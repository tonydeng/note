# 项目介绍

本项目中是用来做PPT分享的Repo，本项目中所有的PPT都是使用用[nodePPT](https://github.com/ksky521/nodePPT)来创作的。

## 为什么选择nodePPT

* 基于GFM的markdown语法编写
* 支持[html混排](https://github.com/ksky521/nodePPT#mixed-code)，再复杂的demo也可以做！
* [导出网页](https://github.com/ksky521/nodePPT#export-html)或者[pdf](https://github.com/ksky521/nodePPT#export-pdf)更容易分享
* 支持[20种转场动画](https://github.com/ksky521/nodePPT#transition)，可以设置单页动画
* 支持单页背景图片
* 多种模式：overview模式，[双屏模式](https://github.com/ksky521/nodePPT#postmessage)，[socket远程控制](https://github.com/ksky521/nodePPT#postmessage)，摇一摇换页，使用ipad/iphone控制翻页更酷哦~
* 可以使用画板，双屏同步画板内容！可以使用note做备注
* 支持语法高亮，自由选择[highlight样式](https://highlightjs.org/)
* 可以单页ppt内部动画，单步动画
* 支持[进入/退出回调](https://github.com/ksky521/nodePPT#callback)，做在线demo很方便
* 支持事件update函数，查看demo

## nodePPT如何使用

### 安装

```
npm install -g nodeppt
```

### 使用

#### 启动

```
# 获取帮助
nodeppt start -h
# 绑定端口
nodeppt start -h -p <port>
```

```
# 绑定某个端口启动
nodeppt start -p 8090 -d path/for/ppts
# 绑定host，默认绑定host为0.0.0.0
nodeppt start -p 8080 -d path/for/ppts -h 127.0.0.1
```

#### 启用socket控制

##### 方法一： 使用```start```命令行

```
# 使用socket通信(按Q键显示/关闭二维码，手机扫描，即可控制)
# 使用socket须知：1、注意手机和PC可以互相访问， 2、防火墙， 3、ip
nodeppt start -c socket
```
在页面中案件【Q】显示控制URL的二维码和控制连接（需要隐身窗口打开），手机上可以使用左右touch滑动和摇一摇切换下一页。

##### 方法二： 使用URL参数

```
http://127.0.0.1:8080/md/demo.md?controller=socket
```
在页面中案件【Q】显示控制URL的二维码和控制连接（需要隐身窗口打开），手机上可以使用左右touch滑动和摇一摇切换下一页。

#### 启用postMessage控制

默认使用postMessage多窗口控制，打开方法：

```
http://127.0.0.1:8080/md/demo.md?_multiscreen=1
```

#### 事件绑定

使用函数 ```Slide.on``` ，目前支持```update```函数，即转场后的回调。

示例代码如下：

```
Slide.on('update',function(i,cls){
    //接受两个参数: index和方向pageup/pagedown
    Puff.add('#FFC524' /*colers[i & 6]*/, ctx, 20, 700, width/2, height/2, width/1.8, 400);
    clearInterval(timer);
    //第十三个有动效
    if(i === 13 || i === 14){
        timer = setInterval(function(){
            Puff.draw(1);
        }, 1E3 / FPS);
    }
})
```

demo中的[第13章](http://qdemo.sinaapp.com/#13)使用了回调做了魔幻翻页效果


### 导出

导出PPT有三种方法，一种最简单的ctrl+P，一种是pdf版本，一种是html版本

#### PDF版本

需要安装[phantomJS](http://phantomjs.org/)

```
# 安装phantomjs，如果安装了，请忽略
npm install -g phantomjs
# 启动nodeppt server
nodeppt start
# 导出文件
nodeppt pdf http://127.0.0.1:8080/md/demo.md -o a.pdf
```

#### html版本

```
# 获取generate帮助
nodeppt generate -h
# 使用generate明亮
nodeptt generate <filepath>
# 导出全部，包括nodeppt的js、img和css文件夹
nodeppt generate ./md/demo.md -a
# 指定导出的文件夹
nodeppt generate ./md/demo.md -a -o <output/path>
```

导出目录下所有的ppt，并生产ppt list首页

```
nodeppt <source/path> -o <output/path> -a
```

### markdown语法
nodeppt是支持**markdown**语法的，但是为了制作更加完美的ppt，扩展了下面的语法

#### 配置

基本配置如下：

```
title:演讲的题目
speaker:演讲者名字
url:可以设置连接
transition:转场效果，例如: (zoomin/cards/slide)
files:引入js和css的地址，如果有的话，自动放在页面底部
```


### 目录关系

可以在md同级目录下创建img、js、css等文件夹，然后再markdown里面引用，nodeppt默认会查找md同级文件下的静态资源，没有再找默认的```assets```文件夹的静态内容

### 支持的转场动画包括

* kontext
* vkontext
* circle
* cover-circle
* cover-diamond
* earthquake
* cards
* glue
* stick
* move
* newspaper
* slide
* slide2
* slide3
* horizontal3d
* horizontal
* vertical3d
* zoomin
* zoomout
* pulse

如果设置单页动画，请参考下面的[单页动画设置](https://github.com/ksky521/nodePPT#transition-page)部分~

### 分页

通过```[slide]```作为每页ppt的间隔，如果需要添加单页背景，使用下面的语法：

```
[slide style="background-image:url('/img/bg1.png')"]
# 这是个有背景的家伙
## 我是副标题
```

### 单页ppt上下布局

```
[slide]
## 主页面样式
### ----是上下分界线
----
nodeppt是基于nodejs写的支持 **Markdown!** 语法的网页PPT

nodeppt：https://github.com/ksky521/nodePPT
```

### 代码格式化

语法跟**Github Flavored Markdown** 一样~


### 单页动画设置

在md文件，顶部 配置 可以设置全局转场动画，如果要设置单页的转场动画，可以通过下面的语法

```
[slide data-transition="vertical3d"]
## 这是一个vertical3d的动画
```

### 插入html代码

如果需要完全diy自己的ppt内容，可以直接使用 html标签，支持markdown和html混编。例如：

```
<div class="file-setting">
    <p>这是html</p>
</div>
<p id="css-demo">这是css样式</p>
<p>具体看下项目中 ppts/demo.md 代码</p>
<script>
    function testScriptTag(){

    }
    console.log(typeof testScriptTag);
</script>
<style>
#css-demo{
    color: red;
}
</style>
```

### 转场回调

前端的ppt，难免会在页面中演示一些demo，除了上面的插入html语法外，还提供了```incallback```和```outcallback```，分别用于：切入（切走）到当前ppt，执行的js函数名。例如：

```
[slide data-outcallback="outcallback" data-incallback="incallback"]
## 当进入此页，就执行incallback函数
## 当离开此页面，就执行outcallback函数
```