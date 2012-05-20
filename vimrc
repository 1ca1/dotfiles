" vimrc file for Matt Sacks

" {{{ Pathogen
runtime! autoload/pathogen.vim
if exists('g:loaded_pathogen')
  call pathogen#runtime_prepend_subdirectories(expand('~/.vimbundles'))
endif

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
"}}}

filetype plugin indent on

" Tabs and Text {{{1
set tabstop=8
set softtabstop=4
set shiftwidth=4
set shiftround
set smarttab
set expandtab

"   Tabline {{{2
"   by default this is non-gui
set guioptions-=e
set tabline=%!MyTabLine()
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " where the magic happens
    let s .= '  %{MyTabLabel(' . (i + 1) . ')}  '
  endfor
  let s .= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif
  return s
endfunction

function! MyTabLabel(n)
  let tabnum  = a:n . ') '
  let buflist = tabpagebuflist(a:n)
  let winnr   = tabpagewinnr(a:n)
  let buf     = bufname(buflist[winnr - 1])
  if getbufvar(buf, '&mod') && buf !~ '^$'
    let s = '+ '
  endif
  let s = exists("s") ? s . tabnum : tabnum
  if buf =~ '^$'
    if getbufvar(buf, 'netrw_browser_active')
      let s .= fnamemodify(b:netrw_curdir, ':t')
    else
      let s .= '(\/) (°,,°) (\/)'
    endif
  endif
  let tail       = fnamemodify(buf, ':t')
  let empty_tail = fnamemodify(buf, ':h:t')
  if tail =~ '^$'
    if empty_tail =~ '.'
      return s . fnamemodify(buf, ':s?\/$??:t')
    else
      return s . empty_tail
    endif
  else
    return s . tail
  endif
endfunction
"   END Tabline }}}2

" toggle between gui tabs and terminal
function! TabToggle()
  if &guioptions !~# 'e'
    set guioptions+=e tabline&
  else
    set guioptions-=e tabline=%!MyTabLine()
  endif
endfunction
command! -nargs=0 TabToggle call TabToggle()
"}}}1

" {{{ Indentation and Margins
set autoindent
set backspace=indent,eol,start
set linebreak
set linespace=2
set wrap
"}}}

" {{{ Navigation and Formatting
set more              " use more prompt
set lazyredraw        " don't redraw when don't have to
set showmode
set showcmd
set scrolloff=5       " keep the cursor centered in the screen
set sidescrolloff=5   " keep at least 5 lines left/right
set formatoptions+=n  " include lists
set title             " show title in the titlebar
set switchbuf=usetab  " use an already existing window for buffers

nnoremap 0 ^
nnoremap Y y$
nnoremap K <NOP>

" Scroll viewport a bit quicker
nno <C-e> 5<C-e>
nno <C-y> 5<C-y>

" Emacs style mappings
ino <C-A> <C-O>^
cno <C-A> <Home>
cno <C-P> <Up>
cno <C-N> <Down>

" zz in insert mode centers the text
imap zz <esc>zzA
"}}}

" {{{ Editor Settings
if has("gui_running")
  augroup gvimrc
    autocmd!
    autocmd GuiEnter *
          \  set background=dark
          \| colorscheme eddie
          \| set lines=200 columns=100
          \| nnoremap <C-S> :w<CR>
          \| nnoremap <C-Q> :q<CR>
          \| nnoremap <C-C> gT
          \| nnoremap <C-X> gt
          \| nnoremap <C-W><C-Q> <C-W>q
          \| set guioptions=gm
          \| let &guifont= has("MacUnix") ?
            \ "Liberation\ Mono:h15" :
            \ "DejaVu\ Sans\ Mono\ 12"
          \| set t_Co=256
          \| endif
  augroup END
else
  set t_Co=256
  colorscheme eddie
endif

syntax on
syntax enable

set nonumber           " no line numbers
set ruler              " for position at the bottom
set cmdheight=1        " cmdline height
set hidden             " Don't display buffers if they've been closed
set laststatus=2       " always display the status line
set nobackup           " don't make a backup
set noswapfile         " swap files aren't helpful
set display=lastline   " show as much of the lastline as possible
set autoread           " dirty shit
set cursorline         " slow ass line

