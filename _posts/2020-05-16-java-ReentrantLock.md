---
layout: post
title:  "Java ReentrantLock 可重入锁"
date:   2019-05-16 09:20:00 +8:00
categories: java
tags: java ReentrantLock AQS
author: Kevin Fan
---

* content
{:toc}



<!-- more -->

ReentrantLock lock() 加锁的执行顺序：
 1. 用cas的方式`compareAndSetState(0, 1)`去将state从0改为1, 如果成功，则将独占线程设置为当前线程，
 如果失败，则调用AQS的`acquire(1)`方法去尝试获取锁，直到获取了锁
 2.acquire() 方法首先调用tryAcquire()
