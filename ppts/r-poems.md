title: 通过机器学习来写诗
speaker: Tony Deng
url: https://github.com/tonydeng/note/master/ppts/r-poems.md
transition: cover-diamond
theme: light

[slide data-transition="vertical3d"]

# 通过机器学习来写诗

<small>Tony Deng</small>

Github @tonydeng

Twitter @wolfdeng

https://tonydeng.github.io

[slide data-transition="kontext"]

# 机器人作诗的可能性

[slide data-transition="kontext"]

![robot poems](https://pic2.zhimg.com/v2-30d3349e93dd0f86e273dffdb7a6c4c5_b.png)

[slide data-transition="kontext"]

![google search result](/img/r-poems/google-search-result.png)

[slide data-transition="kontext"]
# 理论支持

[slide data-transition="kontext"]

## 著名的[无限猴子定理](https://zh.wikipedia.org/zh-hans/無限猴子定理)


哪怕是让一只猴子在打字机上随机地按键，只要按键的时间足够长，那么几乎必然能够打出任何特定的文字，甚至是莎士比亚的全套著作。

![Monkey typing](https://upload.wikimedia.org/wikipedia/commons/f/f1/Monkey-typing.jpg)
[slide data-transition="kontext"]
## [机器学习](https://zh.wikipedia.org/wiki/机器学习)的各种[算法](https://tonydeng.github.io/2017/03/03/common-algorithms-for-machine-learning/)和相关工具的发展


```
有监督学习（分类，回归）
↕
半监督学习（分类，回归）
↕
半监督聚类（有标签数据的标签不是确定的，类似于：肯定不是xxx，很可能是yyy）
↕
无监督学习（聚类）
```

[slide data-transition="kontext"]

# 使用R来写诗

[slide data-transition="kontext"]

![R logo](https://static1.squarespace.com/static/538cea80e4b00f1fad490c1b/t/56362947e4b06c8363ef3f37/1446390088461/?format=1500w)

R语言，一种自由软件编程语言与操作环境，主要用于统计分析、绘图、数据挖掘。

[slide data-transition="kontext"]
## 基本步骤
[slide data-transition="kontext"]
### 在语料库[corpus](https://github.com/rime-aca/corpus)中选择[一个语料库](https://raw.githubusercontent.com/rime-aca/corpus/master/宋詞三百首.txt)

```bash
wget 'https://raw.githubusercontent.com/rime-aca/corpus/master/宋詞三百首.txt' -O training.txt
```

[slide data-transition="kontext"]
### 加载文件

```R
fileName <- "training.txt"

SC <- readChar(fileName, file.info(fileName)$size)
```

[slide data-transition="kontext"]
### 安装并使用[jiebaR](https://www.r-project.org/nosvn/pandoc/jiebaR.html)

```R
install.packages('jiebaR')

library(jiebaR)
```

[slide data-transition="kontext"]

### 分词并进行[TF-IDF](https://zh.wikipedia.org/wiki/TF-IDF)（词频分析）

```R
cc = worker()

analysis <- as.data.frame(table(cc[SC]))

# 重新排序
analysis <- analysis[order(-analysis$Freq),]

# 简单改变一下文件的命名、格式
names(analysis) <- c("word","freq")
analysis$word <- as.character(analysis$word)
```

[slide data-transition="kontext"]

### 分词和频率结果

![analysis](/img/r-poems/analysis.png)

[slide data-transition="kontext"]
### 可视化效果

![一个字](/img/r-poems/wordcloud-1.png)
[slide data-transition="kontext"]
![两个字](/img/r-poems/wordcloud-2.png)
[slide data-transition="kontext"]
![三个字](/img/r-poems/wordcloud-3.png)

[slide data-transition="kontext"]
### 定义一个词牌

李白的《清平乐·画堂晨起》作为范例

> 画堂晨起，来报雪花坠。高卷帘栊看佳瑞，皓色远迷庭砌。盛气光引炉烟，素草寒生玉佩。应是天仙狂醉，乱把白云揉碎。

[slide data-transition="kontext"]

### 对词牌进行分词后，再分析一下各部分的词性

```R
tagger <- worker("tag")
cipai_2 <- tagger <= cipai
```

[slide data-transition="kontext"]

### 查看词性分析结果

```
> cipai_2
     n      x      x      n      v      a      n      g      v      x      x      a      v      x      n
"画堂" "晨起" "来报" "雪花"   "坠"   "高" "卷帘"   "栊"   "看" "佳瑞" "皓色"   "远"   "迷" "庭砌" "盛气"
     x      x      x      x     nr      x      n      x      d      p     nr      v
"光引" "炉烟" "素草" "寒生" "玉佩" "应是" "天仙" "狂醉"   "乱"   "把" "白云" "揉碎"
```

[slide data-transition="kontext"]

### 分辨词语的词性，参见[北大计算所词性标注集简表](http://www.cnblogs.com/finallyliuyu/p/3925186.html)

1. n是名词
1. v是动词
1. a是形容词
1. nr 人名 名词代码n和“人(ren)”的声母并在一起
1. p 介词 取英语介词prepositional的第1个字母
1. q 量词 取英语quantity的第1个字母
1. x 非语素字 非语素字只是一个符号，字母x通常用于代表未知数、符号

[slide data-transition="kontext"]

### 在词频库中，选取了至少出现过两次的一字或两字词语，作为诗词创作的素材库

```R
example <- subset(analysis, freq >1 & nchar(word) <3 & freq < 300)
# 提取词性文件
cixing <- attributes(cipai_2)$names

# 将素材库进行词性分类
example_2 <- tagger <= example$word
```

[slide data-transition="kontext"]
### 定义诗词算法

从范本词牌的第一个词开始，随机在素材库中选取词性相同，字数相等的单词，填入提前设置好的空白字符串中。

```R
write_perms <- function(m){
  set.seed(m)
  empty <- ""
  for (i in 1:length(cipai_2)){
    temp_file <- example_2[attributes(example_2)$name == cixing[i]]
    temp_file <- temp_file[nchar(temp_file) == nchar(cipai_2[i])]
    empty <- paste0(empty, sample(temp_file,1))
  }

  result <- paste0(substr(empty, 1,4), ",", substr(empty,5,9),"。",
                   substr(empty, 10,16), ",", substr(empty, 17,22),"。",
                   substr(empty, 23,28), ",", substr(empty, 29,34),"。",
                   substr(empty, 35,40), ",", substr(empty, 41,46),"。")

}
```

[slide data-transition="kontext"]

### 开始写诗

```R
lapply(1:10,write_perms)
```

[slide data-transition="kontext"]

### 看看效果


> "紅藥蟲網,可堪絃歌回。高煙雨琮兼漸老,清愁久破春山。陸游寒煙缺月,佇久初靜翩翩。應是無力難倩,欲把秋風歸來。"
[slide data-transition="kontext"]

> "流年清露,可堪春意要。窮陽臺旆復驚飆,驚秋慢游柳下。風光戲鼓爭知,阮郎風露鞦韆。凝笑單衣無跡,卻對碧雲不堪。"
[slide data-transition="kontext"]
> "春意晚涼,春山小園賦。明天際紺凍亂紅,呼燈豔搖舊處。思婦紋平不眠,清尊煙光陳跡。傷春闌干杜若,不把綺羅飛來。"
[slide data-transition="kontext"]
> "暗想晏殊,猶唱酒杯調。重金井笮映倦客,疏煙滿聽怨極。紅樓更苦帳飲,老來雲淡蓬壺。情傷驟雨候館,漸因秋千執手。"
[slide data-transition="kontext"]
> "笙歌千樹,葉葉樓頭斷。黑簫聲燼遊不眠,修竹細隨舊香。歸路千縷春衫,行盡驚秋秋水。雪滿金風輕寒,曾向寶馬生怕。"
[slide data-transition="kontext"]
> "殘酒游絲,斜日殘花側。酥夜色燼梳蔣捷,夢短慳能袁去。綠樹香暖花院,淒楚還被凌雲。怨慢人心朝天,便比杜鵑獨立。"
[slide data-transition="kontext"]
> "征塵此身,殘醉思量墜。脆瑤臺囀露更聞,淚滿慢駐香徑。酒旗夢魂舊香,晏殊珠箔杜鵑。梅邊脈脈紫萸,遽憑燕子浮生。"
[slide data-transition="kontext"]
> "淚珠清愁,亭皋飛雨偷。巧亂鴉笮爭那回,更苦近蕩經年。飛花已失姜夔,斜日尋處丁寧。如水風味六州,曾因朱門年少。"
[slide data-transition="kontext"]
> "行雲朱戶,清愁細雨定。孤雕鞍髻謾佇久,朝天冷沒枝上。情懷何世當樓,爭知曾題碧雲。宴清春風暗雨,不同夜闌開時。"
[slide data-transition="kontext"]
> "啼鶯中酒,多麗紅情想。慢畫堂艤關芳酒,難倩淡如李甲。枝頭多麗春去,斜日翠綃秋千。相倚層樓隋堤,共被柳絲睡起。"


[slide data-transition="kontext"]
### PS: 关于简体和繁体转换
可以使用[opencc](https://github.com/BYVoid/OpenCC) 简繁体转换，转换测试地址：http://opencc.byvoid.com 。R也有相应的包[ropencc](https://github.com/qinwf/ropencc),相关使用可以查看这篇文章：[ROPENCC - OPENCC 繁简转换 R 语言接口](http://cn.qinwenfeng.com/ropencc/)

[slide data-transition="kontext"]

# Q & A
