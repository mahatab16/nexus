FROM centos:7
MAINTAINER Mahatab Mallick "mahatab16@gmail.com"

ARG VERSION=3.14.0-04
ARG USER=nexus

RUN yum install -y vim \
        wget

#Install JDK8
RUN yum install -y java-1.8.0-openjdk.x86_64

#Create nexus user and app directory
RUN useradd ${USER} -d /home/nexus
RUN mkdir -p /app && mkdir /nexus-data

#Download and extract target nexus verstion
RUN cd /tmp && wget https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-${VERSION}-unix.tar.gz
RUN tar -xvzf /tmp/nexus-${VERSION}-unix.tar.gz -C /app
RUN mv /app/nexus-${VERSION} /app/nexus

#Change config files
COPY files/nexus.vmoptions /app/nexus/bin
COPY files/nexus.rc /app/nexus/bin

RUN chown -R ${USER}:${USER} /app/nexus && chown -R ${USER}:${USER} /nexus-data

#Create startup script
RUN ln -s /app/nexus/bin/nexus /nexus-startup.sh
COPY files/startup.sh /nexus-startup.sh

#RUN cd /etc/init.d && chkconfig --add nexus && chkconfig --levels 345 nexus on


EXPOSE 8081

CMD ["/nexus-startup.sh"]


