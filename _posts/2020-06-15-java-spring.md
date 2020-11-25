---
layout: post
author: Kevin Fan
title:  "Spring Framework"
date:   2020-06-15 16:00:00 +8
categories: Java
tags: Java Spring
---

* toc
{:toc}


Spring

<!-- more -->

### 概述

### IoC Container

[Spring.io Docs](https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-factory-dependson)

#### 三个问题

1. 构造器注入导致的循环依赖问题

解决方案：构造器注入改成setter注入
2. 
3. 多例注入到单例实例的问题
 
Spring的注入只会发生一次，所以多例实例注入到单例实例中时也只发生了一次，也就是说这个多例在单例实例里是一个不变的实例
解决方案： Method injection，使用`@Lookup`注解,实现方法级的注入


#### Bean加载


```java
public class DefaultSingletonBeanRegistry extends SimpleAliasRegistry implements SingletonBeanRegistry {

	/** Cache of singleton objects: bean name to bean instance. */
	private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256);
    // add to singleton map
    protected void addSingleton(String beanName, Object singletonObject) {
        synchronized (this.singletonObjects) {
            this.singletonObjects.put(beanName, singletonObject);
            this.singletonFactories.remove(beanName);
            this.earlySingletonObjects.remove(beanName);
            this.registeredSingletons.add(beanName);
        }
    }
}
```

#### new ApplicationContext(configure file path)

初始化核心方法： `AbstractApplicationContext#refresh()`

1. `AbstractRefreshableApplicationContext#refreshBeanFactory()`创建beanFactory并且初始化beanDefinition
2. `DefaultListableBeanFactory#registerBeanDefinition`

如果map中不存在，则注册bean definition到map中，如果已经存在，则检查是否有bean已经被created了，如果不是线程安全地添加到map中

`BeanDefinition` 描述了spring的bean 实例

#### getBean("beanName")

核心类和方法 `AbstractBeanFactory` `getBean(String name, Class<T> requiredType)`

先从Spring缓存中获取bean， Spring IoC有三级缓存， 即`singletonObjects` `singletonFactories` `earlySingletonObjects`三个map，
`singletonObjects` 缓存objects
```java
public class DefaultSingletonBeanRegistry extends SimpleAliasRegistry implements SingletonBeanRegistry {

	/** Cache of singleton objects: bean name to bean instance. */
	private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256);

	/** Cache of singleton factories: bean name to ObjectFactory. */
    // 处理循环引用，如果允许循环引用，则可以添加到这个map里
	private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<>(16);

	/** Cache of early singleton objects: bean name to bean instance. */
	private final Map<String, Object> earlySingletonObjects = new HashMap<>(16);

	/** Set of registered singletons, containing the bean names in registration order. */
	private final Set<String> registeredSingletons = new LinkedHashSet<>(256);


    /**
     * Return the (raw) singleton object registered under the given name,
     * creating and registering a new one if none registered yet.
     * @param beanName the name of the bean
     * @param singletonFactory the ObjectFactory to lazily create the singleton
     * with, if necessary
     * @return the registered singleton object
     */
    public Object getSingleton(String beanName, ObjectFactory<?> singletonFactory) {
        synchronized (this.singletonObjects) {
            Object singletonObject = this.singletonObjects.get(beanName);
            if (singletonObject == null) {
                singletonObject = singletonFactory.getObject();
                newSingleton = true;
            }
            /*
            ...
            */
            if (newSingleton) {
                addSingleton(beanName, singletonObject);
            }
        }
    }
    
    @Nullable
    protected Object getSingleton(String beanName, boolean allowEarlyReference) {
        // 从一级缓存singletonObjects获取bean，bean已初始化好，可以直接使用
        Object singletonObject = this.singletonObjects.get(beanName);
        if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
            synchronized (this.singletonObjects) {
                // 从二级缓存earlySingletonObjects获取bean，bean还没有填充属性
                singletonObject = this.earlySingletonObjects.get(beanName);
                if (singletonObject == null && allowEarlyReference) {
                    // 从三级缓存singletonFactories获取bean，bean工厂对象，还未实例化，只是bean的定义
                    ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
                    if (singletonFactory != null) {
                        singletonObject = singletonFactory.getObject();
                        this.earlySingletonObjects.put(beanName, singletonObject);
                        this.singletonFactories.remove(beanName);
                    }
                }
            }
        }
        return singletonObject;
    }

    // Add the given singleton object to the singleton cache of this factory.
    protected void addSingleton(String beanName, Object singletonObject) {
        synchronized (this.singletonObjects) {
            this.singletonObjects.put(beanName, singletonObject);
            this.singletonFactories.remove(beanName);
            this.earlySingletonObjects.remove(beanName);
            this.registeredSingletons.add(beanName);
        }
    }

}
```

如果缓存中不存在，则从beanDefinitionMap 中取出bean的定义，初始化bean以及它的依赖（懒加载情况下 第一次访问bean，缓存中不存在，需要去初始化）
