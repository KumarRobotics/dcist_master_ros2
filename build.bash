#!/usr/bin/env bash
#
# KumarRobotics DCIST Master based on Open Robotics Image
#
# * * * *
#
# Copyright (C) 2018 Open Source Robotics Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eo pipefail

# Upstream images for x86_64 and aarch64
# For x86_64, use the CUDA 11.4.3 image
# For aarch64, use the L4T PyTorch image
# Important: do not modify the variable name as it is used by the Github action
# to build the image
UPSTREAM_X86_64=nvcr.io/nvidia/cuda:11.4.3-devel-ubuntu20.04
UPSTREAM_AARCH64=nvcr.io/nvidia/l4t-pytorch:r35.1.0-pth1.13-py3

# Check that the current user has UID 1000.
if [ $(id -u) -ne 1000 ]
then
  echo "ERROR: This script must be run with UID and GID of 1000."
  echo "       Current UID: $(id -u), current GID: $(id -g)"
  exit 1
fi

if [ $# -eq 0 ]
then
    echo "Usage: $0 directory-name"
    exit 1
elif [ $# -eq 1 ]
then
  # No image type is provided, build x86 by default
  upstream=$UPSTREAM_X86_64
  architecture="x86_64"
elif [ $# -eq 2 ]
then
  # The second argument should be x86_64 or aarch64
  if [ "$2" = "x86_64" ]
  then
    upstream=$UPSTREAM_X86_64
  elif [ "$2" = "aarch64" ]
  then
    upstream=$UPSTREAM_AARCH64
  else
    echo "Usage: $0 directory-name [x86_64|aarch64]"
    exit 1
  fi
  architecture=$2
else
  echo "Usage: $0 directory-name [x86_64|aarch64]"
  exit 1
fi

# Create the image name and tag
user_id=$(id -u)
image_name=$(basename "$1")
revision=$(git describe --tags --long)
image_plus_tag=kumarrobotics/$image_name:$revision

# Print image name in purple
echo -e "\033[0;35mBuilding $image_plus_tag"
echo -e "Architecture: $architecture"
echo -e "Upstream image: $upstream\n\033[0m"

# get path to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d "$DIR/$1" ]
then
  echo "image-name must be a directory in the same folder as this script"
  exit 2
fi

# Build the image
docker build --rm -t $image_plus_tag \
  --build-arg user_id=$user_id \
  --build-arg upstream_image=$upstream \
  -f $DIR/$image_name/Dockerfile .
echo "Built $image_plus_tag and tagged as $image_name:latest"

# Create "latest" tag
docker tag $image_plus_tag kumarrobotics/$image_name:latest
