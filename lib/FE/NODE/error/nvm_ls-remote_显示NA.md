# nvm ls-remote显示N/A

![](/images/node/error/nvm_NA.png)

> 使用nvm查看可安装的node版本时显示N/A

## 原因

默认使用了`https`源，`curl`不能正常拉取到相关信息。（[查看更多](./curl证书问题.html)）

## 解决方案

- `step1`：重新配置 nvm 源，切换到 `http` 源。

```js
// 在终端执行下面的命令。（暂时的方法，shell关闭后失效）
export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist

// 一劳永逸，将下面这行写入配置文件 (~/.bash_profile)
export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist

// 执行命令，使配置文件生效
source ~/.nvm/nvm.sh
```

- `step2`：重新执行命令，返回正常。

```
nvm ls-remote
```

![](/images/node/error/nvm_NA_2.jpg)
