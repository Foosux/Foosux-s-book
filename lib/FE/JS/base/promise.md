# promise

> Promise是异步编程的一种解决方案。比传统的解决方案：回调函数、事件，更合理和强大。

<!-- toc -->

## 概览

### 特点

- 对象的状态不受外界影响。

Promise对象代表一个异步操作，有三种状态：pending（进行中）、fulfilled（已成功）和rejected（已失败）。_只有异步操作的结果_，可以决定当前是哪一种状态，任何其他操作都无法改变这个状态。这也是Promise这个名字的由来，它的英语意思就是“承诺”，表示其他手段无法改变。

- 一但状态改变，就不会再变，任何时候就可以得到这个结果。

Promise对象的状态改变，只有两种可能：从pending变为fulfilled和从pending变为rejected。只要这两种情况发生，状态就凝固了，不会再变了，会一直保持这个结果，这时就称为 resolved（已定型）。

### 三种状态

- pending
- fulfilled
- rejected

### 优点

- 就可以将异步操作以同步操作的流程表达出来，避免了层层嵌套的回调函数。

- Promise对象提供统一的接口，使得控制异步操作更加容易。

### 缺点

- 无法取消Promise，一旦新建它就会立即执行，无法中途取消。

- 如果不设置回调函数，Promise内部抛出的错误，不会反应到外部。

- 当处于pending状态时，无法得知目前进展到哪一个阶段（刚刚开始还是即将完成）。

### 基本用法

ES6 规定，Promise对象是一个构造函数，用来生成Promise实例。

```js
const promise = new Promise(function(resolve, reject) {
  // ... some code

  if (/* 异步操作成功 */){
    resolve(value)
  } else {
    reject(error)
  }
})
```

构造函数接收一个`函数`作为参数，该函数的两个参数分别是 `resolve`、`reject`，它们是两个函数，由JS引擎提供。

- resolve: pending => fulfille  `.then(v => {}, error => {})`

resolve函数的参数除了正常的值以外，还可能是另一个 `Promise` 实例

- reject: pending => rejected   `.catch(error => {})`

reject函数的参数通常是Error对象的实例，表示抛出的错误；

### Promise新建后就会立即执行

立即 resolved 的 Promise 是在本轮事件循环的末尾执行，总是晚于本轮循环的同步任务。

```js
let promise = new Promise(function(resolve, reject) {
  resolve();
  console.log('Promise');
});

promise.then(function() {
  console.log('resolved.');
});

console.log('Hi!');

// Promise
// Hi!
// resolved
```

> 如果后面的语句不执行，则应加上 `return` 语句

```js
let promise = new Promise(function(resolve, reject) {
  return resolve()
  // 后面的语句不会执行
  console.log('Promise')
})
```

### 图片异步加载

```js
function loadImageAsync(url) {
  return new Promise(function(resolve, reject) {
    const image = new Image()

    image.onload = function() {
      resolve(image)
    }

    image.onerror = function() {
      reject(new Error('Could not load image at ' + url))
    }

    image.src = url
  })
}
```

## API

### Promise.prototype.then()

`.then()`的作用是为 Promise 实例添加状态改变时的回调函数。then方法的第一个参数是resolved状态的回调函数，第二个参数（可选）是rejected状态的回调函数。

then方法返回的是一个新的Promise实例（注意，不是原来那个Promise实例）。因此可以采用链式写法，即then方法后面再调用另一个then方法。

```js
getJSON("/posts.json").then(function(json) {
  return json.post
}).then(function(post) {
  // ...
})
```

### Promise.prototype.catch()

`Promise.prototype.catch`方法是.then(null, rejection)的别名，用于指定发生错误时的回调函数。

> catch方法返回的还是一个 Promise 对象，因此后面还可以接着调用then方法。

> catch方法之中，还能再抛出错误, 因此后面还可以接着调用catch方法。

```js
getJSON('/posts.json').then(function(posts) {
  // ...
}).catch(function(error) {
  // 处理 getJSON 和 前一个回调函数运行时发生的错误
  console.log('发生错误！', error);
});
```

`promise`抛出的错误 和 `then`方法指定的回调函数中抛出的错误，也会被`catch`捕获。

```js
const promise = new Promise(function(resolve, reject) {
  throw new Error('test');
});
promise.catch(function(error) {
  console.log(error);
});
// Error: test
```

如果 `Promise` 状态已经变成`resolved`，再抛出错误是无效的。

```js
const promise = new Promise(function(resolve, reject) {
  resolve('ok');
  throw new Error('test');
});
promise
  .then(function(value) { console.log(value) })
  .catch(function(error) { console.log(error) });
// ok
```

Promise 对象的错误具有“冒泡”性质，会一直向后传递，直到被捕获为止。也就是说，错误总是会被下一个catch语句捕获。

```js
getJSON('/post/1.json').then(function(post) {
  return getJSON(post.commentURL);
}).then(function(comments) {
  // some code
}).catch(function(error) {
  // 处理前面三个Promise产生的错误
});
```

> 通常建议总是使用 `catch()`，而非 `then()` 的第二个参数

