# Dotfiles of my linux

Hello! Here are some dotfiles of my linux, many basic dotfiles are set to make my wsl easier to use.

**vscdotfiles**: Dotfiles for my VSCode, which contains dotfiles of C/C++, CUDA and Fortran. In C/C++ configurations, 
it also contains some guidelines for building LLVM.

**config.yaml**: Dotfile of clangd(global configurations).

**config**: Dotfile of ssh.

**.tmux.conf**: Dotfile of tmux.

[build of LLVM](./vscdotfiles/C/README.md)(in Chinese)

**Here are some of my expreriences about wsl2 itself**(could be seen as a memo of myself):

- 1. **probelm about core dump behavior**

> It seems that it's hard to change the core dump default behavior of wsl if we want wsl executes our modified core dump settings as wsl begins its service. The default behavior is as followed:

```bash
$cat /proc/sys/kernel/core_pattern
|/wsl-capture-crash %t %E %p %s
```

> When we want to change the default behavior, it's widely known that we can execute

```bash
if ! grep -qi 'kernel.core_pattern' /etc/sysctl.conf; then
	sudo sh -c 'echo "kernel.core_pattern=core.%p.%u.%s.%e.%t" >> /etc/sysctl.conf'
	sudo sysctl -p
fi

ulimit -c unlimited
```

> to change the default behavior. In our modified behavior, we hope that the core dump files could be generated in the binary executing path with a more detailed filename. If we want to make it permanently, we can

```bash
sudo bash -c "cat << EOF > /etc/security/limits.conf
* soft core unlimited
* hard core unlimited
EOF"
```

> but in wsl, despite the above settings is set, when we reboot the wsl, it still behaves its default behavior.

> So it's annoying that everytime when we want to debug our binary with our modified behavior as we firstly start wsl, we must execute `sudo sysctl -p` and `ulimit -c unlimited` repeatedly. But it's not a severe problem, so I decided not to figure out a solution of this problem.

- 2. **problem about perf**
> Although I cloned the latest wsl source code from github and compiled perf successfully, perf couldn't execute some performance analysis, which is put on hold.
