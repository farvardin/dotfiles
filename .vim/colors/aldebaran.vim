" Vim color file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2006 Apr 15

" This color scheme uses a light background.

" First remove all existing highlighting.
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "aldebaran"

hi Normal ctermfg=Black ctermbg=LightGrey guifg=Black guibg=cornsilk

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg term=standout ctermbg=DarkRed ctermfg=White guibg=Red guifg=White
hi IncSearch term=reverse cterm=reverse gui=reverse
hi ModeMsg term=bold cterm=bold gui=bold
hi StatusLine term=reverse,bold cterm=reverse,bold gui=reverse,bold
hi StatusLineNC term=reverse cterm=reverse gui=reverse
hi VertSplit term=reverse cterm=reverse gui=reverse
hi Visual term=reverse ctermbg=grey guibg=grey80
hi VisualNOS term=underline,bold cterm=underline,bold gui=underline,bold
hi DiffText term=reverse cterm=bold ctermbg=Red gui=bold guibg=Red
hi Cursor guibg=Green guifg=NONE
hi lCursor guibg=Cyan guifg=NONE
hi Directory term=bold ctermfg=#274C4C guifg=#101940
hi LineNr term=underline ctermfg=Brown guifg=Brown
hi MoreMsg term=bold ctermfg=#101940 gui=bold guifg=SeaGreen
hi NonText term=bold ctermfg=#101940 gui=bold guifg=#101940 guibg=grey80
hi Question term=standout ctermfg=#101940 gui=bold guifg=SeaGreen
hi Search term=reverse ctermbg=Yellow ctermfg=NONE guibg=Yellow guifg=NONE
hi SpecialKey term=bold ctermfg=#274C4C guifg=#101940
hi Title term=bold ctermfg=DarkMagenta gui=bold guifg=Magenta
hi WarningMsg term=standout ctermfg=DarkRed guifg=Red
hi WildMenu term=standout ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi Folded term=standout ctermbg=Grey ctermfg=#274C4C guibg=LightGrey guifg=#274C4C
hi FoldColumn term=standout ctermbg=Grey ctermfg=#274C4C guibg=Grey guifg=#274C4C
hi DiffAdd term=bold ctermbg=LightBlue guibg=LightBlue
hi DiffChange term=bold ctermbg=LightMagenta guibg=LightMagenta
hi DiffDelete term=bold ctermfg=#101940 ctermbg=LightCyan gui=bold guifg=#101940 guibg=LightCyan
hi CursorLine term=underline cterm=underline guibg=grey80
hi CursorColumn term=reverse ctermbg=grey guibg=grey80

" Colors for syntax highlighting
hi Constant term=underline ctermfg=DarkRed guifg=Magenta guibg=grey95
hi Special term=bold ctermfg=DarkMagenta guifg=SlateBlue guibg=grey95
if &t_Co > 8
  hi Statement term=bold cterm=bold ctermfg=Brown gui=bold guifg=Brown
endif
hi Ignore ctermfg=LightGrey guifg=grey90

" vim: sw=2
