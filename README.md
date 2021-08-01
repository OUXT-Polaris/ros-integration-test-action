# ROS Integration Test Action

Github actions for running integration test for ROS packages.
Currenty, we are supporting foxy and galactic.
If you want to run build test for ROS / ROS2 package, we are recommend to use [this action.](https://github.com/ros-tooling/action-ros-ci)

## paramters

|         name         | required |              default               |              description               |
| -------------------- | -------- | ---------------------------------- | -------------------------------------- |
| base_image           | false    | ros                                | name of base image                     |
| tag                  | false    | foxy                               | name of docker image tag               |
| repos_url            | true     |                                    | wget url of repos file you want to use |
| test_command         | true     |                                    | shell command for runnig test case     |
| check_result_command | true     | shell command for runnig test case |                                        |

## How it works?
1. Building runtime container in [alpine linux docker continer.](https://github.com/OUXT-Polaris/ros-integration-test-action/blob/master/Dockerfile)
2. [Generate entrypoint.sh](https://github.com/OUXT-Polaris/ros-integration-test-action/blob/9a03c72fb53a3bc18d815470dfc78bdfbae32d09/entrypoint.sh#L12) for runtime container.
3. Wget repos file from repos_url, and build your ROS2 package inside [runtime container.](https://github.com/OUXT-Polaris/ros-integration-test-action/blob/master/runtime_image/Dockerfile)
4. Execute test_command and run integration test.
5. Execute check_result_command and check integration result test.
6. Upload files under "/artifacts" directory inside runtime container as artifact of workflow run.

## Tips
If you want to run integration test quickly, build your packages under "/colcon_ws" directory and push that image into docker registory. (dockerhub, AWS ECR etc..)
