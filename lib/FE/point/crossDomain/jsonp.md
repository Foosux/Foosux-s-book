# JSONP

> `jsonp`(JSON with Padding)，是JSON的一种“使用模式”，可用于解决主流浏览器的跨域数据访问的问题

## 实现原理

- `src`不受通源策略限制，远程JS文件加载后会立即执行
- JS天然支持`json`数据，可直接作为`object`使用

基于以上两点，我们可以实现跨域数据获取，这种使用模式即`JSONP`

```js
// 1.client中定义函数方法
<script>
function jsonpCallBack (data) {
  // 将我们想要跨域获取的数据作为 参数传入
  console.log(data)    // 拿到数据后 doSometing
}

// 2.动态加载 script
const ele = document.createElement('script')
ele.src = 'http://0.0.0.0:8888/somePath?callback=jsonpCallBack&id=1998'
document.body.appendChild(ele)

// 3.server中接收到src的请求，返回一个用 callback包裹的json (以KOA为例)
router.get('/somePath', async (ctx, next) => {
  let params =  ctx.request.query
  ctx.response.body = `${params.callback}({
    price: 19999,
    tickets: 10
  })`
})
```

## TIPS

> 1.为何jsonp只支持 `get` 请求？

当我们正常地请求一个JSON数据的时候，服务端返回的是一串 JSON类型的数据，而我们使用 JSONP模式来请求数据的时候服务端返回的是一段可执行的 JavaScript代码。因为jsonp 跨域的原理就是用的动态加载 script的src ，所以我们只能把参数通过 url的方式传递, 所以jsonp的 type类型只能是`get`

> 2.JSONP和AJAX的差异？

- `ajax`的核心是通过 `XmlHttpRequest` 获取非本页内容。
- `jsonp`的核心则是动态添加 `<script>标签` 来调用服务器提供的js脚本。

## 实例

[上手实例，加深印象](https://github.com/Foosux/jsonpTest)
