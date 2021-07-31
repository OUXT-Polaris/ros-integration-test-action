FROM node:16-alpine3.14

RUN mkdir -p /artifacts
RUN npm install @actions/github

COPY runtime_image /runtime_image
COPY entrypoint.sh /entrypoint.sh

RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["sh", "/entrypoint.sh"]