
(
~t = 1;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;

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
		],1),
	],inf).coin.not,
	\amp, 0.1
));

)

(
~perc2pat = Pbind(
	\dur, 1/6,
	\out, BusDef(\sendbus2, \audio, 2),
);
Pdef(\main, Ppar([
	Pdef(\kick),
	Pdef(\hat),
	Pdef(\snare),
	Pdef(\snarehat),

	~perc2pat <> Pdef(\kick),
	~perc2pat <> Pdef(\hat),
	~perc2pat <> Pdef(\snare),
	~perc2pat <> Pdef(\snarehat),
])).play;
)



(
[
	Pdef(\kick),
	Pdef(\hat),
	Pdef(\snare),
	Pdef(\snarehat),
].collect({ arg x; x.set(\out, BusDef(\sendbus1, \audio, 2)) }) ;
)

RandDelayNetwork(\default).make(\rdn1, "5--", BusDef(\sendbus1, \audio, 2));
RandDelayNetwork(\default).getPbindCompileString(\rdn1);
Ndef(\rdn1).play;
Ndef(\rdn1).stop;
Ndef(\rdn1).edit;

RandDelayNetwork(\default).getPresetCompileString(\rdn1).pbcopy.vimpbpaste;
(
RandDelayNetwork('default').make('rdn1', "5-TC6B-MRQV", BusDef(\sendbus1, \audio, 2));
Ndef('rdn1').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0019774832909109,
	'delay', 0.0066408278506348,
	'delay2', 0.27825594022071,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 2.4564560522316,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 8.9657771616276,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.25545155902396,
).keep(1))
)

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
RandDelayNetwork('default').make('rdn2', "5-B3D7-7N9O", BusDef(\sendbus2, \audio, 2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.00047974276314289,
	'delay', 1.0,
	'delay2', 0.0085769589859089,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.58709148094866,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.84255998715291,
	'fbdistmix', 1.0,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 0.54928027165304,
).keep(1))
)





Ndef(\plop).stop

(
Ndef(\vap, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var gate = Duty.kr(1/~t, 0, Dseq([
		//1,1,0,0,
		0,0,1,1,
	],inf));
	freq = Duty.kr(8/~t, 0, Dseq([
		70,80,
	],inf));
	sig = LFSaw.ar(freq * [1,1.0001]).sum + SinOsc.ar(freq,mul:2).fold2( EnvGen.kr(Env([2,0.62,1],[1.1,0.8]), gate) );
	sig1 = BPF.ar(sig, freq);
	sig = RLPF.ar(sig, freq * EnvGen.kr(Env([1,8 ,1],[0.7* LFNoise1.kr(1/21).range(1/8,2),0.08]), gate) * 2);
	sig = RLPF.ar(sig, freq * EnvGen.kr(Env([1,8,1],[1.7,0.08]), gate));
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp) + Pan2.ar(sig1, SinOsc.ar(1/2 * ( 1 + ( SinOsc.kr(1/23) * 20 ))) , amp/4);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
}).play;
);
Ndef(\vap).stop


(
SynthDef(\bibi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,1.001]);
	sig = sig + LFSaw.ar(freq);
	sig = RLPF.ar(sig, freq * 1.4, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop.mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bibi, Pbind(
	\instrument, \bibi,
	\degree, Pseq([0,2,4,7],inf),
	\isRest, Pseq([
		1,0.3,1,0.3, 0.3,0.3,0.3,0.3,
	],inf).coin.not,
	\octave, 4,
	\dur, 1/4,
	\amp, 0.1
)).stop;
);
