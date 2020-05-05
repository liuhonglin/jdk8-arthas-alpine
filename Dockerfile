FROM jeanblanchard/alpine-glibc:latest
MAINTAINER liuhonglin

ADD locale-archive /usr/glibc-compat/lib/locale/

#更新Alpine的软件源为国内（清华大学）的站点，因为从默认官源拉取实在太慢了。。。
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories \
    && echo "http://mirrors.aliyun.com/alpine/v3.8/main/" >> /etc/apk/repositories \
    && echo "http://mirrors.aliyun.com/alpine/v3.8/community/" >> /etc/apk/repositories

RUN apk update \
        && apk upgrade \
        && apk add --no-cache bash \
        bash-doc \
        bash-completion \
        curl \
        wget \
        vim \
        busybox-extras \
        && rm -rf /var/cache/apk/*

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

ADD jdk1.8.0_241.tar.gz /usr/local/jdk/
# copy arthas
#COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
ADD arthas-3.2.0.tar.gz /

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV JAVA_HOME /usr/local/jdk
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:$JAVA_HOME/bin
