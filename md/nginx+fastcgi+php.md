# Nginx + FastCGI + PHP 安装文档

## 安装mcrypt支持


从[sourceforge](http://sourceforge.net/)下载[mcrypt-2.6.8](http://sourceforge.net/projects/mcrypt/files/MCrypt/2.6.8/)、[libmcrypt-2.5.8](http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/)和[mhash-0.9.9.9](http://sourceforge.net/projects/mhash/files/mhash/0.9.9.9/)。

* 安装libmcrypt

```
tar xvfj libmcrypt-2.5.8.tar.bz2 

cd libmcrypt-2.5.8

./configure

make 

make install
```

* 安装mhash

```
tar xvfj mhash-0.9.9.9.tar.bz2

cd mhash-0.9.9.9

./configure

make 

make install
```

* 安装mcrypt

```
tar zxvf mcrypt-2.5.8.tar.gz

cd mcrypt-2.5.8

LD_LIBRARY_PATH=/usr/local/lib ./configure

make

make install
```

## 安装php

### 下载PHP

```
wget -L http://jp1.php.net/get/php-5.6.4.tar.bz2/from/this/mirror
```

### 编译安装

```
tar jxvf php-5.6.4.tar.bz2 

cd php-5.6.4 

# 测试服务器编译参数
./configure --prefix=/usr/local/php-5.6.4 --enable-fpm --enable-mbstring --enable-pdo --disable-debug --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash --enable-zip --with-pcre-regex --with-mysql --with-mysqli --with-gd --with-jpeg-dir --with-config-file-path=/etc --with-pdo-mysql=/usr/local/mysql --with-freetype-dir=/usr/include/freetype2/freetype/ --with-mcrypt --enable-opcache

# aliyun服务器编译参数
./configure --prefix=/usr/local/php-5.6.4 --enable-fpm --enable-mbstring --enable-pdo --disable-debug --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash --enable-zip --with-pcre-regex --with-mysql --with-mysqli --with-gd --with-jpeg-dir --with-config-file-path=/etc --with-pdo-mysql=mysqlnd --with-freetype-dir=/usr/include/freetype2/freetype/ --with-mcrypt --enable-opcache


make 

make install
```

#### 编译php时出现的错误
##### 1. 错误信息 --enable-opcache=no
```
checking "whether flock struct is BSD ordered"... "no"
configure: error: Don't know how to define struct flock on this system, set --enable-opcache=no
```

```
echo '/usr/local/lib'  >> /etc/ld.so.conf

ldconfig
```

### 设置php环境变量

```
ln -s /usr/local/php-5.6.4 /usr/local/php

export PATH=/usr/local/php/bin:$PATH
```

### 配置php-fpm
```
cp /usr/local/php/etc/php-fpm.conf.default /etc/php-fpm.conf

groupadd www
useradd -g www www
```

```
vi /etc/php-fpm.conf

user = www
group = www

error_log = log/php-fpm.log

pid = run/php-fpm.pid

```

### 配置php.ini
```
cp ${source_dir}/php.ini-[development|production] /etc/php.ini
```

### 查看php-fpm的错误日志
```
tail -f /usr/local/php/var/log/php-fpm.log
```

### 重启php-fpm
```
kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
```


## 动态编译并配置openssl

```
cd {php-src}/ext/openssl

mv config0.m4 config.m4

/usr/local/php/bin/phpize

./configure --with-openssl --with-php-config=/usr/local/php/bin/php-config
make
make install
```

在/etc/php.ini中添加一行

```
extension=openssl.so
```


# Nginx配置


## 虚拟主机配置
```
server {
        listen       9900;
        server_name  athena.dq.in;

        #charset koi8-r;


        location / {
            root   /dq/appdir/php/athena-report/appliction;
            index  index.html index.htm index.php;
            if (!-e $request_filename) {
                 rewrite ^.*$ /index.php last;
            }

            access_log  /usr/local/nginx/logs/athena.access.log  webapplog;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php($|/) {
            root   /dq/appdir/php/athena-report/appliction;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_split_path_info ^(.+\.php)(.*)$;
            fastcgi_param   PATH_INFO $fastcgi_path_info;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        location ~ /\.ht {
            deny  all;
        }
    }
```