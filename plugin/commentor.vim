" c-u provides condition for using v:count or v:count1
nnoremap gc :<C-U>call g:commentor#ToggleComment(v:count1)<cr>
vnoremap gc :<C-U>call g:commentor#ToggleComment( line("'>") - line("'<") + 1)<cr>
