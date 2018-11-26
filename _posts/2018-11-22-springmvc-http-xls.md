---
layout: post
title:  "Java SpringMVC 发送xls(excel)格式的response"
date:   2018-08-13 16:06:05 +8
categories: Java
tags: Java HTTP SpringMVC response xls excel ResponseEntity
author: Kevin Fan
---

* content
{:toc}

Java 中我们经常通过SpringMAC返回json格式的数据,接下来就工作中实际遇到的一个需求来谈下SpringMVC返回xls格式的数据的问题。
<!-- more -->

### 介绍

默认的，如果在controller里使用了`@requestMapping`注解， 我们就可以直接将返回的对象返回成一个json，但是如果要返回其他格式的数据呢？HTTP 
header中的属性`Content-type`可以指定返回的类型，所以如果要返回xls格式的response要将content type设置为`application/vnd.ms-excel`，具体
的对照关系请看[HTTP content-type 对照表](http://www.runoob.com/http/http-content-type.html)

### controller代码

在这里有两种实现方式

1. 通过workbook.write将stream返回到response中，返回时`void`

```java
@RestController
public class CCTGIntegrationController {

    private static final Logger LOGGER = LoggerFactory.getLogger(SBPIntegrationController.class);

    @RequestMapping(value = "/report", method = RequestMethod.GET)
    public void getMigrationDailyReport(HttpServletResponse response) {
        LOGGER.info("begin to get STAT daily report");
        Workbook dailyReport = new HSSFWorkbook();
        Sheet ddd = dailyReport.createSheet("ddd");
        ddd.createRow(0).createCell(0).setCellValue("dddd");
        ServletOutputStream outputStream = null;
        try {
            LOGGER.info("end to get STAT daily report");
            outputStream = response.getOutputStream();
            response.setHeader("Content-type", "application/octet-stream");
            dailyReport.write(outputStream);
        } catch (IOException e) {
            LOGGER.error("IOException when write excel to stream, e: {}", e);
        } finally {
            try {
                outputStream.close();
            } catch (IOException e) {

            }
        }
    }
```

2. 通过`ResponseEntity`返回流信息，三个参数 
```java
org.springframework.http.ResponseEntity<T> public ResponseEntity(T body,
          @Nullable org.springframework.util.MultiValueMap<String, String> headers,
          org.springframework.http.HttpStatus statusCode)
```

|参数|描述|
|:---|:---|
|body | the entity body 返回的内容|
|headers| the entity headers |
|statusCode | the status code - HttpStatus.OK|

```java
@RestController
public class CCTGIntegrationController {
    @RequestMapping(value = "/report1", method = RequestMethod.GET)
    public ResponseEntity<byte[]> getMigrationDailyReport1() throws IOException {
        LOGGER.info("begin to get STAT daily report");
        ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
        Workbook dailyReport = new HSSFWorkbook();
        dailyReport.createSheet("ddd").createRow(0).createCell(0).setCellValue("dddd");
        dailyReport.write(outByteStream);
        dailyReport.close();
        MultiValueMap<String, String> headers = new HttpHeaders();
        List<String> list = new ArrayList<>();
        list.add("application/vnd.ms-excel");
        headers.put(HttpHeaders.CONTENT_TYPE, list);
        return new ResponseEntity<byte[]>(outByteStream.toByteArray(), headers, HttpStatus.OK);
    }
}
```

测试方法： 使用Spring提供的MockMvc进行测试并且保证返回的数据可以被workbook接收。

通过如下代码获取mock response
```java
MvcResult mvcResult = this.mockMvc.perform(MockMvcRequestBuilders.get(url))
                    .andExpect(status().isOk()).andReturn();
```
通过`getContentAsByteArray()`获取response的字节数组。
```java
byte[] bytes = mvcResult.getResponse().getContentAsByteArray();
```

解析response的详细代码：
```java
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:/application-context-test-web.xml"})
public class IntegrationControllerTest {
    @Autowired
    private WebApplicationContext wac;
    private MockMvc mockMvc;
    @Before
    public void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
    }

    @Test
    public void testGetMigrationDailyReport() {
        String url = "/report";
        try {
            MvcResult mvcResult = this.mockMvc.perform(MockMvcRequestBuilders.get(url))
                    .andExpect(status().isOk()).andReturn();
            byte[] bytes = mvcResult.getResponse().getContentAsByteArray();
            // 方法1： 通过outputstream 传入到inputstream
            FileOutputStream fos = new FileOutputStream("output.xls");
            fos.write(bytes);
            fos.close();
            FileInputStream fis = new FileInputStream("output.xls");
            Workbook workbook1 = new HSSFWorkbook(fis);
            
            // 方法2： 通过 ByteArrayInputStream 将bytes传入到inputstream
            InputStream inputStream = new ByteArrayInputStream(bytes);
            Workbook workbook = new HSSFWorkbook(inputStream);
            
            Sheet sheet = workbook.getSheetAt(0);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### 总结

一般情况下， 直接返回json格式的数据，content-type使用`application-json`即可，但是有时我们需要返回文件（`.xls` `.pdf` 等）或者图片`.jpg`，
这时就需要设置content-type为对应的类型，并返回前端字节数组。