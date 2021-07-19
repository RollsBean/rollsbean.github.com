---
layout: post
title:  "使用 Junit5 和 Mockito"
date:   2021-07-16 14:12:05 +8
categories: Java
tags: Java Junit5 Mockito
author: Kevin Fan
---

* content
  {:toc}

升级使用 Junit5 和 Mockito 作为项目的单元测试mock框架
<!-- more -->

## 背景

目前项目都在使用 Springboot 2.3.x，Springboot 的 `spring-boot-starter-test` 包中已经包含了 `junit-jupiter`、`mockito-core`、
`mockito-junit-jupiter` 等 Junit5 和 Mockito 相关的依赖包。Springboot 官方也推荐使用 Junit5 作为单元测试框架，当然，你继续使用 Junit4
也是可以的，只要引入 `junit-vintage-engine` 依赖即可。

```xml
<dependency>
    <groupId>org.junit.vintage</groupId>
    <artifactId>junit-vintage-engine</artifactId>
    <scope>test</scope>
    <exclusions>
        <exclusion>
            <groupId>org.hamcrest</groupId>
            <artifactId>hamcrest-core</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

## 准备工作

### 引入依赖

虽然 Springboot 的 test starter 已经提供了很多 Junit5 的包，但是要想在项目中使用 Junit5 和 Mockito，我们还需要额外引入如下几个包：

```xml
<dependencies>
  <dependency>
      <groupId>org.junit.platform</groupId>
      <artifactId>junit-platform-launcher</artifactId>
      <scope>test</scope>
  </dependency>
  <!-- 不加会报错 -->
  <dependency>
    <groupId>org.junit.vintage</groupId>
    <artifactId>junit-vintage-engine</artifactId>
    <scope>test</scope>
  </dependency>
  
  <dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <scope>test</scope>
  </dependency>
  <dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-inline</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```

### 编写单元测试基类

编写单元测试基础类 **ApplicationTest**，其中 `@SpringBootTest` 已经包含了 `@ExtendWith` 注解，`@SpringBootTest`、`@ExtendWith`、`TestPropertySource`、
`@Transactional` 和 `@Rollback` 都使用了 `@Inherited` 注解，表示这些注解是可继承的，所以只要测试类继承了这个基类，就可以直接写 test 方法
而不需要再写这些注解了。

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, classes = Application.class)
@TestPropertySource("classpath:application-test.properties")
@Transactional
@Rollback
public class ApplicationTest {
    
}
```

编写 webmvc 的基础类来模拟 http 接口请求。同样的，这个 webmvc 基础类需要继承单元测试基类 **ApplicationTest**。

在编写 controller 层的单元测试类时，只需要继承 WebMvcTest 即可。

```java
@AutoConfigureMockMvc
public class WebMvcTest extends ApplicationTest {
    
    @Autowired
    protected MockMvc mockMvc;
}
```

controller 测试，使用 POST 请求 /save 接口，使用 content()设置请求参数，使用 cookie() 设置 cookie。andExpect() 做断言，使用 jsonPath()
可以断言 json 字符串。

```java
public class UserControllerTest extends WebMvcTest {
    
    @Test
    public void testSave() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.post("/save"))
                .content("{\n" +
                        "\"username\": \"kevin\" \n",
                "}")
                .accept(MediaType.APPLICATION_JSON)
                .cookie("cookie")
                .andExpect(MockMvcRequestMatchers.status().isOk())
                .andExpect(MockMvcRequestMatchers.jsonPath("$.code").value(0));
    }
}
```

### 常规断言方式

Junit5 使用 `org.junit.jupiter.api.Assertions` 类提供的静态方法来进行断言，例如：

```java
Assertions.assertNotNull(id);
```

断言超时：
```java
@Test
void testTimeout() throws InterruptedException {
    Assertions.assertTimeout(Duration.ofMillis(10), () -> Thread.sleep(100));
}
```

## 与 Junit5 的区别

* **导入** JUnit 5 使用新的 org.junit.jupiter 包。例如，org.junit.Test变成了org.junit.jupiter.api.Test。
* **注解** @Test 注解不再有参数，每个参数都被移到了一个函数中。例如，下面是如何在JUnit 4中表示预计一个测试会抛出异常的方法
* **断言** JUnit 5断言现在在org.junit.jupiter.api.Assertions中

注解。@Test 注解不再有参数，每个参数都被移到了一个函数中。例如，下面是如何在JUnit 4中表示预计一个测试会抛出异常的方法：

以下是其他的注解的变化：

Junit:

|Junit4（包：org.junit）|  Junit5（包：org.junit.jupiter.api）|
|:---|:---|
|@Before|	@BeforeEach|
|@After|	@AfterEach|
|@AfterClass|	@AfterAll|
|@Ignore|	@Disabled|
|@Test	|@Test|

Springboot:

|2.3.x|2.4.x|
|:---|:---|
|@Runwith(SpringRunner.class)|	@ExtendWith(SpringExtension.class)|
|@ActiveProfiles("test")|@TestPropertySource("classpath:application-test.properties") (不再支持配置文件中指定profile)|

## Mockito mock

Mockito 的 mock 功能在 Junit5 和 Junit4 中使用方式都差不多，Mockito 既可以 mock 静态对象、方法，又可以 mock 普通方法，在与 Springboot 的
整合中还可以 mock Spring 容器中的对象。

### mock 静态方法

比如，有一个 class SessionContext 有一个静态方法 getCurrentUserId() 用于获取当前的登录对象 id，每次请求都需要拿到这个 id 并将其放到参数中，
伪代码如下：

```java
public class SessionContext {
    
    public static final ThreadLocal<Map<String, Object>> sessionLocal = new ThreadLocal<>();
    
    public static String getCurrentUserId() {
        return sessionLocal.get("id");
    }
}
```

如果我们在写测试方法时，不处理这个，那请求会报错或者无法查询到正确结果，因为 user id 没有设置到请求参数上。这时，我们就需要使用 Mockito 来 mock
这个方法，这样当方法中遇到这个方法调用时，Mockito 就会返回 mock 对象的结果，示例代码如下：

由于，这个方法在每个单测类中几乎都会被调用，所以直接将相关的 mock 写到 ApplicationTest 基类中。
```java
public class ApplicationTest {
    protected static MockStatic<SessionContext> sessionContext;
    
    @BeforeAll
    public static void init() {
      sessionContext = Mockito.mockStatic(SessionContext.class);
      sessionContext.when(SessionContext::getCurrentUserId).thenReturn("123");
    }
    
    @AfterAll
    public static void close() {
      sessionContext.close();
    }
}
```

`@BeforeAll` 和 `@AfterAll` 的方法只会在给定的测试类中执行一次，这两个注解要求方法的返回值为 void，不能是 private，并且必须是静态方法。

### mock 普通方法

TODO...

### mock Spring 容器的方法

TODO...


