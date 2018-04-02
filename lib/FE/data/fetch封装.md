# 原生fetch封装

> `fetch` 是 XHR 的替代方案，基于 Promise 实现。

- 统一配置文件，方便统一管理请求配置，如：超时、编码格式、统一的错误处理等
- 支持get、post请求，缺省为 `get`
- 支持 `form、JSON` 格式提交，缺省为 `form`

```js
// 例子中引入了 antd 来解决信息浮层的展示，实践中可自由替换
import { Modal } from 'antd'
const info = Modal.info

export default function (url, {
  params={},
  method='GET',
  headers={}
}={}){
  method = method.toUpperCase()
  let config = {
    method: method,
    // fetch 默认不带cookie，需开启
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      ...headers
    }
  }
  let requestUrl = url,
      paramsString = ""
  if(Object.keys(params).length !== 0){
    let values = []
    for (let i in params) {
      if (params.hasOwnProperty(i)) {
        values.push(i+'='+encodeURIComponent(params[i]))
      }
    }
    paramsString = values.join('&')
  }
  if (method === 'POST') {
    if (config.headers["Content-Type"] === 'application/x-www-form-urlencoded') {
      config.body = paramsString
    } else if (config.headers["Content-Type"] === 'application/json') {
      config.body = JSON.stringify(params)
    }
  } else if (paramsString !== '') {
    requestUrl = requestUrl + '?' + paramsString
  }

  return new Promise(function(resolve, reject) {
    fetch(requestUrl, config).then( r => {
      if (!r.ok) {
        info({
          content:'网络错误'
        })
        return reject('网络错误')
      } else {
        return r.json()
      }
    }).then( json => {
      if (json.code === 1) {
        return resolve(json.data)
      } else if (json.code === 302) {
        window.location.href=json.data
      } else {
        info({
          content:json.msg
        })
        return reject(json)
      }
    }).catch(function (error) {
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
Fetch('/data/business/createInfo?businessId=123').then( data =>{ })

// post
Fetch('/data/business/createInfo', {
  mothod: 'post',
  params: {
    businessId: 123
  }
})
```
