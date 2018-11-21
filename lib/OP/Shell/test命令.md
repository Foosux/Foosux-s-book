# Shell test命令

Shell中的 test 命令用于检查某个条件是否成立，它可以进行`数值`、`字符`和`文件`三个方面的测试。

> 实际测试可使用 [ ] 代替 

## 数值测试

```js
num1=100
num2=100

if test $[num1] -eq $[num2]
then
    echo '两个数相等！'
else
    echo '两个数不相等！'
fi
```
