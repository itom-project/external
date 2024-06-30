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

#https://www.emva.org/standards-technology/genicam/genicam-downloads-archive%20/

#
# GenICam fetch
#
macro(fetch_genicam)
  ExternalProject_Add(
    genicam-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/genicam
    URL ${EXTERNAL_REPO_GENICAM}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()

#
# GenICam compile
#
macro(compile_genicam)
  set(proj genicam-host)

  #[[
  set(GENICAM_NAME_TGZ GenICam_V3_4_1_1-)

    # let the preprocessor know about the system name
  if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(GENICAM_OS Linux)
  endif()
  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(GENICAM_OS Mac)
  if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(GENICAM_OS Win)
  endif()

  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(GENICAM_BITSIZE 64)
  elseif(NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(GENICAM_BITSIZE 32)
  endif(CMAKE_SIZEOF_VOID_P EQUAL 8)

  if(NOT APPLE)
    set(GENICAM_ARCH_REGEX "^.*-march[= ]([^ ]+).*$")
    string(REGEX MATCH "${GENICAM_ARCH_REGEX}" GENICAM_ARCH_MATCH ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS})
    if (GENICAM_ARCH_MATCH)
        string(REGEX REPLACE "${GENICAM_ARCH_REGEX}" "\\1" GENICAM_ARCH ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS})
    else()
        set(GENICAM_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
    endif()
  elseif(APPLE)
    set(GENICAM_ARCH ${OSX_ARCHITECTURES})
  endif(NOT APPLE)
  ]]

  #https://stackoverflow.com/questions/70475665/what-are-the-possible-values-of-cmake-system-processor
  #windows AMD64, IA64, ARM64, EM64T, X86
  #Appple x86_64, arm64, and powerpc
  #LINUX alpha,arc,arm,aarch64_be (arm64),aarch64 (arm64),armv8b (arm64 compat),armv8l (arm64 compat),blackfin,c6x,cris,frv,h8300,hexagon,ia64,m32r,m68k,
  # metag,microblaze,mips (native or compat),mips64 (mips),mn10300,nios2,openrisc,parisc (native or compat),parisc64 (parisc),ppc (powerpc native or compat),ppc64 (powerpc),
  # ppcle (powerpc native or compat), ppc64le (powerpc), s390 (s390x compat), s390x, score, sh, sh64 (sh), sparc (native or compat), sparc64 (sparc), tile, unicore32
  # i386 (x86), i686 (x86 compat), x86_64 (x64), xtensa, armv7l (RaspberyPi4 arm32)

  set(GENICAM_RUNTIME_TGZ GenICam_V3_4_1_1-Linux64_x64_gcc48-Runtime.tgz)
  set(GENICAM_SDK_TGZ GenICam_V3_4_1_1-Linux64_x64_gcc48-SDK.tgz)
  
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/genicam
    BINARY_DIR ${EXTERNAL_BUILD_PREFIX}/genicam-host
    DOWNLOAD_COMMAND ""
    DEPENDS genicam-fetch
    #CMAKE_ARGS
    #  -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_INSTALL_PREFIX}/${proj}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${CMAKE_COMMAND} -E tar xfz "${EXTERNAL_SOURCE_PREFIX}/genicam/Reference Implementation/${GENICAM_RUNTIME_TGZ}"
    COMMAND ${CMAKE_COMMAND} -E tar xfz "${EXTERNAL_SOURCE_PREFIX}/genicam/Reference Implementation/${GENICAM_SDK_TGZ}"
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${EXTERNAL_BUILD_PREFIX}/genicam-host/ ${EXTERNAL_INSTALL_PREFIX}/genicam-host
    #INSTALL_COMMAND ${CMAKE_COMMAND} -E tar xfz "${EXTERNAL_SOURCE_PREFIX}/genicam/Reference Implementation/${GENICAM_SDK_TGZ}"
  )
  #add_to_env(${proj}/lib)
  #force_build(${proj})
  
endmacro()