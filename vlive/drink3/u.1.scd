Pdef(~name +++ \pre, Pbind(
	\env0, [ Env.new([0.5, 9, 0.5, 0], [0.005, 1.16, 0.01], [-4, -2, -4]) ],
	\env0, Pseq([
		[ Env.new([0.5, 9, 0.5, 0], [0.005, 1.16, 0.01], [-4, -2, -4]) ],
		[ Env.new([0.5, 9, 0.5, 0], [0.005, 1.16, 0.01], [-4, -2, -4]) ],
	],inf),
	\envblend, Pseg(Pseq([0,1],inf),16),
	\env0, Pfunc({ arg ev;

			var res = Env.new([0.5, 1, 1.5, 0], [0.005, 0.56, 1.01], [-4, -2, -4]).blend(

				Env.new([0.5, 9, 0.5, 0], [0.005, 1.16, 0.51], [-4, -2, -4]),
				ev[\envblend]
				
			);
			res;

	}).loop,
	\degree, Pseq([-3,0,4,2],inf).stutter(8),
	\mtranspose, Pstep(Pseq([0,0,3,4],inf),4),
	\ctranspose, -4,
	\octave, 3,
	\env1, Pfunc({ arg ev;
		[ Env.new([110, ev[\freq].cpsmidi.postln/2, ev[\freq].cpsmidi.postln], [0.015, 0.29], [-4, -5]) ]
	}),
	\pan, Pseq([
		Pser([0],17),
		Pwhite(-1.0,1.0,16-1)
	],inf).stutter(1) * 0.5,
	\spread, 0.1,
	\fratio, Pseq([0.21,2],inf).stutter(4),
	\clipamp, Pseq([1,2,4,2],inf).stutter(16),
	\clipamp, Ndef(~name+++\lfo1),
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\isRest, Pseq([
		Pser([
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],inf),
	],inf).coin.not,
));

Ndef(~name+++\lfo1, { SinOsc.kr(1/4*~t).range(0.05,10)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

// END

[0.6]
[110,53,29].midicps
