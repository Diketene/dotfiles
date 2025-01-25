clang的编译：

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

其中指定了clang对OpenMP和CUDA的支持.

编译clang20的std模块：

```bash
clang++ -std=c++23 -stdlib=libc++  -fopenmp   -Wno-reserved-identifier -Wno-reserved-module-identifier     --precompile -o std.pcm /usr/local/clang/share/libc++/v1/std.cppm
```

std.compat模块同理.
