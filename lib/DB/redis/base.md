# redis基础

## 安装

### linux

```js
wget http://download.redis.io/releases/redis-5.0.4.tar.gz
tar xzf redis-5.0.4.tar.gz
cd redis-5.0.4
make
```

### mac

- [官网下载](https://redis.io/download) `stable` 稳定版本。

![](https://img-blog.csdn.net/20180419163815069?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvSmFzb25fTV9Ibw==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

```JS
// 解压并移动到想要安装的目录
tar zxvf redis-5.0.4.tar.gz
mv redis-5.0.4 /usr/local/
cd /usr/local/redis-5.0.4/
// 编译测试
sudo make test
// 编译安装
sudo make install
```

## 启动 & 关闭

```js
// 启动 redis-server命令在 /usr/local/redis-5.0.4/src
redis-server [/etc/redis.conf]

// 关闭
redis-cli
SHUTDOWN  
// zsh
kill redis + Tab键
```

## 常用操作命名

客户端环境 `redis-cli` 中操作  

命令 | 用途
- | -
set `<key>` `<value>`	| 设置 `key-value` 值
get `<key>` |	获取 `key` 的值
exists `<key>` | 查看此 `key` 是否存在
keys `*` | 查看所有的 `key`
flushall | 消除所有的 `key`

## 常用配置

修改 `redis.conf`

用途 | 配置项 | 默认值 | 备注
- | - |
守护进程 | daemonize | no | no、yes
设置密码 | requirepass | 无 |
制定端口 | port | 6379 |
主机地址 | bind | 127.0.0.1 |
客户端闲置多长时间后关闭连接| timeout | 0 | 0，表示关闭该功能，单位为`s`
日记记录级别 | loglevel | verbose | verbose、debug、notice、warning
日志记录方式 |  logfile |  stdout |
数据库数量 | databases | 16 | 可以使用`SELECT <dbid>`命令在连接上指定数据库id
存储至本地数据库时是否压缩数据 | rdbcompression | yes | yes、no
指定本地数据库文件名 | dbfilename | dump.rdb |
指定本地数据库存放目录 | dir | ./ |
最大连接数 | maxclients | 不限制 | `0`表示不作限制
最大内存限制 | maxmemory | 不限制 | `<bytes>`
