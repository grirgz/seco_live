
RandDelayNetwork(\default).make(~name+++\fx, "4-58IJ-9QS2");
(
Ndef(~name+++\fx).put(100, \pset -> Pbind(  
		'wet10', 1.02222222222222,
		'fb', 0.0000366916411885,
		//'delay2', 0.0001,
		\delay2, 0.00006,
		\delay, 0.000001,
		'delay', Pswitch1([ 0.0001755676291275, Pwhite(0.7021,0.177).stutter(8)], Pseq([
			0,0,0,0, 1,1,1,0,
			0,0,1,1, 0,1,1,0,
			0,0,1,1, 1,1,1,0,
			0,0,1,1, 0,0,0,0,
		],inf),inf),
		\dur, 1/4,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 100.76022202867323,
		'pitchlag', 1.0,
		'pitchmix', 0.0,
		'prelpf', 17000,
		'prehpf', 17,
		\lpf, 17000,
		'hpf', 17,
		'fbdistamp', 1.193275996345,
		'fbdistmix', 1.0,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.69340221200127,
		'wet20', 1.0,
		'mamp', 0.59978458294429,
		'gain', 0.95177020082612,
));
);

// END



Ndef(~name+++\fx).lag(\delay, 1/2);
Ndef(~name+++\fx).put(100, nil)
Ndef(~name+++\fx).clear

