#!/bin/sh -l

BASE_IMAGE=$1
TAG=$2
ROSDISTRO=$3
TEST_COMMAND=$4
CHECK_RESULT_COMMAND=$5
ARTIFACTS_NAME=$6
REPOS_ARTIFACTS_NAME=$7

cd /runtime_image

cp /packages.repos .

touch entrypoint.sh
echo "#!/bin/sh -l" >> entrypoint.sh
echo "ACTIONS_RUNTIME_TOKEN=$ACTIONS_RUNTIME_TOKEN" >> entrypoint.sh
echo "export ACTIONS_RUNTIME_TOKEN" >> entrypoint.sh
echo "ACTIONS_RUNTIME_URL=$ACTIONS_RUNTIME_URL" >> entrypoint.sh
echo "export ACTIONS_RUNTIME_URL" >> entrypoint.sh
echo "GITHUB_RUN_ID=$GITHUB_RUN_ID" >> entrypoint.sh
echo "export GITHUB_RUN_ID" >> entrypoint.sh
echo "sh /opt/ros/$ROSDISTRO/setup.sh" >> entrypoint.sh
echo "sh /colcon_ws/install/local_setup.sh" >> entrypoint.sh
echo "$TEST_COMMAND > /artifacts/test_command_output.txt" >> entrypoint.sh
echo "$CHECK_RESULT_COMMAND > /artifacts/check_result_command.txt" >> entrypoint.sh
echo "cd /artifact_controller" >> entrypoint.sh
echo "npm install" >> entrypoint.sh
echo "npm run download $REPOS_ARTIFACTS_NAME" >> entrypoint.sh
echo "vcs import src < /$REPOS_ARTIFACTS_NAME" >> entrypoint.sh
echo "cd /colcon_ws" >> entrypoint.sh
echo "rosdep install -iry --from-paths src --rosdistro $ROSDISTRO" >> entrypoint.sh
echo "colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release" >> entrypoint.sh
echo "npm run upload $ARTIFACTS_NAME" >> entrypoint.sh

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t runtime_image \
    --build-arg base_image="$BASE_IMAGE" \
    --build-arg tag="$TAG" \
    --build-arg github_clone_token="$GITHUB_CLONE_TOKEN" \
    . \
    && docker run runtime_image
