
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([700,650],4),
		Pseq([700,650]-100,4),
	],inf) - Pseq([100,200,300]/2,inf),
	\freq, Pseq([100,50],inf),
	\rfreqtab, [ [0.1,0.5,0.5,0.1, 1.1,0.5,2,3] ] * Pseq([2,1,0.5,0.25,0.125],inf),
	\ffreq, Pseq([100,200,350,300],inf),
	\ffreq, Ndef(~name+++\lfo1, { SinOsc.kr(SinOsc.kr(1).range(1,40)).range(100,1400) }),
	\sustain, 0.2,
	\adsr, [Env.adsr(0.01,0.1,0.8,0.05)],
));
