#!/bin/bash

# 目的: 从GitLab中下载Web静态页面, 然后发布到Web服务器中.
# 使用的环境变量: WORKSPACE, 工作目录. 本地Git仓库的保存目录. Jenkins调用该shell脚本时,会自动传.
# 输入参数:  git地址  分支  远程目录地址 [要上传的本地目录]
# i.e. $0 git地址 develop xxxx  dist

repository="${1:? 参数1, git地址不能为空}"

branch="${2:? 参数2, Git分支名称不能为空}"

remote_dir="${3:?参数3, 远程目录地址不能为空}"


# 本地git仓库中, 要上传的目录. 可选参数
local_dir="$4"

# 脚本被Jenkins调用时, Jenkins会传WORKSPACE. 
# 如果不传 `WORKSPACE`, 会取当前工作目录作为默认值
#default value is `pwd`, https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html
workspace=${WORKSPACE-`pwd`}

repository_dir="`basename ${repository}`"

rsync_host="用户名@主机" # 需要修改
rsync_dest="/var/www/${remote_dir}" # 程序要部署的目录

############
echo "~~~~~~~~~~~~~~~~~~~~~~~"
echo "Git地址: ${repository}"
echo "Git分支: ${branch}"
echo "远程目录: ${remote_dir}"
echo "本地Git仓库路径: ${workspace}/${repository_dir}"
echo "本地Git仓库中,要上传的目录: [${local_dir}], 可选参数, 可为空"
echo "文件发布主机: ${rsync_host:? 参数 rsync_host, 文件要发布到的主机不能为空!}"
echo "文件发布目录: ${rsync_dest:? 参数 rsync_dest, 发布目录不能为空!}"
echo "~~~~~~~~~~~~~~~~~~~~~~~"

# 从Git仓库中下载更新.
cd ${workspace}
if [ -d ${repository_dir} ]
then
	cd ${workspace}/${repository_dir}
	echo "> 本地仓库已经存在, 拉取最新代码"
	echo ">> 拉取前本地仓库: "
	git log -1
	#git fetch origin ${branch} 
	echo "> 下载远程库的内容, 不做合并"
	git fetch --all
	echo "> 将 HEAD 指向刚刚下载的最新版本"
	git reset --hard origin/${branch}
	# 删除本地新增但没有提交的文件
	git clean -xdf 
	echo "> 更新后,本地仓库:"
	git log -1
	# git pull origin ${branch}
	# git checkout -b ${branch}
else
	echo "> 本地仓库不存在, clone"
	cd ${workspace} && git clone -b ${branch} ${repository} ${repository_dir}
fi


echo "> 增量上传文件. p.s. 会删除已经删除的文件"
cd ${workspace} && rsync -avzP  --delete ${repository_dir}/${local_dir}  ${rsync_host}:${rsync_dest}


