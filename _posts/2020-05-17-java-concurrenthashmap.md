---
layout: post
author: Kevin Fan
title:  "ConcurrentHashMap 从源码出发分析其线程安全实现(Java8)"
date:   2020-05-17 17:00:00 +8
categories: Java
tags: Java HashMap Map
---

* toc
{:toc}


ConcurrentHashMap是Java JUC(util.concurrent)包下的一个线程安全hashmap，同样的它和hashmap的API 数据结构基本一样，
两者最大的区别就是线程是否安全。下面就通过源码来看看它是如何实现线程安全的还有实现上与hashmap到底有哪些区别


![HashMap Structure](http://www.codenuclear.com/wp-content/uploads/2017/11/bucket_entries.jpg)

<!-- more -->


### HashMap put() 流程

`ConcurrentHashmap`与`HashMap`和基本的结构 API都一样，所以我们直奔主题，看一下关键API的实现。
1. **put() 方法**

put()方法首先会去计算hash，这里有一点区别，`HashMap`是h ^ (h >>> 16，高低位异或，但是Concurrent
不一样，它是(h ^ (h >>> 16)) & HASH_BITS，异或之后和0x7fffffff进行与运算。这里没有想明白，根据计算加不加HASH_BITS
计算的结果都是一样的，可能是出于特殊case(溢出？)的考虑吧。
```java
static final int spread(int h) {
        return (h ^ (h >>> 16)) & HASH_BITS;
    }
//key.hashCode() 是Object类的native方法, 实现是将内部地址转换成一个integer， 但是并不是由Java实现的
public native int hashCode();
```

2. **putVal() 方法**

基本逻辑是一样的，这里主要看一下它的线程安全是如何实现的。`ConcurrentHashMap`是通过cas+synchronized锁来实现的，
首先在put的时候判断当前数组索引下有没有元素，如果没有，我们直接用cas插入值，如果

```java
final V putVal(K key, V value, boolean onlyIfAbsent) {
    // key 不能为null
    if (key == null || value == null) throw new NullPointerException();
    int hash = spread(key.hashCode());
    int binCount = 0;
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        if (tab == null || (n = tab.length) == 0)
            tab = initTable();
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
            if (casTabAt(tab, i, null,
                         new Node<K,V>(hash, key, value, null)))
                break;                   // no lock when adding to empty bin
        }
        else if ((fh = f.hash) == MOVED)
            tab = helpTransfer(tab, f);
        else {
            V oldVal = null;
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    if (fh >= 0) {
                        binCount = 1;
                        for (Node<K,V> e = f;; ++binCount) {
                            K ek;
                            if (e.hash == hash &&
                                ((ek = e.key) == key ||
                                 (ek != null && key.equals(ek)))) {
                                oldVal = e.val;
                                if (!onlyIfAbsent)
                                    e.val = value;
                                break;
                            }
                            Node<K,V> pred = e;
                            if ((e = e.next) == null) {
                                pred.next = new Node<K,V>(hash, key,
                                                          value, null);
                                break;
                            }
                        }
                    }
                    else if (f instanceof TreeBin) {
                        Node<K,V> p;
                        binCount = 2;
                        if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
                                                       value)) != null) {
                            oldVal = p.val;
                            if (!onlyIfAbsent)
                                p.val = value;
                        }
                    }
                }
            }
            if (binCount != 0) {
                if (binCount >= TREEIFY_THRESHOLD)
                    treeifyBin(tab, i);
                if (oldVal != null)
                    return oldVal;
                break;
            }
        }
    }
    addCount(1L, binCount);
    return null;
}
```

### HashMap 的get()

- **get() 方法**

get() 方法会调用getNode()方法， 这是get() 的核心， getNode()方法的两个参数分别是hash值和key
```java
public V get(Object key) {
        Node<K,V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
    }
```
这里重点来看`getNode()`方法，前面讲到过，HashMap是通过key生成的hash值来存储到数组的对应索引上，HashMap在get的时候也是用这种方式来查找元素的。
  1. 根据hash值和数组长度找到key对应的数组索引。
  2. 拿到当前的数组元素,也就是这个链表的第一个元素first，先用hash和equals()判断是不是第一个元素，是的话直接返回，不是的话继续下面的逻辑
  3. 不是链表的第一个元素，判断这个元素first是不是红黑树，如果是调用红黑树的`getTreeNode`方法来查询
  4. 如果不是红黑树结构，从first元素开始遍历当前链表，直到找到要查询的元素，如果没有则返回null
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

### 数组扩容时再哈希(re-hash)的理解

前面提到，当HashMap在put元素的时候，HashMap会调用`resize()`方法来重新计算数组容量，数组扩容之后，数组长度发生变化，我们知道HashMap是根据
key的hash和数组长度计算元素位置的，那当数组长度发生变化时，如果不重新计算元素的位置，当我们get元素的时候就找不到正确的元素了，所以HashMap在
扩容的同时也重新对数组元素进行了计算。

这时还有一个问题，re-hash的时候同一个桶(bucket)上的链表会重新排列还是链表仍然在同一桶上。考虑这个问题的时候先考虑这一点，
那么当它扩容的时候同一个桶上的元素再与新数组长度做与运算`&`时，可能计算出来的数组索引不同。假如数组长度是16即2<sup>4</sup>，扩容后的数组长度将是
32即2<sup>5</sup>，我们用二进在下面来演示与运算

```
原数组 oldLen=16, 二进制为: 0001 0000, oldLen-1: 0000 1111 高位全是0所以忽略掉
新数组 newLen=32, 二进制为: 0010 0000, newLen-1: 0001 1111
HashMap根据length和hash计算索引的公式为 hash & length - 1
假如 hash的低八位是 1010 1010， 计算的时候
                    0001 1111   newLen - 1(32-1=31)     
                &   1010 1010   hash            
                =   0000 1111 
上式中length - 1 的最高几位都为0，所以与操作之后肯定都是0，所以直接忽略高位的0：
                    1 1111   newLen - 1      
                &   0 1010   hash            
                =   0 1111                                                              
```
最终的结果是 0000 1111， 和用oldLen计算的结果一样，其实看上式可以发现真正能改变索引值的是hash第5位(从右向左)上的值，也就是length的最高非零
位，所以，同一个链表上的元素在扩容后，它们的索引只有两种可能，一种就是保持原位(最高非零位是0)，另一种就是length+原索引i(第五位是1，结果就相等于
2<sup>5</sup>+原索引i，也就是length+i)
```markdown
        图示：
                    0001 1111    =     0001 0000 + 0000 1111
                    1010 1010          1010 1010   1010 1010
                    ----------------------------------------
                    0001 1111    =     0001 0000   0000 1111  
```  
源码中就是用这个思路来re-hash一个桶上的链表，`e.hash & oldCap == 0`判断hash对应length的最高非0位是否是1，是1则把元素存在原索引，否则将元素
存在length+原索引的位置。HashMap定义了四个Node对象，`lo`开头的是低位的链表(原索引)，`hi`开头的是高位的链表(length+原索引，所以相当于是新
length的高位)
```java
Node<K,V> loHead = null, loTail = null;  // 低位索引（原索引）上的元素
Node<K,V> hiHead = null, hiTail = null;  // 高位索引（新索引）上的元素
Node<K,V> next;
do {
    next = e.next;
    // 判断是否需要放到新的索引上
    if ((e.hash & oldCap) == 0) {
        // 最高非零位与操作结果是0，扩容后元素索引不发生变化
        if (loTail == null)
            loHead = e;
        else
            loTail.next = e;
        loTail = e;
    }
    else {
        // 需要将元素放到新的索引上
        if (hiTail == null)
            hiHead = e;
        else
            hiTail.next = e;
        hiTail = e;
    }
} while ((e = next) != null);
if (loTail != null) {
    loTail.next = null;
    // 这部分的链表索引没有发生变化，将链表放到原索引上
    newTab[j] = loHead;
}
if (hiTail != null) {
    hiTail.next = null;
    // 这部分的链表索引发生变化，将链表放到新索引上
    newTab[j + oldCap] = hiHead;
}
```

### 总结

- HashMap 底层是**数组+链表**结构，数组长度默认是16，当元素的个数大于数组长度×0.75时，数组会扩容
- HashMap 是**散列表**， 它是根据key的hash值来找到对应的数组索引来储存， 发生hash碰撞的时候（计算出来的hash值相等）HashMap将采用拉链式来储存元素，
也就是我们所说的单向链表结构。
- 在Java7中， 如果hash碰撞，导致拉链过长，查询的性能会下降， 所以在Java8中添加**红黑树结构**， 当一个桶的长度超过8时，将其转为红黑树链表， 
如果小于6， 又重新转换为普通链表
- **re-hash**再哈希问题 HashMap扩容的时候会重新计算每一个元素的索引，重新计算之后的索引只有两种可能，要么等于原索引要么等于原索引加上原数组长度
- 由上一条可知，每次扩容，整个hash table都需要重新计算索引，非常耗时，所以在日常使用中一定要注意这个问题
- HashMap 与HashTable
    - HashMap 是**线程不安全**的， HashTable 线程安全， 因为它在get，put方法上加了`synchronized`关键字。
    - HashMap 和HashTable的hash值是不一样的， 所在的桶的计算方式也不一样。
    HashMap的桶是通过`&`运算符来实现的 `(tab.length - 1) & hash`， 而HashTable是通过取余计算， 速度更慢 `hash & 0x7FFFFFFF) % tab.length`
     （当tab.length = 2^n 时， 两者是等价的， HashMap的数组长度正好都是2^n， 所以这里是等价的）
    - HashTable 的`synchronized`是方法级别的， 也就是它是在put()方法上加的，这也就是说任何一个put操作都会使用同一个锁，而实际上不同索引上
    的元素之间彼此操作不会受到影响；*ConcurrentHashMap* 相当于是HashTable的升级，它也是线程安全的， 而且只有在同一个桶上加锁，也就是说只有
    在多个线程操作同一个数组索引的时候才加锁，极大提高了效率。
     
<br>     

>原文链接：[rollsbean.com/2018/08/08/java-hashmap/](https://rollsbean.com/2018/08/08/java-hashmap/)

### 参考文档

Why is the bucket size 16 by default in HashMap? [https://www.quora.com/Why-is-the-bucket-size-16-by-default-in-HashMap](https://www.quora.com/Why-is-the-bucket-size-16-by-default-in-HashMap)
<br>
集合源码解析之HashMap(基于Java8) [https://www.jianshu.com/p/c77ca6fa6097](https://www.jianshu.com/p/c77ca6fa6097)
<br>
Java HashMap工作原理 [http://www.importnew.com/16599.html](http://www.importnew.com/16599.html)
<br>
HashMap 源码详细分析（JDK1.8） [https://cloud.tencent.com/developer/article/1113700](https://cloud.tencent.com/developer/article/1113700)
