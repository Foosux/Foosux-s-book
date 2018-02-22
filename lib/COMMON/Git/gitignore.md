# gitignore

## 作用及规则
在git中如果想忽略掉某个文件，不让这个文件提交到版本库中，可以使用修改根目录中 .gitignore 文件的方法（如无，则需自己手工建立此文件）。这个文件每一行保存了一个匹配的规则例如：

![](https://mmbiz.qpic.cn/mmbiz_png/jBonsibgwy67icjkicdOo8fQWaykHBjbaBRicX1FpAdZt5WAR3Jmag88saPQonLOEGTv5Ikl0G7edpnEploWvtiaicxQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1)

## 问题及解决方法

- 写入 `.gitignore` 的规则失效？

__原因__：.gitignore只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。

__解决__：先把本地缓存删除（改变成未track状态），然后再提交。

```
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```
