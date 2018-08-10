---
layout: post
author: Kevin Fan
title:  "给你的博客配置独立域名"
date:   2018-08-10 14:00:00 +8
categories: Github
tags: Github blog jekyll domain 
---

* toc
{:toc}

上周把博客搭建好之后， 耐不住躁动的心，接着就想给自己弄一个高大上的独立域名了，Github 默认的域名是user.github.io， 我们经常可以看到有很多
大V的博客是自己的域名，后来专门查了一下， 发现个人域名并不贵，基本上一年只有几十块钱，可以说是很划算了， 然后我就决定了要给自己的博客加一个域名。

好了， 那就搞起来吧！


<!-- more -->

### 前言

网上有很多域名服务商供我们购买域名。 比如国内的万网(阿里云)[wanwang.aliyun.com](https://wanwang.aliyun.com/)，新网[http://www.xinnet.com](http://www.xinnet.com/)等，
国外的有Namesilo[namesilo.com](https://www.namesilo.com/), 
GoDaddy[https://sg.godaddy.com/zh](https://sg.godaddy.com/zh/)(有中文界面， 选择新加坡即可), name[name.com](https://www.name.com/), namecheap[namecheap.com](https://www.namecheap.com/),
1&1[1and1.com](https://www.1and1.com/) 等。

其实我对这个并不太懂， 也是看网上的介绍然后选了一家比较合适的， 国内的据说比较坑， 而且选择`.cn`的话需要备案，时间有些久， 然后国外的域名服务商
有很多老牌的， 口碑也不错， 不需要备案， 几分钟就可以创建好， 所以我就选择了国外的， 当然国外的也有比较坑的， 有的第一年很便宜， 只需2美刀， 
但是第二年要很多钱，还有WHOIS 也要购买，所以大家在买域名的时候一定要注意有没有什么隐形收费。 

我是在**Namesilo**买的域名， 这家的口碑不错，博主买的`.com` 域名只需8.99刀，价格不高(可以用支付宝支付)，主要是不会有乱七八糟坑人的收费,
而且有优惠券可用， 不过只能使用一次，博主也是后来才知道的， 唯一的缺点可能是没有中文页面。 这篇博文将用Namesilo作为例子来介绍， 配置方面
其实各个网站都差不多。

### 购买域名

登录Namesilo官网[https://www.namesilo.com/](https://www.namesilo.com/)
![home page](/images/screeshot/namesilo/namesilo%20homepage.jpg)

#### 搜索你想要的domain

![namesilo search ](/images/screeshot/namesilo/namesilo%20search.jpg)

#### 选择你想要的domain

`.com` 已被我注册， 所以显示**Registered**

![namesilo search ](/images/screeshot/namesilo/namesilo%20search%20result.jpg)

#### 填写domain详细信息

第一项`Service Link`: 允许你选择一个第三方的服务来链接你的domain， 可以选择GitHub 或者不修改， 后面还可以修改。
第二项`NameServers`: 忽略
第三项`Auto-Renew`: 是否自动续费， 我选的 **No**
第四项`Privacy Setting`: 隐私设置， 这个地方记着选择`WHOIS Privacy`
确认一下数量/选择的年限， 就可以提交订单了。

![namesilo search ](/images/screeshot/namesilo/domain%20config.jpg)

#### 创建账户， 完善个人信息

都是基本信息， 地址和电话号码是必填项， 填好之后点下面的按钮即可。 注意： 邮箱需要验证
![namesilo search ](/images/screeshot/namesilo/create%20account.jpg)


#### 支付订单， 查看domain信息

支付订单时可以直接用支付宝支付， 支付完成后， 进入到**My Account**页面， 选择`domain manager`

![namesilo search ](/images/screeshot/namesilo/account%20page.jpg)

点击管理DNS按钮（`Options` 里的小蓝圆圈）

![namesilo search ](/images/screeshot/namesilo/account%20pre-manager.jpg)

### 配置Domain(独立域名)

#### 配置DNS

如下的列表是资源的记录， 这里注意**CNAME**, 它可以将域名link到第三方的服务上， 也就是说可以将这个域名link到Github pages上， 这里主要就是配置它

![namesilo search ](/images/screeshot/namesilo/manage%20page.jpg)

如果你们显示的不是这个页面， 可以往下滚动页面， 下面有一个**DNS Templates**， 选择Github 点`Apply Template`, 这样你就可以修改你的Records了。

![namesilo search ](/images/screeshot/namesilo/github%20template.jpg)

继续之前的， 点击修改`CNAME` , 这里只需要将你的 Target hostname 修改为你的Github blog的url即可， 注意： 这个地方不要加协议信息， 只写domain

![namesilo search ](/images/screeshot/namesilo/cname%20update.jpg)

#### 配置Github CNAME

现在回到Github仓库， 在项目根目录下创建名为`CNAME`的文件， 写上你的域名， 带 "www" 或者不带都可以， 我的是[rollsbean.com](rollsbean.com)

<img src='/images/screeshot/namesilo/github CNAME.jpg' />

然后在`Settings`里查看site状态, 绿色代表配置成功， 不过此时域名可能还没有同步到所有的DNS服务器上，这时访问独立域名是404。

![namesilo search ](/images/screeshot/namesilo/GitHub%20page%20site.jpg)

#### 相关Support

修改CNAME之后， 它需要大约24到48小时来将你新的配置传播到世界各地的DNS服务器上。 所以刚修改完的时候，你的个人域名是访问不到的。
那我们怎么查询自己的域名有没有完全生效呢？ 你可以访问 whatsmydns[whatsmydns.net/#CNAME](https://www.whatsmydns.net/#CNAME) 
来查询你的域名状态。 这里要选择CNAME类型查询

<img src='/images/screeshot/namesilo/dns progagation check.jpg' width='100%' height='400px'/>

如果都是对勾，则代表CNAME同步好了，不然，慢慢等待吧！

### 相关知识

Domain传播需要的时间 How Long Does Domain Propagation Take? 
[https://www.hostgator.com/blog/domain-propagation/](www.hostgator.com/blog/domain-propagation)

查看域名传播状态[www.whatsmydns.net/#CNAME/](https://www.whatsmydns.net/#CNAME/)

Publishing on a Custom Domain (CNAME)
[help.instapage.com/hc/en-us/articles/205226088-Publishing-on-a-Custom-Domain-CNAME-](https://help.instapage.com/hc/en-us/articles/205226088-Publishing-on-a-Custom-Domain-CNAME-)

Using a custom domain with GitHub Pages [help.github.com/articles/using-a-custom-domain-with-github-pages](https://help.github.com/articles/using-a-custom-domain-with-github-pages/)

