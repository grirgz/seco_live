Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(1);
~load_standard_quickpad.();

~kick = Veco(\r).uname;
~hat = Veco(\t).uname;
~snare = Veco(\y).uname;

// load trigpads

// END


(
~set_launcher.(4, { Veco.main.clip_offset = Point(4,0)*8 });
~set_launcher.(5, { Veco.main.clip_offset = Point(5,0)*8 });
~set_mod_launcher.(0, { arg self;
	self.mid_pane;

	Veco.main.clip_offset = Point(5,0)*8 ;
	Veco.main.clip_offset = Point(5,0)*8 ;
})
)

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

