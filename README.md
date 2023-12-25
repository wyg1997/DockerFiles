# DockerFiles

### include

- [x] git
- [x] tmux
- [x] sshd
- [ ] neovimplus
- [x] zsh & oh-my-zsh
  - [x] zsh-autosuggestions
  - [x] zsh-syntax-highlighting
  - [x] z
  - [x] extractor
- [x] pyenv & python3.8.5

### Build

```sh
docker build --build-arg USER_UID=$(id -u) -t cuda102:1.2 -f ./Dockerfile-cuda102 .
docker build --build-arg USER_UID=$(id -u) -t cuda112:1.0 -f ./Dockerfile-cuda112 .
```

如果到`apt-get update`卡住，可能是网络问题，可以使用host模式构建:

```sh
docker build --build-arg USER_UID=$(id -u) --network host -t cuda102:1.2 -f ./Dockerfile-cuda102 .
docker build --build-arg USER_UID=$(id -u) --network host -t cuda112:1.0 -f ./Dockerfile-cuda112 .
```

### Run

```sh
docker run -it --shm-size=8G -P --privileged --runtime=nvidia -u $(id -u) --name "NAME" -v PATH_LOCAL:/home/ubuntu/PATH_DOCKER DOCKER_IMAGE /bin/zsh
```
