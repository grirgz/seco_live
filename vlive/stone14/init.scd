Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(1);
~load_standard_quickpad.();

// patchgrid matrix
(
	8.do { arg x;
		BusDef(\in+++x, \audio);
	};
	8.do { arg x;
		BusDef(\out+++x, \audio);
	};
);

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

// fx project
(
Veco.main.pane_rect = Rect(0,4,8,4);
Veco.main.pane_offset = Point(64,0);
Veco.main.pane_target_project = Veco.project_slots[2]; 
Veco.main.clip.update_display;
)

~trigpadboard = Veco.open_side_project( Veco.main.project_name +/+ "fx1");
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