set wildmode=list:full
set wildmenu
set wildignore+=
      \*.png,*.jpg,*.pdf,
      \CVS,*/CVS/*,SVN,*/SVN/*,
      \*/node_modules/*,node_modules
if exists('+wildignorecase') | set wildignorecase | endif

set complete-=i          " searching includes can be slow
set vb t_vb=             " No bells
set virtualedit=block    " Move cursor past the last char in <C-v> mode
set showmatch            " Show matching parenthesis
set mat=3                " Time between jumping to matching paren
set isk+=_,$,@,%,-       " none of these should be word dividers
set shortmess=at         " Hide 'Press Enter ...'
set cb=unnamed           " Use the system clipboard
set nostartofline        " don't move cursor to the BOL when jumping
set foldmethod=marker    " default foldmethod is marker
set history=1000         " make the history longer
set linespace=2          " give lines some breathing room
set tags+=.git/tags     " look in the git directory for git-hook generated tags

" make grep always recursive and case-insensitive
set grepprg=grep\ -inr\ $*\ /dev/null\

nno <C-n> gt
nno <C-p> gT

map Q gqq

cno <C-q> <C-f>
cno <C-f> <Right>
cno <C-b> <Left>
cno <C-s> <A-Left>

nno <Backspace> "_dd
xno <Backspace> "_d

" statusline is [bufnum] (git branch) local?/path/to/file.ft [filetype]
set statusline=[%n]\ %{matchstr(fugitive#statusline(),\ '(.*)')}\ %f\ %m%r%w%y\ %=(%L\ loc)\ \ %l,%v\ \ %P
"}}}

" {{{ Search and Mouse
set ignorecase       " ignore case when pattern matching
set smartcase        " ignore 'ignorecase' when contains uppercase letters
set hlsearch         " highlight the search
set incsearch        " search while typing
set mouse=a
set mousehide
set modeline
set mousemodel=popup " right click does something
"}}}

" {{{ Leader Mappings
let mapleader = ","

map <Leader>, <C-^>

" Copy to System Clipboard
xmap <Leader>y "+y

" Copy all to pasteboard
nmap <Leader>a mZggVG<Leader>y`Z

" Setting Directories
nnoremap <Leader>cd :lcd %:h<CR>
nnoremap <Leader>CD :cd %:h<CR>

" Change vim's working directory to the above directory
map <Leader>u :lcd %:p:h<CR>

" Vertically split the current window and switch to it
nnoremap <leader>w <C-w>v<C-w>lgg
" Horizontally split the current window and switch to it
nnoremap <leader>s <C-w>s<C-w>jgg

" quickly edit the vimrc
nmap <Leader>v :vsplit ~/.vimrc<CR>

" move all files to the top
nmap <Leader>gg :windo normal gg<CR>
" same but for bottom
nmap <Leader>G :windo normal G<CR>

" turn off search
nno <Leader>n :nohlsearch<CR>
" turn off search when reloading vimrc
nohlsearch
"}}}

"{{{ Commands
fun! ForgotSudo()
  w !sudo tee %
endfun
command! -nargs=0 Fsudo call ForgotSudo()

fun! Syntax()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
endfun
command! -nargs=0 Syn call Syntax()

command! -bar -range=% Trim :<line1>,<line2>s/\s\+$//e

" create a new foldgroup
function! s:Fold(fold)
  let s:beg = substitute(&commentstring, '%s', a:fold, '')
  let s:end = substitute(&commentstring, '%s', 'END '.a:fold, '')
  call setline('.', s:beg.' {{{')
  call append('.', s:end.' }}}')
endfunction
command! -nargs=1 Fold :call s:Fold(<f-args>)
      \| exec 'normal zoo<C-w>'
      \| startinsert

command! -complete=file -nargs=1 TODO :exec 'vimgrep /\%(TODO\|FIXME\)/' <q-args> | copen | wincmd K

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" open grep at the top of the window
" requires regex to be surrounded in double-quotes
command! -complete=file -nargs=* Grep :exec 'grep <args>' | copen | wincmd K

" makes the file writable
command! -nargs=0 Writeable :setl noro modifiable

" fixes solarized shit when changing colorschemes
command! -nargs=1 FixSolarized vsplit | Ve syn/<args> | %s/^\(\s\{-}\)\%(HiLink\|hi def link\)/\1hi link/g | w | wincmd l | e! % | wincmd h | u | wq
"}}}

" Plugins {{{1
autocmd BufReadPost fugitive://* set bufhidden=delete

" vim-coffeescript
let g:coffee_compile_vert = 1

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" fuzzee
nnoremap ,f :F<Space>
nnoremap ,t :F */
nnoremap ,b :FB<Space>
set wcm=<C-z>

call fuzzee#map(',ac', 'app/coffeescripts')
call fuzzee#map(',js', 'javascript')
call fuzzee#map(',cs', 'css')
call fuzzee#map(',so', 'Source')
call fuzzee#map(',sp', 'Specs/spec')
" }}}1

" {{{ Filetypes
" General
augroup General
  autocmd!
  " tabstuff
  autocmd FileType html,python,vim,javascript,scheme
        \ setl shiftwidth=2 softtabstop=2
  " auto omnicompletion
  autocmd FileType * 
        \  if exists("+omnifunc") && &omnifunc == ""
          \| setlocal omnifunc=syntaxcomplete#Complete
        \| endif
  autocmd FileType *
        \  if exists("+completefunc") && &completefunc == ""
          \| setlocal completefunc=syntaxcomplete#Complete
        \| endif
augroup END

" Markdown
fun! MarkItDown()
  !markdown % > %:r.html
endfun
command! -nargs=0 Makemkd call MarkItDown()

