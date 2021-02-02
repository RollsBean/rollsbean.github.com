---
layout: post
title:  "Java Quartz定时任务框架"
date:   2020-09-07 17:42:05 +8
categories: Java Quartz
tags: Java Scheduler Quartz Cron
author: Kevin Fan
---

* content
{:toc}

开源调度框架Quartz

<!-- more -->

### 介绍

#### 如何清理数据

由于quartz生成的表有外键，需要按照一定的顺序删除表

**QRTZ**是在配置文件定义的表前缀
```sql
DELETE FROM `QRTZ_LOCKS`;
DELETE FROM `QRTZ_PAUSED_TRIGGER_GRPS`;
DELETE FROM `QRTZ_SCHEDULER_STATE`;
DELETE FROM `QRTZ_CALENDARS`;
DELETE FROM `QRTZ_CRON_TRIGGERS`;
DELETE FROM `QRTZ_TRIGGERS`;
DELETE FROM `QRTZ_JOB_DETAILS`;
DELETE FROM `QRTZ_BLOB_TRIGGERS`;
DELETE FROM `QRTZ_SIMPLE_TRIGGERS`;
DELETE FROM `QRTZ_SIMPROP_TRIGGERS`;
DELETE FROM `QRTZ_FIRED_TRIGGERS`;
```

