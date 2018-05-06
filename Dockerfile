FROM centos:latest

# Install redis, nginx, daemontools, etc.
RUN yum install -y epel-release
RUN yum install -y graphviz redis unzip wget git

ENV GOLANG_VERSION 1.10.2
RUN wget -O go.tar.gz https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz && tar -C /usr/local -xzf go.tar.gz && rm -f go.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

# Configure daemontools services.
ADD start.sh /services/
RUN chmod 744 /services/start.sh

# Manually fetch and install gddo-server dependencies (faster than "go get")
ADD https://github.com/garyburd/redigo/archive/779af66db5668074a96f522d9025cb0a5ef50d89.zip /x/redigo.zip
ADD https://github.com/golang/snappy/archive/master.zip /x/snappy-go.zip
RUN unzip /x/redigo.zip -d /x && unzip /x/snappy-go.zip -d /x && \
	mkdir -p /go/src/github.com/garyburd && \
	mkdir -p /go/src/github.com/golang && \
	mv /x/redigo-* /go/src/github.com/garyburd/redigo && \
	mv /x/snappy-master /go/src/github.com/golang/snappy && \
	rm -rf /x

# Build the local gddo files.
RUN go get github.com/golang/gddo/gddo-server
RUN mkdir /etc/redis && cp /go/src/github.com/golang/gddo/deploy/redis.conf /etc/redis/redis.conf

# Exposed ports and volumes.
# /data should contain the Redis database, "dump.rdb".
EXPOSE 8080
VOLUME ["/data"]

# How to start it all.
CMD /services/start.sh
