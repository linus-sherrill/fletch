#ckwg +4
# Copyright 2016 by Kitware, Inc. All Rights Reserved. Please refer to
# KITWARE_LICENSE.TXT for licensing information, or contact General Counsel,
# Kitware, Inc., 28 Corporate Drive, Clifton Park, NY 12065.

# Locate the system installed ZLib
#
# The following variables will guide the build:
#
# ZLIB_ROOT        - Set to the install prefix of the ZLib library
#
# The following variables will be set:
#
# ZLib_FOUND       - Set to true if ZLib can be found
# ZLib_INCLUDE_DIR - The path to the ZLib header files
# ZLib_LIBRARY     - The full path to the ZLib library

if(ZLIB_DIR)
  find_package(ZLib NO_MODULE)
elseif(NOT ZLIB_FOUND)
  include(CommonFindMacros)

  SET(ZLIB_INCLUDE_PATHS ${ZLIB_ROOT}/include
    ${ZLIB_ROOT}
    /usr/include
    /usr/local/include
    /opt/ZLib/include )
  SET(ZLIB_LIB_PATHS ${ZLIB_ROOT}/lib
    ${ZLIB_ROOT}
    /lib
    /lib64
    /usr/lib
    /usr/lib64
    /usr/local/lib
    /usr/local/lib64
    /opt/ZLib/lib )

  setup_find_root_context(ZLIB)
  find_path(ZLIB_INCLUDE_DIR zlib.h ${ZLIB_FIND_OPTS} PATHS ${ZLIB_INCLUDE_PATHS})
  find_library(ZLIB_LIBRARY zlib ${ZLIB_FIND_OPTS} PATHS ${ZLIB_LIB_PATHS})
  restore_find_root_context(ZLIB)

  include(FindPackageHandleStandardArgs)
  FIND_PACKAGE_HANDLE_STANDARD_ARGS(Zlib ZLIB_INCLUDE_DIR ZLIB_LIBRARY)
  if(ZLIB_FOUND)
    set(ZLIB_FOUND True)
  else()
    set(ZLIB_FOUND False)
  endif()
endif()
