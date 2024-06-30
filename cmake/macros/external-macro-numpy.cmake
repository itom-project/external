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

# Resources and Instructions:
# https://gitlab.kitware.com/paraview/paraview/-/blob/66db4465f412175033bf419892ff1dc942244aa5/SuperBuild/External_NUMPY.cmake
# /home/bber/Code/paraview-superbuild/superbuild/projects/numpy.cmake


#
# numpy fetch
#
macro(fetch_numpy)
  ExternalProject_Add(
    numpy-fetch
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/numpy
    GIT_REPOSITORY ${EXTERNAL_REPO_NUMPY}
    GIT_TAG v${EXTERNAL_VERSION_NUMPY}
    GIT_SHALLOW TRUE
    GIT_PROGRESS TRUE
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND cmake -E echo "Skipping install step."
  )
endmacro()

# Check that a project name is valid.
#
# Currently "valid" means alphanumeric with a non-numeric prefix.
function (_superbuild_project_check_name name)
  if (NOT name MATCHES "^[a-zA-Z][a-zA-Z0-9]*$")
    message(FATAL_ERROR
      "Invalid project name: ${name}. Only alphanumerics are allowed.")
  endif ()
endfunction ()

macro(_ep_get_add_keywords out_var)
  set(${out_var}
    #
    # Directory options
    #
    PREFIX
    TMP_DIR
    STAMP_DIR
    LOG_DIR
    DOWNLOAD_DIR
    SOURCE_DIR
    BINARY_DIR
    INSTALL_DIR
    #
    # Download step options
    #
    DOWNLOAD_COMMAND
    DOWNLOAD_DEPENDS
    #
    URL
    URL_HASH
    URL_MD5
    DOWNLOAD_NAME
    DOWNLOAD_NO_EXTRACT
    DOWNLOAD_NO_PROGRESS
    TIMEOUT
    INACTIVITY_TIMEOUT
    HTTP_USERNAME
    HTTP_PASSWORD
    HTTP_HEADER
    TLS_VERIFY     # Also used for git clone operations
    TLS_CAINFO
    NETRC
    NETRC_FILE
    #
    GIT_REPOSITORY
    GIT_TAG
    GIT_REMOTE_NAME
    GIT_SUBMODULES
    GIT_SUBMODULES_RECURSE
    GIT_SHALLOW
    GIT_PROGRESS
    GIT_CONFIG
    GIT_REMOTE_UPDATE_STRATEGY
    #
    SVN_REPOSITORY
    SVN_REVISION
    SVN_USERNAME
    SVN_PASSWORD
    SVN_TRUST_CERT
    #
    HG_REPOSITORY
    HG_TAG
    #
    CVS_REPOSITORY
    CVS_MODULE
    CVS_TAG
    #
    # Update step options
    #
    UPDATE_COMMAND
    UPDATE_DEPENDS
    UPDATE_DISCONNECTED
    #
    # Patch step options
    #
    PATCH_COMMAND
    PATCH_DEPENDS
    #
    # Configure step options
    #
    CONFIGURE_COMMAND
    CONFIGURE_DEPENDS
    CMAKE_COMMAND
    CMAKE_GENERATOR
    CMAKE_GENERATOR_PLATFORM
    CMAKE_GENERATOR_TOOLSET
    CMAKE_GENERATOR_INSTANCE
    CMAKE_ARGS
    CMAKE_CACHE_ARGS
    CMAKE_CACHE_DEFAULT_ARGS
    SOURCE_SUBDIR
    CONFIGURE_HANDLED_BY_BUILD
    #
    # Build step options
    #
    BUILD_COMMAND
    BUILD_DEPENDS
    BUILD_IN_SOURCE
    BUILD_ALWAYS
    BUILD_BYPRODUCTS
    #
    # Install step options
    #
    INSTALL_COMMAND
    INSTALL_DEPENDS
    #
    # Test step options
    #
    TEST_COMMAND
    TEST_DEPENDS
    TEST_BEFORE_INSTALL
    TEST_AFTER_INSTALL
    TEST_EXCLUDE_FROM_MAIN
    #
    # Logging options
    #
    LOG_DOWNLOAD
    LOG_UPDATE
    LOG_PATCH
    LOG_CONFIGURE
    LOG_BUILD
    LOG_INSTALL
    LOG_TEST
    LOG_MERGED_STDOUTERR
    LOG_OUTPUT_ON_FAILURE
    #
    # Terminal access options
    #
    USES_TERMINAL_DOWNLOAD
    USES_TERMINAL_UPDATE
    USES_TERMINAL_CONFIGURE
    USES_TERMINAL_BUILD
    USES_TERMINAL_INSTALL
    USES_TERMINAL_TEST
    #
    # Target options
    #
    DEPENDS
    EXCLUDE_FROM_ALL
    STEP_TARGETS
    INDEPENDENT_STEP_TARGETS
    #
    # Miscellaneous options
    #
    LIST_SEPARATOR
  )
