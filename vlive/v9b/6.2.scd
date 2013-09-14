
(
Ndef(~name+++\lfo1, { 
	LFNoise0.kr(1).range(50,5000)
});
Ndef(~name+++\lfo2, { 
	var sig = Impulse.kr(15);
	sig = Lag.kr(sig, 0.01);
	sig = sig.range(50,300);
	//sig.poll;
});
Ndef(~name+++\lfo3, { 
	var sig = SinOsc.kr(1).range(0.01,0.99);
	sig;
});
Pdef(~name +++ \pre, Pbind(
	\freq, Ndef(~name+++\lfo2).bus.asMap.postln,
	//\cutoff, Pseq([100,500,2000],inf),
	\cutoff, Ndef(~name+++\lfo1),
	//\cutoff, Pwhite(100,800.0),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
	],inf),
	\dur, 1/4,
	\isRest, Veco(~namex).isrest(16),
	\legato, 1.5,
	\pwidth, Ndef(~name+++\lfo3),
	//\rq, Ndef(~name+++\lfo1, { PulseCount.kr(Dust.kr(1),Dust.kr(1))*0.1 }),
	\rq, 0.3,
));

);
