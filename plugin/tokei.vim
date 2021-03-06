" =============================================================================
" Description: Count makeup of a project and display the results on
"               a scratch buffer.
" File: tokei.vim
" Author: Vanessa McHale <tmchale@wisc.edu>
" Version: 0.1.0.0
" ChangeLog:
"       0.1.0.0: initial commit.
if exists("g:__TOKEI_VIM__")
    finish
endif
let g:__TOKEI_VIM__ = 1

if !exists("g:tokei_exclude")
    let g:tokei_exclude = 'TODO.md'
endif

let g:tokei_buf_name = 'Tokei'

if !exists("g:tokei_buf_size")
    let g:tokei_buf_size = 13
endif

" Mark a buffer as scratch
function! s:ScratchMarkBuffer()
    setlocal buftype=nofile
    " make sure buffer is deleted when view is closed
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal buflisted
    setlocal nonumber
    setlocal statusline=%F
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal wrap
    setlocal linebreak
    setlocal nolist
endfunction

" Return the number of visual lines in the buffer
fun! s:CountVisualLines()
    let initcursor = getpos(".")
    call cursor(1,1)
    let i = 0
    let previouspos = [-1,-1,-1,-1]
    " keep moving cursor down one visual line until it stops moving position
    while previouspos != getpos(".")
        let i += 1
        " store current cursor position BEFORE moving cursor
        let previouspos = getpos(".")
        normal! gj
    endwhile
    " restore cursor position
    call setpos(".", initcursor)
    return i
endfunction

" return -1 if no windows was open
"        >= 0 if cursor is now in the window
fun! s:TokeiGotoWin() "{{{
    let bufnum = bufnr( g:tokei_buf_name )
    if bufnum >= 0
        let win_num = bufwinnr( bufnum )
        " Will return negative for already deleted window
        exe win_num . "wincmd w"
        return 0
    endif
    return -1
endfunction "}}}

" Close tokei Buffer
fun! TokeiClose() "{{{
    let last_buffer = bufnr("%")
    if s:TokeiGotoWin() >= 0
        close
    endif
    let win_num = bufwinnr( last_buffer )
    " Will return negative for already deleted window
    exe win_num . "wincmd w"
endfunction "}}}

" Open a scratch buffer or reuse the previous one
fun! TokeiGet() "{{{
    let last_buffer = bufnr("%")

    if s:TokeiGotoWin() < 0
        new
        exe 'file ' . g:tokei_buf_name
        setl modifiable
    else
        setl modifiable
        normal ggVGd
    endif

    call s:ScratchMarkBuffer()

    execute '.!tokei -e' . g:tokei_exclude
    setl nomodifiable
    
    let size = s:CountVisualLines()

    if size > g:tokei_buf_size
        let size = g:tokei_buf_size
    endif

    execute 'resize ' . size

    nnoremap <silent> <buffer> q <esc>:close<cr>

endfunction "}}}

command! Tokei call TokeiGet()
map <silent> co :Tokei<CR>
