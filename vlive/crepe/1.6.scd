Pdef(~name +++ \pre, Pbind(
	\instrument, ~name+++\2,
	\env0, [ Env.new([0.5, 4, 0.5, 0], [0.005, 0.16, 0.01], [-4, -2, -4]) ],
	\env1, [ Env.new([110, 53, 29], [0.015, 0.29], [-4, -5]) ],
	\env1, Plazy({
		[ Env.new([110, 63, 29], [0.015, 0.29], [-4, -5]) ];
	}).loop,
	//\fratio, 4.2,
	
	\timeScale, Pseq([1,Pn(0.51,7)],inf),
	//\amp, Pkey(\amp) * Pseq([1,Pn(0.5,7)],inf),
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	//\lag, Pseq([0,0.081],inf).stutter(4),
	\dur, 1/8 - Pseg(Pseq([0,0.1],inf),8),
	\dur, (2/7),
	\dur, 1/4,
	//\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([1,0.2,1,0],inf).coin.not,
	//\isRest, Pseq([
	//	1,0,1,0, 1,0,1,0,
	//],inf).coin.not,
));

// END

[0.6]

(
Ndef(~name+++\mixer)[50] = \filter -> { arg in; 
	var sig;
	var sig2;
	var sig3;
	sig = in;
	//sig = CombL.ar(sig, 0.1,0.1*SinOsc.ar(5).range(0.2,1),1) * 0.1 + sig;

	sig2 = sig;
	sig2 = CombL.ar(sig2, 0.1,1/4/t,1) * 0.1;
	sig2 = (sig2*70).clip2(0.4) * 0.4;
	sig2 = FreqShift.ar(sig2,-5);

	sig3 = sig;
	sig3 = CombL.ar(sig3, 0.1,1/8/t,1) * 0.3;

	sig = sig3 + sig2 + sig;
};
)

(
Ndef(~name+++\mixer)[50] = nil;
)
