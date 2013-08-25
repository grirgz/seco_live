
Ndef(\lfo1, { LFSaw.kr(Rand(0.1,3.20)).range(100,1000+Rand(0,150)) });
Ndef(\line1, { XLine.kr(100,2004,4) });
Pdef(~name +++ \pre, Pbind(
	\freq, 300 + Pseq([100,200,300,250],inf) + Pwhite(0,50.0,inf),
	\freq, Ndef(\lfo1).bus.asMap,
	\fmrange, Ndef(\line1),
));
