# 常用API概览

<!-- toc -->

## 1 指令

> 指令带有前缀 `v-`

### v-bind

- 数据绑定属性

```vue
<div id="app">
  <span v-bind:title="message">
    鼠标悬停几秒钟查看此处动态绑定的提示信息！
  </span>
</div>
```

```js
var app = new Vue({
  el: '#app-2',
  data: {
    message: '页面加载于 ' + new Date().toLocaleString()
  }
})
```

- 简写形式 `:`

```html
<span :title="message"></div>
```

- 绑定 `class` 或 `style` 增强

```vue
<div class="static"
     v-bind:class="{ 'active': isActive, 'text-danger': hasError }">
</div>
```

若data中 `isActive`、`hasError` 为 true，渲染为：

```html
<div class="static active text-danger"></div>
```

更灵活的应用，使用计算值：

```vue
<div v-bind:class="classObject"></div>
```

```js
data: {
  isActive: true,
  error: null
},
computed: {
  classObject: function () {
    return {
      active: this.isActive && !this.error,
      'text-danger': this.error && this.error.type === 'fatal'
    }
  }
}
```

使用数组，多种用法:

```vue
<div v-bind:class="[activeClass, errorClass]"></div>

<div v-bind:class="[isActive ? activeClass : '', errorClass]"></div>

<div v-bind:class="[{ active: isActive }, errorClass]"></div>
```

```js
data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
```

### v-if

- 数据绑定DOM，控制显示隐藏

```vue
<div id="app-3">
  <p v-if="seen">现在你看到我了</p>
</div>
```

```js
var app3 = new Vue({
  el: '#app-3',
  data: {
    seen: true
  }
})
```

- 在 <template> 元素上使用 v-if 条件渲染分组

```vue
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```

> <template> 为不可见的包裹元素，最终的渲染结果不包含 <template> 元素。

### v-else

通常和 v-if 搭配使用

```vue
<h1 v-if="ok">Yes</h1>
<h1 v-else>No</h1>
```

### v-else-if

> 2.10 新增

```vue
<div v-if="type === 'A'">
  A
</div>
<div v-else-if="type === 'B'">
  B
</div>
<div v-else-if="type === 'C'">
  C
</div>
<div v-else>
  Not A/B/C
</div>
```

### v-show

用于根据条件展示元素，用法大致一样

```vue
<h1 v-show="ok">Hello!</h1>
```

> 一般来说，v-if 有更高的切换开销，而 v-show 有更高的初始渲染开销。因此，如果需要非常频繁地切换，则使用 v-show 较好；如果在运行时条件很少改变，则使用 v-if 较好。

> 当 v-if 与 v-for 一起使用时，v-for 具有比 v-if 更高的优先级。


### v-for

绑定DOM，控制循环输出

```vue
<div id="app-4">
  <ol>
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>
```

```js
var app4 = new Vue({
  el: '#app-4',
  data: {
    todos: [
      { text: '学习 JavaScript' },
      { text: '学习 Vue' },
      { text: '整个牛项目' }
    ]
  }
})
```

### v-on

用来为用户交互绑定事件

```vue
<div id="app-5">
  <p>{{ message }}</p>
  <button v-on:click="reverseMessage">逆转消息</button>
</div>
```

```js
var app5 = new Vue({
  el: '#app-5',
  data: {
    message: 'Hello Vue.js!'
  },
  methods: {
    reverseMessage: function () {
      this.message = this.message.split('').reverse().join('')
    }
  }
})
```

> v-on经常使用，缩写形式：

```vue
<button @click="reverseMessage">逆转消息</button>
```

### v-model

实现表单输入和应用状态之间的双向绑定。

```vue
<div id="app-6">
  <p>{{ message }}</p>
  <input v-model="message">
</div>
```

```js
var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
```

### v-once

执行一次性地插值，当数据改变时，插值处的内容不会更新，会影响到该节点上所有的数据绑定：

```vue
<span v-once>这个将不会改变：{{ msg }}</span>
```

### v-html

用于渲染HTML片段。

```vue
<!-- 转化为普通文本 -->
<span>{{ rawHtml }}</span>

<!-- 渲染为HTML -->
<span v-html="rawHtml"></span>
```

## 2 实例属性和方法

> 带有前缀 `$`

### $data

### $el

### $watch

## 3 修饰符

> 以 `.` 指明的特殊后缀

### .prevent

触发的事件调用 `event.preventDefault()`

```vue
<form v-on:submit.prevent="onSubmit">...</form>
```
