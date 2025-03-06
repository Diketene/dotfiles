**1.在系统默认库文件搜索路径下clang的编译：**

系统默认的库文件搜索路径通常是/usr、根目录/、/usr/local/等，如果将项目安装至这些文件夹中不需要在构建项目时设置RPATH（RPATH是一条链接器在创建可执行文件或动态库文件时嵌入的路径信息，其指定了可执行文件/库文件在运行时依赖的动态库文件的路径)。当然，安装至此类文件夹中需要有管理员权限，如没有管理员权限，我们只好退而求其次，利用第2条中所描述的办法构建项目。

在llvm-project文件夹中：
```bash
#!/usr/bin/bash
mkdir build && cd build

cmake 	-G Ninja \
	-DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;polly" \
	-DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;openmp" \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/usr/local/clang \
	-DCMAKE_C_COMPILER=/gcc13.3.0/bin/gcc \
	-DCMAKE_CXX_COMPILER=/gcc13.3.0/bin/g++ \
	-DLLVM_USE_LINKER=gold \
	-DLIBCXX_INSTALL_MODULES=ON \
	-DCLANG_INCLUDE_TESTS=OFF \
	-DLIBOMPTARGET_ENABLE_CUDA=ON \
	-DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
	-DCLANG_ENABLE_CUDA=ON \
	-DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_89 \
	-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=89 \
	../llvm
```

在以上过程中除了构建clang之外，还构建了openmp、lld、polly以及CUDA的clang前端，并指定了CUDA在本平台的架构（即sm_89）。使用的CMake版本为3.31.4。如果使用gold和ld作为链接器，在编译之前还应当设置交换空间，避免编译时因内存不足而崩溃的问题：

```bash
sudo fallocate -l 60G /swapfile \
sudo chmod 600 /swapfile \
sudo mkswap /swapfile \
sudo swapon /swapfile \
sudo sysctl vm.swappiness=100
```

项目的编译在使用ld或gold作为链接器时占用内存较大，因此为其分配了60G的交换空间。

使用lld作为链接器比GNU家族的ld或gold的内存占用要小得多。除此之外，以这种方式构建的clang不依赖于构建llvm项目时构建的运行时库libc++,而直接依赖于gcc的标准库libstdc++，如果要实现clang完全依赖于libc++，必须进行项目的自举构建。

**3.编译clang20的std模块：**

```bash
clang++ -std=c++23 -stdlib=libc++  -fopenmp   -Wno-reserved-identifier -Wno-reserved-module-identifier     --precompile -o std.pcm /usr/local/clang/share/libc++/v1/std.cppm
```

std.compat模块同理。
