# CSSOM

JS通过 `CSSOM` API 操作 CSSRuleTree，本文总结了操作的方式、方法。

> el = getElementById('xxx')

- 通过DOM节点对象的style对象（即 CSSStyleDeclaration）
  - 改
    - el.style.color = 'red'
    - el.style.cssText += ';color:red;line-height:50px;' （DOM2）
    - el.style.setProperty('color', 'red', 'important') （DOM2）
  - 查
    - el.style.color
    - el.style.cssText （DOM2）
    - el.style.getPropertyValue （DOM2）
  - 删
    - el.style.removeProperty('color') （DOM2）
- 通过 element 对象的方法
  - 改：el.setAttribute('style', 'color:red;line-height:50px;')
  - 查：el.getAttribute('style')
  - 删：el.removeAttribute('style')
- 通过 document.styleSheets属性
  - document.styleSheets[0].insertRule('#test:hover{color: white;}',0)
-

> `style`对象是`CSSStyleDeclaration`的实例

> 对属性`Property`可以赋任何类型的值，而对特性`Attribute`只能赋值字符串
