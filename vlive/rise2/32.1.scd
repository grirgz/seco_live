Pdef(~name +++ \pre, Pbind(
	\isRest, Veco(~namex).isrest(32),
	\drive, 50,
	\drive, 15,
	\mixdist, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.1,1)  });,
	\mixdist, Pseq([0.7,0.2],inf).stutter(4),
	\env0, [ Env.new([0.5, 1, 1.5, 0], [0.205, 0.16, 0.4], [-4, -2, -4]) ],
	\mfreq, ~midi.(\k1, 35, \midi.asSpec).valpattern,
	\env1, Plazy({ arg ev;
		[ Env.new([70, ev.mfreq, 30], [0.125, 0.29], [-4, -5]) ];
	}).loop
));

// END

Ndef(~name+++\mixer).edit
\midi.asSpec
