# Based on https://github.com/pytorch/pytorch/blob/master/Dockerfile
FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04 

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libboost-all-dev \
         libjpeg-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \     
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install conda-build && \
     /opt/conda/bin/conda create -y --name pytorch-py35 python=3.5.2 numpy pyyaml scipy ipython mkl&& \
     /opt/conda/bin/conda clean -ya 
ENV PATH /opt/conda/envs/pytorch-py35/bin:$PATH
RUN conda install --name pytorch-py35 -c soumith magma-cuda80
RUN conda install pytorch torchvision cuda80 -c soumith

# Install face-alignment package
WORKDIR /workspace
RUN chmod -R a+w /workspace
RUN git clone https://github.com/1adrianb/face-alignment
WORKDIR /workspace/face-alignment
RUN pip install -r requirements.txt
RUN python setup.py install
