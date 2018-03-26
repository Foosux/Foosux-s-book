# gitignore

## 作用及规则
在git中如果想忽略掉某个文件，不让这个文件提交到版本库中，可以使用修改根目录中 .gitignore 文件的方法（如无，则需自己手工建立此文件）。这个文件每一行保存了一个匹配的规则例如：

```bash
*.a         # 忽略有所 .a 结尾的文件
!lib.a      # lib.a 除外
/TODO       # 仅忽略项目根目录下的 TODO 下的文件，不包含 super/TODO
build/      # 忽略 build/ 下所有文件
doc/*.txt   # 忽略 doc/test.txt 但不包括 doc/serv/test.txt
```

## 问题及解决方法

- 写入 `.gitignore` 的规则失效？

__原因__：.gitignore只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改.gitignore是无效的。

__解决__：先把本地缓存删除（改变成未track状态），然后再提交。

```
git rm -r --cached .
git add .
git commit -m 'update .gitignore'
```
