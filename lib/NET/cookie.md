# cookie机制

> http本身是无状态的请求，但实际应用中我们需要确定用户身份或者跟踪会话。本文主要讲解cookie的使用方法。

Cookie是由W3C组织提出的客户端的解决方案，它可以弥补HTTP协议无状态的不足，目前已成为标准获得广泛支持。通常是`由服务器发送`给客户端的特殊信息（`种cookie`），以文本的方式`存放在客户端`，然后客户端`每次向服务器发送请求都会带上`这些特殊信息。这些信息`通过http响应头进行传送`，需要浏览器支持。

这个通讯过程可以表示为：

![](https://ws1.sinaimg.cn/large/006tKfTcly1g1ogq28dm3j30b405k0sz.jpg)

## 使用场景

- 保持登录状态
- 记录用户访问次数
- 在Session出现之前，基本上所有的网站都采用Cookie来跟踪会话

### 基础用法

除了name与value之外，Cookie还具有其他几个常用的属性。每个属性对应一个`getter`方法与一个`setter`方法。

key | type | desc
- | - | -
name | String | 该Cookie的名称。Cookie一旦创建，名称便不可更改。
value | Object | 该Cookie的值。如果值为Unicode字符，需要为字符编码。如果值为二进制数据，则需要使用BASE64编码。
maxAge | Int | 该Cookie失效的时间，单位秒。<br/> 如果为正数，则该Cookie在>maxAge秒之后失效。<br/>  如果为负数，该Cookie为临时Cookie，关闭浏览器即失效，浏览器也不会以任何形式保存该Cookie。 <br/> 如果为0，表示删除该Cookie。默认为–1。
path | String | 该Cookie的使用路径。如果设置为`/sessionWeb/`，则只有contextPath为`/sessionWeb`的程序可以访问该Cookie。如果设置为`/`，则本域名下contextPath都可以访问该Cookie。注意最后一个字符必须为`/`。
domain | String | 可以访问该Cookie的域名。如果设置为`.google.com`，则所有以`google.com`结尾的域名都可以访问该Cookie。注意第一个字符必须为`.`。
secure | boolean | 该Cookie是否仅被使用安全协议传输。安全协议。安全协议有HTTPS，SSL等，在网络>上传输数据之前先将数据加密。默认为false。
comment | String | 该Cookie的用处说明。浏览器显示Cookie信息的时候显示该说明。
version | int | 该Cookie使>用的版本号。0表示遵循Netscape的Cookie规范，1表示遵循W3C的RFC 2109规范。

#### 服务器端操作cookie

> 根据使用语言的不同，具体方法上会有差异，此处只做展示。

- 新增

```js
// 新建Cookie
Cookie cookie = new Cookie("time","20190402")   
// 设置域名
cookie.setDomain(".helloweenvsfei.com")         
// 设置路径
cookie.setPath("/")  
// 设置有效期，不设置默认为临时cookie和负值效果一样                           
cookie.setMaxAge(Integer.MAX_VALUE)  
// 输出到客户端           
response.addCookie(cookie)                      
```

node示例

```js
// 原生node
var http = require('http')
http.createServer(function(req,res){
  // 设置cookie
  res.setHeader('Set-Cookie',['name=frank','age=23'])
  res.writeHead(400,{'Content-Type':'text/plain'})
  res.end('Hello World\n')
}).listen(1337,'127.0.0.1')

// koa2
var router = require('koa-router')()
router.get('/', (ctx, next) => {
  // 写
  ctx.cookies.set('age', '23', {
    domain:'0.0.0.0',
  })
  // 读
  ctx.cookies.get('age')
})
```

- 修改

```js
cookie.setMaxAge(xxx)
```

- 删除

```js
cookie.setMaxAge(0)
```

#### 客户端操作cookie

首先需要了解在客户端中cookie的格式：

- 整体是一个 `string`
- 以键值对的形式保存，即`key=value`的格式
- 各个cookie之间一般是以`;`分隔
- 可通过 `document.cookie` 查看

![](https://ws3.sinaimg.cn/large/006tKfTcly1g1pa8p3ws0j31mo03qgnc.jpg)

- 查看：可通过浏览控制台查看（亦可直接更删改）

![](https://ws3.sinaimg.cn/large/006tKfTcly1g1p9fpdb9gj31ni0fkq8t.jpg)

- 通过js操作cookie：JS中并没有直接可用的 `getter`/`setter`，需要自行封装。

```js
var username=document.cookie.split(";")[0].split("=")[1];

// 写cookies
function setCookie(name,value) {
  var Days = 30;
  var exp = new Date();
  exp.setTime(exp.getTime() + Days*24*60*60*1000);
  document.cookie = name + "="+ escape(value) + ";expires=" + exp.toGMTString();
}

// 读cookies
function getCookie(name) {
  var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
  if(arr=document.cookie.match(reg))
    return unescape(arr[2]);
  else
  return null;
}

// 删cookies
function delCookie(name) {
  var exp = new Date();
  exp.setTime(exp.getTime() - 1);
  var cval=getCookie(name);
  if(cval!=null)
  document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}
```

> W3C组织早就意识到JavaScript对Cookie的读写所带来的安全隐患并加以防备了，W3C标准的浏览器会阻止JavaScript读写任何不属于自己网站的Cookie。换句话说，A网站的JavaScript程序读写B网站的Cookie不会有任何结果。

### 跨子域共享

Cookie是不可跨域名的。域名`www.google.com`颁发的Cookie不会被提交到域名`www.baidu.com`去。这是由Cookie的隐私安全机制决定的。隐私安全机制能够禁止网站非法获取其他网站的Cookie。

`test.baidu.com`和`www.baidu.com`的cookie默认也是不能共享的（跨小域），但可以通过设置 `domain`设置实现共享。

```js
// 注意第一个字符必须为 .
cookie.setDomain(".baidu.com")
```

### 跨域使用

如果希望在 A 域设置的域名在 B 域使用，

```js
// A域 设置 domain为 B域
Cookie cookie = new Cookie("time","20190402")   
cookie.setDomain(B域)         
cookie.setPath("/")                           
cookie.setMaxAge(Integer.MAX_VALUE)           
response.addCookie(cookie)
```

## cookie的安全性

HTTP协议不仅是无状态的，而且是不安全的。使用HTTP协议的数据不经过任何加密就直接在网络上传播，有被截获的可能。使用HTTP协议传输很机密的内容是一种隐患。如果不希望Cookie在HTTP等非安全协议中传输，可以设置Cookie的secure属性为true。浏览器只会在HTTPS和SSL等安全协议中传输此类Cookie。下面的代码设置secure属性为true：

```js
Cookie cookie = new Cookie("time", "20190402")
cookie.setSecure(true)  
response.addCookie(cookie)
```

## 参考资料

- [理解Cookie和Session机制](https://www.cnblogs.com/andy-zhou/p/5360107.html)
