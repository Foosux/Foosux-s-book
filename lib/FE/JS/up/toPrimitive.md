# JS中的toPrimitive
<!-- toc -->

`toPrimitive`指的是将一个 `Object对象` 转换为 `原始值`的抽象操作，这个过程会涉及

- `toString`
- `valueOf`
- `[Symbol.toPrimitive]`

三个对象方法的调用，本文重点关注这些方法调用的时机及过程中发生的事情。

## 基础知识

### valueOf和toString的由来

所有对象继承了`Object.prototype`的两个转换方法：

- 第一个是`toString()`，它的作用是获取`对象的字符串值`
- 第二个是`valueOf()`，它的作用是获取对象的原始值

这两个方法都可以被改写，后面会举例。

> `null`、`undefined`和`Object.create()`的对象没有这两个方法。

## [[DefaultValue]](hint)内部操作

![](https://ws2.sinaimg.cn/large/006tKfTcly1g0arh51l60j30k50gg75k.jpg)

对象`object`获取原始值会调用内部操作 `[[DefaultValue]]`，它会根据hint的不同，执行不同的操作，大概过程如下：

![](https://ws3.sinaimg.cn/large/006tKfTcly1g0ar66897lj30wg0tottn.jpg)

> 具体可参考 [ES5 规范 8.12.8 节](https://www.ecma-international.org/ecma-262/5.1/#sec-8.12.8)

## valueOf

有二种情况会用到 `valueOf` 方法：

- 直接调用（比较少）
- `toPrimitive` 中 hint 为 number

> `valueOf` 通常是toPrimitive过程中的第一站，对象在需要转换成原始值时通常会先执行这个方法获取原始值，这常发生在隐式类型转换时，很少需要自己调用`valueOf()`方法。

```js
// 直接调用，返回原始值
'hello'.valueOf()  // 'hello'
(123).valueOf()    // 123
true.valueOf()     // true

// 直接调用，Date返回原始值
(new Date).valueOf()  // 1550558372737
// 直接调用，如果对象没有原始值，将返回对象本身
{age:18}.valueOf()    // {age:18}
(()=>{}).valueOf()    // ()=>{}
[1,2,3,4].valueOf()   // [1,2,3,4]
```

## toString

有三种情况会用到 toString方法：

- 直接调用（比较少）
- `toPrimitive` 中 hint 为 string
- `toPrimitive` 中 hint 为 number，但经过`valueOf`结果仍不是一个简单类型值（string/number/boolean/undefined/null），则会调用`toString`方法返回一个表示该对象的`字符串`。

> 当对象被表示为文本值或者当`以期望字符串的方式`引用对象时,`toString()`被自动调用，一般不需要我们主动调用。

```js
// 直接调用，简单类型其效果相当于类型转换
'hello'.toString()  // 'hello'
(123).toString()    // '123'
true.toString()     // 'true'

// 直接调用，普通对象返回`[object type]`，其中 type 是对象类型
({}).toString()     // '[object Object]'

// 直接调用，重新定义过 toString() 的对象
[1,2,3].toString()      // '1,2,3'
(()=>{}).toString()     // '()=>{}'
(new Error).toString()  // 'Error'
...

// 隐式转换，调用 `toPrimitive`，hint 为 string
`${[1,2,3]}`  // '1,2,3'  [].toString
// 隐式转换，调用 `toPrimitive`，hint 为 number
[1,2,3]+''    // '1,2,3'  [].valueOf().toString()
```

> 除隐式类型转换外，`toString`也常用来精准地判断值类型，具体可参考 [JS中的自省](./自省.md)

## Symbol.toPrimitive

> ES6新增`Symbol.toPrimitive`，优先级最高。

在 `Symbol.toPrimitive` 属性(用作函数值)的帮助下，一个对象可被转换为原始值。该函数由字符串参数 `hint` 调用，目的是指定原始值转换结果的首选类型。`hint参数`可以是`number`、`string` 和 `default` 中的一种。

- 拥有 `Symbol.toPrimitive` 属性的对象

```js
let obj = {
  [Symbol.toPrimitive](hint) {
    if(hint === 'number'){
      console.log('Number场景');
      return 123;
    }
    if(hint === 'string'){
      console.log('String场景');
      return 'str';
    }
    if(hint === 'default'){
      console.log('Default 场景');
      return 'default';
    }
  }
}

console.log(+obj)        // Number场景 123
console.log(2*obj)       // Number场景 246
console.log(3+obj)       // Default场景 3default
console.log(obj+"")      // Default场景 default
console.log(`${obj}`)    // String场景 str
console.log(String(obj)) // String场景 str
```

- `Symbol.toPrimitive` 优先级最高

```js
var test = {
  str: '10',
  val: 100,
  toString() {
    console.log('使用 toString')
    return this.str
  },
  valueOf() {
    console.log('使用 valueOf')
    return this.val
  },
  [Symbol.toPrimitive]() {
    return 2;
  }
}

+test          // 2
Number(test)   // 2
''+test        // '2'
String(test)   // '2'
```

- `Symbol.toPrimitive`返回值必须是简单类型，否则会报 TypeError错误

![](https://ws4.sinaimg.cn/large/006tKfTcly1g0byvhwxkbj30ti02c3yt.jpg)

```js
var test = {
  [Symbol.toPrimitive]() {
    return {age: 18}
  }
}

+test     // Uncaught TypeError
```

## 注意事项

> `undefined`和`null`不具备这些方法

null和undefined没有包装对象，访问它们的属性会造成一个类型错误。

![](https://ws1.sinaimg.cn/large/006tKfTcly1g0aof8nhy8j30q4032t95.jpg)

> JS会根据使用场景来调用`toString()`或`valueOf()`或`Symbol.toPrimitive`

- 如果有`Symbol.toPrimitive`属性时，它的优先级最高，其他两个方法不会执行。
- 在进行`强转字符串类型`时将优先调用`toString`。[查看时机](./类型转换.md)
- 强转为数字时优先调用`valueOf`，非简单值再调用`toString`转成字符串，再对字符串进行一次Number转换。

```js
var test = {
  str: '10',
  val: 100,
  toString: function() {
    return this.str
  },
  valueOf: function() {
    return this.val
  }
}

alert(test)            // '10'   toString
// 在有运算操作符的情况下,valueOf的优先级要高一些
alert(+test)           // 100    valueOf
alert(''+test)         // '100'  valueOf => Object.toString()
alert(test == '100')   // true   valueOf
alert(test === '100')  // false  valueOf
// 显示使用包装函数
alert(String(test))    // 10   toString
alert(Number(test))    // 100  valueOf
alert(Boolean(test))   // true
```

## 参考文章

- [JavaScript强制类型转换](https://www.sohu.com/a/231072835_505779)
