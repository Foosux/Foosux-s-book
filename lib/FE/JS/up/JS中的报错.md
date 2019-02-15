# JS中的报错

## 编译报错

## 运行时报错

### Error实例对象

Error实例对象的三个属性

- message 错误提示信息
- name 错误名称
- stack 错误的堆栈

### 6种错误类型

- `SyntaxError` 语法错误

- `TypeError` 类型错误

- `RangeError` 范围错误

- `ReferenceError` 引用错误

- `EvalError` eval错误

- `URIError` URL错误

## 资源加载错误

以下标签加载资源出错时会报错，可以用 `onerror` 监听

- `<img>`
- `<input type="image">`
- `<object>`
- `<script>`
- `<style>`
- `<audio>`
- `<video>`

```js
// 资源加载错误不会冒泡, 只能在事件流捕获阶段获取错误
window.addEventListener('error', handleError, true)

function handleError(e) {
  ...
}
```

### 捕获跨域资源加载错误栈

当加载跨域资源时, 无法直接捕获错误信息栈，需要在元素上添加 `crossorigin`, 同时服务器需要在`response header`中, 设置`Access-Control-Allow-Origin` 为 `*` 或 `允许的域名`

```js
<script src="xxx" crossorigin></script>
```
