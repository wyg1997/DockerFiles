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
- [x] pyenv & python3.11

### Build

```sh
# CUDA
docker build --build-arg USER_UID=$(id -u) -t cuda112:1.0 -f ./Dockerfile-cuda112 .
docker build --build-arg USER_UID=$(id -u) -t cuda123:1.0 -f ./Dockerfile-cuda123 .

# ASCEND
docker build -t ascend_dev:1.0 -f ./Dockerfile-ascend .
```

如果到`apt-get update`卡住，可能是网络问题，可以使用host模式构建:

```sh
docker build --build-arg USER_UID=$(id -u) --network host -t cuda112:1.0 -f ./Dockerfile-cuda112 .
docker build --build-arg USER_UID=$(id -u) --network host -t cuda123:1.0 -f ./Dockerfile-cuda123 .
```

### Run

#### CUDA

```sh
docker run -it --shm-size=8G -P --privileged --runtime=nvidia -u $(id -u) --name "NAME" -v PATH_LOCAL:/home/ubuntu/PATH_DOCKER DOCKER_IMAGE /bin/zsh
```

#### ASCEND

```sh
docker run -it -u root --net=host --shm-size=16g \
    -P \
    --name "NAME" \
    --privileged=true \
    --device /dev/davinci_manager \
    --device /dev/hisi_hdc \
    --device /dev/devmm_svm \
    -v /usr/local/Ascend/driver:/usr/local/Ascend/driver \
    -v /usr/local/dcmi:/usr/local/dcmi \
    -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
    -v /var/queue_schedule:/var/queue_schedule \
    -v /:/system_root \
    ascend_dev:1.0 \
    /bin/zsh
```
