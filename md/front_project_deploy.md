# 前端项目上线流程

## 所使用的技术及工具

* grunt.js //前端工程管理，管理前端资源文件合并、打包、压缩等工作，另外还提供不同生命周期的前端工程资源产出
* shell script //使用shell脚本来简化不同生命周期的管理工作，达到一键式操作
* undercore.js //提供在命令行下对json的读取和操作功能，在前端项目版本升级时起到重要的作用
* pssh //提供同时对多台服务器的便利操作
* scp  //文件远程复制
* rsync //通过高效的算法来实现本机及不同机器之间的文件同步

## 上线流程

进入项目目录，执行项目本身的deploy脚本

```
cd ${project}
./deploy.sh production
```

登陆跳板服务器，执行发布脚本

```
ssh -A -l release 123.56.85.106
cd shells/st
./st.sh ${project}
```
