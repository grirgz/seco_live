
Ndef(~fb1+++\fx).set(\lpf, Ndef(~name+++\lfo1, { 
	SinOsc.kr(4 * [1,2, Duty.kr(1/~t, 0, Dseq([
		1/2, 1/3, 1/3, 1/3,
		1/2, 1/2, 1/2, 1/3,
	],inf))]*~t).mean.range(50,700 * Duty.kr(1/~t, 0, Dseq([
		1,1.2,
		0.81,1.2,
	],inf)))  
}));
Veco(~namex).response_mode = \exec;	
