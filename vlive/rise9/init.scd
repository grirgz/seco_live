TempoClock.default.tempo = ~t = 1.0;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples.scd");
~load_standard_quickpad.();
~rsize = 8;

~define_effects.(['56','57','58','59']);
(
{
	var x = 56;
	MIDIBoard.map(\c5, { ~midi_macro_manager.map_node_macro_to_knobs(Veco(( x+0 ).asSymbol)) });
	MIDIBoard.map(\c6, { ~midi_macro_manager.map_node_macro_to_knobs(Veco(( x+1 ).asSymbol)) });
	MIDIBoard.map(\c7, { ~midi_macro_manager.map_node_macro_to_knobs(Veco(( x+2 ).asSymbol)) });
	MIDIBoard.map(\c8, { ~midi_macro_manager.map_node_macro_to_knobs(Veco(( x+3 ).asSymbol)) });
}.value;
);

// END

Veco.main.fadeout_time = 16;