endmacro()

function (_superbuild_remove_python_modules modules)
  if (NOT superbuild_build_phase)
    return ()
  endif ()

  set(main_python_package 0)
  if (current_project STREQUAL "python3")
    set(main_python_package 1)
  endif ()

  string(REPLACE ";" "${_superbuild_list_separator}" modules_escaped "${modules}")

  superbuild_project_add_step(remove-extra-modules
    COMMAND   "${CMAKE_COMMAND}"
              -Dinstall_dir=<INSTALL_DIR>
              "-Dpython_version=${superbuild_python_version}"
              "-Dwindows=${WIN32}"
              "-Dmain_python_package=${main_python_package}"
              "-Dmodules_to_remove=${modules_escaped}"
              -P "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/superbuild_remove_python_dirs.cmake"
    DEPENDEES install
    COMMENT   "removing extra modules from the ${_name} install"
    WORKING_DIRECTORY "<INSTALL_DIR>")
endfunction ()

function (superbuild_add_project name)
  _superbuild_project_check_name("${name}")

  set(can_use_system FALSE)
  set(must_use_system FALSE)
  set(allow_developer_mode FALSE)
  set(debuggable FALSE)
  set(default OFF)
  set(selectable FALSE)
  set(build_shared_libs_independent FALSE)
  set(help_string)
  set(depends)
  set(optional_depends)
  set(license_files)
  set(process_environment)
  set(spdx_license_identifier)
  set(spdx_copyright_text)
  set(spdx_custom_license_file)
  set(spdx_custom_license_name)

  set(ep_arguments)
  set(grab)

  _ep_get_add_keywords(keywords)

  message(STATUS "keywords: ${keywords}")

  list(APPEND keywords
    PROCESS_ENVIRONMENT)

  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "CAN_USE_SYSTEM")
      set(can_use_system TRUE)
      set(grab)
    elseif (arg STREQUAL "MUST_USE_SYSTEM")
      set(must_use_system TRUE)
      set(grab)
    elseif (arg STREQUAL "DEFAULT_ON")
      set(default ON)
      set(grab)
    elseif (arg STREQUAL "DEVELOPER_MODE")
      set(allow_developer_mode TRUE)
      set(grab)
    elseif (arg STREQUAL "DEBUGGABLE")
      set(debuggable TRUE)
      set(grab)
    elseif (arg STREQUAL "SELECTABLE")
      set(selectable TRUE)
      set(grab)
    elseif (arg STREQUAL "BUILD_SHARED_LIBS_INDEPENDENT")
      set(build_shared_libs_independent TRUE)
      set(grab)
    elseif (arg STREQUAL "HELP_STRING")
      set(grab help_string)
    elseif (arg STREQUAL "DEPENDS")
      set(grab depends)
    elseif (arg STREQUAL "DEPENDS_OPTIONAL")
      set(grab optional_depends)
    elseif (arg STREQUAL "LICENSE_FILES")
      set(grab license_files)
    elseif (arg STREQUAL "SPDX_LICENSE_IDENTIFIER")
      set(grab spdx_license_identifier)
    elseif (arg STREQUAL "SPDX_COPYRIGHT_TEXT")
      set(grab spdx_copyright_text)
    elseif (arg STREQUAL "SPDX_CUSTOM_LICENSE_FILE")
      set(grab spdx_custom_license_file)
    elseif (arg STREQUAL "SPDX_CUSTOM_LICENSE_NAME")
      set(grab spdx_custom_license_name)
    elseif (arg IN_LIST keywords)
      set(grab ep_arguments)
      list(APPEND ep_arguments
        "${arg}")
    elseif (grab)
      list(APPEND "${grab}"
        "${arg}")
    endif ()
  endforeach ()

  # Allow projects to override default values for args
  if (DEFINED "_superbuild_default_${name}")
    set(default "${_superbuild_default_${name}}")
  endif ()
  if (DEFINED "_superbuild_${name}_selectable")
    set(selectable "${_superbuild_${name}_selectable}")
  endif ()

  # Allow projects to override the help string specified in the project file.
  if (DEFINED "_superbuild_help_string_${name}")
    set(help_string "${_superbuild_help_string_${name}}")
  endif ()

  if (NOT help_string)
    set(help_string "Request to build project ${name}")
  endif ()

  if (superbuild_build_phase)
    # Build phase logic. This logic involves saving the final list of arguments
    # that will be passed through to `ExternalProject_add`. It also inspects
    # optional dependencies and adds them as real dependencies if they are
    # enabled.

    foreach (op_dep IN LISTS optional_depends)
      if (${op_dep}_enabled)
        list(APPEND ep_arguments
          DEPENDS "${op_dep}")
      endif ()
    endforeach ()

    get_property(all_projects GLOBAL
      PROPERTY superbuild_projects)
    set(missing_deps)
    set(missing_deps_optional)
    foreach (dep IN LISTS depends)
      if (NOT dep IN_LIST all_projects)
        list(APPEND missing_deps
          "${dep}")
      endif ()
    endforeach ()
    foreach (dep IN LISTS optional_depends)
      if (NOT dep IN_LIST all_projects)
        list(APPEND missing_deps_optional
          "${dep}")
      endif ()
    endforeach ()

    # Warn if optional dependencies are unknown.
    if (missing_deps_optional)
      string(REPLACE ";" ", " missing_deps_optional "${missing_deps_optional}")
      message(AUTHOR_WARNING "Optional dependencies for ${name} not found, is it in the list of projects?: ${missing_deps_optional}")
    endif ()
    # Error if required dependencies are unknown.
    if (missing_deps)
      string(REPLACE ";" ", " missing_deps "${missing_deps}")
      message(FATAL_ERROR "Dependencies for ${name} not found, is it in the list of projects?: ${missing_deps}")
    endif ()

    list(APPEND ep_arguments DEPENDS ${depends})
    set("${name}_arguments"
      "${ep_arguments}"
      PARENT_SCOPE)
  else ()
    # Scanning phase logic. This involves setting up global properties to
    # include the information required in later steps of the superbuild.

    option("ENABLE_${name}" "${help_string}" "${default}")
    # Set the TYPE because it is overrided to INTERNAL if it is required by
    # dependencies later.
    get_property(cache_var_exists CACHE "ENABLE_${name}" PROPERTY TYPE SET)
    if (cache_var_exists)
      set_property(CACHE "ENABLE_${name}" PROPERTY TYPE BOOL)
    endif ()
    set_property(GLOBAL APPEND
      PROPERTY
        superbuild_projects "${name}")

    if (can_use_system)
      set_property(GLOBAL
        PROPERTY
          "${name}_system" TRUE)
      if (USE_SYSTEM_${name})
        set(depends)
        set(depends_optional)
      endif ()
    endif ()

    if (must_use_system)
      set_property(GLOBAL
        PROPERTY
          "${name}_system_force" TRUE)
      set(depends)
      set(depends_optional)
    endif ()

    if (allow_developer_mode)
      set_property(GLOBAL
        PROPERTY
          "${name}_developer_mode" TRUE)
    endif ()

    if (debuggable)
      set_property(GLOBAL
        PROPERTY
          "${name}_debuggable" TRUE)
    endif ()

    if (selectable)
      set_property(GLOBAL
        PROPERTY
          "superbuild_has_selectable" TRUE)
      set_property(GLOBAL
        PROPERTY
          "${project}_selectable" TRUE)
    endif ()

    if (build_shared_libs_independent)
      set_property(GLOBAL
        PROPERTY
          "${name}_build_shared_libs_independent" TRUE)
    endif ()

    set_property(GLOBAL
      PROPERTY
        "${name}_depends" ${depends})
    set_property(GLOBAL
      PROPERTY
        "${name}_depends_optional" ${optional_depends})
    set_property(GLOBAL
      PROPERTY
        "${name}_license_files" ${license_files})
    string(REGEX REPLACE ";" " " spdx_license_identifier "${spdx_license_identifier}")
    set_property(GLOBAL
      PROPERTY
        "${name}_spdx_license_identifier" ${spdx_license_identifier})
    string(REGEX REPLACE ";" " " spdx_copyright_text "${spdx_copyright_text}")
    set_property(GLOBAL
      PROPERTY
        "${name}_spdx_copyright_text" ${spdx_copyright_text})
    set_property(GLOBAL
      PROPERTY
        "${name}_spdx_custom_license_file" ${spdx_custom_license_file})
    set_property(GLOBAL
      PROPERTY
        "${name}_spdx_custom_license_name" ${spdx_custom_license_name})
  endif ()
