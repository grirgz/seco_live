(

	RandDelayNetwork(\default).make(~name+++\fx, "4-2HGI-TUO4");
	Ndef(~name+++\fx).put(100, \pset -> Pbind(  
		'wet10', 1.0,
		'fb', 0.0111,
		'delay', 0.10060271877857795,
		'delay2', 0.20015807120808317,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 9.9255614944957,
		'pitchlag', 1.0,
		'pitchmix', 0.5,
		'prelpf', 17000,
		'prehpf', 20.0,
		'lpf', 20000.0,
		'hpf', 20.0,
		'fbdistamp', 16.556846592035,
		'fbdistmix', 1.0,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.34450701402394,
		'wet20', 1.0,
		'mamp', 0.98471291942974,
		'gain', 0.49336937888347,
	).keep(1)
);
);
Veco(~namex).response_mode = \exec;


// END

RandDelayNetwork(\default).code
RandDelayNetwork(\default).getPbindCompileString(~name+++\fx)
