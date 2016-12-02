title: 基于命令行的Git Plugin开发回顾
speaker: Tony Deng
url: https://github.com/tonydeng/note/master/ppts/md/a-review-of-plugin-git-development-based-on-the-command-line.md
transition: cover-diamond
theme: colors

[slide style="background-image:url('https://www.atlassian.com/git/images/atlassian-getting-git-right.jpg')"]

# 基于命令行的Git Plugin开发回顾

##  -- git-toolkit

<small>Tony Deng</small>

https://tonydeng.github.io

https://twitter.com/wolfdeng


[slide data-transition="earthquake"]

# 开发git toolkit的初衷

人类懒惰的本性和不满足的本性是趋势科技发展的源泉......

[阮一峰《Commit message 和 Change log 编写指南》](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)

[slide data-transition="cards"]

# Commit message

[slide data-transition="stick"]

![commit no message](/img/git-toolkit/commit-no-message.png)

[slide data-transition="move"]

![commit_message](/img/revsion_contorl/commit_message_2.jpg)

[slide data-transition="newspaper"]

![commit message](/img/git-toolkit/commit-message.png)

[slide data-transition="slide"]

# Changelog

[slide data-transition="slide2"]

可以试试这些命令

```
git log git-toolkit-1.0 --pretty=format:%s
```

```
git log git-toolkit-1.0 --pretty=format:%s
```

```
git log git-toolkit-1.0...git-toolkit-1.0.1  --pretty=format:%s
```

```
git log git-toolkit-1.0 --pretty=format:%s --grep feat
```

```
git log git-toolkit-1.0 --pretty=format:'<li> <a href="http://github.com/tonydeng/git-toolkit/commit/%H">view commit &bull;</a> %s</li> ' --reverse
```
[slide data-transition="slide3"]

![changelog](/img/git-toolkit/changelog.png)

[slide data-transition="horizontal3d"]

# Git Toolkit介绍

https://tonydeng.github.io/git-toolkit/

[slide data-transition="horizontal"]

# 开发一个Git插件是不是很难？

[slide data-transition="vertical3d"]

我们来看看Git Flow是怎么来实现的

```bash
➜  ~ git flow
usage: git flow <subcommand>

Available subcommands are:
   init      Initialize a new git repo with support for the branching model.
   feature   Manage your feature branches.
   release   Manage your release branches.
   hotfix    Manage your hotfix branches.
   support   Manage your support branches.
   version   Shows version information.

Try 'git flow <subcommand> help' for details.
```

[slide data-transition="zoomin"]

git flow命令位置

```bash
➜  ~ ll /usr/local/Cellar/git-flow/0.4.1/bin
total 8
-r-xr-xr-x  1 tonydeng  staff    78B  7 18 19:29 git-flow
```

git flow命令内容

```bash
➜  ~ less /usr/local/Cellar/git-flow/0.4.1/bin/git-flow
#!/bin/bash
exec "/usr/local/Cellar/git-flow/0.4.1/libexec/bin/git-flow" "$@"
```

git flow不同命令实现

```bash
➜  ~ ll /usr/local/Cellar/git-flow/0.4.1/libexec/bin/
total 224
-rwxr-xr-x  1 tonydeng  wheel   3.5K  9 21  2015 git-flow
-rw-r--r--  1 tonydeng  wheel    14K  9 21  2015 git-flow-feature
-rw-r--r--  1 tonydeng  wheel   9.2K  9 21  2015 git-flow-hotfix
-rw-r--r--  1 tonydeng  wheel    10K  9 21  2015 git-flow-init
-rw-r--r--  1 tonydeng  wheel    10K  9 21  2015 git-flow-release
-rw-r--r--  1 tonydeng  wheel   5.0K  9 21  2015 git-flow-support
-rw-r--r--  1 tonydeng  wheel   2.0K  9 21  2015 git-flow-version
-rw-r--r--  1 tonydeng  wheel   8.5K  9 21  2015 gitflow-common
-rw-r--r--  1 tonydeng  wheel    30K  9 21  2015 gitflow-shFlags
```
[slide data-transition="move"]
# 看到这里，你领悟到什么了没有？

[slide data-transition="newspaper"]

### 自己开发一个基于命令行的Git插件还是一件比较容易的事情

