# Container image that runs your code
ARG base_image
ARG tag
FROM ${base_image}:${tag}

ARG rosdistro
ARG repos_file
ARG test_command
ARG check_result_command

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN mkdir -p /artifacts
RUN mkdir -p /colcon_ws/src
WORKDIR /colcon_ws
RUN apt-get update && apt-get install -y wget nodejs npm
RUN npm install -g n
RUN n v14.15.0
RUN apt-get purge -y nodejs npm
COPY ${repos_file} packages.repos
RUN vcs import src < packages.repos
RUN source /opt/ros/${rosdistro}/setup.bash && rosdep install -iry --from-paths src --rosdistro ${rosdistro}
RUN source /opt/ros/${rosdistro}/setup.bash && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

COPY upload_artifact/ /upload_artifact/

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY upload_artifact/ /upload_artifact/

RUN ["chmod", "+x", "/entrypoint.sh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["sh", "/entrypoint.sh"]
