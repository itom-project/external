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
# GLEW fetch
#
macro(fetch_glew)
    ExternalProject_Add(
        glew-fetch
        SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/glew
        URL ${EXTERNAL_REPO_GLEW}
        URL_MD5 ""
        DOWNLOAD_EXTRACT_TIMESTAMP ON
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND cmake -E echo "Skipping install step."#${CMAKE_COMMAND}
    )
endmacro()


#
# GLEW compile
#
macro(compile_glew)
  set(proj glew-host)

  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/glew
    DOWNLOAD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS glew-fetch
    CONFIGURE_COMMAND
    SOURCE_SUBDIR ./build/cmake
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/${proj}
      -DCMAKE_BUILD_TYPE:STRING=${EXTERNAL_BUILD_TYPE}
      #-DBUILD_SHARED_LIBS:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      #-DBUILD_TESTING:BOOL=OFF
    INSTALL_COMMAND make install
  )
  add_to_env(${proj}/lib)
  force_build(${proj})
endmacro()
