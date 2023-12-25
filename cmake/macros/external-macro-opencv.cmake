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

#
# OpenCV fetch
#
macro(fetch_opencv)
  ExternalProject_Add(
    opencv-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/opencv
    GIT_REPOSITORY ${EXTERNAL_REPO_OPENCV}
    GIT_TAG ${EXTERNAL_VERSION_OPENCV}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# OpenCV compile
#
macro(compile_opencv)
  set(proj opencv-host)
  #set(CMAKE_MACOSX_RPATH 1)

  set(EXTERNAL_ARGS_OPENCV
    ${ep_common_args}
    -DBUILD_DOCS:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_NEW_PYTHON_SUPPORT:BOOL=OFF
    -DBUILD_PACKAGE:BOOL=OFF
    -DCMAKE_CXX_STANDARD:VALUE=17
    #-DBUILD_SHARED_LIBS:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTS:BOOL=OFF
    -DBUILD_PERF_TESTS=OFF
    -DBUILD_opencv_apps=OFF
    -DCMAKE_BUILD_TYPE:STRING=${EXTERNAL_BUILD_TYPE}
    -DWITH_FFMPEG:BOOL=ON
    -DWITH_GSTREAMER:BOOL=ON
    -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/opencv-host
    -DfPIC:BOOL=ON
  )

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/opencv
    BINARY_DIR ${EXTERNAL_BUILD_PREFIX}/${proj}
    DOWNLOAD_COMMAND ""
    DEPENDS ${EXTERNAL_DEPENDEDCY_OPENCV}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env PKG_CONFIG_PATH=${FFMPEG_ROOT}/lib/pkgconfig:${EXTERNAL_INSTALL_PREFIX}/gstreamer-host/lib/x86_64-linux-gnu/pkgconfig
                      ${CMAKE_COMMAND} ${EXTERNAL_ARGS_OPENCV} ${EXTERNAL_SOURCE_PREFIX}/opencv
    DEPENDS ${EXTERNAL_DEPENDENCY_OPENCV}
    BUILD_COMMAND ${CMAKE_COMMAND} -E echo OpenCV BUILD Step: COMMAND
                  ${CMAKE_COMMAND} -E env PKG_CONFIG_PATH=${EXTERNAL_INSTALL_PREFIX}/lib/pkgconfig:${EXTERNAL_INSTALL_PREFIX}/gstreamer-host/lib/x86_64-linux-gnu/pkgconfig
                  ${CMAKE_COMMAND} --build ${EXTERNAL_BUILD_PREFIX}/${proj} -j8
    INSTALL_COMMAND ${CMAKE_COMMAND} --install ${EXTERNAL_BUILD_PREFIX}/${proj}
  )
  add_to_env(${proj}/lib)
endmacro()