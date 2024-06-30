# - mulitpoint software - 
# URL: http://www.uni-stuttgart.de/ito
# Copyright (C) 2023, Institut fuer Technische Optik (ITO),
# Universitaet Stuttgart, Germany
#
# mulitpoint is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public Licence as published by
# the Free Software Foundation; either version 2 of the Licence, or (at
# your option) any later version.
#
# mulitpoint is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library
# General Public Licence for more details.
#
# You should have received a copy of the GNU Library General Public License
# along with multipoint. If not, see <http://www.gnu.org/licenses/>.

list(APPEND CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(external_config)
include(external_prefix)
include(external_repos)
include(external_versions)
include(external_modules)
include(external_components)
include(external_macros)

set(FFMPEG_ROOT ${EXTERNAL_INSTALL_PREFIX}/ffmpeg-host)
#set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${EXTERNAL_INSTALL_PREFIX}/gstreamer-host/lib/x86_64-linux-gnu/pkgconfig")

set(CMAKE_PREFIX_PATH
    ${EXTERNAL_INSTALL_PREFIX}/ffmpeg-host
    ${EXTERNAL_INSTALL_PREFIX}/ffmpeg-host/lib/pkgconfig
    ${EXTERNAL_INSTALL_PREFIX}/gstreamer-host
    ${EXTERNAL_INSTALL_PREFIX}/gstreamer-host/lib/x86_64-linux-gnu/pkgconfig
    ${EXTERNAL_INSTALL_PREFIX}/opencv-host/lib/cmake/opencv4
    ${EXTERNAL_INSTALL_PREFIX}/qt-host
    ${EXTERNAL_INSTALL_PREFIX}/qt-host/lib/cmake/Qt6
    ${EXTERNAL_INSTALL_PREFIX}/vtk-host/lib/cmake
    ${EXTERNAL_INSTALL_PREFIX}/pcl-host
    ${EXTERNAL_INSTALL_PREFIX}/boost-host
    ${EXTERNAL_INSTALL_PREFIX}/flann-host
    ${EXTERNAL_INSTALL_PREFIX}/eigen-host
    ${EXTERNAL_INSTALL_PREFIX}/glew-host
    )

message(STATUS "External Dependecies Found:")
message(STATUS "--------------------------- \n")

#fetch_python()
#compile_python()

fetch_numpy()
compile_numpy()

#fetch_libusb()
#compile_libusb()

#fetch_genicam()
#compile_genicam()

#[[
find_package(FFMPEG ${EXTERNAL_VERSION_FFMPEG} COMPONENTS ${EXTERNAL_FFMPEG_FIND_COMPONENTS} QUIET)
if(NOT FFMPEG_FOUND)
    message(STATUS "FFmpeg v${EXTERNAL_VERSION_FFMPEG}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    set(EXTERNAL_REBUILD_OPENCV ON)
    fetch_ffmpeg()
    compile_ffmpeg()
else(NOT FFMPEG_FOUND)
    message(STATUS "FFmpeg v${EXTERNAL_VERSION_FFMPEG}: yes")
endif(NOT FFMPEG_FOUND)

find_package(GStreamer ${EXTERNAL_VERSION_GSTREAMER} QUIET)
if(NOT GSTREAMER_FOUND)
    message(STATUS "GStreamer v${EXTERNAL_VERSION_GSTREAMER}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    set(EXTERNAL_REBUILD_OPENCV ON)
    fetch_gstreamer()
    compile_gstreamer()
else(NOT GSTREAMER_FOUND)
    message(STATUS "GStreamer v${EXTERNAL_VERSION_GSTREAMER}: yes")
endif(NOT GSTREAMER_FOUND)


find_package(OpenCV ${EXTERNAL_VERSION_OPENCV} QUIET)
if(NOT OpenCV_FOUND OR EXTERNAL_REBUILD_OPENCV)
    message(STATUS "OpenCV v${EXTERNAL_VERSION_OPENCV}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    fetch_opencv()
    compile_opencv()

    if(NOT FFMPEG_FOUND AND NOT EXTERNAL_REBUILD_OPENCV)
        message(SEND_ERROR "FFMpeg not found: Can not compile OpenCV due to missing dependency.")
    endif(NOT FFMPEG_FOUND AND NOT EXTERNAL_REBUILD_OPENCV)
    if(NOT GSTREAMER_FOUND AND NOT EXTERNAL_REBUILD_OPENCV)
        message(SEND_ERROR "GStreamer not found: Can not compile OpenCV due to missing dependency.")
    endif(NOT GSTREAMER_FOUND AND NOT EXTERNAL_REBUILD_OPENCV)

else(NOT OpenCV_FOUND)
    message(STATUS "OpenCV v${EXTERNAL_VERSION_OPENCV}: yes")
endif(NOT OpenCV_FOUND OR EXTERNAL_REBUILD_OPENCV)


find_package(Qt6 ${EXTERNAL_VERSION_QT} COMPONENTS ${EXTERNAL_QT_FIND_COMPONENTS} QUIET)
if(NOT Qt6_FOUND)
    message(STATUS "Qt v${EXTERNAL_VERSION_QT}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    set(EXTERNAL_DEPENDEDCY_VTK ${EXTERNAL_DEPENDEDCY_VTK} qt-host)
    set(EXTERNAL_DEPENDEDCY_PCL ${EXTERNAL_DEPENDEDCY_PCL} qt-host)
    set(EXTERNAL_REBUILD_VTK ON)
    fetch_qt()
    compile_qt()
else(NOT Qt6_FOUND)
    message(STATUS "Qt v${EXTERNAL_VERSION_QT}: yes")
    qt_standard_project_setup()
endif(NOT Qt6_FOUND)


find_package(Eigen3 ${EXTERNAL_VERSION_EIGEN} NO_MODULE QUIET)
if(NOT TARGET Eigen3::Eigen)
    message(STATUS "Eigen v${EXTERNAL_VERSION_EIGEN}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    set(EXTERNAL_DEPENDEDCY_VTK ${EXTERNAL_DEPENDEDCY_VTK} eigen-host)
    set(EXTERNAL_DEPENDEDCY_PCL ${EXTERNAL_DEPENDEDCY_PCL} eigen-host)
    set(EXTERNAL_REBUILD_VTK ON)
    fetch_eigen()
    compile_eigen()
else(NOT TARGET Eigen3::Eigen)
    message(STATUS "Eigen v${EXTERNAL_VERSION_EIGEN}: yes")
endif(NOT TARGET Eigen3::Eigen)


find_package(Boost ${EXTERNAL_VERSION_BOOST} COMPONENTS ${EXTERNAL_BOOST_FIND_COMPONENTS} QUIET)
if(NOT BOOST_FOUND)
    message(STATUS "Boost v${EXTERNAL_VERSION_BOOST}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    set(EXTERNAL_DEPENDEDCY_VTK ${EXTERNAL_DEPENDEDCY_VTK} boost-host)
    set(EXTERNAL_DEPENDEDCY_PCL ${EXTERNAL_DEPENDEDCY_PCL} boost-host)
    set(EXTERNAL_REBUILD_VTK ON)
    fetch_boost()
    compile_boost()
else(NOT BOOST_FOUND)
    message(STATUS "Boost v${EXTERNAL_VERSION_BOOST}: yes")
endif(NOT BOOST_FOUND)


find_package(FLANN ${EXTERNAL_VERSION_FLANN} QUIET)
if(NOT FLANN_FOUND)
    message(STATUS "Flann v${EXTERNAL_VERSION_FLANN}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    set(EXTERNAL_DEPENDEDCY_VTK ${EXTERNAL_DEPENDEDCY_VTK} flann-host)
    set(EXTERNAL_DEPENDEDCY_PCL ${EXTERNAL_DEPENDEDCY_PCL} flann-host)
    set(EXTERNAL_REBUILD_VTK ON)
    fetch_flann()
    compile_flann()
else(NOT FLANN_FOUND)
    message(STATUS "Flann v${EXTERNAL_VERSION_FLANN}: yes")
endif(NOT FLANN_FOUND)

find_package(VTK QUIET)
if(NOT VTK_FOUND OR EXTERNAL_REBUILD_VTK)
    message(STATUS "VTK v${EXTERNAL_VERSION_VTK}: no")
    set(EXTERNAL_FLAG_BUILD_COMPLETE FALSE)
    set(EXTERNAL_DEPENDEDCY_VTK ${EXTERNAL_DEPENDEDCY_VTK} qhull-host pcap-host)
    set(EXTERNAL_DEPENDEDCY_PCL ${EXTERNAL_DEPENDEDCY_PCL} qhull-host pcap-host vtk-host)
    set(EXTERNAL_REBUILD_PCL ON)
    fetch_qhull()
    fetch_pcap()
    compile_qhull()
    compile_pcap()
    fetch_vtk()
    compile_vtk()
else(NOT VTK_FOUND)
    message(STATUS "VTK v${EXTERNAL_VERSION_VTK}: yes")
endif(NOT VTK_FOUND OR EXTERNAL_REBUILD_VTK)

find_package(PCL QUIET)
if(NOT PCL_FOUND OR EXTERNAL_REBUILD_PCL)
    message(STATUS "PCL v${EXTERNAL_VERSION_PCL}: no")
    fetch_pcl()
    compile_pcl()
else(PCL_FOUND)
    message(STATUS "PCL v${EXTERNAL_VERSION_PCL}: yes")
endif(NOT PCL_FOUND OR EXTERNAL_REBUILD_PCL)
]]

message(STATUS "\n")