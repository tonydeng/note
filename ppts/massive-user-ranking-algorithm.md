title: 海量用户积分排名算法
speaker: Tony Deng
url: https://github.com/tonydeng/note/master/ppts/md/massive-user-ranking-algorithm.md
transition: cover-diamond
theme: colors

[slide data-transition="vertical3d"]

# 海量用户积分排名算法

<small>Tony Deng</small>

https://tonydeng.github.io

https://twitter.com/wolfdeng

[slide data-transition="earthquake"]

# 场景描述

[slide data-transition="stick"]

某海量用户网站，用户拥有积分，积分可能会在使用过程中随时更新。

现在为该网站设计一种算法，在每次用户登录时显示其当前积分排名。

用户最大规模为2亿；积分为非负整数，且小于100万。

[slide data-transition="slide2"]

# 算法1： 简单SQL查询

[slide data-transition="newspaper"]

# 存储结构

```mysql
desc user_score;
```

```mysql
+---------+------------------+--------+-------+-----------+----------------+
| Field   | Type             | Null   | Key   |   Default | Extra          |
|---------+------------------+--------+-------+-----------+----------------|
| uid     | int(11) unsigned | NO     | PRI   |    <null> | auto_increment |
| score   | int(11)          | NO     | MUL   |         0 |                |
+---------+------------------+--------+-------+-----------+----------------+
```

[slide data-transition="slide"]

# 示例数据

```mysql
select * from user_score;
```

```mysql
+-------+---------+
|   uid |   score |
|-------+---------|
|     3 |       0 |
|     9 |       8 |
|     4 |      99 |
|     1 |     232 |
|    10 |     555 |
|     5 |     878 |
|     8 |   69891 |
|     6 |  999999 |
|     2 | 1000289 |
+-------+---------+
```
[slide data-transition="move"]
# 简单SQL查询

```mysql
select t1.score, 1+count(t2.score) as rank
from user_score t1, user_score t2
where t1.uid =5 and t2.score>t1.score;
```

```mysql
+---------+--------+
|   score |   rank |
|---------+--------|
|     878 |      4 |
+---------+--------+
1 row in set
Time: 0.002s
```

[slide data-transition="horizontal"]

# 优点

1. 简单，利用SQL的功能，不需要复杂的查询逻辑，也不需要引入额外的存储结构。

1. 对于小规模或性能要求不高的应用来说，不失为一种良好的解决方案

[slide data-transition="zoomout"]

# 缺点

1. *user_score* 表进行全表扫描。

1. 如有积分更新，会对表造成锁定，在海量数据规模和高并发的场景下，性能是无法接受的。

[slide data-transition="slide3"]

# 算法2：均匀分区设计

[slide data-transition="pulse"]

# 设计原理

* 真实的积分变换其实也是有一定规律的，通常一个用户的积分不会突然暴增暴跌。

* 一般用户总是要在低分区混迹很长时间才会慢慢升入高分区。也即是说，* 用户积分的分布总体来说是有区段的 * 。

* 进一步考虑，*高分区用户的细微变化其实对低分区用户的排名影响不大*。

[slide data-transition="cards"]

# 存储结构

```mysql
desc score_range;
```

```mysql
+------------+---------+--------+-------+-----------+---------+
| Field      | Type    | Null   | Key   |   Default | Extra   |
|------------+---------+--------+-------+-----------+---------|
| from_score | int(11) | NO     | PRI   |         0 |         |
| to_score   | int(11) | NO     | PRI   |         0 |         |
| count      | int(11) | YES    |       |         0 |         |
+------------+---------+--------+-------+-----------+---------+
```

[slide data-transition="vkontext"]
# 数据示例

```mysql
select * from score_range;
```

```mysql
+--------------+------------+---------+
|   from_score |   to_score |   count |
|--------------+------------+---------|
|            0 |       1000 |   48892 |
|         1000 |       2000 |   25329 |
|         2000 |       3000 |   12568 |
|         3000 |       4000 |   10207 |
+--------------+------------+---------+
4 rows in set
Time: 0.002s
```
[slide data-transition="circle"]

* 如果我们按每1000分划分一个区间，则有[1,1000],[1000,2000],...,[999 000,1 000 000]这1000个区间。

* 在分区积分表的辅助下查询积分为`2012`的用户排名，可以首先确定其所属区间，把高于该用户在本区间内的count值累加，然后再查询出该用户在本区间内的排名，相加即可知道用户的排名。

