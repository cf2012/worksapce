#! /usr/bin/env python3

import socket
import ssl
import time
import sys
import os

"""
目的: 对https证书有效期做监控. 快过期前,提前告警. 

实现方式:
  使用py判断证书是否过期& 调用 zabbix_sender将指标推送给 zabbix-server.
  程序使用 rundeck 定时运行. 
  

监控指标:
	trapper.ssl-certificate.${host}.valid, 是否有效
		1 ⇒ true
		2 ⇒ false

	trapper.ssl-certificate.${host}.days 剩余有效天数
  
  trapper.ssl-certificate.job_status. 工作状态
    1 -> 完工了
  
 告警:
  1. 证书过期告警. 级别: 灾难
  2. 证书有效期低于30天, 告警. 级别: 严重
  3. trapper.ssl-certificate.job_status 最后更新时间在24天之前, 告警.  级别: 严重.  --> 检查证书是否有效的job没有运行.
"""


hosts=[
	"www.163.com",
	"github.com",
]



def push_metrics(key, value):
	return # 先不发给 zbx
	sender_cmd = """\
zabbix_sender -z zbx-server -s "me" -k {key} -o {value}""".format(key=key, value=value)
	os.system(sender_cmd)
	print(sender_cmd)


def check_validation(host):
	now = time.time()

	context = ssl.SSLContext(ssl.PROTOCOL_TLSv1_2)
	context.verify_mode = ssl.CERT_REQUIRED
	context.check_hostname = True
	context.load_default_certs()

	conn = context.wrap_socket(socket.socket(socket.AF_INET),server_hostname=host)
	conn.connect((host, 443))
	cert = conn.getpeercert()

	ttl = ssl.cert_time_to_seconds(cert['notAfter']) - now
	print(ttl)
	print(ttl/3600/24)

	k = host.split('.')[0]
	if ttl < 0:
		push_metrics("trapper.ssl-certificate.{0}.valid".format(k), 2)
	else:
		push_metrics("trapper.ssl-certificate.{0}.valid".format(k), 1)

	push_metrics("trapper.ssl-certificate.{0}.days".format(k), round(ttl/3600/24, 2))

def main():
	for h in hosts:
		check_validation(h)
	push_metrics("trapper.ssl-certificate.job_status", 1)


if __name__ == '__main__':
	main()
