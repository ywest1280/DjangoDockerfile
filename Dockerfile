FROM ubuntu:18.04
MAINTAINER ywest1280@gmail.com

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl tmux neofetch vim git
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN /bin/bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda
RUN conda install -c anaconda -y python=3.9
RUN conda install -c anaconda -y \
    pip \
    Django
RUN mkdir /root/eenter_project
#RUN cd /root/eenter_project
RUN django-admin startproject config /root/eenter_project
RUN sed -i 's/ALLOWED_HOSTS \= \[\]/ALLOWED_HOSTS \= \[ '\''www\.eenter\.co\.kr'\'' \, '\''localhost'\'' \]/g' /root/eenter_project/config/settings.py
RUN echo "python manage.py runserver 0.0.0.0:8000" > /root/eenter_project/startDjangoServer.sh
RUN chmod u+x /root/eenter_project/startDjangoServer.sh
CMD [ "/bin/bash" ]
WORKDIR "/root/eenter_project"
