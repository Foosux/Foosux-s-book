# http-proxy-middleware

> 在前后端分离开发的背景下，存在`请求数据跨域`的问题，`http-proxy`可作为一种解决方案，在解决跨域问题的基础上实现`mock服务`，提供便利的开发环境。

> `http-proxy-middleware` 可以使用所有的`http-proxy`选项，以及一些额外的选项。

<!-- toc -->

## 基本用法

### 规则

- proxy([context,] config)

```js
var proxy = require('http-proxy-middleware')

var apiProxy = proxy('/api', {target: 'http://www.example.org'})
//                   \____/   \_____________________________/
//                     |                    |
//                   context             options
```

> context：确定应将哪些请求代理到目标主机。 （更多关于上下文匹配）

> options.target：目标主机到代理。 （协议+主机）

- proxy(uri [, config])

```js
var proxy = proxy('http://www.example.org/api', {changeOrigin:true})
```

### 使用

- 当不需要详细配置时，请使用简写语法

```js
// 引入
var proxy = require('http-proxy-middleware')
var express = require('express')

// 省略 target
var proxy = proxy('http://www.example.org:8000/api')
// 省略 target 带配置项
var proxy = proxy('http://www.example.org:8000/api', {changeOrigin:true})


var app = express()
// 简写方式
app.use(proxy)
// 另一种写法 app.use(path, proxy)
app.use('/api', proxy({target:'http://www.example.org', changeOrigin:true}))

app.listen(3000)
```

- 结合 webpack 中的 `devServer` 使用。

```js
// 引入
var proxy = require('http-proxy-middleware')

devServer:{
  port: 8888,
  contentBase: path.join(__dirname, "dist"),
  // 此处开启代理
  proxy: {
    '/api': {
      target: 'http://www.example.org:8000/api',
      changeOrigin: false
    }
  }
},

```


## config API

### option.target

### option.headers

### option.forward

### option.ssl

### option.ws

### option.xfwd

### option.secure

### option.toProxy

### option.prependPath

### option.ignorePath

### option.localAddress

### option.changeOrigin

### option.proxyTimeout

### option.cookieDomainRewrite

### option.protocolRewrite

### option.autoRewrite

### option.hostRewrite

### option.auth
