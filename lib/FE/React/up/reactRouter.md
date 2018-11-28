# react-router@4.0
<!-- toc -->

React Router 4.0 （以下简称 RR4） 已经正式发布，它遵循React的设计理念，即万物皆组件。所以 RR4 只是一堆 提供了导航功能的组件（还有若干对象和方法），具有声明式（声明式编程简单来讲就是你只需要关心做什么，而无需关心如何去做，好比你写 React 组件，只需要 render 出你想要的组件，至于组件是如何实现的是 React 要处理的事情。），可组合性的特点。

```js
import {
  // 3类顶层容器，使用一个即可，除 Redirect/Prompt 其它组件必须包裹其中
  BrowserRouter,  // browser路由容器
  HashRouter,     // hash路由容器
  Router,         // 兼容老写法，建议使用上面两个代替

  Switch,         
  Redirect,       
  Route,          
  Link,
  NavLink,
  Prompt
} from 'react-router-dom'
```

## 简述

RR4 本次采用单代码仓库模型架构（monorepo），这意味者这个仓库里面有若干相互独立的包，分别是：

* `react-router` React Router 核心
* `react-router-dom` 用于 DOM 绑定的 React Router
* `react-router-native` 用于 React Native 的 React Router
* `react-router-redux` React Router 和 Redux 的集成
* `react-router-config` 静态路由配置的小助手

> react-router 还是 react-router-dom？

`react-router` 和 `react-router-dom` 只需要引用一个，后者比前者多出 <Link> <BrowserRouter> 这样的组件，因此通常项目中只需要引用 `react-router-dom` 即可，如果搭配使用 `redux` ，还需要使用 `react-router-redux`。

以下讨论的是 `react-router-dom` 组件：

## `<BrowserRouter>`

一个使用了 HTML5 history API 的高阶路由组件，保证你的 UI 界面和 URL 保持同步。此组件拥有以下属性：

### basename

作用：为所有位置添加一个基准URL
使用场景：假如你需要把页面部署到服务器的二级目录，你可以使用 basename 设置到此目录。

```js
<BrowserRouter basename="/foosux" />

// 最终渲染为 <a href="/foosux/react">
<Link to="/react" />
```

### getUserConfirmation

作用：导航到此页面前执行的函数，默认使用 window.confirm
使用场景：当需要用户进入页面前执行什么操作时可用，不过一般用到的不多。

```js
const getConfirmation = (message, callback) => {
  window.confirm(message)
  callback()
}

<BrowserRouter getUserConfirmation={getConfirmation('Are you sure?', ()=> alert("before render, i can do something!"))} />
```

### forceRefresh

作用：当浏览器不支持 HTML5 的 history API 时强制刷新页面。
使用场景：同上。

```js
const supportsHistory = 'pushState' in window.history

<BrowserRouter forceRefresh={!supportsHistory} />
```

### keyLength

作用：设置它里面路由的 location.key 的长度，默认是6。（key的作用：点击同一个链接时，每次该路由下的 location.key都会改变，可以通过 key 的变化来刷新页面。）
使用场景：按需设置。

```js
<BrowserRouter keyLength={12} />
```

## ~~`<HashRouter>`~~

Hash history 不支持 location.key 和 location.state。另外由于该技术只是用来支持旧版浏览器，因此更推荐大家使用 BrowserRouter，此API不再作多余介绍。

## `<Switch>`

> Switch必须包含在 `<BrowserRouter>` 或 `<HashRouter>` 或  `<Router>` 之中

只渲染出第一个与当前访问地址匹配的 `<Route>` 或 `<Redirect>`

```js
<Switch>
  // 用了 Switch 这里每次只匹配一个路由
  <Route path='/' exact {...}/>   // 层级高的路由需要做精准匹配
  <Route />
  <Redirect />
</Switch>
```

> `<Switch> `下的子节点只能是 `<Route>` 或 `<Redirect>` 元素。   
> 只有与当前访问地址匹配的第一个子节点才会被渲染。   
> `<Route>` 元素用它们的 path 属性匹配   
> `<Redirect>` 元素使用它们的 from 属性匹配。如果没有对应的 path 或 from，那么它们将匹配任何当前访问地址。

### `<Redirect>`

Redirect渲染时将导航到一个新地址，这个新地址覆盖在访问历史信息里面的本该访问的那个地址。

### to
重定向的 URL

```js
<Redirect to={{
  pathname: '/first',
  search: '?sort=name',
  state: { price: 18 }
  }}
/>
```

### push
若为真，重定向操作将会把新地址加入到访问历史记录里面，并且无法回退到前面的页面。

### from
需要匹配的将要被重定向路径。

## ~~`<Router>`~~
可用 `<BrowserRouter>` 或 `<HashRouter>` 代替。

## `<Route>`

<Route> 是 RR4 中最重要的组件，它最基本的职责就是当页面的访问地址与 Route 上的 path 匹配时，就渲染出对应的 UI 界面。

`<Route>` 自带三个 `render method` 和三个 `默认 props`:

### render method
> 每种 render method 都有不同的应用场景，同一个<Route> 应该只使用一种 render method：，大部分情况下你将使用 component

#### `<Route component>`

只有当访问地址和路由匹配时，一个 React `component` 才会被渲染，此时此组件接受 route props (match, location, history)。

```js
import Home form 'pages/Home'

<Route path="/home" component={Home} />
```

> 额外的，当路由容器层想要获取Props，可以这么写：

```js
<Route path="/home" component={(props) => <>} />
```

