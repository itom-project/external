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

# Resources and Instructions: https://www.tcpdump.org/

#
# python fetch
#
macro(fetch_python)
  ExternalProject_Add(
    python-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/python
    GIT_REPOSITORY ${EXTERNAL_REPO_PYTHON}
    GIT_TAG v${EXTERNAL_VERSION_PYTHON}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()


#
# python compile
#
macro(compile_python)
  set(proj python-host)
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/python
    BINARY_DIR ${EXTERNAL_BUILD_PREFIX}/python-host
    DOWNLOAD_COMMAND ""
    DEPENDS python-fetch
    CONFIGURE_COMMAND ${EXTERNAL_SOURCE_PREFIX}/python/configure
      --prefix ${EXTERNAL_INSTALL_PREFIX}/python-host
      --enable-optimizations
    BUILD_COMMAND make -j8
    INSTALL_COMMAND make install
  )
  add_to_env(${proj}/lib)
  force_build(${proj})
endmacro()