# Shell echo命令

Shell 的 echo 指令与 PHP 的 echo 指令类似，都是用于字符串的输出。命令格式：

```js
echo string
```

## 常规情况

```js
name='Tom'

echo "It is a test"          // 显示普通字符串
echo "$name It is a test"    // 显示变量
echo '$name\"'               // 原样输出，使用单引号
echo -e "OK! \c"             // 不换行，-e 开启转义
echo -e "OK! \n"             // 换行，  -e 开启转义
```

## 显示结果定向至文件

```js
echo "It is a test" > ~/Desktop/log.txt
```

## 显示命令执行结果

```js
echo `expr 1 + 1`    // 2
```
