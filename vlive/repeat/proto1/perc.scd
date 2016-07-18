
(
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

SynthDef(\zhat, { arg out=0, amp=0.1, trig=1, pan=0, freq=200, ampm=1;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),trig,doneAction:2);
	sig = Pan2.ar(sig, pan, amp) * ampm;
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
	\dur, 1/8,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,1,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,0,0,

		1,0,0,0, 0,0,0,0,
		0,0,1,0, 0,0,0,1,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,

		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,1,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,0,0,

		1,0,0,0, 0,0,0,0,
		0,0,1,0, 0,0,0,1,
		1,0,0,0, 0,0,1,0,
		0,0,1,0, 1,0,1,0,
	],inf).coin.not,
	\amp, 0.15,
	\amp, Pkey(\amp) * Pseq([
		1,0.5,0.61,0.5,
		0.7,0.5,0.6,0.5,
	],inf),
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pser([
			0,0,1,0, 1,0,1,0,
			0,1,1,0, 1,0.5,1,0,
			0,0,1,1, 1,1,1,0,
		],16 * 3),
		Pser([
			1,0,
		],16),
		Pser([
			0,0,1,0, 1,0,1,0,
		],16 * 3),
		Pser([
			1,0,
		],16),
	],inf).coin.not,
	\ampm, Ndef(\hat_lfo_ampm, { SinOsc.kr(2.1*~t).range(0.6,1) }),
	\hpf, Ndef(\hat_lfo_lpf, { SinOsc.kr(2.05*~t).range(1500,7000) }),
	\rel, Pseq([0.01,0.1,0.1,0.2],inf).stutter(Prand([1,1,1,2,3,4,1,1,1,1,1,1,1,1],inf)),
	\rel, Pseq([
		Pser([0.1],16),
		Pser([0.07],16),
		Pser([0.04],16),
		Pser([
			Pseq([
				0.04,
			],4),
			0.2,
			Pseq([
				0.01,
			],3),
		],16),
	],inf),
	\amp, 0.1/8,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
		0.3,0.15,1,0.5,
		0.1,0.55,0.41,0.8,
	],inf),
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],1),
	],inf).coin.not,
	\amp, 0.2
));


SynthDef(\lide, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig + LFPulse.ar(freq * [1,2,4,2.01]);
	sig = RLPF.ar(sig, \lpfr.kr(1) * freq, \rq.kr(0.05)) + (sig/2);
	sig = LPF.ar(sig, \lpf.kr(4000), \rq2.kr(1)) + (sig/4);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

Pdef(\lide, Pbind(
	\instrument, \lide,
	\degree, Pseq([0,2],inf),
	\legato, Pseq([
		Pser([
			0.1, 0.2,
		],16 * 2),
		Pser([
			0.1, 0.2, 0.5,
		],16 * 2),
		Pser([
			0.2, 0.01, 0.7, 0.2
		],16 * 2),
	],inf),
	\octave, 3,
	\dur, 1/4,
	\amp, 0.1
));

SynthDef(\hydro, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig + LFPulse.ar(freq * [1,2,4,2.01]);
	sig = RLPF.ar(sig, \lpfr.kr(1) * freq, \rq.kr(0.05)) + (sig/2);
	sig = LPF.ar(sig, \lpf.kr(4000), \rq2.kr(1)) + (sig/4);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig / 8;
	Out.ar(out, sig);
}).add;

Pdef(\hydro, Pbind(
	\instrument, \hydro,
	\degree, Pseq([0,2],inf),
	\lpf, Ndef(\hydro_lfo_lpf, { SinOsc.kr(1/2 * ~t).range(1000,6991) }),
	\lpfr, Ndef(\hydro_lfo_lpfr, { SinOsc.kr(1/2 * ~t).range(0.01,2) }),
	\legato, Pseq([
		Pser([
			0.1, 0.2,
		],16 * 2),
		Pser([
			0.1, 0.2, 0.5,
		],16 * 2),
		Pser([
			0.2, 0.05, 0.7, 0.2
		],16 * 2),
	],inf),
	\octave, 5,
	\dur, 1/4,
	\amp, 0.1
));

Pdef('hydro.1', Pbind(
	\instrument, \hydro,
	\degree, Pseq([0,2,7,4,4,0],inf),
	\lpf, Ndef(\hydro_lfo_lpf, { SinOsc.kr(1/2 * ~t).range(1000,6991) }),
	\lpfr, Ndef(\hydro_lfo_lpfr, { SinOsc.kr(1/2 * ~t).range(0.01,2) }),
	\legato, Pseq([
		Pser([
			0.1, 0.2,
		],16 * 2),
		Pser([
			0.1, 0.2, 0.5,
		],16 * 2),
		Pser([
			0.2, 0.01, 0.7, 0.2
		],16 * 2),
	],inf),
	\octave, 5,
	\dur, 1/4,
	\amp, 0.1
));

Pdef('hydro.2', Pbind(
	\instrument, \hydro,
	\degree, Pseq([0,2,0,7,0,4,0,4,0],inf),
	\lpf, Ndef(\hydro_lfo_lpf, { SinOsc.kr(1/2 * ~t).range(1000,6991) }),
	\lpfr, Ndef(\hydro_lfo_lpfr, { SinOsc.kr(1/2 * ~t).range(0.01,2) }),
	\legato, Pseq([
		Pser([
			0.1, 0.2,
		],16 * 2),
		Pser([
			0.1, 0.2, 0.5,
		],16 * 2),
		Pser([
			0.2, 0.05, 0.7, 0.2
		],16 * 2),
	],inf),
	\octave, 5,
	\dur, 1/8,
	\amp, 0.1
));


Pdef(\part1, Ppar([
	Pdef(\kick),
	Pdef(\snare),
	Pdef(\hat),
	
]));
);


// END

Pdef(\part1).play;
