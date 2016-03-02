

(
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

	osc = SinOsc.ar( EnvGen.kr(Env([400,150,151],[0.01,0.08]), 1) );
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
	\dur, 1/2,
	\isRest, Pseq([
		1,0,1,0, 0,0,1,0,
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		1,0,0,1, 0,0,0,0,
		1,1,0,0, 0,0,0,1,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
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
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/2,
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
		],2),
	],inf).coin.not,
	\amp, 0.20
));

)

(
Pdef(\main, Ppar([
	Pbind(\out, BusDef(\fx1)) <> Pdef(\kick),
	Pdef(\hat),
	Pbind(\out, BusDef(\fx1)) <> Pdef(\snare),
	Pdef(\snarehat),
])).play;
)


RandDelayNetwork(\default).make(\fx1, "5--", BusDef(\fx1)).play
RandDelayNetwork(\default).make(\fx1, "5-R45B-R2G9", BusDef(\fx1)).play
RandDelayNetwork(\default).getPbindCompileString(\fx1)

(
Ndef(\fx1).put(100, \pset ->
Pbind(  
		'wet10', 0.51111111111111,
		'fb', 0.00037253609893317,
		'delay', 0.14307229891938,
		'delay2', 0.00059948425031894,
		'shift', 1.4444444444444,
		'shift2', 0.27777777777778,
		'distamp', 0.93559571119222,
		'pitchlag', 1.0,
		'pitchmix', 0.0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 20000.0,
		'hpf', 20.0,
		'fbdistamp', 0.13142633204586,
		'fbdistmix', 0.66666666666667,
		'postlpf', 20000.0,
		'posthpf', 20.0,
		'wetamp', 0.13572088082975,
		'wet20', 1.0,
		'mamp', 2.0798382188999,
		'foldlfo', 0.71687116443689,
		'fold', 3.6625171314945,
		'delfmamp', 0.61384946029043,
		'delrange', 1.31159776084e-05,
		'delfm', 1.9760927840044,
).keep(1)
)
)

Ndef(\fx1).edit
