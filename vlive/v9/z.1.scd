Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0,0.1)  });
Pdef(~name +++ \pre, Pbind(
	\pitch_stretch, Pseq([0.4,0.3],inf).stutter(3),
	\pitch_stretch, Pseq([0.9,1.1,1],inf).stutter(3),
	\pos, Pseq([0,0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, 0.1,
	\freq, 100,
));
