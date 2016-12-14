FROM base
RUN apt-get -y install nginx
ADD setup /setup
RUN cd setup; bash setup.sh
CMD cd setup; bash run.sh
