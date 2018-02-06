# vue基础结构

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

## 2 实战Demo

单个模块放在一个JS里，包含 `<template>` `<script>` `<style>` 三部分。

```vue
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

<style lang="scss">
  /* 使用sass作为预编译语言 */
  ...
</style>
```
