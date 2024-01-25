DCIST Master
=============

This is the base image used for the DCIST robots at KR, including the Jackals
and the high-altitude UAV. Images are automatically built and
pushed to Docker Hub.

TL;DR:
 - It installs the dependencies required by many user packages (see
   `dcist-master/Dockerfile`).
 - It copies the `ws` main dcist workspace and builds it.
 - It provides helper scripts `build.bash`, `run.bash` and `join.bash`

**Important: Only tagged versions are pushed as the `latest` image.**

### How to use?
```
docker pull kumarrobotics/dcist-master:latest
./run.bash dcist-master
# If you need to join the environment later
./join.bash dcist-master
```

### How to build?
```
./build.bash dcist-master
```
