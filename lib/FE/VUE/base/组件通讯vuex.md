# 组件通讯 vuex

> 在 [组件](FE/VUE/base/组件.html#1-父子组件通信) 章节讨论了父子组件之间基本的通讯方式，包含：

- props向下传递,$emit向上传递
- v-model绑定后 $emit('input', {})向上传递
- 父链、子索引直接修改

> 然而在一下情况下，组件间的通讯会变的复杂些：

- 多个视图依赖于同一状态。   
- 来自不同视图的行为需要变更同一状态。  
- 非父子组件的通讯。

## vuex

> 如果您需要构建是一个中大型单页应用，您很可能会考虑如何更好地在组件外部管理状态，Vuex 将会成为自然而然的选择。

Vuex 是一个专为 Vue.js 应用程序开发的`状态管理模式`。它采用集中式存储管理应用的所有组件的状态，并以相应的规则保证状态以一种可预测的方式发生变化。

把组件的共享状态抽取出来，以一个全局单例模式管理。在这种模式下，我们的组件树构成了一个巨大的“视图”，不管在树的哪个位置，任何组件都能获取状态或者触发行为！


### 引入安装

```js
// 安装vuex
npm i vuex --save

// 引入项目中
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)
```

### 创建 store

> Vuex 通过 store 选项，提供了一种机制将状态从根组件“注入”到每一个子组件中（需调用 Vue.use(Vuex)）

```js

const store = new Vuex.Store({
  // 启用严格模式（不要在发布环境下启用严格模式！）
  strict: true,
  // 定义 值
  state: {
    count: 0
  },
  // 定义 commit 方法
  mutations: {
    // commit 的 type, payload 用来传递参数
    increment (state, payload) {
      state.count = payload.count
    }
  },
  // 定义获取值时的特殊操作
  getters: {
    doneTodos: state => {
      return state.todos.filter(todo => todo.done)
    }
  },
  // 处理异步操作
  actions: {
    incrementAsync (context) {
      setTimeout(() => {
        context.commit('increment')
      }, 1000)
    }，
    // 解构语法(对象说明符)
    incrementAsync ({ commit }) {
      setTimeout(() => {
        commit('increment')
      }, 1000)
    }
  },
  // 分割成多个模块
  modules: {
    a: moduleA,
    b: moduleB
  }
})

new Vue({
  el: '#root',
  router,
  // 把 store 对象提供给 “store” 选项，这可以把 store 的实例注入所有的子组件
  store,
  template: '<App/>',
  components: { App }
})
```

通过在根实例中注册 store 选项，该 store 实例会注入到根组件下的所有子组件中，且子组件能通过 `this.$store` 访问到。

### 获取 state

子组件通过 `this.$store` 来获取状态对象，并放入 `computed` 中。

```js
const Counter = {
  template: `<div>{{ count }}</div>`,
  computed: {
    count () {
      return this.$store.state.count
    }
  }
}
```

#### mapState 辅助函数

当一个组件需要获取多个状态时候，将这些状态都声明为计算属性会有些重复和冗余。为了解决这个问题，我们可以使用 mapState 辅助函数帮助我们生成计算属性：

```js
import { mapState } from 'vuex'

export default {
  // ...
  computed: mapState({
    // 箭头函数可使代码更简练
    count: state => state.count,

    // 传字符串参数 'count' 等同于 `state => state.count`
    countAlias: 'count',

    // 为了能够使用 `this` 获取局部状态，必须使用常规函数
    countPlusLocalState (state) {
      return state.count + this.localCount
    }
  })
}
```

当映射的计算属性的名称与 state 的子节点名称相同时，我们也可以给 mapState 传一个字符串数组。

```js
computed: mapState([
  // 映射 this.count 为 store.state.count
  'count'
])
```

### 触发状态变更

> 不能直接改变 store 中的状态。改变 store 中的状态的唯一途径就是显式地提交 (commit) mutation，异步逻辑都应该封装到 action 里面。

#### mutation

通过 `this.$store.commit` 方法触发状态变更。


```js
// 常规风格
this.$store.commit('increment', { count: 100 })

// 对象风格
this.$store.commit({
  type: 'increment',
  count: 10
})
```

> 一条重要的原则就是要记住 mutation 必须是同步函数

#### action

`Action` 通过 `store.dispatc` 方法触发，用于处理异步操作。

```js
this.$store.dispatch('increment')
```

### 将store分割成多个模块

Vuex 允许我们将 store 分割成模块（module）。每个模块拥有自己的 state、mutation、action、getter、甚至是嵌套子模块——从上至下进行同样方式的分割：

```js
const moduleA = {
  state: { ... },
  mutations: { ... },
  actions: { ... },
  getters: { ... }
}

const moduleB = {
  state: { ... },
  mutations: { ... },
  actions: { ... }
}

const store = new Vuex.Store({
  modules: {
    a: moduleA,
    b: moduleB
  }
})

```

### 项目结构

Vuex 并不限制你的代码结构。但是，它规定了一些需要遵守的规则：

- 应用层级的状态应该集中到单个 store 对象中。
- 提交 mutation 是更改状态的唯一方法，并且这个过程是同步的。
- 异步逻辑都应该封装到 action 里面。

```bash
├── index.html
├── main.js
├── api
│   └── ... # 抽取出API请求
├── components
│   ├── App.vue
│   └── ...
└── store
    ├── index.js          # 我们组装模块并导出 store 的地方
    ├── actions.js        # 根级别的 action
    ├── mutations.js      # 根级别的 mutation
    └── modules
        ├── cart.js       # 购物车模块
        └── products.js   # 产品模块
```
