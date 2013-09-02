Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([
		Pseq([700,650],4),
		Pseq([700,650]-100,4),
	],inf),
	\freq, Ndef(~name+++\noise, { LFNoise0.kr(15).exprange(40,700) }).bus.asMap,
	\sustain, Pseq([1,0.7,0.1,0.6,0.3],inf),
	\dur, 1/4,
	\adsr, [Env.adsr(0.41,0.1,0.8,0.5)],
));
