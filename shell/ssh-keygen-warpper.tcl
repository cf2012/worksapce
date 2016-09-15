#!/usr/bin/expect 
# 作用: 调用 ssh-keygen 生成公私钥. 生成公私钥时,不需要人工按`回车`,便于自动化部署
# 在CentOS7.2 expect-5.45 中测试通过

spawn ssh-keygen

expect {
	"*:*" { send "\r"; exp_continue}
	expect eof
}
exit
