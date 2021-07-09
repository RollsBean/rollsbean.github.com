---
layout: post
title:  "Kubernetes 介绍"
date:   2021-06-30 23:00:00 +8
categories: Kubernetes
tags: Kubernetes Docker
author: Kevin Fan
---

* content
{:toc}

Kubernetes 是一个开源的容器编排引擎，用来对容器化应用进行自动化部署、 扩缩和管理。该项目托管在 [CNCF](https://www.cncf.io/about)。
<!-- more -->

## 基本知识

### Kubernetes 是什么

Kubernetes 是一个可移植的、可扩展的开源平台，用于管理容器化的工作负载和服务，可促进声明式配置和自动化。 Kubernetes 拥有一个庞大且快速增长的生态系统。Kubernetes 的服务、支持和工具广泛可用。

简单来说，Kubernetes 可以用于 docker 镜像的管理，包括不限于资源的配置、容器的启动、停止、扩缩容等。

Kubernetes 还可以做：

* **服务发现和负载均衡** 

  Kubernetes 可以使用 DNS 名称或自己的 IP 地址公开容器。

* **存储编排**

  Kubernetes 允许你自动挂载你选择的存储系统，例如本地存储、公共云提供商等。也就是可以挂在外部网盘。

* **自动部署和回滚**

  自动化部署容器。

* **自动完成装箱计算**

  可以指定每个容器所需的 CPU 和内存（RAM）。

  

### Kubernetes 组件

#### 控制平面组件（Control Plane Components）

主要作用是做全局决策（比如调度），以及检测和相应集群事件。

**kube-apiserver** 是控制面的组件，提供了Kubernetes的 API；**etcd** 是兼具一致性和高可用性的键值数据库，可以作为保存 Kubernetes 所有集群数据的后台数据库；**kube-scheduler** 负责监视新创建的、未指定运行节点的 Pods；**kube-controller-manager** 包括了很多控制器，它们都是单独的进程。**cloud-controller-manager** 云控制管理器包括节点控制器、路由控制器、服务控制器。

kube-controller-manager 包括：

- 节点控制器（Node Controller）: 负责在节点出现故障时进行通知和响应
- 任务控制器（Job controller）: 监测代表一次性任务的 Job 对象，然后创建 Pods 来运行这些任务直至完成
- 端点控制器（Endpoints Controller）: 填充端点(Endpoints)对象(即加入 Service 与 Pod)
- 服务帐户和令牌控制器（Service Account & Token Controllers）: 为新的命名空间创建默认帐户和 API 访问令牌

cloud-controller-manager 包括：

- 节点控制器（Node Controller）: 用于在节点终止响应后检查云提供商以确定节点是否已被删除
- 路由控制器（Route Controller）: 用于在底层云基础架构中设置路由
- 服务控制器（Service Controller）: 用于创建、更新和删除云提供商负载均衡器

#### Node 组件

节点组件在每个节点上运行。

#### 容器运行时（Container Runtime）

Kubernetes 支持多个容器运行环境： [Docker](https://kubernetes.io/zh/docs/reference/kubectl/docker-cli-to-kubectl/)、 [containerd](https://containerd.io/docs/)、[CRI-O](https://cri-o.io/#what-is-cri-o) 等。

### 使用 Kubernetes

#### 描述 Kubernetes 对象

**必须字段**：

* `apiVersion` - API 的版本
* `kind` - 对象的类别
* `metadata` - 包括 `name` 和 `namespace` 
* `spec` - 描述对象的字段，不同的对象有不同的格式，用于描述容器等信息

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

#### Pods

*Pod* 是可以在 Kubernetes 中创建和管理的、最小的可部署的计算单元。

对于 Docker 来说，pod类似于一组 Docker 容器。



### kubectl 概述

**kubectl** 是用来管理 Kubernetes 集群的命令行工具。

#### 语法

语法格式：

```shel
kubectl [command] [TYPE] [NAME] [flags]
```

其中：

* `command` : 指定的操作，例如 `create` 、`get` 、`describe` 、`delete` 。
* `TYPE` ：指定资源类型。不区分大小写，可以指定单数、复数或缩写形式。
* `NAME` :指定资源的名称。区分大小写。
* `flags` : 指定可选的参数。例如，可以使用 `-s` 或 `-server` 参数指定 Kubernetes API 服务器的地址和端口。

#### 操作

常见操作：

| 操作          | 语法                                                         | 描述                                  |
| ------------- | ------------------------------------------------------------ | ------------------------------------- |
| api-resources | kubectl api-resources  [flags]                               | 列出可用的 API 资源。                 |
| api-versions  | kubectl api-versions [flags]                                 | 列出可用的 API 版本。                 |
| logs          | kubectl logs POD [-c CONTAINER] [--follow] [flags]           | 在 pod 中打印容器的日志。             |
| get           | kubectl get (-f FILENAME \|TYPE [NAME \|/NAME \|-l label]) [--watch] [--sort-by=FIELD] [[-o \|--output]=OUTPUT_FORMAT] [flags] | 列出一个或多个资源。                  |
| top           | kubectl top [flags] [options]                                | 显示资源（CPU/内存/存储）的使用情况。 |
| run           | kubectl run NAME --image=image [--env="key=value"] [--port=port] [--dry-run=server \|client \|none] [--overrides=inline-json] [flags] | 在集群上运行指定的镜像。              |

 

