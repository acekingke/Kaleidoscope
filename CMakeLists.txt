cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

# We require C++17 (because LLVM does)
set(CMAKE_CXX_STANDARD 17)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall -Werror -Wpedantic -Wno-unused-variable -Wno-unused-private-field -Wno-error=unused-command-line-argument -fno-omit-frame-pointer -fsanitize=address -O0 -g")



message(STATUS "Find package LLVM")
find_package(LLVM REQUIRED CONFIG PATHS "build/libs/lib/cmake/llvm" "build/libs/lib64/cmake/llvm" NO_DEFAULT_PATH)
    


project(kaleidoscope)

find_package(LLVM REQUIRED CONFIG)

set(SOURCE_FILES 
    src/toy.cpp)


include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# Now build our tools
add_executable(toy ${SOURCE_FILES})


add_link_options(-rdynamic)
set(LLVM_COMPONENTS
core
demangle
objcarcopts
orcjit
aarch64asmparser
aarch64codegen
aarch64desc
aarch64info
armasmparser
armcodegen
armdesc
arminfo
webassemblyasmparser
webassemblycodegen
webassemblydesc
webassemblyinfo
x86asmparser
x86codegen
x86desc
x86info
riscvasmparser
riscvcodegen
riscvdesc
riscvinfo
)
# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(llvm_libs ${LLVM_COMPONENTS})

# Link against LLVM libraries
#message("llvm_libs=${llvm_libs}")
target_link_libraries(toy ${llvm_libs})
