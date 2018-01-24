# npm（Node Package Manager）

> npm是`node`的包管理工具，也是前端模块化的一个标志性产物。   

> 本文中提及的`包`和`模块`是同一概念。

<!-- toc -->

## npm管理

### 1 安装

通常 `安装node` 时会自带npm。

```js
// 查看是否安装npm、可用指令、帮助文档
npm

// 查看npm版本
npm -v
npm --version

//查看项目中模块所在的目录
npm root

//查看全局安装的模块所在目录
npm root -g
```

### 2 卸载

通常npm和node总是打包使用，单独卸载npm的命令很少用到。

```js
sudo npm uninstall npm -g
```

### 3 升级

在执行某些命令时，会提示需要更高版本的npm，可通过命令升级。

```js
npm install -g npm
```

### 4 配置

npm的配置主要通过 `config` 命令来进行，最常用到的是查看和修改使用的 `源`。

```js
// 查看目前使用的源
npm config get registry

// 设置源（退出shell时失效）
npm config set registry https://registry.npm.taobao.org
```

- 关于 `源`？

由于某些原因，使用默认源上传/下载依赖包时会非常缓慢。通常的解决方案是使用公司搭建的私有源或直接使用淘宝源。除使用 `config` 指令设置外，还有以下两种方式更改源：

```js
// 通过npm指令指定源（单次生效）
npm install 模块名 --registry https://registry.npm.taobao.org

// 在系统配置文件 ~/.npmrc 中写入源地址（永久生效，推荐使用）
vim ~/.npmrc		// 打开配置文件
registry=https://registry.npm.taobao.org		// 写入配置并保存退出
```

- 几个常用的源
	+ 默认源 `http://registry.npmjs.org`
	+ 淘宝https源 `https://registry.npm.taobao.org`
	+ 淘宝http 源 `http://registry.npm.taobao.org`

## npm包管理

### 1 安装包

```js
// 全局安装
npm install -g 模块名

// 本地安装，作为生产环境依赖，计入 package.json - dependencies
npm install --save 模块名

// 本地安装，作为开发环境依赖，计入 package.json - devDependencies
npm install --save-dev 模块名

// 安装特定版本的包
npm isntall 模块名@版本号

// 依据 package.json，安装所有项目依赖
npm install
```

- `全局安装` 和 `本地安装` 的区别 ？

> 使用本地安装：依赖包会下载到当前所在目录的 `node_module`，也只能在当前目录下使用。

> 使用全局安装：依赖包会下载到系统特定目录，可以在所有目录中使用。

- 如何选择适当的方式安装依赖包？

> 拉取项目代码时，通常使用 `npm install` 根据 package.json 中的记录，一次安装所有项目依赖包。

> 新建项目和维护项目时，通常会根据需求，单个安装依赖包。安装时使用`--save`or`--save-dev`参数会同步更新 package.json中的包信息。

> 如果包需要作为 `命令行工具` 进行使用，则进行全局安装。

> 如果包仅作为模块功能引用，如 `require('xxx')`，则进行本地安装。

> 如果包仅在 `开发环境` 使用，则使用 `--save-dev` 安装。

> 如果包需要在 `生产环境` 使用，则使用 `--save` 安装。


### 2 卸载包

```js
// 删除全局模块
npm uninstall -g 模块名

// 删除本地模块（仅删除 node_module 中的模块，不改动 package.json）
npm uninstall 模块名

// 删除生产环境依赖并更新 package.json
npm uninstall --save 模块名

// 删除开发环境依赖并更新 package.json
npm uninstall --save-dev 模块名
```

### 3 管理已安装的包

- 查看本机安装的包情况

```js
// 查看全局已安装的包
npm list -g --depth 0

// 查看本地已安装的包
npm list --depth 0

// 查看某个包的版本
npm list 模块名 version
```

> `--depth 0` 是可选参数，表示遍历深度，数值的部分可修改。

- 更新已安装的包（会受 package.json 中限定的版本号影响）

```js
npm update 模块名
```

- 清除未被使用到的包

```js
npm prune
```

- 打开包的`线上仓库`页面（github）

```js
// 打开模块仓库界面
npm repo 模块名

// 打开模块主页
npm home 模块名

// 打开模块文档页
npm docs 模块名
```


### 4 发布包至npm

- 首次发布需要在 [npm](https://www.npmjs.com/) 注册账号并登陆。

```js
// 新增用户 (输入账号、邮箱、密码)
npm adduser

// 登陆npm（输入账号、密码）
npm login

// 查看登陆信息
npm whoami
```

- 编写符合规范的包

- 发布包至npm

```js
npm publish
```

> 包的名称和版本就是你项目中 package.json 里的`name`和`version`

- 注意事项

> 包名不能和已有的包重名。

> 包名不能有大写字母、空格、下划线（通常使用小写字母和中划线）

> 私密代码不想发布，可以写入 `.npmignore` 或 `.gitignore`


### 5 下架已发布的包

```js
npm unpublish 包名 --force
```

- 下架包并不容易，出于安全性考虑，在Azer NPM撤包事件后，npm公布了一版新的规则，如下：

> 版本更新少于24小时的包允许下架；

> 超过24小时的包的下架需要联系npm维护者；

> 如果有npm维护者参与，npm将检查是否有其他包依赖该包，如果有则不允下架；

> 如果某个包的所有版本都被移除，npm会上传一个空的占位包，以防后来的使用者不小心引用怀有恶意的替代者。

### 6 包版本号管理

- npm包的版本号的格式为`X.Y.Z`，遵循 semver2.0规则

> `X`为主版本号，只有更新了不向下兼容的API时修改主版本号

> `Y`为次版本号，当模块增加了向下兼容的功能时进行修改

> `Z`为修订版本号，当模块进行了向下兼容的bug修改后进行修改

- package.json中的版本号含义

![](https://ws2.sinaimg.cn/large/006tKfTcly1fnrsrci4xvj308o02qaa5.jpg)

> `~` 限定模块的次要版本。例如： `~1.2.3 `=> 匹配`1.2.x`，不包括1.3.0  

> `^` 限定模块的主要版本（默认）。例如： `^1.2.3 `=> 匹配`1.x.x`，不包括2.0.0

> `*` 意味着安装最新版本的依赖包。

> ` ` 无前缀意味着安装固定的版本。

- 扩展：`yarn` 也可以得到模块包精确控制的结果

yarn是一个与npm兼容的node包管理器，使用它安装npm包，会自动在项目目录创建一个yarn.lock文件，该文件包含了当前项目中所安装的依赖包的版本信息，其他人在使用yarn安装项目的依赖包时就可以通过该文件创建一个完全相同的依赖环境。

## package.json

在我们讨论过程中涉及了 `package.json` 的部分字段，详细介绍可参考另一篇文章。
