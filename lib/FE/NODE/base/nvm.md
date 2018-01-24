# nvm常用命令

<!-- toc -->

### 安装/卸载node

可结合 [node.green](http://node.green/) 查看需要安装的版本。

	nvm install <version>
	nvm uninstall <version>


> 指定准确版本安装 `nvm install 6.6.6`   
> 模糊安装大版本的最后一版 `nvm install 6` => `6.12.2`   
> 模糊安装小版本的最后一版本 `nvm install 6.9` => `6.9.5`

### 查看版本

	// 查看所有可安装版本
	nvm ls-remote

	// 查看所有已安装版本
	nvm ls

	// 查看当前使用的版本
	nvm current

### 切换版本

	nvm use 6

### 指定默认版本

	nvm alias default 0.10.32

### 安装/删除版本别名

	// 给不同的版本号添加别名
	nvm alias <name> <version>
	// 删除已定义的别名
	nvm unalias <name>

### 安装其它版本npm

	// 当前版本node环境下，重新全局安装指定版本号的npm包
	nvm reinstall-packages <version>
