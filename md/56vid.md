# 56视频抓取方案

56为自己的android客户端提供了一个获取视频地址的接口，可以直接通过网站的视频ID拿到最终的视频地址。

### 灵感来源：

```
http://dev.56.com/wiki/doc-view-71.html
```
### 获取视频地址的API:

```
http://vxml.56.com/mobile/137221122/?src=3gapi
```

其中 ```137221122``` 这个是56的真实视频id，可以通过网站的视频ID ```MTM3MjIxMTIy``` BASE64 Decode出来。

### 基本流程如下：

#### 网站地址：

```
http://www.56.com/u51/v_MTM3MjA1MDY0.html
```

#### API Request
```
GET /mobile/137205064/?src=3gapi HTTP/1.1
User-Agent: gzip
Accept-Encoding: gzip
Host: vxml.56.com
Connection: Keep-Alive
Cookie: mobile_user=1310985346%401432109543; client_t=1432109631%7C37147%7Cb204cf0064376e6bad8881b57099bdef
Cookie2: $Version=1
```


#### API Response
```
HTTP/1.1 200 OK
Server: openresty
Date: Wed, 20 May 2015 08:13:52 GMT
Content-Type: application/json; charset=UTF-8
Transfer-Encoding: chunked
Connection: close
vxml-status: 1

{"info":{"bimg":"http://v6.pfs.56img.com/images/12/21/qq-16962940i56olo56i56.com_sc_143198906158hd_b.jpg","vid":"137205064","m_download":"y","textid":"MTM3MjA1MDY0","img":"http://v6.pfs.56img.com/images/12/21/qq-16962940i56olo56i56.com_sc_143198906158hd.jpg","key":"f6646494ca5d2cbb6ad57779c873c7c0","record":"","tag":"融侨李姐广场舞,最热广场舞,团队版,全民广场舞,","rela_opera":-4,"Subject":"融侨李姐广场舞 老家的月亮 团队版（附格格老师教学版）...","opera_id":-4,"sohu_cdn":"0","hd":2,"rfiles":[{"filesize":"52604872","totaltime":"1309937","url":"http://f4.r.56.com/f4.c204.56.com/flvdownload/5/4/sc_143198906158hd.flv.mp4?v=1&t=D1TeuUpFiozwCuBNPoLXEg&r=3370&e=1432196032&tt=1309&sz=52604872&vid=137205064","type":"qvga"},{"filesize":"93410632","totaltime":"1309916","url":"http://f4.r.56.com/f4.c203.56.com/flvdownload/3/4/sc_143198906158hd_clear.flv.mp4?v=1&t=NSHyzzzrAQaoMyYKamHz_w&r=3370&e=1432196032&tt=1309&sz=93410632&vid=137205064","type":"vga"},{"filesize":"180907298","totaltime":"1309916","url":"http://f4.r.56.com/f4.c204.56.com/flvdownload/16/14/sc_143198906158hd_super.flv.mp4?v=1&t=ccNvCmJnkREQNg7RUNK9YQ&r=3370&e=1432196032&tt=1309&sz=180907298&vid=137205064","type":"wvga"},{"url":"http://f4.r.56.com/f4.c203.56.com/flvdownload/3/4/sc_143198906158hd_clear.flv.m3u8?v=1&t=x77XPX8gF84_xbQFWt_nfw&r=3370&e=1432196032&tt=0&sz=0&vid=137205064","type":"m_vga"},{"url":"http://f4.r.56.com/f4.c204.56.com/flvdownload/5/4/sc_143198906158hd.flv.m3u8?v=1&t=dZPQhU5kC-e9DKF1u-9i6A&r=3370&e=1432196032&tt=0&sz=0&vid=137205064","type":"m_qvga"},{"url":"http://f4.r.56.com/f4.c204.56.com/flvdownload/16/14/sc_143198906158hd_super.flv.m3u8?v=1&t=oS1qsBPpXAkFomg2sTemnQ&r=3370&e=1432196032&tt=0&sz=0&vid=137205064","type":"m_wvga"}],"duration":"1309938","tags":"融侨李姐广场舞,最热广场舞,团队版,全民广场舞,","cid":"3","user_id":"qq-16962940"},"msg":"ok","status":"1","st":1432109632614}
```