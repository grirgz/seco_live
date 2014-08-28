(
Ndef(~name+++\lfo1, { 
	var freq = Duty.kr(2/~t,0,Dseq([4,8,2,1],inf));
	SinOsc.kr(freq / ~t / 4 ).range(0,10)  
});
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { 
	var freq = Duty.kr(2/~t,0,Dseq([4,8,2,1],inf));
	SinOsc.kr(freq / ~t / 4 ).range(0,1)  
});
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Pdef(~name +++ \pre, PmonoArtic(~name+++\b,
	//\freq, Pseq([])462,
	\degree, Pseq([
		-3,0,-8,0,
		-3,0,4,0,
	],inf).stutter(4),
	\freq, Pstep(Pseq([200,220,210,230],inf),4),
	\freq, Pstep(Pseq([200,220,210,230],inf),4) * Pseq([1,2,1,1, 0.5,2,1,4],inf).stutter(6) * 2,
	\octave, 6,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.04) ],
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.04) ],
		[ Env.adsr(0.01,0.1,0.8,0.14) ],
	],inf),
	\legato, 1,
	\ampB, 1000.01,
	\ampB, 0.01,
	\dur, 1/8,
	\select1, 0,
	\ampB, Ndef(~name+++\lfo1),
	\select1, Ndef(~name+++\lfo2),
	\lfratio, 9,
	\igate, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,1,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
	],inf),
	\isRest, Pseq([1,1,1,1],inf).coin.not,
));
)
