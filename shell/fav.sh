# ���� 

# ��������ַ���
openssl rand -base64 32

# �����û�
useradd  -d /var/lib/redis -m -s  /sbin/nologin redis
useradd  -d /home/wildfly  -m -s  /bin/bash wildfly

# ɾ���û�
userdel redis
userdel -r redis # ��ɾ���û��� HOME Ŀ¼

# ��ѯ�����ڴ�ռ�����
ps aux | head -1; ps aux | grep nginx

# ��ѯ tcp �������. ��ʾ: TIME_WAIT ����, ESTABLISHED ����
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'