augroup Markdown
  autocmd!
  au FileType markdown
        \  ino <buffer> <C-b> ****<esc>hi
        \| ino <buffer> <D-b> ****<esc>hi
        \| ino <buffer> <D-i> **<esc>i
        \| xno <buffer> <C-b> sb
        \| setl spell textwidth=80
  " open a markdown file in Marked.app
  au FileType markdown
        \ command! -buffer -nargs=0 Marked exec "!open -a 'Marked'"
        \  fnameescape(expand("%"))
augroup END

augroup Quickfix
  autocmd!
  au FileType qf
        \ setl nolist nowrap cursorline
augroup END

augroup explorer
  autocmd!
  autocmd FileType netrw
        \  nnoremap <buffer> gr :grep %/<Home><C-Right><Space>
augroup END

" TXT
augroup Text
  autocmd!
  au BufNewFile,BufWinEnter *.txt
        \ if &ft !~# 'help'
          \| setl filetype=txt
          \| setl textwidth=80
          \| setl linebreak
          \| nno <buffer> j gj
          \| nno <buffer> k gk
        \| else
          \| nno <buffer> <Enter> <C-]>
        \| endif
augroup END

" Javascript
augroup Javascript
  autocmd!
  " fold describe blocks in Jasmine specs
  au FileType javascript if expand('%') =~ 'spec\.js'
        \| set fdm=expr
        \| set fde=getline(v:lnum)=~'^\\(\\s\\+\\)\\%(describe\\)'?'>1':search('^\\1});')?'<1':'='
        \| endif
augroup END

" CSS/SASS
augroup CSS
  autocmd!
  " CSS Sort Functions {{{2
  function! s:RemoveBrowserPrefix(i)
    " -moz-border-radius: => border-radiusm:
    if a:i =~ '^\s\{-}-'
      return substitute(a:i, '^\(\s*\)-\(\w\)\w\{-1,}-\(.\{-}\):', '\1\3\2:', '')
    else
      return a:i
    endif
  endfunction
  function! s:SortStyles(i1, i2)
    let i1 = s:RemoveBrowserPrefix(a:i1)
    let i2 = s:RemoveBrowserPrefix(a:i2)
    return i1 == i2 ? 0 : i1 < i2 ? -1 : 1
  endfunction
  function! s:SortList(l1, l2)
    if a:l1 == a:l2
      let l1 = searchpair('{', '', '}', 'nb')+1
      let l2 = searchpair('{', '', '}', 'n')-1
    else
      let l1 = a:l1
      let l2 = a:l2
    endif
    call setline(l1, sort(getline(l1, l2), "s:SortStyles"))
  endfunction
  " END CSS Sort Functions }}}2

  au FileType css,sass,scss command! 
        \ -nargs=0 -range -buffer
        \ Csort :call s:SortList(<line1>, <line2>)
  au FileType css,sass,scss setl sw=2
augroup END

" Git
augroup Git
  autocmd!
  autocmd FileType git set fdm=syntax
  " fold each file in a gitcommit used with the -v flag
  autocmd FileType gitcommit
        \ set fdm=expr foldexpr=getline(v:lnum)=~'^diff\\s--git'?'>1':'='
  " view the output of `git diff` in a vertical split
  command! -nargs=0 Gddiff
        \ vnew | exec "r!git diff" | set ft=git
  " git status in a vertical split
  command! -nargs=0 Gsv Gst | wincmd H
augroup END

" Webdev {{{
augroup Webdev
  autocmd!
  autocmd BufRead,BufNewFile *.styl set ft=sass
  " this is just emulating textmate's ;
  autocmd FileType css,javascript inoremap <buffer> <expr> ;
        \ getline('.')[col('.')-1] == ';' ? "\<Right>" : ";"
  autocmd FileType css,javascript,scss,sass
        \ inoremap <buffer> <C-l> {<CR>}<C-o>O

  " make one-line if statements into multiline ones {{{
  function! s:MakeMultiline()
    let line      = getline('.')
    let code      = matchstr(line, ')\s*\zs.*$')
    let statement = matchstr(line, '\(\(if\|else\|else if\)\s*(.\{-})\=\s*\ze[^{]\)')
    if code =~ '[{}]' && statement !~ '^$'
      " trim the { and } and spaces
      let code = substitute(code, '\%({\s*\|\s*}\)', '', 'g')
    endif
    if statement !~ '^$'
      let linenr = line('.')
      call setline(linenr, statement . '{')
      call append(linenr, code)
      call append(linenr+1, '}')
      normal =3j
    endif
  endfunction

  au FileType javascript command! -nargs=0 -buffer Multi
        \ call s:MakeMultiline()
  au FileType javascript nnoremap <buffer> <Leader>m :Multi<CR>
  au FileType javascript command! -nargs=0 -buffer Brap
        \ normal A<Space>{<Esc>jo}
  au FileType javascript nnoremap <buffer> <Leader>r :Brap<CR>
  " END MakeMultiline }}}
augroup END
" END Webdev augroup }}}

"}}}

set exrc

" vi:ft=vim fdm=marker:
