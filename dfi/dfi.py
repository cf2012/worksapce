#!/bin/env python
#!coding=utf8
"""
输出指定目录inode使用率.  模仿 df -i 
在 CentOS 6.7 + py2.6 中测试通过
在 CentOS 6.7 + py3.5 中测试通过
在 CentOS 7.2 + py2.7 中测试通过
"""
import os, sys

if __name__ == "__main__":
	path = sys.argv[1]
	sfsp = os.statvfs(path)

	if  sfsp.f_files == 0:
		print(100)
	else:
		print(round(float(sfsp.f_files - sfsp.f_ffree)/sfsp.f_files * 100, 1) )