* 可以用任何在终端运行的脚本来开发
    (Shell、Python、Golang、NodeJS、Java、Clojure.......)

* 遵循Git本身命令的命名规范


[slide data-transition="slide"]

### 最终选择Bash Shell来开发git-toolkit的原因

* 跨平台支持
* 最小侵入

[slide data-transition="zoomout"]

# 开发Git Toolkit要点

[slide data-transition="pulse"]

1. Git Hook
1. Message Template
1. Git命令命名规则
1. 掌握一门脚本语言（shell）
[slide data-transition="kontext"]

# Git Toolkit介绍

[slide data-transition="vkontext"]

## 安装

#### 1. 使用curl

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tonydeng/git-toolkit/master/installer.sh)"
```

#### 2. 使用wget

```bash
sh -c "$(wget https://raw.githubusercontent.com/tonydeng/git-toolkit/master/installer.sh -O -)"
```


[slide data-transition="circle"]
## 自定义命令 -- git toolkit

提供本工具集的管理命令。

**查看帮助**

```bash
git toolkit help
```

**卸载本工具集**

```bash
git toolkit uninstall
```

**更新本工具集**

```bash
git toolkit update
```

[slide data-transition="earthquake"]
## 自定义命令 -- git ci

提供交互式`git commit`的命令，用于定制统一`commit message`。

> 用于替换[Commitizen](https://github.com/commitizen/cz-cli)

```
git ci
选择您正在提交的类型:
        1. backlog: 开始一个新的backlog
        2. feat: 新功能（feature）
        3. fix: 修补bug
        4. docs: 文档（documentation）
        5. style: 格式（不影响代码运行的变动）
        6. refactor: 重构（即不是新增功能，也不是修改bug的代码变动）
        7. test: 增加测试
        8. chore: 构建过程或辅助工具的变动
        0. quit: 退出
```    
[slide data-transition="newspaper"]
```
➜  note git:(master) ✗ git ci
选择您正在提交的类型:
        1. backlog: 开始一个新的backlog
        2. feat: 新功能（feature）
        3. fix: 修补bug
        4. docs: 文档（documentation）
        5. style: 格式（不影响代码运行的变动）
        6. refactor: 重构（即不是新增功能，也不是修改bug的代码变动）
        7. test: 增加测试
        8. chore: 构建过程或辅助工具的变动
        0. quit: 退出

请选择相关数字选项 [0-8]> 2
本次提交的范围，建议填写版本号 ($version):
1.0
请添加简短的，必要的对本次提交的描述:
添加《基于命令行的Git Plugin开发回顾》PPT
添加一个完整提交的描述:
对Git Toolkit整个项目进行一次回顾
列出本次提交解决的、可以关闭的所有相关问题，建议使用关键字 refs 、 close:
refs #2
git commit -F .gitCOMMIT-MSG.tmp -a
[master 57ae28e] feat(1.0): 添加《基于命令行的Git Plugin开发回顾》PPT
 5 files changed, 281 insertions(+)
 create mode 100644 ppts/a-review-of-plugin-git-development-based-on-the-command-line.md
 create mode 100644 ppts/img/git-toolkit/changelog.png
 create mode 100644 ppts/img/git-toolkit/commit-message.png
 create mode 100644 ppts/img/git-toolkit/commit-no-message.png
 create mode 100644 ppts/img/git-toolkit/tree.png
```
[slide data-transition="slide"]

## Hook脚本 -- commit-msg

用于验证每次提交的`commit message`是否符合规范，如果不符合规范，则提交不成功

[Git Hooks详细文档](https://github.com/tonydeng/git-toolkit/blob/master/docs/git-hooks.md)

[slide data-transition="cards"]

## 配置
配置统一的`commit message`模板
```
git config --global commit.template
```

配置制定的Hook脚本的目录，使用本项目的git hook脚本
```
git config --global core.hooksPath
```

[slide data-transition="glue"]

## 目录结构
```bash
➜  git-toolkit git:(develop) tree
.
├── README.md
├── command
│   └── git-ci
├── config
│   └── git-message-template
├── docs
│   └── git-hooks.md
├── hooks
│   └── commit-msg
└── installer.sh

4 directories, 6 files
```

[slide data-transition="stick"]
# 上代码

[slide data-transition="move"]

# Shell开发神器 shellcheck

[slide data-transition="newspaper"]

# Q & A
