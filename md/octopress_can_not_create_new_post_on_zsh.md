# Octopress Can Not Create new Post on Zsh

在zsh中执行rake new_post[“Title”]时会报错，提示“no matches found”。

原因是zsh中若出现下列符合，则将识别为查找文件名的通配符，很不幸我们在octopress中创建一下新blog的命令就出现了“[”这个符号。

 > ‘*’, ‘(’, ‘|’, ‘<’, ‘[’, or ‘?’

报错信息如下：

```shell
@Wolf ➜  octopress git:(source) rake new_post["title"]
zsh: no matches found: new_post[title]
```
解决方法有两个：

1. 快速解决法，将rake之后都用双引号“”括起来：
```shell
@Wolf ➜  octopress git:(source) rake "new_post[title]"
```
2. 彻底解决法，在执行rake时，取消zsh的通配(GLOB)：
```shell
echo "alias rake='noglob rake'" >> ~/.zshrc
```