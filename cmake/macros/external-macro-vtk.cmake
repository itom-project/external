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
# VTK fetch
#
macro(fetch_vtk)
  ExternalProject_Add(
    vtk-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/vtk
    GIT_REPOSITORY ${EXTERNAL_REPO_VTK}
    GIT_TAG v${EXTERNAL_VERSION_VTK}
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()


#
# VTK compile
#
macro(compile_vtk)
  set(proj vtk-host)
  #get_try_run_results_file(${proj})
  #message(STATUS "try_run_results_file: ${try_run_results_file}")
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/vtk
    DOWNLOAD_COMMAND ""
    DEPENDS ${EXTERNAL_DEPENDEDCY_VTK}
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${EXTERNAL_BUILD_TYPE}
      #-DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DVTKCompileTools_DIR:PATH=${EXTERNAL_BUILD_PREFIX}/vtk-host
      #-DVTK_USE_CUDA:BOOL=ON
      -DVTK_QT_VERSION:STRING=6
      -DQT_QMAKE_EXECUTABLE:PATH=${EXTERNAL_BUILD_PREFIX}/qt-host/qtbase/bin/qmake
      #-DVTK_USE_QT:BOOL=ON
      -DVTK_Group_Qt:BOOL=ON
      #-DQtDir::PATH=${EXTERNAL_BUILD_PREFIX}/qt-host
      -DVTK_USE_QVTK_QTOPENGL:BOOL=OFF
      ${VTK_MODULE_DEFAULTS}
      #-C ${try_run_results_file}
    #INSTALL_COMMAND make install
  )
  add_to_env(${proj}/lib)
  force_build(${proj})
endmacro()