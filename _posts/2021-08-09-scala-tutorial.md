---
layout: post
title:  "Scala 教程"
date:   2021-08-09 10:48:05 +8
categories: Scala
tags: Scala
author: Kevin Fan
---

* content
{:toc}

Scala 是一门多范式（multi-paradigm）的编程语言。
Scala 运行在 Java 虚拟机上，并兼容现有的 Java 程序。  
Scala 源代码被编译成 Java 字节码，所以它可以运行于 JVM 之上，并可以调用现有的 Java 类库。  

第一个 Hello World 程序

```scala
object HelloWorld {
    def main(args: Array[String]): Unit = {
        println("Hello, world!")
    }
}
```

<!-- more -->

# Scala 基础语法

类似 Java 的基础语法，Scala 中：

* **对象** - 对象有属性和行为。例如：一只狗的状属性有：颜色，名字，行为有：叫、跑、吃等。对象是一个类的实例。

* **类** - 类是对象的抽象，而对象是类的具体实例。

* **方法** - 方法描述的基本的行为，一个类可以包含多个方法。

* **字段** - 每个对象都有它唯一的实例变量集合，即字段。对象的属性通过给字段赋值来创建。

**def main(args: Array[String])** : Scala 的入口程序，类似 Java 的 main 函数。

## 换行符

Scala 面向行，可以用分号（;）结尾或换行符，分号非必填。

## Scala 包

### 定义包

Scala 使用 `package` 关键字定义包：

```scala
package com.runoob
class HelloWorld
```

或者也可以使用类似 C# 的方式，这种方式可以在一个文件里定义多个包。

```scala
package com.runoob {
  class HelloWorld 
}
```

### 引用

Scala 使用 `import` 关键字引包。

```scala
import java.awt.Color  // 引入Color
 
import java.awt._  // 引入包内所有成员
```

特殊方式：
```scala
// 引入某几个成员
import java.awt.{Color, Font}
 
// 重命名成员
import java.util.{HashMap => JavaHashMap}
 
// 隐藏成员
import java.util.{HashMap => _, _} // 引入了util包的所有成员，但是HashMap被隐藏了
```

---

# Scala 数据类型

Scala 与 Java 数据类型类似，不同处有：

|数据类型|描述|
|:---|:---|
|Unit|	表示无值，和其他语言中void等同。用作不返回任何结果的方法的结果类型。Unit只有一个实例值，写成()。|
|Null|	null 或空引用|
|Nothing|	Nothing类型在Scala的类层级的最底端；它是任何其他类型的子类型。|
|Any|	Any是所有其他类的超类|
|AnyRef|	AnyRef类是Scala里所有引用类(reference class)的基类|

# Scala 变量

## 变量声明

* 变量 - 使用 var 声明
* 常量 - 使用 val 声明

```scala
// 变量
var myVar : String = "Foo"

// 常量，不可修改，否则在编译器会报错
val myVal : String = "Foo"
```

## 变量类型声明

语法：

```scala
var VariableName : DataType [=  Initial Value]

或

val VariableName : DataType [=  Initial Value]
```

## 类型推断

```scala
var myVar = 10;
val myVal = "Hello, Scala!";
```

# Scala 循环

## 循环类型

while 循环和 do...while 循环类似。

### 语法

```scala
for( var x <- Range ){
   statement(s);
}
```

#### 示例

```scala
object Test {
   def main(args: Array[String]) {
      var a = 0;
      // for 循环
      for( a <- 1 to 10){
         println( "Value of a: " + a );
      }
   }
}
```

### for 循环过滤

语法：

```scala
for( var x <- List
      if condition1; if condition2...
   ){
   statement(s);
}
```

示例：

说白了就是在 for 的括号里写 if 判断条件

```scala
object Test {
   def main(args: Array[String]) {
      var a = 0;
      val numList = List(1,2,3,4,5,6,7,8,9,10);

      // for 循环
      for( a <- numList
           if a != 3; if a < 8 ){
         println( "Value of a: " + a );
      }
   }
}
```

# Scala 方法与函数

使用 **def** 语句定义方法

## 方法声明

```scala
def functionName ([参数列表]) : [return type]
```

## 方法定义

```scala
def functionName ([参数列表]) : [return type] = {
   function body
   return [expr]
}
```

### 示例

```scala
object add{
   def addInt( a:Int, b:Int ) : Int = {
      var sum:Int = 0
      sum = a + b

      return sum
   }
}
```

## 方法调用

```scala
functionName( 参数列表 )
  
[instance.]functionName( 参数列表 )
```

## Scala 匿名函数

```scala
var inc = (x:Int) => x+1
```

上面的匿名函数等价于

```scala
def add2 = new Function1[Int,Int]{  
    def apply(x:Int):Int = x+1;  
} 
```

```scala
// 无参匿名函数
var userDir = () => { System.getProperty("user.dir") }
```

