Ndef(~name+++\lfo1).quant = 2;
Pdef(~name +++ \pre, 
	Pbind(
		//\fratio, Pseq([1,2,4]/4,inf),
	)<>

	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\isRest1, Veco(~namex).isrest(64),
	\isRest2, Pseq([
		//Pser([0.2,0.9],32),
		Pser([0.9,0.9,0.9,0.9, 0.2,0.9,0.9,0.9]+0.9,32),
	],inf).coin,
	\isRest, Pfunc{ arg ev;
		(ev[\isRest1].not or: ev[\isRest2].not).not
	},
	\fratio, 2,
	\fratio, Pseq([1.5,2.3,2.7,2.1,1.8],inf).stutter(1),
	//\release, Pseq([0.1,0.7, 0.5,0.1, 1.1]/2,1),
	//\release, Pn(0.21,1),
	//\modamp, Ndef(~name+++\lfo1),
	\rq, 0.9,
));
//Ndef(~name+++\lfo1, { LFPulse.ar(16*t).range(0.2,1) });
//Ndef(~name+++\lfo1, { DC.ar(1) });


// END

Sdef(~name, \mypreset).edit
