FROM alpine:edge

RUN mkdir /go
ENV GOPATH /go
ENV GOBIN /go/bin
VOLUME /etc/telegraf
ENV TELEGRAF github.com/influxdata/telegraf
WORKDIR $GOPATH/src/$TELEGRAF/
#RUN go get github.com/influxdata/telegraf
COPY . $GOPATH/src/$TELEGRAF/
RUN set -ex && \
	  apk add --no-cache --virtual .build-deps \
		git \
		go \
		build-base && \
		go get github.com/sparrc/gdm && \
		/go/bin/gdm restore && \
    go install cmd/telegraf/telegraf.go && \
    apk del .build-deps && \
	  rm -rf $GOPATH/pkg && \
	  rm -rf $GOPATH/src && \
	  rm -rf /usr && \
	  rm -rf $GOPATH/bin/gdm

CMD /go/bin/telegraf
