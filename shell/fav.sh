# ���� 

# ��������ַ���
openssl rand -base64 32

# �����û�
useradd  -d /var/lib/redis -m -s  /sbin/nologin redis
useradd  -d /home/wildfly  -m -s  /bin/bash wildfly

# ɾ���û�
userdel redis
userdel -r redis # ��ɾ���û��� HOME Ŀ¼

