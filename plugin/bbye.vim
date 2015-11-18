if exists("g:loaded_bbye") || &cp | finish | endif
let g:loaded_bbye = 1

function! s:bdeleteexcept(bang, buffer_name)
	let except_buffer = s:str2bufnr(a:buffer_name)
  let last_buffer_nr = bufnr('$')
  let buffer_nr = 1
  let warn_modified = 0

  " Pass a:buffer_name in as -1 to delete all buffers
  if a:buffer_name == -1
    let except_buffer = -1
  endif

  while buffer_nr <= last_buffer_nr
    if buffer_nr != except_buffer
      if getbufvar(buffer_nr, "&modified") && empty(a:bang)
        let warn_modified = 1
      else
        call s:bdelete(a:bang, buffer_nr)
      endif
    endif
    let buffer_nr = buffer_nr + 1
  endwhile

  if warn_modified
		let error = "E89: No write since last change for some buffers "
		return s:warn(error . " (add ! to override)")
  endif
endfunction

function! s:bdeleteall(bang)
  call s:bdeleteexcept(a:bang, -1)
endfunction

function! s:bdelete(bang, buffer_name)
	let buffer = s:str2bufnr(a:buffer_name)
	let w:bbye_back = 1

	if buffer < 0
		return s:warn("E516: No buffers were deleted. No match for ".a:buffer_name)
	endif

	if getbufvar(buffer, "&modified") && empty(a:bang)
		let error = "E89: No write since last change for buffer "
		return s:warn(error . buffer . " (add ! to override)")
	endif

	" If the buffer is set to delete and it contains changes, we can't switch
	" away from it. Hide it before eventual deleting:
	if getbufvar(buffer, "&modified") && !empty(a:bang)
		call setbufvar(buffer, "&bufhidden", "hide")
	endif

	" For cases where adding buffers causes new windows to appear or hiding some
	" causes windows to disappear and thereby decrement, loop backwards.
	for window in reverse(range(1, winnr("$")))
		" For invalid window numbers, winbufnr returns -1.
		if winbufnr(window) != buffer | continue | endif
		execute window . "wincmd w"

		" Bprevious also wraps around the buffer list, if necessary:
		try | exe bufnr("#") > 0 && buflisted(bufnr("#")) ? "buffer #" : "bprevious"
		catch /^Vim([^)]*):E85:/ " E85: There is no listed buffer
		endtry

		" If found a new buffer for this window, mission accomplished:
		if bufnr("%") != buffer | continue | endif

		call s:new(a:bang) 
	endfor

	" Because tabbars and other appearing/disappearing windows change
	" the window numbers, find where we were manually:
	let back = filter(range(1, winnr("$")), "getwinvar(v:val, 'bbye_back')")[0]
	if back | exe back . "wincmd w" | unlet w:bbye_back | endif

	" If it hasn't been already deleted by &bufhidden, end its pains now.
	" Unless it previously was an unnamed buffer and :enew returned it again.
	if bufexists(buffer) && buffer != bufnr("%")
		exe "bdelete" . a:bang . " " . buffer
	endif
endfunction

function! s:str2bufnr(buffer)
	if empty(a:buffer)
		return bufnr("%")
	elseif a:buffer =~ '^\d\+$'
		return bufnr(str2nr(a:buffer))
	else
		return bufnr(a:buffer)
	endif
endfunction

function! s:new(bang)
	exe "enew" . a:bang

	setl noswapfile
	" If empty and out of sight, delete it right away:
	setl bufhidden=wipe
	" Regular buftype warns people if they have unsaved text there.  Wouldn't
	" want to lose someone's data:
	setl buftype=
	" Hide the buffer from buffer explorers and tabbars:
	setl nobuflisted
endfunction

" Using the built-in :echoerr prints a stacktrace, which isn't that nice.
function! s:warn(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:bdelete(<q-bang>, <q-args>)

command! -bang -complete=buffer -nargs=? Bdeleteexcept
	\ :call s:bdeleteexcept(<q-bang>, <q-args>)

command! -bang -complete=buffer -nargs=? Bdeleteall
	\ :call s:bdeleteall(<q-bang>)
