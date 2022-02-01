#!/bin/sh -l

BASE_IMAGE=$1
TAG=$2
ROSDISTRO=$3
TEST_COMMAND=$4
CHECK_RESULT_COMMAND=$5
ARTIFACTS_NAME=$6
REPOS_ARTIFACTS_NAME=$7
REPOS_FILENAME=$8
COLCON_ARGS=$9
LCOV_ARTIFACTS_NAME="${10}"
WITH_LCOV="${11}"

set -e

cd /runtime_image

touch entrypoint.sh
echo "#!/bin/bash -l" >> entrypoint.sh
echo "#!/set -e" >> entrypoint.sh
echo "ACTIONS_RUNTIME_TOKEN=$ACTIONS_RUNTIME_TOKEN" >> entrypoint.sh
echo "export ACTIONS_RUNTIME_TOKEN" >> entrypoint.sh
echo "ACTIONS_RUNTIME_URL=$ACTIONS_RUNTIME_URL" >> entrypoint.sh
echo "export ACTIONS_RUNTIME_URL" >> entrypoint.sh
echo "GITHUB_RUN_ID=$GITHUB_RUN_ID" >> entrypoint.sh
echo "export GITHUB_RUN_ID" >> entrypoint.sh
echo "cd /artifact_controller" >> entrypoint.sh
echo "npm install" >> entrypoint.sh
echo "npm run download $REPOS_ARTIFACTS_NAME" >> entrypoint.sh
echo "cd /" >> entrypoint.sh
echo "find $REPOS_FILENAME" >> entrypoint.sh
echo "cd /colcon_ws" >> entrypoint.sh
echo "vcs import src < /$REPOS_FILENAME" >> entrypoint.sh
echo "source /opt/ros/$ROSDISTRO/setup.bash && rosdep update && rosdep install -iry --from-paths src --rosdistro $ROSDISTRO" >> entrypoint.sh
echo "source /opt/ros/$ROSDISTRO/setup.bash && colcon build $COLCON_ARGS" >> entrypoint.sh

if [ $WITH_LCOV = "true" ]; then
    echo "lcov --config-file .lcovrc --base-directory /colcon_ws --capture --directory build -o lcov.base --initial" >> entrypoint.sh
fi

echo "source /opt/ros/$ROSDISTRO/setup.bash && source /colcon_ws/install/local_setup.bash && $TEST_COMMAND > /artifacts/test_command_output.txt" >> entrypoint.sh
echo "source /opt/ros/$ROSDISTRO/setup.bash && source /colcon_ws/install/local_setup.bash && $CHECK_RESULT_COMMAND > /artifacts/check_result_command.txt" >> entrypoint.sh

if [ $WITH_LCOV = "true" ]; then
    echo "lcov --config-file .lcovrc --base-directory /colcon_ws --capture --directory build -o lcov.test" >> entrypoint.sh
    echo "lcov --config-file .lcovrc -a lcov.base -a lcov.test -o lcov.total" >> entrypoint.sh
    echo "lcov --config-file .lcovrc -r lcov.total '*/build/*' '*/install/*' '*/test/*' '*/CMakeCCompilerId.c' '*/CMakeCXXCompilerId.cpp' '*_msgs/*' -o lcov.total.filtered" >> entrypoint.sh
    echo "mv /colcon_ws/lcov.total.filtered /lcov" >> entrypoint.sh
fi

echo "cd /artifact_controller" >> entrypoint.sh
echo "npm run upload $ARTIFACTS_NAME /artifacts" >> entrypoint.sh

if [ $WITH_LCOV = "true" ]; then
    echo "npm run upload $LCOV_ARTIFACTS_NAME /lcov" >> entrypoint.sh
fi

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t runtime_image \
    --build-arg base_image="$BASE_IMAGE" \
    --build-arg tag="$TAG" \
    --build-arg github_clone_token="$GITHUB_CLONE_TOKEN" \
    . \
    && docker run runtime_image
