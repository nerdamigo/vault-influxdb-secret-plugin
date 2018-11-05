FROM golang:alpine AS build

# Copy Modules In
RUN mkdir -p /src

COPY . /src

WORKDIR /src

RUN go build -o /dist/app

FROM alpine AS runtime

RUN apk add --no-cache bash net-tools curl

COPY --from=build /dist/app /app
#COPY ./test/integration/run-tests.sh /run-tests.sh

WORKDIR /

RUN mkdir -p /tmp \
    && cd /tmp \
    && wget https://dl.influxdata.com/influxdb/releases/influxdb-1.6.4-static_linux_amd64.tar.gz \
    && echo downloads done

RUN echo setup influx \
    && tar xvfz /tmp/influxdb-1.6.4-static_linux_amd64.tar.gz -C / \
    && mv `find -name influx* -type d` /influx \
    && echo $'#!/bin/sh\n\
    echo "inside integration container!"\n\
    cat <&0 > run.sh \n\
    chmod +x run.sh \n\
    ./run.sh\n\
    echo "done with integration container!"\n'\
    > entrypoint.sh \
    && chmod +x entrypoint.sh \
    && echo done

ENTRYPOINT [ "/entrypoint.sh"]