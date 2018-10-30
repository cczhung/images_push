# Mirror Image
将国内拉取不了的镜像，用`海外服务器`进行拉取，然后推送到国内的`私有镜像仓库`，部署时从`私有镜像仓库`拉取下来即可。
## 解决方案

<div align=center>
<img src="http://ww2.sinaimg.cn/large/a15b4afegw1fao00f12w7j20kn0b1wep.jpg" width="400px" />
</div>

我们将需拉取的镜像列表录入到一个或多个`镜像列表文件`中，并将文件路径传入本项目`pull_public_registry.sh`脚本运行，就可开始拉取镜像，镜像拉取完成后，脚本自动修改镜像的`tag`，并推送到国内`私有镜像仓库`，解决了拉取不了镜像的问题；`需镜像主机`，使用同一`镜像列表文件`，将文件路径传入本项目`pull_private_registry.sh`脚本运行，即可从国内`私有镜像仓库`中拉取镜像，脚本将自动修改回镜像原本的`tag`。

## 必要条件
* 拉取镜像的服务器网络没有被和谐。
* 已安装Docker的Linux系统。Ubuntu 14.04+,CentOS 7.X经过测试可用。

## 下载项目
* 在`gitlab`上`clone`项目至本地。

 ```
 git clone http://rdc.hand-china.com/gitlab/rdc_hip/mirror-image.git
 ```

## 项目使用
* 本项目脚本使用时需`镜像列表文件`的`路径`作为参数传入。
  * 将`镜像路径`和需推向的`目的仓库地址/项目名称`成对录入到一个或多个`镜像列表文件`中，该`镜像列表文件`具体录入格式请移步：[镜像列表文件格式](./data/README.md)。

### 拉取海外镜像
* 登录私有镜像仓库。
  * 以`私有镜像仓库`为`registry.saas.hand-china.com`的仓库为例。

```
sudo docker login registry.saas.hand-china.com
# 然后按照系统提示输入用户名和密码登录
```

* 运行脚本拉取镜像。

```
# 事例以本项目中data文件夹中的[镜像列表文件]为例进行镜像拉取。
# 一个[镜像列表文件]拉取镜像。
./pull_public_registry.sh ./data/imageList.part1.txt
# 多个[镜像列表文件]拉取镜像。
./pull_public_registry.sh ./data/imageList.part1.txt ./data/imageList.part2.txt
```

### 部署镜像到本地

* 运行脚本部署镜像。

```
# 事例以本项目中data文件夹中的[镜像列表文件]为例进行镜像拉取。
# 一个[镜像列表文件]拉取镜像。
./pull_private_registry.sh ./data/imageList.part1.txt
# 多个[镜像列表文件]拉取镜像。
./pull_private_registry.sh ./data/imageList.part1.txt ./data/imageList.part2.txt
```

### 运行异常处理
* 项目生成`not_pull_images.txt`文件时，表示拉取镜像时出错，文件内容为未拉取的镜像列表，请排查以下情况后（包括但不限于），以该文件做为`镜像列表文件`传入脚本运行即可：
  - 1.网络是否畅通。
  - 2.`镜像列表文件`格式是否正确。
  - 3.`镜像列表文件`中`镜像地址`是否填写正确。
* 项目生成`not_push_images.txt`文件时，表示推送镜像时出错，文件内容为未推送的镜像列表，请排查以下情况后（包括但不限于），以该文件做为`镜像列表文件`传入脚本运行即可：
  - 1.网络是否畅通。
  - 2.是否登录`私有镜像仓库`。
  - 3.`镜像列表文件`格式是否正确。
  - 4.查看image是否存在：`sudo docker images`。
  - 5.`私有镜像仓库`中是否创建有要推送到的`项目名称`。
  - 6.`镜像列表文件`中`目的仓库地址/项目名称`是否填写正确。

### 报错的解决方法
* shell /bin/bash\^M: bad interpreter:No such file or directory
* '\r': command not found

```
# 查看脚本格式，这里以pull_public_registry.sh脚本为例。
vi pull_public_registry.sh
:set ff
# 若显示set fileformat=doc则执行以下代码，修改格式为unix。
:set fileformat=unix
:wq
```