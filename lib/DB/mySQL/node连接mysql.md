# node连接mysql

## 安装和示例

```js
// 安装依赖包
npm i mysql

// node中使用
var mysql      = require('mysql')
var connection = mysql.createConnection({
  host     : '127.0.0.1',
  user     : 'me',
  password : 'secret',
  database : 'my_db'
})

connection.connect(err => {
  if (err) throw err
  clonse.log('开启连接')
})

connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
  if (error) throw error
  console.log('The solution is: ', results[0].solution)   // 2
})

connection.end(err => {
  if (err) throw err
  clonse.log('关闭连接')
})
```

## query

```js
// 一般形式
.query(sqlString, callback)
.query(
  'SELECT * FROM `books` WHERE `author` = "David"',
  ()=>{}
)

// 第二种写法：? 作为 placeholders，用values替代
.query(sqlString, values, callback)
.query(
  'SELECT * FROM `books` WHERE `author` = ?',
  ['David'],
  ()=>{}
)

// 第三种写法
.query(options, callback)
.query({
  sql: 'SELECT * FROM `books` WHERE `author` = ?',
  timeout: 40000,       // 40s
  values: ['David']
}, ()=>{})
```

## 连接池（Pooling connections）

在实际开发过程中，应该还是使用连接池的方式比较好！

```js
var mysql = require('mysql')

//创建连接池
var pool  = mysql.createPool({
  host     : '192.168.0.200',
  user     : 'root',
  password : 'abcd',
  database : 'my_db'
})

//共享使用
pool.getConnection(function(err, connection) {
  connection.query(sqlStr, (err, results, fields) => {
    connection.release()  // 释放，会把连接放回连接池，等待其它使用者使用!
  })
  connection.query(sqlStr, () => {
    connection.release()
  })
  connection.query(sqlStr, () => {
    connection.release()
  })
})


```

## 断线重连

```js
function handleDisconnect() {
  connection = mysql.createConnection(db_config)                                               
  connection.connect(function(err) {              
    if(err) {                                     
      console.log("进行断线重连：" + new Date())
      setTimeout(handleDisconnect, 2000)   //2秒重连一次
      return
    }         
     console.log("连接成功")  
  })                                                                           
  connection.on('error', function(err) {
    console.log('db error', err)
    if(err.code === 'PROTOCOL_CONNECTION_LOST') {
      handleDisconnect()                         
    } else {                                      
      throw err                                 
    }
  })
}
handleDisconnect()
```

## 参考资料

- [npm包-`mysql`](https://github.com/mysqljs/mysql)
