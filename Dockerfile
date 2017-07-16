# This is sca ci slave doxygen image.
# TODO: check https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run

FROM btowerlabz/docker-sca-ci-slave
MAINTAINER BTower Labz <labz@btower.net>

ARG LABELS=/home/jenkins/swarm-labels.cfg

#Install additional software
USER root
RUN apt-get update && apt-get install -y apt-utils

#Install basic tools
RUN apt-get update && apt-get install -y curl git unzip lsof nano
RUN apt-cache search dia

#Install doxygen environment
RUN apt-get update && apt-get install -y doxygen
RUN apt-get update && apt-get install -y graphviz graphviz-doc
RUN apt-get update && apt-get install -y mscgen
RUN apt-get update && apt-get install -y dia dia-shapes dia2code

USER jenkins
RUN printf " doxygen" >>${LABELS}

RUN uname -a
RUN cat /etc/issue
RUN cat ${LABELS}