endfunction ()


macro (superbuild_add_project_python_pyproject _name)
  cmake_parse_arguments(_superbuild_add_project_python_pyproject
    "PYPROJECT_TOML_NO_WHEEL"
    "PACKAGE;SPDX_CUSTOM_LICENSE_FILE;SPDX_CUSTOM_LICENSE_NAME"
    "LICENSE_FILES;PROCESS_ENVIRONMENT;DEPENDS;DEPENDS_OPTIONAL;SPDX_LICENSE_IDENTIFIER;SPDX_COPYRIGHT_TEXT;REMOVE_MODULES"
    ${ARGN})

  if (NOT DEFINED _superbuild_add_project_python_pyproject_PACKAGE)
    message(FATAL_ERROR
      "Python requires that projects have a package specified")
  endif ()

  if (superbuild_build_phase AND NOT superbuild_python_pip)
    message(FATAL_ERROR
      "No `pip` available?")
  endif ()

  if (SUPERBUILD_SKIP_PYTHON_PROJECTS)
    superbuild_require_python_package("${_name}" "${_superbuild_add_project_python_pyproject_PACKAGE}")
  else ()
    if (WIN32)
      set(_superbuild_python_args
        --root=<INSTALL_DIR>
        "--prefix=Python")
    else ()
      set(_superbuild_python_args
        "--prefix=<INSTALL_DIR>")
    endif ()

    if (NOT _superbuild_add_project_python_pyproject_PYPROJECT_TOML_NO_WHEEL)
      list(APPEND _superbuild_add_project_python_pyproject_DEPENDS
        pythonwheel)
    endif ()

    superbuild_add_project("${_name}"
      BUILD_IN_SOURCE 1
      DEPENDS python3 ${_superbuild_add_project_python_pyproject_DEPENDS}
      DEPENDS_OPTIONAL ${_superbuild_add_project_python_pyproject_DEPENDS_OPTIONAL}
      LICENSE_FILES ${_superbuild_add_project_python_pyproject_LICENSE_FILES}
      PROCESS_ENVIRONMENT ${_superbuild_add_project_python_pyproject_PROCESS_ENVIRONMENT}
      SPDX_LICENSE_IDENTIFIER "${_superbuild_add_project_python_pyproject_SPDX_LICENSE_IDENTIFIER}"
      SPDX_COPYRIGHT_TEXT "${_superbuild_add_project_python_pyproject_SPDX_COPYRIGHT_TEXT}"
      SPDX_CUSTOM_LICENSE_FILE "${_superbuild_add_project_python_pyproject_SPDX_CUSTOM_LICENSE_FILE}"
      SPDX_CUSTOM_LICENSE_NAME "${_superbuild_add_project_python_pyproject_SPDX_CUSTOM_LICENSE_NAME}"
      ${_superbuild_add_project_python_pyproject_UNPARSED_ARGUMENTS}
      CONFIGURE_COMMAND
        ""
      BUILD_COMMAND
        ""
      INSTALL_COMMAND
        ${superbuild_python_pip}
          install
          --no-index
          --no-deps
          --no-build-isolation
          ${_superbuild_python_args}
          "<SOURCE_DIR>")

    if (_superbuild_add_project_python_pyproject_REMOVE_MODULES)
      _superbuild_remove_python_modules("${_superbuild_add_project_python_pyproject_REMOVE_MODULES}")
    endif ()
  endif ()
