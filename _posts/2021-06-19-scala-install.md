---
layout: post
title:  "MacOS 安装 Scala"
date:   2021-06-19 11:25:05 +8
categories: Scala
tags: Scala Java
author: Kevin Fan
---

* content
{:toc}


Scala 是一门多范式（multi-paradigm）的编程语言，设计初衷是要集成面向对象编程和函数式编程的各种特性。

Scala 运行在 Java 虚拟机上，并兼容现有的 Java 程序。

Scala 源代码被编译成 Java 字节码，所以它可以运行于 JVM 之上，并可以调用现有的 Java 类库。

参考菜鸟教程：[https://www.runoob.com/scala/scala-tutorial.html](https://www.runoob.com/scala/scala-tutorial.html)
<!-- more -->

## 安装包下载

当前最新的两个版本是 `3.0.0` 和 `2.13.6`，两个版本不兼容，如果想下载之前的版本，点击下面的 _All Previous Releases_。
![scala download homepage](../images/scala/scala%20download%20homepage.jpg)

我选择了 `2.12.14` 版本，安装之前要确保 Java 已经安装

点击如下链接会直接下载。
![scala download](../images/scala/scala%20download.png)

## 配置环境变量

编辑 `~/.bash_profile` 配置文件并添加如下配置

```shell
export SCALA_HOME=/Users/kevin/scala-2.12.14
export PATH=$JAVA_HOME/bin:$SCALA_HOME/bin:$PATH
```

## 验证

输入 scala 如果进入到 scala 交互界面，表明已经安装成功，最后输入 _:quit_ 退出程序

```shell
kevin@medeMacBook-Pro conf % scala
Welcome to Scala 2.12.14 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_291).
Type in expressions for evaluation. Or try :help.

scala> 1+1
res0: Int = 2

scala> :quit
kevin@medeMacBook-Pro conf %
```

