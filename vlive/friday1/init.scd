TempoClock.default.tempo = t = 75 / 60;
Veco.main.board_size = Point(16,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
~load_standard_quickpad.();

~set_exec_zone.(Rect(0,32,8,64));

~fxcomb = '32';
~fxbufstut = '33';
~fxrlpf = '34';
MIDIBoard.map(\c5, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('32')) });
MIDIBoard.map(\c6, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('33')) });
MIDIBoard.map(\c7, { ~midi_macro_manager.map_node_macro_to_knobs(Veco('34')) });

Veco.exec_file("trigpad.scd");

(
		Veco.main.clip.response_launcher_on_hook = { arg self, pos, opos, mod;
			var ev;
			var funs;
			[pos, opos, mod].debug("response_launcher_on_hook===");
			ev = ~launcher_lib;
			funs = [
				{Veco.main.clip_offset = Point(0,0)},
				{Veco.main.clip_offset = Point(8,0)},
				{ev.no_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane; Veco.main.clip_offset = Point(Veco.main.clip_offset.x,0)},

				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+4)},
				{ev.mid_pane; Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32+8)},
				{ev.no_pane},
			];

			funs[pos.y].value;
			Veco.main.clip.render_state;

		};
);

// END

Veco.main.fadeout_time = 16;

