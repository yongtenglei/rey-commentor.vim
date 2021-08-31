" Check if has comment string
function! g:commentor#HasCommentStr() 
  if exists('g:commentor#python_comment_string')
    return 1
  endif
  echom "rey-commentor doesn't work for filletype " . &ft . " yet"
  return 0
endfunction

" Check the minimum indent number
function! g:commentor#DetectMinIntent(start, end)
  let l:min_indent = -1
  let l:i = a:start

  while l:i < a:end
    if l:min_indent == -1 || indent(l:i) < l:min_indent
      let l:min_indent = indent(l:i)
    endif
    let l:i += 1
  endwhile
  return l:min_indent
endfunction

" Handle insert a comment or remove a comment, lnum = number of line
function! g:commentor#InsertOrRemoveComment(lnum, line, indent, is_commented)
  let l:prefix = a:indent > 0 ? a:line[:a:indent - 1] : ''
  if a:is_commented "remove comment
    call setline(a:lnum, l:prefix . a:line[a:indent + len(g:commentor#python_comment_string):])
  else "insert comment
    call setline(a:lnum, l:prefix . g:commentor#python_comment_string . a:line[a:indent:])
  endif
endfunction

" Toggle comment
function! g:commentor#ToggleComment(counter)
  if !g:commentor#HasCommentStr()
    return
  endif

  let l:start = getline('.')
  let l:end = l:start + a:counter - 1

  if l:end > line('$')
    let l:end = line('$')
  endif

  let l:indent = g:commentor#DetectMinIntent(l:start, l:end)

  let l:lines = l:start == l:end ? [getline(l:start)] : getline(l:start, l:end)

  let l:cur_row = getcurpos()[1]
  let l:cur_col = getcurpos()[2]

  let l:lnum = l:start
  if l:lines[0][l:indent : l:indent + len(g:commentor#python_comment_string) - 1] ==# g:commentor#python_comment_string
    let l:is_commented = 1
    let l:cur_offset = -len(g:commentor#python_comment_string)
  else
    let l:is_commented = 0
    let l:cur_offset = len(g:commentor#python_comment_string)
  endif

  for l:line in l:lines
    call g:commentor#InsertOrRemoveComment(
          \ l:lnum, l:line, l:indent, l:is_commented)
    let l:lnum += 1
  endfor

  call cursor(l:cur_row, l:cur_col + l:cur_offset)
endfunction
