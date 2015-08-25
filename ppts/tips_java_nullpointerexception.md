title: 避免Java空指针异常的小技巧
speaker: Tony Deng
url: https://gitlab.duoquyuedu.com/dengtao/note/master/ppts/md/
transition: cover-diamond
files: /js/demo.js,/css/demo.css

[slide data-transition="vertical3d" style="background-image:url('/img/high-performance-server/cover.jpg')"]

# 避免Java空指针异常的小技巧

<small>Tony Deng</small>

https://twitter.com/wolfdeng

https://delicious.com/wolf.deng

https://friendfeed/tonydeng

[slide data-transition="vertical3d"]

NullPointerException是我们在生产环境中最常见的异常情况。

[slide data-transition="vertical3d"]

## 本以为

![mm](/img/tips_java_nullpointerexception/mm.jpg)

[slide data-transition="vertical3d"]

## 没想到

![mm](/img/tips_java_nullpointerexception/bajie.jpg)

[slide data-transition="vertical3d"]
俗话说**“预防胜于治疗”**，对于这么令人讨厌的空指针异常，我们应该怎么去预防呢？

我们可以采用一些防御性的编码技巧来尽量避免空指针的产生。

[slide data-transition="vertical3d"]

## 我们来看看一些容易产生空指针的代码及相应的防御性编码技巧

[slide data-transition="vertical3d"]
## 产生空指针异常的equals使用方式

```java
Object unknowObject = null;

if(unknowObject("test")){
    System.err.println("This may result in NullPoniter if unknowObject is null");
}
```
[slide data-transition="vertical3d"]

## 防御编码技巧

基于equals()方法的对称原则

```java
Object unknowObject = null;

if("test".equals(unknowObject)){
    System.err.println("This may result in NullPoniter if unknowObject is null");
}
```

[slide data-transition="vertical3d"]

## 产生空指针的toString使用方式

```java
Integer i = null;

i.toString(); 
```

[slide data-transition="vertical3d"]

## 防御编码技巧
```java
Integer i = null;

String.valueOf(i);
```

[slide data-transition="vertical3d"]

当`valueOf`和`toString`返回相同的结果时，宁愿使用前者。

尤其是在那些包装类，像**Integer**、**Float**、**Double**和**BigDecimal**。

[slide data-transition="vertical3d"]

## 集合操作前要注意

```java
Map<String,String> map = null;
map.get("foo"); 
```

```java
Map<String,String> map = null;
for(String key:map.keySet()){
    log.info("key:'{}', value'{}'",key,map.get(key)); 
}
```

```java
List<String> list = null;

log.info("list index 0:'{}'",list.get(0));
```

```java
List<String> list = null;
for(String value:list){
    log.info("value:'{}'",value);
}
```

[slide data-transition="vertical3d"]

## 防御编码技巧

在做实际的数据操作之前，先使用使用`null`安全的方法和库(`commons-lang3`、`commons-collection4`)做一下验证。

[slide data-transition="vertical3d"]

## 验证字符串

```
String str = null;
if(StringUtils.isNotEmpty(str)){
    ...
}
if(StringUtils.isNotBlank(str)){
    ...
}
if(StringUtils.isNotNumeric(str)){
    ...
}
```

[slide data-transition="vertical3d"]

## 验证集合

```
Map<String,String> map = null;
if(MapUtils.isNotEmpty(map)){
    ...
}
List<String> list = null;
if(CollectionUtils.isNotEmpty(list)){
    ...
}
```

[slide data-transition="vertical3d"]

## 下面的代码有什么样的隐患？

```
public List<Order> getOrders(List<Integer> orderIds){
    return orderDao.getOrdersByIds(orderIds);
}

for(Order order : getOrders(orderIds)){
    ...
}
```
[slide data-transition="vertical3d"]

## 避免从方法中返回null，而是返回空的collection或者空数组

```
public List<Order> getOrders(List<Intger> orderIds){
    List<Order> orders = orderDao.getOrdersByIds(orderIds);
    if(CollectionUtils.isEmpty(orders)){
        orders = Collections.EMPTY_LIST;
    } 
    return orders;
}
```
可以使用Collections.EMPTY_SET和Collections.EMPTY_MAP来代替null

[slide data-transition="vertical3d"]

## 注意Java的Autoboxing特性

```
class Person {
        private Integer phone;
        private int age;
        private String name;

        public Person(String name) {
            this.name = name;
        }
        public Integer getPhone() {
            return phone;
        }
        public String getName() {
            return name;
        }
        public int getAge() {
            return age;
        }
    }
```

[slide data-transition="vertical3d"]
## 下面的代码会出现NullPointerException吗？
```
Person tony = new Person("tony");
int phone = tony.getPhone();
int age = tony.getAge();
```
[slide data-transition="vertical3d"]

## 使用基本类型或者在getXXX时赋予初始化值
```
public Integer getPhone(){
    if(phone == null)
        phone = 0;
    return phone;
}
```
[slide data-transition="vertical3d"]
## 对象的构造方法中赋予初始值
```
class Person{
    public Person(String name){
        this.name = name;
        this.phome = 0;
    }
}
```

[slide data-transition="vertical3d"]

## 参考

[Effective Java](http://www.amazon.com/gp/product/B000WJOUPA/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B000WJOUPA&linkCode=as2&tag=job0ae-20)

[java.lang.NullPointerException - Common cause of NullPointerException in Java Example
](http://javarevisited.blogspot.com/2012/06/common-cause-of-javalangnullpointerexce.html)

[Overriding equals() and hashCode() method in Java and Hibernate](http://javarevisited.blogspot.com/2011/02/how-to-write-equals-method-in-java.html)