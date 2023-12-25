
# - itom software
# URL: http://www.uni-stuttgart.de/ito
# Copyright (C) 2020, Institut fuer Technische Optik (ITO),
# Universitaet Stuttgart, Germany
#
# This file is part of itom and its software development toolkit (SDK).
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
# force build macro
#
macro(add_to_env proj_lib_path)
  #[[
  add_custom_target( EXTERNAL_ADD2ENV_${proj} ALL
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/external/script/external_add_to_env.sh "${EXTERNAL_INSTALL_PREFIX}/${proj}/lib"
    COMMENT "Add Boost Libraries to System Path"
  )
  add_custom_target(TARGET ${proj}
    PRE_BUILD
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/external/script/external_add_to_env.sh
    ARGS "${EXTERNAL_INSTALL_PREFIX}/${proj}/lib"
    COMMENT "Add Project ${proj} Boost Libraries to System Path."
  )
  ]]
  execute_process( COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/external/script/external_add_to_env.sh "${EXTERNAL_INSTALL_PREFIX}/${proj_lib_path}" )
  
endmacro()

#
# force build macro
#
macro(force_build proj)
  ExternalProject_Add_Step(${proj} forcebuild
    COMMAND ${CMAKE_COMMAND} -E remove ${base}/Stamp/${proj}/${proj}-build
    DEPENDEES configure
    DEPENDERS build
    ALWAYS 1
  )
endmacro()

macro(get_toolchain_file tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(toolchain_file ${toolchain_${tag_with_underscore}})
endmacro()

macro(get_try_run_results_file tag)
  string(REPLACE "-" "_" tag_with_underscore ${tag})
  set(try_run_results_file ${try_run_results_${tag_with_underscore}})
endmacro()



include(macros/external-macro-ffmpeg)
include(macros/external-macro-gstreamer)
include(macros/external-macro-opencv)

include(macros/external-macro-qt)
include(macros/external-macro-glew)
include(macros/external-macro-eigen)
include(macros/external-macro-vtk)
include(macros/external-macro-flann)
include(macros/external-macro-pcap)
include(macros/external-macro-qhull)
include(macros/external-macro-boost)
include(macros/external-macro-pcl)


# macro to find programs on the host OS
macro( find_host_program )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER )
 if( CMAKE_HOST_WIN32 )
  SET( WIN32 1 )
  SET( UNIX )
 elseif( CMAKE_HOST_APPLE )
  SET( APPLE 1 )
  SET( UNIX )
 endif()
 find_program( ${ARGN} )
 SET( WIN32 )
 SET( APPLE )
 SET( UNIX 1 )
 set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
 set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
endmacro()
