# session机制

> http本身是无状态的请求，但实际应用中我们需要确定用户身份或者跟踪会话。本文主要讲解session的使用方法。

除了使用Cookie，Web应用程序中还经常使用Session来记录客户端状态。Session是`服务器端使用`的一种记录客户端状态的机制，使用上比Cookie简单一些，相应的也增加了服务器的存储压力。

把数据放到cookie中是不可取的，但是我们可以将口令放在cookie中的，比如cookie中常见的会放入一个sessionId,该sessionId会与服务器端之间会产生映射关系，如果sessionId被篡改的话，那么它就不会与服务器端数据之间产生映射，因此安全性就更好，并且session的有效期一般比较短，一般都是设置是20分钟，如果在20分钟内客户端与服务端没有产生交互，服务端就会将数据删除。

## 创建

## Session的生命周期

## Session的常用方法

## Session对浏览器的要求

## Cookie与Session的区别
