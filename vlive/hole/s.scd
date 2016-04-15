~name = 'hole-s';

RandDelayNetwork(\default).define_specs;

~ndef_channel.();
//Ndef(~name+++\fx).addSpec(\inbus, XBusSpec());
Ndef(~name+++\fx).lag(\delay, 1/4);
Spec.add(\inbus, XBusSpec());

(
[
	\fb,
	\delay,
	\delay2,
	\distamp,

	\pitchmix,
	\pitchlag,
	\shift,
	\shift2,

	\mamp,

	\prelpf,
	\prehpf,
	\lpf,
	\hpf,

	\postlpf,
	\posthpf,
	\fbdistamp,
	\fbdistmix,
].collect({ arg key, x; 
	var tt = (1..9).collect({ arg x; (\k++x).asSymbol }) ++ (1..9).collect({ arg x; (\s++x).asSymbol });
	~set_macro.(tt[x].debug("fdf"), Param(Ndef(~name+++\fx), key));
});
)

// END

Ndef(~name+++\fx).clear
Ndef(~name+++\fx).objects
Param(Ndef(~name+++\fx) , \fb).spec
\fb.asSpec
\distamp.asSpec
