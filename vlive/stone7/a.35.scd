(
Ndef(~name+++\lfo1, { LFSaw.kr(2).range(0.3,0.4) + ( Duty.kr(1/~t, 0, Dseq([
	1,0,0,0,
],inf))/10 ) * Duty.kr(1/4/~t, 0, Dseq([
	1,4,2,1/10,
	1/10, 1/10, 1/10, 1/10,
],inf))  });
Ndef(~name+++\lfo2, { SinOsc.kr([0.1,0.01,1.15]/4).range(1.8,1.09).sum/3;  });
Ndef(~name+++\lfo3, { LFSaw.kr(1/2).range(0.03,0.4)  });
Pdef(~name +++ \pre, Pbind(
	\pitch_stretch, Pseq([0.9,1.1,1],inf).stutter(3),
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	\pitch_stretch, Ndef(~name+++\lfo2),
	\time_stretch, Pseq([0.03],inf).stutter(3),
	\time_stretch, Ndef(~name+++\lfo3),
	\randrate, 0,
	\randframes, 0,
	\pos, Pseq([0,0.3]+0.73,inf),
	\pos, Ndef(~name+++\lfo1),
	\legato, 0.3,
	\amp, 0.3,
	\freq, 100,
));
);

// END


