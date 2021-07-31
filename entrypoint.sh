#!/bin/sh -l

BASE_IMAGE=$1
TAG=$2
ROSDISTRO=$3
REPOS_URL=$4
TEST_COMMAND=$5
CHECK_RESULT_COMMAND=$6

cd /runtime_image

touch entrypoint.sh
echo "#!/bin/sh -l" >> entrypoint.sh
echo "sh /opt/ros/$ROSDISTRO/setup.sh" >> entrypoint.sh
echo "sh /colcon_ws/install/local_setup.sh" >> entrypoint.sh
echo $TEST_COMMAND >> entrypoint.sh
echo $CHECK_RESULT_COMMAND >> entrypoint.sh

echo "Entrypoint of runtime image"
cat entrypoint.sh

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t runtime_image \
    --build-arg base_image="$BASE_IMAGE" \
    --build-arg tag="$TAG" \
    --build-arg rosdistro="$ROSDISTRO" \
    --build-arg repos_url="$REPOS_URL" \
    . \
    && docker run -v /artifacts:/artifacts runtime_image

echo "===== Artifacts ====="
ls /artifacts
echo "===== Artifacts ====="
cd ../upload_artifact
npm install
npm run upload