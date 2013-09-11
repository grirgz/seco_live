(
Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.3,0.4)  });
Ndef(~name+++\lfo2, { LFCub.kr([1.1,1.01,1.15]*2).range(0.1,1.09).clip(0.8,0.9).sum/3;  });
Pdef(~name +++ \pre, Pbind(
	\pitch_stretch, Pseq([0.9,1.1,1],inf).stutter(3),
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	\pitch_stretch, Ndef(~name+++\lfo2),
	\time_stretch, Pseq([0.03,0.1],inf).stutter(3),
	\isRest, Veco(~namex).isrest(16),
	\randrate, 0,
	\randframes, 0,
	\pos, Ndef(~name+++\lfo1),
	\pos, Pseq([0,0.3,0.3,0.2]+0.73,inf),
	\amp, 0.2,
	\freq, 100,
));
);
