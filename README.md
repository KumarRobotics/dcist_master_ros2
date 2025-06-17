DCIST Master
=============
![Docker CI Build](https://github.com/KumarRobotics/dcist_master/actions/workflows/docker-build.yaml/badge.svg?branch=master)

This is the base image used for the DCIST robots at KR, for the Jackals to run ROS2-Jazzy on Ubuntu-24.04

TL;DR:
 - It installs the dependencies required by many user packages (see
   `dcist-master-jazzy/Dockerfile`).
 - It copies the `ws` main dcist workspace and builds it.
 - It provides helper scripts `build.bash`, `run.bash` and `join.bash`

### Architectures
Three architectures are provided:
 - `kumarrobotics/dcist-master-jazzy-bare` - **x86_64 CPU**: To run in CPU-only platforms, such as the Intel NUC for the high-altitude quads. Based on `ubuntu` Docker images.
 - `kumarrobotics/dcist-master-jazzy-nvda` - **x86_64 CUDA**: To run in x86_64 GPU-accelerated platforms, such as the computers on the Jackals. Based on `nvidia/cuda` Docker images.
 - `kumarrobotics/dcist-master-jazzy-nvda` - **arm64 CUDA**: To run in Nvidia Jetson platforms.

### How to build and use?
```
git clone https://github.com/KumarRobotics/dcist_master_ros2.git
cd dcist_master_ros2 && git submodule update --init --recursive
./build.bash dcist-master-jazzy x86_64_nvda
./run.bash dcist-master-jazzy-nvda:latest
```

### Notes on how to start up the Jackal
To launch the base hardware (no sensors), use the following commands:

```
ros2 launch /etc/clearpath/platform/launch/platform-service.launch.py
ros2 run safety_controller safety_controller
```

### Notes on how to start the zed and ouster
To launch the camera and LIDAR, use the following commands:

```
ros2 launch zed_wrapper zed_camera.launch.py camera_model:=zed2i
ros2 launch ouster_ros sensor.composite.launch.py viz:=false
```

### Notes on how to get odometry estimates
To receive odometry, use the following commands:

```
ros2 launch direct_lidar_inertial_odometry dlio.launch.py rviz:=false
```
