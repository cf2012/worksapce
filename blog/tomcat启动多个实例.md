## Running Multiple Tomcat Instances


#CATALINA_HOME 设置为安装目录.
CATALINA_HOME="/opt/apache/apache-tomcat-7.0.32"; export CATALINA_HOME

# tomcat运行目录
CATALINA_BASE="/home/app/nexus"; export CATALINA_BASE

# 启动
$CATALINA_HOME/bin/startup.sh

$CATALINA_BASE 目录下需要有一下文件:
* /conf - 存放配置
* /logs - 日志
* /webapps - 代码

配置多实例方法:
1. 确定 CATALINA_HOME，CATALINA_BASE

2. 创建实例需要的目录:
[ -e ${CATALINA_BASE} ] && mkdir ${CATALINA_BASE}/{conf,logs,webapps,temp,work}


3. 将tomcat下的conf复制过来, 并酌情修改
cp -R $CATALINA_HOME/conf  $CATALINA_BASE/


2014/10/06 操作
CATALINA_BASE=`pwd`
[ -e ${CATALINA_BASE} ] && mkdir ${CATALINA_BASE}/{conf,logs,webapps,temp,work}

# 需要 root 权限才能将文件复制过去。 
# 复制完毕后，需要修改文件属组
cp -R $CATALINA_HOME/conf  $CATALINA_BASE/

2. 修改端口
# 文件名： server.xml
<Server port="-1" shutdown="SHUTDOWN">
    <!-- Define an AJP 1.3 Connector on port 8009 -->
    <!-- Connector port="8009" protocol="AJP/1.3" redirectPort="8443" / -->


supervisord中的配置
```
[program:dubbo-admin]
command=/opt/apache-tomcat-8.0.14/bin/catalina.sh run
directory=/home/dubboadmin
environment=CATALINA_BASE="/home/dubboadmin/tomcat",CATALINA_OPTS="'-server -Xms1024m -Xmx2048m -XX:PermSize=512M -XX:MaxNewSize=1000m -XX:MaxPermSize=1000m '"
autostart=true             
autorestart=true       
user=dubboadmin                 
stdout_logfile=/var/log/dubbo-admin.stdout.log      
stderr_logfile=/var/log/dubbo-admin.stderr.log   
```

初始化配置
参见: https://wiki.apache.org/tomcat/FAQ/CharacterEncoding
关于URL的编码. 
Tomcat 6,7,8 的URL默认使用ISO-8859-1. 中文会出现乱码. 

处理方式:

There are two ways to specify how GET parameters are interpreted:
    1. Set the URIEncoding attribute on the <Connector> element in server.xml to something specific (e.g. URIEncoding="UTF-8").
    2. Set the useBodyEncodingForURI attribute on the <Connector> element in server.xml to true. This will cause the Connector to use the request body's encoding for GET parameters.

