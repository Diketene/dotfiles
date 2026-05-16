help([[
This module loads llvm 22.1.5.
]]
)

whatis("Name: llvm")
whatis("Version: 22.1.5")
whatis("Description: llvm project include clang flang polly clang-tools-extra mlir compiler-rt flang-rt libcxx libcxxabi libunwind openmp")

local version = "22.1.5"
local root = "/home/diketene/.myapps/llvm-22.1.5"
local include_root = root .. "/include"
local lib_root = root .. "/lib"

setenv("CC", root .. "/bin/clang")
setenv("CXX", root .. "/bin/clang++")
setenv("FC", root .. "/bin/flang")
setenv("CXXFLAGS", "-stdlib=libc++")

prepend_path("PATH", root .. "/bin")
prepend_path("CPLUS_INCLUDE_PATH", include_root .. "/llvm")
prepend_path("CPLUS_INCLUDE_PATH", include_root .. "/mlir")
prepend_path("CPATH", include_root .. "/mlir-c")
prepend_path("CPLUS_INCLUDE_PATH", include_root .. "/polly")
prepend_path("CPLUS_INCLUDE_PATH", include_root .. "/c++/v1")
prepend_path("CPLUS_INCLUDE_PATH", include_root .. "/x86_64-unknown-linux-gnu/c++/v1")

prepend_path("LD_LIBRARY_PATH", lib_root)
prepend_path("LIBRARY_PATH", lib_root)
prepend_path("LD_LIBRARY_PATH", lib_root .. "/x86_64-unknown-linux-gnu")
prepend_path("LIBRARY_PATH", root .. "/x86_64-unknown-linux-gnu")

conflict("llvm")
family("compiler")

