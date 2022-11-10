config ?= release
arch ?= native
tune ?= generic
build_flags ?= -j2
llvm_archs ?= X86;ARM;AArch64;WebAssembly;RISCV
llvm_config ?= Release
llc_arch ?= x86-64
pic_flag ?=

# Use clang by default; because CC defaults to 'cc'
# you must explicitly set CC=gcc to use gcc
$(warning A top-level warning)
ifndef CC
	ifneq (,$(shell clang --version 2>&1 | grep 'clang version'))
		CC = clang
		CXX = clang++
	endif
else ifeq ($(CC), cc)
	ifneq (,$(shell clang --version 2>&1 | grep 'clang version'))
		CC = clang
		CXX = clang++
	endif
endif
# $(waring $(MAKEFILE_LIST))
# https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html
srcDir := $(shell dirname '$(subst /Volumes/Macintosh HD/,/,$(realpath $(lastword $(MAKEFILE_LIST))))')
# $(info last words $(realpath $(lastword $(MAKEFILE_LIST))))

libsSrcDir := $(srcDir)/lib/llvm/llvm/
libsBuildDir := $(srcDir)/build/build_libs
libsOutDir := $(srcDir)/build/libs
buildDir := $(srcDir)/build/build_$(config)


libs:
	mkdir -p '$(libsBuildDir)'
	cd '$(libsBuildDir)' && env CC="$(CC)" CXX="$(CXX)" cmake -B '$(libsBuildDir)' -S '$(libsSrcDir)'  -DCMAKE_INSTALL_PREFIX="$(libsOutDir)" -DCMAKE_BUILD_TYPE="$(llvm_config)" -DCMAKE_CXX_FLAGS="-fpic" -DLLVM_TARGETS_TO_BUILD="$(llvm_archs)"  
	cd '$(libsBuildDir)' && env CC="$(CC)" CXX="$(CXX)" cmake --build '$(libsBuildDir)' --target install --config $(llvm_config) -- $(build_flags)
configure:
	mkdir -p '$(buildDir)'
	cd '$(buildDir)' && env CC="$(CC)" CXX="$(CXX)" cmake -B '$(buildDir)' -S '$(srcDir)' -DCMAKE_BUILD_TYPE=$(config)
build: configure
	cd '$(buildDir)' && env CC="$(CC)" CXX="$(CXX)" cmake --build '$(buildDir)' --config $(config) --target all -- $(build_flags)
