# 目的 #
将自己写的shell脚本放到这. 方便复用, 避免重复造轮子.

# 文件列表 #

`deploy_web_from_git.sh` 供`jenkins`调用, 从`GitLab`中下载文件, 发布到`Web`服务器上. 只实现了下载和上传, 不含编译.

`fav.sh` 收藏的`shell`命令

`ssh-copy-id-warpper.tcl` `expect`脚本, 将本地的公钥复制到远程主机. 封装了 `ssh-copy-id`

`ssh-keygen-warpper.tcl`: `expect`脚本, 调用`ssh-keygen` 生成公私钥.

`update_from_git_incr.sh`, 一个小工具. 从`Git`中下载更新. 并将更新通过增量方式上传到远端服务器.

`pssh.sh` 在多台服务器上批量执行命令. p.s. 使用第三方工具：`pssh`会更好

# 闲话 #

提交完 `deploy_web_from_git.sh` 之后, 发现其实可以从`update_from_git_incr.sh`中抽一部分代码重用... 如果将工具集做成一个库, 需要时`import`一下就方便了. 

