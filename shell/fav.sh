# 常用 

# 生成随机字符串
openssl rand -base64 32

# 创建用户
useradd  -d /var/lib/redis -m -s  /sbin/nologin redis
useradd  -d /home/wildfly  -m -s  /bin/bash wildfly

# 删除用户
userdel redis
userdel -r redis # 会删除用户的 HOME 目录

# 查询进程内存占用情况
ps aux | head -1; ps aux | grep nginx

# 查询 tcp 连接情况. 显示: TIME_WAIT 数量, ESTABLISHED 数量
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'

# rsync-ssh-on-different-port
# 参见: http://www.linuxquestions.org/questions/linux-software-2/rsync-ssh-on-different-port-448112/
rsync -avzH  --progress --inplace --rsh="ssh -p2222"  $files $username@$ip:$remote_dir/
