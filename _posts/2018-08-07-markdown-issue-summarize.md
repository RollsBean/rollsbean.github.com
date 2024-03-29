---
layout: post
title:  "Markdown 文件的语法问题"
date:   2018-08-07 10:20:00 +8:00
categories: markdown
tags: markdown
author: Kevin Fan
---

* content
{:toc}

项目运行之后开始用md文件写博客，调格式，在md的语法上又遇到了很多问题。

<!-- more -->

### Markdown 文件介绍

Markdown ([Markdown语法介绍](http://xianbai.me/learn-md/article/about/readme.html))是一种轻量级标记语言，创始人为约翰·格鲁伯（John Gruber）。它允许人们“使用易读易写的纯文本格式编写文档，然后转换成有效的 XHTML
（或者 HTML）文档”。这种语言吸收了很多在电子邮件中已有的纯文本标记的特性。

#### 为什么选择 Markdown
----
- 它基于纯文本，方便修改和共享；
- 几乎可以在所有的文本编辑器中编写；
- 有众多编程语言的实现，以及应用的相关扩展；
- 在 GitHub 等网站中有很好的应用；
- 很容易转换为 HTML 文档或其他格式；
- 适合用来编写文档、记录笔记、撰写文章。

#### 遇到的问题：

- **解析不灵活**， 多一个空格少一个空格都不行
- 现在的样式还比较简单
- 由于编译器的差别， 可能在不同环境下的显示有区别， 需要注意

上面说到了markdown 是纯文本， 语法简单易记， 适合编写文档， 但是解析很不灵活， 所以对于新手来说， 会出现很多问题。

1. **空格的问题**：
markdown的语法有一个要求就是， 语法标记和内容之间要有空格， 比如说`####` 代表标题， 然而`####标题` 并不会被解析，因为标记和内容之间没有空格，
正确的写法是`#### 标题`， 还有在写列表的时候`-` `*` `+` 这些标记符号和内容之间也要有空格， 比如`- 它基于纯文本，方便修改和共享；`

2. **语法标记之间换行**
前面讲到， 写标题的时候 `##` 要和标题内容有空格， 但是有时候我们这样写了， 怎么标题还是渲染不出来呢， 可能的原因就是， 标题下面紧跟内容了。 
比如说
```
#### 遇到的问题：
- **解析不灵活**， 多一个空格少一个空格都不行
- 现在的样式还比较简单
```
第一行 `#### 遇到的问题` 和下面的文本中间没有空行， 所以 标题不能被解析出来， 而且下面的列表也无法渲染出来。

3. **字符转义**
我在上一篇博文中有提到， 由于我一篇博文中有`<%include %>`, 虽然我并没有真正去引用其他文件，但是这里的标记符号却被解析成引用外部文件了， 
最终导致编译失败。 但是有时候我们的博文中会用到Jekyll的语言来做说明， 但是又不想被引用， 这是就需要字符转义了。 请看下面的例子：
```
这是用来 *演示* 的 _文本_
<br>
这是用来 \*演示\* 的 \_文本\_
```
 如上两个文本将被解析成: <br>
 这是用来 *演示* 的 _文本_
 <br>
 这是用来 \*演示\* 的 \_文本\_
 
#### 最后简单说下配置上的一些问题
 
 我的博客是fork别人的， 所以刚开始并没有了解Jekyll的配置， 后来发现了一些问题， 才去了解了一些配置信息， 下面是我遇到的配置问题，
 
 - 博客首页显示摘要
 
 如果想要在首页显示博文的摘要， 可以直接在`_config.yml` 中配置 `excerpt_separator: "<!-- more -->"`， `"<!-- more -->"`指的是
 摘要和正文的分隔符， 比如： 
 
```markdown

项目运行之后开始用md文件写博客，调格式，在md的语法上又遇到了很多问题。

<!-- more -->

### Markdown 文件介绍

Markdown ([Markdown语法介绍](http://xianbai.me/learn-md/article/about/readme.html))是一种轻量级标记语言，创始人为约翰·格鲁伯（John Gruber）。它允许人们“使用易读易写的纯文本格式编写文档，然后转换成有效的 XHTML
（或者 HTML）文档”。这种语言吸收了很多在电子邮件中已有的纯文本标记的特性。

```
 
首页的显示是这样的：
![](/images/home_page.jpg)

- 博客日期排序问题

Jekyll要求的博客命名格式是 `YEAR-MONTH-DAY-title.MARKUP`， 在博客的开始地方也有日期属性，比如： 
```
 layout: post
 title:  "Markdown 文件的语法问题"
 date:   2018-08-07 10:20:00 +8:00
 categories: markdown
 tags: markdown
 author: Kevin Fan
```
 
 这个地方的日期默认是GMT 时间
(Greenwich Mean Time，格林尼治平时), 所以有时候写了博文，但是并没有在首页中显示可能是没有加时区， 中国大陆时区可以直接在 时间后面加 `+08:00`,
这样就不会有时间显示的问题了。

<br>

>原文链接：[https://rollsbean.com/2018/08/07/markdown-issue-summarize/](https://rollsbean.com/2018/08/07/markdown-issue-summarize/)