[![klepsydra logo](./images/klepsydra_logo.jpg)](http://www.klepsydra.org)

# Installation Instructions

## System dependencies

* Ubuntu 14.04 or above
* ZMQ 3 or above (optional)
* DDS (optional)
* Cmake 3.5.1 or above
* gcc for C++11 5.4.0 or above.

## System installation

	sudo apt install build-essentials
	sudo apt install git
	sudo apt install cmake
	git clone https://github.com/google/googletest.git

### Installation

Run the script ./build_3parties.sh with the following parameters:
- -p: Source folder location. Default is current folder
- -i: Installation path. Defatul is /opt/klepsydra/thirdparties

Example
```
./build_3parties.sh $HOME/klepsydra/kpsr-thirdparties
```

