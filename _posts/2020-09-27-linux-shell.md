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


#### 问题

```shell script
reindexTableJson='{
  "source": {
    "index": "dtstack_assets_table_v1"
  },
  "dest": {
    "index": "dtstack_assets_table_v2"
  }
}'
http_code=$(curl -sSL -w '%{http_code}' ${curlParamU} -o ./response5.txt -XPOST "${url}/_reindex" -H 'Content-Type: application/json' -d ${reindexTableJson})
```

```shell script
curl: (6) Could not resolve host: "source"
curl: (3) unmatched brace in URL position 1:
{
 ^
curl: (6) Could not resolve host: "index"
curl: (6) Could not resolve host: "dtstack_assets_column_v1"
curl: (3) unmatched close brace/bracket in URL position 1:
},
 ^
curl: (6) Could not resolve host: "dest"
curl: (3) unmatched brace in URL position 1:
{
 ^
curl: (6) Could not resolve host: "index"
curl: (6) Could not resolve host: "dtstack_assets_column_v2"
curl: (3) unmatched close brace/bracket in URL position 1:
}
 ^
curl: (3) unmatched close brace/bracket in URL position 1:
}
 ^
./increment_v2.sh: line 138: [: 500000000000000000000: integer expression expected
method: reindex4Column
 将数据迁入新索引dtstack_assets_column_v2失败}
{"error":{"root_cause":[{"type":"json_e_o_f_exception","reason":"Unexpected end-of-input: expected close marker for Object (start marker at [Source: org.elasticsearch.transport.netty4.ByteBufStreamInput@9b43f7f; line: 1, column: 1])\n at [Source: org.elasticsearch.transport.netty4.ByteBufStreamInput@9b43f7f; line: 1, column: 3]"}],"type":"json_e_o_f_exception","reason":"Unexpected end-of-input: expected close marker for Object (start marker at [Source: org.elasticsearch.transport.netty4.ByteBufStreamInput@9b43f7f; line: 1, column: 1])\n at [Source: org.elasticsearch.transport.netty4.ByteBufStreamInput@9b43f7f; line: 1, column: 3]"},"status":500}
```

原因： `-d ${reindexTableJson}` 未加引号 修改为 `-d "${reindexTableJson}"`