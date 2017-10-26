CentOS中使用mailx登陆stmp服务器发送电子邮件
===========================================

现在每周有个任务要定时处理一下. 一周2次. 我在`jenkins`里配置了定时任务. 完成了自动化. 任务结束后,还需要邮件通知一下相关人.  作为一个懒人, 我把这事交给程序了 :)

目前有多个轮子, 但还是觉得不够 :)

深挖了一下,在`man mail` 里看到这段

	   Sending mail from scripts
       If you want to send mail from scripts, you must be aware that mailx reads the user’s configuration files by default.  So unless
       your script is only intended for your own personal use (as e.g. a cron job), you need to circumvent this by invoking mailx like

           MAILRC=/dev/null mailx -n

       You then need to create a configuration for mailx for your script.  This can be done by either pointing the MAILRC variable  to
       a custom configuration file, or by passing the configuration in environment variables.  Since many of the configuration options
       are not valid shell variables, the env command is useful in this situation.  An invocation could thus look like

           env MAILRC=/dev/null from=scriptreply@domain smtp=host \
                 smtp-auth-user=login smtp-auth-password=secret \
                 smtp-auth=login mailx -n -s "subject" \
                 -a attachment_file recipient@domain < content_file

**测试通过.** 

使用这个方法的优点:

* 跟直接用mail比, 终于可以走`smtp`了.
* 系统自带. 不用额外写代码了.
* 可以支付附件. 挺方便的

## p.s. 环境信息

* 操作系统: CentOS 6.9
* 使用的工具: mailx


## 拓展

环境变量`MAILRC`控制程序取哪个配置文件. 取值优先级如下:

* 优先级 1. 用户设置的值. 比如设置 `MAILRC=/dev/null` 或者其它
* 优先级 2. ~/.mailrc  如果用户没有设置. 优先读它.
* 优先级 3. /etc/mail.rc 如果用户的 `~/.mailrc`存在, 就不读取这个了.


如果设置了 `~/.mailrc` 就可以直接用`mail`通过`stmp`形式发送邮件了. /哈哈

举例:

文件`~/.mailrc` 内容

	# 发件人
	set from=cf2012@example.com

	# 邮件服务器地址 (MTA地址)
	set smtp=mail.example.com 

	# 账户
	set smtp-auth-user=cf2012@example.com

	# 密码
	set smtp-auth-password=xxxxxxxx
 
	set smtp-auth=login
	
使用:

	mailx -a nohup.out -s 程序日志  cf2012@example.com << EOF
	RT
	EOF

就可以将日志发送到自己的邮箱了 :)


## 更多参数

	
	-a file  添加附件.
		Attach the given file to the message.

	-b address  将邮件密送给xxx. 支持多个人,收件人列表用逗号分隔
		Send blind carbon copies to list.  List should be a comma-separated list of names.

	-c address 抄送给xxx.支持多个人,用逗号分隔   
         Send carbon copies to list of users.

	-s subject 邮件主题
          Specify subject on command line (only the first argument after the -s flag is used as a subject; be careful to  quote  subjects  containing
          spaces).
