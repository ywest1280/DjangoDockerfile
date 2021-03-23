FROM ubuntu:18.04
MAINTAINER ywest1280@gmail.com

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl tmux neofetch vim git openssh-server
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN /bin/bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda
RUN conda install -c anaconda -y python=3.9
RUN conda install -c anaconda -y \
    pip \
    Django
RUN mkdir /root/eenter_web
COPY --chown=root:root eenter_web /root/eenter_web
#RUN mkdir /root/eenter_project
#RUN django-admin startproject config /root/eenter_project
#ERUN sed -i 's/ALLOWED_HOSTS \= \[\]/ALLOWED_HOSTS \= \[ '\''www\.eenter\.co\.kr'\'' \, '\''localhost'\'' \]/g' /root/eenter_project/config/settings.py
#RUN echo "python manage.py runserver 0.0.0.0:8000" > /root/eenter_project/startDjangoServer.sh
#RUN chmod u+x /root/eenter_project/startDjangoServer.sh
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
COPY --chown=root:root authorized_keys /root/.ssh/
RUN echo "#Start SSH service if bash start">> /root/.bashrc
RUN echo "if [ -f /usr/sbin/sshd ]; then service ssh start; fi" >> /root/.bashrc
RUN echo "#Add miniconda/bin to PATH">> /root/.bashrc
RUN echo "export PATH=/miniconda/bin:$PATH" >> /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]
WORKDIR "/root/eenter_web"
EXPOSE 22
EXPOSE 8000
