SCVim.updateCaches
SCVim.updateHelpCache


(
Pdef(\plop,
	Pbind(
		\instrument, \default,
		\freq, 1958.9393341391,
		\legato, 2.1,
		\dur, 1/8,
		\detune, Pseq([0,10,-41,5],inf),
	)
).play
)















~midi.(\k1, 100, \freq.asSpec)

(
	Pbind(
		\instrument, \default,
		\freq, ~class_number_editor_gui.new_pattern(100),
		\dur, 1,
	).play
)

"vim --servername scvim --remote-send '<Esc>:call SCreplaceTextBlock(15,20, %)<Enter>'".format("k\\\njkj".asCompileString)).unixCmd;
"vim --servername scvim --remote-send '<Esc>:call SCreplaceTextBlock(15,20, \"%\")<Enter>'".format("aaa\nbbb").unixCmd;
"echo -e ''hello\nplop' ".unixCmd;
"aaa\naaa".escapeChar.dump

a = "aaa\nbbb"
a = "aaa\nb\\nbb"
a = "aaa\n" ++ "bbbb" ++ $\\ ++ $n ++ "cccY"
a.escapeChar($\n).dump
a.replace("\\n", "\\\n").dump
a.replace("\n", "\\n").dump
a.replace("\\n", "\\\n").replace("\n", "\\n").dump
a.asCompileString.dump
a.shellQuote.dump

(
a = "aaa\n" ++ "bbbb" ++ $\\ ++ $n ++ "c\"X\"c";
a = a.replace("\\", "\\\\");
a = a.replace($\n.asString, "\\n");
a = a.replace($".asString, $\\ ++ $");
a.dump;
)
"vim --servername scvim --remote-send '<Esc>:call SCreplaceTextBlock(15,20, \"%\")<Enter>'".format(a).unixCmd;

(
a = "aaa\n" ++ "bbbb" ++ $\\ ++ $n ++ "c\"X\"cc\\\"ccc";
a = a.escapeChar($\\);
a = a.replace($\n.asString, "\\n");
a = a.replace($".asString, $\\ ++ $");
a.dump;
)
"vim --servername scvim --remote-send '<Esc>:call SCreplaceTextBlock(15,20, \"%\")<Enter>'".format(a).unixCmd;







~inline_editor = { arg cmd, line, col, code;
	"===".debug;
	[cmd, line, col, code].postcs;
	"===".debug;
	code.interpret;
	"--===".debug;
};
