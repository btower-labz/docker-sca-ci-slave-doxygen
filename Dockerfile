# Jenkins doxygen slave image for SCA project.
# TODO: check https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
# TODO: add dot and other graphics

FROM openjdk:8-jdk

MAINTAINER BTower Labz <labz@btower.net>

ENV HOME /home/jenkins
ENV SWARM_DESCRIPTION "Doxygen swarm agent"

RUN groupadd -g 10000 jenkins
RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins
LABEL Description="Provides Jenkins agent (slave.jar). Provides Jenkins swarm (swarm.jar). Provides doxygen tool." Vendor="BTower" Version="1.0"

ARG AGENT_VERSION=3.7
ARG SWARM_VERSION=3.3
ARG JAR_PATH=/usr/share/jenkins

USER root
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get update && apt-get install -y curl git unzip lsof nano wget curl
RUN uname -a
RUN cat /etc/issue
# Install doxygen
RUN apt-get update && apt-get install -y doxygen

# Install agent
RUN curl --create-dirs -sSLo ${JAR_PATH}/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${AGENT_VERSION}/remoting-${AGENT_VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

# Install swarm
RUN curl --create-dirs -sSLo ${JAR_PATH}/swarm.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/swarm.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave
COPY jenkins-swarm /usr/local/bin/jenkins-swarm

# Set labels
COPY swarm-labels.cfg /home/jenkins/swarm-labels.cfg
RUN chown jenkins:jenkins /home/jenkins/swarm-labels.cfg

USER jenkins
RUN mkdir /home/jenkins/.jenkins
VOLUME /home/jenkins/.jenkins
WORKDIR /home/jenkins

# RUN php --version
#RUN mkdir -p /home/jenkins/swarm
#RUN cd /home/jenkins/swarm && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4-javadoc.jar
#RUN cd /home/jenkins/swarm && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4.jar
#RUN cd /home/jenkins/swarm && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4.pom
#RUN cd /home/jenkins/swarm && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4-javadoc.jar.md5
#RUN cd /home/jenkins/swarm && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4-sources.jar.md5
#RUN cd /home/jenkins/swarm && wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4.pom.md5

ENTRYPOINT ["jenkins-swarm"]
