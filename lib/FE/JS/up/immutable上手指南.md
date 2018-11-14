# Immutable快速上手指南

## 是什么？

Facebook工程师Lee Byron花费3年时间打造，与 React 同期出现，但没有被默认放到React工具集里。它内部实现了一套完整的 Persistent Data Structure，还有很多易用的数据类型。像 Collection、List、Map、Set、Record、Seq。有非常全面的map、filter、groupBy、reduce、find函数式操作方法。同时 API 也尽量与 Object 或 Array 类似。

## 特点

Immutable Data 就是一旦创建，就不能再被更改的数据。对 Immutable 对象的任何修改或添加删除操作都会返回一个新的 Immutable 对象。Immutable 实现的原理是 Persistent Data Structure（持久化数据结构）

## 解决什么问题？

JavaScript 中的对象一般是可变的（Mutable），因为使用了引用赋值，新的对象简单的引用了原始对象，改变新的对象将影响到原始对象。

```js
let foo= {a: 1}
bar = foo
bar.a = 2
console.log(foo)  // {a: 2}
```

```js
let { is, fromJS } = require('immutable')

var a = { age: 20, sub: { name: 'Tom'} }
var b = { age: 20, sub: { name: 'Tom'} }

console.log(a===b)  // false
console.log(is(fromJS(a), fromJS(b)))  // false
```

```js
import { is } from 'immutable'

shouldComponentUpdate (nextProps = {}, nextState = {}) => {
  const thisProps = this.props

  for (const key in nextProps) {
    if (!is(thisProps[key], nextProps[key])) {
      return true
    }
  }
}
```

## 优缺点

* Immutable 降低了 Mutable 带来的复杂度
* 节约内存
![](https://ws2.sinaimg.cn/large/006tNbRwly1fwtr9pqxw7j310e0gqqbm.jpg)

* 容易与原生对象混淆
* API文档比较晦涩
* 增加了资源文件大小

## 上手

### 引入

```js
// 安装依赖包
npm i immutable

// 作为统一的对象引入和使用
let Immutable = require('immutable')
Immutable.fromJS()

// 解构方式引入需要的方法函数
let { formJS, Map } = require('immutable')
formJS()
```

### 区分immutable和JS对象

由于两者API近似，在使用过程中容易混淆当前操作的是`immutable`还是`JS对象`

#### 将 JS对象 转换成 Immutable

有两种途径可以完成Immutable对象的转换：

* `fromJS()`

```js
const { fromJS, Map } = require('immutable')

const A1 = fromJS({
  name: 'Tom',
  type: 1
})

console.log(A1)   // Map { "name": "Tom", "type": 1 }
```

> 使用`fromJS`

* 使用 Immutable 类型包装函数

```js
const {
  Map,              // 常用
  List,             // 常用
  Set,
  OrderedMap,
  OrderedSet,
  Stack,
  Range,
  Repeat,
  Record,
  Seq,
  Iterable,
  Collection
} = require('immutable')

const A1 = Map({ name: 'Tom', type: 1 })
const A2 = List([1,2,3,4])

console.log(A1)  // Map { "name": "Tom", "type": 1 }
console.log(A2)  // List [ 1, 2, 3, 4 ]
```

#### 将 Immutable 转换成 JS对象

* 使用 `toJS`

```js
const { Map, List } = require('immutable')

const A1 = Map({ name: 'Tom', type: 1 })
const A2 = List([1,2,3,4])

console.log(A1.toJS())  // { "name": "Tom", "type": 1 }
console.log(A2.toJS())  // [ 1, 2, 3, 4 ]
```

### Immutable API

将一个数据变成 `Immutable`后，可持有对应的方法操作函数，包含以下几类：

* `is` 类 : 比较两个`Immutable`数据是否相等
* `增删改查` 类
* 专有类型的专有方法、属性

特点：

* 成对出现
* 操作后的类型任然是 Immutable（除非进行`toJS`）
* 可以进行链式调用

#### set('sss', 1) 、setIn(['a','b'],)

#### update()、updateIn()

#### get()、getIn()

#### remove()、removeIn()

#### delete(key)、deleteIn()、clear()

#### has()、hasIn()

#### size、setSize()

#### merge()、mergeDeep()、mergeWith()、mergeDeepWith()

merge接收普通的JS对象
