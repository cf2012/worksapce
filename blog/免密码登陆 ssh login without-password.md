# 环境信息

CentOS 7.2
# 目的

安装 `Ambari` 时, 需要设置免密码登陆
# 步骤
1. 生成公私钥(如果已经有,跳过)
2. 使用`ssh-copy-id`将本机的公钥复制到对端
   
   ```
   # 生成公私钥
   ssh-keygen
   
   # 将本地公钥复制到对端的 ~/.ssh/authorized_keys 中
   ssh-copy-id 用户名@IP
   ```
# 涉及的文件

`~/.ssh`, 目录, 权限需要为 700

`~/.ssh/authorized_keys` 经过认证的公钥

`~/.ssh/known_hosts` 远端服务器指纹

`~/.ssh/id_rsa.pub` 公钥. 文件权限: 644

`~/.ssh/id_rsa` 私钥. 文件权限: 600
# 遇到的错误以及解决方法
1.  将公钥加入对端`authorized_keys`后, 登陆依然需要手工输入口令

分析: tail -f /var/log/secure 发现 ~/.ssh的权限不对. 当时我是手工复制的. 
解决方法: chmod 700 ~/.ssh; chmod 600 ~/.ssh/*
