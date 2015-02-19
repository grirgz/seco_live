Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
~set_default_quant.(4);
~set_project_tempo.(1);
~load_standard_quickpad.();
~define_effect.(1, Veco('56').uname );

// END

~define_effects.(['56','57','58','59']);
Veco.main.fadeout_time = 16;

~define_effect.(2, ~trigpadboard.use ({ Veco('2').uname }) );
~define_effect.(3, ~trigpadboard.use ({ Veco('3').uname }) );

~fx1
Ndef('testme_fx-56fx').set(\inbus, ~fx1);
Ndef('testme_fx-56fx').set(\inbus, BusDef('testme_fxfx1'));
BusDef('testme_fxfx1')

/// in a fx:

~fx_channel.();
~make_fx.();

Ndef(\plop).set(\inbus, BusDef(\plop,\audio))
Ndef(\plop).set(\inbus, ~fx1)
Ndef(\plop).play
(
Ndef(\plop, {
	arg in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero,\audio)))
	
}).play;
)

BusDef(\zero)

(
Ndef(\plop).put(0, { arg preamp=1;
	var sigin;
	sigin = InFeedback.ar(\inbus.kr(BusDef(\zero)), 2);
	sigin = sigin * preamp;
	sigin;
});
);

Ndef(\plop).set(\inbus, ~fx1)
BusPool
BusDef.all
