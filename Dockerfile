FROM alpine:3.6

MAINTAINER Cheyne Wallace

ARG DEF_REMOTE_PORT=80
ARG DEF_LOCAL_PORT=80

ENV REMOTE_PORT=$DEF_REMOTE_PORT
ENV LOCAL_PORT=$DEF_LOCAL_PORT

RUN echo "Installing base packages" \
    && apk add --update --no-cache \
    socat ca-certificates \
    && echo "Removing apk cache" \
    && rm -rf /var/cache/apk/

CMD socat tcp-listen:$LOCAL_PORT,reuseaddr,fork tcp:$REMOTE_HOST:$REMOTE_PORT & pid=$! && trap "kill $pid" SIGINT && \
    echo "Socat started listening on $LOCAL_PORT: Redirecting traffic to $REMOTE_HOST:$REMOTE_PORT ($pid)" && wait $pid