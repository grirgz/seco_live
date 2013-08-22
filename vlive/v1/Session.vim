let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/code/sc/seco/vlive/v1
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 ~/code/sc/seco/live/dev2.scd
badd +1 ~/code/sc/seco/live/dev3.scd
badd +1211 ~/.local/share/SuperCollider/Extensions/seco/seco/main.scd
badd +67 ~/.local/share/SuperCollider/Extensions/seco/seco/exp/piano.scd
badd +1 ~/code/sc/seco/live/dev2.sc
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/exp/launchpad.scd
badd +1 ~/code/sc/seco/live/crap72.scd
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/exp/tile.scd
badd +3 ~/.vim/sctile.vim
badd +0 ~/.local/share/SuperCollider/Extensions/seco/seco/veco/launchpad.scd
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/veco/tile.scd
badd +1 ~/code/sc/seco/vlive/v1/P.scd
badd +1 ~/code/sc/seco/vlive/v1/V.scd
args ~/code/sc/seco/vlive/v1/V.scd
edit ~/code/sc/seco/live/dev2.scd
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
let s:l = 4 - ((3 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
tabedit ~/.local/share/SuperCollider/Extensions/seco/seco/veco/launchpad.scd
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
let s:l = 1 - ((0 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabedit ~/.local/share/SuperCollider/Extensions/seco/seco/veco/tile.scd
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
let s:l = 1 - ((0 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
tabnext 3
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
