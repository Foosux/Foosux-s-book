# 前后端数据交互

> 目前前后端的通信主要通过`HTTP协议`来完成，过程中提交数据的格式有哪些？又会碰到哪些问题？

<!-- toc -->

## 前端视角

### 常见方式

#### Get-数据放在URL中

在URL`?`后增加参数，以键值对的形式分割。

```js
http://foosux.com?wd=test&ucid=100091
```

#### Post-不同的编码方案

- `application/x-www-form-urlencoded`

```js
// 请求头
'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8'

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

- `multipart/form-data`

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

使用表单上传文件时，必须让 `<form>` 表单的 `enctyped` 等于 `multipart/form-data`。它将会把窗体数据被编码为一条消息，页上的每个控件对应消息中的一个部分。浏览器会把整个表单以控件为单位分割，并为每个部分加上Content-Disposition(form-data或者file)、Content-Type(默认为text/plain)、name(控件name)等信息，并加上分割符(boundary)。

> 上面提到的这两种 POST 数据的方式，都是浏览器原生支持的，而且现阶段标准中原生 `<form>` 表单也只支持这两种方式。

> 随着越来越多的 Web 站点，尤其是 WebApp，全部使用 Ajax 进行数据交互之后，我们完全可以定义新的数据提交方式，给开发带来更多便利。

- `application/json`

```js
// 请求首部中的字段设置
'Content-type': 'application/json; charset=utf-8'
```

**使用JSON格式提交的优势？**

- JSON格式支持比键值对复杂得多的结构化数据
- 各大抓包、调试工具如：Chrome自带的开发者工具、Firebug、Fiddler，都会以树形结构展示 JSON 数据，非常友好。
- 除了低版本 IE 之外的各大浏览器都原生支持 JSON.stringify，服务端语言也都有处理 JSON 的函数，使用JSON不会遇上什么麻烦。

> Google的AngularJS中的Ajax功能，默认就是提交JSON字符串。

- `text/xml`

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

### 不同技术方案中的AJAX请求

- VUE
  - axios
  - vue-resource
- React
  - fetch polyfill

## Form表单交互

- headers
  - 'X-Requested-With': 'XMLHttpRequest'
