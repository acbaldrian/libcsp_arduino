# Target system
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR rp2040)
set(CSP_SYSTEM_NAME "Arduino")

if(NOT ARDUINO_DIR)
    message(FATAL_ERROR "ARDUINO_DIR is not set. Please specify the Arduino installation directory, -DARDUINO_DIR=...")
endif()

set(PLATFORM_DIR "${ARDUINO_DIR}/packages/rp2040")
set(ARDUINO_PICO_DIR "${PLATFORM_DIR}/hardware/rp2040/6.3.0")

set(SYSTEM_DIR "${PLATFORM_DIR}/tools/pqt-gcc/5.0.0-9576866")
set(COMPILER_DIR "${SYSTEM_DIR}/bin")

# Setting D__FREERTOS is the tool chain file for Arduino FreeRTOS
# should separate this as tool chain file and then OS
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} \
    -march=armv6-m \
    -mcpu=cortex-m0plus \
    -mthumb \
    -ffunction-sections \
    -fdata-sections \
    -pipe \
    -D__FREERTOS")   

# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
#     -march=armv6-m \
#     -mcpu=cortex-m0plus \
#     -mthumb \
#     -ffunction-sections \
#     -fdata-sections \
#     -fno-exceptions \
#     -fno-rtti \
#     -pipe \
#     -D__FREERTOS")   

# Same comment for the freertos include
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} \
    -iprefix${ARDUINO_PICO_DIR}/ \
    @${ARDUINO_PICO_DIR}/lib/rp2040/platform_inc.txt \
    @${ARDUINO_PICO_DIR}/lib/core_inc.txt \
    @${ARDUINO_PICO_DIR}/lib/platform_def.txt \
    @${ARDUINO_PICO_DIR}/lib/rp2040/platform_def.txt \
    -isystem ${SYSTEM_DIR}/arm-none-eabi")

set(CMAKE_C_COMPILER   "${SYSTEM_DIR}/bin/arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "${SYSTEM_DIR}/bin/arm-none-eabi-g++")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_FIND_ROOT_PATH "${SYSTEM_DIR}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Stop VSCode from trying to run the compiler to determine its version,
# which will fail 
set(CMAKE_C_COMPILER_FORCED TRUE)
