# 使用pandoc、revealjs将Markdown转成HTML5的Slide

# 安装pandoc

```
brew install pandoc
```

#  安装reveal.js
```
git clone git@github.com:hakimel/reveal.js.git
```

# 将reveal.js相关资源同步到静态资源服务器

```
scp -r reveal.js/{js,css,lib,plugin} root@st.dq.in:/dq/resource/st/reveal.js
```

# 将reveal.js中引入的google字体转成360网站卫士的CDN

```
find reveal.js -name '*.css' sed -i 's/https:\/\/fonts.googleapis.com/http:\/\/fonts.useso.com/g' {} \;
find reveal.js -name '*.scss' sed -i 's/https:\/\/fonts.googleapis.com/http:\/\/fonts.useso.com/g' {} \;
```

# 编写markdown

```
% 年终总结
% Tony Deng
% 2014-12-24

# 工作回顾

1. 工作1
2. 工作2
3. 工作3

# 成绩与不足

* blablabla
* blablabla
* blablabla

# End

Thanks
```

# 使用pandoc生成html5 slide，并使用静态服务器的reveal.js

```
pandoc -t revealjs -s test.md -o target/test.html -V theme=night
sed -i 's/reveal.js/http:\/\/st.dq.in\/reveal.js/g' target/test.html
```

# 除了默认的外观主题以外，reveal.js还提供了多个主题可供选择，


>     default：（默认）深灰色背景，白色文字
>     beige：米色背景，深色文字
>     sky：天蓝色背景，白色细文字
>     night：黑色背景，白色粗文字
>     serif：浅色背景，灰色衬线文字
>     simple：白色背景，黑色文字
>     solarized：奶油色背景，深青色文字
