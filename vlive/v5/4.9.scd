Ndef(\lfo1, { SinOsc.kr(4).range(100,1000) });
Ndef(\line1, { XLine.kr(100,2004,10) });
Pdef(~name +++ \pre, Pbind(
	\freq, 300 + Pseq([100,200,300,250],inf) + Pwhite(0,50.0,inf),
	\freq, Ndef(\line1).bus.asMap,
	\fmrange, Ndef(\lfo1),
));
