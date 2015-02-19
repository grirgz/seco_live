~trigpadboard = Veco.open_side_project( Veco.main.project_name +/+ "fx1");

Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("samples_slices.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(70/60);
~load_standard_quickpad.();

(
~set_launcher.(4, { arg self;
	self.mid_pane;
	Veco.main.pane_offset = Point(64,0);
	Veco.main.pane_target_project = ~trigpadboard;
});
~set_launcher.(7, { arg self;
	self.no_pane;
});
);
~define_effect.(1, ~trigpadboard.use ({ Veco('1').uname }) );
~define_effect.(2, ~trigpadboard.use ({ Veco('2').uname }) );
~define_effect.(3, ~trigpadboard.use ({ Veco('3').uname }) );
~define_effect.(4, ~trigpadboard.use ({ Veco('4').uname }) );

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

~trigpadboard.use ({ Veco('1').uname })
~fx3
~bus = BusDef(Veco.main.name+++\fx3)
BusDef(\zero)
Ndef(~trigpadboard.use ({ Veco('3').uname })+++\fx).edit
Ndef(~trigpadboard.use ({  }))
~trigpadboard.use ({ Veco('3').execute })
~trigpadboard.use ({ Ndef(Veco('3').uname+++\fx).clear })
~trigpadboard.use ({ Ndef(Veco('3').uname+++\fx).set(\inbus, ~bus) })

Veco.activate_side_project("stone12/fx1")
Veco.activate_side_project("stone12/")
Veco.activate_main_project