[slide data-transition="earthquake"]
## 执行SQL

```mysql
select sum(count) as higt_rank
from score_range
where from_score > 2000 and to_score> 3000;
```

```mysql
+-------------+
|   higt_rank |
|-------------|
|       10207 |
+-------------+
1 row in set
Time: 0.001s
```

```mysql
select t1.uid, t1.score, 1+count(t2.uid) as low_rank
from user_score t1, user_score t2
where t1.uid = 1 and t2.score > t1. score and t2.score < 2000
```

```mysql
+-------+---------+------------+
|   uid |   score |   low_rank |
|-------+---------+------------|
|     1 |     232 |          3 |
+-------+---------+------------+
1 row in set
Time: 0.002s
```
[slide data-transition="glue"]

## explain分析

```mysql
explain select t1.uid, t1.score, 1+count(t2.uid) as low_rank
from user_score t1, user_score t2
where t1.uid = 1 and t2.score > t1. score and t2.score < 2000

+------+---------------+---------+--------------+--------+-----------------+---------+-----------+--------+--------+------------+--------------------------+
|   id | select_type   | table   |   partitions | type   | possible_keys   | key     |   key_len | ref    |   rows |   filtered | Extra                    |
|------+---------------+---------+--------------+--------+-----------------+---------+-----------+--------+--------+------------+--------------------------|
|    1 | SIMPLE        | t1      |       <null> | const  | PRIMARY,score   | PRIMARY |         4 | const  |      1 |        100 | <null>                   |
|    1 | SIMPLE        | t2      |       <null> | range  | score           | score   |         4 | <null> |      2 |        100 | Using where; Using index |
+------+---------------+---------+--------------+--------+-----------------+---------+-----------+--------+--------+------------+--------------------------+
```

```mysql
explain select t1.uid, t1.score, 1+count(t2.uid) as low_rank
from user_score t1, user_score t2
where t1.uid = 1 and t2.score > t1. score;

+------+---------------+---------+--------------+--------+-----------------+---------+-----------+--------+--------+------------+--------------------------+
|   id | select_type   | table   |   partitions | type   | possible_keys   | key     |   key_len | ref    |   rows |   filtered | Extra                    |
|------+---------------+---------+--------------+--------+-----------------+---------+-----------+--------+--------+------------+--------------------------|
|    1 | SIMPLE        | t1      |       <null> | const  | PRIMARY,score   | PRIMARY |         4 | const  |      1 |        100 | <null>                   |
|    1 | SIMPLE        | t2      |       <null> | range  | score           | score   |         4 | <null> |      5 |        100 | Using where; Using index |
+------+---------------+---------+--------------+--------+-----------------+---------+-----------+--------+--------+------------+--------------------------+
```

[slide data-transition="stick"]

* 从分析结果来说，扫描的条数少了，不过依然是对所有score小于2000的记录都进行了扫描。

* 二八定律告诉我们，前20%的低分区往往集中了80%的用户。对于大量低分区用户进行排名查询的性能远不及对少数高分区用户进行排名查询。

* 这种分区方式并没有带来实质的性能提升。

[slide data-transition="cards"]

# 优点

注意到了积分区间的存在，并通过预先聚合消除查询的全表扫描。

[slide data-transition="slide3"]

# 缺点

积分非均匀分布的特定使得性能提升并不理想。

[slide data-transition="circle"]

# 还有办法吗❓

[slide data-transition="cards"]

### 能不能按二八定律，把score_range表设计未非均匀区间呢？

> 比如，低分区密集一些，10分一个区间，然后在逐步变成100分，1000分，10000分.......

[slide data-transition="earthquake"]

# 算法3：树形分区设计
[slide data-transition="newspaper"]

* 把[0,1 000 000]作为一级区间，再把一级区间分为两个二级区间[0, 500 000]，[500 001, 1 000 000]，然后在把二级区间二分为4个三级区间，以此类推，最终我们会得到1 000 000个21级区间。 [0,1],[1,2] ... [999 999,1 000 000]。

* 其实就把区间组织成一种*平衡二叉树*结构。

[slide data-transition="move"]

![tree](/img/massive-user-ranking/tree.png)

[slide data-transition="pulse"]

## 如何更新

* 每次用户积分有变化需要更新的区间数量和积分变化量有关系，积分变换越小，更新的区间层次越低。

* 总体上，每次需要更新的区间是用户积分变量的*log n*级别的，也就是说，如果用户积分一次变化在百万级，更新区间的数量在二十这个级别。

