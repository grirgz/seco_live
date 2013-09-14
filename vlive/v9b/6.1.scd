
(
Ndef(~name+++\lfo1, { 
	var sig = PulseCount.kr(Dust.kr(4),Dust.kr(0.1))*100;
	//sig.poll;
	sig;
});
Ndef(~name+++\lfo2, { 
	var sig = PulseCount.kr(Dust.kr(4),Dust.kr(0.8))*100;
	sig = (800 - sig).abs + 50;
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
