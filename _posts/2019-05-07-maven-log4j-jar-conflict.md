---
layout: post
title:  "记一次Spring boot log4j jar包冲突的处理"
date:   2019-05-07 15:20:00 +8:00
categories: log4j
tags: springboot log4j logging maven
author: Kevin Fan
---

* content
{:toc}

Springboot项目在配置了slf4j之后无反应，检查maven依赖发现因为依赖传递导致了问题。

<!-- more -->

### 背景

一个单独的Springboot小项目， 最近由于安全问题，要改成WAR包部署，趁着这次机会，顺便把日志配置了一下，结果遇到了
配置不起作用，改了之后启动又报jar包冲突的错误。

### 项目配置

本项目采用Springboot + Mybatis，下面是maven pom文件。

```xml
<dependencies>
        <dependency>
			<groupId>org.mybatis.spring.boot</groupId>
			<artifactId>mybatis-spring-boot-starter</artifactId>
			<version>1.2.0</version>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
			<exclusions>
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-tomcat</artifactId>
				</exclusion>
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-logging</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>javax.servlet-api</artifactId>
			<version>3.1.0</version>
			<scope>provided</scope>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-log4j2</artifactId>
		</dependency>
</dependency>	
```

项目使用了Spring官方的推荐依赖`spring-boot-starter-log4j2`，由于依赖`spring-boot-starter-web`中已经存在
log4j2，所以排除掉了此依赖。

再配置上`slf4j2.xml`，贴上部分配置

```xml
<Appenders>
        <Console name="Console-Appender" target="SYSTEM_OUT">
            <PatternLayout>
                <pattern>
                    %-d{yyyy-MM-dd HH\:mm\:ss} [%p] [%t]-[%c]-[%M] %m%n
                </pattern>>
            </PatternLayout>
        </Console>
        <!--default log file-->
        <RollingFile name="Server-Log"
                     fileName="${logDir}/migration_analysis.log"
                     filePattern="${archive}/migration_data.log.%d{yyyy-MM-dd}.gz">
            <PatternLayout pattern="[%-5level] %-d{yyyy-MM-dd HH\:mm\:ss.SSS} [%t]-[%c]-[%M] %m%n"/>
            <Policies>
                <SizeBasedTriggeringPolicy size="10 MB"/>
            </Policies>
            <DefaultRolloverStrategy max="20"/>
        </RollingFile>
```

#### 检查依赖

配置完成后，命令行打包`mvn clean install` 并在tomcat中运行，结果发现项目启动正常但是日志根本没有生成，要不然就是
日志的文件生成了但是没有日志，而且启动的时候还会报错（错误如下）。可以看到错误原因是
*java.lang.IllegalArgumentException: LoggerFactory is not a Logback LoggerContext but Logback is on the classpath.*
错误很明显了，log4j 相关的jar冲突导致的，下一步就是解决jar包冲突。

错误日志：

```java
07-May-2019 14:27:09.230 SEVERE [localhost-startStop-1] org.apache.catalina.core.ContainerBase.addChildInternal ContainerBase.addChild: start:
 org.apache.catalina.LifecycleException: Failed to start component [StandardEngine[Catalina].StandardHost[localhost].StandardContext[/migrationback]]
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:167)
        at org.apache.catalina.core.ContainerBase.addChildInternal(ContainerBase.java:754)
        at org.apache.catalina.core.ContainerBase.addChild(ContainerBase.java:730)
        at org.apache.catalina.core.StandardHost.addChild(StandardHost.java:734)
        at org.apache.catalina.startup.HostConfig.deployWAR(HostConfig.java:980)
        at org.apache.catalina.startup.HostConfig$DeployWar.run(HostConfig.java:1852)
        at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
        at java.util.concurrent.FutureTask.run(FutureTask.java:266)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.IllegalArgumentException: LoggerFactory is not a Logback LoggerContext but Logback is on the classpath. Either remove Logback or the competing implementation (class org.apache.logging.slf4j.Log4jLoggerFactory loaded from file:/C:/Developments/Software/apache-tomcat-8.5.39/webapps/migrationback/WEB-INF/lib/log4j-slf4j-impl-2.7.jar). If you are using WebLogic you will need to add 'org.slf4j' to prefer-application-packages in WEB-INF/weblogic.xml: org.apache.logging.slf4j.Log4jLoggerFactory
        at org.springframework.util.Assert.instanceCheckFailed(Assert.java:389)
        at org.springframework.util.Assert.isInstanceOf(Assert.java:327)
        at org.springframework.boot.logging.logback.LogbackLoggingSystem.getLoggerContext(LogbackLoggingSystem.java:274)
        at org.springframework.boot.logging.logback.LogbackLoggingSystem.beforeInitialize(LogbackLoggingSystem.java:98)
        at org.springframework.boot.logging.LoggingApplicationListener.onApplicationStartingEvent(LoggingApplicationListener.java:230)
        at org.springframework.boot.logging.LoggingApplicationListener.onApplicationEvent(LoggingApplicationListener.java:209)
        at org.springframework.context.event.SimpleApplicationEventMulticaster.invokeListener(SimpleApplicationEventMulticaster.java:167)
        at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent(SimpleApplicationEventMulticaster.java:139)
        at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent(SimpleApplicationEventMulticaster.java:122)
        at org.springframework.boot.context.event.EventPublishingRunListener.starting(EventPublishingRunListener.java:69)
        at org.springframework.boot.SpringApplicationRunListeners.starting(SpringApplicationRunListeners.java:48)
        at org.springframework.boot.SpringApplication.run(SpringApplication.java:292)
        at org.springframework.boot.web.support.SpringBootServletInitializer.run(SpringBootServletInitializer.java:151)
        at org.springframework.boot.web.support.SpringBootServletInitializer.createRootApplicationContext(SpringBootServletInitializer.java:131)
        at org.springframework.boot.web.support.SpringBootServletInitializer.onStartup(SpringBootServletInitializer.java:86)
        at org.springframework.web.SpringServletContainerInitializer.onStartup(SpringServletContainerInitializer.java:169)
        at org.apache.catalina.core.StandardContext.startInternal(StandardContext.java:5225)
        at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
        ... 10 more
```

