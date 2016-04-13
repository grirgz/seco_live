
(
RandDelayNetwork(\default).make(~name+++\fx, "4-2HGI-TUO4");
Ndef(~name+++\fx).put(100, \pset -> Pbind(  
		'wet10', 0.52222222222222,
		'fb', 0.0003366916411885,
		'delay2', 0.0001,
		'delay', Pswitch1([ 0.0001755676291275, Pwhite(0.3021,0.777).stutter(8)], Pseq([
			0,0,0,0, 0,0,0,0,
			0,1,1,1, 0,0,0,0,
			0,0,0,0, 0,0,0,1,
			1,1,0,1, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,1,1,0, 0,1,0,0,
			1,0,1,1, 0,0,0,1,
			1,1,0,1, 0,0,0,0,
		],inf),inf).trace,
		//\delay, 0.6,
		\dur, 1/2,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 0.76022202867323,
		'pitchlag', 1.0,
		'pitchmix', 1.0,
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
));
);

