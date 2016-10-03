FROM alpine:edge

ENV DOCKERIZE_VERSION 0.2.0
RUN apk add --no-cache ca-certificates curl && \
    mkdir -p /usr/local/bin/ && \
    curl -SL https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz \
    | tar xzC /usr/local/bin
RUN mkdir /go
ENV GOPATH /go
RUN set -ex \
	  && apk add --no-cache --virtual .build-deps \
		git \
		go \
		build-base

ENV TELEGRAF github.com/influxdata/telegraf
RUN go get github.com/influxdata/telegraf
COPY . $GOPATH/src/$TELEGRAF/
COPY ./example.conf /etc/telegraf/telegraf.conf
WORKDIR $GOPATH/src/$TELEGRAF/
RUN make

RUN apk del .build-deps \
	  && rm -rf $GOPATH/pkg \
	  && rm -rf $GOPATH/src/github.com/influxdata

CMD dockerize \
  $GOPATH/bin/telegraf
