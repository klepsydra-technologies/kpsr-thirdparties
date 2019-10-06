#!/bin/bash

# Abort on errors
set -e

THIRDPARTIES_PATH="/opt/klepsydra/thirdparties"
BUILD_PISTACHE=""
BUILD_YAML=""
BUILD_ZMQ=""
BUILD_ROS=""
BUILD_OCV=""
SUDO_CMD=""

usage() {
    echo "Usage: $0 [options]" 1>&2
    echo "" 1>&2
    echo "OPTIONS:" 1>&2
    echo "-i <installation folder> Default: ${THIRDPARTIES_PATH}" 1>&2
    echo "-r Install ROS" 1>&2
    echo "-y Build yaml-cpp" 1>&2
    echo "-p Build pistache" 1>&2
    echo "-z Build cppzmq" 1>&2
    echo "-o Build opencv 3.4.1" 1>&2
    echo "-s Use sudo" 1>&2
    exit 1
}

while getopts "irypzo" o; do
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
        p)
            BUILD_PISTACHE="true"
            ;;
        s)
            SUDO_CMD="sudo"
            ;;
        o)
            BUILD_OCV="true"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "THIRDPARTIES_PATH = ${THIRDPARTIES_PATH}"
echo "BUILD_YAML = ${BUILD_YAML}"
echo "BUILD_YAML = ${BUILD_OCV}"
echo "BUILD_ZMQ = ${BUILD_ZMQ}"
echo "BUILD_ROS = ${BUILD_ROS}"
echo "SUDO_CMD = ${SUDO_CMD}"


$SUDO_CMD rm -rf $THIRDPARTIES_PATH
$SUDO_CMD mkdir -p $THIRDPARTIES_PATH

pushd .

if [ "$BUILD_PISTACHE" ]; then
   git clone https://github.com/klepsydra-technologies/pistache.git
   cd pistache
   git submodule update --init
   mkdir -p build
   cd build
   cmake -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=Release \
        -DPISTACHE_BUILD_EXAMPLES=true \
        -DPISTACHE_BUILD_TESTS=true \
        -DPISTACHE_BUILD_DOCS=false \
        -DPISTACHE_USE_SSL=true \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH/pistache \
        ../
   make
   $SUDO_CMD make install
fi

popd

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
   $SUDO_CMD . /etc/os-release
   $SUDO_CMD echo "deb http://packages.ros.org/ros/ubuntu $VERSION_CODENAME main" > /etc/apt/sources.list.d/ros-latest.list
   $SUDO_CMD apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
   cat /etc/apt/sources.list.d/ros-latest.list

   $SUDO_CMD apt update
   $SUDO_CMD apt install ros-melodic-desktop-full -y 
   $SUDO_CMD apt dist-upgrade -y 

   source /opt/ros/melodic/setup.bash
   $SUDO_CMD apt install python-rosinstall -y 
   $SUDO_CMD apt install ca-cacert -y

   $SUDO_CMD rosdep init
   rosdep update

   $SUDO_CMD apt install ros-melodic-mavros ros-melodic-mavros-extras -y 
fi

if [ "$BUILD_OCV" ]; then
    wget https://github.com/opencv/opencv/archive/3.4.1.tar.gz
    tar zxvf 3.4.1.tar.gz

    cd opencv-3.4.1

    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=RELEASE ..
    make -j4
    $SUDO_CMD make install
fi

