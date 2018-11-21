# Shell printf命令

* printf 命令模仿 C 程序库（library）里的 printf() 程序。
* printf 由 POSIX 标准所定义，因此使用 printf 的脚本比使用 echo 移植性好。
* printf 使用引用文本或空格分隔的参数，外面可以在 printf 中使用格式化字符串，还可以制定字符串的宽度、左右对齐方式等。
* 默认 printf 不会像 echo 自动添加换行符，我们可以手动添加 \n。

## 基本语法

```js
printf  format-string  [arguments...]
```

参数说明：
* format-string: 为格式控制字符串
* arguments: 为参数列表

示例：

```js
printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876
```

![](https://ws2.sinaimg.cn/large/006tNbRwly1fxfmv71fyqj30bw04gdgf.jpg)

## 命令格式指示符

* %s 字符串
  * %-10s 指一个宽度为10个字符，`-`表示左对齐
* %c ASCII字符.显示相对应参数的第一个字符
* %d，%i 十进制整数
* %u 不带正负号十进制
* %x 不带正负号十六进制 a-f
* %X 不带正负号十六进制 A-F
* %E，%e 浮点格式
* %% 字面量%

## 精度指示符

* %f 小数点右边的位数
  * %-4.2f 指格式化为小数，其中.2指保留2位小数。

## 转义序列

* \a	警告字符，通常为ASCII的BEL字符
* \b	后退
* \c	抑制（不显示）输出结果中任何结尾的换行字符（只在%b格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略
* \f	换页（formfeed）
* \n	换行
* \r	回车（Carriage return）
* \t	水平制表符
* \v	垂直制表符
* \\	一个字面上的反斜杠字符
* \ddd	表示1到3位数八进制值的字符。仅在格式字符串中有效
* \0ddd	表示1到3位的八进制值字符
