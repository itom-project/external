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

#https://pointclouds.org/documentation/tutorials/compiling_pcl_dependencies_windows.html

#
# PCL fetch
#
macro(fetch_pcl)
  ExternalProject_Add(
    pcl-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/pcl
    GIT_REPOSITORY ${EXTERNAL_REPO_PCL}
    GIT_TAG pcl-${EXTERNAL_VERSION_PCL}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    PATCH_COMMAND ""
    #  ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/cmake/patches/FindGlew.cmake ${EXTERNAL_SOURCE_PREFIX}/pcl/cmake/Modules/FindGLEW.cmake
  )
endmacro()


#
# PCL compile
#
macro(compile_pcl)
  set(proj pcl-host)
  get_try_run_results_file(${proj})
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/pcl
    DOWNLOAD_COMMAND ""
    DEPENDS ${EXTERNAL_DEPENDEDCY_PCL}
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${EXTERNAL_BUILD_TYPE}
      #-DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      #-DPCL_SHARED_LIBS:BOOL=OFF
      -DPCL_SHARED_LIBS:BOOL=ON
      #-DVTK_DIR=${EXTERNAL_INSTALL_PREFIX}/vtk-host/
      -DEIGEN_INCLUDE_DIR=${EXTERNAL_SOURCE_PREFIX}/eigen
      -DFLANN_ROOT=${EXTERNAL_INSTALL_PREFIX}/flann-host
      #-DFLANN_INCLUDE_DIR=${EXTERNAL_INSTALL_PREFIX}/flann-host/include
      #-DFLANN_LIBRARY=${EXTERNAL_INSTALL_PREFIX}/flann-host/lib/libflann_cpp_s.a
      -DBOOST_ROOT=${EXTERNAL_INSTALL_PREFIX}/boost-host
      -DVTK_ROOT=${EXTERNAL_INSTALL_PREFIX}/vtk-host
      -DWITH_PCAP:BOOL=OFF
      -DWITH_OPENGL:BOOL=ON
      -DWITH_OPENMP:BOOL=ON
      -DWITH_OPENNI:BOOL=OFF
      -DWITH_OPENNI2:BOOL=OFF
      #-DPCAP_INCLUDE_DIR:PATH=${EXTERNAL_INSTALL_PREFIX}/pcap-host/include
      #-DPCAP_LIBRARY:PATH=${EXTERNAL_INSTALL_PREFIX}/pcap-host/lib
      -DGLEW_INCLUDE_DIR=${EXTERNAL_INSTALL_PREFIX}/glew-host/include
      -DGLEW_LIBRARY=${EXTERNAL_INSTALL_PREFIX}/glew-host/lib
      -DQHULL_INCLUDE_DIR=${EXTERNAL_INSTALL_PREFIX}/qhull-host/lib
      -DQHULL_LIBRARY=${EXTERNAL_INSTALL_PREFIX}/qhull-host/lib
      -DWITH_QT:STRING=QT6
      -DQt6Concurrent_DIR:STRING=${EXTERNAL_INSTALL_PREFIX}/qt-host/lib/cmake/Qt6Concurrent
      -DQt6CoreTools_DIR:STRING=${EXTERNAL_INSTALL_PREFIX}/qt-host/lib/cmake/Qt6CoreTools
      -DQt6Core_DIR:STRING=${EXTERNAL_INSTALL_PREFIX}/qt-host/lib/cmake/Qt6Core
      -DQt6_DIR:STRING=${EXTERNAL_INSTALL_PREFIX}/qt-host/lib/cmake/Qt6
      -DQTDIR:STRING=${EXTERNAL_INSTALL_PREFIX}/qt-host
      -DQT_QMAKE_EXECUTABLE:STRING=${EXTERNAL_INSTALL_PREFIX}/qt-host/bin/qmake
      #-C ${try_run_results_file}
  )
  add_to_env(${proj}/lib)
  force_build(${proj})
endmacro()