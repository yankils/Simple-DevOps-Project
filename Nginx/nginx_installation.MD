1. update your system 
```sh 
 # yum update
```

2. Download Nginx latest version. version we use here is : 

2. download latest version of nginx from http://nginx.org/en/download.html website
```sh 
 # cd /opt
 # wget http://nginx.org/download/nginx-1.15.4.tar.gz
 # tar -zxvf nginx-1.15.4.tar.gz
 # mv nginx-1.15.4 /opt/nginx 
```
 
3. In order to compile our source code we need to install dependences. 
```sh
  # yum groupinstall "Development Tools"
  # yum install pcre pcre-devel zlib zlib-devel openssl openssl-devel
```

4. Run /opt/nginx/configure file with below parameters 
```sh
	# cd /opt/nginx 
	# ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf  --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid --with-http_ssl_module
```

5. Now compile and install  nginx 
```sh
 # make 
 # make install 
 ```
 
6. Check nginx version and start service to use. 
```sh 
 # nginx -V
 # nginx 
 ```

6. Setup nginx as a system servicecreate a file /lib/systemd/system/nginx.service and copy below URL content into that and modify according to your file path locations. 
```sh 

Ref URL : https://www.nginx.com/resources/wiki/start/topics/examples/systemd/

# vi /lib/systemd/system/nginx.service
```

copy below contant in to nginx.service file by changing PIDFile location 

```sh 
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid 
ExecStartPre=/usr/bin/nginx -t  
ExecStart=/usr/bin/nginx 
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
 7. Start nginx and test 
 ```sh 
 # systemctl start nginx
 # systemctl enable nginx
 # ps aux | grep nginx
 ```
