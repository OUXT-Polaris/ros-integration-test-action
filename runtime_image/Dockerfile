# Container image that runs your code
ARG base_image
ARG tag
ARG rosdistro
ARG repos_file
FROM ${base_image}:${tag}

RUN mkdir -p /colcon_ws/src
WORKDIR /colcon_ws
COPY ${repos_file} /colcon_ws
RUN vcs import src < ${repos_file}
RUN source /opt/ros/${rosdistro}/setup.sh && rosdep install -iry --from-paths src --rosdistro ${rosdistro}

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["sh", "/entrypoint.sh"]
