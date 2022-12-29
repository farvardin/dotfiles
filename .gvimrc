" farvardin's dotfiles

" window size 
:set co=80
:set lines=28
" Use visual bell instead of beeping
" :set visualbell
" Use CSS for HTML conversion
:let html_use_css = 1
" Luxi Mono 8 point font
:set gfn=Monospace\ 13


" Function for removing toolbar
function! NoToolBar()
    set guioptions-=m
    set guioptions-=l
    set guioptions-=r 
    set guioptions-=L
    set guioptions-=t
    set guioptions-=T
endfunction

map <C-F> :call NoToolBar()<CR>
imap <C-F> <ESC> :call NoToolBar()<CR>a

" Function for putting toolbar back
function! ToolBar()
    set guioptions+=m
    "set guioptions+=l
    set guioptions+=r
    set guioptions+=L
    set guioptions+=t
    set guioptions+=T 
endfunction

map <C-T> :call ToolBar()<CR>


" Function for toggling full-screen
function! ToggleFullScreen()
   !wmctrl -i -r $(head -n1 ~/.gvim_wid) -b toggle,fullscreen
   redraw
endfunction

map <M-F> :call ToggleFullScreen()<CR>
imap <M-F> <ESC> :call ToggleFullScreen()<CR>a
map <M-F3> :call ToggleFullScreen()<CR>
imap <M-F3> <ESC> :call ToggleFullScreen()<CR>a

