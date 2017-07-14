# Jenkins doxygen slave image for SCA project.
# TODO: check https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
# TODO: add dot and other graphics

FROM jenkinsci/slave
MAINTAINER BTower Labz <labz@btower.net>

COPY jenkins-slave /usr/local/bin/jenkins-slave

#Install additional software
USER root
RUN apt-get update && apt-get install -y curl git unzip lsof nano apt-utils
RUN uname -a
RUN cat /etc/issue

# Install doxygen
RUN apt-get update && apt-get install -y doxygen

USER jenkins
# RUN php --version

ENTRYPOINT ["jenkins-slave"]
