#!/usr/bin/env bash
#
# KumarRobotics Jackal Master based on Open Robotics Image
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
fi

# Create the image name and tag
user_id=$(id -u)
image_name=$(basename "$1")
revision=$(git describe --tags --long)
image_plus_tag=kumarrobotics/$image_name:$revision

# Print image name in purple
echo -e "\033[0;35mBuilding $image_plus_tag\033[0m"

# get path to current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d $DIR/$1 ]
then
  echo "image-name must be a directory in the same folder as this script"
  exit 2
fi

# Build the image
docker build --rm -t $image_plus_tag --build-arg user_id=$user_id -f $DIR/$image_name/Dockerfile .
echo "Built $image_plus_tag and tagged as $image_name:latest"

# Create "latest" tag
docker tag $image_plus_tag kumarrobotics/$image_name:latest
