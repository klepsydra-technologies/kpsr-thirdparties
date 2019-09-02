#!/bin/bash

THIRDPARTIES_PATH="/opt/klepsydra/thirdparties"
SOURCES_PATH="${PWD}"
BUILD_YAML=""
BUILD_ZMQ=""

usage() {
    echo "Usage: $0 [options]" 1>&2
    echo "" 1>&2
    echo "OPTIONS:" 1>&2
    echo "-i <installation folder> Default: ${THIRDPARTIES_PATH}" 1>&2
    echo "-p <sources path> Default: ${SOURCES_PATH}" 1>&2
    echo "-y Build yaml-cpp" 1>&2
    echo "-z Build cppzmq" 1>&2
    exit 1
}

while getopts "i:p:yz" o; do
    case "${o}" in
        i)
            THIRDPARTIES_PATH=${OPTARG}
            ((s == 45 || s == 90)) || usage
            ;;
        p)
            SOURCES_PATH=${OPTARG}
            ;;
        y)
            BUILD_YAML="true"
            ;;
        z)
            BUILD_ZMQ="true"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "THIRDPARTIES_PATH = ${THIRDPARTIES_PATH}"
echo "SOURCES_PATH = ${SOURCES_PATH}"
echo "BUILD_YAML = ${BUILD_YAML}"
echo "BUILD_ZMQ = ${BUILD_ZMQ}"

if [ -w "${THIRDPARTIES_PATH}" ]; then
    SUDO_CMD=""
else
    SUDO_CMD="sudo"
fi

git submodule update --init

$SUDO_CMD rm -rf $THIRDPARTIES_PATH/*

$SUDO_CMD mkdir -p $THIRDPARTIES_PATH/include

$SUDO_CMD cp $SOURCES_PATH/concurrentqueue/*.h $THIRDPARTIES_PATH/include/
$SUDO_CMD cp -r $SOURCES_PATH/cereal/include/* $THIRDPARTIES_PATH/include/
$SUDO_CMD cp -r $SOURCES_PATH/spdlog/include/* $THIRDPARTIES_PATH/include/
$SUDO_CMD cp -r $SOURCES_PATH/googletest $THIRDPARTIES_PATH/

pushd .

cd pistache
git submodule update --init
rm -rf $SOURCES_PATH/pistache/build
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
make -j
$SUDO_CMD make install

popd

if [ "$BUILD_YAML" ]; then
    pushd .

    git clone https://github.com/jbeder/yaml-cpp
    cd yaml-cpp
    git checkout yaml-cpp-0.6.2
    mkdir build
    cd build
    cmake \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make -j
    sudo make install

    popd
fi

if [ "$BUILD_ZMQ" ]; then
    pushd .

    git clone https://github.com/zeromq/libzmq.git
    cd libzmq
    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make -j
    sudo make install

    popd

    pushd .

    git clone https://github.com/zeromq/cppzmq.git
    cd cppzmq
    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make -j
    sudo make install

    popd

    pushd .

    git clone https://github.com/zeromq/czmq.git
    cd czmq
    mkdir build
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX=$THIRDPARTIES_PATH \
        ..
    make -j
    sudo make install

    popd
fi

