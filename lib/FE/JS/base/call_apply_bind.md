# call、apply、bind

## 基础概念

```js
// call 语法
fn.call(this, arg1, arg2)

// apply 语法
fn.call(this, [arg1, arg2])

// bind 语法
fn.bind(this, arg1, arg2)
```

> `call` 和 `apply` 实现的功能是相同的，只是传参的方式不同。他们可以显式的指定`this`（普通函数调用是隐式传入 this）

> apply 是 call 的语法糖，call的性能好一些，一些基础工具库的内部实现都会尽可能使用`call`

> 在Javascript中，多次 bind() 是无效的

> bind是返回对应函数，便于稍后调用；apply 、call 则是立即调用

## 使用场景

我们通常使用的函数有两种：

- 作为某个对象的方法调用 （this指向调用对象）
- 作为独立的函数调用 （通常内部不使用this）

这时候确实没有任何使用 `apply` 的必要，那么何时使用 `call`/`apply` ?

### 借用其它对象的方法

- 类数组借用数组方法

```js
function A() {
  return Array.prototype.slice.call(arguments, 1, 3)
}

A(1,2,3,4)   // [2,3]
```

`arguments`是一个类数组（array-like）自身没有 `slice` 方法，这里使用 `call` 借用Array的方法。

> Javascript中存在一种名为`类数组`的对象结构，有`length`属性但不能使用Array的原型方法，包括：`arguments`、通过类似 document.childNodes 返回的 `NodeList`对象。

> `类数组` 通过 `Array.prototype.slice.call` 可转化为标准数组

- 获取数组中的最大值

```js
var  numbers = [5, 458 , 120 , -215 ]
var maxInNumbers = Math.max.apply(Math, numbers)   //458
```

数组本身没有`max`方法，但`Math`有，所以可以利用 apply 数组传参的方式借用一下。

- 验证是否数组

```js
functionisArray(obj){
    return Object.prototype.toString.call(obj) === '[object Array]' ;
}
```

### 声明了一个带有`this`的函数，根据传入不同的对象可能做一点不一样的操作

- 一个实例

```js
function changeStyle(attr, value){
    this.style[attr] = value
}
var box = document.getElementById('box')
changeStyle.call(box, "height", "200px")
```

- 继承实例方法

```js
function say() {  
  this.sayName = function(){  
    alert(this.name)  
  }  
}
say.prototype.sayProto = () => {console.log('Prototype fn')}  

function Student(name){  
  this.name = name  
  // 通过 call 继承 say 中的实例方法
  say.call(this)  
}  
var xiaoming = new Student("xiaoming")  
xiaoming.sayName()  
// 不能继承到原型链上的方法
xiaoming.sayProto()   // TypeError
```
