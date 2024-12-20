#!/bin/bash

# Usage: ./init-rosdep.sh
# initialize rosdep before using ROS2

# Initialize rosdep
sudo -E rosdep init
rosdep update