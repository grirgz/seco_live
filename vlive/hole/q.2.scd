
(
	RandDelayNetwork(\default).make(~name+++\fx, "4-PH0R-N44E");
	Ndef(~name+++\fx).put(100, \pset -> 

		Pbind(  
			'wet10', 1,
			'fb', 0.00027745414263437,
			'delay', 0.0011,
			'delay2', 0.00027602275220903,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 264.6746092985,
			'pitchlag', 1.0,
			'pitchmix', 0.8,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 16.193275996345,
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
