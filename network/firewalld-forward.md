# 使用 firewalld做 端口映射. 

2个节点: n1, n2. 

n1 看作防火墙. 有两块网卡. 一块连公网(public), 一块连接内网(dmz). 


## 设置步骤

1. 查看网口使用的区域

  firewall-cmd --get-active-zones
  dmz
    interfaces: enp0s8
  public
    interfaces: enp0s3

2. 网口2设置为DMZ区域

  sudo firewall-cmd --zone=dmz --add-interface=enp0s8
 
3.  本地打开 7070

  firewall-cmd --zone=public --add-port=7070/tcp

4. 查看 dmz 区域是否支持转发.  

  firewall-cmd --zone=dmz --query-masquerade
  # 如果不支持(上一句返回 no). 设置。
  firewall-cmd --zone=dmz --add-masquerade
  
5 添加转发规则. 将 public 7070收到的请求, 转发给 后段 192.168.30.21.

  firewall-cmd --zone=public --add-forward-port=port=7070:proto=tcp:toaddr=192.168.30.21
