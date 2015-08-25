title: Muse介绍
speaker: Tony Deng
url: https://gitlab.duoquyuedu.com/dengtao/note/master/ppts/md/high-performance_server_three_elements
transition: cover-diamond
files: /js/demo.js,/css/demo.css

[slide data-transition="vertical3d"]

# Muse介绍

<small>Tony Deng</small>

https://twitter.com/wolfdeng

https://delicious.com/wolf.deng

https://friendfeed/tonydeng

[slide data-transition="kontext"]

# 产品描述

现在的互联网产品和服务针对的目标用户大部分都是80后、90后的年轻人，但是其实我们的父辈们他们辛苦了一辈子，当他们慢慢退出这个社会的主体之后，其实他们对互联网服务也是有强烈地需求，我们也应该通过互联网服务能够让他们的生活有更多地乐趣。

那么，本产品是为了服务广大的大龄文艺男女中年，让他们在移动互联网时代也拥有属于自己的专属的服务和社交。

[slide data-transition="circle"]

我们的口号是：**“因为我们的产品，让被互联网忽略的大爷大妈们也享受更多地互联网服务”**

广告语是：**"大爷大妈们，走出来，跳起来，唠（闹）起来"**

[slide data-transition="stick"]

![大妈也疯狂](/img/muse/Terpsichore_2014A2_397.jpg)

[slide data-transition="vertical3d"]

# 产品代号

我将这个产品代号叫：**缪斯（Muse）**。

[slide data-transition="earthquake"]

## 为什么叫这个名字

