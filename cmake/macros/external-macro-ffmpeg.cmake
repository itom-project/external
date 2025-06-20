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
# along with itom. If not, see <http://www.gnu.org/licenses/>.

#https://github.com/Kitware/fletch/blob/master/CMake/External_FFmpeg.cmake
#https://github.com/m-ab-s/media-autobuild_suite

#
# ffmpeg fetch
#
if( WIN32 )
  macro(fetch_ffmpeg)
    ExternalProject_Add(
      ffmpeg-fetch
      SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/ffmpeg
      GIT_REPOSITORY ${EXTERNAL_REPO_FFMPEG_WIN}
      GIT_SHALLOW TRUE
      GIT_PROGRESS TRUE
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND "")
  endmacro()
else( WIN32 )
  macro(fetch_ffmpeg)
    ExternalProject_Add(
      ffmpeg-fetch
      SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/ffmpeg
      GIT_REPOSITORY ${EXTERNAL_REPO_FFMPEG_UNIX}
      GIT_TAG n${EXTERNAL_VERSION_FFMPEG}
      GIT_SHALLOW TRUE
      GIT_PROGRESS TRUE
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND "")
  endmacro()
endif( WIN32 )

#
# FFmpeg compile
#
macro(compile_ffmpeg)
  set(proj ffmpeg-host)
  set(FFMPEG_PRIVATE_LIBRARY_PATH "home/user/local/lib")
  set(FFMPEG_PRIVATE_PKG_CONFIG "home/user/local/pkgconfig")
  
  if( WIN32 )
    #set( EXTERNAL_REPO_FFMPEG ${EXTERNAL_REPO_FFMPEG_WIN})
    # setup autobuild here
    set( FFMPEG_Autobuild_Command ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/media-autobuild_suite.bat )
    #execute_process(COMMAND cmd.exe /C ${FFMPEG_Autobuild_Command})
    #execute_process(COMMAND cmd.exe echo "Hello World!")
    
    ExternalProject_Add(ffmpeg
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/ffmpeg
    BUILD_IN_SOURCE 1   # Currently only Build in Source is runnig.
    DOWNLOAD_COMMAND ""
    DEPENDS ffmpeg-fetch
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E echo "Skipping configure step."
    BUILD_COMMAND  ${CMAKE_COMMAND} -E echo "Skipping build step."
    INSTALL_COMMAND ${CMAKE_COMMAND} -E echo "Skipping install step."
    )

    #set( FFMPEG_Autobuild_Command "${EXTERNAL_SOURCE_PREFIX}/ffmpeg/media-autobuild_suite.bat")
    set( FFMPEG_Autobuild_File_ini_In ${CMAKE_CURRENT_LIST_DIR}/cmake/patches/media-autobuild_suite.ini )
    set( FFMPEG_Autobuild_File_ini_OUT ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/build/media-autobuild_suite.ini )
    set( FFMPEG_Autobuild_File_ffmpeg_In ${CMAKE_CURRENT_LIST_DIR}/cmake/patches/ffmpeg_options.txt )
    set( FFMPEG_Autobuild_File_ffmpeg_OUT ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/build/ffmpeg_options.txt )
    set( FFMPEG_Autobuild_File_mpv_In ${CMAKE_CURRENT_LIST_DIR}/cmake/patches/mpv_options.txt )
    set( FFMPEG_Autobuild_File_mpv_OUT ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/build/mpv_options.txt )

    #configure_file( ${CMAKE_CURRENT_LIST_DIR}/cmake/patches/media-autobuild_suite.ini ${EXTERNAL_SOURCE_PREFIX}/ffmpeg/build/media-autobuild_suite.ini @ONLY)

    add_custom_command(
        TARGET  ffmpeg
        PRE_BUILD 
        #OUTPUT ${FFMPEG_Autobuild_File_ini_OUT}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${FFMPEG_Autobuild_File_ini_In}
                ${FFMPEG_Autobuild_File_ini_OUT}
        #DEPENDS ${FFMPEG_Autobuild_File_ini_In} ${compile_ffmpeg}
        COMMENT "Copying media-autobuild_suite.ini"
    )

    add_custom_command(
        TARGET  ffmpeg
        PRE_BUILD 
        #OUTPUT ${FFMPEG_Autobuild_File_ffmpeg_OUT}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${FFMPEG_Autobuild_File_ffmpeg_In}
                ${FFMPEG_Autobuild_File_ffmpeg_OUT}
        #DEPENDS ${FFMPEG_Autobuild_File_ffmpeg_In} ${compile_ffmpeg}
        COMMENT "Copying ffmpeg_options.txt"
    )

    add_custom_command(
        TARGET  ffmpeg
        PRE_BUILD 
        #OUTPUT ${FFMPEG_Autobuild_File_mpv_OUT}
        COMMAND ${CMAKE_COMMAND} -E copy
                ${FFMPEG_Autobuild_File_mpv_In}
                ${FFMPEG_Autobuild_File_mpv_OUT}
        COMMAND start "" cmd.exe /k echo "Hello World"
        #COMMAND start "" cmd.exe /k set CL= && set LINK= && set INCLUDE= && set LIB= &&> ${FFMPEG_Autobuild_Command}
        #COMMAND start powershell -Verb RunAs /k ${FFMPEG_Autobuild_Command}
        #DEPENDS ${FFMPEG_Autobuild_File_mpv_In} ${compile_ffmpeg}
        COMMENT "Copying ffmpeg_options.txt"
    )

    execute_process(COMMAND start "" cmd.exe /k echo "Hello World")

    #COMMAND start "" cmd.exe /k ${FFMPEG_Autobuild_Command}

    # set VCINSTALLDIR= && set VSINSTALLDIR= && set VisualStudioVersion= && set VSCMD_ARG_TGT_ARCH= && set VSCMD_VER= && set VSCMD_ARG_HOST_ARCH= && set VSCMD_ARG_APP_PLAT= && set VSCMD_SKIP_SENDTELEMETRY= && set ExtensionSdkDir= && set WindowsSdkDir= && set WindowsLibPath= && set WindowsSdkVersion= && set WindowsSdkBinPath= && set WindowsSdkIncludePath= && set WindowsSdkLibVersion= && set UniversalCRTSdkDir= && set INCLUDE= && set LIB= && set LIBPATH= && set PATH= && 
    # "C:\Windows\System32;C:\Windows"
    #[[
    add_custom_command(
    OUTPUT open_cmd_trigger.txt
    COMMAND cmake -E echo "Launching CMD..." > open_cmd_trigger.txt
    COMMAND start "" cmd.exe /k ${FFMPEG_Autobuild_Command}
    COMMENT "Opening a new Command Prompt window"
    )
    ]]

    #[[
    add_custom_command(
    TARGET  ffmpeg
    PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Launching CMD..."
    COMMAND start "" cmd.exe /k echo "Hellow World"
    #DEPENDS ${compile_ffmpeg}
    COMMENT "Opening a new Command Prompt window"
    )
    ]]

    #"${FFMPEG_Autobuild_Command}

    #add_custom_target(ffmpeg_custom_run ALL
    #DEPENDS ${FFMPEG_Autobuild_File_ini_OUT} ${FFMPEG_Autobuild_File_ffmpeg_OUT} ${FFMPEG_Autobuild_File_mpv_OUT} run_autobuild_cmd.txt
    #)

    #
    #BUILD_COMMAND  ${CMAKE_COMMAND} -E echo "Launching CMD..." &&
    #              cmd.exe /C ${FFMPEG_Autobuild_Command}

    message(STATUS "FFmpeg: Using Windows autobuild repository")
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