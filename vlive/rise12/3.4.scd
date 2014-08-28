(
Ndef(~name+++\lfo1, { 
	var freq = Duty.kr(2/~t,0,Dseq([4,8,2,1],inf));
	SinOsc.kr(freq / ~t).range(0,10)  
});
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { 
	var freq = Duty.kr(2/~t,0,Dseq([4,8,2,1],inf));
	SinOsc.kr(freq / ~t).range(0,1)  
});
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Pdef(~name +++ \pre, PmonoArtic(~name,
	//\freq, Pseq([])462,
	\note, Pseq([
		-1,0,-2,0,
		-1,0,-2,0,
		7,0,1,0,
		2,0,1,0,
	],inf) + Prand([-14,0,0,0,0,0,4],inf),
	\octave, 6,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.04) ],
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.44) ],
		[ Env.adsr(0.01,0.1,0.8,0.14) ],
	],inf),
	\flag, Pseq([0,0.1,0.5,0, 0,0.1,0,0],inf),
	\legato, Prand([1,0.2,0.3,0.8],inf),
	\ampB, 1000.01,
	\ampB, 0.01,
	\dur, 1/2,
	\select1, 0,
	\ampB, Ndef(~name+++\lfo1),
	\select1, Ndef(~name+++\lfo2),
	\lfratio, 9,
	\igate, Pseq([
		1,0.2,1,1, 0.2,0,0.81,0,
		1,0,1,0, 1,0,0.81,0,
	],inf),
	\isRest, Pseq([1,1,1,1],inf).coin.not,
));
)
