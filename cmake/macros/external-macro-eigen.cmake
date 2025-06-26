# - itom software - 
# URL: http://www.uni-stuttgart.de/ito
# Copyright (C) 2023, Institut fuer Technische Optik (ITO),
# Universitaet Stuttgart, Germany
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

#
# Eigen fetch
#
macro(fetch_eigen)
  ExternalProject_Add(
    eigen-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/eigen
    GIT_REPOSITORY ${EXTERNAL_REPO_EIGEN}
    GIT_TAG ${EXTERNAL_VERSION_EIGEN}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
    CMAKE_ARGS
      -DEIGEN_MPL2_ONLY
  )
endmacro()


#
# EIGEN compile
#
macro(compile_eigen)
  set(proj eigen-host)
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/eigen
    DOWNLOAD_COMMAND ""
    DEPENDS eigen-fetch
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/${proj}
    CONFIGURE_COMMAND
    BUILD_COMMAND
    INSTALL_COMMAND cmake --install .
  )

  force_build(${proj})
endmacro()
