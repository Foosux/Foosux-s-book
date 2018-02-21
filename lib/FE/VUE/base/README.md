# vue简介

> 本章作为vue学习初章，尝试对知识脉络进行梳理，形成树形结构。

> 即方便概览全貌，亦有助于总结性记忆。

![](https://ws2.sinaimg.cn/large/006tNc79ly1foo802hlfgj30kb0jwdi4.jpg)

<!-- toc -->

## 基本概念

- vue.js 是一个用来开发 web 界面的前端库。
- 它也有配套的周边工具。如果把这些东西都算在一起，那么你也可以叫它一个『前端框架』。
- 是一套用于构建用户界面的渐进式框架 __渐进式框架__，Vue 的核心库只关注视图层。
- Vue.js 的核心是一个允许采用简洁的模板语法来声明式地将数据渲染进 DOM 的系统。
- Vue.js通过简单的API提供高效的`数据绑定`和`灵活的组件系统`。

> 作者本尊写的 [vue介绍](https://zhuanlan.zhihu.com/evanyou/20302927)

## 特点

- 轻量级的框架
- 申明式渲染，响应式编程。数据可动态绑定到:

1> `文本`

```html
<span>{{ data }}</span>
```

2> `属性`

```html
<span v-bind:title='data'>
```

3> `DOM结构`

```html
<p v-for="todo in todos">
  {{ todo.text }}
</p>
```

- 支持指令
  - `v-bind:` 简写形式 `:`
  - `v-on:` 简写形式 `@`
  - `v-if`
  - `v-else`
  - `v-else-if`
  - `v-show`
  - `v-for`
  - `v-once`
  - `v-model`
  - `v-html`
- 支持修饰符
  - 事件修饰符
  - 按键修饰符
  - 表单修饰符
- 双向数据绑定
- 组件化开发：模板、逻辑、样式仅内部耦合，更内聚、利于维护。
- 不支持低端浏览器（IE8及以下）

> React 可以通过 `es5-shim` 运行在 IE8

## 和 React 比较

- [vue和React的使用场景和深度有何不同](https://www.zhihu.com/question/31585377)
