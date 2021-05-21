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
docker build -t cuda102:1.1 -f ./Dockerfile-cuda102 .
```

如果到`apt-get update`卡住，可能是网络问题，可以使用host模式构建:

```sh
docker build --network host -t cuda102:1.1 -f ./Dockerfile-cuda102 .
```

### Run

```sh
docker run -it --shm-size=8G -P --cap-add=SYS_PTRACE --runtime=nvidia -u YOUR_UID --name "NAME" -v PATH_LOCAL:PATH_DOCKER cuda102:1.1 /bin/zsh
```
