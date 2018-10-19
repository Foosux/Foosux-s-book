# immutable

* 增
* 删
  *
* 改
  *
* 查


## fromJS() & toJS()

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
