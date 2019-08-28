#!/bin/bash

THIRDPARTIES_PATH=/opt/klepsydra/thirdparties
SOURCES_PATH=`pwd`

usage() { echo "Usage: $0 [-i <installation folder. Default: /opt/klepsydra/thirdparties>] [-p <sources path. Default $pwd>]" 1>&2; exit 1; }

while getopts ":i:p:" o; do
    case "${o}" in
        i)
            THIRDPARTIES_PATH=${OPTARG}
            ((s == 45 || s == 90)) || usage
            ;;
        p)
            SOURCES_PATH=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "THIRDPARTIES_PATH = ${THIRDPARTIES_PATH}"
echo "SOURCES_PATH = ${SOURCES_PATH}"

git submodule update --init

rm -rf $THIRDPARTIES_PATH/*

mkdir -p $THIRDPARTIES_PATH/include

cp $SOURCES_PATH/concurrentqueue/*.h $THIRDPARTIES_PATH/include/
cp -r $SOURCES_PATH/cereal/include/* $THIRDPARTIES_PATH/include/
cp -r $SOURCES_PATH/spdlog/include/* $THIRDPARTIES_PATH/include/
cp -r $SOURCES_PATH/googletest $THIRDPARTIES_PATH/

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
make install

