# ROS Integration Test Action

Github actions for running integration test for ROS packages.
Currenty, we are supporting foxy and galactic.
If you want to run build test for ROS / ROS2 package, we recommend to use [this action.](https://github.com/ros-tooling/action-ros-ci)

## paramters

|         name         | required |  default  |                 description                 |
| -------------------- | -------- | --------- | ------------------------------------------- |
| base_image           | false    | ros       | name of base image                          |
| tag                  | false    | foxy      | name of docker image tag                    |
| rosdistro            | false    | foxy      | name of ros distribution                    |
| test_command         | true     |           | shell command for runnig test case          |
| check_result_command | true     |           | shell command for checkin test case results |
| artifact_name        | false    | artifacts | name of output artifact                     |

## How it works?
1. Building runtime container in [alpine linux docker continer.](https://github.com/OUXT-Polaris/ros-integration-test-action/blob/master/Dockerfile)
2. Generate entrypoint.sh script for runtime container.
3. Copy packages.repos file into runtime docker, and build your ROS2 package inside runtime container.
4. Execute test_command and run integration test.
5. Execute check_result_command and check integration result test.
6. Upload files under "/artifacts" directory inside runtime container as artifact of workflow run.

## Tips
If you want to run integration test quickly, build your packages under "/colcon_ws" directory and push that image into docker registory. (dockerhub, AWS ECR etc..)

## How to use?

See also, [example workflow](https://github.com/OUXT-Polaris/ros-integration-test-action/blob/master/.github/workflows/test.yaml) of this repository.

```yaml
name: test

on:
  workflow_dispatch:
  schedule:
    - cron: 0 0 * * *
  pull_request:
  push:
    branches:
      - master

jobs:
  test:
    runs-on: ubuntu-latest
    name: A test job for ros integration test action
    strategy:
      fail-fast: false
      matrix:
        rosdistro: [foxy, galactic]
    steps:
    - uses: actions/checkout@v0.0.2
    - name: Copy and rename repos file
      run: cp .github/workflows/test.repos packages.repos
    # Read package.repos and run integration test.
    - name: Run ros integration test action
      uses: OUXT-Polaris/ros-integration-test-action@0.0.3
      with:
        base_image: ros
        tag: ${{ matrix.rosdistro }}
        rosdistro: ${{ matrix.rosdistro }}
        test_command: ls /colcon_ws/src
        check_result_command: ls /colcon_ws/src
        artifact_name: artifacts_${{ matrix.rosdistro }}
      env:
        ACTIONS_RUNTIME_TOKEN: ${{ secrets.GITHUB_TOKEN }} 
        ACTIONS_RUNTIME_URL: ${{ env.ACTIONS_RUNTIME_URL }}
        GITHUB_RUN_ID: ${env.GITHUB_RUN_ID}
        GITHUB_CLONE_TOKEN: ${{ secrets.WAMV_TAN_BOT_SECRET }} # access token for cloning your package in private repository.
        GITHUB_CLONE_USERNAME: wam-v-tan # users of access token
```