> 一般总是建议，Promise 对象后面要跟catch方法，这样可以处理 Promise 内部发生的错误。

### Promise.prototype.finally()

finally方法用于指定不管 Promise 对象最后状态如何，都会执行的操作。该方法是 `ES2018` 引入标准的。

```js
promise
.then(result => {···})
.catch(error => {···})
.finally(() => {···});
```

> finally方法的回调函数不接受任何参数，这意味着没有办法知道，前面的 Promise 状态到底是fulfilled还是rejected。这表明，finally方法里面的操作，应该是与状态无关的，不依赖于 Promise 的执行结果。

finally方法总是会返回原来的值。

```js
// resolve 的值是 undefined
Promise.resolve(2).then(() => {}, () => {})

// resolve 的值是 2
Promise.resolve(2).finally(() => {})

// reject 的值是 undefined
Promise.reject(3).then(() => {}, () => {})

// reject 的值是 3
Promise.reject(3).finally(() => {})
```

### Promise.all([ ])

Promise.all方法用于将多个 Promise 实例，包装成一个新的 Promise 实例。

```js
const p = Promise.all([p1, p2, p3]);
```

p的状态由p1、p2、p3决定，分成两种情况。

- 只有p1、p2、p3的状态都变成fulfilled，p的状态才会变成fulfilled，此时p1、p2、p3的返回值组成一个数组，传递给p的回调函数。

- 只要p1、p2、p3之中有一个被rejected，p的状态就变成rejected，此时第一个被reject的实例的返回值，会传递给p的回调函数。

```js
const databasePromise = connectDatabase();

const booksPromise = databasePromise
  .then(findAllBooks);

const userPromise = databasePromise
  .then(getCurrentUser);

Promise.all([
  booksPromise,
  userPromise
])
.then(([books, user]) => pickTopRecommentations(books, user));
```

果作为参数的 Promise 实例，自己定义了catch方法，那么它一旦被rejected，并不会触发Promise.all()的catch方法。

> catch方法会让实例状态变为 resolved，因此 外面all的catch方法不会执行

### Promise.race()

Promise.race方法同样是将多个 Promise 实例，包装成一个新的 Promise 实例。

```js
const p = Promise.race([p1, p2, p3]);
```

上面代码中，只要p1、p2、p3之中有一个实例率先改变状态，p的状态就跟着改变。那个率先改变的 Promise 实例的返回值，就传递给p的回调函数。

### Promise.resolve()

有时需要将现有对象转为 Promise 对象，Promise.resolve方法就起到这个作用。

```js
const jsPromise = Promise.resolve($.ajax('/whatever.json'));
```

Promise.resolve方法的参数分成四种情况。

- 参数是一个 Promise 实例

原封不动返回

- 参数是一个thenable对象

thenable对象指的是具有then方法的对象，Promise.resolve方法会将这个对象转为 Promise 对象，然后就立即执行thenable对象的then方法。

- 参数不是具有then方法的对象，或根本就不是对象

如果参数是一个原始值，或者是一个不具有then方法的对象，则Promise.resolve方法返回一个新的 Promise 对象，状态为resolved。

- 不带任何参数

直接返回一个resolved状态的 Promise 对象。

> 需要注意的是，立即resolve的 Promise 对象，是在本轮“事件循环”（event loop）的结束时，而不是在下一轮“事件循环”的开始时。

```js
setTimeout(function () {
  console.log('three');
}, 0);

Promise.resolve().then(function () {
  console.log('two');
});

console.log('one');

// one
// two
// three
```

### Promise.reject()

Promise.reject(reason)方法也会返回一个新的 Promise 实例，该实例的状态为rejected。

```js
const p = Promise.reject('出错了');
// 等同于
const p = new Promise((resolve, reject) => reject('出错了'))

p.then(null, function (s) {
  console.log(s)
});
// 出错了
```

> Promise.reject()方法的参数，会原封不动地作为reject的理由，变成后续方法的参数。这一点与Promise.resolve方法不一致。

### Promise.try()

实际开发中，经常遇到一种情况：不知道或者不想区分，函数f是同步函数还是异步操作，但是想用 Promise 来处理它。因为这样就可以不管f是否包含异步操作，都用then方法指定下一步流程，用catch方法处理f抛出的错误。一般就会采用下面的写法。

```js
Promise.resolve().then(f)
```

让同步函数同步执行，异步函数异步执行，并且让它们具有统一的 API 呢？回答是可以的，并且还有两种写法。第一种写法是用async函数来写。

鉴于这是一个很常见的需求，所以现在有一个提案，提供Promise.try方法替代上面的写法。

```js
const f = () => console.log('now');
Promise.try(f);
console.log('next');
// now
// next
```

由于Promise.try为所有操作提供了统一的处理机制，所以如果想用then方法管理流程，最好都用Promise.try包装一下。

```js
Promise.try(database.users.get({id: userId}))
  .then(...)
  .catch(...)
```

事实上，Promise.try就是模拟try代码块，就像promise.catch模拟的是catch代码块。
