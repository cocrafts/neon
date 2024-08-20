cmake_minimum_required(VERSION 3.20)
project(NeonDemo LANGUAGES Swift CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # Generate compile_commands.json as lsp for Clangd
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")
set(CMAKE_Swift_FLAGS "${CMAKE_Swift_FLAGS} -swift-version 5")

# Use C++'17.
set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++17"
    CACHE STRING "Xcode C++ Language Standard")
# Use libc++.
set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++"
    CACHE STRING "Xcode C++ Standard Library")

set(CMAKE_XCODE_ATTRIBUTE_SWIFT_OBJC_INTEROP_MODE "objcxx")

include_directories(
    "${CMAKE_SOURCE_DIR}/native/include"
    "${CMAKE_SOURCE_DIR}/generated/include"
)

file(GLOB_RECURSE SOURCES
    "${CMAKE_SOURCE_DIR}/native/include/*.h"}
    "${CMAKE_SOURCE_DIR}/native/include/*.hpp"}
    "${CMAKE_SOURCE_DIR}/native/src/*.cpp"}
    "${CMAKE_SOURCE_DIR}/native/src/*.swift"}
    "${CMAKE_SOURCE_DIR}/generated/include/*.h"}
    "${CMAKE_SOURCE_DIR}/generated/src/*.cpp"}
)

add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES})

# Register yoga as dependency
set(YOGA_PATH "${CMAKE_SOURCE_DIR}/../lib/yoga")
include_directories("${YOGA_PATH}/include")
add_subdirectory(${YOGA_PATH} ${CMAKE_BINARY_DIR}/yoga)
target_link_libraries(${PROJECT_NAME} PRIVATE yogacore)

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_SOURCE_DIR}/Info.plist
    XCODE_ATTRIBUTE_SWIFT_VERSION 5.0
    XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "native/include/Bridging-Header.h"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "-"
)

target_link_libraries(${PROJECT_NAME} PRIVATE "-framework SwiftUI")

target_link_libraries(${PROJECT_NAME} PRIVATE
    "-framework AppKit"
    "-framework Foundation"
    "-framework CoreGraphics"
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    XCODE_ATTRIBUTE_ENABLE_BITCODE YES
)
