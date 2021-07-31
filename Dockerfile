FROM alpine:latest
RUN apk add --no-cache nodejs
WORKDIR /nodejs_ws
RUN npm install @actions/github

WORKDIR /
RUN mkdir -p /artifacts

COPY runtime_image /runtime_image
COPY entrypoint.sh /entrypoint.sh
COPY upload_artifact.js upload_artifact.js

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["sh", "/entrypoint.sh"]