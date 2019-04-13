近期出来一个wildfly 8.2 死锁的问题。记录一下

表现：
> 程序更新后，wildfly可以调用。但过一块，就无响应了。再重启，可以接收几个请求，又死掉。

处理过程：
> 1. 使用jstack dump出wildfly内线程信息。
     jstack -F $pid > $pid.txt
> 2. 查看 $pid.txt 文件。搜索 deadlock. 然后找到deadlock所在的位置，看到死锁在日志输出的地方。
> 3. 根据错误信息搜索答案。找到：http://stackoverflow.com/questions/31750844/wildfly-8-2-x-hangs-after-redeployment-and-gets-unreponsive/31783658#31783658

原因：
wildfly 8.1, 8.2 中的一个bug. 使用log4j时，会触发。
参见：http://stackoverflow.com/questions/31750844/wildfly-8-2-x-hangs-after-redeployment-and-gets-unreponsive/31783658#31783658


解决方法：
方法1. 工程中增加一个文件 `jboss-deployment-structure.xml` 
内容
        <jboss-deployment-structure>
          <deployment>
             <!-- exclude-subsystem prevents a subsystems deployment unit processors running on a deployment -->
             <!-- which gives basically the same effect as removing the subsystem, but it only affects single deployment -->
             <exclude-subsystems>
                <subsystem name="logging" />
            </exclude-subsystems>
          </deployment>
        </jboss-deployment-structure>

方法2.升级 log4j-jboss-logmanager， 版本升到 1.1.2.Final 。

我采用的方法2.
