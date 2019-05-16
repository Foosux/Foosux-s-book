# PHP基础
<!-- toc -->

PHP（Hypertext Preprocessor，超文本预处理器），是一种服务器、跨平台、HTML嵌入式的脚本语言，其独特的语法混合了C语言、Java语言和Perl语言的特点，是一种被广泛应用的开源式的多用途脚本语言，尤其适合Web开发。

优势：

- 安全性高
- 跨平台特性
- 支持广泛的数据库

## 安装

### 组合包

适合新手，可快速搭建整套环境，`*AMP`(如：XAMPP/WAMP/LAMP/MAMP)

- windows: AppServ、EasyPHP、XAMPP

### MAC系统自带

适合MAC系统学习使用。

### 二进制编译

安装已编译好的二进制文件，Linux系统通常使用此种方法安装。

### 源代码安装

难度最大，但在增加和减少PHP组件时可以获得最大的自由度。

## 启动及关闭

此处以 `Apache` 为例

```js
// 启动、停止、重启
sudo apachectl start | stop | restart
```
