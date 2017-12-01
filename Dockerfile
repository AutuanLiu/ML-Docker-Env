FROM ubuntu:16.04

LABEL maintainer="autuanliu <autuanliu@163.com>"

USER root

ARG KERAS_VERSION=1.2.0
ARG ANACONDA3_VERSION=5.0.1

RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -y --fix-missing \
    curl \
    grep \
    sed \
    wget \ 
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
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

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install Tini
# https://github.com/krallin/tini
RUN wget -q https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Create autuanliu user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -m -s /bin/bash -N -u 1000 autuanliu && \
    mkdir /home/autuanliu/work && \
    chown autuanliu:100 /home/autuanliu/work

ENV PATH=/opt/conda/bin:$PATH \
    HOME=/home/autuanliu
    
# Install anaconda as autuanliu and check the md5 sum provided on the download site
# https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/Dockerfile
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget -nv https://repo.continuum.io/archive/Anaconda3-${ANACONDA3_VERSION}-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    chown autuanliu:100 /opt/conda

USER autuanliu

RUN chmod 777 /opt/conda && \
    chmod 777 ${HOME}/work

# Install TensorFlow
# https://anaconda.org/conda-forge/tensorflow
RUN conda install -q -y -c conda-forge tensorflow

# Install pytorch
# http://pytorch.org/
# RUN conda install pytorch torchvision -c soumith
RUN conda install -q -y pytorch torchvision -c soumith

# Install Keras
RUN pip --no-cache-dir install git+git://github.com/fchollet/keras.git@${KERAS_VERSION}

# Install opencv
RUN conda install -c menpo opencv3

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

USER root

# Expose Ports for TensorBoard (6006), Ipython (8888)
EXPOSE 6006 8888
WORKDIR $HOME

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD [ "/bin/bash" ]

# Add local files as late as possible to avoid cache busting
COPY jupyter_notebook_config.py /etc/jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh ${HOME}

# Switch back to jovyan to avoid accidental container runs as root
USER autuanliu