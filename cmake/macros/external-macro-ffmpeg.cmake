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

#https://github.com/Kitware/fletch/blob/master/CMake/External_FFmpeg.cmake

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
    INSTALL_COMMAND ""
  )
endmacro()

#
# FFmpeg compile
#
macro(compile_ffmpeg)
  set(proj ffmpeg-host)
  set(FFMPEG_PRIVATE_LIBRARY_PATH "home/user/local/lib")
  set(FFMPEG_PRIVATE_PKG_CONFIG "home/user/local/pkgconfig")

  if(NOT (EXISTS ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/config.h))
    set(FFMPEG_CONFIGURE_COMMAND ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/configure)
    set(FFMPEG_DEBUG_CONFIGURE_ARGS
      --prefix=${EXTERNAL_INSTALL_PREFIX}/${proj}
      #--enable-nonfree
      #--enable-gpl
      #--enable-version3
      #--enable-libmp3lame
      #--enable-libvpx
      #--enable-libopus
      #--enable-opencl
      #--enable-libxcb
      #--enable-opengl
      #--enable-nvenc
      #--enable-vaapi
      #--enable-vdpau 
      #--enable-ffplay
      #--enable-ffprobe
      #--enable-libxvid 
      #-enable-libx264
      #--enable-libx265
      #--enable-openal
      #--enable-openssl
      #--enable-cuda-nvcc
      #--enable-cuvid
      #--extra-cflags=-I/usr/local/cuda/include
      #--extra-ldflags=-L/usr/local/cuda/lib64
      #--nvccflags="-gencode arch=compute_52,code=sm_52 -O2"
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
    CONFIGURE_COMMAND export LD_LIBRARY_PATH=${FFMPEG_PRIVATE_LIBRARY_PATH} PKG_CONFIG_PATH=${FFMPEG_PRIVATE_PKG_CONFIG}/usr/lib/pkgconfig && ${FFMPEG_CONFIGURE_COMMAND} ${FFMPEG_DEBUG_CONFIGURE_ARGS}
    BUILD_COMMAND export LD_LIBRARY_PATH=${FFMPEG_PRIVATE_LIBRARY_PATH} PKG_CONFIG_PATH=${FFMPEG_PRIVATE_PKG_CONFIG}/usr/lib/pkgconfig && make -j8
    BINARY_DIR ${EXTERNAL_BUILD_PREFIX}/${proj}
    INSTALL_COMMAND make install
    )

  add_to_env(${proj}/lib)
  ExternalProject_Add_StepTargets(ffmpeg install)
  set(EXTERNAL_DEPENDENCY_OPENCV ${EXTERNAL_DEPENDENCY_OPENCV} ffmpeg-install)

endmacro()