# vue简介



## 特点

- 申明式渲染，数据可动态绑定到:

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

> 在控制台改动数据时，页面会时实渲染。

- 数据双向绑定


## 指令

见于 `DOM` 结构中，作为与JS衔接的钩子

- v-bind:
- v-if
- v-for
- v-on
- v-model

## 实例化

```js
var vm = new Vue({
  // 绑定目标DOM
  el: '#app-5',
  // 绑定数据
  data: {
    message: 'Hello Vue.js!'
  },
  // 绑定事件
  methods: {
    reverseMessage: function () {
      ...
    }
  },
  // 生命周期钩子
  created: function () {
    ...
  },
  // 侦听器
  watch: {
    ...
  },
  // 侦听属性
  computed: {
    ...
  }
})
```
