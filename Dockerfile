FROM centos:7

RUN yum install -y vim \
        wget
RUN yum install -y java-1.8.0-openjdk.x86_64

RUN useradd nexus -d /home/nexus
RUN mkdir -p /app && mkdir /nexus-data

RUN cd /tmp && wget https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.0.2-02-unix.tar.gz
RUN tar -xvzf /tmp/nexus-3.0.2-02-unix.tar.gz -C /app
RUN mv /app/nexus-3.0.2-02 /app/nexus


COPY files/nexus.vmoptions /app/nexus/bin
COPY files/nexus.rc /app/nexus/bin
RUN chown -R nexus:nexus /app/nexus && chown -R nexus:nexus /nexus-data

RUN ln -s /app/nexus/bin/nexus /nexus-startup.sh
COPY files/startup.sh /nexus-startup.sh

#RUN cd /etc/init.d && chkconfig --add nexus && chkconfig --levels 345 nexus on


EXPOSE 8081

CMD ["/nexus-startup.sh"]


