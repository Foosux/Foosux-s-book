# object内部方法及proxy
<!-- toc -->

ES委员会为对象定义了一个由14种方法组成的集合，它是适用于所有对象的通用接口，你可以调用、删除或覆写普通方法，但是无法操作`内部方法`。下面让我们来看一下这14个方法，`[[]]`代表内部方法，在一般代码中不可见。

## 概览

对应对象内建的14个方法，handler也有14个方法可以覆盖，下面我们将会一一讲解。

Internal Method |	Handler Method
- | -
[[GetPrototypeOf]] |getPrototypeOf
[[SetPrototypeOf]] |setPrototypeOf
[[IsExtensible]] |isExtensible
[[PreventExtensions]] |preventExtensions
[[GetOwnProperty]] |getOwnPropertyDescriptor
[[HasProperty]] |has
[[Get]] |get
[[Set]] |set
[[Delete]] |deleteProperty
[[DefineOwnProperty]] |defineProperty
[[Enumerate]] |enumerate
[[OwnPropertyKeys]] |ownKeys
[[Call]] |apply
[[Construct]] |construct

### [[GetPrototypeOf]] ()

获取对象的原型时调用，在执行`obj[__proto__]`或`Object.getPrototypeOf(obj)`时调用

```js
var p = new Proxy(target, {
  getPrototypeOf(target) {

  }
});
```

### [[SetPrototypeOf]] (V)

设置一个对象的原型时调用，在执行`obj.prototype=otherObj`或则`Object.SetPrototypeOf(v)`的时候调用

```js
var p = new Proxy(target, {
  setPrototypeOf: function(target, prototype) {

  }
});
```

### [[IsExtensible]] ()

获取对象的可扩展性时调用，执行`Object.isExtensible(object)`时被调用

```js
var p = new Proxy(target, {
  isExtensible: function(target) {

  }
});
```
### [[PreventExtensions]] ()

扩展一个不可扩展的对象时调用

```js
var p = new Proxy(target, {
  preventExtensions: function(target) {

  }
});
```

### [[GetOwnProperty]] (P)

获取自有属性时调用

```js
var p = new Proxy(target, {
  getOwnPropertyDescriptor: function(target, prop) {

  }
});
```

### [[HasProperty]] (P)

检测对象是否存在某个属性时调用，如 `key in obj`

```js
var p = new Proxy(target, {
  has: function(target, prop) {

  }
});
```

### [[Get]] (P, Receiver)

获取属性时调用，如`obj.key` 或 `obj[key]`

```js
var p = new Proxy(target, {
  get: function(target, property, receiver) {

  }
});
```

### [[Set]] (P, V, Receiver)

为对象的属性赋值时调用，如`obj.key=value`或`obj[key]=value`

```js
var p = new Proxy(target, {
  set: function(target, property, value, receiver) {

  }
});
```

### [[Delete]] (P)

删除某个属性时调用

```js
var p = new Proxy(target, {
  deleteProperty: function(target, property) {

  }
});
```

### [[DefineOwnProperty]] (P, Desc)

定义自有属性时调用

```js
var p = new Proxy(target, {
  defineProperty: function(target, property, descriptor) {

  }
});
```

### [[Enumerate]] ()

列举对象的可枚举属性时调用，如`for (var key in obj)`

```js
var p = new Proxy(target, {
  enumerate: function() {

  }
});
```

### [[OwnPropertyKeys]] ()

列举对象的自有属性时调用

```js
var p = new Proxy(target, {
  ownKeys: function(target) {

  }
});
```

### [[Call]] (thisValue, arguments)

调用一个函数时被调用，`functionObj()`或者`x.method()`

```js
var p = new Proxy(target, {
  apply: function(target, thisArg, argumentsList) {

  }
});
```

### [[Construct]] (arguments, newTarget)

使用new操作的时候调用，如`new Date()`

```js
var p = new Proxy(target, {
  construct: function(target, argumentsList, newTarget) {

  }
});
```

## 小结

在整个 ES6 标准中，只要有可能，任何语法或对象相关的内建函数都是基于这14种内部方法构建的 。但是我们不必记住这些对象的内建属性，我们更应关注是handler与之相对应的方法。

## 参考文档

- [Proxy Object Internal Methods and Internal Slots](http://www.ecma-international.org/ecma-262/6.0/#sec-proxy-object-internal-methods-and-internal-slots)
