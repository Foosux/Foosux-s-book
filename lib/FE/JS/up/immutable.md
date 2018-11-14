# immutable简易上手指南

* 是什么？
* 解决什么问题？
* 怎么用？
* 注意事项？

## 基础概念

Facebook 工程师 Lee Byron 花费 3 年时间打造，与 React 同期出现，但没有被默认放到 React 工具集里（React 提供了简化的 Helper）。它内部实现了一套完整的 Persistent Data Structure，还有很多易用的数据类型。像 Collection、List、Map、Set、Record、Seq。有非常全面的map、filter、groupBy、reduce、find函数式操作方法。同时 API 也尽量与 Object 或 Array 类似。

> 是什么？

Immutable数据就是一旦创建，就不能更改的数据。每当对Immutable对象进行修改的时候，就会返回一个新的Immutable对象，以此来保证数据的不可变。

> 解决什么问题？好处？

好处：

* 降低mutable带来的复杂度
* 节省内存空间

> 缺点？难点？

* 官方文档有点晦涩难懂

> 如何用？API？

> 注意事项

### 常用API

Immutable用的最多就是List和Map，所以在这里主要介绍这两种数据类型的API。

## fromJS() & toJS()

作用：JS和Immutable数据互换。

```js
let Immutable = require('immutable')
// let { fromJS } = require('immutable')

let obj = {
  name: 'zq',
  age: 18
}

let immObj = Immutable.fromJS(obj)
let reObj = immObj.toJS()

console.log(immObj, reObj)
```

## set() & get()

## setIn() & getIn()

## update() & updateIn()

## remove() & removeIn()

## merge()

不影响原值，生成新值。

```js
const { merge } = require('immutable')

const A = { x: 123, y: 456 }
merge(A, { y: 789, z: 'abc' }) // { x: 123, y: 789, z: 'abc' }
console.log(A) // { x: 123, y: 456 }

// react中
const { fromJS } = require('immutable')
const original = fromJS({ x: 123, y: 456 })
const o2 = original.merge({ y: 789, z: 'abc' }) // { x: 123, y: 789, z: 'abc' }
console.log(o2.toJS(), original.toJS()) // { x: 123, y: 456 }
```

## mergeDeep()

## mergeDeepWith()
