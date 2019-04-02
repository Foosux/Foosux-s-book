# 基础

MySQL 数据库是一种C\S结构的软件，即分为：客户端和服务端。

若想访问服务器，则必须通过客户端；服务器应该一直运行，客户端则在需要使用的时候运行。

## 常用指令

### 别名

```js
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

// 启动&关闭
alias mysqlstart='sudo /usr/local/mysql/support-files/mysql.server start'
alias mysqlstop='sudo /usr/local/mysql/support-files/mysql.server stop'
```

### 重置密码

```js
mysqladmin -u 帐号名 -p password 新密码
```

### 登录MySQL

```js
mysql -h 主机名 -u 用户名 -p

// 登录本机
mysql -u root -p
```

- `-h` 指定客户端所要登录的 MySQL 主机名, 登录本机(localhost 或 127.0.0.1)该参数可以省略
- `-u` 登录的用户名
- `-p` 告诉服务器将会使用一个密码来登录, 如果所要登录的用户名密码为空, 可以忽略此选项
- `-P` 端口号，用来找软件

### 退出

```js
exit
// or
quit
// or
\q
```

### 查看是否启动

```js
ps -ef | grep mysqld
```

### 查看用户信息

```js
select host,user,authentication_string,plugin from user;

// 更改host的默认配置
update user set host='%' where user='root';
// 执行刷新命令
flush privileges;
```

### 查看字符集

```js
// 查看服务器识别的全部字符集
show character set;

// 查看服务器默认的对外处理的字符集
show variables like 'character_set%';

// 修改字符集 (squel pro 在 table info 设置)
set character_set_results = gbk;      // 会话内有效
set names gbk;                        // 永久有效
```

> 服务器默认的对外处理的字符集是utf8.

## 遇到的问题

> sequel pro 连接不上本地 sql

![使用Sequel pro 链接本地的mysql](https://blog.csdn.net/baby_hua/article/details/82381345)


![浅谈mysql8.0新特性的坑和解决办法](http://www.manongjc.com/article/13483.html)

> Sequel Pro 1.1.2 ，连接上数据库后操作报错

本地测试时需要选择



![解决](https://www.cnblogs.com/lhdcg/p/9937324.html)
