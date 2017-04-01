# 山寨版MySQL审计功能 #

## 需求背景 ##
早上遇到一个问题. 一个系统`MySQL`一张表有几千条数据被修改掉了. 查询了`binlog`, 发现是一条`SQL`的`where`条件写错了. 误更新了这么多数据. 谁做的? 不知道. 

`MySQL`本身没有审计功能. 但可以山寨一个. 

## 实现方式 ##

参照: http://bbs.chinaunix.net/thread-3632588-1-1.html

在`/etc/my.cnf`中添加`init-connect`参数. 当用户登陆数据库时, 记录账户名、登陆地址、`connect_id`. 结合`binlog`，便可以查询用户执行了哪些`SQL`.
前提条件: *每人使用自己单独的账号修改数据*

在数据库里创建表, 并赋权. 
```
-- 创建 Database
create database audit;

-- 创建表, 保存登陆记录
CREATE TABLE audit.user_login
(	`id` int(11) primary key auto_increment,
	 connection_id int(11),
	`time` timestamp NOT NULL DEFAULT now(),
	`localname` varchar(30) ,
	`matchname` varchar(30)
);

-- 将写入权限赋给登陆账号
grant insert on audit.user_login to ''@'localhost';

grant insert on audit.user_login to ''@'%';

grant insert on audit.user_login to 'test'@'%';
```

在 `/etc/my.cnf`的`[mysqld]`中追加的:
```
init-connect='insert into audit.user_login(connection_id, localname, matchname) values(connection_id(),user(),current_user());'
```

然后重启

## 进度 ##
[X] 实现基本功能. 当用户登录时, 记录相应信息.

[ ] 目前新增用户后, 还需要将 `audit.user_login`的`insert`权限赋给他. 否则用户无法登陆. 有点麻烦. `MySQL`中不能将执行表的`Insert`权限赋给所有人吗?

[ ] 排除程序账户. `init-connect`中调用存储过程. 在存储过程中,排除程序账户.


## 期间遇到的错误 ##

添加 `init-connect` 后, `MySQL`重启失败. 查询日志. 原来是重启时的用户没有审计表的插入权限. 赋权后成功. 

