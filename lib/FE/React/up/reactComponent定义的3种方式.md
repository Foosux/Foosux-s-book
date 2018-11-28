# reactComponent定义的3种方式

## React.createClass

```js

```

## class

```js

```

## Stateless Functional Component

推荐尽量使用本方式，保持简洁和无状态。这是函数，不是 `Object`，没有 this 作用域，是 pure function。

```js
function App(props) {
  function handleClick() {
    props.dispatch({ type: 'app/create' })
  }
  return <div onClick={handleClick}>${props.name}</div>
}

// 等价于
class App extends React.Component {
  handleClick() {
    this.props.dispatch({ type: 'app/create' });
  }
  render() {
    return <div onClick={this.handleClick.bind(this)}>${this.props.name}</div>
  }
}
```

> react在判断的时候，因为是个纯函数，会直接省略生命周期的部分，从而可以大大的加快加载速度。
