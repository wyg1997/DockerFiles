MINICONDA_URL=https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh
CONDA_INSTALL_SHELL=`basename ${MINICONDA_URL}`
INSTALL_PATH=~/miniconda3
wget ${MINICONDA_URL} && sh $CONDA_INSTALL_SHELL -b -p $INSTALL_PATH && rm -rf $CONDA_INSTALL_SHELL
PATH=$INSTALL_PATH/bin:$PATH;export PATH
conda init bash
conda env create -f=oneflow-dev.yml && echo "conda activate oneflow-dev" >> ~/.bashrc