endmacro ()


#
# numpy compile
#
macro(compile_numpy)
  set(proj numpy-host)

  # Check to see if the build path is too short for the packages.
  if (UNIX AND NOT APPLE)
    string(LENGTH "${CMAKE_BINARY_DIR}" numpy_bindir_len)
    # Emperically determined. If longer paths still have the issue, raise this limit.
    if (numpy_bindir_len LESS 24)
      message(WARNING
        "Note that your build tree (${CMAKE_BINARY_DIR}) is too short for "
        "packaging (due to limited RPATH space in the header). Please use a "
        "longer build directory to avoid this problem. You may ignore it if you "
        "are not building packages.")
    endif ()
  endif ()

  set(numpy_process_environment)
  if (lapack_enabled)
    list(APPEND numpy_process_environment
      BLAS    "<INSTALL_DIR>"
      LAPACK  "<INSTALL_DIR>"
      NPY_BLAS_ORDER blas
      NPY_LAPACK_ORDER lapack)
  else()
    list(APPEND numpy_process_environment
      BLAS    "None"
      LAPACK  "None")
  endif ()

  if (fortran_enabled)
    list(APPEND numpy_process_environment
      FC "${CMAKE_Fortran_COMPILER}")
  endif ()

  set(numpy_fortran_compiler "no")
  if (fortran_enabled)
    set(numpy_fortran_compiler "${CMAKE_Fortran_COMPILER}")
  endif ()

  set(numpy_python_build_args
    "--fcompiler=${numpy_fortran_compiler}")

  set(numpy_depends)
  set(numpy_depends_optional)
  if (NOT WIN32)
    if (APPLE)
      # If `lapack` is not a hard requirement, we end up linking to
      # `Accelerate.framework` which is not wanted.
      list(APPEND numpy_depends
        lapack pkgconf)
    else ()
      list(APPEND numpy_depends_optional
        lapack)
    endif ()
    list(APPEND numpy_depends_optional
      fortran)
  endif()

  superbuild_add_project_python_pyproject(numpy
  PACKAGE numpy
  CAN_USE_SYSTEM
  DEPENDS
    pythoncython ${numpy_depends}
  DEPENDS_OPTIONAL ${numpy_depends_optional}
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2005-2023, NumPy Developers"
  PROCESS_ENVIRONMENT
    MKL         "None"
    ATLAS       "None"
    ${numpy_process_environment}
  REMOVE_MODULES
    numpy.array_api.tests
    numpy.compat.tests
    numpy.distutils.tests
    numpy.f2py.tests
    numpy.fft.tests
    numpy.lib.tests
    numpy.linalg.tests
    numpy.ma.tests
    numpy.matrixlib.tests
    numpy.polynomial.tests
    numpy.random._examples
    numpy.random.tests
    numpy.tests
    numpy.typing.tests
  )

  #[[
  ExternalProject_Add(
    ${proj}
    SOURCE_DIR ${EXTERNAL_SOURCE_PREFIX}/numpy
    BINARY_DIR ${EXTERNAL_BUILD_PREFIX}/numpy-host
    DOWNLOAD_COMMAND ""
    DEPENDS numpy-fetch
    CONFIGURE_COMMAND ${EXTERNAL_SOURCE_PREFIX}/numpy/configure
      --prefix ${EXTERNAL_INSTALL_PREFIX}/numpy-host
      --enable-optimizations
    BUILD_COMMAND make -j8
    INSTALL_COMMAND make install
  )
  ]]
  #add_to_env(${proj}/lib)
  #force_build(${proj})
endmacro()