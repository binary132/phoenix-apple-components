project(PhoenixAppleComponentsCMake NONE)

cmake_minimum_required(VERSION 3.13)

# ConfigureXcodeBuildCommand prepares an `xcodebuild` shell invocation
# to run the build.  BUILD_MODE should be something like "Release" or
# "Debug".  This macro supports an optional SDK parameter string.
#
# To use XCODE_BUILD_CMD, pass it as an argument to ExternalProject_add.
# See: https://cmake.org/cmake/help/latest/module/ExternalProject.html
#
# After this macro is invoked, the variables "XCODE_BUILD_CMD",
# "OBJ_ROOT", and "SYM_ROOT" are set.
#
# After the build is completed, the resulting binaries will be symlinked
# from the ${OBJ_ROOT} build path into ${SYM_ROOT}/artifacts.
macro(ConfigureXcodeBuildCommand
  BUILD_MODE
  BUILD_DIR
  PROJECT
  SCHEME
)
  # Generate the build command.  It will be appended to.
  set(XCODE_BUILD_CMD
    xcodebuild
    -quiet
    -project ${PROJECT}
    -scheme ${SCHEME}
    -configuration ${BUILD_MODE}
  )

  set(OBJ_ROOT ${BUILD_DIR}/obj)
  set(SYM_ROOT ${BUILD_DIR}/artifacts)

  # Configure external build for custom SDK if necessary.
  if(${ARGC} GREATER 5)
    message("Building with -sdk ${ARGV5}")
    set(XCODE_BUILD_CMD ${XCODE_BUILD_CMD} -sdk ${ARGV5})
    set(OBJ_ROOT ${BUILD_DIR}/${ARGV5}/obj)
    set(SYM_ROOT ${BUILD_DIR}/${ARGV5}/artifacts)
  endif()

  # Append OBJROOT for intermediate objects and SYMROOT for symlinked
  # final products.
  set(XCODE_BUILD_CMD
    ${XCODE_BUILD_CMD}
    OBJROOT=${OBJ_ROOT}
    SYMROOT=${SYM_ROOT}
  )
endmacro()

set(PhoenixAppleComponents_DIR ${CMAKE_CURRENT_LIST_DIR})
set(PhoenixAppleComponents_BUILD_DIR ${PhoenixAppleComponents_DIR}/cmake-build)
set(XCODE_PROJ phoenix-apple-components.xcodeproj)
set(XCODE_SCHEME PHXRenderer)

if(IOS)
  set(XCODE_SCHEME ${XCODE_SCHEME}-iOS)
  set(XCODE_SDK ${XCODE_IOS_PLATFORM})
else()
  # Default is mac OS
  # TODO: Derive host platform SDK value (default should work....)
  # set(XCODE_SDK "macosx10.14")
endif()

# TODO: Switch to github.com/phoenix-engine/build-tools
# TODO: Support Debug build?
ConfigureXcodeBuildCommand(
  "Release"
  ${PhoenixAppleComponents_BUILD_DIR}
  ${XCODE_PROJ}
  ${XCODE_SCHEME}
  ${XCODE_SDK} # Optional SDK parameter, which if unset won't be used.
)

include(ExternalProject)
ExternalProject_Add(
  PhoenixAppleComponents
  PREFIX ${PhoenixAppleComponents_DIR}
  BINARY_DIR ${PhoenixAppleComponents_DIR}
  STAMP_DIR ${PhoenixAppleComponents_BUILD_DIR}/cmake-stamp
  DOWNLOAD_DIR ${PhoenixAppleComponents_BUILD_DIR}/cmake-download
  SOURCE_DIR ${PhoenixAppleComponents_DIR}/src
  TMP_DIR ${PhoenixAppleComponents_BUILD_DIR}/tmp

  CONFIGURE_COMMAND ""

  BUILD_COMMAND   ${XCODE_BUILD_CMD} build
  INSTALL_COMMAND ""
  TEST_COMMAND    ""

  USES_TERMINAL_BUILD TRUE
)

SET(MetalPhoenixRenderer_INCLUDE_DIR ${PhoenixAppleComponents_DIR}/include)
SET(MetalPhoenixRenderer_LIB_DIR ${SYM_ROOT})

# IMPORTED means the file is generated outside of CMake.
add_library(MetalPhoenixRenderer STATIC IMPORTED)
set_target_properties(
  MetalPhoenixRenderer
  PROPERTIES
  IMPORTED_LOCATION ${MetalPhoenixRenderer_LIB_DIR}
)
