ARG CUDA="11.1.1"
ARG CUDNN="8"

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu18.04

# use tinghua resource to speed up
COPY sources-ubuntu1804.list /etc/apt/sources.list

# skip select geographic area
ENV DEBIAN_FRONTEND=noninteractive

# install packages
RUN apt-get update \
 && apt-get install -y sudo git zsh curl wget build-essential libbz2-dev \
                       libssl-dev libreadline-dev libsqlite3-dev tk-dev \
                       libpng-dev libfreetype6-dev libffi-dev liblzma-dev \
                       openssh-server locales busybox software-properties-common

# create user
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN echo $USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
   && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
   && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
   && chmod 0440 /etc/sudoers.d/$USERNAME

# set language && time
RUN export LANGUAGE=en_US.UTF-8 \
    && export LANG=en_US.UTF-8 \
    && export LC_ALL=en_US.UTF-8 \
    && sudo locale-gen en_US.UTF-8 \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone

# set user
USER ${USERNAME}
WORKDIR /home/${USERNAME}
RUN sudo chown -R ${USERNAME}:${USERNAME} /tmp

# setup conda
COPY oneflow-dev.yml ./
COPY setup_conda.sh ./
RUN sh setup_conda.sh && rm -rf setup_conda.sh


# sshd
RUN sudo mkdir -p /var/run/sshd
# SSH login fix. Otherwise user is kicked off after login
RUN sudo sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" | sudo tee -a /etc/profile 
CMD ["/usr/sbin/sshd", "-D"]

# remove temp files
RUN sudo rm -rf /tmp/* \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# open port
EXPOSE 22 8888 8887 8886
