Veco.load_lib("main.scd");
//Veco.load_lib("synth.scd");
//
//Veco.main.board_size = Point(32,64);
//~set_default_quant.(4);
//~set_project_tempo.(1);
~load_standard_quickpad.();

~pdef_init = { arg pat;
	Pdef(~name, 
		Pdef(~name+++\patfx) <>
		Pdef(~name+++\mod) <>
		Pdef(~name+++\pre) <>
		pat
		<> Veco(~name).mixer;
	)
};

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

~pdef_init.(
	Pbind(
		\instrument, ~name,
	)
);
