#!/bin/bash

# 目的: Jenkins编译完毕war包后, 调用该脚本. 完成: 上传war包, 重启Tomcat服务器

workspace=${WORKSPACE-`pwd`}

# 将文件传送到目标服务器
push(){
	host=$1
	echo $host
	find ${workspace} -type f -name "*.war" -exec scp {} $host \;
}

# 重启 web 服务器
# 输入参数格式:  user@host:remote_dir, e.g: webapp@wf-1:/var/www/tomcat/webapp
restart(){
	host=`echo $1 | cut -d: -f1`
	ssh $host service tomcat restart
}

#
usage(){
	echo "将War包发布到执行服务器"
	echo "Usage: $0 push|deploy  user@host:dir [user@host2:dir [user@host3:dir]]"
	echo "	push 将编译好的文件推送的远端服务器"
	echo "	restart  重启远端服务器"
	echo "	deploy  push+restart"
	echo "e.g.  $0 deploy webapp@as-1:/var/www/tomcat/webapp  webapp@as-2:/var/www/tomcat/webapp"
}


case "$1" in
	"push")
		shift
		for host in $*
		do
			echo $host
			push $host
		done
		;;

	"deploy")
		shift
		for host in $*
		do
			push  $host && restart $host
		done
		;;

	*)
		usage
		;;
esac
