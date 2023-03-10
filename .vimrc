" ------------------------------                          
"      _  __(_)_ _  ________
"     | |/ / /  ' \/ __/ __/
"   (_)___/_/_/_/_/_/  \__/ 
" ------------------------------                          

" python path
set pythonthreedll=~/AppData/Local/Programs/Python/Python38/python38.dll

" plugins
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

Plug 'arcticicestudio/nord-vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-commentary'

call plug#end()

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" colorscheme
set termguicolors
colorscheme nord
syntax enable

" appearance
set title
set number
set cursorline
highlight clear CursorLine
set nowrap
set showmatch
set signcolumn=yes

" backup, swap and buffer
set nobackup
set noswapfile
set hidden
set history=1000

" undo
if has('persistent_undo')
    if empty(glob('~/.vim/undo'))
        silent !mkdir ~/.vim/undo
    endif
    let undo_path = expand('~/.vim/undo')
    exe 'set undodir=' .. undo_path
    set undofile
endif

" bell
set belloff=all

" clipboard
set clipboard+=unnamed

" complete
set completeopt=menuone
set pumheight=10
set wildmenu
set wildmode=longest,full

" encoding
set encoding=utf-8
scriptencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" mouse
set mouse=a

" scrolling
set scrolloff=3
set sidescrolloff=3
set sidescroll=1

" search
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" tab
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
set smartindent

" tabline
set showtabline=2

" statuslilne
set laststatus=2
set cmdheight=2
set showcmd
set noshowmode

" keymap
inoremap <silent> jj <ESC>
command Vterm vert term



" vim-lsp
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_signs_error = {'text': '▪'}
let g:lsp_diagnostics_signs_warning = {'text': '▪'}

" let g:lsp_settings = {
"             \ 'pyls' : {
"                 \'workspace_config': {
"                     \ 'pyls': {
"                         \ 'configurationSources': ['flake8']
"                         \ }
"                     \ }
"                 \ },
"             \ }

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    " setlocal omnifunc=lsp#complete
    " setlocal signcolumn=yes
    " if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    " nmap <buffer> gd <plug>(lsp-definition)
    " nmap <buffer> gs <plug>(lsp-document-symbol-search)
    " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    " nmap <buffer> gr <plug>(lsp-references)
    " nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    " nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> gp <plug>(lsp-previous-diagnostic)
    nmap <buffer> gn <plug>(lsp-next-diagnostic)
    nmap <buffer> gf <plug>(lsp-document-format)
    nmap <buffer> gh <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+2)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-2)

    " let g:lsp_format_sync_timeout = 1000
    " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" augroup LspAutoFormatting
"     autocmd!
"     autocmd BufWritePre *.py LspDocumentFormatSync
" augroup END



" lightline
let g:lightline = {'colorscheme': 'nord' }
let g:lightline.mode_map = {
    \ 'n': 'n',
    \ 'i': 'i',
    \ 'r': 'r',
    \ 'v': 'v',
    \ 'V': 'vl',
    \ "\<C-v>": 'vb',
    \ 'c': 'c',
    \ 's': 's',
    \ 'S': 'S',
    \ "\<C-s>": 'sb',
    \ 't': 't',
    \}
let g:lightline.active = {
    \   'left': [
    \   ['mode', 'paste'],
    \   ['readonly', 'filename', 'modified']],
    \   'right': [
    \   ['lineinfo', 'percent'],
    \   ['lsp_warnings', 'lsp_errors']]
    \   }
let g:lightline.component_expand = {
    \   'lsp_errors': 'LightlineLSPErrors',
    \   'lsp_warnings': 'LightlineLSPWarnings',
    \   }
let g:lightline.component_type = {
    \   'lsp_errors': 'error',
    \   'lsp_warnings': 'warning',
    \   }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }

function! LightlineLSPErrors() abort
    let l:counts = lsp#get_buffer_diagnostics_counts()
    return l:counts.error == 0 ? '' : printf('%d', l:counts.error)
endfunction

function! LightlineLSPWarnings() abort
    let l:counts = lsp#get_buffer_diagnostics_counts()
    return l:counts.warning == 0 ? '' : printf('%d', l:counts.warning)
endfunction

augroup LightlineOnLSP
    autocmd!
    autocmd User lsp_diagnostics_updated call lightline#update()
augroup END

highlight LightlineLeft_normal_0 cterm=bold,italic
highlight LightlineLeft_visual_0 cterm=bold,italic
highlight LightlineLeft_insert_0 cterm=bold,italic
highlight LightlineLeft_command_0 cterm=bold,italic
highlight LightlineLeft_terminal_0 cterm=bold,italic

highlight LspErrorHighlight ctermfg=1, guifg=#BF616A
highlight LspErrorText ctermfg=1, guifg=#BF616A



" Copyright (C) 2016-present Arctic Ice Studio <development@arcticicestudio.com>
" Copyright (C) 2016-present Sven Greb <development@svengreb.de>

" Project: Nord Vim
" Repository: https://github.com/arcticicestudio/nord-vim
" License: MIT

let s:nord_vim_version="0.18.0"
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:nord0 = ["#2E3440", "NONE"]
let s:nord1 = ["#3B4252", 0]
let s:nord2 = ["#434C5E", "NONE"]
let s:nord3 = ["#4C566A", 8]
let s:nord4 = ["#D8DEE9", "NONE"]
let s:nord5 = ["#E5E9F0", 7]
let s:nord6 = ["#ECEFF4", 15]
let s:nord7 = ["#8FBCBB", 14]
let s:nord8 = ["#88C0D0", 6]
let s:nord9 = ["#81A1C1", 4]
let s:nord10 = ["#5E81AC", 12]
let s:nord11 = ["#BF616A", 1]
let s:nord12 = ["#D08770", 11]
let s:nord13 = ["#EBCB8B", 3]
let s:nord14 = ["#A3BE8C", 2]
let s:nord15 = ["#B48EAD", 5]

let s:p.normal.left = [ [ s:nord9, s:nord3 ], [ s:nord4, s:nord3 ] ]
let s:p.normal.middle = [ [ s:nord4, s:nord3 ] ]
let s:p.normal.right = [ [ s:nord4, s:nord3 ], [ s:nord4, s:nord3 ] ]
let s:p.normal.warning = [ [ s:nord13, s:nord3 ] ]
let s:p.normal.error = [ [ s:nord11, s:nord3 ] ]

let s:p.inactive.left =  [ [ s:nord10, s:nord1 ], [ s:nord3, s:nord1 ] ]
let s:p.inactive.middle = g:nord_uniform_status_lines == 0 ? [ [ s:nord3, s:nord1 ] ] : [ [ s:nord3, s:nord1 ] ]
let s:p.inactive.right = [ [ s:nord3, s:nord1 ], [ s:nord3, s:nord1 ] ]

let s:p.insert.left = [ [ s:nord14, s:nord3 ], [ s:nord5, s:nord3 ] ]
let s:p.replace.left = [ [ s:nord15, s:nord3 ], [ s:nord5, s:nord3 ] ]
let s:p.visual.left = [ [ s:nord13, s:nord3 ], [ s:nord5, s:nord3 ] ]

let s:p.tabline.left = [ [ s:nord3, s:nord0 ] ]
let s:p.tabline.middle = [ [ s:nord3, s:nord0 ] ]
let s:p.tabline.right = [ [ s:nord3, s:nord0 ] ]
let s:p.tabline.tabsel = [ [ s:nord4, s:nord0 ] ]

let g:lightline#colorscheme#nord#palette = lightline#colorscheme#flatten(s:p)



