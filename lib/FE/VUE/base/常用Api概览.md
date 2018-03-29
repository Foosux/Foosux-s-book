# 常用API概览

<!-- toc -->

## 1 指令

> 指令带有前缀 `v-`

### v-bind

- 数据绑定到属性

> 双括号的数据绑定形式不能作用于属性，所以有了 v-bind

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

> v-bind经常使用，所以有了简写的语法糖 `:`

```html
<span :title="message"></div>
```

- 绑定 `class` 或 `style` 增强

> 绑定class和style的逻辑可能会相对复杂，所以有了特殊的`对象语法`、`数组语法`来方便理解和维护。

`对象语法`

```vue
<div
  class="static"
  :class="{ 'active': isActive, 'text-danger': hasError }">
</div>
```

若data中 `isActive`、`hasError` 为 true，渲染为：

```html
<div class="static active text-danger"></div>
```

`数组语法`

```vue
<div :class="[activeClass, errorClass]"></div>

<div :class="[isActive ? activeClass : '', errorClass]"></div>

<div :class="[{ active: isActive }, errorClass]"></div>
```

```js
data: {
  activeClass: 'active',
  errorClass: 'text-danger'
}
```

> 注意：数组语法中可以嵌套使用对象语法，如：

> :class="[{ active: isActive }, errorClass]"

- 如果逻辑进一步复杂，建议使用计算值：

```vue
<div :class="classObject"></div>
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

- 组件中把一个对象的所有属性当成props进行传递。（不带参数）

> 直接绑定属性仅作用于组件的根元素，已经存在的类不会被覆盖。

```html
todo: {
  text: 'Learn Vue',
  isComplete: false
}

<todo-item v-bind="todo"></todo-item>
```

- 2.3.0 以后style绑定可以使用`多重值`，常用于提供多个带前缀的值。

> 通常使用`:style`时，Vue.js 会自动侦测并添加相应的前缀

```vue
<div :style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }"></div>
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

绑定DOM，控制循环输出列表类结构。

- 实例: 使用数组数据

```vue
<div id="app-4">
  <ol>
    <!-- 亦可用 of 代替 in -->
    <li v-for="todo in todos">
      {{ todo.text }}
    </li>
  </ol>
</div>

<!-- 使用第二个参数，作为索引 -->
<li v-for="(item, index) in items">
  {{ index }} - {{ item.message }}
</li>
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

- 另一个实例：使用单个对象作为数据

```vue
<li v-for="value in object">
  {{ value }}
</li>

<!-- 使用第二个参数 -->
<li v-for="(value, key) in object">
  {{ key }}: {{ value }}
</li>

<!-- 使用第三个参数，作为索引 -->
<li v-for="(value, key, index) in object">
  {{ index }}. {{ key }}: {{ value }}
</li>
```

```js
var app = new Vue({
  el: '#app',
  data: {
    object: {
      firstName: 'John',
      lastName: 'Doe',
      age: 30
    }
  }
})
```

- 一段取值范围

```vue
<span v-for="n in 10">{{ n }}</span>
```

> 建议尽可能在使用 v-for 时提供 `key`，除非遍历输出的 DOM 内容非常简单，或者是刻意依赖默认行为以获取性能上的提升。

> 当它们处于同一节点，v-for 的优先级比 v-if 更高，这意味着 v-if 将分别重复运行于每个 v-for 循环中。   

> 2.2.0+ 的版本里，当在组件中使用 v-for 时，key 现在是必须的。

### v-on:

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

> 带有前缀 `$`，通常在组件挂在后，才能使用实例方法和属性。

### $data

返回当前组件当前的 data

### $el

返回当前组件的 dom 节点

### $watch

观察一个值的变化，观察的这个值一变化的话，那么就执行function里面的语句

```js
var vm = new Vue({
   el: '#watch',
   data: {
      firstName: 'a',
      lastName: 'fei',
      fullName: 'a fei'
    },
    watch: {
      firstName: function (val) {
        this.fullName = val + ' ' + this.lastName
      },
      lastName: function (val) {
        this.fullName = this.firstName + ' ' + val
      }
    }
  })
```

### $set

全局 `Vue.set` 的别名，作用一致

```vue
Vue.set(vm.xx, 'age', 27)

vm.$set(vm.xx, 'age', 27)
```

### $on(eventName)

为实例监听事件

### $emit(eventName)

为实例触发事件

### $root

子组件访问根组件，如果当前实例没有父实例，此实例将会是其自已。

### $parent

父链，子组件访问父组件使用。

### $children

子索引，返回所有子组件的实例，是一个数组。

### $ref

有时候组件过多的话，就很记清各个组件的顺序与位置，所以通过给子组件一个索引ID，可以访问单个子组件。

## 3 修饰符

> 以 `.` 指明的特殊后缀

### .prevent

触发的事件调用 `event.preventDefault()`

```vue
<form v-on:submit.prevent="onSubmit">...</form>
```
