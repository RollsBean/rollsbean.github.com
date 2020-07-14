---
layout: post
author: Kevin Fan
title:  "SpringMVC"
date:   2020-06-27 14:20:00 +8
categories: Java
tags: Java SpringMVC
---

* toc
{:toc}


SpringMVC 

<!-- more -->

### SpringMVC 加载

1. SpringMVC的请求先有 `DispacherServlet`处理（前端控制器），它将请求传给映射处理器 `HandlerMapping`，请求被映射成chain，里面有多个
`HandlerIntercepter`，通过这种策略模式，很容易增加新的映射处理器。
2. `DispacherServlet`调用 `HandlerAdapter`，根据不同的适配器，找到对应的处理器（`Controller`），并返回 `ModelAndView`对象。
3. `DispacherServlet`将`ModelAndView`发送到 `ViewResolver`(视图解析器)
4. 渲染视图，并且返回到`DispacherServlet`，最后由它返回给用户。

### SpringMVC 参数加载方式

利用注解+反射的方式将前端传来的string反序列化为Controller里的参数对象。

#### @RequestParam 如何利用反射将请求参数映射到controller的参数里的




