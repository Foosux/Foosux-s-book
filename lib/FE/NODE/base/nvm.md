# nvm（Node Version Manage）

<!-- toc -->

> nvm是`node`的版本管理工具，和另一个版本管理工具`n`相比具有以下优点：

- 沙箱式管理，各版本之间无任何关联，非常适合做各种测试。
- 不依赖node，无需预安装node环境。
- 安装使用简单方便，功能更为灵活、强大。

## nvm管理

### 安装

```js
// 使用curl安装（使用于Linux环境）
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

// 使用homebrew安装（适用于MAC环境）
$ brew install nvm
```

## 管理node版本

### 1 查看已有版本

```js
// 查看所有可安装版本
nvm ls-remote

// 查看所有已安装版本
nvm ls

// 查看当前使用的版本
nvm current
```

> ls-romote 时显示 N/A？ [查看解决方法](../error/nvm_ls-remote_显示NA.html)


### 2 安装&卸载

可结合 [node.green](http://node.green/) 查看需要安装的版本。

```
nvm install <version>

nvm uninstall <version>
```

- 使用模糊版本号

> 指定准确版本安装 `nvm install 6.6.6`   

> 模糊安装大版本的最后一版 `nvm install 6` => `6.12.2`   

> 模糊安装小版本的最后一版本 `nvm install 6.9` => `6.9.5`

### 3 切换版本

	nvm use <version>

### 4 指定默认版本

	nvm alias default <version>

### 5 安装/删除版本别名

```js
// 给不同的版本号添加别名
nvm alias <name> <version>

// 删除已定义的别名
nvm unalias <name>
```

### 6 安装其它版本npm

```js
// 当前版本node环境下，重新全局安装指定版本号的npm包
nvm reinstall-packages <version>
```

## 卸载node

如果使用nvm前已经安装全局node或是其它原因需要卸载，可参考下面方法：

```js
// 查看已经安装在全局的模块，以便删除这些全局模块后再按照不同的 node 版本重新进行全局安装
npm ls -g --depth=0

// 删除全局 node_modules 目录
sudo rm -rf /usr/local/lib/node_modules

// 删除 node
sudo rm /usr/local/bin/node

// 删除全局 node 模块注册的软链
cd  /usr/local/bin && ls -l | grep "../lib/node_modules/" | awk '{print $9}'| xargs rm
```
