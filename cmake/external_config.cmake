# - itom software
# URL: http://www.uni-stuttgart.de/ito
# Copyright (C) 2020, Institut fuer Technische Optik (ITO),
# Universitaet Stuttgart, Germany
#
# This file is part of itom and its software development toolkit (SDK).
#
# itom is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public Licence as published by
# the Free Software Foundation; either version 2 of the Licence, or (at
# your option) any later version.
#
# itom is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library
# General Public Licence for more details.
#
# You should have received a copy of the GNU Library General Public License
# along with itom. If not, see <http://www.gnu.org/licenses/>.

include(ExternalProject)

set(base "${CMAKE_BINARY_DIR}/external")
set_property(DIRECTORY PROPERTY EP_BASE ${base})

# This macro sets CMAKE_BUILD_TYPE if it is undefined
# and makes sure that the variable appears in the cache
macro(set_default_build_type build_type)
  if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE ${EXTERNAL_BUILD_TYPE})
  endif()
  set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Build configuration type" FORCE)
endmacro()

set_default_build_type(release)
set(EXTERNAL_BUILD_TYPE ${CMAKE_BUILD_TYPE})

set(EXTERNAL_PATCHES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/patches)

find_package(PythonInterp REQUIRED)
find_package(Git REQUIRED)

set(EXTERNAL_DEPENDENCY_OPENCV opencv-fetch)
set(EXTERNAL_DEPENDEDCY_VTK vtk-fetch)
set(EXTERNAL_DEPENDEDCY_PCL pcl-fetch)
set(EXTERNAL_FLAG_BUILD_COMPLETE TRUE)

set(EXTERNAL_REBUILD_OPENCV OFF)
set(EXTERNAL_REBUILD_VTK OFF)
set(EXTERNAL_REBUILD_PCL OFF)

#option(BUILD_ANDROID "Build for Android" OFF)
#option(BUILD_IOS_DEVICE "Build for iOS device" OFF)
#option(BUILD_IOS_SIMULATOR "Build for iOS simulator" OFF)

#set(toolchain_dir ${CMAKE_SOURCE_DIR}/toolchains)
#set(toolchain_ios_simulator ${toolchain_dir}/toolchain-ios-simulator.cmake)
#set(toolchain_ios_device ${toolchain_dir}/toolchain-ios-device.cmake)
#set(toolchain_android ${toolchain_dir}/toolchain-android.cmake)
#set(try_run_results_vtk_ios_simulator ${toolchain_dir}/vtk-try-run-results.cmake)
#set(try_run_results_vtk_ios_device ${toolchain_dir}/vtk-try-run-results.cmake)
#set(try_run_results_vtk_android ${toolchain_dir}/vtk-try-run-results.cmake)
#set(try_run_results_pcl_ios_simulator ${toolchain_dir}/pcl-try-run-results.cmake)
#set(try_run_results_pcl_ios_device ${toolchain_dir}/pcl-try-run-results.cmake)
#set(try_run_results_pcl_android ${toolchain_dir}/pcl-try-run-results.cmake)
