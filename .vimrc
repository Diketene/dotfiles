set number						"显示行号
set cursorline				"突出显示当前行 
syntax on							"语法高亮
set autoindent 
set termguicolors
set relativenumber
set nocompatible
colorscheme slate			"主题风格
setlocal noswapfile 	"不生成swap文件
set ruler							"打开状态栏标尺
set shiftwidth=2			"设定>> 和 << 移动宽度为2
set softtabstop=2			"设定按一次退格键删掉2个空格
set tabstop=2					"tab长度为2
set nobackup					"覆盖文件时不备份
set autochdir					"自动切换当前目录为当前文件所在目录
set backupcopy=yes		"设置备份时的行为被覆盖
set hlsearch					"设置高亮显示搜索到的文本
set noerrorbells			"关闭错误信息响铃
set novisualbell			"关闭使用可视响铃代替呼叫
set magic							"设置魔术
set smartindent				"开启新行时使用智能缩进
set backspace=indent,eol,start " 不设定在插入状态无法用退格键和 Delete 键删除回车符
set cmdheight=1				"设定命令行行数为1
set laststatus=2			"显示状态栏
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%) " 设置在状态行显示的信息
set foldenable				"开始折叠
set foldmethod=syntax	"设置语法折叠
set foldcolumn=0			"设置折叠宽度
setlocal foldlevel=1	"设置折叠层数为1
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> " 用空格键来开关折叠


map <C-m> :NERDTreeToggle<CR>
set clipboard=unnamedplus
set visualbell
set t_vb=
