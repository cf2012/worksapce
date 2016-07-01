# 常用 

# 生成随机字符串
openssl rand -base64 32

# 创建用户
useradd  -d /var/lib/redis -m -s  /sbin/nologin redis
useradd  -d /home/wildfly  -m -s  /bin/bash wildfly

# 删除用户
userdel redis
userdel -r redis # 会删除用户的 HOME 目录

