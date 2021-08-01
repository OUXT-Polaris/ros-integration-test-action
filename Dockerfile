FROM alpine:latest

WORKDIR /
RUN mkdir -p /artifacts

COPY runtime_image /runtime_image
COPY entrypoint.sh /entrypoint.sh
COPY packages.repos /packages.repos

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["sh", "/entrypoint.sh"]