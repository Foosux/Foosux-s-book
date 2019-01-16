# URL encoding
<!-- toc -->

> `URL encoding`是Uniform Resource Identifier(URI)规范文档中对特殊字符编码制定的规则。本质是把一个字符转为`%`加上UTF-8编码对应的16进制数字。故又称之为`Percent-encoding`。

使用UTF-8对 非ASCII字符进行编码，然后再进行百分号编码，这是RFC推荐的。

现在URL转义表示法比较常用的有两个网络标准：
* [RFC 2396 - Uniform Resource Identifiers (URI): Generic Syntax](https://tools.ietf.org/html/rfc2396)
* [RFC 3986 - Uniform Resource Identifier (URI): Generic Syntax](https://tools.ietf.org/html/rfc3986)


不同的编程语言对于URL的转义有差异。

* Java中的URLEncoder是按照 `RFC2398` 转义
* PHP5中的rawurlencode是按照`RFC3986`转义
* `RFC5987` ???
* JS中遵循 `RFC3986`

> RFC3986 保留了 `!`、`'`、`(`、`)`、`*`
`! * ' ( ) ; : @ & = + $ , / ? # [ ]`

> 对于非ASCII字符，需要使用ASCII字符集的超集进行编码得到相应的字节，然后对每个字节执行百分号编码。
> 对于Unicode字 符，RFC文档建议使用utf-8对其进行编码得到相应的字节，然后对每个字节执行百分号编码。

## 为何需要 url encoding

一般来说，URL只能使用英文字母、阿拉伯数字和某些标点符号，不能使用其他文字和符号。
这是因为网络标准 [RFC 1738](https://www.ietf.org/rfc/rfc1738.txt) 做了硬性规定：

> ...Only alphanumerics [0-9a-zA-Z], the special characters "$-_.+!*'()," [not including the quotes - ed], and reserved characters used for their reserved purposes may be used unencoded within a URL.

> 只有字母和数字[0-9a-zA-Z]、一些特殊符号"$-_.+!*'(),"[不包括双引号]、以及某些保留字，才可以不经过编码直接用于URL。

这意味着，如果URL中有汉字，就必须编码后使用。但是麻烦的是，RFC 1738没有规定具体的编码方法，而是交给应用程序（浏览器）自己决定。这导致"URL编码"成为了一个混乱的领域。

URL有一些基本的特性：

* URL是可移植的。（所有的网络协议都可以使用URL）
* URL的完整性。（不能丢失数据，比如URL中包含二进制数据时，如何处理）
* URL的可阅读性。（希望人能阅读）

因为一些历史的原因URL设计者使用US-ASCII字符集表示URL。（原因比如ASCII比较简单；所有的系统都支持ASCII）

为了满足URL的以上特性，设计者就将转义序列移植了进去，来实现通过ASCII字符集的有限子集对任意字符或数据进行编码。

## 哪些字符需要编码

```js
foo://example.com:8042/over/there?name=ferret#nose
  \_/ \______________/ \________/\_________/ \__/
   |         |              |         |        |
  scheme   authority       path     query   fragment
```


## URL encoding的原则

- 谁生产Url，谁负责encode规则。原则上只encode查询参数的value部分，查询参数的key以及path避免特殊字符。
- encode仅一次，decode仅一次。
- 保留字符必须encode
- 非保留字符不能encode
- 其它字符强烈建议encode

## JS中的编码方法

* URL元字符：分号`;`，逗号`’,’`，斜杠`/`，问号`?`，冒号`:`，at`@`，&，等号`=`，加号`+`，美元符号`$`，井号`#`
* 语义字符：a-z，A-Z，0-9，连词号`-`，下划线`_`，点`.`，感叹号`!`，波浪线`~`，星号`*`，单引号`\`，圆括号`()`


- escape（69个）（已经被W3C废弃）：*/@+-._0-9a-zA-Z
- encodeURI（82个）：!#$&'()*+,/:;=?@-._~0-9a-zA-Z
- encodeURIComponent（71个）：!'()*-._~0-9a-zA-Z
### encodeURI & decodeURI

它会将`元字符`和`语义字符`之外的字符，都进行转义，通常用来处理整个URL。

### encodeURIComponent & decodeURIComponent

只转除了语义字符之外的字符，元字符也会被转义。通常用来处理一个URL中的值或片段。

#### 问题

> 对于 `application/x-www-form-urlencoded` (POST) 这种数据方式，空格需要被替换成 '+'，所以通常使用 encodeURIComponent 的时候还会把 "%20" 替换为 "+"

原因：

* 按照 RFC3986 ，空格编码后是 %20 [查看](https://tools.ietf.org/html/rfc3986#section-2.1)

> For example, "%20" is the percent-encoding for the binary octet "00100000" (ABNF: %x20), which in US-ASCII corresponds to the space character (SP).

* 但按照 HTML 标准，application/x-www-form-urlencoded 对空格的处理是这样的

> If the byte is 0x20 (U+0020 SPACE if interpreted as ASCII)   
> Replace the byte with a single 0x2B byte (U+002B PLUS SIGN character (+) if interpreted as ASCII).


```js
let name = '&time=  2019.1.15'
encodeURIComponent(name).replace(/%20/g,"+") // "%26time%3D++2019.1.15"
```

> 为了更严格的遵循 RFC 3986，即使`!`、`'`、`(`、`)`、`*`并没有正式划定 URI 的用途，下面这种方式是比较安全的：

```js
function fixedEncodeURIComponent (str) {
  return encodeURIComponent(str).replace(/[!'()*]/g, function(c) {
    return '%' + c.charCodeAt(0).toString(16);
  });
}
```

## 参考资料

- [ASCII，Unicode 和 UTF-8](http://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)
- [关于URL编码](http://www.ruanyifeng.com/blog/2010/02/url_encoding.html)
- [MDN-encodeURIComponent](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent)
- [Web开发须知：URL编码与解码](https://www.cnblogs.com/liuhongfeng/p/5006341.html )
