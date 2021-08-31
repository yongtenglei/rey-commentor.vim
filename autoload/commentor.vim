function! g:commentor#ToggleComment()
  let l:i = indent('.')  "Number of space"
  let l:line = getline('.')
  let l:cur_row = getcurpos()[1]
  let l:cur_col = getcurpos()[2]

  let l:prefix = l:i > 0 ? l:line[:l:i - 1] : "" "handle the situation with no indent

  if l:line[l:i:l:i + len(g:commentor#python_comment_string) - 1] == g:commentor#python_comment_string "Has been commented"
    call setline('.', l:prefix . l:line[l:i + len(g:commentor#python_comment_string): ])
    let l:cur_offset = -len(g:commentor#python_comment_string)
  else
    call setline('.', l:prefix . g:commentor#python_comment_string . l:line[l:i:])
    let l:cur_offset = len(g:commentor#python_comment_string)
  endif
  call cursor(l:cur_row, l:cur_col + l:cur_offset)
endfunction