但是再看pom文件，发现并没有冲突的地方呀，该排除的也排除了，而且配置和我的另一个项目一模一样，没办法了，只能看
两个项目的maven 依赖到底有什么区别。命令行运行`mvn dependency:tree`，它将会打印出
项目的依赖树，方便看到那些依赖下有引用log相关的jar。果然发现两个项目虽然都引用了`mybatis-spring-boot-starter`
但是依赖却不一样。

正常的项目：

```java
[INFO] +- org.mybatis.spring.boot:mybatis-spring-boot-starter:jar:1.3.2:compile
[INFO] |  +- org.springframework.boot:spring-boot-starter-jdbc:jar:2.0.1.RELEASE:compile
[INFO] |  |  +- com.zaxxer:HikariCP:jar:2.7.8:compile
[INFO] |  |  \- org.springframework:spring-jdbc:jar:5.0.5.RELEASE:compile
[INFO] |  |     \- org.springframework:spring-tx:jar:5.0.5.RELEASE:compile
[INFO] |  +- org.mybatis.spring.boot:mybatis-spring-boot-autoconfigure:jar:1.3.2:compile
[INFO] |  +- org.mybatis:mybatis:jar:3.4.6:compile
[INFO] |  \- org.mybatis:mybatis-spring:jar:1.3.2:compile
```

日志输出失败的项目：

```java
[INFO] +- org.mybatis.spring.boot:mybatis-spring-boot-starter:jar:1.2.0:compile
[INFO] |  +- org.springframework.boot:spring-boot-starter:jar:1.5.4.RELEASE:compile
[INFO] |  |  +- org.springframework.boot:spring-boot:jar:1.5.4.RELEASE:compile
[INFO] |  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:1.5.4.RELEASE:compile
[INFO] |  |  +- org.springframework.boot:spring-boot-starter-logging:jar:1.5.4.RELEASE:compile
[INFO] |  |  |  +- ch.qos.logback:logback-classic:jar:1.1.11:compile
[INFO] |  |  |  |  \- ch.qos.logback:logback-core:jar:1.1.11:compile
[INFO] |  |  |  \- org.slf4j:log4j-over-slf4j:jar:1.7.25:compile
[INFO] |  |  \- org.yaml:snakeyaml:jar:1.17:runtime
[INFO] |  +- org.springframework.boot:spring-boot-starter-jdbc:jar:1.5.4.RELEASE:compile
[INFO] |  |  +- org.apache.tomcat:tomcat-jdbc:jar:8.5.15:compile
[INFO] |  |  |  \- org.apache.tomcat:tomcat-juli:jar:8.5.15:compile
[INFO] |  |  \- org.springframework:spring-jdbc:jar:4.3.9.RELEASE:compile
[INFO] |  |     \- org.springframework:spring-tx:jar:4.3.9.RELEASE:compile
[INFO] |  +- org.mybatis.spring.boot:mybatis-spring-boot-autoconfigure:jar:1.3.2:compile
[INFO] |  +- org.mybatis:mybatis:jar:3.4.6:compile
[INFO] |  \- org.mybatis:mybatis-spring:jar:1.3.2:compile
```

仔细对比之后，发现mybatis版本不一样，改成一样的 1.3.2，结果还是失败，而且依赖树是一样的，既然版本没问题，怀疑是依赖传递优先级的问题，
对比两个项目的pom，发现虽然都依赖了同样的jar，但是dependency顺序不一样，根据maven依赖传递的特性，优先最短依赖路径，如果依赖路径相同，那么就遵循声明优先
原则，比如以下两个依赖，A下的D将会生效。

```java
A -> B -> D(V1)
E -> F -> D(V2)
```

由于mybatis starter中依赖了logback，所以按照原来的顺序，会导致log的jar冲突，报上面的错误，
解决方案也很好处理，调换两个依赖的顺序或者在`mybatis-spring-boot-starter`中排除`spring-boot-starter-logging`，
果然项目正常启动，日志也正常打印出来了。

最终的pom依赖：

```xml
<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
			<exclusions>
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-tomcat</artifactId>
				</exclusion>
				<exclusion>
					<groupId>org.springframework.boot</groupId>
					<artifactId>spring-boot-starter-logging</artifactId>
				</exclusion>
			</exclusions>
		</dependency>
		<dependency>
			<groupId>org.mybatis.spring.boot</groupId>
			<artifactId>mybatis-spring-boot-starter</artifactId>
			<version>1.3.2</version>
		</dependency>
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>javax.servlet-api</artifactId>
			<version>3.1.0</version>
			<scope>provided</scope>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-log4j2</artifactId>
		</dependency>
</dependencies>
```

### 总结

1. 项目中会经常遇到依赖传递的问题，就算是一个单一的springboot项目，由于依赖第三方和spring本身的
依赖问题，依赖传递还是会存在，由此导致的jar包冲突也有可能存在。
2. 遇到此类日志不生效的问题，先看配置有没有问题，配置没问题看jar包有没有冲突，可以用`mvn dependency:tree`来
查看项目的完整依赖关系。

