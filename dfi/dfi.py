#!/bin/env python
#!coding=utf8
"""
输出指定目录inode使用率.  模仿 df -i.  
输入: 需要查询的磁盘分区.  例如:   dfi.py /   查询根目录的inode使用率.
输出: 如果 inode 使用率为 20%, 会返回 20. 即, 使用率 * 100.

在 CentOS 6.7 + py2.6 中测试通过
在 CentOS 6.7 + py3.5 中测试通过
在 CentOS 7.2 + py2.7 中测试通过

p.s. 
openbsd 的 df.c 中使用函数 statfs 获得 inode信息
statfs 参见: http://www.tutorialspoint.com/unix_system_calls/fstatfs.htm
"""
import os, sys

if __name__ == "__main__":
	path = sys.argv[1]
	sfsp = os.statvfs(path)

	if sfsp.f_files == 0:
		print(100)
	else:
		print(round(float(sfsp.f_files - sfsp.f_ffree)/sfsp.f_files * 100, 1) )

