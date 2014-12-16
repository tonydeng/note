# 前端项目上线流程

## 所使用的技术及工具

* grunt.js
* pssh
* scp
* rsync

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

