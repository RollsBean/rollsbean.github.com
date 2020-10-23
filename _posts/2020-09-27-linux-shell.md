---
layout: post
title:  "Shell 入门"
date:   2018-09-27 15:25:05 +8
categories: Shell
tags: Shell Linux Bath
author: Kevin Fan
---

* content
{:toc}

Shell脚本
<!-- more -->

### 介绍
Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。
[RUNOOB.COM Shell 教程](https://www.runoob.com/linux/linux-shell.html)

### Linux 基本命令

### Shell基本语法

#### 创建脚本

创建文件test.sh，扩展名为 `sh`,写下如下代码保存，运行脚本 `sh test.sh` 或者 `./test.sh`
```shell script
#!/bin/bash
echo "Hello World !"
```
#### 变量

格式为 *变量名=变量值*, 等号前后*不能有空格*， 变量名的规范和Java类似。
```shell script
your_name="rollsbean.com"
```
使用时，变量名前加 `$`, 花括号可加可不加，当需要和后面的字符串隔开时要加花括号
```shell script
echo $your_name
echo ${your_name}
# 为了与后面的 678区别开，加花括号，否则被认为是变量 your_name678
echo "${your_name}678"
```



### Shell使用

