let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/code/sc/seco/vlive
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +207 ~/.local/share/SuperCollider/Extensions/seco/seco/veco/tile.scd
badd +1 v4/y.2.scd
badd +10 ~/code/sc/seco/vlive
badd +20 rise10/2.1.scd
badd +95 rise10/2.scd
badd +8 rise10/init.scd
badd +35 crepe/t.3.scd
badd +19 rise10/2.3.scd
badd +22 rise10/4.1.scd
badd +20 rise10/2.2.scd
badd +22 rise10/4.2.scd
badd +1 rise10/1.2.scd
badd +10 rise10/8.1.scd
badd +169 lib/demo/clip.scd
badd +34 lib/main.scd
badd +16 rise10/3.1.scd
badd +3 rise10/8.scd
badd +13 rise10/1.1.scd
badd +64 rise10/1.scd
badd +2 rise10/8.2.scd
badd +11 rise10/1.3.scd
badd +2 rise10/8.3.scd
badd +40 rise10/3.4.scd
badd +29 rise10/4.4.scd
badd +2 rise10/trigpad.scd
badd +28 rise9/trigpad.scd
badd +187 lib/demo/patfx.scd
badd +33 potar3/1.scd
badd +1 potar3/3.scd
badd +58 potar3/4.scd
badd +1 potar3/1.1.scd
badd +1 potar3/1.33.scd
badd +95 rise10/3.scd
badd +95 rise10/4.scd
badd +0 ~/bin/seco
args rise10/1.scd
edit ~/code/sc/seco/vlive
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
let s:l = 10 - ((9 * winheight(0) + 20) / 40)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
10
normal! 0
tabnext 1
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
