---
layout: post
title:  "Springboot 使用maven properties动态定义active profile遇到的问题"
date:   2018-08-13 16:06:05 +8
categories: Java
tags: Java Springboot Maven
author: Kevin Fan
---

* content
{:toc}

最近做的Springboot项目需要配置不同环境的properties（dev环境和prod环境）并且要打成war包，根据这个需求，我要分别为不同环境写配置文件，
并且在Maven中动态指定active的配置文件。虽然很简单的一个配置，其中遇到了一个坑，在此记录一下。

我的resource 目录结构

```java
  --|application.properties
  --|application-dev.properties
  --|application-prod.properties
```

最终达到的效果是maven编译的时候指定active的profile从而可以调用对应环境的properties。

<!-- more -->

### application.properties的配置

```properties
-- 配置profiles.active，指定active的配置文件，这里引用了maven中的配置，后续再说为什么要这样写。
spring.profiles.active=@profiles.active@
```
`application-dev.properties`, `application-prod.properties`中可以配置对应环境中的配置，比如db配置等。

### Maven `pom.xml`的配置文件

#### 配置`<profiles>`标签来定义不同的环境

使用maven编译的时候，只需加上`-P dev`或者`-P prod`就可以使对应的profile生效，properties下面的变量就可以使用
```xml
<profiles>
    <!-- Developers build, to initiate use -P dev -->
    <profile>
        <id>dev</id>
        <properties>
            <!-- 这里配置自定义属性，属性名可以随便配置 -->
            <profiles.active>dev</profiles.active>
        </properties>
    </profile>
    <!-- Production build, to initiate use -P prod. -->
    <profile>
        <id>prod</id>
        <properties>
            <profiles.active>prod</profiles.active>
        </properties>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
    </profile>
</profiles>
```
#### 配置`<resources>` 标签指定配置文件的目录

这里非常重要的一点，如果想在spring中使用上面的变量，需要添加`<filtering>true</filtering>`， `<filtering>`标签的作用是代替spring中
对应的变量，只有配置了这个标签，前面spring中的引用变量才能生效。[Maven官网文档-Filtering](https://maven.apache.org/plugins/maven-resources-plugin/examples/filter.html)
```xml
<build>
    <finalName>project name</finalName>
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <filtering>true</filtering>
        </resource>
    </resources>
</build>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>group id</groupId>
    <artifactId>art id</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>war</packaging>
    <name>name</name>
    <description>poc</description>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.0.1.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <exclusions>
                <exclusion>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-starter-logging</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>1.3.2</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-log4j2</artifactId>
        </dependency>
        <!-- don't use embed tomcat for WAR deployment -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <scope>provided</scope>
        </dependency>

    </dependencies>

    <profiles>
        <!-- Developers build, to initiate use -P dev -->
        <profile>
            <id>dev</id>
            <properties>
                <profiles.active>dev</profiles.active>
            </properties>
        </profile>
        <!-- Production build, to initiate use -P prod. -->
        <profile>
            <id>prod</id>
            <properties>
                <profiles.active>prod</profiles.active>
            </properties>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
        </profile>
    </profiles>

    <build>
        <finalName>project name</finalName>
        <resources>
            <resource>
                <directory>src/main/resources</directory>
                <filtering>true</filtering>
            </resource>
        </resources>
    </build>
</project>
```

### spring 配置文件引用maven中定义的变量

我在pom文件中配置了 `spring-boot-starter-parent`, 而在`spring-boot-starter-parent`中,变量的分隔符使用的是`@` (
`<resource.delimiter>@</resource.delimiter>`), 所以在application.properties中要使用`@property name@`来引用变量，如果还是想使用
`${}`来表示应用变量，也可以在pom文件中使用`<resource.delimiter>`配置你想要的分隔符。

### 在命令行执行`mvn clean install -P prod` 就可以将prod的配置文件加载到spring

### 总结

1. Spring配置文件中引用变量用`@变量名@`
2. 要想让引用变量生效需要在pom文件中配置`<filtering>true</filtering>`
3. maven编译时，加上`-P profile id` 来指定profile

