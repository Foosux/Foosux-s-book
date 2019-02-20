# JS中的eventLoop
<!-- toc -->

> enentLoop决定了JS的执行顺序

## 任务队列

不同的任务源会被分配到不同的任务队列中，任务源可以分为 `微任务`（microtask）和 `宏任务`（macrotask）。在 ES6 规范中，microtask 称为 `jobs`，macrotask 称为 `task`。

### 宏任务

- script
- setTimeout
- setInterval
- setImmediate
- I/O
- UI rendering
- xhr

### 微任务

- process.nextTick
- promise
- Object.observe
- MutationObserver


## 浏览器中的 eventLoop

浏览器中一次`EventLoop` 顺序是这样的：

![](https://ws4.sinaimg.cn/large/006tKfTcly1g0crlibeipj30g909xjsb.jpg)

- 执行同步代码，这属于宏任务
- 执行栈为空，查询是否有微任务需要执行
- 执行所有微任务
- 必要的话渲染 UI
- 然后开始下一轮 eventLoop，执行宏任务中的异步代码

> 如果宏任务中的异步代码有大量的计算并且需要操作 DOM 的话，为了更快的界面响应，我们可以把操作 DOM 放入微任务中。

## node中的 eventLoop

```js
┌───────────────────────┐
┌─>│        timers         │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
│  │     I/O callbacks     │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
│  │     idle, prepare     │
│  └──────────┬────────────┘      ┌───────────────┐
│  ┌──────────┴────────────┐      │   incoming:   │
│  │         poll          │<──connections───     │
│  └──────────┬────────────┘      │   data, etc.  │
│  ┌──────────┴────────────┐      └───────────────┘
│  │        check          │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
└──┤    close callbacks    │
   └───────────────────────┘
```

### TIMER

timers 阶段会执行到期的 `setTimeout` 和 `setInterval`

### I/O

I/O 阶段会执行除了 `close`事件，`定时器` 和 `setImmediate` 的回调。包含文件，网络等等。

### IDLE, PREPARE

idle, prepare 阶段内部实现

### POLL

poll 阶段很重要，这一阶段中，系统会做两件事情：

- 执行到点的定时器
- 执行 `poll队列` 中的事件

### CHECK

check 阶段执行 `setImmediate`

### CLOSE CALLBACKS

close callbacks 阶段执行 `close事件`

## 注意事项

```js
setTimeout(() => {
  console.log('timer1')

  Promise.resolve().then(function() {
    console.log('promise1')
  })
}, 0)

setTimeout(() => {
  console.log('timer2')

  Promise.resolve().then(function() {
    console.log('promise2')
  })
}, 0)

// 以上代码在浏览器和 node 中打印情况是不同的
// 浏览器中打印 timer1, promise1, timer2, promise2
// node 中打印 timer1, timer2, promise1, promise2
```

> Node 中的 process.nextTick 会先于其他 `microtask` 执行

```js
setTimeout(() => {
  console.log('timer1')

  Promise.resolve().then(function() {
    console.log('promise1')
  })
}, 0)

process.nextTick(() => {
  console.log('nextTick')
})
// nextTick, timer1, promise1
```

### 问题

> node中无法保证`setTimeout`和`setImmediate`的回调的执行顺序。

关键在于setTimeout何时到期，只有到期的`setTimeout`才能保证在`setImmediate`之前执行。

> 高优先级的代码可以用Promise/process.nextTick注册执行。

jobs优先于task执行。那如果有需要优先执行的逻辑，放入microtask队列会比macrotask更早的被执行，这个特性可以被用于在框架中设计任务调度机制。

> 如果对执行效率有要求，优先使用process.nextTick和setImmediate

从node的实现来看，setTimeout这种timer类型的API，需要创建定时器对象和迭代等操作，任务的处理需要操作小根堆，时间复杂度为O(log(n))。而相对的，process.nextTick和setImmediate时间复杂度为O(1)，效率更高。

## 参考

- [几道高级前端面试题解析](https://yuchengkai.cn/几道高级前端面试题解析)
