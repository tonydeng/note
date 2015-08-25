title: 版本控制和常用的分支模型
speaker: Tony Deng
url: https://gitlab.duoquyuedu.com/dengtao/note/master/ppts/md/revison_contorl_branch_pattern
transition: cover-diamond
files: /js/demo.js,/css/demo.css

[slide data-transition="vertical3d" style="background-image:url('/img/high-performance-server/cover.jpg')"]

# 版本控制和常用分支模型

<small>Tony Deng</small>

https://twitter.com/wolfdeng

https://delicious.com/wolf.deng

https://friendfeed/tonydeng

[slide data-transition="vertical3d"]

## 什么是版本控制

版本控制是一种在开发的过程中对**软件开发历史系统的跟踪的方法**

http://zh.wiipedia.org/wiki/版本控制

[slide data-transition="vertical3d"]

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

[slide data-transition="vertical3d"]
## 如何做好版本控制

* 选用一个优秀的版本控制系统，比如```Git```
    * 高效
    * 开源
    * 容易配置
    * 容易整合
    * 分支太爽了
    * 有多种工作流可以便于团队合作

[slide data-transition="vertical3d"]
## 什么时候开始版本化


[slide data-transition="vertical3d"]
## 一开始就要版本化

* 在项目中有些东西要保存在比草稿更加正式的地方，那么绝对要将其版本化
* 一旦我们需要在记录一些东西的时候，我们就必须将它放入到版本库中，让相关的人都能够通过版本库看到这个的演进历程
* 只要人类的智慧就要版本化。代码、测试用例、编译脚本、文档、任务列表、解释说明、演讲稿、想法、需求等，只要是经过人的大脑创造出来的一切，都应该记录在版本控制系统中。除非你有更好的理由将它们放在别处。

[slide data-transition="vertical3d"]

## 注意

计算机生成的文件就不必放入版本控制中了。如果放入的画，只能导致不同环境下项目出现不一致的情况。


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
[slide data-transition="vertical3d"]
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

[slide data-transition="vertical3d"]

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
[slide data-transition="vertical3d"]
## 版本号的意义
* 软件版本号由四部分组成
    * 第一个1为主版本号
    * 第二个1为子版本号
    * 第三个1为阶段版本号
    * 第四部分为日期版本号加希腊字母版本号，希腊字母版本号共有5 种，分别为：base、alpha、beta、RC、release。例如：1.1.1.051021_beta。
    

