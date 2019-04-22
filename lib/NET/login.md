# 登录功能的实现

## 简单登录功能

## 哈希加密

> 哈希算法，即 hash，又叫散列算法，是一类把任意数据转换为定长（或限制长度）数据的算法统称。

> 在 Web 应用中，永远在服务端上进行哈希加密

密码加密一般用不可逆的哈希算法

### 前端常用加密算法

哈希算法 | 长度(bit) | 数据库长度(byte) | 备注
- | - | - | - |
md5 | 128 | 16 |  `<script src="jquery.js">` <br/> `<script src="js/md5.js">` <br/> $.md5(password) <br/> 不建议使用，容易被破解
sha1 | 160 | 20 | `<script src="js/shal.js">` <br/> hex_sha1(password) <br/> b64_sha1(password) <br/> str_sha1(password)
sha256 | 256 | 32 |
sha512 | 512 | 64 | sha512(sha512(password)+salt)
base64(非hash) | 不固定 | 不固定 | `<script src="js/base64.js">` <br/> Base64.encode(password) <br/> Base64.decode(base64Password)

```js
// 示例
MD5:    fbc3ca43230086857aac9b71b588a574
SHA1:   116c5f60b50e80681842b5716be23951925e5ad3
SHA256: 201f8815c71a47d39775304aa422a505fc4cca18493cfaf5a76e608a72920267
SHA512: 4ea023e0080494cfdb52b134f7e686bc70d49b5c9a89ff45f26574e44f98f5714f955e69c26e09086e796b819ff4d90adb263278cb579c7e343f3201b690916d
```

### 后端常用加密算法

哈希算法 | 数据库长度(byte) | 备注
- | - | -  
UUID | 32个16进制数字 |
SSID | 160 |

```js
// 示例
UUID: 550e8400-e29b-41d4-a716-446655440000
SSID:
```

### 2次MD5方案

> MD5(MD5(pass明文+固定salt)+随机salt)

#### 明文密码不能在网络上传输

由于http是明文传输，当输入密码若直接发送服务端验证，此时被截取将直接获取到明文密码，获取用户信息。

#### 写入数据库的密码需要再次加密

密码明文传递或者直接写到数据库中，都有被偷看的风险

### 精心设计的密钥扩展算法

可使用的：

- PBKDF2
- bcrypt
- scrypt
- OpenWall的 `Portable PHP password hashing framework`
- PBKDF2 在PHP、C＃、Java和Ruby的实现
- crypt 的安全版本

不可使用的：

- 快速加密哈希函数，如 MD5 、SHA1、SHA256、SHA512、RipeMD、WHIRLPOOL、SHA3
- crypt()的不安全版本
- 任何自己设计的加密算法。只应该使用那些在公开领域中的、由经验丰富的密码学家完整测试过的技术。

### 常见攻击

> 加盐可以确保攻击者无法使用像`查询表`和`彩虹表`攻击那样对大量哈希值进行破解，但依然不能阻止他们使用字典攻击或暴力攻击。

###

## 实现单点登录


## 用户服务

### 账号服务 remember

特点 ：

- 提供全局唯一的UCID分发
- 多账号体系隔离的账号管理能力
- 支持多种类型的账号标识
- 满足基本账号信息的存储与访问
- 账号密码存储与校验，支持第三方验密扩展
- 提供RESTful风格的API接口
- 符合公司的安全标准和审计要求

```js
// UCID是一个int64类型的正整数数字，长度共有16位，其中前3~6位被用来标识所属的账号体系
ucid: 1000000020213303
```

提供什么？

- 共享账号体系或者自建独立的账号体系
- 账号注册并颁发全局唯一的UCID
- 基本信息管理包括：UCID、账号名（account）、邮箱（email）、手机号（phone）、显示名称（displayName）、真实名称（realName）、性别（gender）、生日（birthday）、头像（avatar）
- 最多10个自定义的账号标识，默认为账号名（account）、邮箱（email）、手机号（phone）
- 最多255个自定义账号描述信息（扩展字段）
- 密码存储与验证
- 账号查询Sug

#### API

> http://uc.lianjia.com/

- `/ehr/user` only链家集团内部人员（经纪人、员工）
- `/ehr/user/staff`  链家集团人员、德祐、满堂红
- `/user` 链家网注册用户
- `/ehr/user/batch`
- `/ehr/user/agent`

### 通行证服务 passport(Login)

接入通行证服务使账号可以通过单点登录进入一个系统

#### API

web单点服务2.0 API

- `/authentication/initialize` POST 获取登录初始信息
- `/authentication/authenticate` POST 登录
- `/serviceValidate` GET 获取用户信息
- `/authentication/destroy` POST 退出

### 权限服务  permission

为用户配置细粒度的系统功能权限

### session服务

为用户维护一个lianjia_token，满足用户登录状态维持的需要

### IM服务

接入即时通讯可让业务具有实时通讯的能力


## 参考文档

- [基于CAS实现单点登录](https://zhuanlan.zhihu.com/p/25007591)
- [单点登录的三种实现方式](https://cnodejs.org/topic/55f6e69904556da7553d20dd)
