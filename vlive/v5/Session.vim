let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/code/sc/seco/vlive/v5
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +4 ~/code/sc/seco/live/dev2.scd
badd +1 ~/code/sc/seco/live/dev3.scd
badd +1211 ~/.local/share/SuperCollider/Extensions/seco/seco/main.scd
badd +67 ~/.local/share/SuperCollider/Extensions/seco/seco/exp/piano.scd
badd +1 ~/code/sc/seco/live/dev2.sc
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/exp/launchpad.scd
badd +1 ~/code/sc/seco/live/crap72.scd
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/exp/tile.scd
badd +3 ~/.vim/sctile.vim
badd +64 ~/.vim/sc.vim
badd +68 ~/code/sc/seco/vlive/v4/a.scd
badd +28 ~/code/sc/seco/vlive/v4/init.scd
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/..
badd +475 ~/.local/share/SuperCollider/Extensions/seco/seco/synthpool.scd
badd +30 ~/code/sc/seco/vlive/v4/z.scd
badd +32 ~/code/sc/seco/vlive/v4/e.scd
badd +1 ~/code/sc/seco/vlive/v4/r.scd
badd +5 ~/code/sc/seco/vlive/v4/a.1.scd
badd +7 ~/code/sc/seco/vlive/v4/a.2.scd
badd +3 ~/code/sc/seco/vlive/v4/a.3.scd
badd +1 ~/code/sc/seco/vlive/v4/a.0.scd
badd +3 ~/code/sc/seco/vlive/v4/a.4.scd
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/veco/tile.scd
badd +1 ~/code/sc/seco/vlive/v4/a.6.scd
badd +1 ~/code/sc/seco/vlive/v4/1.scd
badd +20 ~/code/sc/seco/vlive/v4/q.scd
badd +4 ~/code/sc/seco/vlive/v4/t.scd
badd +2 ~/code/sc/seco/vlive/v4/t.8.scd
badd +1 ~/code/sc/seco/vlive/v4/t.1.scd
badd +7 ~/code/sc/seco/vlive/v4/t.7.scd
badd +2 ~/code/sc/seco/vlive/v4/k.scd
badd +28 ~/code/sc/seco/vlive/v1/a.scd
badd +1 ~/code/sc/seco/vlive/v1/z.scd
badd +1 ~/code/sc/seco/vlive/v1/e.scd
badd +1 ~/code/sc/seco/vlive/v1/r.scd
badd +1 ~/code/sc/seco/vlive/v1/q.scd
badd +29 ~/code/sc/seco/vlive/v1/t.scd
badd +46 ~/code/sc/seco/vlive/v4/y.scd
badd +5 ~/code/sc/seco/vlive/v4/y.1.scd
badd +8 ~/code/sc/seco/vlive/v4/y.2.scd
badd +1122 ~/.local/share/SuperCollider/Extensions/seco/seco/veco/launchpad.scd
badd +1 ~/.scvim/doc/UGens/Delays/DelayL.scd
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/veco/buffer.scd
badd +1 ~/.local/share/SuperCollider/Extensions/seco/seco/veco/main.scd
badd +0 ~/.config/SuperCollider/startup.scd
badd +1 1.5.scd
badd +0 ~/seco/seco/veco/other.scd
args 1.5.scd
edit ~/.local/share/SuperCollider/Extensions/seco/seco/veco/buffer.scd
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
let s:l = 102 - ((23 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
102
normal! 046l
lcd ~/.local/share/SuperCollider/Extensions/seco/seco
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
1153
normal zo
1166
normal zo
1169
normal zo
1171
normal zo
1166
normal zo
1212
normal zo
1213
normal zo
1215
normal zo
1212
normal zo
1153
normal zo
let s:l = 1089 - ((15 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1089
normal! 0
tabedit ~/.local/share/SuperCollider/Extensions/seco/seco/veco/other.scd
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
let s:l = 211 - ((26 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
211
normal! 0
tabnew
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
argglobal
enew
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
tabedit ~/.vim/sc.vim
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
let s:l = 39 - ((15 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
39
normal! 0
lcd ~/.local/share/SuperCollider/Extensions/seco/seco
tabedit ~/.config/SuperCollider/startup.scd
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
let s:l = 17 - ((16 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 0
tabedit ~/.local/share/SuperCollider/Extensions/seco/seco/veco/main.scd
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
let s:l = 1 - ((0 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.local/share/SuperCollider/Extensions/seco/seco
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
let s:l = 207 - ((8 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
207
normal! 035l
lcd ~/.local/share/SuperCollider/Extensions/seco/seco
tabnext 2
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
