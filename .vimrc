syntax enable

"set background=dark
"color solarized
"color desert
"color zenburn


"set background=light
"color buttercream

"highlight search
set hlsearch

"smartcase. Ignore with \C in search pattern or :set noic (set no ignorecase) at runtime
set ignorecase
set smartcase 

set nobackup

"disable adding unicode BOM when creating a new file
set nobomb
 
set wrap
set linebreak
set nolist 

set mouse=a

" load txt2tags stuffs 

" au BufNewFile,BufRead *.t2t Voom txt2tags
au BufNewFile,BufRead *.t2t set syntax=txt2tags 
au BufNewFile,BufRead *.t2t set noexpandtab
au BufNewFile,BufRead *.t2t set nolist 
au BufNewFile,BufRead *.t2t Voom txt2tags

au BufNewFile,BufRead *.ni set ft=inform7

if has("multi_byte")
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " we disable BOM unicode when creating a new file
        set nobomb
        set termencoding=utf-8
        set fileencodings=utf-8,ucs-bom,iso-8859-15,iso-8859-3
else
        echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

" switch line with ctrl shift arrows up/down
noremap <c-s-up> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
noremap <c-s-down> ddp

map <c-s-j> <c-s-down>
map <c-s-k> <c-s-up>

"allow navigating through long lines that span multiple rows
"nnoremap j gj
"nnoremap k gk

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

map <down> gj
map <up> gk


" We want to save with ctrl+s

nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>i

" see http://amix.dk/vim/vimrc.html


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
set paste

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction



" copy cut paste with alt


map <a-v> "+gP
map <a-c> "+y
map <a-x> "+x

map <A-v> "+gP
map <A-c> "+y
map <A-x> "+x



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
"set lbr
"set tw=500

"set ai "Auto indent
"set si "Smart indent




