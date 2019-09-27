#!/bin/bash

# Abort on errors
set -e

THIRDPARTIES_PATH="/opt/klepsydra/thirdparties"
BUILD_YAML=""
BUILD_ZMQ=""
BUILD_ROS=""
SUDO_CMD=""

usage() {
    echo "Usage: $0 [options]" 1>&2
    echo "" 1>&2
    echo "OPTIONS:" 1>&2
    echo "-i <installation folder> Default: ${THIRDPARTIES_PATH}" 1>&2
    echo "-r Install ROS" 1>&2
    echo "-y Build yaml-cpp" 1>&2
    echo "-z Build cppzmq" 1>&2
    echo "-s Use sudo" 1>&2
    exit 1
}

while getopts "i:p:yz" o; do
    case "${o}" in
        i)
            THIRDPARTIES_PATH=$(realpath ${OPTARG})
            ;;
        r)
            BUILD_ROS="true"
            ;;
        y)
            BUILD_YAML="true"
            ;;
        z)
            BUILD_ZMQ="true"
            ;;
        s)
            SUDO_CMD="sudo"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "THIRDPARTIES_PATH = ${THIRDPARTIES_PATH}"
echo "BUILD_YAML = ${BUILD_YAML}"
echo "BUILD_ZMQ = ${BUILD_ZMQ}"
echo "BUILD_ROS = ${BUILD_ROS}"
echo "SUDO_CMD = ${SUDO_CMD}"

if [ "$BUILD_YAML" ]; then
    pushd .

    set +e
    git clone https://github.com/jbeder/yaml-cpp
    set -e
    cd yaml-cpp
    git checkout yaml-cpp-0.6.2
    mkdir build
    cd build
    cmake \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make
    $SUDO_CMD make install

    popd
fi

if [ "$BUILD_ZMQ" ]; then
    pushd .

    set +e
    git clone https://github.com/zeromq/libzmq.git
    set -e
    cd libzmq
    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make
    $SUDO_CMD make install

    popd

    pushd .

    set +e
    git clone https://github.com/zeromq/cppzmq.git
    set -e
    cd cppzmq
    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make
    $SUDO_CMD make install

    popd

    pushd .

    set +e
    git clone https://github.com/zeromq/czmq.git
    set -e
    cd czmq
    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make
    $SUDO_CMD make install

    popd
fi

if [ "$BUILD_ROS" ]; then
   $SUDO_CMD apt update
   $SUDO_CMD sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
   $SUDO_CMD apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

   $SUDO_CMD apt update
   $SUDO_CMD apt --assume-yes install ros-melodic-desktop-full
   $SUDO_CMD apt dist-upgrade

   source /opt/ros/melodic/setup.bash
   $SUDO_CMD apt --assume-yes install python-rosinstall
   $SUDO_CMD apt --assume-yes install ca-cacert

   $SUDO_CMD rosdep init
   rosdep update

   $SUDO_CMD apt --assume-yes install ros-melodic-mavros ros-melodic-mavros-extras 
fi