# 数组

## 声明数组

```scala
var z:Array[String] = new Array[String](3)

或

var z = new Array[String](3)
```

以上定义了一个长度为 3 的数组

通过索引访问每个元素，与 Java 类似
```scala
z(0) = "Runoob"; z(1) = "Baidu"; z(4/2) = "Google"
```

# 集合

## List 列表

Scala 中的列表是**不可变**的

```scala
// 字符串列表
val site: List[String] = List("Runoob", "Google", "Baidu")
// 空列表
val empty: List[Nothing] = List()
```

## 列表基本操作

* head 返回列表第一个元素
* tail 返回一个列表，包含除了第一元素之外的其他元素
* isEmpty 在列表为空时返回true

### 示例

```scala
// 字符串列表
object Test {
   def main(args: Array[String]) {
      val site = "Runoob" :: ("Google" :: ("Baidu" :: Nil))
      val nums = Nil

      println( "第一网站是 : " + site.head )
      println( "最后一个网站是 : " + site.tail )
      println( "查看列表 site 是否为空 : " + site.isEmpty )
      println( "查看 nums 是否为空 : " + nums.isEmpty )
   }
}
```

## 连接列表

你可以使用 ::: 运算符或 **List.:::()** 方法或 **List.concat()** 方法来连接两个或多个列表。实例如下:

```scala
object Test {
   def main(args: Array[String]) {
      val site1 = "Runoob" :: ("Google" :: ("Baidu" :: Nil))
      val site2 = "Facebook" :: ("Taobao" :: Nil)

      // 使用 ::: 运算符
      var fruit = site1 ::: site2
      println( "site1 ::: site2 : " + fruit )
     
      // 使用 List.:::() 方法
      fruit = site1.:::(site2)
      println( "site1.:::(site2) : " + fruit )

      // 使用 concat 方法
      fruit = List.concat(site1, site2)
      println( "List.concat(site1, site2) : " + fruit  )
   }
}
```

具体 API 参考：[Scala List(列表)](https://www.runoob.com/scala/scala-lists.html)

## Map（映射）

在 Scala 中 你可以同时使用可变与不可变 Map，不可变的直接使用 Map，可变的使用 mutable.Map。以下实例演示了不可变 Map 的应用：

```scala
// 空哈希表，键为字符串，值为整型
var A:Map[Char,Int] = Map()

// Map 键值对演示
val colors = Map("red" -> "#FF0000", "azure" -> "#F0FFFF")
```

定义好之后，需要添加元素时使用 **+=**  

```scala
A += ('I' -> 1)
A += ('J' -> 5)
```

## Scala 元组

与列表一样，元组也是不可变的，但与列表不同的是元组可以包含不同类型的元素。元祖使用括号将值放入其中。

```scala
val t = (1, 3.14, "Fred")  
```

我们可以使用 t._1 访问第一个元素， t._2 访问第二个元素，如下所示：

```scala
object Test {
   def main(args: Array[String]) {
      val t = (4,3,2,1)

      val sum = t._1 + t._2 + t._3 + t._4

      println( "元素之和为: "  + sum )
   }
}
```

### 迭代元组

你可以使用 **Tuple.productIterator()** 方法来迭代输出元组的所有元素：

```scala
t.productIterator.foreach{ i =>println("Value = " + i )}
```

# 类和对象

Scala中的类不声明为public，一个Scala源文件中可以有多个类。

### 示例

```scala
class Point(xc: Int, yc: Int) {
  
}
```

## Scala 单例对象

在 Scala 中，是没有 static 这个东西的，但是它也为我们提供了单例模式的实现方法，那就是使用关键字 object。它和类的区别是，object对象不能带参数。

单例对象是一种特殊的类，有且只有一个实例。单例对象是延迟创建的，当它第一次被使用时创建。当对象定义于顶层时(即没有包含在其他类中)，单例对象只有一个实例。

示例：

```scala
package logging

object Logger {
  def info(message: String): Unit = println(s"INFO: $message")
}
```

## Scala 通配符

Java 中使用 * 代表所有，在 Scala 中使用 _。

```scala
//Java
import java.util.*;
 
//Scala
import java.util._
```

### 默认值

Scala 需要显式指定初始值

```scala

class Foo{
    //String类型的默认值为null
    var s: String = _
}
```

### 泛型

Java 中指定泛型用 List<?> 或 List&lt;T>，Scala 中使用 List[_]。

## Scala 特有语法

### 简写函数字面量

如果函数的参数在函数体内只出现一次，则可以使用下划线代替：

```scala
val f1 = (_: Int) + (_: Int)
//等价于
val f2 = (x: Int, y: Int) => x + y

list.foreach(println(_))
//等价于
list.foreach(e => println(e))

list.filter(_ > 0)
//等价于
list.filter(x => x > 0)
```
