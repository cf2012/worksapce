#!/bin/bash

# clone
# 输入参数:  git地址  分支  远程目录地址 [要上传的本地目录]
# i.e.$0 git地址 develop xxxx  dist 


repository="${1:? 参数1, git地址不能为空}"

branch="${2:? 参数2, Git分支名称不能为空}"

remote_dir="${3:?参数3, 远程目录地址不能为空}"


# 本地git仓库中, 要上传的目录. 可选参数
local_dir="$4"

#default value is `pwd`, https://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html
workspace=${WORKSPACE-`pwd`}

repository_dir="`basename ${repository}`"

rsync_host="用户@主机"  # 需要修改
rsync_dest="/var/www/html/${remote_dir}" # 程序要部署的目录

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

# 1. 切换到工作目录
cd ${workspace}


# 2. 从Git仓库中下载更新.
if [ -d ${repository_dir} ]
then
	echo "本地仓库已经存在, 拉取最新代码"
	#git fetch origin ${branch} 
	git reset --hard origin/${branch}
	git clean -xdf 
	git pull origin ${branch}
	git checkout -b ${branch}
else
	echo "本地仓库不存在, clone"
	git clone -b ${branch} ${repository} ${repository_dir}
fi

# 3. 将文件上传的Web服务器相应目录下.
echo "增量上传文件. p.s. 会删除已经删除的文件"
rsync -avzP  --delete ${repository_dir}/${local_dir}  ${rsync_host}:${rsync_dest}
