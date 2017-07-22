FROM centos:7
ENV container docker
RUN yum -y update && yum -y upgrade && yum -y install wget curl git  gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel wxBase.x86_64 curl 
RUN yum -y install epel-release 
RUN yum -y install erlang
RUN wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
RUN rpm -Uvh erlang-solutions-1.0-1.noarch.rpm 
RUN cd /opt && wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_20.0-1~centos~6_amd64.rpm
RUN cd /opt && rpm -Uvh --replacefiles esl-erlang_20.0-1~centos~6_amd64.rpm
RUN cd /opt && git init && git clone "https://github.com/Antibiotic/websocket_chat" && git clone https://github.com/erlang/rebar3.git && cd rebar3 && ./bootstrap && ./rebar3 local install
RUN echo "export PATH=$PATH:~/.cache/rebar3/bin" >> ~/.bashrc && cp ~/.cache/rebar3/bin/rebar3 /usr/bin/
RUN cd /opt/websocket_chat && make compile
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
EXPOSE 8080
WORKDIR /opt/websocket_chat/
ENTRYPOINT make start
CMD ["/usr/sbin/init"]


