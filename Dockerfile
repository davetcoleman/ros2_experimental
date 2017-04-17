# ROS2 docker

FROM ubuntu:16.04
MAINTAINER Dave Coleman dave@dav.ee

# setup environment
RUN apt-get update && apt-get install -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# lsb-release is required for the keys
RUN apt-get update
RUN apt-get -qq install -y git wget lsb-release

# setup keys
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-latest.list'
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys D2486D2DD83DB69272AFE98867170598AF249743

# deps
RUN apt-get update
RUN apt-get -qq install -y build-essential cppcheck cmake libopencv-dev libpoco-dev libpocofoundation9v5 libpocofoundation9v5-dbg python-empy python3-dev python3-empy python3-nose python3-pip python3-setuptools python3-vcstool libtinyxml-dev libeigen3-dev
# dependencies for testing
RUN apt-get -qq install -y clang-format pydocstyle pyflakes python3-coverage python3-mock python3-pep8 uncrustify
RUN pip3 install flake8 flake8-import-order
# dependencies for FastRTPS
RUN apt-get -qq install -y libasio-dev libboost-chrono-dev libboost-date-time-dev libboost-program-options-dev libboost-regex-dev libboost-system-dev libboost-thread-dev libtinyxml2-dev

ENV TERM xterm

# Setup catkin workspace
ENV CATKIN_WS=/root/ws_ros2
RUN mkdir -p $CATKIN_WS/src
WORKDIR $CATKIN_WS

RUN wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
RUN vcs import src < ros2.repos

RUN src/ament/ament_tools/scripts/ament.py build --build-tests --symlink-install

CMD ["bash"]
