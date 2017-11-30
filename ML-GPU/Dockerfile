FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

LABEL maintainer="autuanliu <autuanliu@163.com>"

USER root

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ARG KERAS_VERSION=1.2.0
ARG ANACONDA3_VERSION=5.0.1

RUN apt-get update --fix-missing && \
    apt-get install -y --fix-missing \
    curl \
    grep \
    sed \
    wget \ 
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git \
    dpkg \
    mercurial \
    subversion && \
    apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* 

# https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/Dockerfile
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget -nv https://repo.continuum.io/archive/Anaconda3-${ANACONDA3_VERSION}-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

# Install Tini
# https://github.com/krallin/tini
RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH

# Install TensorFlow
# https://anaconda.org/anaconda/tensorflow-gpu
RUN conda install -q -y -c anaconda tensorflow-gpu

# Install pytorch
# http://pytorch.org/
# RUN conda install pytorch torchvision -c soumith
RUN conda install -q -y pytorch torchvision cuda80  -c soumith

# Install Keras
RUN pip --no-cache-dir install git+git://github.com/fchollet/keras.git@${KERAS_VERSION}

# Install tangent
# https://github.com/google/tangent
RUN pip install -q tangent

# R packages including IRKernel which gets installed globally.
RUN conda config --system --append channels r && \
    conda install -q -y \
    'rpy2=2.8*' \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-dplyr=0.5*' \
    'r-forecast=6.2*' \
    'r-ggplot2=2.2*' \
    'r-matrix=1.2*' \
    'r-devtools=1.12*' \
    'r-tidyverse=1.0*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-forecast=7.3*' \
    'r-rsqlite=1.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' && \
    conda clean -tipsy
    
# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /root/

# Expose Ports for TensorBoard (6006), Ipython (8888)
EXPOSE 6006 8888

WORKDIR "/root/shareDir"

ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/bin/bash" ]
