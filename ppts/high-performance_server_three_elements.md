title: 高性能服务端三要素
speaker: Tony Deng
url: https://gitlab.duoquyuedu.com/dengtao/note/master/ppts/md/high-performance_server_three_elements
transition: cover-diamond
files: /js/demo.js,/css/demo.css

[slide data-transition="vertical3d" style="background-image:url('/img/high-performance-server/cover.jpg')"]

# 高性能服务端三要素
<small>Tony Deng</small>

https://twitter.com/wolfdeng

https://delicious.com/wolf.deng

https://friendfeed/tonydeng

[slide data-transition="vertical3d"]

## 引言

开发一个高性能的服务端需要些什么？

[slide data-transition="kontext"]

## 牛逼开发语言？
----
*  ```Java``` {:&.moveIn}
*  ```Go```
*  ```Scala```
*  ```PHP```
*  ```C \ C++```
*  ```Ruby```
*  ```NodeJS```
*  ```Python```

[slide data-transition="vkontext"]

## 牛逼的开发框架？ 
----
* ```Spring``` {:&.moveIn}
* ``` Martini```
* ```Play```
* ```Yii```
* ```ROR```
* ```Express```
* ```Django```

[slide data-transition="circle"]
## 牛逼的服务器？

[slide data-transition="earthquake"]
## 上面的讨论，可能我们期待的是这样场面
----
![美女打架](/img/high-performance-server/mm.jpg "美女打架")

[slide data-transition="cards"]

## 然而实际可能产生的结果可能是......
----
![程序猿打架](/img/high-performance-server/gorilla-fight.jpg "程序猿打架")

别忘了，美女对于程序猿这个职业来说，基本上是非常非常稀奇的资源 

[slide data-transition="glue"]

## So

我们今天不谈硬件，不谈操作系统，不评论开发语言及框架，不谈论算法

[slide data-transition="stick"]

## 三个关键词

** ```Cache``` **
** ```Asynchronous``` **
** ```Concurrent``` **

[slide data-transition="kontext"]

## Cache

[slide data-transition="kontext"]

Cache翻译成中文就是**“缓存”**，台湾的叫法是**“快取”**

其本质是将```获取缓慢```或```计算缓慢```的数据结果暂时存储起来，以便以后再次获取或计算```同样地数据```可以直接从存储中获得结果，从而可能```提升性能```的一种手段。

[slide data-transition="vkontext"]

## Cache的起源

Cache其实最早应用在计算机的CPU中，有兴趣的同学可以自行Google

[slide data-transition="earthquake"]

```
1+2+3+4+..+99+100=?
```

每隔一分钟进行上面的计算，你会怎么做？


[slide data-transition="cards"]

## 下面几个方式，你会选择哪个？

* 一个一个的加一遍  {:&.bounceIn}
* OK，这是一个**发散级数**的计算，直接使用公式```(1/2)*100*(100+1)```，或者这样的公式```100*(100+1)/2```，（估计我需要一秒钟）
* 第一次算完之后就直接在某张纸上记住上面计算的结果，等到下一分钟直接给出来就好了

[slide data-transition="zoomin"]

计算机只会选择第一种方式来完成这个要求。

虽然上面的计算对于计算机来说，纸上小菜一碟，但是计算机往往面临的计算量比这个大的多得多

[slide data-transition="zoomout"]

就像刚才那个场景一样，你会发现一些非常复杂的计算结果是可以复用的，而且把这个结果暂时存储在某个地方，查起来也很方便。（就像我们之前用小纸条来记录计算结果一样）

```这个小纸条就是Cache```

[slide data-transition="newspaper"]

## 缓存策略

理解了Chace，我们可以来思考一些缓存的设计策略

> 不同的缓存策略和具体的业务场景关系非常大，制定缓存策略需要根据具体的情况来分析。

[slide data-transition="slide"]

## 常用的策略

* 最终结果型缓存 {:&.fadeIn}
    * 这种缓存往往提升性能效果最为明显，但是命中率却低，也就是可重用性不高。
* 中间结果型缓存
    * 比如上面的例子，1加到100，可以构建1加到10，10加到20...一直到90加到100。
    * 好处是：如果要计算1加到60的时候，你依然可以使用这些缓存结果
    * 坏处也很明显：你取到几个缓存的结果后 ，不得不再一次进行计算
    * 实际情况，往往是在最终结果和中间结果之前找个平衡点，或者是两者配合使用

