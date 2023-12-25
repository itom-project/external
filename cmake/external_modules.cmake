
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

#FFmpeg
list(JOIN EXTERNAL_FFMEPG_FIND_COMPONENTS ", " EXTERNAL_FFMEPG_MODULES)

#QT
set(EXTERNAL_QT_MODULES
  qtbase
  qtsvg
  qtdeclarative
  qtactiveqt
  qtmultimedia
  qttools
  qtxmlpatterns
  qttranslations
  qtdoc
  qtrepotools
  qtqa
  qtlocation
  #qtpositioning
  qtsensors
  qtsystems
  qtfeedback
  qtpim
  qtconnectivity
  qtwayland
  qt3d
  qtimageformats
  qtserialbus
  qtserialport
  qtwebsockets
  qtwebchannel
  qtwebengine
  qtcanvas3d
  qtwebview
  qtcharts
  qtdatavis3d
  qtvirtualkeyboard
  qtgamepad
  qtscxml
  qtspeech
  qtnetworkauth
  qtremoteobjects
  qtwebglplugin
  qtlottie
  qtquicktimeline
  qtquick3d
  qtshadertools
  qt5compat
  qtcoap
  qtmqtt
  qtopcua
  qtlanguageserver
  qthttpserver
  qtquick3dphysics
  qtgrpc
  qtquickeffectmaker
)


#BOOST
list(JOIN EXTERNAL_BOOST_FIND_COMPONENTS ", " EXTERNAL_BOOST_MODULES)


#VTK
set(VTK_MODULE_DEFAULTS
  -DVTK_Group_StandAlone:BOOL=OFF
  -DVTK_Group_Rendering:BOOL=OFF
  -DModule_vtkFiltersCore:BOOL=ON
  -DModule_vtkFiltersModeling:BOOL=ON
  -DModule_vtkFiltersSources:BOOL=ON
  -DModule_vtkFiltersGeometry:BOOL=ON
  -DModule_vtkIOGeometry:BOOL=ON
  -DModule_vtkIOLegacy:BOOL=ON
  -DModule_vtkIOXML:BOOL=ON
  -DModule_vtkIOImage:BOOL=ON
  -DModule_vtkIOPLY:BOOL=ON
  -DModule_vtkIOInfovis:BOOL=ON
  -DModule_vtkImagingCore:BOOL=ON
  -DModule_vtkParallelCore:BOOL=ON
  -DModule_vtkRenderingCore:BOOL=ON
  -DModule_vtkRenderingFreeType:BOOL=ON
)


#PCL
set(PCL_MODULE_DEFAULTS
      -DBUILD_common:BOOL=ON
      -DBUILD_features:BOOL=ON
      -DBUILD_filters:BOOL=ON
      -DBUILD_global_tests:BOOL=OFF # PROBLEM
      -DBUILD_io:BOOL=ON
      -DBUILD_kdtree:BOOL=ON
      -DBUILD_keypoints:BOOL=ON
      -DBUILD_octree:BOOL=ON # PROBLEM
      -DBUILD_range_image:BOOL=ON
      -DBUILD_registration:BOOL=ON
      -DBUILD_sample_consensus:BOOL=ON
      -DBUILD_segmentation:BOOL=ON
      -DBUILD_surface:BOOL=ON
      -DBUILD_visualization:BOOL=ON
      -DBUILD_examples:BOOL=ON
      -DBUILD_tools:BOOL=ON
      -DBUILD_apps:BOOL=ON
      -DWITH_PCAP:BOOL=ON
      -DWITH_QT:BOOL=OFF # PROBLEM
)