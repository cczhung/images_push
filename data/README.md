# Image List
我们约定`镜像列表`和需推送的`目的仓库地址/项目名称`要成对录入，录入格式：`镜像地址`后跟`目的仓库地址/项目名称`，具体书写方式如下所示：
## 录入格式
* 我们用以下镜像需推送到`目的仓库地址`为：`registry.saas.hand-china.com`,项目名为：`google_containers`的仓库为例。

```
gcr.io/google_containers/kubernetes-dashboard-amd64
gcr.io/google_containers/kube-discovery-amd64
gcr.io/google_containers/kube-dnsmasq-amd64
```

### 以`换行符`成对书写
```
gcr.io/google_containers/kubernetes-dashboard-amd64
registry.saas.hand-china.com/google_containers
gcr.io/google_containers/kube-discovery-amd64
registry.saas.hand-china.com/google_containers
gcr.io/google_containers/kube-dnsmasq-amd64
registry.saas.hand-china.com/google_containers
```
### 以`空格符`成对书写
```
gcr.io/google_containers/kubernetes-dashboard-amd64 registry.saas.hand-china.com/google_containers
gcr.io/google_containers/kube-discovery-amd64 registry.saas.hand-china.com/google_containers
gcr.io/google_containers/kube-dnsmasq-amd64 registry.saas.hand-china.com/google_containers
```
### 以`制表符`成对书写
```
gcr.io/google_containers/kubernetes-dashboard-amd64 registry.saas.hand-china.com/google_containers
gcr.io/google_containers/kube-discovery-amd64   registry.saas.hand-china.com/google_containers
gcr.io/google_containers/kube-dnsmasq-amd64 registry.saas.hand-china.com/google_containers
```