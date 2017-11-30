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
    build-essential \
    cmake \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    mercurial \
    python-dev \
    python-numpy \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libjasper-dev \
    libdc1394-22-dev \
    subversion && \
    apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* 

# https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/Dockerfile
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-${ANACONDA3_VERSION}-Linux-x86_64.sh -O ~/anaconda.sh && \
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
RUN conda install --yes -c anaconda tensorflow-gpu

# Install pytorch
# http://pytorch.org/
# RUN conda install pytorch torchvision -c soumith
RUN conda install --quiet --yes pytorch torchvision cuda80  -c soumith

# Install Keras
RUN pip --no-cache-dir install git+git://github.com/fchollet/keras.git@${KERAS_VERSION}

# Install tangent
# https://github.com/google/tangent
RUN pip install tangent

# Install OpenCV
# https://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html
RUN git clone --depth 1 https://github.com/opencv/opencv.git /root/opencv && \
	cd /root/opencv && \
	mkdir build && \
	cd build && \
	cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON .. && \
	make -j"$(nproc)"  && \
	make install && \
	ldconfig && \
	echo 'ln /dev/null /dev/raw1394' >> ~/.bashrc

# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /root/

# Expose Ports for TensorBoard (6006), Ipython (8888)
EXPOSE 6006 8888

WORKDIR "/root/shareDir"

ENTRYPOINT [ "/usr/bin/tini", "--" ]

CMD [ "/bin/bash" ]
