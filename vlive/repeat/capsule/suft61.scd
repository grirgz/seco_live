~t = 185/2/60; TempoClock.default.tempo = ~t;
~swing = (1 + (0.06 * Pseg(Pseq([1,-1],inf),1/8)));
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
~master_simple = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
}

(
	~master_simple.();
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pbind(
		\instrument, \snapkickx,
		\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
		\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
	
		\popfstart, 750,
		\popfend, 261,
		\popfdur, 0.02,
		\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
		\popamp, 0.15,
	
		\formfund, 910,
		\formfreq, 4760,
		\formbw, 2110,
		\lpf, 3140,
		\clickat, 0.001,
		\clickrel, 0.01,
		\clickamp, 0.15,
	
		\distpreamp, 1,
		\distpostamp, 1,
	
		\isRest, Pseq([
			1,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
		\out, BusDef(\sendbus2, \audio),
	),
	
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,1,0,1, 0,0,0, 0,0,1,
				0,0,0,0,0,0, 1,1,1, 0,0,1,
				0,0,1,1,0,1, 0,0,0, 0,0,1,
				1,1,0,0,0,1, 0,0,1, 1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 0,0, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 0,0, 1,1, 0,0, 1,0,
				1,0, 0,1, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 1,0, 0,0, 0,0, 1,0,
				1,0, 0,0, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 0,0, 1,1, 0,0, 1,0,
				0,0, 0,1, 1,0, 1,0, 0,0, 1,0,
				1,0, 0,0, 0,0, 1,0, 0,0, 1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12/2,
			\amp, 0.01 * Pseq([
				0.74,0.5, 0.7,0.5, 0.7, 0.5, 
				1,0.5,0.7,0.5,0.7,0.5,
			],inf),
		),
		Pbind(
			\instrument, \phyhat4,
			\isRest, Pseq([
				Pseq([
					0,0,0,
					0,0,0,
				],2*7),
				Pseq([
					0,0,0,
				],4*1),
			],inf).coin.not,
			\sustain, 0.1,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.02 * Pseq([1,0.7],inf),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0,0,0, 1,0,0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\instrument, \playersec_hlpf,
			\hpfmix, 1,
			\hpf, Pseq([
				100,
				1000,
				1000,
			],inf),
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 1,0,0,
				1,0,0, 1,0,1,  1,0,1, 0,0,1,
			   	1,0,1,  1,0,0, 1,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
			  	1,0,1, 0,0,1, 1,0,1,  1,0,0,
				1,0,1, 1,0,0,  1,0,1, 0,0,1, 
				1,0,1,  1,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.07,
			\speed, Pseq([
				1,
			],inf),
			\gain, 0.1 * Pseq([
				1,1,
		
			],inf),
			\dur, 1/12,
		)),
	]),
		
	])
)).play;
)


{ SinOsc.ar(200) ! 2 * 0.1}.play;

ProtoDef(\rdn).outBus = 0
ProtoDef(\rdn).outBus = 0
ProtoDef(\rdn2).edit


(
SynthDef(\wavechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = SinOsc.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/8!3).range(0,1);
	sig2 = sig2.mean;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/9!3).range(0,1);
	sig3 = sig3.mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * env2 * freq, \rq.kr(0.5));
	sig = SelectX.ar( lfo1, [sig1, sig2, sig3] ) * 1;
	sig = [sig, SelectX.ar( lfo2, [sig1, sig2, sig3] ) * 1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.4)), gate, doneAction:2);
	sig = sig * amp * 2;

	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pdef(\part).clear;

(
	~master_simple.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				0,0,-1,-1,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	Pbind(
		\instrument, \snapkickx,
		\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
		\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
	
		\popfstart, 750,
		\popfend, 261,
		\popfdur, 0.02,
		\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
		\popamp, 0.15,
	
		\formfund, 910,
		\formfreq, 4760,
		\formbw, 2110,
		\lpf, 3140,
		\clickat, 0.001,
		\clickrel, 0.01,
		\clickamp, 0.15,
	
		\distpreamp, 1,
		\distpostamp, 1,
	
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
			1,0,1,0, 0,0,0,0,
			1,0,0,0, 0,0,1,0,
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
			//\dur, 1/8 * ~swing,
			\dur, 1/8,
		\amp, 0.1,
		\out, BusDef(\sendbus2, \audio),
	),
		
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,0,0,0, 0,0,0, 0,0,0,
				1,0,0,0,0,0, 0,0,1, 0,0,0,
				0,0,0,0,0,0, 0,0,0, 0,0,0,
				1,0,0,1,0,1, 0,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
		\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0,0,0, 1,0,0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/12,
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,0,  0,0,0, 0,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \phyhat4,
			\isRest, Pseq([
				Pseq([
					1,0,0,
				],4*7),
				Pseq([
					0,0,0,
				],4*1),
			],inf).coin.not,
			\sustain, 0.1,
			\fac1,0.1,
			\dur, 1/12,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.02 * Pseq([1,0.7],inf),
		),
	])
)).play;
)

ProtoDef(\rdn2).clear
ProtoDef(\rdn2).edit
ProtoDef(\rdn3).edit
Ndef(\rdn2).clear

///////////////////////
