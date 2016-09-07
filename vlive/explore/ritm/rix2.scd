
(

///////////////////////////////////



SynthDef(\zkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	//son = son * 1.2;
	//son = son.clip2(1);

	son = son * amp;
	son = son * env0 * 8;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;

SynthDef(\zhat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\zsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(Env([400,130,111],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.20], -4), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,4852,3451],[0.01,0.1]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,4452,3451],[0.01,0.1]), 1));
	snare = snare * EnvGen.kr(Env([0,1,0],[0.001,0.18], -2), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\zsnarehat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(Env([400,150,151],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.20], -4), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,7852,5451],[0.01,0.1]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,3452,3451],[0.01,0.1]), 1));
	snare = snare * EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.08], -4), 1);

	sig = click + osc + snare;

	sig = sig / 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;


Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,1,0, 1,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,
		],3),

		Prand([
			Pseq([
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		0,0,0,0, 0,0,1,0,
		1,1,1,0, 0,0,0,0,
		1,0,0,1, 1,1,1,1,
		0,0,0,0, 1,1,1,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.1
));

Pdef(\bkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\bsnare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));


)

(
Pdef(\main, Ppar([
	Pdef(\kick),
	Pdef(\hat),
	Pdef(\snare),
	Pdef(\snarehat),

	Pdef(\bkick),
	Pdef(\bsnare),

])).play;
Ndef(\rdn1).play;
Ndef(\rdn2).play;
)



(
[
	Pdef(\kick),
	Pdef(\hat),
	Pdef(\snare),
	Pdef(\snarehat),
].collect({ arg x; x.set(\out, BusDef(\sendbus1, \audio, 2)) }) ;
)

(
[
	Pdef(\bkick),
	Pdef(\bsnare),
].collect({ arg x; x.set(\out, BusDef(\sendbus2, \audio, 2)) }) ;
)

RandDelayNetwork(\default).make(\rdn1, "5--", BusDef(\sendbus1, \audio, 2));
RandDelayNetwork(\default).getPbindCompileString(\rdn1);
Ndef(\rdn1).play;
Ndef(\rdn1).stop;
Ndef(\rdn1).edit;

RandDelayNetwork(\default).getPresetCompileString(\rdn1).pbcopy.vimpbpaste;
(
RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 0.52222222222222,
	'fb', 0.0011990602545058,
	'delay', 0.095011850731814,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 37.643663592843,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 9.7558710570923,
	'fbdistmix', 0.12777777777778,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 2.376036510883,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
	'wet200', 2.0117484049213,
).keep(1));
);

(
RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 0.52222222222222,
	'fb', 0.0049151533654037,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.27303626552375,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.12078257281154,
	'fbdistmix', 0.12777777777778,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 2.376036510883,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
	'wet200', 2.0117484049213,
).keep(1));
);



(
Ndef(\rdn1).put(200, \filter -> {
	arg in;
	in.mean ! 2;
});
Ndef(\rdn2).put(200, \filter -> {
	arg in;
	in.mean ! 2;
});
)




RandDelayNetwork(\default).make(\rdn2, "5--", BusDef(\sendbus2, \audio, 2));
Ndef(\rdn2).play;
Ndef(\rdn2).edit;

RandDelayNetwork(\default).getPresetCompileString(\rdn2).pbcopy.vimpbpaste;
(
RandDelayNetwork('default').make('rdn2', "5-OQD1-LRS2");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0034495383368566,
	'delay', 0.12271252398512,
	'delay2', 0.095011850731814,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2623832454686,
	'pitchlag', 2.0,
	'pitchmix', 0.98333333333333,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.04928645605,
	'fbdistmix', 0.96111111111111,
	'postlpf', 19247.012527962,
	'posthpf', 20.0,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
	'wet200', 1.0,
).keep(1));
);

(
RandDelayNetwork('default').make('rdn2', "5-B2NP-H1EH");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.021311277185749,
	'delay', 0.15058363542798,
	'delay2', 0.00020469682718075,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.647548972442,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.84255998715291,
	'fbdistmix', 1.0,
	'postlpf', 17000,
	'posthpf', 60.864397742154,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
	'wet200', 1.0,
).keep(1));
);



//////////////////////


