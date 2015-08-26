title: 版本控制和常用的分支模型
speaker: Tony Deng
url: https://github.com/tonydeng/note/master/ppts/md/revison_contorl_branch_pattern
transition: move
files: /js/demo.js,/css/demo.css,/js/zoom.js
theme: colors

[slide style="background-image:url('/img/revsion_contorl/version_contorl.png')"]

# 版本控制和常用分支模型

<small>Tony Deng</small>

[https://twitter.com/wolfdeng](https://twitter.com/wolfdeng)

[https://delicious.com/wolf.deng](https://delicious.com/wolf.deng)

[https://friendfeed/tonydeng](https://friendfeed/tonydeng)

[https://tonydeng.github.io/](https://tonydeng.github.io/)

[slide data-transition="vertical3d"]

## 什么是版本控制

版本控制是一种在开发的过程中对**软件开发历史系统的跟踪的方法**

http://zh.wiipedia.org/wiki/版本控制

[slide data-transition="horizontal"]

## 版本控制系统

* 集中式
    * Subversion
    * CVS
    * VSS    
* 分布式
    * Git
    * Mercurial 
    
[slide data-transition="vertical3d"]
## 最简单地版本控制

在自己的或共享的文件系统中保留软件的不同版本的若干份Copy，并对这些Copy进行编号。

[slide data-transition="vertical3d"]
## 通过Copy的版本控制的问题

* 保存的数份Copy几乎会完全一样
* 太依赖开发者的自律
* 容易Copy错误的版本

[slide data-transition="horizontal"]
## 如何做好版本控制

* 选用一个优秀的版本控制系统，比如```Git```
    * 高效 {:&.rollIn}
    * 开源
    * 容易配置
    * 容易整合
    * 分支太爽了
    * 有多种工作流可以便于团队合作

[slide data-transition="vertical3d"]
## 什么时候开始版本化


[slide data-transition="earthquake"]
## 一开始就要版本化

* 在项目中有些东西要保存在比草稿更加正式的地方，那么绝对要将其版本化
* 一旦我们需要在记录一些东西的时候，我们就必须将它放入到版本库中，让相关的人都能够通过版本库看到这个的演进历程
* 只要人类的智慧就要版本化。代码、测试用例、编译脚本、文档、任务列表、解释说明、演讲稿、想法、需求等，只要是经过人的大脑创造出来的一切，都应该记录在版本控制系统中。除非你有更好的理由将它们放在别处。

[slide data-transition="vertical3d"]

## 注意

计算机生成的文件就不必放入版本控制中了。如果放入的话，只能导致不同环境下项目出现不一致的情况。


[slide data-transition="vertical3d"]

## 如何忽略

如果是```git```，我们可以选择用`.gitignore`来忽略这些文件。

```
*.class

# Package Files #
*.jar
*.war
*.ear
#Eclipse Files#
*.pydevproject
.project
.metadata
bin/**
tmp/**
tmp/**/*
**/tmp/*
*.tmp
*.bak
*.swp
*~.nib
local.properties
.classpath
.settings/
.loadpath
```
[slide data-transition="horizontal"]

## 一定要写commit message

基本上所有的版本控制系统都会在每一次更改的时候都会让你留下每次提交的备注，目的是解释一下你对提交的代码都做了什么？

**千万别忽略这一步，一定要写，并且好好写**

[slide data-transition="vertical3d"]
## 如何好好写commit message

![commit_message](/img/revsion_contorl/commit_message_2.jpg)

[slide data-transition="vertical3d"]

## 如何好好写commit message

* 不光是为了别人而写，也是为了自己，认真细致的记录日志会迫使你梳理你的设计，看清问题所在，认清正在做的事情，也会使得想知道细节的人（同样包括未来某个时刻的你）与代码的作者有个交流。

* 把“做了什么”记下来，而不是“怎么做的”。要是“怎么做的”真的那么令人感兴趣，而且中修改本身很难去理解，当然有必要记一记，但是通常代码本身已经很能说明“怎么做的”了。要是真的有什么地方不清楚的话，一定是你的思路。

* 描述点滴所做。版本控制系统能帮助你找到你所做的更改，要试着将所有的修改都详细地告诉系统。推论：不要做自己都解释不清楚的事情。要将其分割成很多比较小的步骤，然后一个一个来做。

[slide data-transition="horizontal"]

修改要小到原子理想的情形下，每次修改只包含一个意图，每条日志只是说明了一个问题的单句段落。有一条傻瓜法则用于判断两个相互关联的事情到底是一个还是两个原子修改：问问自己会不会有人只想撤销其中一个而保留另外一个。如果答案是肯定的，就要分开来提交。

[slide data-transition="vertical3d"]

不要改而不交拖延。修改的时间越长，你越容易忘了自己都做了什么，越容易产生bug，也越容易与其他人的相关工作不协调。要是你没有提交修改，其实一天的活就不算干完，除非你有更好的理由。

[slide data-transition="vertical3d"]

不能搞破坏。每一次你提交了代码，系统应该是好用的。也就是说，其他人此时更新代码后应该能够编译（可能的话），执行测试套件，并通过测试。将错误提交了是对与你协同的人（还是包括未来的你）极大的不尊重。这会让他们搞不清到底是因为自己的问题还是你提交的一些垃圾导致了系统不能运转。

[slide data-transition="vertical3d"]

要是你搞了破坏，要道歉，并立即修补。

[slide data-transition="vertical3d"]

## 版本号的意义
![version number](/img/revsion_contorl/version_number.jpg)
[slide data-transition="horizontal"]
## 版本号的意义
* 软件版本号由四部分组成
    * 第一个1为主版本号
    * 第二个1为子版本号
    * 第三个1为阶段版本号
    * 第四部分为日期版本号加希腊字母版本号，希腊字母版本号共有5 种，分别为：base、alpha、beta、RC、release。例如：1.1.1.051021_beta。
    

[slide data-transition="vertical3d"]

## 为什么要用分支？

[slide data-transition="horizontal"]

试想一个场景：

假设我们是某个互联网公司的开发人员。我们正在进行一个长期的大项目开发，开发的结束日期可能是一个月以后，但是这个时候，由于正在运行的网站出现一些严重的bug需要紧急的修复；同时，市场部提出要在网站中加一段广告代码，以便进行网站推广，要我们尽快加入到系统中，这次推广要持续一周。


[slide data-transition="vertical3d"]

但是我们所有的代码只有一个版本。

那这个时候我们应该怎么来解决现在的问题呢？

[slide data-transition="vertical3d"]

## 场景分析

[slide data-transition="horizontal"]

## 我们需要同时进行三件事情

1. 正在进行中的长期的项目开发工作	**重要不紧急** {:&.moveIn} 
2. 紧急的BUG修复					**既重要也紧急**
3. 广告代码（新需求）的添加			**紧急不重要**

[slide data-transition="vertical3d"]

## 问题（限制）

**所有的代码只有一个版本**

嗯，还有一个版本，就是在生产环境上正在运行的代码 {:&.moveIn} 

[slide]

## 你的选择？

* A：继续进行手中的项目，等完成了这个项目在进行BUG修复以及新功能的添加 {:&.rollIn}
* B：停下手中进行的项目，在现在的代码基础上完成bug修复和新功能的添加
* B+：停下手中进行的项目，在生产环境的代码基础上完成bug修复和新功能的添加，完成后，将这次变更的代码复制在正在进行的项目中。
* C：停下手中进行的项目，将生产环节的代码做一个tag，并且在这个tag之上衍生出一个版本分支，在这个版本分支上完成bug修复和新功能的添加。完成修复以及添加之后，在这个分支之上再做一个tag，同时合并进入正在进行的项目。
* D：停下手中进行的项目，将生产环节的代码做一个tag，并且在这个tag之上衍生出一个版本分支，在这个版本分支上完成bug修复，完成修复后再做一个tag，并且在这个tag之上衍生出一个新的版本分支来添加公共代码，同时将修复后的tag版本合并进入正在进行的项目。

[slide]

## 为什么要用分支？期望你们的回答是：

![version number](/img/revsion_contorl/i_know.png)

[slide data-transition="horizontal"]

## 分支应用场景总结

[slide]

## 什么情况下可以考虑不需要分支

1. 需求很稳定，不需要处理紧急情况
2. 你确认你写的代码不会有任何的问题
3. 开发的周期可以很长，对项目时间没有要求

[slide]

## 实际情况

1. 你拿到的需求经常变化
2. 你不敢保证写的代码不会有任何的问题
3. 开发周期一般都很短，deadline很恐怖，需求方恨不得今天提出需求，明天就完成

[slide]

## 关键的是，我们要做很靠谱的工程师！

[slide data-transition="horizontal"]

## 常用的分支模式

* 不稳定主干策略
* 稳定主干策略
* 敏捷发布策略

[slide]
## 不稳定主干策略

![unstable main branchs](/img/revsion_contorl/unstable_main_branchs.png)
* 此种分支策略使用主干作为新功能开发主线，分支用作发布。
* 此种分支管理策略被广泛的应用于开源项目。
	* 比如freebsd的发布就是一个典型的例子。freebsd的主干永远是current，也就是包括所有最新特性的不稳定版本。然后随着新特性的逐步稳定，达到一个发布的里程碑以后，从主干分出来一个stable分支。
	* freebsd是每个大版本一个分支。也就是说4.x，5.x，6,x各一个分支。每个发布分支上只有bug修改和现有功能的完善，而不会再增加新特性。新特性会继续在主干上开发。当稳定分支上发生的修改积累到一定程度以后，就会有一次发布。发布的时候会在稳定分支上再分出来一个 release分支。
[slide]
## 不稳定主干策略


* 此种分支管理策略比较适合诸如传统软件产品的开发模式，例如微软Windows开发，对于互联网开发不是很适合。已经在主干上集成的新功能，如果达不到里程碑的要求，稳定分支就不能创建，很有可能影响下一个发布的计划。
* 还有一个问题就是bug修改必须在各个分支之间合并。 

[slide]
## 稳定主干策略

![稳定主干策略](/img/revsion_contorl/stable_main.png)

* 此种分支策略使用主干作为稳定版的发布。

* 主干上永远是稳定版本，可以随时发布。bug的修改和新功能的增加，全部在分支上进行。而且每个bug和新功能都有不同的开发分支，完全分离。而对主干上的每一次发布都做一个标签而不是分支。分支上的开发和测试完毕以后才合并到主干。

[slide]

## 稳定主干策略

* 这种发布方法的好处是每次发布的内容调整起来比较容易。
	* 如果某个新功能或者bug在下一次发布之前无法完成，就不可能合并到主干，也就不会影响其他变更的发布。另外，每个分支的生命期比较短，唯一长期存在的就是主干，这样每次合并的风险很小。每次发布之前，只要比较主干上的最新版本和上一次发布的版本就能够知道这次发布的文件范围了。
* 此种分支策略的缺点之一是如果某个开发分支因为功能比较复杂，或者应发布计划的要求而长期没有合并到主干上，很可能在最后合并的时候出现冲突。另外由于对于每一分支都要进行测试才能够合并到主干中，测试工作量较大。 

[slide]
## 敏捷发布策略
![敏捷发布策略](/img/revsion_contorl/stable_main.png)

* 此种模式在采用敏捷开发模式（例如Scrum）的项目中广泛采用。

* 这些项目有固定的迭代周期（例如Scrum中每个Sprint的两周时间），新的功能开发都在Task branch(Feature branch)上进行，在接近迭代周期的发布阶段时候，新建Release branch来完成本迭代周期的发布，各Task branch(Feature branch)的功能merge到Release Branch中。在完成发布后，Release branch的功能merge到Trunk和尚在进行的Task branch中。

[slide]

* 采用敏捷发布策略要求主干的版本：
	* 任何时候都可以发布 ：在任何时候，产品所有者都可以基于主干的最新版本，发布新版本的产品
	* 希望尽早发布

* 此种模式较适合敏捷开发软件的要求，但对程序员及SCM要求较高。
* 关于敏捷发布策略可以参考：[多个敏捷团队之间的版本控制](http://www.infoq.com/cn/articles/agile-version-control)

[slide data-transition="horizontal"]
 ## Q & A