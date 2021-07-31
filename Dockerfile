FROM alpine:latest

RUN mkdir -p /artifacts

COPY runtime_image /runtime_image
COPY entrypoint.sh /entrypoint.sh

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["sh", "/entrypoint.sh"]