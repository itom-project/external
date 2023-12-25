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
# Qt fetch
#
macro(fetch_qt)
  ExternalProject_Add(
    qt-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/qt
    GIT_REPOSITORY ${EXTERNAL_REPO_QT}
    GIT_TAG v${EXTERNAL_VERSION_QT}
    GIT_SUBMODULES ${EXTERNAL_QT_MODULES}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
endmacro()


#
# Qt compile
#
macro(compile_qt)
  set(proj qt-host)
  list(JOIN EXTERNAL_QT_MODULES ", " EXTERNAL_QT_MODULES_JOINED)
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/qt
    DOWNLOAD_COMMAND ""
    DEPENDS qt-fetch
    CONFIGURE_COMMAND ${EXTERNAL_SOURCE_PREFIX}/qt/configure
      -xcb
      -xcb-xlib
      #-bundled-xcb-input
      -submodules ${EXTERNAL_QT_MODULES_JOINED}
      -prefix ${EXTERNAL_INSTALL_PREFIX}/qt-host
      -release
      -shared
    BUILD_COMMAND cmake --build ${EXTERNAL_BUILD_PREFIX}/qt-host -j8
    INSTALL_COMMAND cmake --install ${EXTERNAL_BUILD_PREFIX}/qt-host 
  )

  add_to_env(${proj}/lib)
  set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${EXTERNAL_INSTALL_PREFIX}/qt-host)

endmacro()