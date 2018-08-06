---
layout: post
title:  "安装以及使用Jekyll的问题总结"
date:   2018-08-03 16:44:00
categories: jekyll
tags: jekyll
author: Kevin Fan
---

经历了几天的折腾，终于能正常运行fork的blog模板和写博客了。 所以在此总结一下这几天出过的问题。
<!-- more -->


### 写第一篇博文就显示不出来
fork了别人的bolg之后， 我就开始用markdown文件写第一篇bolg， 文本内容是
[Jekyll Docs](https://jekyllrb.com/docs/structure/) 上的内容， 格式也尽量保持一样， 这样正好可练习一下md的语法，
然后费劲一番功夫写完传到GitHub上之后， 我的GitHub page并没有更新， 新的文档竟然没有显示。 这我就有些不明白了， 因为我的博文格式是仿照模板里的写的，
感觉没有什么问题呀， 就这样耗了一天也不知道怎么回事， 后来再修改上传到GitHub发现邮箱有收到邮件， 邮件内容：
```
The page build failed for the \`master\` branch with the following error:
 A file was included in \`_posts/2018-08-03-first-blog.md\` that is a symlink or does not exist in your \`_includes\` directory.
 For more information, see https://help.github.com/articles/page-build-failed-file-is-a-symlink/.

 For information on troubleshooting Jekyll see:
   https://help.github.com/articles/troubleshooting-jekyll-builds
 If you have any questions you can contact us by replying to this email.
 ```
 意思就是在我第一篇博文里有一个symlink(符号链接)不能被找到，然后我开始查`a symlink or does not exist`问题，然后了解到可能是我的md文档里引
 用了某个不存在的文件比如`\{\%include example.html%}`， 所以GitHub解析出现问题，但是我在文件中并没有引用其他文件呀， 而且重要的是邮件里并
 没有提示是哪个symlink引用出现的问题

 最后为了调试，我开始尝试去根据网上的Jekyll安装教程来在本地来装Jekyll+Ruby，这时问题又来了。。。

### 本地安装Ruby+Jekyll出现的问题

 根据网上的教程， 我先在本地安装Ruby installer for Windows, 然后安装RubyGems， 安装成功之后用cd 到RubuGems根目录，打开cmd输入命令
 `gem install jekyll`， 失败， 原因是make命令不存在， 然后Google之后感觉可能是需要安装ASYS2(原因我也不知道)， 安装之后还是不行，
 经过一番折腾（安装卸载N次）之后， 只能去求助StockOverflow了， 不得不说StockOverflow的回复真的很快， 才刚问完问题，就有人回复了
 [StockOverflow问题链接](https://stackoverflow.com/questions/51699761/error-installing-jekyll-error-failed-to-build-gem-native-extension)
 问题的原因就是我没有安装DevKit， 所以没有C相关的扩展，接下来就好办了， 直接卸载Ruby/ASYS, 然后去官网重新安装Ruby installer with devkit,然后就是傻瓜安装。
 安装完成之后再命令行输入`ruby -v` `gem -v`来检验是否都安装成功。 最后就是最重要的部分了， cd到rubygems 根目录安装Jekyll `gem install jekyll`
 安装成功！
 ```
C:\Developments\GitRepository\testRepository\blogFork1>ruby -v
ruby 2.5.1p57 (2018-03-29 revision 63029) [x64-mingw32]

C:\Developments\GitRepository\testRepository\blogFork1>jekyll -v
jekyll 3.8.3
```
查看Jekyll版本， 出现版本号证明安装成功。 接下来就是运行Jekyll项目了，问题又来了。

### 运行Jekyll项目遇到的问题

第一步cd到项目所在的根目录， 运行`jekyll serve --watch`, 运行失败。。。
```
C:\Developments\GitRepository\testRepository\blogFork1>jekyll serve --watch
Configuration file: C:/Developments/GitRepository/testRepository/blogFork1/_config.yml
       Deprecation: The 'gems' configuration option has been renamed to 'plugins'. Please update your config file accordingly.
            Source: C:/Developments/GitRepository/testRepository/blogFork1
       Destination: C:/Developments/GitRepository/testRepository/blogFork1/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
  Liquid Exception: Could not locate the included file 'file.ext' in any of
  ["C:/Developments/GitRepository/testRepository/blogFork1/_includes"].
  Ensure it exists in one of those directories and, if it is a symlink, does not point outside your site source. in
  C:/Developments/GitRepository/testRepository/blogFork1/_posts/2018-08-03-first-blog.md
jekyll 3.8.3 | Error:  Could not locate the included file 'file.ext' in any of
["C:/Developments/GitRepository/testRepository/blogFork1/_includes"]. Ensure it exists in one of those directories and,
if it is a symlink, does not point outside your site source.
```
终于可以看到异常的stacktrace了， 根据异常信息中的描述： *Could not locate the included file 'file.ext'*，  找到了问题定位：
在*2018-08-03-first-blog.md* 中的一段文本里有`\{\%include file.ext%}`, 本以为使用了md的语法，里面的命令不会生效，但是还是生效了。
所以删掉这段命令。
重新运行， 新的错误， 没有找到 `jekyll-paginate`，在命令行安装`gem install jekyll-paginate`
```
C:\Developments\GitRepository\testRepository\blogFork1>jekyll serve --watch
Configuration file: C:/Developments/GitRepository/testRepository/blogFork1/_config.yml
       Deprecation: The 'gems' configuration option has been renamed to 'plugins'.
       Please update your config file accordingly.
  Dependency Error: Yikes! It looks like you don't have jekyll-paginate or one of its dependencies installed.
  In order to use Jekyll as currently configured, you'll need to install this gem. The full error message from Ruby
  is: 'cannot load such file -- jekyll-paginate' If you run into trouble, you can find helpful resources at
  https://jekyllrb.com/help/!
jekyll 3.8.3 | Error:  jekyll-paginate
```
再重新运行， 发现默认端口被占用
```
Auto-regeneration: enabled for 'C:/Developments/GitRepository/testRepository/blogFork1'
jekyll 3.8.3 | Error:  Permission denied - bind(2) for 127.0.0.1:4000
```
查找4000 端口， `netstat -aon | findstr "4000"` kill掉或者在`_config.yml`中添加配置 `port: 4100`

到此为止项目终于成功运行了， 但是接下来还有markdown语法的很多问题。 下篇博客详细讲。