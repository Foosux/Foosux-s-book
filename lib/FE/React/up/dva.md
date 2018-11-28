# dva
<!-- toc -->

在编写 redux 这部分代码的时候需要频繁在 actions 、 constants 、 reducers 这几个目录间切换。

dva简化了redux的使用（只需要一个`model`就可以完成所有操作），并且在封装了 redux-saga 和 react-router，同时还可以包含`dva-loading插件`获取 loading 状态等。

## app

出现在入口文件 `../src/index.js`，完成`dva`基础全局设置。

```js
import dva from 'dva';
const app = dva({
  history,         // 路由，默认为 hashHistory
  initialState,    // 默认state，优先级高于 `model 中的 state`
  onError,         // 以 on 开头的均为钩子函数
  onAction,
  onStateChange,
  onReducer,
  onEffect,
  onHmr,
  extraReducers,
  extraEnhancers,
});
```

> 如果想要使用 browserHistory，需要安装 history，然后在 ./src/index.js 引入使用   

常用的history有三种形式：
* "browser history" - history 在 DOM 上的实现，用于支持 HTML5 history API 的浏览器
* "hash history" - history 在 DOM 上的实现，用于旧版浏览器。
* "memory history" - history 在内存上的实现，用于测试或非 DOM 环境（例如 React Native）。

```js
import dva from 'dva'
import createHistory from 'history/createBrowserHistory'
// import { browserHistory } from 'dva/router'

const app = dva({
  history: createHistory(),
  // history: browserHistory,
})
```

### 创建步骤

```js
// 1. Initialize
const app = dva()

// 2. Plugins
app.use({})

// 3. Model
app.model(require('./models/example').default)

// 4. Router
app.router(require('./router').default)

// 5. Start
app.start('#root')
```

## Model

对`redux`、`react-redux`、`redux-saga`的封装。用来接收发送的`action`。

```js
import { fetchUsers } from '../services/user';

export default {
  namespace: 'user',      // 命名空间，也是全局 state 上的一个属性
  state: {                // 初始值
    list: [],
  },
  // 是唯一可以修改 state 的地方，由 action 触发，它有 state 和 action 两个参数。
  reducers: {             // 类似redux中的reducer
    actionType(state, action) {
      return {
        ...state,
        list: action.data,
      };
    },
  },
  // 用于处理异步操作，不能直接修改 state，由 action 触发，也可触发 action
  // 它只能是 generator 函数，并且有 action 和 effects 两个参数
  // 第二个参数 effects 包含 put、call 和 select 三个字段
  // put 用于触发 action
  // call 用于调用异步处理逻辑
  // select 用于从 state 中获取数据。
  // take 获取发送的数据
  effects: {
    *fetch(action, { put, call }) {
      const result = yield call(fetch, '/todos')
      const todos = yield select(state => state.todos)
      const users = yield put(fetchUsers, action.data)
      yield put({ type: 'actionType', data: users })
    },
  },
  // 订阅 某些数据源，并根据情况 dispatch 某些 action
  subscriptions: {      
    setup({ dispatch, history }) {
      return history.listen(({ pathname }) => {
        if (pathname === '/user') {
          dispatch({ type: 'fetch' });
        }
      });
    },
  },
}
```

如上的一个 model，监听路由变化，当进入 /user 页面时，执行 effects 中的 fetch，以从服务端获取用户列表，然后 fetch 中触发 reducers 中的 save 将从服务端获取到的数据保存到 state 中。

## connect

通常用于page级页面 `../src/route/xxx/index.js` 接入redux。

当写完 model 和组件后，需要将 model 和组件连接起来。dva 提供了 `connect` 方法，其实它就是 react-redux 的 connect。

```js
import React from 'react'
import { connect } from 'dva'

const User = ({ dispatch, user }) => {
  // dispatch 是根据你里面设置的type内容，然后转发到指定的model
  // 在组件中触发 action 时就需要带上命名空间
  dispatch({ type: 'user/actionType' }, data: {})
  console.log(user)

  return (
    <div></div>
  )
}

export default connect(({ user }) => {
  return user
})(User)
```

## router

## proxy

## mock

## dva-hmr

## dva-loading
