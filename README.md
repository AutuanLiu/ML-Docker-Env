## machine learning Docker environment

[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg?style=plastic)](https://hub.docker.com/u/autuanliu/)
[![Ubuntu version](https://img.shields.io/badge/Ubuntu-16.04-green.svg?style=plastic)]()

This is a Docker configure for machine learning and deep learning. You can use the Dockerfile to build Docker image locally or 
pull the image I have create from [Docker Hub](https://hub.docker.com/r/autuanliu/)

1. [CPU Version](https://hub.docker.com/r/autuanliu/ml-docker-env-cpu/)
2. [GPU Version](https://hub.docker.com/r/autuanliu/ml-docker-env-gpu/)

### Pull the image
1. from the Docker hub
    * CPU-Version

        `docker pull autuanliu/ml-docker-env-cpu`

    * GPU-Version

        `docker pull autuanliu/ml-docker-env-gpu`

2. from the Aliyun
    * CPU-Version
        
        `docker pull registry.cn-hangzhou.aliyuncs.com/autuanliu/ml-env-cpu`

    * GPU-Version
        
        `docker pull registry.cn-hangzhou.aliyuncs.com/autuanliu/ml-env-gpu`

for more information about Docker, you can visit the website: [Docker - Build, Ship, and Run Any App, Anywhere](https://www.docker.com/)

### what you can get
when you create a container with the docker image, you can get:

* Ubuntu 16.04
* nano
* tmux
* Tensorflow 
* Pytorch
* Keras
* Anaconda
* jupyter notebook
* numpy
* pandas
* matplotlib
* seaborn
* pillow
* Other useful Python libraries

If you want to add new modules of python or other libraries, you can modify the Dockerfile 
directly or submit a issue [here](https://github.com/AutuanLiu/ML-Docker-Env/issues)

### Usage
`
docker run -it --rm -p 8888:8888 -v your_host_work_dir:/home/autuanliu/sharef registry_name/image_name:tag
`

* here is an example 

[![asciicast](https://asciinema.org/a/koioQuPhCpyUKQcvdgQ3dlVjC.png)](https://asciinema.org/a/koioQuPhCpyUKQcvdgQ3dlVjC)

for more detail commands usage, you can visit the website: [Get Started, Part 1: Orientation and setup | Docker Documentation](https://docs.docker.com/get-started/)

### About
These Docker images are used for learning and research related to data science and machine learning. You do not need to configure a complex environment on your computer. You need almost everything are all included in the images. All you need is 'docker pull' and 'docker run'.

[Another repository](https://github.com/AutuanLiu/Machine-Learning-on-docker) are created to submit my learning and research. It is about Machine learning, Neural Network, data science etc. You can run all code or jupyter-notes base on this Docker image.

Hope it works!
---

If you have any questions or suggestions about this reposity, you can submit your issues or email me. [autuanliu@163.com]()