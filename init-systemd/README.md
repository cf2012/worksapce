# 为什么整理Systemd相关资料. 

2016年之前的项目使用的是`CentOS 6.x`.  2016年开始, 部分项目转移到`CentOS 7.x` 上. 开始学些 `Systemd`



# Tips #

1. `man systemd.exec` 可以看到配置文件中相关参数的文档. 

2. 通过Systemd配置文件, 直接修改进程可以使用的句柄数+线程数:  `LimitNPROC=8000`. 

3. 同一个变量可以写多行. 比如 `Environment`

4. `man` 中建议对于`long-running services` 设置 `ProtectSystem`, `ProtectHome`.


# 参考资料 #
http://www.ibm.com/developerworks/cn/linux/1407_liuming_init3/index.html

http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html

https://coreos.com/os/docs/latest/using-environment-variables-in-systemd-units.html

