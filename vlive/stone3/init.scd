TempoClock.default.tempo = t = ~t = 1.25;
Veco.main.board_size = Point(32,64);
Pdef.defaultQuant = 4;
Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
~load_standard_quickpad.();
~define_effects.(['56','57','58','59']);

~trigpadboard = Veco.open_side_project( Veco.main.project_name +/+ "trigpad1");

(
~set_launcher.(4, { arg self;
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


"/home/ggz/eelel"
