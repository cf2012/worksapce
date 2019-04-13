## 背景
某项目使用CDH5.8作为大数据平台. 设备重启后, Hbase启动失败. stderr中报错为: 60020端口被占用.
操作系统: CentOS7.2

## 处理过程

	# 1. 查看端口被哪个进程占用. 查询不到结果
	ss -nltp |grep 60020
	
	# 2. 继续查询.  终于查询到结果
	ss -anp | grep 60020
	
	# 3. 查看进程ID对应的进程信息. 查询到是 hdfs进程占用的. 
	ps -ef | grep $pid 

## 原因
`client`连接`Server`时, `client` 会从操作系统随机申请一个端口, 占用.  而`hdfs`进程正好申请到了`60020`端口.

## 临时处理方法
重启`hdfs`, 重启后, `hdfs` 会将60020端口释放. 然后启动`hbase`.  问题解决. 

## 反思
为什么 `hdfs` 会随机到`60020`端口?

查看操作系统默认的随机端口范围:  

	# 查看操作系统默认的随机端口范围.  60020 在此范围内
	cat /proc/sys/net/ipv4/ip_local_port_range
	32768 61000

解决方法:
方法1. 修改 ip_local_port_range 范围, 排除掉 CDH各个组件的监听端口. 
修改文件 `/etc/sysctl.conf`, 追加: `net.ipv4.ip_local_port_range = 32768 50000`, 然后执行

	# 加载配置
	sysctl -p /etc/sysctl.conf
	
	# 验证结果
	cat /proc/sys/net/ipv4/ip_local_port_range

方法2. 通过`CDH`管理界面修改相应组件的监听端口. 将监听端口, 调整到`ip_local_port_range`之外. 

方法3. 设置 `net.ipv4.ip_local_reserved_ports`, 将在 `ip_local_port_range`内的监听端口加入`ip_local_reserved_ports`中. 

## 参考资料
《修改linux端口范围 ip_local_port_range》 http://www.cnblogs.com/solohac/p/4154180.html
 
《预留端口避免占用ip_local_reserved_ports》http://www.ttlsa.com/linux/reserved-port-to-avoid-occupying-ip_local_reserved_ports/
