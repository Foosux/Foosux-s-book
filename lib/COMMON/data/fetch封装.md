# 原生fetch封装

> `fetch` 是 XHR 的替代方案，基于 Promise 实现。

- 统一配置文件，方便统一管理请求配置，如：超时、编码格式、统一的错误处理等

- 支持get、post请求，缺省为 `get`

- 支持 `form、JSON` 格式提交，缺省为 `form`

```js
// 例子中引入了 antd 来解决信息浮层的问题，实践中可自由替换
import { Modal } from 'antd'
const info = Modal.info;

export default function ({url, params={}, method='GET', ContentType='application/x-www-form-urlencoded'}){
  method = method.toUpperCase()
  var fetchConfig = {
    method: method,
    credentials: 'include',
    headers: {
      'X-Requested-With':'XMLHttpRequest',
    }
  };
  let requestUrl
  requestUrl = url
  var paramsString = ""
  if(Object.keys(params).length !== 0){
    var values = []
    for(var i in params){
      if (params.hasOwnProperty(i)) {
        values.push(i+'='+encodeURIComponent(params[i]));
      }
    }
    paramsString = values.join('&')
  }
  if (method === 'POST') {
    fetchConfig.headers = {
      ...fetchConfig.headers,
      "Content-Type": ContentType
    }
    if (ContentType === 'application/x-www-form-urlencoded') {
      fetchConfig.body = paramsString;
    } else if(ContentType === 'application/json') {
      fetchConfig.body = JSON.stringify(params);
    }
  }else if (paramsString !== '') {
    requestUrl = requestUrl + '?' + paramsString;
  }
  return new Promise(function(resolve, reject) {
    fetch(requestUrl, fetchConfig).then(
      (response) =>{
        return response.json().then(json => ({ json, response }))
      }).then(({ json, response }) => {
        if (!response.ok) {
          info({
            content:'网络错误'
          })
          return reject('网络错误')
        }
        if (json.code === 1) {
          return resolve(json.data);
        }else if(json.code === 302){
          window.location.href=json.data;
        }else{
          info({
            content:json.msg
          })
          return reject(json)
        }
      }).catch(function(error){
        info({
          content:'接口错误'
        })
        return reject('接口错误')
      })
  })
}
```

- 使用

```js
import Fetch from './fetch'

// get
Fetch({
  url: '/data/business/createInfo?businessId=123'
}).then( data =>{ })

// post
Fetch({
  url: '/data/business/createInfo',
  mothod: 'post',
  params: {
    businessId: 123
  }
})
```