[slide data-transition="slide"]

## 其他需要缓存的场景

上面的```1+2+3+...+100=5050```这个结果是永远不会变化的，但是如果我们需要缓存今天的天气情况呢？或者需要缓存某一个列表，当这个列表发生变化了，我们应该怎么使用缓存呢？
    
[slide data-transition="slide1"]

## 缓存的过期策略 

* 永久式缓存 {:&.bounceIn}
    * 结果在任何情况下都不发生改变，无需清除或更新
* 会过期的缓存
    * 在特定时间或时间段后失效
* 触发式失效缓存
    * 当某一事件产生时，缓存失效
    * 缓存过期也可以理解成时间点或时间段到期为触发条件的触发式失效缓存
    
[slide data-transition="slide2"]

## 缓存的更新

既然提到了缓存的更新或清除，那么就涉及到缓存的更新策略。

[slide data-transition="slide2"]

## 例子永远好于理论

假如我们要缓存某个分类的书籍列表，那么我们有些什么样的策略来进行缓存呢？

* 当用户请求时，检查是否存在这样的缓存。 {:&.moveIn}
    * 如果有，则直接返回缓存数据； {:&.moveIn}
    * 否则，我们通过计算生成这个列表，将这个数据返回给用户并将书籍缓存起来，以便以后的用户请求时直接获取。 这个缓存我们可以设定一个合理的过期时间，或者当这个分类的书籍信息发生变化时，清除这个缓存。 
* 每当这个分类的书籍发生变化时，我们都重新构建这个缓存，用户每次查看分类的书籍列表都是取缓存数据

[slide data-transition="slide2"]

## 缓存的更新策略

* 被动式缓存 {:&.zoomIn}
    * 需要时才构建
* 主动式缓存
    * 预先构建
    
[slide data-transition="newspaper"]

##  Asynchronous

[slide data-transition="newspaper"]

## 什么是**异步**？

就是不在第一时间告知调用者结果，告诉他我已经收到这个任务了，我会处理，处理完了通知你结果。

> 如果你不是等不到结果就无法进行下去的话，你完全可以先去做别的事情。

[slide data-transition="move"]

## 继续举栗子

> 你去一个咖啡店点了一杯咖啡，服务员告诉你需要15分钟才能做好，那在咖啡做好之前，你肯定不会一直在柜台前盯着服务员或咖啡师15分钟（如果美女可能会有例外...）。你肯定会干点别的，比如会看看手机或者和身边的朋友聊天......总之，你不会傻乎乎的等着。等到咖啡做好了，服务员会给你把咖啡送过来。
>

你在等待咖啡的过程中做了很多与这次购买咖啡无关的事情，这就是**异步**。你的大脑不必为一个漫长的过程卡住，可以继续其他的事情

[slide data-transition="move"]

异步已经在现在各种编程语言和框架中都有相应地支持，比如AJAX，就是一种异步的手段。

[slide data-transition="move"]

## 简单说一下AJAX的原理

AJAX使用回调的方式来支持异步，大致流程是：A交代给B一个任务，并且告知B “任务完成后继续执行哪段程序（往往包装成一个匿名的函数）”，B执行完任务后，执行这个匿名的方法，这样来完成异步过程。

在Javascript中大量的使用这种回调的异步方案，已经不再局限于一个缓慢的过程了，可以对于几乎所有的过程都采用异步处理。（基于Javascript的NodeJS更是将这种异步方案使用到极致）

[slide data-transition="move"]

## AJAX流程图
![Ajax流程图](/img/high-performance-server/ajax.gif)

[slide data-transition="move"]

## 异步的方式

