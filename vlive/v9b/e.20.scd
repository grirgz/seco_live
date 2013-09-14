Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.3,0.4)  });
Pdef(~name +++ \pre, Pbind(
	\pitch_stretch, Pseq([0.9,1.1,1],inf).stutter(3),
	\pitch_stretch, Pseq([0.4,0.3]+0.3,inf).stutter(3),
	\time_stretch, Pseq([1.8,4.3]+0.3,inf).stutter(3),
	\pos, Pseq([0,0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\legato, Pseq([0.1,0.5,1.2,0.9],inf),
	\amp, 0.3,
	\freq, 100,
));
