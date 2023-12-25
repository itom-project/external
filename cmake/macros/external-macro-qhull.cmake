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
# QHULL fetch
#
macro(fetch_qhull)
  ExternalProject_Add(
    qhull-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/qhull
    GIT_REPOSITORY ${EXTERNAL_REPO_QHULL}
    GIT_TAG v${EXTERNAL_VERSION_QHULL}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()


#
# QHULL compile
#
macro(compile_qhull)
  set(proj qhull-host)
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/qhull
    DOWNLOAD_COMMAND ""
    DEPENDS qhull-fetch
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${EXTERNAL_BUILD_TYPE}
      #-DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_EXAMPLES:BOOL=OFF
      -DBUILD_PYTHON_BINDINGS:BOOL=OFF
      -DBUILD_MATLAB_BINDINGS:BOOL=OFF
  )
  add_to_env(${proj}/lib)
  force_build(${proj})
endmacro()