# vue代码风格及结构

<!-- toc -->

## 1 简单Demo

最简单的页面结构，完成数据绑定，输出`Hello Vue!`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>helloVue</title>
</head>
<body>
  <!-- DOM -->
  <div id="app">
    {{ message }}
  </div>

  <!-- 引入vue -->
  <script src="https://cdn.jsdelivr.net/npm/vue@2.5.13/dist/vue.js"></script>

  <!-- 实例化，完成数据绑定 -->
  <script>
    var app = new Vue({
      el: '#app',
      data: {
        message: 'Hello Vue!'
      }
    })
  </script>

</body>
</html>
```

### 实例化概览

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
  // 侦听属性，计算值
  computed: {
    ...
  },
  // 局部注册组件
  components: {
    ...
  }
})
```

上面Demo存在一些问题：

> 全局定义 (Global definitions) 强制要求每个 component 中的命名不得重复

> 字符串模板 (String templates) 缺乏语法高亮，在 HTML 有多行的时候，需要用到丑陋的 `\`

> 不支持 CSS (No CSS support) 意味着当 HTML 和 JavaScript 组件化时，CSS 明显被遗漏

> 没有构建步骤 (No build step) 限制只能使用 HTML 和 ES5 JavaScript, 而不能使用预处理器，如 Pug (formerly Jade) 和 Babel

## 2 实战进阶Demo

推荐使用 `webpack + vue-loader` 的`单文件组件`格式。单个模块放在一个`.vue文件`里，包含 `<template>` `<script>` `<style>` 三部分。

> `.vue文件` 是用户用 HTML-like 的语法编写的 Vue 组件。

```js
<template>
  <div id="app">
    <my-header :transparent="isTransparent"></my-header>
    <div class="app-body">
      <div class="app-content">
        <bread-crumb />
        <router-view></router-view>
      </div>
    </div>
    <my-footer></my-footer>
  </div>
</template>

<script>
import MyHeader from '@/components/Header'
import MyFooter from '@/components/Footer'
import BreadCrumb from '@/components/BreadCrumb'

export default {
  name: 'app',
  components: {
    MyHeader,
    MyFooter,
    BreadCrumb
  },
  computed: {
    isTransparent: function () {
      return this.$route.path === '/' ? true : false;
    }
  }
}
</script>

<style lang="scss" scoped>
  /* 使用sass作为预编译语言 */
  ...
</style>
```
