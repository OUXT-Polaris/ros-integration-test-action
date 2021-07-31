FROM node:alpine

RUN mkdir -p /artifacts
RUN mkdir -p /nodejs_ws

COPY runtime_image /runtime_image
COPY entrypoint.sh /entrypoint.sh

WORKDIR /nodejs_ws
RUN npm install @actions/github

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["sh", "/entrypoint.sh"]