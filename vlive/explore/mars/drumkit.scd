(
///////// kicks

SynthDef(\zkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;
	var son_d;

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
	

	son_d = son * \dist.kr(1.2);
	son_d = son_d.clip2(1);
	son_d = HPF.ar(son_d, \hpf.kr(100));
	son_d = son_d * \distamp.kr(0.4);
	son = SelectX.ar(\distmix.kr(0), [son, son_d]);

	son = son * amp;
	son = son * env0 * 8;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
	env0: XEnvSpec(\amp!4),
	env1: XEnvSpec(\midinote!3),
	distmix: \unipolar,

))).store;

SynthDef(\zkick2, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
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
	env0: XEnvSpec(\amp!4),
	env1: XEnvSpec(\midinote!3),
))).store;

///////// hats

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

SynthDef(\zhat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env([0,1,0.5,0],[0.01,1,\rel.kr(0.1)],-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\zhatadsr, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = (sig * 10).tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.2,0.4,0.2,4,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

////////// snares


SynthDef(\zsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(\oscfreqenv.kr(Env([400,150,151],[0.01,0.08])), 1) );
	osc = osc * EnvGen.kr(\oscampenv.kr(Env([0,1,0],[0.001,0.20], -4)), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(\lpenv.kr(Env([14700,4852,3451],[0.01,0.1])), 1));
	snare = HPF.ar(snare, EnvGen.ar(\hpenv.kr(Env([9700,4452,3451],[0.01,0.1])), 1));
	snare = snare * EnvGen.kr(\snareampenv.kr(Env([0,1,0],[0.001,0.18], -2)), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	oscfreqenv: XEnvSpec(\freq!3),
	oscampenv: XEnvSpec(\amp!3),
	lpenv: XEnvSpec(\freq!3),
	hpenv: XEnvSpec(\freq!3),
	snareampenv: XEnvSpec(\amp!3),
	adsr: XEnvSpec.adsr,
))).add;


////////////////////////////////////////////////////

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

Pdef(\kick_var2, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
			[ Env.new([80, 31, 35], [0.025, 0.19], [-4, -5]) ],
		Pseq([
		[ Env.new([80, 31, 35], [0.035, 0.39], [-4, -5]) ],
		],3),
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		//1,0,0,0, 0,0,1,0,
		//0,1,0,1, 0,0,0,0,
		1,0,0,0, 0,1,0,1,
		0,1,1,0, 0,0,0,1,
		1,0,1,0, 0,1,0,1,
		0,1,1,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.25 * Pseq([
		1.2,1,1,1,
	],inf)/1.2,
));

Pdef(\hat_var2, Pbind(
	\instrument, \zhatadsr,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	//\dur, Pkey(\dur) * (1 + (0.11 * Pseq([1,0,-1,0],inf))).stutter(2),
	\lag, 0.01,
	\sustain, Pseq([
		1,Pn(0.1,7),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		1,0.5,Pn(0.1,6),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		//Pn(0.1,8),
		//Pn(0.1,8),
		
	],inf)+Pwhite(-0.05,0.051,inf),
	//\rel, Pkey(\sustain),
	\amp, Pkey(\amp) * Pseq([
		1,0.5,0.7,0.3,
	],inf)+Pwhite(0,0.1,inf),
	\isRest, Pseq([
		0,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		0,1,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,1,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\cym, Pbind(
	\instrument, \zcymbal,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\sustain, Pseq([
		1,Pn(0.1,7),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		1,0.5,Pn(0.1,6),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		//Pn(0.1,8),
		//Pn(0.1,8),
		
	],inf),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare_var2, Pbind(
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

Pdef(\snarehat_var2, Pbind(
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
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.20
));

Pdef(\part1, Ppar([
	Pdef(\kick),
	Pdef(\snare),
	Pdef(\snarehat),
	Pdef(\hat),
	
])).play;

);

TempoClock.default.tempo = 140/60
