## 基础

### 生成 SSH key

查看`.ssh`目录是否存在 `id_rsa` 和 `id_rsa.pub`,若没有则用下面命令生成:

    ssh-keygen -t rsa -C "youremail@example.com"

### 设置账号

    git config --global user.name "Your Name"
    git config --global user.email "email@example.com"

### 忽略某些文件

有些系统文件不用提交，需要在本地仓库下新增一个 `.gitignore`，然后添加相关的内容，格式如下：

    # mac
    .DS_Store
    # Windows
    Thumbs.db
    ehthumbs.db
    Desktop.ini

### 指令别名

可以把复杂的命令封装在一个别名里，方便使用。

#### 设置

    $ git config --global alias.st status
    $ git config --global alias.co checkout
    $ git config --global alias.ci commit
    $ git config --global alias.br branch
    $ git config --global alias.lg --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

#### 取消

* 全局的放在 `~/.gitconfig` 中
* 本地的放在 `.git/config` 中

## 基本指令

类别 | 指令 | 参数 | 作用
-|-
`创建` | git clone | ssh://user@domain.com/repo.git | clone已存在项目到本地
- | git init | | 创建一个本地仓库
`配置`| git config | -l |查看git配置信息
- | - | -global user.name "Your Name" | 重新设置昵称
- | - | --global user.email "email@example.com" | 重新设置邮箱
本地仓库 | git status |  | 查看本地仓库状态(增、删、改)
`缓存`| git add | . | 预加载所有文件
-| - | fileName | 预加载制定文件
-| - | 通配符 | 预加载通配符匹配的文件
-| git stash | | 缓存当前状态，常用于解决临时Bug
-| - | list |  查看stash的缓存日志
-| - | apply| 恢复stash
-| - | drop| 删除stash
-| - | pop | 恢复并删除stash(=上面两个命令的合集)
-| - | clear | 删除所有缓存列表
`撤销`| git reset HEAD | fileName | 取消add的预加载文件
-| git checkout  | -- fileName | 将文件恢复到之前的版本（新增的文件无效）
`提交`| git commit | -m 'msg' | 提交并填写说明
-|-|-am 'msg' | add并提交所有修改的内容(新增的不会提交)
-| -| --amend | 修改最后一次commit的注释（未push）
`日志` | git log | | 查看所有提交日志
- | - | -- fileName | 查看某文件的历史提交
- | - | --oneline | 查看精简版日志（显示成一行）
- | - | --abbrev-commit | 版本号使用7位简短值
- | - | -p | 查看详细日志
- | - | -p -2 | 查看最近两次的详细日志
- | - | -p fileName | 查看指定文件的详细提交记录
- | - | --stat | 仅显示简要的增改行数统计
- | - | --pretty=oneline/fuller/full/short/format | 只显示哈希值和提交说明(1行...)
- | - | --graph |ASCII 字符串表示的简单图形
- | git blame | fileName | 查看指定文件的提交人、时间
- | git reflog |  | 查看之前的日志
`回滚` | git reset  | --hard HEAD^ | 回滚到上一个版本
- | - | --hard HEAD^^ | 回滚到上两个个版本
- | - | --hard HEAD~100 | 回滚到上N个版本
- | - | --hard HEAD@{1} | 回滚到之前有过的版本
- | - | --hard 版本号 | 回滚到某个版本
`分支`| git checkout | -b 分支名 | 创建并切换到新分支
- | - | 分支/master | 切换分支
- | - | --track 远程分支名 | 关联远程仓库里的特定分支
- | - | --track -b 远程分支名 | 获取远程仓库里的特定分支并在本地创建
- |  git branch | | 查看分支list（\*为指针）
- | - | -r | 查看远程仓库分支
- | - | -a | 查看本地和远程所有的仓库分支
- | - | -d 分支名 | 删除合并过的分支
- | - | -D 分支名 | 删除未合并的分支
- |  git log | --graph | 查看分支/合并时间
`合并` | git merge | 分支名 | 合并某分支到当前分支
-|-|--no-ff -m '备注'| 强制禁用FastForward模式，生成分支记录
`冲突` | git diff | 分支名称 | 查看冲突
`比较` | gitk | fileName | 比较工作区某文件和历史版本之间的差别
`标签` | git tag |  | 查看标签列表(按字母排序)
-| - | tagName | 增加一个标签
-| - | tagName 版本号| 给指定版本增加标签
-| - | -d tagName| 给指定版本增加标签
-| - | -a tagName -m '注释' 版本号| 增加有注释说明的tag
-| git show | tagName | 查看某标签信息
-| git push | origin v1.0 | push标签到远程
-| - | origin --tags | push所有标签到远程
-| - | origin :refs/tags/v0.9 | 删除远程标签
远程仓库 | git remote add origin | git@github.com:Foosux/atom.git | 链接远程仓库
`推送` | git push | -u origin master | 将内容推送到远程库(第一次推送需要 -u)
`拉取` | git fetch | origin master | 从远程获取最新版本到本地
- | git log | -p master..origin/master |
- | git merge | origin/master | 合并
- | git pull | origin master | 从远程获取最新版本并`merge`到本地
