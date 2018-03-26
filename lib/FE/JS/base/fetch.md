# fetch

> fetch 是 XMLHTMLRequest的一种替代方案

XMLHttpRequest 是一个设计粗糙的 API，不符合关注分离（Separation of Concerns）的原则，配置和调用方式非常混乱，而且基于事件的异步模型写起来也没有现代的 Promise，generator/yield，async/await 友好。

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
