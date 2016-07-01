#coding=utf8

import sys, os

def main(filename):
	top1k=[-19999999 for x in xrange(1000)]
	min_top1k= min(top1k)

	with open(filename, 'r') as fp:
		for line in fp:
			if line=="": continue
			x = int(line)
			
			# 如果x比 top1k 中最小的值大. 用 x 替换 top1k中的最小值.
			if x > min_top1k: 
				top1k.remove(min_top1k)
				top1k.append(x)
				min_top1k = min(top1k) # 替换后, 计算 top1k 中的最小值

	for x in top1k:
		print x

if __name__ == '__main__':
    main(sys.argv[1])
