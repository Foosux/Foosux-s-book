# 组件通讯 Bus

> 在 [组件](FE/VUE/base/组件.html#1-父子组件通信) 章节讨论了父子组件之间基本的通讯方式，包含：

- props向下传递,$emit向上传递
- v-model绑定后 $emit('input', {})向上传递
- 父链、子索引直接修改

> 然而在一下情况下，组件间的通讯会变的复杂些：

- 多个视图依赖于同一状态。   
- 来自不同视图的行为需要变更同一状态。  
- 非父子组件的通讯。

## Bus

> 在简单的场景下，可以使用一个空的Vue实例作为中央事件总线。

vue2中废弃了`$dispatch`和`$broadcast`广播和分发事件的方法。可以通过实例一个vue实例Bus作为媒介，要相互通信的兄弟组件之中，都引入Bus，之后通过分别调用Bus事件触发和监听来实现组件之间的通信和参数传递。

- 首先需要在任意地方添加一个bus.js

- 在`bus.js`里面 写入下面信息

```js
import Vue from 'vue'

export default new Vue
```

- 在需要通信的组件都引入`Bus.js`

- 添加一个触发 `$emit` 的事件按钮

```vue
<template>
  <div id="emit">
      <button @click="bus">按钮</button>
  </div>
 </template>

<script>
import Bus from './bus.js'

export default {
  data() {
    return {
      message: ''"
    }
  },
  methods: {
    bus () {
      Bus.$emit('msg', '我要给兄弟组件们传信息了，你收到没有！')
    }
  }
}
</script>
```

- 在另一个组件中使用 `$on` 监听 Bus 发出的事件

```vue
<template>
  <div id="on">
    <p>{{ message }}</p>
  </div>
</template>

import Bus from './bus.js'
export default {
  data() {
    return {
      message:  ''
    }
  },
  mounted() {
    Bus.$on('msg', (e) => {
      this.message = msg
    })
  }
}
```

> 但这种引入方式，经过webpack打包后可能会出现Bus局部作用域的情况，即引用的是两个不同的Bus，导致不能正常通信。可以直接将 Bus 注入到 Vue的根对象中

```js
import Vue from 'vue'
const Bus = new Vue()

var app= new Vue({
    el:'#app',
　　 data:{
　　　　Bus
    }　　
})

// 在子组件中通过this.$root.Bus.$on(),this.$root.Bus.$emit()来调用
```
