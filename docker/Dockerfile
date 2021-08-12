# This Dockerfile builds the image for a container in which the Makefile can use Grails
# to build the DCmd war in the mounted project directory.  This can be used by a developer
# with Docker (or Docker Desktop), or by Jenkins, to avoid installing Java and Grails,
# and to document and help reproduce the build environment.

FROM alpine:latest as download-grails
ARG GRAILS_VERSION=2.3.8
RUN mkdir /grails
WORKDIR /grails
RUN wget https://github.com/grails/grails-core/releases/download/v$GRAILS_VERSION/grails-$GRAILS_VERSION.zip && \
    unzip grails-$GRAILS_VERSION.zip && \
    rm -rf grails-$GRAILS_VERSION.zip && \
    ln -s grails-$GRAILS_VERSION grails

FROM alpine:latest as download-java-rpm
ARG JAVA_VERSION=7
ARG JAVA_UPDATE=80
ARG JAVA_BUILD=15
ARG JAVA_PATH=3d5a2bb8f8d4428bbe94aed7ec7ae784
RUN mkdir /java-installer
WORKDIR /java-installer
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
         "https://docprod.pvt.hawaii.edu/nexus/repository/raw-private/java/oracle/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.rpm"
        # 'https://www.oracle.com/webapps/redirect/signon?nexturl=https://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.rpm'
#         "https://javadl.oracle.com/webapps/download/GetFile/1.${JAVA_VERSION}.0_${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/linux-i586/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.rpm"
#         https://javadl.oracle.com/webapps/download/GetFile/1.8.0_251-b08/3d5a2bb8f8d4428bbe94aed7ec7ae784/linux-i586/jdk-8u251-linux-x64.rpm
#         https://javadl.oracle.com/webapps/download/GetFile/1.8.0_301-b09/d3c52aa6bfa54d3ca74e617f18309292/linux-i586/jdk-8u301-linux-x64.rpm
#         "https://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/${JAVA_PATH}/jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.rpm"

FROM centos:6.10
# CentOS 6 was EOL on 2020-11-30, so update repos to use the vault
RUN sed -i -e 's!mirrorlist!#mirrorlist!g' /etc/yum.repos.d/CentOS-Base.repo; \
    sed -i -e 's!#baseurl=http://mirror.centos.org/centos/\$releasever!baseurl=https://vault.centos.org/6.10/!g' /etc/yum.repos.d/CentOS-Base.repo; \
    yum clean all
# Dependencies (earlier, to reuse these Docker build caches when changing Grails and JDK)
### git is needed by gradle, jq is needed by the `./bin/wait-for-grid.sh` script
### jq is in the EPEL repository so it has to be done after installing epel-release
RUN yum install -y git epel-release; yum install -y jq; yum clean all
### nc is for manually testing connection ability
RUN yum install -y nc; yum clean all
# grails
RUN mkdir /grails
COPY --from=download-grails /grails /
ENV GRAILS_HOME /grails
ENV PATH $GRAILS_HOME/bin:$PATH

# oracle jdk
COPY --from=download-java-rpm /java-installer /java-installer
RUN yum localinstall -y /java-installer/jdk-*.rpm
ENV JAVA_HOME=/usr/java/latest
## openjdk (has problems resolving dependencies for war)
# RUN yum install -y java-1.7.0-openjdk-devel; yum clean all
# ENV JAVA_HOME=/usr/lib/jvm/java-1.7.0

# Image setup
# ---The DCMD_UID is required because bind mounted source files require the host
#    and container user ids match.
ARG DCMD_UID
RUN useradd --create-home --shell /bin/bash -u ${DCMD_UID} dcmduser
USER dcmduser
RUN mkdir /home/dcmduser/workspace
WORKDIR /home/dcmduser/workspace
ENV GRAILS_OPTS -Xmx1500m \
                -Dmaven.repo.local=/home/dcmduser/workspace/maven-repo
RUN mkdir /home/dcmduser/grails-conf
ENV TZ Pacific/Honolulu
