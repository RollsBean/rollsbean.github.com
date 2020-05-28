---
layout: post
title:  "Java ArrayBlockingQueue 源码分析"
date:   2019-05-15 15:20:00 +8:00
categories: java
tags: java ArrayBlockingQueue queue
author: Kevin Fan
---

* content
{:toc}

`ArrayBlockingQueue`队列在Java项目中经常被用到，就算平时没有直接调用但是很多常用的API都涉及到了队列，
比如线程池`ThreadPoolExecutor` 消息队列等。 本篇文章将从队列源码出发，分析其源码和作用。

<!-- more -->

### 简述

队列是一种先进先出的特殊线性表，一般只能从表的头出尾进，`ArrayBlockingQueue`是一个基于数组的阻塞队列。

#### 先看类图结构

如下图所示，`ArrayBlockingQueue`的顶层接口也是`Collection`,并直接实现了`BlockingQueue`.

![ArrayBlockQueue类图结构](/images/queue/ArrayBlockingQueue%20structure.PNG)

### 源码分析

#### 构造器

队列的容量是必须提供的参数，第一个参数是队列的长度，第二个参数是否使用公平锁
```java
/** 这里默认使用非公平锁，所以第二个参数值是false */
public ArrayBlockingQueue(int capacity) {
    this(capacity, false);
}
/** 我们也可以指定是否使用公平锁 */
public ArrayBlockingQueue(int capacity, boolean fair) {
    if (capacity <= 0)
        throw new IllegalArgumentException();
    this.items = new Object[capacity];
    lock = new ReentrantLock(fair);
    // notEmpty是Condition对象，主要用来唤醒等待出队的线程
    notEmpty = lock.newCondition();
    // notFull是Condition对象，主要用来唤醒等待入队的线程
    notFull =  lock.newCondition();
}
```







