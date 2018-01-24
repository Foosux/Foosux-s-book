# curl证书问题

![](/images/node/error/curl_error.png)

> 使用curl下载资源时报错："curl performs SSL certificate verification by default, using a "bundle"
 of Certificate Authority (CA) public keys (CA certs). If the default
 bundle file isn't adequate, you can specify an alternate file
 using the --cacert option.
If this HTTPS server uses a certificate signed by a CA represented in
 the bundle, the certificate verification probably failed due to a
 problem with the certificate (it might be expired, or the name might
 not match the domain name in the URL).
If you'd like to turn off curl's verification of the certificate, use
 the -k (or --insecure) option."

## 原因

curl下载`https`资源时缺少SSL证书。

## 解决方法

- `step1`：去[官网](https://curl.haxx.se/docs/caextract.html) [下载证书](/images/node/error/cacert.pem) `cacert.pem`至本地

![](/images/node/error/curl_epm.png)

- `step2`：执行`curl`命令时指定`--cacert`参数

```js
curl -fsSL --cacert 本地证书地址 正常资源地址

// 示例：下载0.32.1版本的nvm
curl -fsSL --cacert https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
```
