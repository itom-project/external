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
# FLANN fetch
#
macro(fetch_flann)
  ExternalProject_Add(
    flann-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/flann
    GIT_REPOSITORY ${EXTERNAL_REPO_FLANN}
    GIT_TAG ${EXTERNAL_VERSION_FLANN}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()


#
# FLANN compile
#
macro(compile_flann)
  set(proj flann-host)
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/flann
    DOWNLOAD_COMMAND ""
    DEPENDS flann-fetch
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${EXTERNAL_BUILD_TYPE}
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_EXAMPLES:BOOL=OFF
      -DBUILD_PYTHON_BINDINGS:BOOL=OFF
      -DBUILD_MATLAB_BINDINGS:BOOL=OFF
  )

  add_to_env(${proj}/lib)
  force_build(${proj})
endmacro()