# 常用API概览

<!-- toc -->

## 1 指令

> 指令带有前缀 `v-`

### v-bind

数据绑定属性

```html
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

> v-bind经常使用，缩写形式：

```html
<span :title="message"></div>
```

### v-if

数据绑定DOM，控制显示隐藏

```html
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

### v-for

绑定DOM，控制循环输出

```html
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

```html
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

```html
<button @click="reverseMessage">逆转消息</button>
```

### v-model

实现表单输入和应用状态之间的双向绑定。

```html
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

```html
<span v-once>这个将不会改变：{{ msg }}</span>
```

### v-html

用于渲染HTML片段。

```html
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

```html
<form v-on:submit.prevent="onSubmit">...</form>
```