首先是习惯，希望能够用希腊神话中的人物或事物来命名我们的产品。在多趣的[产品列表](https://redmine.duoquyuedu.com/projects)中，我们可以看到很多希腊神话的人物，比如[雅典娜（Athena）](https://redmine.duoquyuedu.com/projects/athena)、[潘多拉（Pandora）](https://redmine.duoquyuedu.com/projects/pandora)、[阿特拉斯（Atlas）](https://redmine.duoquyuedu.com/projects/atlas)。

[slide data-transition="earthquake"]

其实，我脑海中出现的第一个是[忒耳普西科瑞（Terpsichore）](http://zh.wikipedia.org/wiki/%E5%BF%92%E8%80%B3%E6%99%AE%E8%A5%BF%E7%A7%91%E7%91%9E)，她是希腊神话中得司职舞蹈的缪斯，九位缪斯之一。忒耳普西科瑞的古希腊语是（Τερψιχόρᾱ），来之希腊语词根的“爱好”（τέρπω）和舞蹈（χoρός），合起来就是“爱舞蹈的”。

不过，还是[缪斯](http://zh.wikipedia.org/wiki/%E7%BC%AA%E6%96%AF)这个称呼大家更加熟悉一些。所以还是采用了缪斯这个名字作为产品的代号。

而且，很多人认为缪斯是位人类带来昌盛和友爱，是通往好的生活的秘密。

[slide data-transition="cards"]

### 九位缪斯

| 缪斯 | 希臘文 | 拉丁文 | 司管藝術 |	 象征物 | 名字之意 |
| -------- | -------- | -------- | -------- | -------- | -------- | 
|卡利俄佩（卡利俄珀）| Καλλιόπη | Calliope |英雄史詩| 鐵筆與蠟板 | 聲音悅耳的 |
|克利俄	 |Κλειώ|	 Clio|	 歴史|	 書卷與桂冠	 |赞美的|
|歐忒耳佩（歐忒耳珀）|	Εὐτέρπη|Euterpe|抒情詩與音樂|長笛與花籃|令人快樂的|
|忒耳普西科瑞（忒耳西科瑞）|Τερψιχόρα|Terpsichore|合唱與舞蹈|七弦琴與常春藤|熱愛舞蹈的|
|厄剌托（埃拉托）| Ἐρατώ| Erato|爱情诗與獨唱|七弦琴或豎琴|可愛的|
|墨爾波墨涅	| Μελπομένη	| Melpomene	| 悲劇與哀歌	| 悲劇面具、短劍或棍棒|聲音甜美的|
|塔利亞	| Θάλεια| Thalia|喜劇與牧歌|喜劇面具、牧杖或铃鼓|繁榮昌盛的|
|波呂許謨尼亞（波林尼亞）| Πολύμνια	 |Polyhymnia|頌歌與修辭學、幾何學|無象徵物|通常神情憂鬱，頭戴面紗。	 有很多颂歌的|
|烏剌尼亞（烏拉尼亞）|Οὐρανία|Urania|天文學與占星學|天球儀與圓規|天空的|

[slide data-transition="cards"]

# 技术调研

[slide data-transition="newspaper"]

## 视频解决方案需求

![视频解决方案需求](/img/muse/video_resolvent.png)

[slide data-transition="newspaper"]

可以参考的现有视频云解决厂商

### [CC视频云](http://www.bokecc.com/)
### [乐视云视频](http://www.yshipin.net/index.asp)
### [视博云](http://cybercloud.com.cn/)

[slide data-transition="newspaper"]

## 视频源抓取方案

[slide data-transition="newspaper"]

### 中国太极拳网--舞蹈屋

可以通过原视频链接

> http://www.cntaijiquan.com/gcw/29084.html

获得视频下载链接

> http://php.cntaijiquan.com/downcq.php?u=29084


[slide data-transition="newspaper"]

通过测试，如此三次http请求，就可以获得最终的视频地址

```
➜  muse  curl -I http://php.cntaijiquan.com/downcq.php\?u\=29084
HTTP/1.1 302 Moved Temporarily
Connection: close
Date: Tue, 23 Dec 2014 09:07:03 GMT
Server: Microsoft-IIS/6.0
X-Powered-By: ASP.NET
X-Powered-By: PHP/5.2.17
Location: http://f3.r.56.com/f3.c192.56.com/flvdownload/14/7/sc_141922323231hd_super.flv.mp4?v=1&t=0VECK8OaQDSmoqFpC7f44Q&r=95076&e=1419412016&tt=1058&sz=145635225&vid=133235793
Content-type: text/html

➜  muse  curl -I http://f3.r.56.com/f3.c192.56.com/flvdownload/14/7/sc_141922323231hd_super.flv.mp4\?v\=1\&t\=0VECK8OaQDSmoqFpC7f44Q\&r\=95076\&e\=1419412016\&tt\=1058\&sz\=145635225\&vid\=133235793
HTTP/1.1 302 Moved Temporarily
Server: nginx
Date: Tue, 23 Dec 2014 09:07:07 GMT
Content-Type: text/html
Content-Length: 154
Connection: close
Location: http://218.61.21.28/fcs192.56.com/flvdownload/14/7/sc_141922323231hd_super.flv.mp4?t=w2_pbON8G6PDbPkVlS_tyA&r=95076&e=1419412016&v=1&s=1&tt=1058&sz=145635225&vid=133235793

➜  muse  curl -I http://218.61.21.28/fcs192.56.com/flvdownload/14/7/sc_141922323231hd_super.flv.mp4\?t\=w2_pbON8G6PDbPkVlS_tyA\&r\=95076\&e\=1419412016\&v\=1\&s\=1\&tt\=1058\&sz\=145635225\&vid\=133235793
HTTP/1.1 200 OK
Server: Tengine
Date: Tue, 23 Dec 2014 09:07:17 GMT
Content-Type: video/mp4
Content-Length: 145635225
Last-Modified: Mon, 22 Dec 2014 05:09:45 GMT
Connection: keep-alive
Expires: Thu, 31 Dec 2037 23:55:55 GMT
Cache-Control: max-age=315360000
Accept-Ranges: bytes
```

[slide data-transition="newspaper"]

### 草莓广场舞

[slide data-transition="newspaper"]

可以通过原视频链接

> http://www.gcw.cm/guangchangwu/59948.html

获得视频下载链接

> http://cntaijiquan.duapp.com/cmsj.php?u=59948

[slide data-transition="newspaper"]

通过测试，如此三次http请求，就可以获得最终的视频地址

```
➜  muse  curl -I http://cntaijiquan.duapp.com/cmsj.php\?u\=59948
HTTP/1.1 302 Found
Set-Cookie: BAEID=1824BDCACDA362F880ECA5B45E5D80AE:FG=1; path=/; version=1
Location: http://f2.r.56.com/f2.c181.56.com/flvdownload/28/27/sc_141931985583hd_clear.flv.mp4?v=1&t=5Uv5KGPADewIb1P8ErxPiA&r=66420&e=1419412126&tt=290&sz=20324471&vid=133291392
Content-type: text/html
Date: Tue, 23 Dec 2014 09:08:46 GMT
Server: BWS/1.0
Content-Length: 0

➜  muse  curl -I http://f2.r.56.com/f2.c181.56.com/flvdownload/28/27/sc_141931985583hd_clear.flv.mp4\?v\=1\&t\=5Uv5KGPADewIb1P8ErxPiA\&r\=66420\&e\=1419412126\&tt\=290\&sz\=20324471\&vid\=133291392
HTTP/1.1 302 Moved Temporarily
Server: nginx
Date: Tue, 23 Dec 2014 09:09:40 GMT
Content-Type: text/html
Content-Length: 154
Connection: close
Location: http://218.61.21.20/fcs181.56.com/flvdownload/28/27/sc_141931985583hd_clear.flv.mp4?t=yd_7ACAvwHDozWvsFruaBA&r=66420&e=1419412126&v=1&s=1&tt=290&sz=20324471&vid=133291392

➜  muse  curl -I  http://218.61.21.20/fcs181.56.com/flvdownload/28/27/sc_141931985583hd_clear.flv.mp4\?t\=yd_7ACAvwHDozWvsFruaBA\&r\=66420\&e\=1419412126\&v\=1\&s\=1\&tt\=290\&sz\=20324471\&vid\=133291392
HTTP/1.1 200 OK
Server: Tengine
Date: Tue, 23 Dec 2014 09:09:46 GMT
Content-Type: video/mp4
Content-Length: 20324471
Last-Modified: Tue, 23 Dec 2014 07:40:12 GMT
Connection: keep-alive
Expires: Thu, 31 Dec 2037 23:55:55 GMT
Cache-Control: max-age=315360000
Accept-Ranges: bytes
```

[slide data-transition="newspaper"]

### 糖豆

通过其移动端的网站来访问

如果要解决糖豆网全部视频源获取，需要解决**其他视频网站**（56、优酷、土豆等）的视频源解析

[slide data-transition="newspaper"]

## 思考

1. 不应只从广场舞入手，广场舞毕竟女的多，中老年男网民应该比女网民多
1. 可以从同城、同龄、同爱好等各个角度和方向来加强交流和画圈
2. 关注中老年健康，应该是重要版块（饮食、锻炼、养生等）
3. 希望能够涉及到中老年的生活中所关注的地方
3. 网页版必须做，好多人才会用电脑，而且电脑的字大！不应该只做手机app
4. 设计时一定要考虑到老年人眼神不好的因素