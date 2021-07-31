# Container image that runs your code
ARG base_image
ARG tag
ARG rosdistro
ARG repos_url
FROM ${base_image}:${tag}

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes

RUN mkdir -p /colcon_ws/src
WORKDIR /colcon_ws
RUN apt-get update && apt-get install -y wget
RUN wget ${repos_url}
RUN ls /colcon_ws
RUN cat /colcon_ws/${repos_url}
RUN vcs import src < ${repos_url}
RUN source /opt/ros/${rosdistro}/setup.sh && rosdep install -iry --from-paths src --rosdistro ${rosdistro}

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["sh", "/entrypoint.sh"]
