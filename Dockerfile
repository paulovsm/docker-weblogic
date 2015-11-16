FROM ubuntu:trusty
ADD docker_files/install_jvm.sh /weblogic/install_jvm.sh
ADD docker_files/build_image.sh /weblogic/build_image.sh
ADD docker_files/entrypoint.sh /weblogic/entrypoint.sh
ADD docker_files/myDomain.py /weblogic/myDomain.py
ADD docker_files/blodes_domain.jar /weblogic/blodes_domain.jar
ADD docker_files/wls1213_dev_update3.zip weblogic/wls1213_dev_update3.zip
ADD docker_files/configure.sh  /weblogic/configure.sh  
ADD docker_files/wlst.sh /weblogic/wlst.sh

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/jdk1.8
ENV MW_HOME=/weblogic/wls12130
ENV CONFIG_JVM_ARGS=-Djava.security.egd=file:///dev/urandom:${CONFIG_JVM_ARGS}

VOLUME /weblogic/domains/mydomain
VOLUME /weblogic/wls12130

RUN apt-get update && \
    /weblogic/install_jvm.sh && \
#    /weblogic/build_image.sh && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/*

#ENTRYPOINT /weblogic/entrypoint.sh
ENTRYPOINT bash
