#!/usr/bin/python
#!coding=utf8
import os, sys,commands

import logging
logging.basicConfig(filename='/var/logs/commit-control.log',format='%(asctime)s %(message)s',level=logging.DEBUG)
log = logging.getLogger('commit-contorl')

svnlook='/usr/bin/svnlook'

def system(cmd_string):
	status, output = commands.getstatusoutput(cmd_string)
	log.debug('cms:[%s], status:[%s],output:[%s]'%(cmd_string, status, output))

	if status <> 0:
		sys.exit(-1)

	return status, output

def count_char(s):
	"""
	计算字符串中的字符数.

	对中文做特殊处理:
		用提交的注释中: a中文b
		钩子中获取的值: a?\228?\184?\173?\230?\150?\135b
	"""
	import re
	p= re.compile(r'\?\\\d{1,3}')
	words = p.findall(s)
	return len(s) - sum([len(x) for x in words]) + len(words)/3



def main(args):
	log.debug("args: REPOS-PATH=%s, TXN-NAME=%s, [%d]"%(args[0], args[1], len(args)))
	repos, txn = args[0], args[1]

	log.debug("仓库:{0}, 指定事务名称:{1}".format(repos, txn))

	# 查询出修改的目录
	#svnlook  dirs-changed   /opt/svnroot/repos  -r xx
	status, output = system("{0} dirs-changed {1} -t '{2}'".format(svnlook, repos, txn))
	dirs_changed = output.split('\n')

	# 如果修改了目录 xx, yyy, 读取提交的注释
	for d in dirs_changed:
		log.debug("修改的目录为:%s"%d)

		# http://127.0.0.1:6060/svn/web/ui  UED组的目录不做限制
		if ("%s/%s"%(repos, d)).startswith('/opt/svnroot/web/ui/'):
			log.debug("UED组的目录不做限制")
			continue

		status, output = system("{0} log {1} -t '{2}'".format(svnlook, repos, txn))
		message = output.strip()

		# 中文: a?\228?\184?\173?\230?\150?\135b
		length = count_char(message)
		log.debug("填写的注释为[%d]:%s"%(length,message))

		if length < 20:
			log.debug("注释长度不满足要求, 抛出错误. 拒绝提交")
			sys.stderr.write("请填写长度大于等于20的注释. 当前注释长度:%d, 长度不足,不允许提交!"%(length))
			sys.exit(-1)

	pass

if __name__ == '__main__':
	#输入参数1: REPOS-PATH   (the path to this repository)
	#输入参数2: TXN-NAME     (the name of the txn about to be committed)
	sys.exit(main(sys.argv[1:]))

