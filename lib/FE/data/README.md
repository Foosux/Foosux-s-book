# 前后端数据交互

> 目前 前后端的通信 主要通过`HTTP协议`来完成，此篇总结了前端请求数据的各种形式及需要注意的问题。

<!-- toc -->

## 常见方式

在前端开发中，常见的获取数据、资源的方式如下：

- 非Ajax请求
  - Get-url（包含直接的url请求、各类资源标签src）
  - 原生表单提交
- Ajax请求
  - 原生ajax（XML）
  - 各类ajax库
  - fetch

> 比较 `form提交` 和 `Ajax提交`

**提交方式**

原生表单`form`提交时：通过 `method` 来设置请求方式，通过 `enctype` 来设置编码类型（仅支持设置这一个请求头信息），包含：

- application/x-www-form-urlencoded (POST默认)
- multipart/form-data （含上传文件功能时必选）
- text/plain  (纯文本传输，发送邮件时需要，很少使用)

最后通过 `Submit` 来提交（可使用表单提交，亦可通过onclick事件JS提交）。

Ajax的编码类型通过设置请求头`Content-Type`来实现，额外支持 `application/json` 的提交方式，不支持 `multipart/form-data`(可用FormData类型代替)，支持自定义各种请求头，最后基于`XMLHttpRequest`进行提交。

**页面刷新**

Form提交，更新数据完成后，需要跳转到一个空白页面再对原页面进行提交后处理。哪怕是提交给自己本身的页面，也是需要刷新的，因此局限性很大。

Ajax实现页面的局部刷新，整个页面不会刷新。

**请求由谁来提交？**

Form提交是浏览器完成的，无论浏览器是否开启JS，都可以提交表单。

Ajax是通过js来提交请求，请求与响应均由js引擎来处理，因此不启用JS的浏览器，无法完成该操作。

**是否可上传文件**

最初，ajax出于安全性考虑，不能对文件进行操作，所以就不能通过ajax来实现文件上传，但是通过隐藏form提交则可以实现这个功能，所以这也是用隐藏form提交的主要用途。

后来`XMLHttpRequest`引入了`FormData`类型，使得通过Ajax也可以实现文件上传。

### Get-url

Get请求不涉及编码方式的问题，表现形式上也比较简单：在URL`?`后增加参数，以键值对的形式分割。

```js
http://foosux.com/api/test?wd=test&ucid=100091

<img src="http://foosux.com/xx.png" />
<link src="http://foosux.com/css/index.css?v=1232131" />
<script src="http://foosux.com/js/index.js"></script>
```

> 请求方式为 `GET` 时，设置 `enctype` 和 `content-Type` 无效。

### Post-不同的编码方案

#### `application/x-www-form-urlencoded`

```js
// Form 默认提交方式
<form action='xxx/xxx' method='post'>
</form>
// AJAX 则需要设置请求头
'Content-type': 'application/x-www-form-urlencoded'

// 数据格式（key-value键值对，通过 & 连接，中文转码）
title=test&sub%5B%5D=1&sub%5B%5D=2&sub%5B%5D=3
```

这应该是最常见的`POST`提交数据的方式了。浏览器的原生`<form>`表单，如果不设置 `enctype` 属性，那么最终就会以 `application/x-www-form-urlencoded` 方式提交数据。

> 大部分服务端语言都对这种方式有很好的支持，后端可以直接用 `$_POST` 拿到数据。

> 很多时候，我们使用`Ajax`提交数据时，也是使用这种方式，例如：Jquery.Ajax 等。

> 非原生表单提交时，前端可使用`qs`将数据转换成该格式：

```js
import qs from 'qs'
{
  ...,
  params: qs.stringify(params)
}
```

**使用 application/x-www-form-urlencoded 存在的问题？**

> key/value的语言表达形式没有json强。value是复杂对象的情况更加糟糕，一般只能通过程序来序列化得到参数，想手写基本不可能。   
> 对前端也不算友好(没有现成的解析、拼装方法)。      
> value要进行编码，编码之后的对调试者不友好。   

#### `multipart/form-data`

```js
// 请求头
'Content-Type': 'multipart/form-data; boundary=----WebKitFormBoundaryrGKCBY7qhFd3TrwA'

// 请求体
------WebKitFormBoundaryrGKCBY7qhFd3TrwA
Content-Disposition: form-data; name="text"

// html
<form enctyped="multipart/form-data">
  <input type="file" />
</form>
```

使用表单上传文件时，必须让 `<form>` 表单的 `enctyped` 等于 `multipart/form-data`。它将会把窗体数据被编码为一条消息，页上的每个控件对应消息中的一个部分。浏览器会把整个表单以控件为单位分割，并为每个部分加上`Content-Disposition`(form-data或者file)、Content-Type(默认为text/plain)、name(控件name)等信息，并加上分割符(boundary)。

> 上面提到的这两种 POST 数据的方式，都是浏览器原生支持的，而且现阶段标准中原生 `<form>` 表单也只支持这两种方式。

> 随着越来越多的 Web 站点，尤其是 WebApp，全部使用 Ajax 进行数据交互之后，我们完全可以定义新的数据提交方式，给开发带来更多便利。

#### `text/plain`

- 在发送邮件时要设置这种编码类型，否则会出现接收时编码混乱的问题
- 纯文本传输，不对特殊字符编码，只会将空格转换为`+`

#### `application/json`

```js
// 请求首部中的字段设置
'Content-type': 'application/json; charset=utf-8'
```

**使用JSON格式提交的优势？**

- JSON格式支持比键值对复杂得多的结构化数据。
- 使用 `require body` 提交数据相对 get 安全一些，亦解决了长度限制的问题。
- 各大抓包、调试工具如：Chrome自带的开发者工具、Firebug、Fiddler，都会以树形结构展示 JSON 数据，非常友好。
- 除了低版本 IE 之外的各大浏览器都原生支持 JSON.stringify，服务端语言也都有处理 JSON 的函数，使用JSON不会遇上什么麻烦。

> Google的AngularJS中的Ajax功能，默认就是提交JSON字符串。

#### `text/xml`

XML在数据传输方面相对 JSON 而言没有任何优势，此处仅作简单介绍。

```xml
<!-- 请求头 -->
'Content-Type': 'text/xml'

<?xml version="1.0"?>
<methodCall>
  <methodName>examples.getStateName</methodName>
    <params>
      <param>
        <value><i4>41</i4></value>
      </param>
    </params>
</methodCall>
```
`XML-RPC协议`是一种使用`HTTP`作为传输协议，`XML`作为编码方式的远程调用规范。它简单、功能够用，各种语言的实现都有，如 WordPress 的 XML-RPC Api，搜索引擎的 ping 服务等等。

## 发送Ajax请求

- `原生Ajax` （[详细介绍](/FE/JS/base/ajax.html)）
- `Jquery.Ajax`
- 各类Ajax库，如：`axios`
- `fetch polyfill`（[详细介绍](/FE/JS/base/fetch.html)）
