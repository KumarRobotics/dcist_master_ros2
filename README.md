Jackal Master
=============

This is the base image used for the Jackals. Images are automatically built and
pushed to Docker Hub.

TL;DR:
 - It installs the dependencies required by many user packages (see
   `jackal-master/Dockerfile`).
 - It copies the `ws` jackal workspace and builds it.
 - It provides helper scripts `build.bash`, `run.bash` and `join.bash`

### How to use?
```
docker pull kumarrobotics/jackal-master:latest
./run.bash jackal-master
# If you need to join the environment later
./join.bash jackal-master
```

### How to build?
```
./build.bash jackal-master
```
