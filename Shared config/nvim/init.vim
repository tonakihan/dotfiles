set mouse=a  "enable mouse
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf8,cp1251
set number
set noswapfile
set cursorline
"set clipboard^=unnamed,unnamedplus
" Enable plugins and load plugin for the detected file type.
filetype plugin on
" Enable Omnicomplete features
"set omnifunc=syntaxcomplete#Complete

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
autocmd BufNewFile,BufRead *.ejs set filetype=html
autocmd FileType html,json setlocal tabstop=2 shiftwidth=2 softtabstop=2

syntax enable

call plug#begin()
  " Color hex
  Plug 'ap/vim-css-color'
  " Statusline in vim
  Plug 'itchyny/lightline.vim'
  " Terminal
  Plug 'kassio/neoterm'
  " Commenting lines
  "Plug 'scrooloose/nerdcommenter'
  Plug 'chrisbra/vim-commentary'
  " File manajer
  Plug 'scrooloose/nerdtree'
  " Icons for vim
  Plug 'ryanoasis/vim-devicons'
  " Auto pairs
  Plug 'jiangmiao/auto-pairs'
  " Themes vim
  Plug 'NLKNguyen/papercolor-theme'
  " LaTeX
  "Plug 'lervag/vimtex'
  " Different tab level
  Plug 'yggdroot/indentline'
  " Autocomplete
  Plug 'ervandew/supertab'
  " ? (find info about this)
  Plug 'prettier/vim-prettier', {
        \ 'do': 'npm install' 
        \ }
  " Autochange for html (works is not good)
  "Plug 'AndrewRadev/tagalong.vim' 
  " ? for html (find info about this)
  Plug 'tpope/vim-surround'
call plug#end()

" Auro pairs
let g:AutoPairs={
      \ '<':'>', '(':')', '[':']', '{':'}',"'":"'",'"':'"',
      \ "`":"`", '```':'```', '"""':'"""', "'''":"'''"
      \ }

" Themes vim
set background=dark
colorscheme PaperColor

" Different tab level
let g:indentLine_char='┆'

" Statusline
set noshowmode
"set background=light
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ }

" LaTeX
"let g:tex_flavor = 'latex' "Уточняем какой Тех
"
" Отключаем автоматическое открытие окна Quickfix
"let g:vimtex_quickfix_mode = 0

"===============ENCODING_FILES===============
"<F7> EOL format (dos <CR><NL>,unix <NL>,mac <CR>)
set wildmenu
set wcm=<Tab>
menu EOL.unix :set fileformat=unix<CR>
menu EOL.dos  :set fileformat=dos<CR>
menu EOL.mac  :set fileformat=mac<CR>
map <F7> :emenu EOL.<Tab>
"
"<F8> Change encoding
set wildmenu
set wcm=<Tab>
menu Enc.cp1251  :e ++enc=cp1251<CR>
menu Enc.koi8-r  :e ++enc=koi8-r<CR>
menu Enc.cp866   :e ++enc=ibm866<CR>
menu Enc.utf-8   :e ++enc=utf-8<CR>
menu Enc.ucs-2le :e ++enc=ucs-2le<CR>
map <F8> :emenu Enc.<Tab>
"
"<Shift+F8> Convert file encoding
set wildmenu
set wcm=<Tab>
menu FEnc.cp1251  :set fenc=cp1251<CR>
menu FEnc.koi8-r  :set fenc=koi8-r<CR>
menu FEnc.cp866   :set fenc=ibm866<CR>
menu FEnc.utf-8   :set fenc=utf-8<CR>
menu FEnc.ucs-2le :set fenc=ucs-2le<CR>
map <S-F8> :emenu FEnc.<Tab>
"===============ENCODING_FILES===============

" Для снятия раздражающего выделения
:nnoremap <esc> :noh<return><esc>

