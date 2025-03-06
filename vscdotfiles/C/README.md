**clang的编译：**

在llvm-project文件夹中：
```bash
mkdir build
```

```bash
cd build
```

```bash
cmake -G Ninja \
-DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;polly" \
-DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind;openmp" \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr/local/clang \
../llvm \
-DCMAKE_C_COMPILER=/gcc13.3.0/bin/gcc \
-DCMAKE_CXX_COMPILER=/gcc13.3.0/bin/g++ \
-DLLVM_USE_LINKER=gold \
-DLIBCXX_INSTALL_MODULES=ON \
-DCLANG_INCLUDE_TESTS=OFF \
-DLIBOMPTARGET_ENABLE_CUDA=ON \
-DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
-DCLANG_ENABLE_CUDA=ON \
-DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_89 \
-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=89
```

使用的CMake版本为3.31.4。其中指定了clang对OpenMP和CUDA的支持，并指定了CUDA在本平台的架构。在编译之前还应当设置交换空间，避免编译时因内存不足而崩溃的问题：

```bash
sudo fallocate -l 60G /swapfile \
sudo chmod 600 /swapfile \
sudo mkswap /swapfile \
sudo swapon /swapfile \
sudo sysctl vm.swappiness=100
```

clang的编译占用内存较大，因此为其分配了60G的交换空间。

使用lld作为链接器比ld的内存占用要小得多。除此之外，以这种方式构建的clang不依赖于构建llvm项目时构建的运行时库libcxx,而直接依赖于gcc的标准库libstdc++。

**编译clang20的std模块：**

```bash
clang++ -std=c++23 -stdlib=libc++  -fopenmp   -Wno-reserved-identifier -Wno-reserved-module-identifier     --precompile -o std.pcm /usr/local/clang/share/libc++/v1/std.cppm
```

std.compat模块同理。
