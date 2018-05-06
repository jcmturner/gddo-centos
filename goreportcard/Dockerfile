FROM centos:latest

RUN yum install -y wget git

ENV GOLANG_VERSION 1.10.2
RUN wget -O go.tar.gz https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz && tar -C /usr/local -xzf go.tar.gz && rm -f go.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH



RUN go get -u gopkg.in/alecthomas/gometalinter.v2 && mv "$GOPATH/bin/gometalinter.v2" "$GOPATH/bin/gometalinter" && \
  gometalinter --install && \
  go get -u github.com/gojp/goreportcard

WORKDIR $GOPATH/src/github.com/gojp/goreportcard
EXPOSE 8000
CMD goreportcard
