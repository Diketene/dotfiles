**1.在系统默认库文件搜索路径下clang的编译：**

系统默认的库文件搜索路径通常是/usr、根目录/、/usr/local/等，如果将项目安装至这些文件夹中不需要在构建项目时设置RPATH（RPATH是一条链接器在创建可执行文件或动态库文件时嵌入的路径信息，其指定了可执行文件/库文件在运行时依赖的动态库文件的路径）。当然，安装至此类文件夹中需要有管理员权限，如没有管理员权限，我们只好退而求其次，利用第2条中所描述的办法构建项目。

在llvm-project文件夹中：
```bash
#!/usr/bin/bash
mkdir build && cd build 

cmake 	-G Ninja \
		-D LLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;polly" \
		-D LLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;openmp" \
		-D CMAKE_BUILD_TYPE=Release \
		-D CMAKE_INSTALL_PREFIX=/usr/local/clang \
		-D CMAKE_C_COMPILER=/gcc13.3.0/bin/gcc \
		-D CMAKE_CXX_COMPILER=/gcc13.3.0/bin/g++ \
		-D LLVM_USE_LINKER=gold \
		-D LIBCXX_INSTALL_MODULES=ON \
		-D CLANG_INCLUDE_TESTS=OFF \
		-D LIBOMPTARGET_ENABLE_CUDA=ON \
		-D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
		-D CLANG_ENABLE_CUDA=ON \
		-D CLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_89 \
		-D LIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=89 \
		../llvm
```

在以上过程中除了构建clang之外，还构建了openmp、lld、polly以及CUDA的clang前端，并指定了CUDA在本平台的架构（即sm_89）。这些配置不是编译clang所必需的，必需的目标项目只有clang，而必需的运行时项目有libcxx、libcxxabi和libunwind。使用的CMake版本为3.31.4。如果使用gold和ld作为链接器，在编译之前还应当设置交换空间，避免编译时因内存不足而崩溃的问题：

```bash
sudo fallocate -l 60G /swapfile \
sudo chmod 600 /swapfile \
sudo mkswap /swapfile \
sudo swapon /swapfile \
sudo sysctl vm.swappiness=100
```

项目的编译在使用ld或gold作为链接器时占用内存较大，因此为其分配了60G的交换空间。

使用lld作为链接器比GNU家族的ld或gold的内存占用要小得多。除此之外，以这种方式构建的clang不依赖于构建llvm项目时构建的运行时库libc++,而直接依赖于gcc的标准库libstdc++，如果要实现clang完全依赖于libc++，必须进行项目的自举构建。

**2.非默认路径下的构建方法**

这种方法适合不具有管理员权限时构建llvm项目，例如我们是一个服务器用户，但无法取得管理员权限。前提是需要服务器自带一个满足llvm项目构建版本要求的gcc编译器（个人估计这个条件是足够低以至于很容易满足）。笔者构建llvm项目的服务器大致条件如下：

系统版本：CentOS Linux 7

内核版本：Linux 3.10.0-957.el7.x86_64

架构：x86-64

服务器内含一个gcc12.1.0，笔者使用了这个编译器对llvm进行构建。构建脚本如下：

```bash
#!/bin/bash
set -e

unset CPLUS_INCLUDE_PATH   #服务器环境变量太过混乱，在一开始将可能造成污染的环境变量全部清除
unset C_INCLUDE_PATH
unset LD_LIBRARY_PATH

export LD_LIBRARY_PATH="/public/software/compiler/gcc-12.1.0/lib64:$LD_LIBRARY_PATH"
source /public/home/zhangt/lht/env.sh  #此脚本通过conda运行了python3.9环境

mkdir -p build-stage1 && cd build-stage1

cmake   -G Ninja \
        -D LLVM_ENABLE_PROJECTS="clang" \
        -D LLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=/public/home/zhangt/lht/custom-toolchain/clang21/stage1 \
        -D CMAKE_BUILD_WITH_INSTALL_RPATH=ON \       #将链接器嵌入RPATH设定为ON
        -D CMAKE_INSTALL_RPATH="\$ORIGIN/../lib" \	 #$ORIGIN是目标文件安装时的路径，$ORIGIN/../lib保证了安装时的库文件和可执行文件都依赖于库文件
        -D CMAKE_C_COMPILER=/public/software/compiler/gcc-12.1.0/bin/gcc \    #gcc的路径
        -D CMAKE_CXX_COMPILER=/public/software/compiler/gcc-12.1.0/bin/g++ \  #g++的路径
        -D LLVM_USE_LINKER=lld \					 #使用lld作为链接器
        -D CLANG_INCLUDE_TESTS=OFF \
        -D LIBCXX_INSTALL_MODULES=ON \
        -D CMAKE_C_FLAGS="-I/public/software/compiler/gcc-12.1.0/lib/gcc/x86_64-pc-linux-gnu/12.1.0/include/** " \
        -D CMAKE_CXX_FLAGS="-I/public/software/compiler/gcc-12.1.0/include/c++/12.1.0/**" \
        -D CMAKE_SHARED_LINKER_FLAGS="-L/public/software/compiler/gcc-12.1.0/lib64/** -Wl,-rpath,/public/software/compiler/gcc-12.1.0/lib64"\
        -D LIBCXX_HAS_GCC_S_LIB=OFF \                #显式强制设定构建的运行时库依赖于clang的abi
        -D LIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF \    
        -D LIBCXX_CXX_ABI=libcxxabi \
        -D LIBCXXABI_USE_LLVM_UNWINDER=ON \
        -D LIBCXXABI_ENABLE_SHARED=ON \             #运行时库全部构建为动态库
        -D LIBUNWIND_ENABLE_SHARED=ON \
        ../llvm

ninja -j$(nproc) && ninja install
```

此脚本实现构建的是最小的clang生态，所构建的clang依然依赖于libstdc++的运行时库。在构建完成后，为了验证clang是否完整地被成功编译，笔者利用如下代码进行了测试：

```C++
#include <print>
auto main(void) -> int{
	std::println("Hello, world!");
} //hello.cpp
```

笔者发现，消除系统默认环境变量后为编译器传递如下参数，编译可以正常进行和结束：

```bash
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH #消除系统默认环境变量
clang++ -nostdinc++ -nostdinc \
		-std=c++23 \
		-stdlib=libc++ \
		-isystem /public/home/zhangt/lht/custom-toolchain/clang21/stage1/include/c++/v1 \ #libc++库文件路径
		-isystem /public/home/zhangt/lht/custom-toolchain/clang21/stage1/include/x86_64-unknown-linux-gnu/c++/v1 \ #<__config_site>路径
		-isystem /public/home/zhangt/lht/custom-toolchain/clang21/stage1/lib/clang/21/include \  #clang内部头文件路径
		-isystem /usr/include \  #系统C标准库文件
		-lc++ -lc++abi \
		-o hello hello.cpp  #./hello => Hello, world!
```

下一步，笔者将探索用构建好的这个clang编译器实现llvm项目的自举，在第二阶段实现用此编译器构建llvm工具链，并在第三阶段用第二阶段构建的工具链构建llvm工具链。

**3.编译clang20的std模块：**

```bash
clang++ -std=c++23 -stdlib=libc++ \
		-fopenmp  \
		-Wno-reserved-identifier -Wno-reserved-module-identifier \
		--precompile -o std.pcm /usr/local/clang/share/libc++/v1/std.cppm
```

std.compat模块同理。
