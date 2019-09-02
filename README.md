[![klepsydra logo](./images/klepsydra_logo.jpg)](http://www.klepsydra.org)

# Installation Instructions

## System dependencies

* Ubuntu 14.04 or above
* ZMQ 3 or above (optional)
* DDS (optional)
* Cmake 3.5.1 or above
* gcc for C++11 5.4.0 or above.

## System installation

	sudo apt install build-essential
	sudo apt install git
	sudo apt install cmake
	sudo apt install libssl-dev
	sudo apt install libcurl4-gnutls-dev

### Installation

Run the script ./build_3parties.sh with the following parameters:
- -p: Source folder location. Default is current folder
- -i: Installation path. Default is /opt/klepsydra/thirdparties
- -y: Build and install yaml-cpp
- -z: Build and install cppzmq

Example
```
./build_3parties.sh $HOME/klepsydra/kpsr-thirdparties
```

