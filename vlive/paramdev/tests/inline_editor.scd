
Pbindef(\bla, \instrument, \default)

// put cursor on 200 and hit <F10>n : edit number
// map <F10>n <Esc>:call SCcallInlineEditor("number")<CR>
// which call libdef/inline_editor.scd
// call ~class_inline_editor.edit_number
// call ~class_number_editor_gui.new

~ne = ~class_number_editor_gui.new
~ne.make_gui
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200, 
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

////////////////
// map <F10>s <Esc>:call SCcallInlineEditorRange("seq")<CR>

// should visual select which line goes to editor
// select 1,0,0,0, 1,0,0,0, 

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200, 
			\bufnum, BufDef('/tmp')
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)


////////////////////////
// vmap <F10>i <Esc>:call SCinterpretInPlace()<CR>
// should select expr
1+1
// ERROR: freeze vim
// kill a vim process and it unfreeze, the result is ok. Should debug

// vmap <F10>r <Esc>:call SCcallFunctionOnSelection()<CR>

///////////////
// map <F10>b <Esc>:call SCcallInlineEditor("sample")<CR>
// BROKEN

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

//////////////////
// map <F10>e <Esc>:call SCcallInlineEditor("pbindef")<CR>
// 
// BROKEN

Pbindef(\bla, \instrument, \sh101);

Pbindef(\bla)




// " insert note in vim with midi (need libdef/vim_piano_writer.scd)
// map <F10>m <Esc>:call SendToSC("~start_vim_writer.();")<CR>
// 
// " insert synthdef argument in pbind
// map <F10>p <Esc>:call SCcallInlineEditor("instrument")<CR> 
