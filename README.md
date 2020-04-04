# 使用方法
~/.bashrc 中添加如下内容, 这个 source 指令会引入两个函数： kube PS1: kube_symbol kube_ctx

```
source /path/kctx/kctx-source.sh
```

在 PS1 使用这两个函数即可：
```
PS1='$(kube_symbol)$(kube_ctx) # '
```
