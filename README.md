# DockerFile for OneFlow-Developing Image

### Build

```sh
docker build --build-arg USER_UID=$(id -u) -t oneflow-dev:0.1 -f ./Dockerfile .
```

如果到`apt-get update`卡住，可能是网络问题，可以使用host模式构建:

```sh
docker build --build-arg USER_UID=$(id -u) --network host -t oneflow-dev:0.1 -f ./Dockerfile .
```

### Run

```sh
docker run -it --shm-size=8G -P --privileged --runtime=nvidia -u YOUR_UID --name "NAME" -v PATH_LOCAL:PATH_DOCKER oneflow-dev:0.1 /bin/bash
```
