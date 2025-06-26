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

#https://doc.qt.io/qt-6/qtmultimedia-building-ffmpeg-windows.html
#C:\msys64\usr\bin\mintty.exe /usr/bin/env MSYSTEM=MINGW64 /bin/bash -l
# Alternative: C:\msys64\mingw64.exe

#https://github.com/Kitware/fletch/blob/master/CMake/External_FFmpeg.cmake
#https://github.com/m-ab-s/media-autobuild_suite

#
# ffmpeg fetch
#
macro(fetch_ffmpeg)
  ExternalProject_Add(
    ffmpeg-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/ffmpeg
    GIT_REPOSITORY ${EXTERNAL_REPO_FFMPEG}
    GIT_TAG n${EXTERNAL_VERSION_FFMPEG}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND "")
endmacro()

#
# FFmpeg compile
#
macro(compile_ffmpeg)
  set(proj ffmpeg-host)
  set(FFMPEG_PRIVATE_LIBRARY_PATH "home/user/local/lib")
  set(FFMPEG_PRIVATE_PKG_CONFIG "home/user/local/pkgconfig")
  
  if( WIN32 )
    set( FFMPEG_MSYS2_SHELL "C:/msys64/msys2_shell.cmd")  # Or bash.exe from Git
    set( FFMPEG_MSYS2_Configure ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/configure --prefix=${EXTERNAL_INSTALL_PREFIX}/${proj} --disable-doc --enable-network --enable-shared --toolchain=msvc)
    set( FFMPEG_MSYS2_Make make -j install)

    ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/ffmpeg
    BUILD_IN_SOURCE 1   # Currently only Build in Source is runnig.
    DOWNLOAD_COMMAND ""
    DEPENDS ffmpeg-fetch
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Skipping configure step."
    BUILD_COMMAND  ${FFMPEG_MSYS2_SHELL} -mingw64 -full-path -c "cd '${EXTERNAL_BUILD_PREFIX}/${proj}' && ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/configure --prefix=${EXTERNAL_INSTALL_PREFIX}/${proj} --disable-doc --enable-network --enable-shared --toolchain=msvc && make -j install && exit; exec /bin/sh"
    INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "Skipping install step."
    )

  else( WIN32 )
  
    if(NOT (EXISTS ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/config.h))
      set(FFMPEG_CONFIGURE_SCRIPT ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/configure)
      set( FFMPEG_CONFIGURE_COMMAND export LD_LIBRARY_PATH=${FFMPEG_PRIVATE_LIBRARY_PATH} PKG_CONFIG_PATH=${FFMPEG_PRIVATE_PKG_CONFIG}/usr/lib/pkgconfig && ${FFMPEG_CONFIGURE_SCRIPT} ${FFMPEG_DEBUG_CONFIGURE_ARGS})
      set( FFMPEG_BUILD_COMMAND export LD_LIBRARY_PATH=${FFMPEG_PRIVATE_LIBRARY_PATH} PKG_CONFIG_PATH=${FFMPEG_PRIVATE_PKG_CONFIG}/usr/lib/pkgconfig && cmake --build --parallel 8)
      set( FFMPEG_INSTALL_COMMAND cmake --install ${EXTERNAL_BUILD_PREFIX}/ffmpeg-host )
      
      set(FFMPEG_DEBUG_CONFIGURE_ARGS
        --prefix=${EXTERNAL_INSTALL_PREFIX}/${proj}
        --enable-x86asm
        --disable-doc
        --extra-libs=-lpthread
        --extra-libs=-ldl
        --enable-nonfree
        --enable-pic
        --enable-shared
        --enable-static
        --enable-gpl 
        --enable-libx264
        --enable-libx265
        --disable-avx512
        --disable-optimizations
        --extra-cflags=-g3
        --extra-cflags=-fno-omit-frame-pointer
        --enable-debug=3
        --extra-cflags=-fno-inline
        --disable-stripping)
    endif(NOT (EXISTS ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/config.h))
    
    ExternalProject_Add(ffmpeg
      SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/ffmpeg
      DOWNLOAD_COMMAND ""
      DEPENDS ffmpeg-fetch
      CONFIGURE_COMMAND ${FFMPEG_CONFIGURE_COMMAND}
      BUILD_COMMAND ${FFMPEG_BUILD_COMMAND}
      BINARY_DIR ${EXTERNAL_BUILD_PREFIX}/${proj}
      INSTALL_COMMAND ${FFMPEG_INSTALL_COMMAND}
      )

  add_to_env(${proj}/lib)
  ExternalProject_Add_StepTargets(ffmpeg install)
  set(EXTERNAL_DEPENDENCY_OPENCV ${EXTERNAL_DEPENDENCY_OPENCV} ffmpeg-install)      
  
  endif( WIN32 )

endmacro()