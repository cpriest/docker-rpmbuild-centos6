FROM centos:6

MAINTAINER Clint Priest <docker-rpmbuild-centos6@github.rxv.me>

# Yum
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm 2>&1
RUN yum -y update 2>&1
RUN yum -y install rpmdevtools mock rpmlint git wget curl kernel-devel rpmdevtools rpmlint rpm-build sudo gcc-c++ make automake autoconf vim 2>&1
RUN yum -y update 2>&1

# build files
ADD bin/build-spec /bin/
ADD bin/build-all /bin/

# Sudo
ADD etc/sudoers.d/wheel /etc/sudoers.d/
RUN chown root:root /etc/sudoers.d/*

# Remove requiretty from sudoers main file
RUN sed -i '/Defaults    requiretty/c\#Defaults    requiretty' /etc/sudoers

# Rpm User
RUN adduser -G wheel rpmbuilder
ADD .rpmmacros /home/rpmbuilder/
USER rpmbuilder

WORKDIR /home/rpmbuilder
