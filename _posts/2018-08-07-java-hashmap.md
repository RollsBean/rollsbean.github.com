---
layout: post
author: Kevin Fan
title:  "Java HashMap 深入学习(Java8)"
date:   2018-08-08 17:00:00 +8
categories: Java
tags: Java HashMap Map
---

* toc
{:toc}

Java中最常用到的Map就是HashMap了，下面就详细地从HashMap的源码中一探它的究竟。

![HashMap Structure](http://www.codenuclear.com/wp-content/uploads/2017/11/bucket_entries.jpg)

<!-- more -->

## HashMap 简介

----

[HashMap](https://baike.baidu.com/item/hashmap) 是基于哈希表的 Map 接口的实现。允许使用 null 值和 
null 键。（除了非同步和允许使用 null 之外，HashMap 类与 Hashtable 大致相同。）此类不保证映射的顺序，也就是说它的元素是无序的。
<br>

首先HashMap 是一个双列结构， 它是一个散列表， 存储方式是键值对存放。 它继承了AbstractMap, 实现了Map<K,V> Cloneable Serializable 接口
<br>
HashMap 的数据结构是*数组Node[]* 加 *链表*结构， 我们知道数组的查询很快，但是修改很慢， 因为数组定常， 所以添加或者减少元素都会导致数组扩容， 
而链表结构恰恰相反, 它的查询慢，因为没有索引， 需要遍历链表查询， 但是它的修改很快， 不需要扩容数组， 只需要在首或者尾部添加即可。
HashMap 正是应用了这两种数据结构， 以此来保证它的查询和修改都有很高的效率。

HashMap在调用put()方法存储元素的时候，会根据key的hash值来计算它的索引，这个索引有什么用呢？HashMap使用这个索引来将这个键值对储存到对应的数组
位置， 比如如果计算出来的索引是n，则它将存储在Node[n]这个位置，HashMap在计算索引的时候尽量保证它的离散，但是还是会有不同的key计算出来的索引是一样的，
那么第二个在put的时候，key就会产生冲突，HashMap用链表的结构解决它，当HashMap发现当前的索引下已经有不为null的Node存在时，HashMap会在这个Node后面添加
新元素，同一索引下的元素就组成了链表结构，Node和Node之间如何联系可以看下面Node类的源码分析。


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
final float loadFactor;
```
* 阈值，扩容的临界值（capacity * load factor）
```java
int threshold;
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
非常重要的一个内部类，实现了Map.Entry，Node 是HashMap中的基本元素，每个键值对都储存在一个Node对象里，Node类有四个成员变量，`hash` key的哈希值，
`key``value`键值对的key和value，`next` 也是Node类型，这个Node指向的是链表下一个键值对，也就是前文提到的hash冲突(碰撞)时HashMap的处理办法.

Node类内部实现了`Map.Entry`接口中的 `getKey()` `getValue()`等方法，所以在遍历Map的时候我们可以用Map.entrySet()遍历。
```java
static class Node<K,V> implements Map.Entry<K,V> {
        final int hash; // 哈希值
        final K key;
        V value;
        // 链表结构, 这里的next将指向链表的下一个Node键值对
        Node<K,V> next; 
        Node(int hash, K key, V value, Node<K,V> next) {
            ...
        }
        public final K getKey()        { return key; }
        public final V getValue()      { return value; }
    }
```

### HashMap put() 流程

1. **put() 方法**

`put()`主要是将key和value保存到Node数组中，HashMap根据key的hash值来确定它的索引，源码里put方法将调用内部的putVal()方法。
```java
public V put(K key, V value) {
        return putVal(hash(key), key, value, false, true);
}
```
HashMap在put键值对的时候会计算key的hash 值， 调用`hash()`方法，hash()方法会调用Object的`native`方法`hashCode()`并且将计算之后的hash值高低位
做异或运算， 增加hash复杂性。（Java里一个int类型占4个字节，一个字节是8bit，所以下面源码中的h与h右移16位就相当于高低位异或）
```java
static final int hash(Object key) {
        int h;
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
//key.hashCode() 是Object类的native方法, 实现是将内部地址转换成一个integer， 但是并不是由Java实现的
public native int hashCode();
```

2. **putVal() 方法**

这部分是主要put的逻辑
 1. 计算容量：根据map的size计算数组容量大小，如果元素数量也就是size大于数组容量×0.75，对数组进行扩容，扩容到原来的2倍。
 2. 查找数据索引：根据key的hash值和数组长度找到Node数组索引
 3. 储存：这里有以下几种情况（假设计算出的hash为`i`，数组为`tab`,变量以代码为例）
    1. 当前索引为null，直接new一个Node并存到数组里，`tab[i]=newNode(hash, key, value, null)`
    2. 数组不为空， 这时两个元素的hash是一样的，再调用equals方法判断key是否一致，相同，则覆盖当前的value，否则继续向下判断
    3. 上面两个条件都不满足，说明hash发生冲突，Java 8里实现了红黑树，本篇也是基于Java 8的源码进行分析，在这里HashMap会判断当前数组上的元素
    tab[i]是否是红黑树，如果是，调用红黑树的`putTreeVal`的put方法，它会将新元素以红黑树的数据结构储存到数组中；
    4. 以上条件都不成立，表明tab[i]上有其他key的元素存在，并且没有转成红黑树结构，这时只需调用`tab[i].next`来遍历此链表，找到链表的尾然后将
    元素存到当前链表的尾部。
```java
    transient Node<K,V>[] table;
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
            // put之后，如果元素个数大于当前的数组容量了，进行数组扩容
            resize();
        afterNodeInsertion(evict);
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
                    0001 1111   newLen - 1      
                    1010 1010   hash            
                =   0000 1111 
上式中length - 1 的最高几位都为0，所以与操作之后肯定都是0，所以直接忽略高位的0：
                    1 1111   newLen - 1      
                    0 1010   hash            
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