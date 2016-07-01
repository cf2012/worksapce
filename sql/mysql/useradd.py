#!/usr/bin/env python2.7
#!coding=utf8
import os, sys

from string import Template


def usage():
	print "Usage:", sys.argv[0], "username password database"
	print "\t", "username: 用户名"
	print "\t", "password: 口令"
	print "\t", "database: 所属的database"
	return 0

def main(args):
	if len(args) != 3:
		sys.exit(usage())

	with open("tpl/useradd.sql", 'r') as fp:
		sql = "".join(fp.readlines())
		s = Template(sql)
		name, pswd, database = args
		print s.substitute(tpl_database_name=database, tpl_user_name=name, tpl_passswd=pswd)

if __name__ == "__main__":
	main(sys.argv[1:])

