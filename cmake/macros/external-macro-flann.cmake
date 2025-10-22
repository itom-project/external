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

#winget install pkg-config

#[[
build flann using msys

pacman -Syu  # update system (do this twice as prompted)
pacman -S git base-devel \
  mingw-w64-x86_64-toolchain \
  mingw-w64-x86_64-cmake \
  mingw-w64-x86_64-pkg-config \
  mingw-w64-x86_64-lz4

git clone https://github.com/flann-lib/flann.git
cd flann
mkdir build
cd build

cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/your/custom/path

make -j$(nproc)

make install

]]

set(test ${CMAKE_GENERATOR_PLATFORM})
set(test2 ${MSVC_VERSION})
set(test3 ${CMAKE_GENERATOR})


macro(compile_flann)
  set(proj flann-host)

  if( WIN32 )
    set( FLANN_MSYS2_SHELL "C:/msys64/msys2_shell.cmd")  # Or bash.exe from Git
    set( FLANN_MSYS2_Configure ${EXTERNAL_SOURCE_PREFIX}/flann -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_PREFIX}/${proj} 
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DBUILD_EXAMPLES:BOOL=OFF
        -DBUILD_PYTHON_BINDINGS:BOOL=OFF
        -DBUILD_MATLAB_BINDINGS:BOOL=OFF)
    set( FLANN_MSYS2_Make make -j install)

    ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/flann
    DOWNLOAD_COMMAND ""
    DEPENDS flann-fetch
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Skipping configure step."
    #BUILD_COMMAND ${FLANN_MSYS2_SHELL} -mingw64 -no-start -defterm -c "echo Hello && exec bash"
    BUILD_COMMAND  ${FLANN_MSYS2_SHELL} -mingw64 -c "cd '${EXTERNAL_BUILD_PREFIX}/${proj}' && echo ${EXTERNAL_SOURCE_PREFIX}/flann -G Unix Makefiles -DCMAKE_INSTALL_PREFIX=${EXTERNAL_INSTALL_PREFIX}/${proj} -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS:BOOL=ON -DBUILD_EXAMPLES:BOOL=OFF -DBUILD_PYTHON_BINDINGS:BOOL=OFF -DBUILD_MATLAB_BINDINGS:BOOL=OFF && exec bash"
    INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "Skipping install step."
    )
    #&& make -j install; exec /bin/sh 
    #&& exec bash"
    #-full-path
    # && exit; exec /bin/sh"
  else( WIN32 )

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

  endif( WIN32 )

  add_to_env(${proj}/lib)
  force_build(${proj})
endmacro()