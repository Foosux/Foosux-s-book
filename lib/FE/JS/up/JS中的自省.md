# JS中的自省

> JS中判断自身类型的操作，称为`自身`，本文总结了此类操作

<!-- toc -->

## typeof

`typeof`得到的返回值是一个字符串，可用来检测基本类型，符合类型不适用

```js
typeof 'zifuchuan'  // 'string'
typeof true         // 'boolean'
typeof 1            // 'number'
typeof undefined    // 'undefined'
typeof {}           // 'object'
typeof (()=>{})     // 'function'

// 以下情况不适用
typeof null         // 'object'
typeof []           // 'object'

```

## instanceof

##
