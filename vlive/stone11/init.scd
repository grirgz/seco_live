Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(8);
~set_project_tempo.(1);
~load_standard_quickpad.();

~kick = Veco(\r).uname;
~hat = Veco(\t).uname;
~snare = Veco(\y).uname;

~trigpadboard = Veco.open_side_project( Veco.main.project_name +/+ "trigpad1");

(

~set_launcher.(4, { arg self; self.offset = Point(4,0)*8 });
~set_launcher.(5, { arg self; self.offset = Point(5,0)*8 });
~set_launcher.(6, { arg self;
	self.mid_pane;
	Veco.main.pane_offset = Point(0,64);
	Veco.main.pane_target_project = ~trigpadboard;
});
~set_launcher.(7, { arg self;
	self.no_pane;
});
);


// END



~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

