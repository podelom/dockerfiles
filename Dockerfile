FROM centos:7
ENV ip 95.213.236.70
RUN yum -y update && yum -y upgrade && yum -y install wget curl git  gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel wxBase.x86_64 curl net-tools 
RUN yum -y install epel-release && yum -y install erlang
RUN wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm && rpm -Uvh erlang-solutions-1.0-1.noarch.rpm 
WORKDIR /opt
RUN wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_20.0-1~centos~6_amd64.rpm && rpm -Uvh --replacefiles esl-erlang_20.0-1~centos~6_amd64.rpm
RUN git init && git clone "https://github.com/Antibiotic/websocket_chat" && git clone https://github.com/erlang/rebar3.git && cd rebar3 && ./bootstrap && ./rebar3 local install
RUN echo "export PATH=$PATH:~/.cache/rebar3/bin" >> ~/.bashrc && cp ~/.cache/rebar3/bin/rebar3 /usr/bin/
WORKDIR /opt/websocker_chat
RUN sed -i 's/localhost/${ip}/g' priv/www/index.js
RUN make compile
VOLUME [ "/sys/fs/cgroup" ]
EXPOSE 8080
WORKDIR /opt/websocket_chat/
ENTRYPOINT make start
CMD ["/usr/sbin/init"]
