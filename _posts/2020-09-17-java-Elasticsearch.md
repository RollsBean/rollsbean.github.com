---
layout: post
title:  "Elasticsearch 入门"
date:   2018-09-17 11:25:05 +8
categories: Elasticsearch
tags: Elasticsearch Lucene Kibana ELK Java
author: Kevin Fan
---

* content
{:toc}

Elasticsearch 是一款开源的分布式文档搜索引擎，建立在一个全文搜索引擎库 [Apache Lucene™](https://lucene.apache.org/core/) 基础之上。
Elasticsearch 使用Java编写，可扩展，支持PB级的结构化或非结构化数据。

[Elasticsearch Git Repo](https://github.com/elastic/elasticsearch.git)
<!-- more -->

### 使用Elasticsearch 的动机

使用Mysql作为数据存储时，如果数据量达到百万级，查询效率会很差，尤其是在复杂查询条件下，而且我们的查询还需要支持模糊匹配，不管是前缀还是后缀都需要支持

### Elasticsearch 本地环境搭建

#### Elasticsearch环境搭建

#### Kibana(ES的web管理页面)环境搭建


### Elasticsearch 的数据结构

### ES基本增删改查

#### 创建第一个索引

参考：[Elasticsearch Reference [6.8] » Indices APIs » Put Mapping](https://www.elastic.co/guide/en/elasticsearch/reference/6.8/indices-put-mapping.html)

创建索引（库）m1, _type即表名为doc
```shell script
PUT /m1
{
  "mappings": {
    "doc": {
      "properties": {
        "id": {
          "type": "long"
        },
        "name": {
          "type": "text"
        }
      }
    }
  }
}
```

#### 插入数据

使用PUT方法，向m1/doc中插入数据，可以指定文档的_id，也可以不填_id，不填_id es会创建唯一id
```shell script
PUT /m1/doc/1
{
  "id":1,
  "name":"table"
}
PUT /m1/doc/2
{
  "id":2,
  "name":"ming"
}
PUT /m1/doc/3
{
  "id":3,
  "name":"ming",
  "age": 17
}
```

#### 执行简单查询

根据主键id查询
```shell script
GET /m1/doc/3
```
根据query查询, url格式为`/index/_type/_search`,请求体以`query`开头

例： 查询id=2的数据
```shell script
GET /m1/doc/_search
{
  "query": {
    "match": {
      "id": "2"
    }
  }
}
```
**多条件组合查询**
如果是多个条件查询需要使用 `bool`查询语句，`bool`查询可以将多个条件组合在一起使用,bool内可以使用 `must`,`should`,`must_not`等参数

参考：[Elasticsearch 全文搜索 » 组合查询](https://www.elastic.co/guide/cn/elasticsearch/guide/current/bool-query.html)

例：查询name="ming"并且id=2的文档
```shell script
GET /m1/doc/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "id": 2
          }
        },
        {
          "match": {
            "name": "ming"
          }
        }
      ]
    }
  }
}
```

**排序和分页**
使用排序功能,在query同级下添加 `sort`参数,值为 `desc`倒序和`asc`正序

例：查找name= "ming"，并且按照id倒序排列
```shell script
GET /m1/doc/_search
{
  "query": {
    "match": {
      "name": "ming"
    }
  },
  "sort":{
    "id":"desc"
  }
}
```

分页,ES默认一页显示20, 分页参数 `from`从第几条开始，从0开始，`size`一页数量是多少，默认20

例：一页显示5条，第一页的分页
```shell script
GET /m1/doc/_search
{
  "query": {
    "match": {
      "name": "ming"
    }
  },
  "sort":{
    "id":"desc"
  },
  "from": 0,
  "size": 5
}
```


### ES 使用进阶

#### 查询使用自定义分词器

#### ES 重建索引

#### ES 创建索引别名

#### ES _bulk 批量执行操作

### ES 更新机制

#### 

### ES 使用深入

#### `_update_by_query`更新

1. 根据条件更新字段

2. 根据条件删除文档的指定属性
```shell script
POST /m1/_update_by_query
{
  "script": "ctx._source.remove('name');ctx._source.remove('age');",
  "query": {
    "match": {
      "id": 3
    }
  }
}
```

#### es script使用

#### delete by query删除

#### 插入数据的策略

#### shell 脚本初始化es索引



### ES 排序和相关性

### ES 分片原理
