(
Ndef(~name+++\lfo1, { arg fmfreq; SinOsc.kr(fmfreq).range(100,4100)  });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8]*8,inf),
	\dur, 1/4,
));
Ndef(~name+++\lfo2, { arg fmfreq; SinOsc.kr(fmfreq).range(0.100,1.4100)  });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\fmfreq, Pseq([4,2,8,4]*1,inf),
	\dur, 1,
));
Pdef(~name +++ \pre, Pbind(
	\noisefreq, 10.1,
	\dur, 1/2,
	\delayfactor, 0.8,
	\shift, -230,
	\degree, Pseq([0],inf),


	\fbase, 200 + Pseq([1,1.5,1.7,0.5],inf).stutter(4),
	\fbase, Ndef(~name+++\lfo1),
	\fbase2, 150,

	\fscale, Pseq([1.8,1.7,0.6],inf),
	\fscale2, 3.4,
	\fscale2, Pseq([4.8,1,1.7,0.6],inf),

	\decay, 2.8,
	\decay2, 2.1,

	\freqfactor, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Pseq([1,1.1,0.42,1.3],inf),
	\freqfactor2, Ndef(~name+++\lfo2),
	\freqfactor, 1,
));
);
