FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y install vim less
RUN apt-get -y install make gcc lib32z1 python cython sudo
RUN apt-get -y install socat
