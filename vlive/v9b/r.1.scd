Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.3,0.4)  });
Ndef(~name+++\lfo2, { SinOsc.kr(1).range(0.1,5.9)  });
Pdef(~name +++ \pre, Pbind(
	\pitch_stretch, Pseq([0.9,1.1,1],inf).stutter(3),
	\pitch_stretch, Pseq([0.4,0.3]+0.3,inf).stutter(3),
	\pitch_stretch, Ndef(~name+++\lfo2),
	\time_stretch, Pseq([0.03,[0.03,10],10],inf).stutter(3),
	\pos, Pseq([0,0.1],inf),
	\pos, Ndef(~name+++\lfo1),
	\amp, 0.1,
	\freq, 100,
));
