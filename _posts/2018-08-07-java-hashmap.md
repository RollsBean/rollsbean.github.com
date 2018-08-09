---
layout: post
author: Kevin Fan
title:  "Java HashMap 深入学习(Java8)"
date:   2018-08-07 17:00:00 +8:00
categories: Java
tags: Java HashMap Map
---

* toc
{:toc}

Java中最常用到的Map就是HashMap了，下面就详细地从HashMap的源码中一探它的究竟。

![Java](https://www.softexia.com/wp-content/uploads/2017/04/Java-logo.png)

<!-- more -->

## HashMap 简介

----

[HashMap](https://baike.baidu.com/item/hashmap) 是基于哈希表的 Map 接口的实现。此实现提供所有可选的映射操作，并允许使用 null 值和 null 键。（除了非同步和允许使用 null 之外，HashMap 类与 
Hashtable 大致相同。）此类不保证映射的顺序，特别是它不保证该顺序恒久不变。 此实现假定哈希函数将元素适当地分布在各桶之间，可为基本操作
（get 和 put）提供稳定的性能。迭代 collection 视图所需的时间与 HashMap 实例的“容量”（桶的数量）及其大小（键-值映射关系数）成比例。
<br>
![HashMap Structure](http://www.codenuclear.com/wp-content/uploads/2017/11/bucket_entries.jpg)

首先HashMap 是一个双列结构， 它是一个散列表， 存储方式是键值对存放。 它继承了AbstractMap, 实现了Map<K,V> Cloneable Serializable 接口
<br>
HashMap 的数据结构是数组Node[]加链表结构， 我们知道数组的查询很快，但是修改很慢， 因为数组定常， 所以添加或者减少元素都会导致数组扩容， 
而链表结构恰恰相反, 它的查询慢，因为没有索引， 需要遍历链表查询， 但是它的修改很快， 不需要扩容数组， 只需要在首或者尾部添加即可。
HashMap 正是应用了这两种数据结构， 以此来保证它的查询和修改都有很高的效率。

```java
public class HashMap<K,V> extends AbstractMap<K,V>
    implements Map<K,V>, Cloneable, Serializable {

    private static final long serialVersionUID = 362498820763181265L;
}
```

### HashMap 里的几个参数：

* 默认初始长度 16
```java
static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16
```
* 最大长度 2^30
```java
static final int MAXIMUM_CAPACITY = 1 << 30;
```
* 默认加载因子 0.75
```java
static final float DEFAULT_LOAD_FACTOR = 0.75f;
```

HashMap 构造函数
```java
// 初始长度 加载因子
public HashMap(int initialCapacity, float loadFactor)

public HashMap(int initialCapacity)
// 无参构造
public HashMap()
// 初始化一个Map
public HashMap(Map<? extends K, ? extends V> m)
```

```java
// 非常重要的一个内部类, 实现了Map.Entry
static class Node<K,V> implements Map.Entry<K,V> {
        final int hash; // 哈希值
        final K key;
        V value;
        // 链表结构, 这里的next将指向链表的下一个Node键值对
        Node<K,V> next; 

        Node(int hash, K key, V value, Node<K,V> next) {
            this.hash = hash;
            this.key = key;
            this.value = value;
            this.next = next;
        }

        public final K getKey()        { return key; }
        public final V getValue()      { return value; }
        public final String toString() { return key + "=" + value; }
    }
```

### HashMap put() 流程

1. **put() 方法**

```java
public V put(K key, V value) {
        return putVal(hash(key), key, value, false, true);
}
```
计算hash值， 调用hash()， 根据key来判断key, 高低位做异或运算， 增加hash复杂性
```java
static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}

//key.hashCode() 是Object类的native方法, 下面是jdk源码中的注释， 意思就是这个实现是将内部地址转换成一个integer， 但是并不是由Java实现的
/**
* (This is typically implemented by converting the internal
* address of the object into an integer, but this implementation
* technique is not required by the Java&trade; programming language.)
*/
public native int hashCode();
```

2. **putVal() 方法**

这部分是主要put的逻辑
```java

    transient Node<K,V>[] table;
    /**
     * @param hash hash for key
     * @param key the key
     * @param value the value to put
     * @param onlyIfAbsent if true, don't change existing value
     * @param evict if false, the table is in creation mode.
     * @return previous value, or null if none
     */
    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        // 根据当前的map size计算容量大小capacity， 主要实现是在resize()中计算capacity，需要扩容的时候， 长度左移一位（二倍）
        if ((tab = table) == null || (n = tab.length) == 0)
            n = (tab = resize()).length;
        // 这里就是经常说的桶结构了， 看过HashMap介绍的都知道它的内部有不同的桶, 这个桶实际上就是一个链表结构
        // 在这个地方， HashMap先判断key所属的桶是否存在。 (n - 1) & hash 相当于计算桶的序号， 根据桶序号来找到对应的桶
        // 这里的table 是HashMap的数组， 数组为空就新建一个数组 newNode(hash, key, value, null)
        if ((p = tab[i = (n - 1) & hash]) == null)
            tab[i] = newNode(hash, key, value, null);
        else {
            //数组不为空， 先判断key是否存在， 存在 就覆盖value
            Node<K,V> e; K k;
            if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
            // 如果此链表是红黑树结构（TreeNode）
            else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            else {
                // 循环当前链表， 找出p.next为空的位置就是链表的末端， 添加上
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {
                        p.next = newNode(hash, key, value, null);
                        // 这里会判断这个链表是否需要转换为红黑树链表
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            treeifyBin(tab, hash);
                        break;
                    }
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    p = e;
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                afterNodeAccess(e);
                return oldValue;
            }
        }
        ++modCount;
        if (++size > threshold)
            resize();
        afterNodeInsertion(evict);
        return null;
    }
```

### HashMap 的get()

- **get() 方法**
get() 方法会调用getNode()方法， 这是get() 的核心， 两个参数分别是hash值和key
```java
public V get(Object key) {
        Node<K,V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
    }
```
```java
final Node<K,V> getNode(int hash, Object key) {
        // tab： HashMap的数组
        Node<K,V>[] tab; 
        Node<K,V> first, e; 
        int n; K k;
        // 判断数组不为空， 桶不为空
        if ((tab = table) != null && (n = tab.length) > 0 &&
            (first = tab[(n - 1) & hash]) != null) {
            // 先查询桶的第一个元素
            if (first.hash == hash && // always check first node
                ((k = first.key) == key || (key != null && key.equals(k))))
                return first;
            // 不是第一个元素
            if ((e = first.next) != null) {
                // 如果是红黑树， 则用红黑树的方法查询
                if (first instanceof TreeNode)
                    return ((TreeNode<K,V>)first).getTreeNode(hash, key);
                // 不是红黑树， 遍历桶， 直到找到对应的key， 返回
                do {
                    // 1. 判断hash值是否相等； 2. 判断key相等。 防止hash碰撞发生
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        return e;
                } while ((e = e.next) != null);
            }
        }
        return null;
    }
```

### 总结

- HashMap 是散列表， 因为它是根据key的hash值来储存的， 发生hash碰撞的时候（计算出来的hash值相等）采用拉链式， 也就是我们所说的单向链表结构
- 在Java7中， 如果hash碰撞，导致拉链过长，查询的性能会下降， 所以在Java8中添加红黑树结构， 当一个桶的长度超过8时，将其转为红黑树链表， 
如果小于6， 又重新转换为普通链表
- HashMap 与HashTable
    - HashMap 是线程不安全的， HashTable 线程安全， 因为它在get，put方法上加了`synchronized`关键字。
    - HashMap 和HashTable的hash值是不一样的， 所在的桶的计算方式也不一样。
    HashMap的桶是通过`&`运算符来实现的 `(tab.length - 1) & hash`， 而HashTable是通过取余计算， 速度更慢 `hash & 0x7FFFFFFF) % tab.length`
     （当tab.length = 2^n 时， 两者是等价的， HashMap的数组长度正好都是2^n， 所以这里是等价的）
    - HashTable 的`synchronized`是方法级别的， 也就是它是在put()方法上加的， 而ConcurrentHashMap 相当于是HashTable的升级，
     它也是线程安全的， 而且只有在同一个桶上加锁， 极大提高了效率。
     


### 参考文档

Why is the bucket size 16 by default in HashMap? [https://www.quora.com/Why-is-the-bucket-size-16-by-default-in-HashMap](https://www.quora.com/Why-is-the-bucket-size-16-by-default-in-HashMap)
<br>
集合源码解析之HashMap(基于Java8) [https://www.jianshu.com/p/c77ca6fa6097](https://www.jianshu.com/p/c77ca6fa6097)
<br>
Java HashMap工作原理 [http://www.importnew.com/16599.html](http://www.importnew.com/16599.html)
<br>
HashMap 源码详细分析（JDK1.8） [https://cloud.tencent.com/developer/article/1113700](https://cloud.tencent.com/developer/article/1113700)