
(
	RandDelayNetwork(\default).make(~name+++\fx, "4-PH0R-N44E");
	Ndef(~name+++\fx).put(100, \pset -> 
		Pbind(  
			'wet10', 1,
			'fb', 0,
			'delay', 0.016022283408775,
			'delay2', 0.14112576178115,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0,
			'pitchlag', 1.0,
			'pitchmix', 1.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 1,
			'fbdistmix', 1.0,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.69340221200127,
			'wet20', 1.0,
			'mamp', 0.99978458294429,
			'gain', 0.95177020082612,
		).keep(1)

	);
);
Veco(~namex).response_mode = \exec;

// END

RandDelayNetwork(\default).getPbindCompileString(~name+++\fx)
Ndef(~name+++\fx).edit
