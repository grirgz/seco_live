
// END

// disabled because preset

~name = 'presets_perc2-8';
~ndef_channel.();
(
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
);
BusDef(~name+++\fx, \audio,2);
~make_fx.();
Ndef(~name+++\fx).set(\inbus, BusDef(~name+++\fx));
[\1,\2,\3,\4,\5,\6,\7].do { arg name; ~set_out_bus.(name, BusDef(~name+++\fx)) }




//===================================

[\1,\2,\3,\4,\5,\6,\7].do { arg name; ~set_out_bus.(name, 0) }
[\a].do { arg name; ~set_out_bus.(name, 0) }
Veco(\e).master_bus

Ndef(~name+++\fx).clear
(
Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = sig * SinOsc.ar(720);

	sig;
});
);
