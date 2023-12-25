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
# Boost fetch
#
macro(fetch_boost)
  ExternalProject_Add(
    boost-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/boost
    GIT_REPOSITORY ${EXTERNAL_REPO_BOOST}
    GIT_TAG boost-${EXTERNAL_VERSION_BOOST}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()

#
# Boost compile
#
macro(compile_boost)
  set(proj boost-host)

  # Boost Bootstrap
  set( Boost_Bootstrap_Command )
  if( UNIX )
    set( Boost_Bootstrap_Command ${EXTERNAL_SOURCE_PREFIX}/boost/bootstrap.sh )
    set( Boost_b2_Command ${EXTERNAL_SOURCE_PREFIX}/boost/b2 )
  else()
    if( WIN32 )
      set( Boost_Bootstrap_Command ${EXTERNAL_SOURCE_PREFIX}/boost/bootstrap.bat )
      set( Boost_b2_Command ${EXTERNAL_SOURCE_PREFIX}/boost/b2.exe )
    endif()
  endif()


  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/boost
    BUILD_IN_SOURCE 1   # Currently only Build in Source is runnig.
    DOWNLOAD_COMMAND ""
    DEPENDS boost-fetch
    CONFIGURE_COMMAND ${Boost_Bootstrap_Command} --prefix=${EXTERNAL_INSTALL_PREFIX}/boost-host --with-libraries=${EXTERNAL_BOOST_MODULES}
    BUILD_COMMAND  ${Boost_b2_Command} install
      #--without-python
      #--without-mpi
      #--disable-icu
      --threading=single,multi
      #--link=static
      --link=shared
      --variant=${EXTERNAL_BUILD_TYPE}
      -j8
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
  add_to_env(${proj}/lib)
endmacro()
