#!/bin/env python3
#!coding=utf-8

""" 操作 Cisco 2960 交换机
"""

import telnetlib

to_bytes = lambda x: x.encode(encoding='utf-8')

class SW2960():
    def __init__(self, host, username, pswd, enable_pswd):
        self.host = host
        self.username= username
        self.login_pswd = pswd
        self.enable_pswd = enable_pswd
        self.tn = None
        self.finish = to_bytes('>')
        self.finish2 = to_bytes('#')
        pass

    def login(self, debug=None):
        """ 登陆
        """
        self.tn = telnetlib.Telnet(self.host, port=23, timeout=30)
        if debug:
            self.tn.set_debuglevel(2)
        self.tn.read_until(to_bytes('Username: '))
        self.tn.write(to_bytes(self.username + '\n'))

        self.tn.read_until(to_bytes('Password: '))
        self.tn.write(to_bytes(self.login_pswd + '\n'))

        self.tn.read_until(self.finish)
        pass

    def exec_cmd(self, cmds):
        """ 正常的模式执行命令
        """
        # 执行用户的命令
        if callable(cmds):
            cmds(self.tn)
        elif isinstance(cmds,list) or isinstance(cmds, tuple):
            for c in cmds:
                self.tn.write(to_bytes(c + '\n'))
                self.tn.read_until(self.finish)
        elif isinstance(cmds, str):
            self.tn.write(to_bytes(cmds + '\n'))
            self.tn.read_until(self.finish)
        else:
            print('不支持的参数')
        pass

    def enable(self):
        """ 进入管理模式
        """
        self.tn.write(to_bytes('enable' + '\n'))
        self.tn.read_until(to_bytes('Password: '))

        self.tn.write(to_bytes(self.enable_pswd + '\n'))
        self.tn.read_until(self.finish2)
        pass

    def config_terminal(self, cmds):
        """ 进入编辑模式, 修改配置
        """
        try:
            # 进入编辑模式
            self.tn.write(to_bytes('config terminal' + '\n'))
            self.tn.read_until(self.finish2)

            # 执行用户的命令
            if callable(cmds):
                cmds(self.tn)
            elif isinstance(cmds,list) or isinstance(cmds, tuple):
                for c in cmds:
                    self.tn.write(to_bytes(c + '\n'))
                    self.tn.read_until(self.finish2)
            elif isinstance(cmds, str):
                self.tn.write(to_bytes(cmds + '\n'))
                self.tn.read_until(self.finish2)
            else:
                print('不支持的参数')
        finally:
            # 退出 编辑模式
            self.tn.write(to_bytes('end' + '\n'))
            self.tn.read_until(self.finish2)
        pass

    def save(self):
        self.tn.write(to_bytes('write' + '\n'))
        self.tn.read_until(self.finish2)
        pass

    def do_show_arp(self):
        """ 获得 arp 列表
        Internet  ip地址         -   mac地址  ARPA
        """
        self.tn.write(to_bytes('show arp' + '\n'))
        arp_list = to_bytes('')
        while True:
            #  show arp 会分页显示
            i, obj, data = self.tn.expect([to_bytes('--More--'), self.finish ], timeout=10)
            if i == 0:
                arp_list += data
                self.tn.write(to_bytes(' '))
            elif i== 1:
                arp_list += data
                break
        tmpbuf = arp_list.decode()
        tmpbuf = [ x.strip() for x in tmpbuf.split('\n') ]

        for x in tmpbuf:
            if x.startswith('Internet'):
                L = x.split()
                yield L[1], L[3]

    def logout(self):
        self.tn.write(to_bytes('exit\n'))
        self.tn.read_all()
        self.tn.close()
        pass


def test1():
    """ 登陆交换机,重启网口. switch port.
    """
    sw = SW2960("ip", "admin","admin_password", "enable_password")
    sw.login()
    sw.enable()
    sw.config_terminal(["int 网口名字", "shutdown", "no shutdown"])
    sw.logout()
