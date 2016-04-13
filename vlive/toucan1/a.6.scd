
(
	~iname = 'fxboard1-34';
	RandDelayNetwork(\default).make(~iname+++\fx, "4-PH0R-N44E");
	Ndef(~iname+++\fx).put(100, \pset -> 

		Pbind(  
			'wet10', 0.52222222222222,
			'fb', 0.00027745414263437,
			'delay', 0.0011,
			'delay2', 0.00862122071335,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.1,
			'pitchlag', 1.0,
			'pitchmix', 0.8,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 16.193275996345,
			'fbdistmix', 0.7,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.69340221200127,
			'wet20', 1.0,
			'mamp', 0.99978458294429,
			'gain', 0.95177020082612,
		).keep(1)
	);
);
