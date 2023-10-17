FROM ubuntu:22.04

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak \
    && sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list

ENV TZ=US/Alaska
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get upgrade -y

RUN apt install build-essential make -y
