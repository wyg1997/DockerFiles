ARG TSINGHUA_PUB_KEY1="3B4FE6ACC0B21F32"
ARG TSINGHUA_PUB_KEY2="871920D1991BC93C"
ARG CONDA_VERSION="4.10.3"

FROM continuumio/miniconda3:${CONDA_VERSION}

# use tsinghua resource to speed up
COPY sources.list /etc/apt/
RUN apt-get -o Acquire::AllowInsecureRepositories=true \
        -o Acquire::AllowDowngradeToInsecureRepositories=true \
        update \
    && apt-get install -y --allow-unauthenticated gnupg2 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv ${TSINGHUA_PUB_KEY1} \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv ${TSINGHUA_PUB_KEY2} \
    && apt-get install -y --allow-unauthenticated sudo build-essential \
                libreadline-dev libsqlite3-dev libpng-dev \
                libfreetype6-dev liblzma-dev  openssh-server \
                locales busybox software-properties-common

# skip select geographic area
ENV DEBIAN_FRONTEND=noninteractive

# create user "ubuntu"
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN echo $USER_UID \
    && groupadd --gid $USER_GID $USERNAME \
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

# set user "ubuntu"
USER ubuntu
WORKDIR /home/ubuntu
COPY oneflow-dev.yml /tmp/
RUN sudo chown -R ubuntu:ubuntu /tmp \
    && sudo chown -R ubuntu:ubuntu /opt/conda \
    && conda init bash \
    && conda env create -f=/tmp/oneflow-dev.yml \
    && echo "conda activate oneflow-dev" >> ~/.bashrc 

# sshd && SSH login fix. Otherwise user is kicked off after login
RUN sudo mkdir -p /var/run/sshd \
    && sudo sed \
        's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' \
        -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" | sudo tee -a /etc/profile 
CMD ["/usr/sbin/sshd", "-D"]

# remove temp files
RUN sudo rm -rf /tmp/* \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# open port
EXPOSE 22 8888 8887 8886

