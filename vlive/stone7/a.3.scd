(
// TAGS: pdef, voice, calm
Ndef(~name+++\lfo1, { SinOsc.kr(1*~t).range(0.3,0.4)  });
Ndef(~name+++\lfo2, { SinOsc.kr([0.1,0.01,0.15]*~t).range(0.8,1.09).sum/3;  });
Pdef(~name +++ \pre, Pbind(
	\pitch_stretch, Pseq([0.9,1.1,1],inf).stutter(3),
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	\pitch_stretch, Ndef(~name+++\lfo2),
	\time_stretch, Pseq([0.03,0.12,0.7,0.1],inf).stutter(1) * Pseg(Pseq([1,1.2,0.8],inf),1),
	\legato, Pseq([
		4.8,0.1,0.1,0.1,
		0.1,0.1,0.4,0.1,
	],inf),
	\randrate, 0,
	\randframes, 0,
	\pos, Ndef(~name+++\lfo1),
	\pos, Pseq([0,0.3]+0.13,inf),
	\amp, 0.3,
	\freq, 100,
));
);

