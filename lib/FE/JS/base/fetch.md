# fetch

> fetch 是 XMLHTMLRequest的一种替代方案

<!-- toc -->

XMLHttpRequest 是一个设计粗糙的 API，不符合关注分离（Separation of Concerns）的原则，配置和调用方式非常混乱，而且基于事件的异步模型写起来也没有现代的 Promise，generator/yield，async/await 友好。

## 基本用法

- get请求

```js
fetch('/test/content.json').then(function(data){
    return data.json()
}).then(function(data){
    console.log(data)
}).catch(function(error){
    console.log(error)
})
```

- post请求

```js
// url: fetch事实标准中可以通过Request相关api进行设置
fetch('/test/content.json', {
  method: 'POST',
  // same-origin | no-cors（默认）| cors
  mode: 'same-origin',      
  // omit（默认，不带cookie）| same-origin(同源带cookie) | include(总是带cookie)
  credentials: 'include',
  // headers: fetch事实标准中可以通过Header相关api进行设置   
  headers: {
    // default: 'application/json'              
    'Content-Type': 'application/x-www-form-urlencoded'
  },
  // body: fetch事实标准中可以通过Body相关api进行设置
  body: 'a=1&b=2'
  // res: fetch事实标准中可以通过Response相关api进行设置
}).then(function(res){
    return res.json()
}).then(function(data){
    console.log(data)
}).catch(function(error){

})
```

## Response API

fetch的`response`比较特殊，如果`console.log(response)`会返回一个对象：

```js
{
  body: ReadableStream,  // 请求的资源都存储在body中，作为一种可读的流    
  bodyUsed: false,
  headers: Headers,
  ok: true,
  redirected: false,
  status: 200,
  statusText: "OK",
  type: "cors"
  url: "http://some-website.com/some-url"
  __proto__ : Response
}
```

可以看出Fetch返回的响应能告知请求的状态。

### 格式化数据

fetch请求的资源都存储在body中，作为一种可读的流。所以需要调用一个恰当方法将可读流转换为我们可以使用的数据。

```js
fetch('/test/content.json').then(function(data){
  // 返回Text类型的数据的Promise对象（处理如：xml）
  return data.text()
  // 返回JSON类型的数据的Promise对象
  return data.json()
  // 返回FormData类型的数据的Promise对象
  return data.formData()
  // 返回Blob类型的数据的Promise对象（处理图片）
  return data.blob()
  // 返回ArrayBuffer类型的数据的Promise对象
  return data.arrayBuffer()
})
```

###

#### bodyUsed

- 标记返回值是否被使用过
- 这样设计的目的是为了之后兼容基于流的API，让应用一次消费data，这样就允许了JavaScript处理大文件例如视频，并且可以支持实时压缩和编辑。

```js
fetch('/test/content.json').then(function(res){
    console.log(res.bodyUsed)   // false
    var data = res.json()
    console.log(res.bodyUsed)   //true
    return data
})
```

#### headers

有时候我们需要通过判断响应头来决定内容的格式，返回的`headers`对象实现了 Iterator，可通过for...of遍历。

> headers.get()

> headers.has()

> headers.getAll()

```js
fetch('/test/content.json').then(function(res){
  var headers = res.headers
  if(headers.get('content-type').includes('application/json')) {
    return res.json()
  } else if (headers.get('content-type').includes('text/html')) {
    return res.text()
  }

  console.log(headers.get('Content-Type')) // application/json
  console.log(headers.has('Content-Type')) // true
  console.log(headers.getAll('Content-Type')) // ["application/json"]
  for(let key of headers.keys()){
      console.log(key) // datelast-modified server accept-ranges etag content-length content-type
  }
  for(let value of headers.values()){
      console.log(value)
  }
  headers.forEach(function(value, key, arr){
      console.log(value)    // 对应values()的返回值
      console.log(key)      // 对应keys()的返回值
  });
  return res.json()
})
```

#### ok

fetch不关心AJAX是否成功，他只关心向服务器发出请求和接收响应，如果响应失败我们需要抛出异常，因此初始`then`方法需要做一些处理，最简单的方法是检查 `reponse.ok` 是否为 true。

```js
fetch('some-url')
  .then(response => {
    if (response.ok) {
      return response.json()
    } else {
      throw new Error('some wrong')
      // or
      return Promise.reject('some wrong')
    }
  })
```

#### status & statusText

只输出字符串不太好，这样不清楚哪里出错了。我们可以用 `status`和`statusText`做一些改良：

```js
fetch('some-url')
  .then(response => {
    if (response.ok) {
      return response.json()
    } else {
      return Promise.reject({
        status: response.status,
        statusText: response.statusText
      })
    }
  })
  .catch(error => {
    if (error.status === 404) {
      // do something about 404
    }
  })
```

#### url

返回完整的 url。

```js
fetch('some-url').then(r => {
  // 输出 http://域名/some-url
  console.log(r.url)
})
```

#### type

> response.type 会返回以下值：

- `basic`：正常的，同域的请求，包含所有的headers。排除Set-Cookie和Set-Cookie2。
- `cors`：Response从一个合法的跨域请求获得，一部分header和body可读。
- `error`：网络错误。Response的status是0，Headers是空的并且不可写。当Response是从Response.error()中得到时，就是这种类型。
- `opaque`： Response从"no-cors"请求了跨域资源。依靠Server端来做限制。

### clone()

- 生成一个Response的克隆
- body只能被读取一次，但clone方法就可以得到body的一个备份
- 克隆体仍然具有bodyUsed属性，如果被使用过一次，依然会失效

```js
fetch('/test/content.json').then(function(data){
    var d = data.clone()
    d.text().then(function(text){
        console.log(JSON.parse(text))
    });
    return data.json()
}).then(function(data){
    console.log(data)
}).catch(function(error){
    console.log(error)
})
```

## 缺点

- 没有直接设置请求超时的方法（可通过 promise.race+setTimeOut 来实现）
- 无法监控读取进度
- 无法中断请求

## 兼容性

目前项目中对Promise的兼容性尚存在问题，如果在项目中应用fetch，需要引入`es6-promise`和`fetch`。

![](https://segmentfault.com/image?src=https://cloud.githubusercontent.com/assets/948896/10188421/c6e19fc8-6791-11e5-8ac2-bfede76df6b4.png&objectId=1190000003810652&token=21f555d76bde525897cbb7b183350941)

原生支持率并不高，幸运的是，引入下面这些 polyfill 后可以完美支持 IE8+ ：

- 由于 IE8 是 ES3，需要引入 ES5 的 polyfill: es5-shim, es5-sham
- 引入 Promise 的 polyfill: es6-promise
- 引入 fetch 探测库：fetch-detector
- 引入 fetch 的 polyfill: fetch-ie8
- 可选：如果你还使用了 jsonp，引入 fetch-jsonp
- 可选：开启 Babel 的 runtime 模式，现在就使用 async/await

## 注意事项

- Fetch 请求默认是不带 cookie 的，需要设置 fetch(url, {credentials: 'include'})
- 服务器返回 400，500 错误码时并不会 reject，只有网络错误这些导致请求不能完成时，fetch 才会被 reject。
