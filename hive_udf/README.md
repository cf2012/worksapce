# Hive udf

## 背景

系统中有一个打分流程. 之前是通过Hive完成. 从A表中取记录. 根据若干字段,计算出这条记录的分数(权值). 改流程耗时30分钟到1个小时. 因业务需求,T+0的数据需要在2小时内处理完毕. 打分流程成为瓶颈. 所以采用`UDF`(User Defined Functions)方式实现.

## 实现步骤

简单地说. UDF使用Python模板动态生成,运行时,计算分数. 使用`UDF`将打分流程耗时降低到5分钟以内.

执行步骤:

* 程序运行时,根据参数表+模板,生成对应的 udf文件
* 将`udf`文件提交到`hive`
* 执行

类似这种:
```python
#!/usr/bin/env python
import sys
import string
import hashlib

while True:
    line = sys.stdin.readline()
    if not line:
        break

    line = string.strip(line, "\n ") # 我程序最先使用 string.strip(line). 当输入的数据末尾的字段为`null`时,会报错!!
    clientid, devicemake, devicemodel = string.split(line, "\t")
    phone_label = devicemake + ' ' + devicemodel
    print "\t".join([clientid, phone_label, hashlib.md5(phone_label).hexdigest()])

```

```sql
add file wasbs:///hiveudf.py;

SELECT TRANSFORM (clientid, devicemake, devicemodel)
    USING 'python hiveudf.py' AS
    (clientid string, phoneLabel string, phoneHash string)
FROM hivesampletable
ORDER BY clientid LIMIT 50;

```

## 遇到的问题

1. `select`语句末尾需要添加`limit`. 不加会报错. 原因不明.  未解决. 目前处理方式, 末尾加一个比现有记录数大很多的值 `limit 200000000` (2亿)
2. 生成的结果,末尾字段带了`\n`. 其中,`hive`表是`orc`格式. 原因: `print`默认会加一个`\n`... 解决: py程序里,去掉换行.
3. 一部分数据插入报错. 原因: 程序bug. 程序里最先用了  `input.strip()`  . 

## 参考资料 
https://docs.microsoft.com/en-us/azure/hdinsight/hadoop/python-udf-hdinsight

http://dwgeek.com/hive-udf-using-python-use-python-script-into-hive-example.html/
