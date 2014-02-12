Pdef(~name+++\rhy, Pbind());
Pdef(~name +++ \pre, Pdef(~name+++\rhy) <> Pbind(
	\degree, Pseq([
		[0,2,4],
	],inf),
	//\mtranspose, Pseq([0,2,3,4],inf).stutter(32),
	\mtranspose, Pseq([0,1,3,4,3],inf).stutter(32),
	//\root, Pseq([0,3,4,3],inf).stutter(16),
	//\legato, Pseq([0.1,0.4,0.2]*8,inf),
	//\sustain, 0.05,
	\legato, Pseq([1.5,1],inf),
	\isRest, Veco(~namex).isrest(16),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.01) ],
	],inf),
	\ffreq, ~cdegcps.(Pseq([0,4,3,4]+14,inf)),
	\ffreq, 440*2,
	\dur, 1/8,
	\sustain, ~midi.(\k3, 0.1, ControlSpec(0.01,1,\exp,0,0.1)).valpattern,
	\distmix, ~midi.(\k4, 0.1, \unipolar.asSpec).vpattern,
	\ffreq, Ndef(~name+++\lfo1, { SinOsc.ar(t/2).range(1400,12000) }),
	\ffreq, ~midi.(\k1).vpattern,
	\dur, Pkey(\dur) * ~swing1,
));

// END
~swingamp = ~midi.(\k2, 0, \unipolar.asSpec).valpattern;

(
)

a = List.new
a[14] = 4
Veco.force_init
