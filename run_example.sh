#!/usr/bin/env bash
# This example command to create a Docker container
# For reference only, may not be a valid command
# autuanliu@163.com

docker container run -it --rm -p 8888:8888 -v /home/autuanliu/work/sharef:/home/autuanliu/sharef autuanliu/ml-docker-env-cpu:latest

# nvidia-docker run -it --rm -p 8888:8888 -p 6006:6006 -v /home/autuanliu/work/sharef:/home/autuanliu/sharef autuanliu/ml-docker-env-gpu:latest
# docker container run -it --rm -p 8888:8888 -v /home/autuanliu/work/sharef:/home/autuanliu/sharef registry.cn-hangzhou.aliyuncs.com/autuanliu/ml-env-cpu:latest