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

# https://github.com/smfrpc/smf/blob/master/CMakeLists.txt.in

#
# Gstreamer fetch
#
macro(fetch_gstreamer)
  ExternalProject_Add(
    gstreamer-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/gstreamer
    GIT_REPOSITORY ${EXTERNAL_REPO_GSTREAMER}
    GIT_TAG ${EXTERNAL_VERSION_GSTREAMER}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()

#
# Gstreamer compile
#
macro(compile_gstreamer)
  set(proj gstreamer-host)

  find_program(Meson_EXECUTABLE meson)
  if(NOT Meson_EXECUTABLE)
    message(FATAL_ERROR "Cooking: Meson is required!")
  endif()

  find_program(Ninja_EXECUTABLE ninja)
  if(NOT Ninja_EXECUTABLE)
    message(FATAL_ERROR "Cooking: Ninja is required!")
  endif()

  #set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${EXTERNAL_INSTALL_PREFIX}/${proj}/lib/x86_64-linux-gnu/pkgconfig")

  
  set(GSTREAMER_ARGS
  -Dpython=disabled
  -Dlibav=disabled
  -Dlibnice=disabled
  -Dbase=enabled
  -Dgood=enabled
  -Dugly=disabled
  -Dbad=disabled
  -Ddevtools=disabled
  -Dges=disabled
  -Drtsp_server=disabled
  -Domx=disabled
  -Dvaapi=disabled
  -Dsharp=disabled
  -Drs=disabled
  -Dgst-examples=disabled
  -Dtls=disabled
  -Dqt5=disabled
  -Dtools=disabled)

  ExternalProject_Add(gstreamer
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/gstreamer
    DOWNLOAD_COMMAND ""
    DEPENDS gstreamer-fetch
    CONFIGURE_COMMAND
    #${Meson_EXECUTABLE} --prefix=${EXTERNAL_INSTALL_PREFIX}/${proj} ${EXTERNAL_BUILD_PREFIX}/${proj}  ${EXTERNAL_SOURCE_PREFIX}/gstreamer
    ${Meson_EXECUTABLE} setup ${GSTREAMER_ARGS} --prefix=${EXTERNAL_INSTALL_PREFIX}/${proj} ${EXTERNAL_BUILD_PREFIX}/${proj}  ${EXTERNAL_SOURCE_PREFIX}/gstreamer
    BUILD_COMMAND
      ${Ninja_EXECUTABLE} -C ${EXTERNAL_BUILD_PREFIX}/${proj}
    INSTALL_COMMAND
      ${Ninja_EXECUTABLE} -C ${EXTERNAL_BUILD_PREFIX}/${proj} install)

  add_to_env(${proj}/lib/x86_64-linux-gnu)
  ExternalProject_Add_StepTargets(gstreamer install)
  set(EXTERNAL_DEPENDENCY_OPENCV ${EXTERNAL_DEPENDENCY_OPENCV} gstreamer-install)
endmacro()

#env CC=@CMAKE_C_COMPILER@ ${Meson_EXECUTABLE} ${dpdk_args} --prefix=${EXTERNAL_INSTALL_PREFIX}/${proj} ${EXTERNAL_BUILD_PREFIX}/${proj}  ${EXTERNAL_SOURCE_PREFIX}/gstreamer