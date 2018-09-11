需求: 使用nginx作为http代理服务器

配置文件
```
server {
    listen 8001;
    server_name _;

    access_log /logs/nginx/http_proxy.access.log main;

    # 限制IP 
    allow 127.0.0.1;
    # allow 其它
    deny  all;


    # dns服务器. 解析 $http_host
    resolver 127.0.0.1;

    # $host 不带端口. $http_host: 用户浏览器输入的
    set $upstream_endpoint $http_host; 

    location / {
        proxy_pass http://$upstream_endpoint;
    }
}

```

