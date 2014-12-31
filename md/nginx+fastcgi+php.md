# Nginx + FastCGI + PHP 安装文档

## 安装php

### 下载PHP

```
wget -L http://jp1.php.net/get/php-5.6.4.tar.bz2/from/this/mirror
```

### 编译安装

```
tar jxvf php-5.6.4.tar.bz2 

cd php-5.6.4 

./configure --prefix=/usr/local/php-5.6.4 --enable-fpm 
    /--enable-mbstring --enable-pdo --disable-debug --disable-rpath     
    /--enable-inline-optimization --with-bz2 --with-zlib --enable-sockets 
    /--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash 
    --enable-zip --with-pcre-regex --with-mysql --with-mysqli --with-gd 
    /--with-jpeg-dir --with-config-file-path=/etc

make 

make install
```

### 设置php环境变量

```
ln -s /usr/local/php-5.6.4 /usr/local/php

export PATH=/usr/local/php/bin:$PATH
```

### 配置php-fpm
```
cp /usr/local/php/etc/php-fpm.conf.defau /etc/php-fpm.conf

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
