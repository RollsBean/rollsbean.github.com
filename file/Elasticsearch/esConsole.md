```shell script
GET assets_test2/_mapping
GET dtstack_assets_table/table/_count
DELETE /assets_test1/table/33
{}

GET /assets_test2/table/_mapping

PUT /dtstack_assets_table_v1/table/8193
{
    "updateAt": "2020-09-29 15:48:16",
    "extraAttr_0_6_7": {
        "attribute_id": 7,
        "attribute_name": "row_format",
        "attribute_type": 0,
        "attribute_value": "Dynamic",
        "field_type": 6,
        "attribute_name_cn": "行格式",
        "attribute_value_display": "Dynamic"
    },
    "createAt": "2020-08-19 21:14:09",
    "extraAttr_0_6_9": {
        "attribute_id": 9,
        "attribute_name": "row_count",
        "attribute_type": 0,
        "attribute_value": "75",
        "field_type": 6,
        "attribute_name_cn": "表行数",
        "attribute_value_display": "75"
    },
    "tableName": "da_project",
    "extraAttr_1_1_15": {
        "attribute_id": 15,
        "attribute_name": "manager",
        "attribute_type": 1,
        "attribute_value": "admin@dtstack.com",
        "field_type": 1,
        "attribute_name_cn": "负责人",
        "attribute_value_display": "admin@dtstack.com"
    },
    "dataSourceId": 11,
    "subModelId": 7,
    "dbId": 163,
    "id": 8193,
    "tableNameCn": "api项目表",
    "extraAttr_0_5_13": {
        "attribute_id": 13,
        "attribute_name": "create_time",
        "attribute_type": 0,
        "attribute_value": "2020-06-18 16:22:19",
        "field_type": 5,
        "attribute_name_cn": "创建时间",
        "attribute_value_display": "2020-06-18 16:22:19"
    },
    "syncDate": "2020-09-29 15:48:16",
    "extraAttr_0_7_11": {
        "attribute_id": 11,
        "attribute_name": "total_size",
        "attribute_type": 0,
        "attribute_value": "16384",
        "field_type": 7,
        "attribute_name_cn": "存储大小",
        "attribute_value_display": "16384"
    },
    "tableCreateAt": "2020-06-18 16:22:19",
    "tableStorage": 8193,
    "extraAttr_1_2_17": {
        "attribute_id": 17,
        "attribute_name": "tb_name_cn",
        "attribute_type": 1,
        "attribute_value": "api项目表",
        "field_type": 2,
        "attribute_name_cn": "表中文名",
        "attribute_value_display": "api项目表"
    },
    "extraAttr_0_6_3": {
        "attribute_id": 3,
        "attribute_name": "data_base",
        "attribute_type": 0,
        "attribute_value": "api",
        "field_type": 6,
        "attribute_name_cn": "数据库",
        "attribute_value_display": "api"
    },
    "extraAttr_0_6_5": {
        "attribute_id": 5,
        "attribute_name": "engine",
        "attribute_type": 0,
        "attribute_value": "InnoDB",
        "field_type": 6,
        "attribute_name_cn": "引擎",
        "attribute_value_display": "InnoDB"
    },
    "extraAttr_0_5_471": {
        "attribute_id": 471,
        "attribute_name": "recent_sync_time",
        "attribute_type": 0,
        "attribute_value": "2020-09-29 15:48:15",
        "field_type": 5,
        "attribute_name_cn": "最近同步时间",
        "attribute_value_display": "2020-09-29 15:48:15"
    },
    "tableOwner": 1,
    "extraAttr_0_6_1": {
        "attribute_id": 1,
        "attribute_name": "table_name",
        "attribute_type": 0,
        "attribute_value": "da_project",
        "field_type": 6,
        "attribute_name_cn": "表名",
        "attribute_value_display": "da_project"
    },
    "tenantId": 1,
    "dataSourceType": 1,
    "syncStatus": 1,
    "tableHot": 0
}



GET /dtstack_assets_table_v1/table/_search
{
  "query":{
    "match":{
      "id":8193
    }
  }
}



GET /dtstack_assets/table/_count
GET m6/doc/10

GET /assets_test2/table/_search?size=20
{
     "query": {
          "term": {
               "syncStatus": 8888
          }
     }
}

{
  "query":{
    "match_all": {}
  }
}


GET /assets_test1/table/_search
{
    "query": {
      "bool": {
        "must": [
          {
                    "range" : {
    "extraAttr_0_5_443.attributeValue": {
        "gte" : "2020-1-20 23:29:58",
        "lte" : "2020-8-20 23:29:58"
    }
}
                }
        ]
      }
    }
}

GET /assets_test2/_mapping

GET /assets_test2/table/_search?size=10&from=1000
{
    "query": {
        "bool": {
            "must": [
                {
                    "match": {
                        "dbId": "74"
                    }
                },
                {
                    "bool": {
                        "should": [
                            {
                                "match_phrase": {
                                    "tableNameCn": "贡"
                                }
                            },
                            {
                                "match": {
                                    "tableName": "igy"
                                }
                            }
                        ]
                    }
                },
                {
                    "range" : {
    "extraAttr_0_5_443.attributeValue": {
        "gte" : "2020-1-20 23:29:58",
        "lte" : "2020-8-20 23:29:58"
    }
}
                }
            ]
        }
    },
    "sort":{"extraAttr_0_5_655.attributeValue":"desc"}
}


GET /assets_test2/table/_search
{"from":0,"size":20,"query":{"bool":{"filter":[{"term":{"dataSourceId":{"value":6,"boost":1.0}}},{"term":{"dbId":{"value":74,"boost":1.0}}}],"adjust_pure_negative":true,"boost":1.0}},"sort":[{"createAt":{"order":"desc"}}]}

GET /assets_test2/table/_search
{"from":0,"size":10,"query":{"bool":{"filter":[{"term":{"dbId":{"value":74,"boost":1.0}}},{"term":{"dataSourceType":{"value":1,"boost":1.0}}}],"adjust_pure_negative":true,"boost":1.0}},"sort":[{"tableHot":{"order":"desc"}}]}

POST /assets_test2/table/_delete_by_query
{
  "query": {
    "bool": {
      "filter": [
        {
          "terms": {
            "_id": [
              3,
              23
            ],
            "boost": 1
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  }
}



GET /assets_test2/table/_search?size=10&from=10
{
    "query": {
        "bool": {
            "must": [
                {
                    "match": {
                        "dbId": "74"
                    }
                },
                {
                    "bool": {
                        "should": [
                            {
                                "match_phrase": {
                                    "tableNameCn": "贡"
                                }
                            },
                            {
                                "match": {
                                    "tableName": "igy"
                                }
                            }
                        ]
                    }
                },
                {
                    "range" : {
    "extraAttr_0_5_443.attributeValue": {
        "gte" : "2020-1-20 23:29:58",
        "lte" : "2020-8-20 23:29:58"
    }
}
                }
            ]
        }
    },
    "sort":{"extraAttr_0_5_655.attributeValue":"desc"}
}




POST /_bulk
{ "index":{ "_index": "assets_test2", "_type": "table", "_id": "1" }}
{"dbName":"aaa","tableName":"test_table","dataSourceId":5,"deleted":false,"id":1,"tableNameCn":"表中文名","dataSourceType":7}
{ "index":{ "_index": "assets_test2", "_type": "table", "_id": "2" }}
{"dbName":"aaa","tableName":"test_table","dataSourceId":5,"deleted":false,"id":2,"tableNameCn":"表中文名","dataSourceType":7}

GET /assets_test2/table/_search
{
  "query": {
    "match": {
      "id": "2"
    }
  }
}



GET /assets_test2/table/_search
{"from":100,"size":10,"query":{"bool":{"filter":[{"term":{"dbId":{"value":54,"boost":1.0}}},{"term":{"dataSourceType":{"value":1,"boost":1.0}}},{"term":{"dataSourceId":{"value":11,"boost":1.0}}}],"adjust_pure_negative":true,"boost":1.0}},"sort":[{"extraAttr_0_5_655.attributeValue":{"order":"desc"}}]}

GET /assets_test2/table/_search
{
  "from": 0,
  "size": 10,
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "dbId": {
              "value": 54,
              "boost": 1
            }
          }
        },
        {
          "term": {
            "dataSourceType": {
              "value": 1,
              "boost": 1
            }
          }
        },
        {
          "term": {
            "dataSourceId": {
              "value": 11,
              "boost": 1
            }
          }
        },
        {
          "bool": {
            "should": [
              {
                "match_phrase": {
                  "tableNameCn": {
                    "query": "田",
                    "slop": 0,
                    "zero_terms_query": "NONE",
                    "boost": 1
                  }
                }
              },
              {
                "match": {
                  "tableName": {
                    "query": "tb",
                    "operator": "OR",
                    "prefix_length": 0,
                    "max_expansions": 50,
                    "fuzzy_transpositions": true,
                    "lenient": false,
                    "zero_terms_query": "NONE",
                    "auto_generate_synonyms_phrase_query": true,
                    "boost": 1
                  }
                }
              }
            ],
            "adjust_pure_negative": true,
            "boost": 1
          }
        },
        {
          "range": {
            "extraAttr_0_5_443.attributeValue": {
              "from": "2020-1-20 23:29:58",
              "to": "2020-8-20 23:29:58",
              "include_lower": true,
              "include_upper": true,
              "boost": 1
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "sort": [
    {
      "extraAttr_0_5_655.attributeValue": {
        "order": "desc"
      }
    }
  ]
}


GET /assets_test2/table/_search
{
  "size":10,
  "from":1000,
  "query": {
    "match_all": {}
  },
  "sort": {
     "tableHot": {
        "order": "desc"
      }
  }
}

GET /assets_test1/table/_search
{
  "query": {
    "match_all": {}
  }
}
GET /assets_test1/table/_search
{
  "query":{
    "match": {
      "_id": 2704
    }
  }
}
POST /assets_test1/table/2708/_update
{
  "doc":{
   "dbName": "update_test",
   "syncDate":"aaa"
  }
}


GET /assets/table/_search
{
  "query": {
    "term":{
    "tableHot": "103"}
  }
}

GET /assets/table/_search
{
  "query": {
    "wildcard": {
      "dbName": "*ing*"
    }
  }
}

GET /assets/table/_search
{
  "query": {
      "match_phrase":{
      "dbName": "test"
      }
  }
}

GET _mapping



# ddd
PUT /assets/_alias/dtstack_assets

POST /assets/table
{"id":"11057","tableName":"liu","tableNameCn":"血缘测试专用表","dataSourceId":"13","syncStatus":1,"syncDate":null,"dbId":"239","dbName":"liuxing_test","tableStorage":"0","tableOwner":"9","tableOwnerName":"hanjiang@dtstack.com","tableHot":"400","attributes":[],"tableCreateAt":null,"dataSourceType":27}


POST /_aliases
{
    "actions": [
        { "remove": { "index": "assets_test1", "alias": "dtstack_assets" }},
        { "add":    { "index": "assets_test2", "alias": "dtstack_assets" }}
    ]
}

# 分词器测试
GET _analyze			
{
    "analyzer": "standard", 
    "text": "狄葛幸彭利方麹毕"
}

GET _analyze			
{
    "analyzer":{
            "my_analyzer":{
               "tokenizer":"my_tokenizer"
            }
         },
         "tokenizer":{
            "my_tokenizer":{
               "type":"ngram",
               "min_gram":2,
               "max_gram":10,
               "token_chars":[
                  "letter",
                  "digit"
               ]
            }
         },
    "text": "狄葛幸彭利方麹毕"
}


PUT m9
{
  "mappings": {
    "doc":{
      "properties": {
        "name": {
          "type": "text"
        },
        "age": {
          "type": "long"
        },
        "date":{
          "type":"date",
          "format":"yyyy-MM-dd HH:mm:ss.S||epoch_millis"
        }
      }
    }
  }
}
PUT m9/doc/1
{
  "date":"2020-8-9 12:20:30"
}

PUT m2
{
  "mappings": {
    "doc":{
      "dynamic" : "true",
      "properties": {
        "name": {
          "type": "text"
        },
        "age": {
          "type": "long"
        }
      }
    }
  }
}
GET m6/_doc/5
PUT m6/doc/5
{
  "name": "小白",
  "age": 19
}


GET m6/_doc/1
GET m3/_mapping
POST m6/doc/1/_update
{
  "doc":{
   "sex": "男",
   "extraAttr_0_5_3":null
  }
}


POST m6/_update_by_query
{
  "script": {
    "source": "ctx._source.age++",
    "lang": "painless"
  },
  "query": {
    "term": {
      "_id": 1
    }
  }
}

POST m6/_update_by_query
{
  "script": {
    "source": "ctx._source.extraAttr_0_5_3= params.mifieldAsParam",
    "params":{
      "mifieldAsParam":{
        "attributeValue":"2020-09-27 23:37:16",
        "updateByQuery":"yes"
      }
    },
    "lang": "painless"
  },
  "query": {
    "term": {
      "_id": 1
    }
  }
}
POST m6/_update_by_query
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "age": {
              "boost": 1,
              "value": "19"
            }
          }
        },
        {
          "term": {
            "sex": {
              "boost": 1,
              "value": "男"
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "script": {
    "source": "ctx._source.extraAttr_0_5_3= params.mifieldAsParam",
    "lang": "painless",
    "params": {
      "dbName": "name",
      "mifieldAsParam": "data"
    }
  }
}
GET m6/doc/1
POST m6/_update_by_query
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "sex": {
              "boost": 1,
              "value": "男"
            }
          }
        },
        {
          "term": {
            "age": {
              "boost": 1,
              "value": 19
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "script": {
    "source": """ctx._source.dbName = \"name\";ctx._source.extraAttr_0_5_443 = params.extraAttr_0_5_443;""",
    "lang": "painless",
    "params": {
      "extraAttr_0_5_443": "data"
    }
  }
}

POST m6/_update_by_query
{
  "query": {
    "bool": {
      "filter": [
        {
          "term": {
            "sex": {
              "boost": 1,
              "value": "男"
            }
          }
        },
        {
          "term": {
            "age": {
              "boost": 1,
              "value": 19
            }
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  },
  "script": {
    "source": """ctx._source.dbName = "test";ctx._source.extraAttr_0_5_443 = params.extraAttr_0_5_443;""",
    "lang": "painless",
    "params": {
      "extraAttr_0_5_443": "data"
    }
  }
}


{"query":{"bool":{"filter":[{"term":{"sex":{"boost":1.0,"value":"男"}}},{"term":{"age":{"boost":1.0,"value":23}}}],"adjust_pure_negative":true,"boost":1.0}},"script":{"source":"ctx._source.dbName = \\\"name\\\";ctx._source.extraAttr_0_5_443 = params.extraAttr_0_5_443;","lang":"painless","params":{"extraAttr_0_5_443":"data"}}}

{"query":{"bool":{"filter":[{"term":{"sex":{"boost":1.0,"value":"男"}}},{"term":{"age":{"boost":1.0,"value":23}}}],"adjust_pure_negative":true,"boost":1.0}},"script":{"source":"ctx._source.dbName = \\\"name\\\";ctx._source.extraAttr_0_5_443 = params.extraAttr_0_5_443;","lang":"painless","params":{"extraAttr_0_5_443":"data"}}}

{"query":{"bool":{"filter":[{"term":{"sex":{"boost":1.0,"value":"男"}}},{"term":{"age":{"boost":1.0,"value":23}}}],"adjust_pure_negative":true,"boost":1.0}},"script":{"source":"ctx._source.dbName = \\\"name\\\";ctx._source.extraAttr_0_5_443 = params.extraAttr_0_5_443;","lang":"painless","params":{"extraAttr_0_5_443":"data"}}}

PUT /m6/_alias/m
GET /m6/_mapping
PUT m/doc/1
{
  "name": "小黑",
  "age": 18,
  "sex": "不详",
  "extraAttr_0_5_3":{
    "attributeValue":"2020-09-17 23:37:16"
  }
}
GET /m4/_mapping
#extraAttr_0_5_443
PUT /m4
{
  "mappings": {
    "_default_": {
      "date_detection": true,
      "dynamic_templates": [
        {
          "dates": {
            "match": ".*Date|date",
            "match_pattern": "regex",
            "mapping": {
              "type": "date",
              "format": "yyyy-MM-dd HH:mm:ss||dateOptionalTime"
            }
          }
        },
        {
          "attr":{
            "match": "extraAttr*",
            "match_pattern": "regex",
            "mapping": {
              "type": "nested"
            }
          }
        }
      ]
    },
    "doc":{
      "dynamic" : "true",
      "properties": {
        "name": {
          "type": "text"
        },
        "age": {
          "type": "long"
        }
      }
    }
  }
}





PUT /m7
{
  "mappings": {
    "_default_": {
      "date_detection": true,
      "dynamic_date_formats": ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss.SSS"],
      "dynamic_templates": [
        {
          "attr":{
            "match": "extraAttr*",
            "match_pattern": "regex",
            "mapping": {
              "type": "nested"
            }
          }
        }
      ]
    },
    "doc":{
      "dynamic" : "true",
      "properties": {
        "name": {
          "type": "text"
        },
        "age": {
          "type": "long"
        }
      }
    }
  }
}



PUT /m6
{
  "mappings": {
    "_default_": {
      "date_detection": true,
      "dynamic_templates": [
        {
          "dates": {
            "path_match":"extraAttr_[\\d]_5_[\\d]+.attributeValue(Display)?",
            "match_pattern": "regex",
            "mapping": {
              "type": "date",
              "format": "yyyy-MM-dd HH:mm:ss||dateOptionalTime"
            }
          }
        },
        {
          "attr":{
            "match": "extraAttr*",
            "match_pattern": "regex",
            "mapping": {
              "type": "nested"
            }
          }
        }
      ]
    },
    "doc":{
      "dynamic" : "true",
      "properties": {
        "name": {
          "type": "text"
        },
        "age": {
          "type": "long"
        }
      }
    }
  }
}



PUT /m5
{
  "mappings": {
    "_default_": {
      "date_detection": true
    },
    "doc":{
      "dynamic" : "true",
      "properties": {
        "name": {
          "type": "text"
        },
        "age": {
          "type": "long"
        }
      }
    }
  }
}

POST m2/doc
{
  "name": "小黑",
  "age": 18,
  "4534":89
}

GET m7/_mapping
GET m6/_search
{
   "query":{
     "bool": {
      "must": [
        {
        "match":{
         "age":18
        }
        },
        {"range" : {
    "extraAttr_0_5_3.attributeValue": {
        "gte" : "2020-1-20 23:29:58",
        "lte" : "2020-10-20 23:29:58"
    }
}}
      ]
     
   }
   },
   "sort":{
         "age":"desc"
   }
}
GET m6/_mapping
GET m6/_search
{
  "query": {
    "match_all": {}
  }
}


GET /assets_column_test2/_mapping



PUT my_date
{
  "mappings": {
    "_doc": {
      "properties": {
        "date": {
          "type": "date" 
        }
      }
    }
  }
}

PUT my_date2/_doc/1
{ "date": "2015-01-01" } 

PUT my_date2/_doc/2
{ "date": "2015-01-01T12:10:30Z" } 

PUT my_date2/_doc/2
{ "date": "2015-01-01 12:10:30" } 

PUT my_date2/_doc/3
{ "date": 1420070400001 } 

GET my_date2/_search
{
  "sort": { "date": "asc"} 
}
GET my_date3/_mapping
PUT my_date3
{"mappings":{"_doc":{"properties":{"date":{"type":"date","format":"yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"}}}}}

,
          "token_chars": [
                        "letter",
                        "digit",
                        "whitespace",
                        "punctuation",
                        "symbol"
                    ]
                    
                    

DELETE /m8
PUT m8
{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_analyzer": {
          "tokenizer": "my_tokenizer",
          "token_chars": [
                        "letter",
                        "digit",
                        "whitespace",
                        "punctuation",
                        "symbol"
                    ],
          "custom_token_chars":"."
        },
        "cn_analyzer": {
          "tokenizer": "cn_tokenizer",
          "filter": "lowercase"
        }
      },
      "tokenizer": {
        "my_tokenizer": {
          "type": "ngram",
          "min_gram": 1,
          "max_gram": 6
        },
        "cn_tokenizer": {
          "type": "pattern",
          "pattern": "|"
        }
      }
    },
    "max_ngram_diff": 10
  },
  "mappings": {
    "table": {
      "properties": {
        "dataSourceId": {
          "type": "long"
        },
        "dataSourceType": {
          "type": "integer"
        },
        "dbName": {
          "type": "text",
          "analyzer": "my_analyzer",
          "fields": {
            "keyword": {
              "type": "keyword",
              "ignore_above": 256
            }
          }
        }
      }
    }
  }
}


PUT /m8/table/1
{
  "dataSourceId":1,
  "dataSourceType":2,
  "dbName":"rm.rf"
}

PUT /m8/table/2
{
  "dataSourceId":1,
  "dataSourceType":2,
  "dbName":"rm_rf"
}
PUT /m8/table/3
{
  "dataSourceId":1,
  "dataSourceType":2,
  "dbName":"rmrf"
}
PUT /m8/table/4
{
  "dataSourceId":1,
  "dataSourceType":2,
  "dbName":"ttrf"
}

GET /m8/_settings
GET /m8/_mapping
GET /m8/table/3

GET /m8/table/_search
{
  "query": {
    "match_phrase": {
      "dbName": {
           "query": "rm.",
           "analyzer": "standard"
         }
    }
  }
}

POST m8/_analyze
{
  "tokenizer": "my_tokenizer",
  "text": "ttrf"
}

```