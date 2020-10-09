# DockerFiles

### include

- [x] git
- [x] tmux
- [x] sshd
- [x] vim-plus
- [x] zsh & oh-my-zsh
  - [x] zsh-autosuggestions
  - [x] zsh-syntax-highlighting
  - [x] z
  - [x] extractor
- [x] pyenv & python3.7.4

### Build

```sh
docker build -t cuda10:1.0 -f ./Dockerfile-cuda10 .
```

如果到`apt-get update`卡住，可能是网络问题，可以使用host模式构建:

```sh
docker build --network host -t cuda10:1.0 -f ./Dockerfile-cuda10 .
```

### TODO

- 修改时间：`tzselect`选择地区，`cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime`使时间生效
- 启动ssh服务

