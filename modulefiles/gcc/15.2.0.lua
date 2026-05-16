help([[
This module loads GCC 15.2.0.
]]
)

whatis("Name: GCC")
whatis("Version: 15.2.0")
whatis("Description: GNU Compiler Collection")

local version = "15.2.0"
local root = "/home/diketene/.myapps/gcc-15.2.0"

setenv("CC", root .. "/bin/gcc")
setenv("CXX", root .. "/bin/g++")
setenv("FC", root .. "/bin/gfortran")

prepend_path("PATH", root .. "/bin")
prepend_path("CPLUS_INCLUDE_PATH", root .. "/include/c++/15.2.0")
prepend_path("LD_LIBRARY_PATH", root .. "/lib64")
prepend_path("MANPATH", root .. "/share/man")

conflict("gcc")
family("compiler")
