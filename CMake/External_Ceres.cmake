
# Set Eigen dependency
if (fletch_ENABLE_Eigen)
  message(STATUS "Ceres depending on internal Eigen")
  list(APPEND Ceres_DEPENDS Eigen)
else()
  message(FATAL_ERROR "Eigen is required for Ceres Solver, please enable")
endif()

# Set SuiteSparse dependency
if (fletch_ENABLE_SuiteSparse)
  message(STATUS "Ceres depending on internal SuiteSparse")
  list(APPEND Ceres_DEPENDS SuiteSparse)
else()
  message(FATAL_ERROR "SuiteSparse is required for Ceres Solver, please enable")
endif()

if (fletch_ENABLE_GLog)
  list(APPEND Ceres_DEPENDS GLog)
  get_system_library_name( glog glog_libname )
  list(APPEND Ceres_EXTRA_BUILD_FLAGS
         -DGLOG_INCLUDE_DIR:PATH=${fletch_BUILD_INSTALL_PREFIX}/include
         -DGLOG_LIBRARY:PATH=${fletch_BUILD_INSTALL_PREFIX}/lib/${glog_libname}
      )
else()
  list(APPEND Ceres_EXTRA_BUILD_FLAGS -DMINIGLOG:BOOL=ON)
endif()

ExternalProject_Add(Ceres
  DEPENDS ${Ceres_DEPENDS}
  URL ${Ceres_file}
  URL_MD5 ${Ceres_md5}
  PREFIX ${fletch_BUILD_PREFIX}
  DOWNLOAD_DIR ${fletch_DOWNLOAD_DIR}
  INSTALL_DIR ${fletch_BUILD_INSTALL_PREFIX}
  CMAKE_GENERATOR ${gen}
  PATCH_COMMAND ${CMAKE_COMMAND}
    -DCeres_patch=${fletch_SOURCE_DIR}/Patches/Ceres
    -DCeres_source=${fletch_BUILD_PREFIX}/src/Ceres
    -P ${fletch_SOURCE_DIR}/Patches/Ceres/Patch.cmake

  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX:PATH=${fletch_BUILD_INSTALL_PREFIX}
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
    -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
    -DEIGEN_INCLUDE_DIR=${EIGEN_INCLUDE_DIR}
    -DCXSPARSE_INCLUDE_DIR=${SuiteSparse_INCLUDE_DIR}
    -DCXSPARSE_LIBRARY_DIR_HINTS=${SuiteSparse_ROOT}/lib
    -DLIB_SUFFIX:STRING=
    ${Ceres_EXTRA_BUILD_FLAGS}
  )

set(Ceres_ROOT ${fletch_BUILD_INSTALL_PREFIX} CACHE PATH "" FORCE)
set(Ceres_DIR "${Ceres_ROOT}/share/Ceres" CACHE PATH "" FORCE)

file(APPEND ${fletch_CONFIG_INPUT} "
########################################
# Ceres
########################################
set(Ceres_ROOT @Ceres_ROOT@)
set(Ceres_DIR @Ceres_DIR@)
set(fletch_ENABLED_Ceres TRUE)
")
