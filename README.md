DCIST Master
=============
![Docker CI Build](https://github.com/KumarRobotics/dcist_master/actions/workflows/docker-build.yaml/badge.svg?branch=master)

This is the base image used for the DCIST robots at KR, for the Jackals to run ROS2-Jazzy on Ubuntu-24.04

TL;DR:
 - It installs the dependencies required by many user packages (see
   `dcist-master/Dockerfile`).
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

### Notes on image building
  - Despite the colcon build command being present in the Dockerfile, it the dcist_ws does not remain built. That being said, if after running the docker container, if you build it inside the docker container it will remain built upon future executions (not sure why)

### Notes on how to start up the Jackal
To launch the base hardware (no sensors), use the following commands:

```
ros2 launch jackal_robot bringup.launch.py
ros2 run twist_stamper twist_stamper --ros-args -r  cmd_vel_in:=/jackal_velocity_controller/cmd_vel_unstamped -r cmd_vel_out:=/jackal_velocity_controller/cmd_vel
```

### Notes on how to start the realsense and ouster
To launch the camera and LIDAR, use the following commands:

```
ros2 launch realsense2_camera rs_launch.py depth_module.depth_profile:=1280x720x30 pointcloud.enable:=true
ros2 launch ouster_ros sensor.launch.xml sensor_hostname:=192.168.100.12 udp_dest:=192.168.100.1 viz:=false
```