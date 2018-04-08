# http-proxy-middleware

> 在前后端分离开发的背景下，存在`请求数据跨域`的问题，`http-proxy`可作为一种解决方案，在解决跨域问题的基础上实现`mock服务`，提供便利的开发环境。

> `http-proxy-middleware` 可以使用所有的`http-proxy`选项，以及一些额外的选项。

<!-- toc -->

## 基本用法

### 规则

#### proxy([context,] config)

```js
var proxy = require('http-proxy-middleware')

var apiProxy = proxy('/api', {target: 'http://www.example.org'})
//                   \____/   \_____________________________/
//                     |                    |
//                   context             options
// 'apiProxy' is now ready to be used as middleware in a server.
```

> context：确定应将哪些请求代理到目标主机。 （更多关于上下文匹配）

> options.target：目标主机到代理。 （协议+主机）

**关于`context` 的配置**

`context`字段决定了哪些请求被代码，可以提供一个匹配规则进行自定义。

```js
// RFC 3986路径用于上下文匹配
foo://example.com:8042/over/there?name=ferret#nose
\_/   \______________/\_________/ \_________/ \__/
 |           |            |            |        |
scheme     authority       path        query   fragment
```

- 路径匹配
  - `proxy({...}) `- 匹配任意路径，所有的请求都会被代理。
  - `proxy('/', {...})` - 匹配任意路径，所有的请求都会被代理。
  - `proxy('/api', {...})` - 匹配所有以/api开始的路径。
- 多重路径匹配
  - `proxy(['/api', '/ajax', '/someotherpath'], {...})`
- 通配符路径匹配
  - `proxy('**', {...})`  匹配任意路径，所有的请求都会被代理。
  - `proxy('**/*.html', {...})`  匹配所有以.html结尾的任意路径。
  - `proxy('/*.html', {...})`  直接匹配绝对路径下的路径。
  - `proxy('/api/**/*.html', {...})`  匹配在/api路径下以.html结尾的请求。
  - `proxy(['/api/**', '/ajax/**'], {...})`  组合多重路由模式。
  - `proxy(['/api/**', '!**/bad.json'], {...})`  排除匹配。

#### proxy(uri [, config])

```js
var proxy = proxy('http://www.example.org/api', {changeOrigin:true})
```

### 实践

- 当不需要详细配置时，通常使用 `uri` 的方式。

```js
// 引入
var proxy = require('http-proxy-middleware')
var express = require('express')

// uri匹配方式，省略 target
var proxy = proxy('http://www.example.org:8000/api')
// uri匹配方式，省略 target，带配置项
var proxy = proxy('http://www.example.org:8000/api', {changeOrigin:true})

var app = express()
// 简写方式
app.use(proxy)
// 另一种写法 app.use(path, proxy)
app.use('/api', proxy({target:'http://www.example.org', changeOrigin:true}))

app.listen(3000)
```

- 需要对匹配项进行灵活控制时，建议使用 `context` 方式。（示例：结合 webpack 中的 `devServer` 使用）

```js
// 引入
var proxy = require('http-proxy-middleware')

devServer:{
  port: 8888,
  contentBase: path.join(__dirname, "dist"),
  // 此处开启代理
  proxy: {
    // context 匹配方式
    '/api': {
      target: 'http://www.example.org:8000/api',
      changeOrigin: false
    }
  }
},

```

## http-proxy-middleware configAPI

## http-proxy configAPI

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