RandDelayNetwork(\default).make(\rdn1, "5--", BusDef(\sendbus1, \audio, 2));
RandDelayNetwork(\default).getPbindCompileString(\rdn1);
Ndef(\rdn1).play;
Ndef(\rdn1).stop;
Ndef(\rdn1).edit;

RandDelayNetwork(\default).getPresetCompileString(\rdn1).pbcopy.vimpbpaste;



RandDelayNetwork(\default).make(\rdn2, "5--", BusDef(\sendbus2, \audio, 2));
Ndef(\rdn2).play;
Ndef(\rdn2).edit;

RandDelayNetwork(\default).getPresetCompileString(\rdn2).pbcopy.vimpbpaste;


////////////////////////////////////////////////////////////////

(
/////// PART 1
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,1,0, 1,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,
		],3),

		Prand([
			Pseq([
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		0,0,0,0, 0,0,1,0,
		1,1,1,0, 0,0,0,0,
		1,0,0,1, 1,1,1,1,
		0,0,0,0, 1,1,1,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.1
));

Pdef(\bkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\bsnare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 0.52222222222222,
	'fb', 0.0049151533654037,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.27303626552375,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.12078257281154,
	'fbdistmix', 0.12777777777778,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 2.376036510883,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
	'wet200', 2.0117484049213,
).keep(1));

RandDelayNetwork('default').make('rdn2', "5-OQD1-LRS2");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0034495383368566,
	'delay', 0.12271252398512,
	'delay2', 0.095011850731814,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2623832454686,
	'pitchlag', 2.0,
	'pitchmix', 0.98333333333333,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.04928645605,
	'fbdistmix', 0.96111111111111,
	'postlpf', 19247.012527962,
	'posthpf', 20.0,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
	'wet200', 1.0,
).keep(1));

)

////////////////////////////////////////////////////////////////////////////////////////////////////
(
/////// PART 2
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,1,
			0,0,0,0, 1,0,1,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],3),

		Prand([
			Pseq([
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		1,1,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,1,0, 0,0,0,0,
			0,0,1,0, 0,0,0,0,
			0,0,1,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,

			0,0,0,0, 0,0,1,0,
			0,0,1,0, 0,0,0,0,
			0,0,1,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,
		],3),
	],inf).coin.not,
	\amp, 0.1
));

Pdef(\bkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\bsnare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 0.52222222222222,
	'fb', 0.00064985507641938,
	'delay', 0.00029286445646252,
	'delay2', 0.00015848931924611,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.27303626552375,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.12078257281154,
	'fbdistmix', 0.12777777777778,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 2.376036510883,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
	'wet200', 2.0117484049213,
).keep(1));
RandDelayNetwork('default').make('rdn2', "5-OQD1-LRS2");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.00019301194235932,
	'delay', 0.090272517794846,
	'delay2', 0.12915496650149,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2623832454686,
	'pitchlag', 2.0,
	'pitchmix', 0.98333333333333,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.04928645605,
	'fbdistmix', 0.96111111111111,
	'postlpf', 19247.012527962,
	'posthpf', 20.0,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
	'wet200', 1.0,
).keep(1));

)

///////////////////////////
(
/////// PART FAST
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		0,0,0,0, 1,0,1,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.1
));

Pdef(\bkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,

		1,0,0,0, 1,0,0,1,
		0,0,0,0, 0,0,0,0,

		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,

		1,0,0,1, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\bsnare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

RandDelayNetwork('default').make('rdn1', "5-U5AA-U9GB");
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 0.52222222222222,
	'fb', 0.0012542979055177,
	'delay', 0.00035938136638046,
	'delay2', 0.00037824899063894,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2210553000676,
	'pitchlag', 0.89125093813375,
	'pitchmix', 1.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 11.073456864011,
	'fbdistmix', 0.68888888888889,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 2.376036510883,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
	'wet200', 2.0117484049213,
).keep(1));

RandDelayNetwork('default').make('rdn2', "5-SIAS-CHHE");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.00011638688420065,
	'delay', 0.0018478497974223,
	'delay2', 0.012915496650149,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.5936114584398,
	'pitchlag', 0.45620816316516,
	'pitchmix', 1.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.04928645605,
	'fbdistmix', 0.51666666666667,
	'postlpf', 19247.012527962,
	'posthpf', 20.0,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
	'wet200', 1.0,
).keep(1));

)

