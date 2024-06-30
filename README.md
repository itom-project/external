# itom-external project #

welcome to the open source software **itom**. It allows operating measurement systems with multiple hardware components, like cameras, AD-converters, actuators, motor stages as well as handling your lab automation. The graphical user interface provides a quick and easy access to all components, complex measurement tasks and algorithms can be scripted using the embedded python scripting language and self-defined user interfaces finally provide a possibility to adapt **itom** to your special needs. External hardware or algorithms are added to **itom** by an integrated plugin system.

In order to learn more about **itom**, see the official homepage [itom.bitbucket.io](http://itom.bitbucket.io) or read the [user documentation](http://itom.bitbucket.io/latest/docs/)

### What is this repository for? ###

This repository is the includes the superbuild instructions to add the external depencies for the **itom-project**,
which are currently comprising:

* FFMepg
* GStreamer
* OpenCV
* Qt
* Boost
* Eigen
* PCAP
* FLANN
* VTK
* PCL


### How do I get set up? ###

Clone this repositoriy and initialize the submodules and update them:

    git clone git@github.com:itom-project/xternal.git

or use the main project to complete an All-In-Build, comprsing **xternals**, **itom**core, **plugins** and **designerplugins** submodules:

    git clone --recursive --remote git@github.com:itom-project/mulitpoint.git
    cd mulitpoint
    git submodule foreach --recursive git checkout master

### Dependencies ###

Ubuntu:

for FFmpeg:
    sudo apt install -y yasm libx265-dev libnuma-dev libx264-dev gnutls-dev
    sudo apt install -y libvpx-dev libfdk-aac-dev libopus-dev libdav1d-dev

for Gstreamer:
    sudo apt install pkg-config ninja-build flex bison
    sudo apt install python3-pip
    sudo pip install meson --break-system-packages
    echo "export PATH=/usr/local/bin:$PATH" >> ~/.bashrc

for QT:
    sudo apt install libfontconfig1-dev libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb-cursor-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-randr0-dev libxcb-util-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev liblz4-dev libxkbcommon-x11-dev libgl1-mesa-dev mesa-common-dev
    sudo apt install fle bison

https://askubuntu.com/questions/343770/gdb-symbol-lookup-error

### Path Environment ###
**LD_LIBRARY_PATH**

### Building ###
to build the project follow the steps listed below:

    git clone --recursive --remote git@github.com:itom-project/mulitpoint.git
    cd mulitpoint
    git submodule foreach --recursive git checkout master
    
### Recognition ###
This project is based on [Superbuild](https://github.com/willperkins/pcl-superbuild) **PCL-Superbuild** by Will Perkins.


### Contribution ###

You are welcome to use and test **itom**. If you want to you are invited to participate in the development of **itom** or some of its plugins. If you found any bug, feel free to post an issue.


### Contact ###

**itom** is being developed since 2011 by

> [Institut für Technische Optik](http://www.uni-stuttgart.de/ito)

> University of Stuttgart

> Stuttgart

> Germany

in co-operation with 
> [twip Optical Solutions GmbH](http://www.twip-os.com)

> Stuttgart

> Germany


CMake build scripts for cross compiling PCL and its dependencies for Android and iOS.    