在服务端的程序中，除了使用[线程](http://zh.wikipedia.org/zh-cn/%E7%BA%BF%E7%A8%8B)、[协程](http://zh.wikipedia.org/zh-cn/%E7%BA%BF%E7%A8%8B)、[回调](http://zh.wikipedia.org/zh-cn/%E5%9B%9E%E8%B0%83%E5%87%BD%E6%95%B0)以外，另外一种常见的异步的支持方式就是[消息队列](http://zh.wikipedia.org/zh-cn/%E6%B6%88%E6%81%AF%E9%98%9F%E5%88%97)。

[slide data-transition="move"]

## 消息队列原理

生产者发送消息到消息队列中，消费者监听这个队列，当发现有消息之后，从队列取出消息，并作出相应处理，并把结果存储起来或者通过某种方式告知生产者。

[slide data-transition="move"]

## 注意

异步再很多时候，可以运用现代化计算机CPU的多核特性和分布式计算特性，能显著的提升应用的性能，但是一定要注意一个**前提**就是：

> 异步任务的结果必须是主进程进行下一步操作所不依赖的，否则主进程必须等待，直到这个任务执行结束，拿到结果再进行下一步，这时就变成传统的同步计算了。

[slide data-transition="circle"]

##  Concurrent

[slide data-transition="circle"]

## Concurrent的意思就是并行。

如果将一个任务拆分成多个更小的任务，同时来进行，这样是不是更快些呢？

[slide data-transition="circle"]

现代的CPU往往具有多个核心，而且有些CPU也具有超线程能力，我们完全可以将一个任务拆成多个小得任务，交给CPU的多个核心，或者分布式计算系统的多个计算节点，就可以充分利用并行计算来提升性能。

[slide data-transition="circle"]

## 前提

你要拆分的各个小任务之间**不要有相互依赖**的关系。

[slide data-transition="circle"]

## 依然是栗子

有一批用户，我们需要计算他们的活跃度。

* 传统的方式： {:&.moveIn} 
    * 查出这一批用户，然后写一个循环，然后轮流计算他们的积分，最后得到的结果 
* 并行的方式： 
    * 其实每个用户的计算都是独立的，相互不依赖，那么我们就可以利用这一点来进行并行计算   

[slide data-transition="circle"]
    
## 上代码    

[slide data-transition="circle"]

## 某段使用了并行计算的代码

```java
public List<Commit> getCommits(String objectId, String path, int offset, int maxCount) {
        List<String> shas = getCommitsSha(this, objectId, path, offset, maxCount);
        List<Commit> commits = new ArrayList<>();

        if (shas != null) {
            List<GetCommit> getCommits = new ArrayList<>();
            for (String sha : shas) {
                getCommits.add(new GetCommit(this, sha));
            }

            //声明一个自适应的线程池
            ExecutorService executor = Executors.newFixedThreadPool(8);

            List<Future<Commit>> futureList = null;

            //并发的调用getCommit
            futureList = executor.invokeAll(getCommits);
            executor.shutdown();

            for (Future<Commit> future : futureList) {
                Commit commit = future.get();
                commits.add(commit);
            }        
        }
        return commits;
    }
```

[slide data-transition="circle"]

## 关键代码

利用Java的Cocurrent包来做并发循环，充分利用多核来尽快得到执行结果

```java
//声明一个自适应的线程池
ExecutorService executor = Executors.newFixedThreadPool(8);

List<Future<Commit>> futureList = null;

//并发的调用getCommit
futureList = executor.invokeAll(getCommits);
executor.shutdown();

```

[slide data-transition="cards"]

## 总结

[slide data-transition="cards"]

关于高性能服务端程序需要注意的点还有很多，这里只是简单介绍了Cahce（缓存）、Asynchronous（异步）、Concurrent（并行）三个利器。即便我介绍的也只是这三个利器的冰山一角，但是请相信，如果你理解了这三个东西，从和你关系思考服务端变成，会获得不少的收获。

[slide data-transition="cards"]

这三者也是相辅相成的关系，很多时候都是配合着使用才能起到很好的效果。异步和并行在某种程度上是有重叠的，而我们经常使用异步的方式去主动构建缓存。

[slide data-transition="kontext"]

## 最后的小提示

* 不要让CPU闲着（CPU正常情况下压力大的时候自然不会闲着，这里指CPU负载低的时候，可以让它主动构建缓存，或者做一些准备工作等等）。
* 提升CPU效率，即不要总让CPU做重复的劳动，用空间换时间的理念来减轻CPU的压力。
* 不要让无关紧要的任务卡住主进程，让他们在后台慢慢做。
* 可以提前做好准备工作，这个比较抽象，但是举个栗子就明白了：连接池、主动缓存以及之前的代码栗子都是很好地栗子