(
Ndef(~name+++\lfo1, { 
	var freq = Duty.kr(2/~t,0,Dseq([4,8,2,1],inf));
	SinOsc.kr(freq / ~t / 8 ).range(0,10)  
});
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { 
	var freq = Duty.kr(2/~t,0,Dseq([4,8,2,1],inf));
	SinOsc.kr(freq / ~t / 8 ).range(0,1)  
});
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Pdef(~name +++ \pre, PmonoArtic(~name+++\c,
	//\freq, Pseq([])462,
	\degree, Pseq([
		-3,0,-8,0,
		-3,0,4,0,
	],inf).stutter(4),
	\freq, Pstep(Pseq([200,220,210,230],inf),4) * Pseq([1,2,1,1, 0.5,2,1,4],inf).stutter(6) * 2,
	\freq, Pstep(Pseq([200,220,210,230],inf),4) * 4,
	\freq, Pstep(Pseq([200,220,210,230],inf),4) * Pseq([1,2,1,1, 0.5,2,1,4],inf).stutter(32) * 2,
	\freq, Pseg(Pseq([200,220,210,230],inf),16)/2,
	\octave, 6,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.04) ],
	],inf),
	\iadsr, Pseq([
		//[ Env.adsr(0.01,0.1,0.8,0.04) ],
		[ Env.adsr(0.71,0.1,0.8,0.74) ],
	],inf),
	\legato, 1,
	\legato, Pseq([1,1,1,1, 1,1,1,0.9],inf),
	\ampB, 1000.01,
	\ampB, 0.01,
	\dur, 1/8,
	\select1, 0,
	\ampB, Ndef(~name+++\lfo1),
	\select1, Ndef(~name+++\lfo2),
	\lfratio, 2,
	\igate, Pseq([
		1,0,0,0, 1,0,0,0,
	],inf),
	\amp, Pkey(\amp) * 8,
	\isRest, Pseq([1,1,1,1],inf).coin.not,
));
)
