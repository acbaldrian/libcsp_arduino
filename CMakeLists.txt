cmake_minimum_required(VERSION 3.26)

#
# Get the toolchain file for Arduino rp2040 
# must be BEFORE project() as project() will include the toolchain file and set the compiler
#
set(CMAKE_TOOLCHAIN_FILE "" CACHE PATH "Path to Arduino rp2040 tool chain makefile")
if(NOT CMAKE_TOOLCHAIN_FILE AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain-rp2040.cmake")
  set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain-rp2040.cmake" CACHE PATH "" FORCE)
  message(STATUS "No toolchain specified, using default: ${CMAKE_TOOLCHAIN_FILE}")
endif()

if(CMAKE_TOOLCHAIN_FILE)
  message(STATUS "Using toolchain: ${CMAKE_TOOLCHAIN_FILE}")
else()
  message(FATAL_ERROR "No Arduino rp2040 tool chain defined. Set -DCMAKE_TOOLCHAIN_FILE=...")
endif()

project(csp_arduino C)

# # Force static
# set(BUILD_SHARED_LIBS OFF)

#
# add the CSP project as a subdirectory and build it locally
#
set(CSP_DIR "" CACHE PATH "Path to CSP source tree")

# Try the cache variable first, then fall back to a known relative location
if(NOT CSP_DIR AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../libcsp/CMakeLists.txt")
  set(CSP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../libcsp")
  message(STATUS "no CSP_DIR specified, using default: ${CSP_DIR}")
endif()

#
# Set the Options for the CSP library build
#
set(CSP_HAVE_STDIO OFF)
set(CSP_ENABLE_CSP_PRINT ON)
set(CSP_PRINT_STDIO ON)


if(CSP_DIR)
  message(STATUS "Using libcsp in ${CSP_DIR}")
  add_subdirectory(${CSP_DIR} ${CMAKE_BINARY_DIR}/libcsp)
else()
  message(FATAL_ERROR "CSP source directory not found. Set -DCSP_DIR=... or place the CSP source at ../libcsp")
endif()

message(STATUS "CSP include dir: ${CMAKE_CURRENT_SOURCE_DIR}/include")
file(GLOB _h "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")
message(STATUS "Found headers: ${_h}")   

#
# Install the library to the Arduino libraries folder in the user's home directory
#
set(ARDUINO_LIBRARY "" CACHE PATH "Path to Arduino Library tree")
if(NOT ARDUINO_LIBRARY)
  message(FATAL_ERROR "Path to Arduino Library. Set -DARDUINO_LIBRARY=... ")
endif()

set(ARDUINO_INSTALL_DIR "${ARDUINO_LIBRARY}/cps")
message(STATUS "installing to ${ARDUINO_INSTALL_DIR}")

install(TARGETS csp
  ARCHIVE DESTINATION ${ARDUINO_INSTALL_DIR}/src/cortex-m0plus
  COMPONENT runtime
)
install(
  DIRECTORY "${CSP_DIR}/include/"
  DESTINATION ${ARDUINO_INSTALL_DIR}/src
  FILES_MATCHING PATTERN "*.h"
)
install(
  DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/libcsp/include/
  DESTINATION ${ARDUINO_INSTALL_DIR}/src
  OPTIONAL
  FILES_MATCHING PATTERN "*.h"
)

install(
  DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Library/"
  DESTINATION ${ARDUINO_INSTALL_DIR}
  FILES_MATCHING PATTERN "*.properties"
)
install(
  DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/Library/"
  DESTINATION ${ARDUINO_INSTALL_DIR}
  FILES_MATCHING PATTERN "*.h"
)
