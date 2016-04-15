
(
	RandDelayNetwork(\default).make(~name+++\fx, "4-3BE1-5GF2");
	Ndef(~name+++\fx).put(100, \pset -> 

		Pbind(  
			'wet10', 1,
			'fb', 0.00064495581470522,
			'delay', 0.07900194712409,
			'delay2', 0.00039666620101612,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2414.0226187143,
			'pitchlag', 1.0,
			'pitchmix', 0.73228346456693,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.193275996345,
			'fbdistmix', 0.5,
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
RandDelayNetwork(\default).code
Ndef(~name+++\fx).edit
