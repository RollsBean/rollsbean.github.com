---
layout: post
title:  "the first blog"
date:   2018-08-03 16:06:05
categories: Demo
tags: markdown 
author: Kevin Fan
---

* content
{:toc}

## Try to Use Markdown syntax
### Copy Text from Jekyll
[Jekyll Docs](https://jekyllrb.com/docs/structure/)


#Directory structure
Jekyll is, at its core, a text transformation engine. The concept behind the system is this: you give it text written in 
your favorite markup language, be that Markdown, [Textile](https://github.com/jekyll/jekyll-textile-converter) , or just plain HTML, and it churns that through a layout or 
a series of layout files. Throughout that process you can tweak how you want the site URLs to look, what data gets 
displayed in the layout, and more. This is all done through editing text files; the static web site is the final product.

A basic Jekyll site usually looks something like this:


```markdown
.
├── _config.yml
├── _data
|   └── members.yml
├── _drafts
|   ├── begin-with-the-crazy-ideas.md
|   └── on-simplicity-in-technology.md
├── _includes
|   ├── footer.html
|   └── header.html
├── _layouts
|   ├── default.html
|   └── post.html
├── _posts
|   ├── 2007-10-29-why-every-programmer-should-play-nethack.md
|   └── 2009-04-26-barcamp-boston-4-roundup.md
├── _sass
|   ├── _base.scss
|   └── _layout.scss
├── _site
├── .jekyll-metadata
└── index.html # can also be an 'index.md' with valid YAML Frontmatter
```

####Directory structure of Jekyll sites using gem-based themes
Starting Jekyll 3.2, a new Jekyll project bootstrapped with `jekyll new` uses *gem-based themes* to define the look of the site. 
This results in a lighter default directory structure : `_layouts`, `_includes` and `_sass` are stored in the theme-gem, by default.


*minima* is the current default theme, and `bundle show minima` will show you where minima theme's files are stored on your computer.

####An overview of what each of these does:

|FILE / DIRECTORY|	DESCRIPTION|
|:---|:---|
|`_config.yml`|Stores *configuration* data. Many of these options can be specified from the command line executable but it’s easier to specify them here so you don’t have to remember them.|
|`_drafts`|Drafts are unpublished posts. The format of these files is without a date: `title.MARKUP`. Learn how to work with drafts.|
|`_includes`|These are the partials that can be mixed and matched by your layouts and posts to facilitate reuse. The liquid tag `{% include file.ext %}` can be used to include the partial in `_includes/file.ext`.|
|`_layouts`|These are the templates that wrap posts. Layouts are chosen on a post-by-post basis in the *YAML Front Matter*, which is described in the next section. The liquid tag  `{{ content }}` is used to inject content into the web page.
|`_posts`|Your dynamic content, so to speak. The naming convention of these files is important, and must follow the format: `YEAR-MONTH-DAY-title.MARKUP`. The permalinks can be customized for each post, but the date and markup language are determined solely by the file name.
|`_data`|Well-formatted site data should be placed here. The Jekyll engine will autoload all data files (using either the `.yml`,  `.yaml`, `.json`, `.csv` or  `.tsv`formats and extensions) in this directory, and they will be accessible via `site.data`. If there's a file  members.yml under the directory, then you can access contents of the file through `site.data.members`.
|`_sass`|These are sass partials that can be imported into your `main.scss` which will then be processed into a single stylesheet  `main.css` that defines the styles to be used by your site.
|`_site`|This is where the generated site will be placed (by default) once Jekyll is done transforming it. It’s probably a good idea to add this to your `.gitignore` file.
|`.jekyll-metadata`|This helps Jekyll keep track of which files have not been modified since the site was last built, and which files will need to be regenerated on the next build. This file will not be included in the generated site. It’s probably a good idea to add this to your `.gitignore` file.
|`index.html` or `index.md` and other HTML, Markdown files|Provided that the file has a YAML Front Matter section, it will be transformed by Jekyll. The same will happen for any `.html`, `.markdown`,  `.md`, or `.textile` file in your site’s root directory or directories not listed above.
|Other Files/Folders|Every other directory and file except for those listed above—such as `css` and `images` folders,  `favicon.ico` files, and so forth—will be copied verbatim to the generated site. There are plenty of *sites already using Jekyll* if you’re curious to see how they’re laid out.


<img src="images/jekyll docs 01.jpg" title="DOCS 01" width="200px" height="200px"/>
<img src="images/jekyll docs 01.jpg" title="DOCS 02" width="200px" height="200px"/>