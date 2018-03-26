# 基于axios的请求封装

> VUE项目中基于 `element-ui` 和 `axios` 完成对请求方式的封装

- 统一配置文件，方便统一管理请求配置，如：超时、编码格式、统一的错误处理等

- 支持get、post请求，缺省为 `get`

- 支持 `form、JSON` 格式提交，缺省为 `JSON`

```js
// ajax.js
import Axios from 'axios'
import { Message } from 'element-ui'

export default function ({
  url,
  params={},
  method="GET",
  contentType="application/json"
}) {
  var opts = {}
  if (method.toUpperCase()==='GET' || contentType==='application/x-www-form-urlencoded') {
    opts.params = params
  } else if(method.toUpperCase()==='POST') {
    opts.data = params
  }
  var config = {
    method,
    url,
    headers: {
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': contentType
    },
    timeout: 1000,
    ...opts
  }

  return new Promise(function(resolve, reject){
    Axios(config).then(({data}) => {
      if(data.code === 1){
        return resolve(data.data)
      } else if(data.code === 302){
        window.location.href=data.data
      } else {
        Message({
          message: data.msg,
          type: 'warning'
        })
        return reject(data)
      }
    }).catch( error => {
      Message.error('接口请求出错')
      return reject('接口请求出错')
    })
  })
}
```

- 使用:

```js
// 使用
import Ajax from './ajax'

// get
Ajax({
  url: 'xxx',
  params: {
    p1: 'xxx',
    p2: 'xxx'
  }
}).then( data => { })

// post
Ajax({
  url: '',
  method: 'post',
  params: {
    p1: 'xxx',
    p2: 'xxx'
  }
}).then( data => {})
```
