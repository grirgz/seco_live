
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([700,650],4),
		Pseq([700,650]-100,4),
	],inf) - Pseq([100,200,300]/2,inf),
	\freq, Pseq([800,500,600,400]/2,inf),
	\rfreqtab, Pn(Plazy{
		[ [0.1,0.5,0.5,0.1, 1.1,0.5,2,3].scramble * rrand(0.9,1.1) ] * Pseq([2,1,0.5,0.25,0.125],1);
	}),
	\ffreq, Pseq([800,900,1350,1300],inf),
	\ffreq, Ndef(~name+++\lfo1, { SinOsc.kr(LFSaw.kr(2/8).range(1,8*2)).range(100,3400) }),
	\sustain, 0.1,
	//\legato, 0.9,
	\adsr, [Env.adsr(0.01,0.1,0.8,0.05)],
));
