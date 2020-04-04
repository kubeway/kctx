# 配置方法
~/.bashrc 中添加如下内容, 这个 source 指令会引入两个函数： kube PS1: kube_symbol kube_ctx

```
source /path/kctx/kctx-source.sh
```

在 PS1 使用这两个函数即可：
```
PS1='$(kube_symbol)$(kube_ctx) # '
```

## 使用方法
- 查看 所有的 kubeconfig 文件

  kctx -l

- 选择一个 kubeconfig 文件

  kctx -s xxx-config-xxx

- 查看 ns

kctx -n

- 选择一个 ns

kctx -n xxxns

- 上述设置完成以后执行 kubecl 和 helm(v3) 命令，就会使用前面的 context

  - kubectl get pod
  - helm list
