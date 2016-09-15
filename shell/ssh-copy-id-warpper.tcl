#!/usr/bin/expect 
# filename: ssh-copy-id-warpper.tcl
# 作用: 将公钥复制到对端主机上. 
# 调用方法: ssh-copy-id-warpper.tcl  $ip $password
# p.s. 
#	1. 如果密码中有特殊字符, 使用单引号''包起来
#	2. 将password放到参数中会有安全隐患 —— 使用history可以看到口令

set ip   [lindex $argv 0]
set password [lindex $argv 1]

set timeout 60

puts "> ssh-copy-id $ip"

spawn ssh-copy-id $ip
expect {
	"*yes/no*" { send "yes\r"; exp_continue}
	"*password:*" { send "$password\r"; exp_continue}
	expect eof
}

exit
