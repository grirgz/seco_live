
(
Ndef(~name+++\lfo1, { 
	var sig;
	sig = LFNoise0.kr(1).range(50,5000);
	sig = LPF.kr(sig, 10);
	sig;
});
Ndef(~name+++\lfo2, { arg freq=300;
	var sig = Impulse.kr(15);
	sig = Lag.kr(sig, 0.01);
	sig = sig.range(50,freq);
	//sig.poll;
});
Ndef(~name+++\lfo3, { 
	var sig = SinOsc.kr(1).range(0.01,0.99);
	sig;
});

Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\freq, Pseq([200,300,310],inf),
));
Pdef(~name +++ \pre, Pbind(
	\freq, Ndef(~name+++\lfo2).bus.asMap,
	\freq, Ptuple([
		Ndef(~name+++\lfo2).bus.asMap,
		//Pseq([200,300,310,320,410]+200,inf),
		Pslide([200,300,310,320,410]+00,inf, 3,2) + Pwhite(0,10.0),
	]),
	//\cutoff, Pseq([100,500,2000],inf),
	\cutoff, Ndef(~name+++\lfo1),
	//\cutoff, Pwhite(100,800.0),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		[ Env.adsr(0.1,0.1,0.8,0.001) ],
	],inf),
	\dur, 1/8,
	\isRest, Veco(~namex).isrest(16),
	\legato, 0.5,
	\pwidth, Ndef(~name+++\lfo3),
	//\rq, Ndef(~name+++\lfo1, { PulseCount.kr(Dust.kr(1),Dust.kr(1))*0.1 }),
	\rq, 0.3,
));

);

