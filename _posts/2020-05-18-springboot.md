---
layout: post
author: Kevin Fan
title:  "SpringBoot"
date:   2020-05-18 15:00:00 +8
categories: Java
tags: Java SpringBoot Spring
---

* toc
{:toc}


SpringBoot

<!-- more -->


### 

@SpringBootApplication 包含了@SpringBootConfiguration @EnableAutoConfiguration @ComponentScan等

@SpringBootConfiguration 类上有@Configuration 是Spring的配置类
@EnableAutoConfiguration Springboot实现自动配置的关键，类上有@Import(AutoConfigurationImportSelector.class),
在它的selectImports()方法中调用了getCandidateConfigurations(),loadFactoryNames()加载spring默认配置类，拿到所有需要加载的
配置项循环放到AutoConfigurationGroup的map里，接下来利用反射创建配置对象
@ComponentScan 

### 启动SpringApplication.run流程

1. 使用SpringFactoriesLoader 在classpath下找ApplicationListener
2. SpringApplication初始化后开始加载SpringApplicationRunListener 调用starting()方法
3. 配置Environment
4. createApplicationContext() 创建ApplicationContext实例
5. 初始化context，set classloader   set environment
6. refresh() 初始化BeanFactory，向JVM 注册registerShutdownHook 完成IoC的最后工序 
7. listener.start(context)
8. 最后遍历listener 的running方法

