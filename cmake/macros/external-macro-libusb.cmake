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

#https://github.com/IntelRealSense/librealsense/blob/master/CMake/external_libusb.cmake

#
# libusb fetch
#
macro(fetch_libusb)
  ExternalProject_Add(
    libusb-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/libusb
    GIT_REPOSITORY ${EXTERNAL_REPO_LIBUSB}
    GIT_TAG v${EXTERNAL_VERSION_LIBUSB}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()


#
# libusb compile
#
macro(compile_libusb)
  set(proj libusb-host)
  
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/libusb
    BINARY_DIR ${EXTERNAL_BUILD_PREFIX}/libusb-host
    DOWNLOAD_COMMAND ""
    DEPENDS libusb-fetch
    PATCH_COMMAND ""
    CMAKE_ARGS
            -DCMAKE_BUILD_TYPE:STRING=release
            -DBUILD_SHARED_LIBS:BOOL=ON
            -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_PREFIX}/libusb-host
    TEST_COMMAND ""
  )
  add_to_env(${proj}/lib)
  force_build(${proj})
  
endmacro()