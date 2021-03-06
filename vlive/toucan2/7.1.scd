Pdef(~name +++ \pre, Pbind(
	\prob, Pseq([
		0,0.5,0.2,0.7,
	],inf),
	\amp, Pkey(\amp) * 0.5,
	\dur, 1/8,
	\isRest, Pfunc({ arg ev;
		ev.isRest || ev.prob.coin;
	
	}),
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 1,1,1,1,
		1,1,0,1, 1,1,1,1,
		0,0,0,0, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 1,1,0,1,
	],inf).coin.not,
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\shift, Pseq([100,0,50,100,-200],inf).stutter(4),
	\legato, Pseq([0.1,3,0.7,1,0.5,2],inf),
	\freqfactor, Pseq([1,1.1,0.42],inf),
	\freqfactor, [
		Ndef(~name+++\lfo1, { SinOsc.ar(0.1).range(0.2,2) }),
		0.5,
	],
	\freqfactor, [0.5,3] * Pseq([1,2],inf),
	\shift, Pseq([
		Pseq([
			100,500,-500,0
		],8),
		Pseq([
			500,100,-200,-100
		],8),
	],inf).stutter(1),
	\legato, Pseq([
		1.7,1,0.1,0.5,
		0.4,1,0.4,0.5,
		0.7,0.81,1.7,0.5,
		0.4,1,0.4,0.5,

		//Pser([0.1,0.2],16),
	],inf).stutter(2) * 2,
	\adsr, Pseq([
		[ Env.adsr(0.4,0.1,0.8,0.1,1,4) ],
	],inf),
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
	],inf).coin.not,
	\isRest, Veco(~name).isrest(16),
));

// END
~t

Pdef(~name).asStream.next(Event.default).keysValuesDo({ arg k,v; "%: %,".format(k.asCompileString, v.asCompileString).postln })
