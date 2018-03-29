# vue路由

> VUE路由解决方案，通常使用 `vue-router`

<!-- toc -->

## 接入路由

- 根据config配置文件 创建 router

```js
import Vue from 'vue'
import Router from 'vue-router'
import { platRoutes as routes } from './config'

Vue.use(Router)
export default new Router({ routes })
```

- config文件格式

```js
const routes = [
  {
    path: '/',
    name: '首页',
    component: Home,
    hideInSidebar: true,
    redirect: '/mediaList'
  },
  {
    name: '媒体管理',
    icon: 'media',
    level: 1,
    children: [
      {
        path: '/mediaList',
        name: '媒体列表',
        component: MediaList,
        level: 2
      }
    ]
  },
  {
    path: '*',
    name: '404',
    component: NotFound,
    hideInSidebar: true
  }
]

function getPlatRoute(routes){
  var newRoute = [];
  routes.forEach(route => {
    if(route.component) {
      newRoute.push(route);
    }
    if(route.children) {
      const childRoutes = getPlatRoute(route.children);
      newRoute.push(...childRoutes);
    }
  });
  return newRoute;
}
const platRoutes = getPlatRoute(routes);

export {
  platRoutes,
  routes
}
```

- 使用

```js
import router from './router'

new Vue({
  el: '#root',
  router,               // 注入
  template: '<App/>',
  components: { App }
})
```

## 路由跳转

### vue组件式跳转

```html
<router-link :to="{
  name:'list',
  params: { id: 123 ,id2: 456},
  query: { queryId:  789 }}"
>
  router-link 跳转至list
</router-link>
```

### 编程式导航跳转

```js
// 拼接模式
this.$router.push({path: '/list/123/456?queryId=789'})

// 参数模式
this.$router.push({
  name:'router1',      // config里定义的 name
  params: { id: 123, id2: 456 },
  query: { queryId:  789 }
})
```

## 参数的传递

### params方式

```js
// 这里的id叫做 params
/router1/:id   
```

params一旦设置在路由，params就是路由的一部分，如果这个路由有params传参，但是在跳转的时候没有传这个参数，会导致跳转失败或者页面会没有内容。

```vue
<router-link :to="{ name:'router1',params: { id: status}}" >正确</router-link>
<router-link :to="{ name:'router1',params: { id2: status}}">错误</router-link>
```

> 参数名必须一致

- 接收参数

获取路由上面的参数，用的是 `$route`，后面没有 `r`。


### query方式

```js
// 这里的id叫做 query
/router1?id=123  
```

params是路由的一部分,必须要有。query是拼接在url后面的参数，没有也没关系。
