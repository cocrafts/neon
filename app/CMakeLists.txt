cmake_minimum_required(VERSION 3.20)
project(neon LANGUAGES Swift CXX)

if(DEFINED PLATFORM)
	message("-- Targeting ${PLATFORM}")
else()
	set(PLATFORM OS64COMBINED)
	message("-- [DEFAULTS] Targeting ${PLATFORM}, use -DPLATFORM=[platform] to specify")
endif()

include(../lib/cmake/ios.toolchain.cmake)

# Use C++'17.
set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++17"
    CACHE STRING "Xcode C++ Language Standard")
# Use libc++.
set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++"
    CACHE STRING "Xcode C++ Standard Library")

# Enable Swift and C++ bridge
set(CMAKE_XCODE_ATTRIBUTE_SWIFT_OBJC_INTEROP_MODE "objcxx")

# Primary entry
add_executable(${PROJECT_NAME})

file(GLOB_RECURSE NEON_SOURCES "${CMAKE_SOURCE_DIR}/src/neon/platform/swiftui/native/*.swift")
source_group("Neon/Core" FILES ${NEON_SOURCES})

file(GLOB_RECURSE SOURCES
	"${CMAKE_SOURCE_DIR}/native/include/*.h"
	"${CMAKE_SOURCE_DIR}/generated/include/*.h"
	"${CMAKE_SOURCE_DIR}/native/src/*.cpp"
	"${CMAKE_SOURCE_DIR}/generated/src/*.cpp"
	"${CMAKE_SOURCE_DIR}/native/src/*.swift"
)

set(GENERATED_EXCLUDE_FILES "${CMAKE_SOURCE_DIR}/generated/src/_main_.cpp")
list(REMOVE_ITEM SOURCES ${GENERATED_EXCLUDE_FILES})

target_sources(${PROJECT_NAME} PRIVATE ${SOURCES} ${NEON_SOURCES})
target_include_directories(${PROJECT_NAME} PRIVATE
	"${CMAKE_SOURCE_DIR}/native/include"
	"${CMAKE_SOURCE_DIR}/generated/include"
)

# Register yoga as dependency
set(YOGA_PATH "${CMAKE_SOURCE_DIR}/../lib/yoga")
include_directories("${YOGA_PATH}/include")
add_subdirectory(${YOGA_PATH} ${CMAKE_BINARY_DIR}/yoga)
target_link_libraries(${PROJECT_NAME} PRIVATE yogacore)

set_target_properties(${PROJECT_NAME} PROPERTIES
	MACOSX_BUNDLE TRUE
	MACOSX_BUNDLE_INFO_PLIST ${CMAKE_SOURCE_DIR}/Info.plist
	XCODE_ATTRIBUTE_LIBRARY_SEARCH_PATHS ""
	XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "17.0"
	XCODE_ATTRIBUTE_SWIFT_VERSION 5.0
	XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2,3,4"  # 1 = iPhone, 2 = iPad
	XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH YES
	XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST YES
	XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST_IOS YES
	XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "native/include/Bridging-Header.h"
	XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "4R7EAZY462"
	XCODE_ATTRIBUTE_CODE_SIGN_STYLE "Automatic"
)

target_link_libraries(${PROJECT_NAME} PRIVATE
	"-framework UIKit"
	"-framework Foundation"
	"-framework CoreGraphics"
)

add_custom_command(
    TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Running POST_BUILD command..."
    COMMAND ${CMAKE_COMMAND} -E echo "Custom command is running!"
    COMMAND ${CMAKE_COMMAND} -E echo "Running Ruby script to set Library Search Paths..."
)
