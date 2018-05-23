#!/bin/bash
# set -ex
# 批量执行命令

cmdstr="$*"
if [ -n "$cmdstr" ]
then
	for h in 172.16.128.{100..200}
	do
		echo $h
		ssh $h "${cmdstr}"
    # 如果要并行
    # ssh $h "${cmdstr}" &
	done
else
	echo "Usage: $0 命令"
fi

# wait
