# 前端性能优化基础

- DNS解析阶段
  - 预解析
- 资源加载
  - 利用缓存
  - 利用cdn
  - 文件优化
    - 图片
      - 减少图片使用
      - 减少图片体积
      - 选择正确的图片格式
      - 小图使用 base64 格式
      - 雪碧图
    - 其他
      - 服务端开启文件压缩功能
      - Webpack
        - 开启 `tree shaking`
      - 按照路由拆分代码，实现按需加载
      - CSS 文件放在 head 中
      - JS 放在 body 底部，或者加上 `defer`，无依赖加上 `async`，需要很多时间计算的代码可以考虑使用 `Webworker`
- 浏览器渲染阶段
  - 懒执行
  - 懒加载
  - 减少重绘重排
    - 使用代码片段 document.createDocumentFragment()

## DNS预解析

DNS 解析也是需要时间的，可以通过预解析的方式来预先获得域名所对应的 IP。

```js
<link rel="dns-prefetch" href="//yuchengkai.cn" />
```

![](https://ws3.sinaimg.cn/large/006tKfTcly1g0im4tu5vwj31xy0bm0v8.jpg)

## CDN

静态资源尽量使用 CDN 加载，由于浏览器对于单个域名有并发请求上限，可以考虑使用多个 CDN 域名。对于 CDN 加载静态资源需要注意 CDN 域名要与主站不同，否则每次请求都会带上主站的 Cookie。

## 资源预加载

### preload

预加载其实是声明式的 fetch ，强制浏览器请求资源，并且不会阻塞 onload 事件，可以使用以下代码开启预加载。

```js
<link rel="preload" href="http://example.com" />
```

![](https://ws3.sinaimg.cn/large/006tKfTcly1g0im602f3fj31xo0bg41a.jpg)

## 预渲染

可以通过预渲染将下载的文件预先在后台渲染，可以使用以下代码开启预渲染

```js
<link rel="prerender" href="http://example.com" />
```

![](https://ws3.sinaimg.cn/large/006tKfTcly1g0im9n5pjyj31xc09q76i.jpg)

## 懒执行

懒执行就是将某些逻辑延迟到使用时再计算。该技术可以用于首屏优化，对于某些耗时逻辑并不需要在首屏就使用的，就可以使用懒执行。懒执行需要唤醒，一般可以通过定时器或者事件的调用来唤醒。

# 懒加载

懒加载就是将不关键的资源延后加载。

懒加载的原理就是只加载自定义区域（通常是可视区域，但也可以是即将进入可视区域）内需要加载的东西。对于图片来说，先设置图片标签的 src 属性为一张占位图，将真实的图片资源放入一个自定义属性中，当进入自定义区域时，就将自定义属性替换为 src 属性，这样图片就会去下载资源，实现了图片懒加载。

懒加载不仅可以用于图片，也可以使用在别的资源上。比如进入可视区域才开始播放视频等等。

## 参考资料

![正确使用图片格式](https://www.jianshu.com/p/261cd13757ce)
![谈谈web安全色](https://www.jianshu.com/p/6ec9f261ee70)
