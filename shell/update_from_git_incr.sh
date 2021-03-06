#!/bin/bash
#Created by libin, 2017/02/14

# 目的:  从git中更新, 然后将新增的文件增量传到服务器端. 

#重要说明: 
# 1. 需要在 client & Server side 均安装 rsync.  CentOS 6.7: yum install -y rsync 
# 2. Client 需要免密码登陆 Server

#本地保存路径
local_dir="/dev/shm/xxx"

# 远端保存路径
remote_dir="UserName@host:/dev/shm/"

# git 库地址
repository_url=""


die(){
        echo $@ 1>&2
        exit 1
}

init(){
	# 创建仓库
	cd `dirname $local_dir` && git clone ${repository_url} || die "初始化失败"
}

update(){
	# 更新
	cd ${local_dir} && git pull || die "更新代码失败"
}

push_incr(){
	# 增量传送文件, 排除 .git 目录
	# sending incremental file list
	# 如果要同步删除, 需要调整这里 rsync 的参数
	rsync -aAXhv --exclude ".git" ${local_dir} ${remote_dir}
}

case "$1" in
	"init")
		init
		;;
	"update")
		update && push_incr
		;;
	*)
		echo "Usage: $0 init | update"
		echo "    init 初始化本地git仓库"
		echo "    update 下载增量, 并将增量推送到远端服务器"
		echo "e.g."
		echo "    初始化并上传到远端:  $0 init && $0 update"
		echo "    将增量更新到远端:  $0 update"
		;;
esac

