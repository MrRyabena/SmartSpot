
cmake_minimum_required(VERSION 3.27)

project(SHS_SmartSpot VERSION 2.0.0 LANGUAGES CXX C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SHS_CMF_UNUSE_SHS_SETTINGS ON)
add_compile_definitions(
    SHS_SF_DEBUG
)


set(SOURCES
    shs_SmartSpot.cpp
    shs_SmartSpot.h
    shs_SmartSpotApi.cpp
    shs_SmartSpotApi.h
    shs_SmartSpotApiCommands.h
    shs_SmartSpotConfig.h
    shs_SmartSpotConfigReader.cpp
    shs_SmartSpotConfigReader.h
    shs_SmartSpotInterface.h
    shs_SmartSpotVirtual.cpp
    shs_SmartSpotVirtual.h
)

add_library(SHS_SmartSpot ${SOURCES})

target_include_directories(SHS_SmartSpot PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(SHS_SmartSpot
    PRIVATE SHScore
    PRIVATE SHS_Color
    )
target_compile_features(SHS_SmartSpot PRIVATE cxx_std_17)
