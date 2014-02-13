TempoClock.default.tempo = t = 75 / 60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.exec_file("synth.scd");
~load_standard_quickpad.();


~fxcomb = '32';
~fxbufstut = '33';
~fxrlpf = '34';
MIDIBoard.map(\c5, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('32')) });
MIDIBoard.map(\c6, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('33')) });
MIDIBoard.map(\c7, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('34')) });

Veco.exec_file("trigpad.scd");


// END

Veco.main.fadeout_time = 16;

