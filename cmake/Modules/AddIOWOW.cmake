include(ExternalProject)

set(IOWOW_INCLUDE_DIR "${CMAKE_BINARY_DIR}/include")

if(NOT DEFINED IOWOW_URL)
  if(EXISTS ${CMAKE_SOURCE_DIR}/iowow.zip)
    set(IOWOW_URL ${CMAKE_SOURCE_DIR}/iowow.zip)
  else()
    set(IOWOW_URL https://github.com/Softmotions/iowow/archive/master.zip)
  endif()
endif()

set(CMAKE_ARGS  -DOWNER_PROJECT_NAME=${PROJECT_NAME}
                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}
                -DBUILD_SHARED_LIBS=OFF
                -DBUILD_EXAMPLES=OFF)

foreach(extra CMAKE_TOOLCHAIN_FILE
              ANDROID_PLATFORM
              ANDROID_ABI
              TEST_TOOL_CMD)
  if(DEFINED ${extra})
    list(APPEND CMAKE_ARGS "-D${extra}=${${extra}}")
  endif()
endforeach()
message("IOWOW CMAKE_ARGS: ${CMAKE_ARGS}")

ExternalProject_Add(
  extern_iowow
  URL ${IOWOW_URL}
  DOWNLOAD_NAME iowow.zip
  TIMEOUT 360
  PREFIX ${CMAKE_BINARY_DIR}
  BUILD_IN_SOURCE OFF
  UPDATE_COMMAND ""
  UPDATE_DISCONNECTED ON
  LOG_DOWNLOAD OFF
  LOG_UPDATE OFF
  LOG_BUILD OFF
  LOG_CONFIGURE OFF
  LOG_INSTALL OFF
  CMAKE_ARGS ${CMAKE_ARGS}
  BUILD_BYPRODUCTS "${CMAKE_BINARY_DIR}/src/extern_iowow-build/src/libiowow-1.a"
)

add_library(iowow_s STATIC IMPORTED GLOBAL)
set_target_properties(
   iowow_s
   PROPERTIES
   IMPORTED_LOCATION "${CMAKE_BINARY_DIR}/src/extern_iowow-build/src/libiowow-1.a"
)
add_dependencies(iowow_s extern_iowow)

list(APPEND PROJECT_LLIBRARIES iowow_s m)
list(APPEND PROJECT_INCLUDE_DIRS "${IOWOW_INCLUDE_DIR}")