////////////////////////////////////////////////////////////////////////////////////////////////////

(
/////// PART INTRO
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		0,0,0,0, 0,0,1,0,
		1,1,1,0, 0,0,0,0,
		1,0,0,1, 1,1,1,1,
		0,0,0,0, 1,1,1,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.1
));

Pdef(\bkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\bsnare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 0.52222222222222,
	'fb', 0.0049151533654037,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.27303626552375,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.12078257281154,
	'fbdistmix', 0.12777777777778,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 2.376036510883,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
	'wet200', 2.0117484049213,
).keep(1));

RandDelayNetwork('default').make('rdn2', "5-OQD1-LRS2");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0034495383368566,
	'delay', 0.12271252398512,
	'delay2', 0.095011850731814,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2623832454686,
	'pitchlag', 2.0,
	'pitchmix', 0.98333333333333,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.04928645605,
	'fbdistmix', 0.96111111111111,
	'postlpf', 19247.012527962,
	'posthpf', 20.0,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
	'wet200', 1.0,
).keep(1));

)


(
////////////////////////////// PART 1 IMP
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,1,0, 1,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,
		],3),

		Prand([
			Pseq([
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],1),
			
			Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		0,0,0,0, 0,0,1,0,
		1,1,1,0, 0,0,0,0,
		1,0,0,1, 1,1,1,1,
		0,0,0,0, 1,1,1,0,

		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
		0,0,0,0, 0,0,0,0,

		0,0,0,0, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

~snareseq = ~snareseq ?? {StepEvent.new};
//~snareseq = nil;
//~snareseq.addSpec(\list, \unipolar);
//~snareseq.[\isRest].collect(_.asInteger).asCompileString.pbcopy.vimpbpaste

Pdef(\snare, 
	//Pn(~snareseq) <> 
	Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0, 0, 0, 0,  0, 0, 0, 0, 
			0, 0, 0, 0,  0, 0, 1, 0, 
			0, 0, 0, 0,  0, 0, 0, 0, 
			0, 0, 0, 0,  0, 0, 0, 0,

			0, 0, 0, 0,  0, 0, 0, 0, 
			0, 0, 0, 1,  0, 0, 0, 0, 
			0, 0, 0, 0,  0, 0, 0, 0, 
			0, 0, 0, 0,  0, 0, 0, 0,

			0, 0, 1, 0,  0, 0, 0, 0, 
			1, 0, 0, 1,  0, 0, 1, 0, 
			0, 0, 0, 0,  0, 0, 0, 0, 
			1, 0, 0, 1,  0, 0, 1, 0,

			0, 0, 0, 0,  0, 0, 0, 0, 
			1, 0, 1, 0,  0, 0, 1, 0, 
			0, 0, 0, 0,  0, 0, 0, 0, 
			0, 0, 1, 0,  0, 1, 0, 0,
		],3),
		//Pseq([
		//	0,0,0,0, 0,1,0,0,
		//	0,0,0,0, 0,0,1,0,
		//	0,0,0,0, 0,0,0,0,
		//	0,0,0,0, 0,0,0,0,
		//],3),
	],inf).coin.not,
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,1,0,0,
			0,0,0,0, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,1,0,0, 0,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.1
));

Pdef(\bkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\bsnare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

RandDelayNetwork('default').make('rdn1', "5-QJTR-6638");
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 0.52222222222222,
	'fb', 0.0009151533654037,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.27303626552375,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.12078257281154,
	'fbdistmix', 0.12777777777778,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 2.376036510883,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
	'wet200', 2.0117484049213,
).keep(1));

RandDelayNetwork('default').make('rdn2', "5-OQD1-LRS2");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0034495383368566,
	'delay', 0.12271252398512,
	'delay2', 0.095011850731814,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2623832454686,
	'pitchlag', 2.0,
	'pitchmix', 0.98333333333333,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 12.04928645605,
	'fbdistmix', 0.96111111111111,
	'postlpf', 19247.012527962,
	'posthpf', 20.0,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
	'wet200', 1.0,
).keep(1));

)
