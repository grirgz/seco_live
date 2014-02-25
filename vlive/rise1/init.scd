TempoClock.default.tempo = t = 75/60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.exec_file("trigpad.scd");
Veco.load_lib("synth.scd");

~load_standard_quickpad.();

(
~matrix_ctrl.set_fxlist([
	BusDef('fx1'),
	BusDef('fx2'),
	BusDef('fx3'),
	BusDef('fx4'),
]);
);

~fx_do = { arg offset=54, len=8, fun;
	len.do { arg x;
		var node;
		var index;
		index = offset + x;
		node = Veco.main.get_node_by_index(index);
		if(node.is_present) {
			fun.(index, node, x);
		}
	
	}
};

~fx_do.(56,8, { arg index, node, x;
	[index, node.uname].debug("index");
	MIDIBoard.map(\c+++(x+1), { ~midi_macro_manager.map_node_macro_to_knobs(node) });
});


// END

4.do { arg }
MIDIBoard.map(\c1, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('56')) });
MIDIBoard.map(\c6, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('33')) });
MIDIBoard.map(\c7, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('34')) });
MIDIBoard.map(\c8, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('35')) });

Veco.main.fadeout_time = 16;

(
	8.do { arg x;
		
		var val = Veco.main.get_node_by_index(x+Veco.main.clip_offset.x);
		var key = val.uname;
		
		if(val.has_mixer) {
			key.postln;
			Ndef(key+++\mixer).play(BusDef('fx1'));
			//Ndef(key+++\mixer).play(0);
		};
	}
)

BusDef('fx1')