[slide data-transition="zoomout"]

## 如何查询

在这种树形分区积分表的辅助下查询积分为`s`的用户排名，实际上是一个在区间树上由上至下、由粗到细一步步明确`s`所在位置的过程。

[slide data-transition="slide"]

*比如，对于积分 499 000，我们用一个初值为0的排名变量来做累加*
* 首先，它属于1级区间的左子树[0,500 000]，那么该用户排名应该在右子树[500 000,1 000 000]的用户数count之后，我们把该count值累加到该用户排名变量，进入下一级区间；
* 其次，它属于3级区间的[250 000, 500 000]，这是2级区间的右子树，所以不用累加count到排名变量，直接进入下一级区间；
* 再次，它属于4级区间的......
* 直到最后我们把积分精确定位到21级区间[499 000,499 001]，整个累加过程完成，得出排名。
[slide data-transition="zoomout"]

![algorithm3](/img/massive-user-ranking/algorithm3.png)

[slide data-transition="pulse"]
# 关于性能提升

1. 更新和查询虽然都涉及若干个操作，但如果我们为*from_score*和*to_score*建立索引，这些操作都是`基于键的查询和更新，不会产生表扫描`，因此效率更高。

1. 结构并不依赖关系数据模型和SQL运算，可以`轻易改造为NoSQL等其他存储`，而基于键的操作也`很容易引入缓存机制进行优化性能`。

1. 整个树形区间的数目大约为 *200 000 000*，考虑每个节点的大小，整个结构只占用*几十M*空间，完全可以在内存建立区间树结构，并通过 *user_score* 表在 *O(n)* 的时间内初始化区间树，然后排名的查询和更新操作都可以在内存进行。一般来说，`同样的算法，从数据库到内存的性能提升常常可以达到100%以上`。

[slide data-transition="vkontext"]
#优点

1. 结构稳定，不受积分分布影响

1. 每次查询或更新的复杂度为积分最大值得O(log n)级别，且与用户规模无关，可以应对海量规模

1. 不依赖SQL，容易改造成NoSQL或内存数据结构

[slide data-transition="move"]
# 缺点

算法相对复杂

[slide data-transition="stick"]

# 算法4： 积分排名数组

[slide data-transition="vkontext"]

算法3虽然性能较高，达到积分变化的`O(log n)`的复杂度，但是实现比较复杂。而且`O(log n)`的复杂度只在`n特别大的时候`才显示出它的优势，而实际应用中积分变化情况往往不会太大 ，这时和`O(n)`的算法相比往往没有明显的优势，甚至更慢。

[slide data-transition="move"]

考虑到这种情况，仔细观察一下积分变化对排名的具体影响，可以发现某用户的积分从`s`变为`s+n`，`积分小于s`或者`大于等于s+n`的其他用户排名实际上并不会受到影响，`只有积分在[s, s+n]区间内`的用户排名会下降1位。

[slide data-transition="newspaper"]

我们可以用一个大小为`100 000 000的数组表示积分和排名的对应关系`，其中rank数组可以有`user_score`表在O(n)的复杂度内计算而来。用户排名的查询和更新基于这个数组来进行。查询积分s对应的排名直接 访问rank[s]即可，复杂度为O(1)；当用户积分从s变为s+n，只需要把`rank[s]到rank[s+n-1]这个n元素的值加1`即可，复杂度为O(n)。

[slide data-transition="stick"]

## 积分变化前

![algorithm4-1](/img/massive-user-ranking/algorithm4-1.png)

[slide data-transition="stick"]

## 积分变换后

![algorithm4-2](/img/massive-user-ranking/algorithm4-2.png)

[slide data-transition="glue"]
# 优点

1. 积分排名数组比区间数更简单，易于实现

1. 排名查询复杂度为O(1)

1. 排名更新复杂度为O(n),在积分变换不大的情况下非常高效。

[slide data-transition="earthquake"]
# 缺点

当n比较大时，需要更新大量元素，效率不如算法3.

[slide data-transition="newspaper"]
# 总结
[slide data-transition="circle"]

上面介绍的用户积分排名算法。

* 算法1简单，易于理解和实现，适用于小规模和低并发场景

* 算法3引入较复杂的树形分区结构，但是O(log n)的复杂度性能优越，可以应用于海量规模和高并发

* 算法4采用简单的排名数组，易于实现，在积分变换不大的情况下性能不亚于算法3。

[slide data-transition="cards"]
# Q & A
