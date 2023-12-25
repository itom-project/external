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


#find_package(OpenCV ${EXTERNAL_VERSION_OPENCV} ${EXTERNAL_MODULES_OPENCV} REQUIRED)
find_package(Qt6 ${EXTERNAL_VERSION_QT} COMPONENTS ${EXTERNAL_QT_FIND_COMPONENTS} REQUIRED)
message(STATUS "Qt6_FOUND: ${Qt6_FOUND}")

qt_standard_project_setup()
#find_package(Eigen3 ${EXTERNAL_VERSION_EIGEN} ${EXTERNAL_MODULES_EIGEN} REQUIRED)
#find_package(Boost ${EXTERNAL_VERSION_BOOST} ${EXTERNAL_MODULES_BOOST} REQUIRED)
#find_package(FLANN ${EXTERNAL_VERSION_FLANN} ${EXTERNAL_MODULES_FLANN} REQUIRED)
#find_package(GLEW ${EXTERNAL_VERSION_GLEW} ${EXTERNAL_MODULES_GLEW} REQUIRED)
#find_package(VTK ${EXTERNAL_VERSION_VTK} ${EXTERNAL_MODULES_VTK} REQUIRED)
#find_package(PCL ${EXTERNAL_VERSION_PCL} ${EXTERNAL_MODULES_PCL} REQUIRED)