当使用 `component` 时，router 将使用 React.createElement 根据给定的 component 创建一个新的 React 元素。这意味着如果你使用`内联函数`（inline function）传值给 `component` 将会产生不必要的重复装载。

```js
// 内联渲染，使用component会产生重复装载
<Route path="/home" component={() => <h1>Home</h1} />
```

#### `<Route render>`

此方法适用于内联渲染，而且不会产生上文说的重复装载问题。

```js
// 内联渲染
<Route path="/home" component={() => <h1>Home</h1} />

// 改进
<Route path="/home" render={() => <h1>Home</h1} />
```

#### `<Route children>`

### Route 默认props

> 所有的 render method 都将被传入这些 props，无需再次的申明。

#### match
match 对象包含了 <Route path> 如何与 URL 匹配的信息，具体属性如下：

* params: object 路径参数，通过解析 URL 中的动态部分获得键值对
* isExact: bool 为 true 时，整个 URL 都需要匹配
* path: string 用来匹配的路径模式，用于创建嵌套的 <Route>
* url: string URL 匹配的部分，用于嵌套的 <Link>

在以下情境中可以获取 match 对象

* 在 Route component 中，以 `this.props.match`获取
* 在 Route render 中，以 `({match}) => ()` 方式获取
* 在 Route children 中，以 `({match}) => ()` 方式获取
* 在 withRouter 中，以 `this.props.match`的方式获取
* matchPath 的返回值

> 当一个 Route 没有 path 时，它会匹配一切路径。

#### location
location 是指你当前的位置，将要去的位置，或是之前所在的位置

> location 对象不会发生改变，因此可以在生命周期的回调函数中使用 location 对象来查看当前页面的访问地址是否发生改变。这种技巧在获取远程数据以及使用动画时非常有用

#### history

histoty 是 RR4 的两大重要依赖之一（另一个是 React 了），在不同的 javascript 环境中，history 以多种能够行驶实现了对会话（session）历史的管理。history 对象通常具有以下属性和方法：

* length: number 浏览历史堆栈中的条目数
* action: string 路由跳转到当前页面执行的动作，分为 PUSH, REPLACE, POP
* location: object 当前访问地址信息组成的对象，具有如下属性：
* pathname: string URL路径
* search: string URL中的查询字符串
* hash: string URL的 hash 片段
* state: string 例如执行 push(path, state) 操作时，location 的 state 将被提供到堆栈信息里，state 只有在 browser 和 memory history 有效。
* push(path, [state]) 在历史堆栈信息里加入一个新条目。
* replace(path, [state]) 在历史堆栈信息里替换掉当前的条目
* go(n) 将 history 堆栈中的指针向前移动 n。
* goBack() 等同于 go(-1)
* goForward 等同于 go(1)
* block(prompt) 阻止跳转

### 其他 props

#### path && exact && strict

```js
// path
<Route path="/home" render={() => <h1>Home</h1} />

// exact 精确匹配
<Route path="/home" exact render={() => <h1>Home</h1} />

// 对路径末尾斜杠的匹配
<Route path="/home" strict render={() => <h1>Home</h1} />
```

> 如果要确保路由没有末尾斜杠，那么 strict 和
exact 都必须同时为 true

> 在之前的版本中，在 Route 中写入的 path，在路由匹配时是独一无二的，而 v4 版本则有了一个包含的关系：如匹配 path="/users" 的路由会匹配 path="/"的路由，在页面中这两个模块会同时进行渲染。因此，v4中多了 exact 关键词，表示只对当前的路由进行匹配。

> 如果想要只匹配一个路由，除了 exact 属性之外，还可以使用 Swtich 组件。

## `<Link>`

为应用提供声明式，无障碍导航。

### to
作用：跳转到指定路径

```js
<Link to="/courses" />

// 携带参数
<Link to={{
  pathname: '/course',
  search: '?sort=name',
  state: { price: 18 }
}} />
```

### replace

作用：为 true 时，点击链接后将使用新地址替换掉上一次访问的地址。
应用场景：回退时需要跳过某些页的场景

```js
<Link to="/courses" replace />

// 没有replace时依次访问： '/one'=>'/two'=>'/three'=>’/four'
// 回退顺序是：   '/one'<='/two'<='/three'<=

// 假设  '/one'=>'/two'=>'/three'(含replace)=>’/four'
// 回退顺序是：   '/one'<='/three'<=
```

## `<NavLink>`

Link的特殊版，顾名思义这就是为页面导航准备的。因为导航需要有 “激活状态”。

### activeClassName && activeStyle

```js
<NavLink
  to="/about"
  // 导航激活状态样式
  activeClassName="selected"
  // 如果不想使用样式名就直接写style
  activeStyle={{ color: 'green', fontWeight: 'bold' }}
>MyBlog</NavLink>
```

### path && exact && strict
和Link类似

## `<Prompt>`

当用户离开当前页面前做出一些提示。（可在任何页面使用）

```js
// 始终提示
<Prompt message="确定要离开？" />

// 通过条件判断
<Prompt when={this.state.xxx} message="确定要离开？" />
```

> 使用 RR4体系跳转时才有效果，浏览器默认回退、前进时无效。 so，有点鸡肋（摊手）

## 参考文章

![初探 React Router 4.0](https://www.jianshu.com/p/e3adc9b5f75c)
![All About React Router4](https://css-tricks.com/react-router-4/)
![React Router 4：痛过之后的豁然开朗](https://www.jianshu.com/p/bf6b45ce5bcc)
