---
layout: post
title:  "Java  线程池"
date:   2019-05-26 12:20:00 +8:00
categories: java
tags: java AbstractQueuedSynchronizer AQS
author: Kevin Fan
---

* content
{:toc}



<!-- more -->

线程池四种拒绝策略：
CallerRunsPolicy: 直接在请求的线程中运行
AbortPolicy: 直接抛出RejectedExecutionException异常
DiscardPolicy: 丢弃任务
DiscardOldestPolicy: 丢弃最老的任务
