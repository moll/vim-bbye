if exists("g:loaded_bbye") || &cp | finish | endif
let g:loaded_bbye = 1

function! s:bdelete(bang, buffer_name)
	let buffer = s:str2bufnr(a:buffer_name)
	let current = winnr()

	if buffer < 0
		return s:warn("E516: No buffers were deleted. No match for ".a:buffer_name)
	endif

	if empty(a:bang) && getbufvar(buffer, "&modified")
		let error = "E89: No write since last change for buffer "
		return s:warn(error . buffer . " (add ! to override)")
	endif

	" For cases where adding buffers causes new windows to appear, make sure to
	" check for the loop end on each iteration.
	let window = 0
	while window < winnr("$")
		let window += 1
		if winbufnr(window) != buffer | continue | endif
		execute window . "wincmd w"

		" Bprevious also wraps around the buffer list, if necessary:
		try | exe bufnr("#") > 0 && buflisted(bufnr("#")) ? "buffer #" : "bprevious"
		catch /^Vim([^)]*):E85:/ " E85: There is no listed buffer
		endtry

		" If found a new buffer for this window, mission accomplished:
		if bufnr("%") != buffer | continue | endif

		exe "enew" . a:bang
		setl noswapfile
		" If empty and out of sight, delete it right away:
		setl bufhidden=delete
		" Regular buftype warns people if they have unsaved text there.  Wouldn't
		" want to lose someone's data:
		setl buftype=
		" Hide the buffer from buffer explorers and tabbars:
		setl nobuflisted
	endwhile

	" If it hasn't been already deleted by &bufhidden, end its pains now:
	if bufexists(buffer) && buflisted(buffer)
		exe "bdelete" . a:bang . " " . buffer
	endif

	exe current . "wincmd w"
endfunction

function! s:str2bufnr(buffer)
	if empty(a:buffer)
		return bufnr("%")
	elseif a:buffer =~ '^\d\+$'
		return bufnr(str2nr(a:buffer)rn)
	else
		return bufnr(a:buffer)
	endif
endfunction

" Using the built-in :echoerr prints a stacktrace, which isn't that nice.
function! s:warn(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:bdelete(<q-bang>, <q-args>)
