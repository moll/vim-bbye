Bbye (Buffer Bye) for Vim
==========================
Bbye allows you to do delete buffers (close files) without closing your windows or messing up your layout.

Vim by default closes all windows that have the buffer (file) open when you do `:bdelete`.  If you've just got your splits and columns perfectly tuned, having them messed up equals a punch in the face and that's no way to tango.

Bbye gives you `:Bdelete` and `:Bwipeout` commands that behave like well designed citizens:

- Close and remove the buffer.
- Show another file in that window.
- Show an empty file if you've got no other files open.
- Do not leave useless `[no file]` buffers if you decide to edit another file in that window.
- Work even if a file's open in multiple windows.
- Work a-okay with various buffer explorers and tabbars.

Regain your throne as king of buffers!


Installing
----------
The easiest and most modular way is to download Bbye to `~/.vim/bundle`:
```
mkdir -p ~/.vim/bundle/bbye
```

Using Git:
```
git clone https://github.com/moll/vim-bbye.git ~/.vim/bundle/bbye
```

Using Wget:
```
wget https://github.com/moll/vim-bbye/archive/master.tar.gz -O- | tar -xf- --strip-components 1 -C ~/.vim/bundle/bbye
```

Then prepend that directory to Vim's `&runtimepath` (or use [Pathogen](https://github.com/tpope/vim-pathogen)):
```
set runtimepath^=~/.vim/bundle/bbye
```


Using
-----
Instead of `:bdelete` and `:bwipeout`, use `:Bdelete` and `:Bwipeout` respectively. Fortunately autocomplete helps by sorting `:Bdelete` before its lowercase brother.

As it's likely you'll be using `:Bdelete` often, make a shortcut to `\q`, for example, to save time. Throw this to your `vimrc`:
```
:nnoremap <Leader>q :Bdelete<CR>
```

### Buffer delete vs wipeout
Vim has two commands for closing a buffer: `:bdelete` and `:bwipeout`. The former removes the file from the buffer list, clears its options, variables and mappings. However, it remains in the jumplist, so `Ctrl-o` takes you back and reopens the file. If that's not what you want, use `:bwipeout` or Bbye's equivalent `:Bwipeout` where you would've used `:bdelete`.

### Closing all open buffers and files
Occasionally you'll want to close all open buffers and files while leaving your pristine window setup as is. That's easy. Just do:
```
:bufdo :Bdelete
```

For some variations, like closing all-but-one buffer, see [@qiushihe](https://github.com/qiushihe)'s script in https://github.com/moll/vim-bbye/pull/4.

### Aliasing to :Bclose
If you've used any `Bclose.vim` scripts before and for some reason need the `:Bclose` command to exist, you may make an alias:
```
command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
```


License
-------
Bbye is released under a *Lesser GNU Affero General Public License*, which in summary means:

- You **can** use this program for **no cost**.
- You **can** use this program for **both personal and commercial reasons**.
- You **do not have to share your own program's code** which uses this program.
- You **have to share modifications** (e.g bug-fixes) you've made to this program.

For more convoluted language, see the `LICENSE` file.


About
-----
**[Andri Möll](http://themoll.com)** authored this in SublemacslipseMate++.  
[Monday Calendar](https://mondayapp.com) supported the engineering work.  
Inspired by [Bclose.vim](http://vim.wikia.com/wiki/VimTip165), but rewritten to be perfect.

If you find Bbye needs improving or you've got a question, please don't hesitate to email me anytime at andri@dot.ee or [create an issue online](https://github.com/moll/vim-bbye/issues).
