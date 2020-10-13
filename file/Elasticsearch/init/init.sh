#!/bin/bash

# ##################################
# ES 脚本
# 执行时需要指定ES的url和用户名，用户名非必填
# 执行方式 ./create.sh ${url} [${username}]， 比如：./create.sh http://localhost:9200
# ##################################
assets_table_index=@json/assets_table_index.json
assets_column_index=@json/assets_column_index.json
tableIndex='assets_table_v1'
columnIndex='assets_column_v1'
# http://localhost:9200
url=$1
username=$2
curlParamU=""

if [ ! -n "$1" ]; then
  echo "请输入ES url, 例：./create.sh http://localhost:9200"
  exit
fi

if [ -n "$2" ]; then
    curlParamU="-u ${username}"
fi
echo -e "url: ${url}"
echo -e "用户名: ${username}\n"

function createTableIndex()
{

    http_code=$(curl -sSL -w '%{http_code}' ${curlParamU} -o ./response.txt -XPUT "${url}/${tableIndex}" -H 'Content-Type: application/json' -d ${assets_table_index})

    if [ ${http_code} -eq 200 ]
    then
      echo -e "method: createTableIndex(): \n 创建索引${tableIndex}成功, http status: ${http_code}"
    else
      echo -e "method: createTableIndex(): \n 创建索引${tableIndex}失败, http status: ${http_code}"
    fi
    cat response.txt
    rm response.txt
    echo -e "\n"
}

function createAlias4TableIndex() {
    alias='assets_table'
    http_code=$(curl -sSL -w '%{http_code}' ${curlParamU} -o ./response1.txt -XPUT "${url}/${tableIndex}/_alias/${alias}" -H 'Content-Type: application/json')

    if [ ${http_code} -eq 200 ]
    then
      echo -e "method: createAlias4TableIndex(): \n 给索引${tableIndex}创建别名${alias}成功, http status: ${http_code}"
    else
      echo -e "method: createAlias4TableIndex(): \n 给索引${tableIndex}创建别名${alias}失败, http status: ${http_code}"
    fi
    cat response1.txt
    rm response1.txt
    echo -e "\n"
}


function createColumnIndex()
{

    http_code=$(curl -sSL -w '%{http_code}' ${curlParamU} -o ./response2.txt -XPUT "${url}/${columnIndex}" -H 'Content-Type: application/json' -d ${assets_column_index})

    if [ ${http_code} -eq 200 ]
    then
      echo -e "method: createColumnIndex(): \n 创建索引${columnIndex}成功, http status: ${http_code}"
    else
      echo -e "method: createColumnIndex(): \n 创建索引${columnIndex}失败, http status: ${http_code}"
    fi
    cat response2.txt
    rm response2.txt
    echo -e "\n"
}

function createAlias4ColumnIndex() {
    alias='assets_column'
    http_code=$(curl -sSL -w '%{http_code}' ${curlParamU} -o ./response3.txt -XPUT "${url}/${columnIndex}/_alias/${alias}" -H 'Content-Type: application/json')

    if [ ${http_code} -eq 200 ]
    then
      echo -e "method: createAlias4ColumnIndex(): \n 给索引${columnIndex}创建别名${alias}成功, http status: ${http_code}"
    else
      echo -e "method: createAlias4ColumnIndex(): \n 给索引${columnIndex}创建别名${alias}失败, http status: ${http_code}"
    fi
    cat response3.txt
    rm response3.txt
    echo -e "\n"
}

# 创建table的索引
createTableIndex

createAlias4TableIndex

# 创建column索引
createColumnIndex

createAlias4ColumnIndex