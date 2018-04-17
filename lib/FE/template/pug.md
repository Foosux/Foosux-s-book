# 基础

> `pug`即`jade`，是一种常用的`视图引擎`

## 安装

```js
npm i pug
```

## 基本用法

### 插值

- 属性中插值

```js
// 新版本
a(href=link)
// (在 Node.js/io.js ≥ 1.0.0)
a(href=`before${link}after`)
// 任何场合
a(href='before' + link + 'after')
```

- 文本插值

```js

```

### 属性

- 管道符 `|` 用来控制空格

```js
// pug
a(href='baidu.com') 百度
|
|
a(class='button' href='baidu.com') 百度

// 输出
<a href="baidu.com">百度</a>
<a class="button" href="baidu.com">百度</a>
```

- 属性的多种写法

```js
// 空格
a(class='button' href='baidu.com') 百度
// 逗号
a(class='button', href='baidu.com') 百度
// 多行
a(
  class='button'
  href='baidu.com'
) 百度
// 长数据
input(data-json=`
  {
    "非常": "长的",
    "数据": true
  }
`)
```

- 属性中含特殊字符

如果您的属性名称中含有某些奇怪的字符，并且可能会与 JavaScript 语法产生冲突的话，请您将它们使用 `""` 或者 `''` 括起来

- 使用未转义的属性

在默认情况下，所有的属性都经过转义（即把特殊字符转换成转义序列）来防止诸如跨站脚本攻击之类的攻击方式。如果您非要使用特殊符号，您需要使用 !=

```js

```

- 样式属性

```js
a(style={color: 'red', background: 'green'})

// 解析为
<a style="color:red;background:green;"></a>
```

- 类属性

```js
- var classes = ['foo', 'bar', 'baz']
a(class=classes)
|
//- 复合属性
a.bang(class=classes class=['bing'])

// 解析为
<a class="foo bar baz"></a>
<a class="bang foo bar baz bing"></a>
```

### 循环

- each / for

```js
each a in b
  = a

for a in b
  = a
```

### 分支条件

- `case`

```js
- var friends = 10
case friends
  when 0
    p 您没有朋友
    - break
  when 1
    p 您有一个朋友
  default
    p 您有 #{friends} 个朋友

// 块展开
- var friends = 10
case friends
  when 0: p 您没有朋友
  when 1: p 您有一个朋友
  default: p 您有 #{friends} 个朋友

// 解析为
<p>您有 10 个朋友</p>
```

- `while`

```js
- var n = 0;
ul
  while n < 4
    li= n++
```

### 条件语句

Pug 的条件判断的一般形式的括号是可选的，所以您可以省略掉开头的 -，效果是完全相同的。类似一个常规的 JavaScript 语法形式。

```js
- var user = { description: 'foo bar baz' }
- var authorised = false
#user
  if user.description
    h2.green 描述
    p.description= user.description
  else if authorised
    h2.blue 描述
    p.description.
      用户没有添加描述。
      不写点什么吗……
  else
    h2.red 描述
    p.description 用户没有描述
```

反义版本 `unless`

```js
unless user.isAnonymous
  p 您已经以 #{user.name} 的身份登录。

// 等价于
if !user.isAnonymous
  p 您已经以 #{user.name} 的身份登录。
```

### 代码code

> Pug 为您在模板中嵌入 JavaScript 提供了可能。这里有三种类型的代码。

#### 不输出的代码

用 `-` 开始一段不直接进行输出的代码，比如：

```js
- for (var x = 0; x < 3; x++)
  li item

// 输出为
<li>item</li>
<li>item</li>
<li>item</li>
```

Pug 也支持把它们写成一个块的形式：

```js
-
  var list = ["Uno", "Dos", "Tres","Cuatro", "Cinco", "Seis"]
each item in list
  li= item

// 输出为
<li>Uno</li>
<li>Dos</li>
<li>Tres</li>
<li>Cuatro</li>
<li>Cinco</li>
<li>Seis</li>
```

- 带输出的代码

用 `=` 开始一段带有输出的代码，它应该是可以被求值的一个 `JavaScript表达式`。为安全起见，它将被 HTML 转义：

```js
- var a = 0
p
  = a>0?'这个代码被 <转义> 了！'
// 行内模式
p= '这个代码被 <转义> 了！'

// 输出为
<p>这个代码被 &lt;转义&gt; 了！</p>
```

- 不转义的、带输出的代码

用 `!=` 开始一段不转义的，带有输出的代码。这将不会做任何转义，所以用于执行用户的输入将会不安全：

```js
p!= '这段文字 <strong>没有</strong> 被转义！'
```

### 注释

```
// 一些内容
//- 这行不会出现在结果里
body
  //-
    给模板写的注释
    随便写多少字
    都没关系。
  //
    给生成的 HTML 写的注释
    随便写多少字
    都没关系。
```

### 混入

混入是一种允许您在 Pug 中重复使用一整个代码块的方法。

```js
//- 定义
mixin list
  ul
    li foo
    li bar
    li baz
//- 使用
+list
+list

// 解析为
<ul>
  <li>foo</li>
  <li>bar</li>
  <li>baz</li>
</ul>
<ul>
  <li>foo</li>
  <li>bar</li>
  <li>baz</li>
</ul>
```
