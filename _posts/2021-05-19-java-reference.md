# Java 引用

## 正常引用（强引用）

Java默认的引用是强引用，也就是在JVM在内存回收时，只有有引用或者枚举根节点能查到就不会被回收。

```java
Object o = new Object();
```
如上，只有对象o还指向这个对象实例，就不会被gc回收。

## 其他引用

**java.lang.ref**类库包含了一组类，这些类为垃圾回收提供了更大的灵活性。有三个继承自抽象类**Reference**的类，**SoftReference**、
**WeakReference**和**PhantomReference**。

如果想保持对某个对象的引用，希望以后还能访问到它，但是也希望垃圾回收机释放它，这时就可以使用**Reference**对象。

**SoftReference**、**WeakReference**和**PhantomReference**由强到弱排列，对应不同级别的 "可获得性"。

- **SoftReference**：较强，用于实现内存敏感的高速缓存
- **WeakReference**：较弱，为实现 "规范映射"而设计，它不妨碍垃圾回收区回收映射的 "键"或"值"。
- **PhantomReference**：最弱，用以调度回收前的清理工作，它比Java终止机制更灵活。

使用**SoftReference**和**WeakReference**时，可以选择将它放入**ReferenceQueue**（用作回收前清理的工具）。而**PhantomReference**必须依赖
于**ReferenceQueue**。

### 软引用 SoftReference

如果内存足够，垃圾回收器就不会回收它，如果内存空间不足，就会回收这些对象。

```java
Object obj = new Object();
ReferenceQueue queue = new ReferenceQueue();
SoftReference reference = new SoftReference(obj, queue);
//强引用对象置空，保留软引用
obj = null;
```

#### 使用场景

用于实现高速缓存等

1. 希望线程隔离的对象，但是它又是静态的，比如SimpleDateFormat
2. 用于session缓存，将session放到ThreadLocal中，它里面的ThreadLocalMap的key就是软引用

### 弱引用 WeakReference

弱引用的对象拥有更短的生命周期，只要垃圾回收器扫描到它，不管内存空间充足与否，都会回收它的内存。

### 虚引用 PhantomReference

不影响对象的生命周期，它必须与引用队列一起用。

### WeakHashMap 


### 补充Java GC

#### Young GC

在Young Generation(新生代)的Eden区的空间不足以容纳新生成的对象时执行, 同时会将 Eden 区与 From Survivor 区中尚且存活的对象移动至空闲的 To Survivor 区中.

#### Full GC

又叫Major GC(主收集), 是对整个Java Heap中的对象(包括永久代/元空间)进行垃圾收集.

1.年老代(Tenured)空间不足:
通过Minor GC后进入老年代的对象的体积大于老年代的可用空间;由Eden块、From Space块向To Space复制存活对象时, 它们的体积大于To Space的大小, 系统就会把这些对象转存到老年代, 而老年代的可用空间小于这些对象的体积.
2. System.gc()方法被显式调用, 系统建议执行Full GC, 但并不会立即执行 —— 非常影响程序性能, 建议禁止使用;
3. 上一次GC之后Heap中各个区域空间的动态变化.