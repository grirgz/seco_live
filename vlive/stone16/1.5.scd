(
Ndef(~name+++\lfo2, { LFNoise1.kr(1/39).range(30,55)  });
Ndef(~name+++\lfo3, { LFNoise1.kr(1/22).range(0.030,0.55)  });
Pdef(~name +++ \pre, Pbind(
	\lfo2, Ndef(~name+++\lfo2).bus,
	\lfo3, Ndef(~name+++\lfo3).bus,
	\env0, Pfunc({ arg ev;
		[ Env.new([0.5, 1, 0.5, 0], [0.005, ev[\lfo3].getSynchronous, 0.4], [-4, -2, -4]) ];
	}),
	\env1, Pseq([
		Pfunc({ arg ev;
			[ Env.new([71, ev[\lfo2].getSynchronous, 29], [0.015, 0.29], [-4, -5]) ];
		}),
	],1),
	\hpfreq, Ndef(~name+++\lfo1, { SinOsc.kr(1/28).range(10,300)  }),
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\dur, 1/2,
	\spread, 0.1,
	\isRest, Pseq([
		1,1,1,1,
		0,0,0,0,
		1,0,1,0,
		0,0,1,0,
	],inf).coin.not,
));
)

// END

[0.6]
