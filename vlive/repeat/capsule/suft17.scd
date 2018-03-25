
~t = 135/4/60; TempoClock.default.tempo = ~t;


(
SynthDef(\ulu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread =1;
	var sig;
	var fmt = CuspN.ar((1..8)/30) * \fmtamp.kr(0.2) + 1; 
	sig = SinOsc.ar(freq * [1,1/2,3/5,2] * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmr.kr(1) * fmt) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8)/20, (1..8)); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\ulu2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\cymnoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [9400,17030,16410,8000.14,15000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([14821,14810,14251,1100],[0.01,0.1*fac1,0.1], 4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([4820,4000,3151],[0.07,0.8*fac1],4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.08,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\cymnoise2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([14210,14100,14051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([1210,1200,1451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [9400,17030,16410,8000.14,15000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([10821,10810,10251,10000],[0.01,0.1*fac1,0.1], 4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([4820,4800,4851],[0.07,0.8*fac1],4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = LPF.ar(sig, env2);
	sig = HPF.ar(sig, env1);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.08,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/4,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		Pbind(
			\instrument, \cymnoise,
			\freq, 200,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 2.2,
			\fac1,1.0,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \cymnoise2,
			\freq, 200,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 2.2,
			\fac1,1.0,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, Prand([\ulu, \ulu2],inf),
			\note, Pstep(Pseq([
				[ 0, 3, 6, 12],
				[ 1, 4, 7, 12],
				[ 0, 4, 7, 12],
				[ 0, 4, 6, 12],
			],inf),2),
			\isRest, Pseq([
				[ 0,1,0,1 ],
				[ 1,0,1,1 ],
				[ 1,1,1,0 ],
			],inf).collect({arg x;x.coin.collect(_.not)}),
			\strum, Pseg(Pseq([0,0.01,0.1,1],inf),8),
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		);
	])
)).play;
)


(
	Pdefn(\chords,
			Pstep(Pseq([
				[ 0, 3, 6, 12],
				[ 1, 4, 7, 12],
				[ 0, 4, 7, 12],
				[ 0, 4, 6, 12],
			],inf),1),
	);
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,1,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,1,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\sustain, 0.051,
				\gain, 0.15,
				\dur, 1/16,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 1,1, 1,1, 1,1,
					1,1, 1,1, 0,0, 0,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		Pbind(
			\instrument, \cymnoise,
			\freq, 200,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1.0,
			\fac1,1.0,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, Prand([\ulu, \ulu2],inf),
			\instrument, Pseq([
				\ulu, \ulu, \ulu2, \ulu,
				\ulu, \ulu2, \ulu, \ulu2,
				\ulu, \ulu, \ulu2, \ulu,
				\ulu, \ulu2, \ulu, \ulu2,
				\ulu, \ulu, \ulu2, \ulu,
				\ulu, \ulu, \ulu2, \ulu,
				\ulu, \ulu2, \ulu, \ulu2,
				\ulu, \ulu, \ulu2, \ulu,
				\ulu, \ulu2, \ulu, \ulu2,
			],inf),
			\note, Pstep(Pseq([
				[ 0, 3, 6, 12],
				[ 1, 4, 7, 12],
				[ 0, 4, 7, 12],
				[ 0, 4, 6, 12],
			],inf),1),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			//\lag, Ptuple(Prand([0,0,0,0,0,1/16]/~t,inf)!4),
			//\lag, Prand([0,0,0,0,0,1/16]/~t,inf),
			\strum, Pseg(Pseq([0,0.01],inf),8),
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, Prand([\ulu],inf),
			//\note, Pdefn(\chords).collect(_.choose),
			\note, Pstep(Pseq([
				[ 0, 3, 6, 12],
				[ 1, 4, 7, 12],
				[ 0, 4, 7, 12],
				[ 0, 4, 6, 12],
			],inf),1).collect({arg x; x.scramble.keep(2) }),
			\fspread, 0.01,
			\fmtamp, 0.1,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\octave, 6,
			//\lag, Ptuple(Prand([0,0,0,0,0,1/16]/~t,inf)!4),
			\lag, Prand([0,0,0,0,0,1/16]/~t,inf),
			\strum, Pseg(Pseq([0,0.01],inf),8),
			\legato, 1.0,
			\dur, PdurStutter(Pseq([1,1,1,1, 1,4,2,8],inf), 1),
			\amp, 0.1/4,
		),
	])
)).play;
)


(
	Pdefn(\chords,
			Pstep(Pseq([
				[ 0, 3, 6, 12],
				[ 1, 4, 7, 12],
				[ 0, 4, 7, 12],
				[ 0, 4, 6, 12],
			],inf),1),
	);
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\bodyenv, Pseq([
					[ Env.linen(0.01,0.04,0.1,0.2) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 1,0,0,1,
					//0,0,0,1, 0,0,1,0, 0,0,0,1, 0,0,1,0,
					//0,0,0,0, 0,0,0,0, 0,0,0,1, 0,1,1,0,
					//0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\sustain, 0.071,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15,
				\dur, 1/16,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 1,1, 1,1, 1,1,
					1,1, 1,1, 0,0, 0,0,
					1,0, 1,0, 1,0, 1,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		Pbind(
			\instrument, \cymnoise,
			\freq, 200,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1.0,
			\fac1,1.0,
			\dur, 1/8,
			\amp, 0.1/4,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,2,3,4,
				],inf),
				\octave, 8,
				\diff, 0.0001 * Pseq([
					1,1,1,
					1,10,2,
				],inf),
				\fmr, 1/8,
				\isRest, Pseq([
					Pseq([
						0,0, 1,0, 0,1,0,1,
						0,0, 1,0, 0,0,1,0,
						0,0, 1,0, 0,0,0,1,
						0,0, 1,0, 0,1,0,0,
					],4),
				],inf).coin.not,
				\legato, 2,
				\lag, 0.08,
				//\lag, 0.04,

				\dur, 1/8,
				\amp, 0.1/8,
				\out, BusDef(\sendbus3, \audio),
			),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/16,
					\bodyenv, Pseq([
						[ Env.linen(0.01,0.04,0.1,0.2) ],
					],inf),
					\isRest, Pseq([
						0,0,0,0, 1,0,1,0, 0,0,1,0, 1,0,0,0,
						0,0,1,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.2,
					\dur, 1/8,
				)),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,0,0, 0,0,0,0, 1,0,0,1,
						//0,0,0,1, 0,0,1,0, 0,0,0,1, 0,0,1,0,
						//0,0,0,0, 0,0,0,0, 0,0,0,1, 0,1,1,0,
						//0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1,
					],inf).coin.not,
					\sustain, 0.071,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\gain, 0.15,
					\dur, 1/16,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,1, 1,1, 1,1, 1,1,
						1,1, 1,1, 0,0, 0,0,
						1,0, 1,0, 1,0, 1,0,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			Pbind(
				\instrument, \cymnoise,
				\freq, 200,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1.0,
				\fac1,1.0,
				\dur, 1/8,
				\amp, 0.1/4,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.25714285714286,
			'gain', 0.744889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.000301231 * Pseq([
				1,1,1/1.3,
			],inf).stutter(1),
			'delay2', 0.000000210000543560101,
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			'distamp', 01.061836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\mix, Pseq([

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,1, 0,0,1,0,
				0,1,1,0, 0,1,0,1,
				0,1,0,0, 0,1,1,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\time, 1/16/~t,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\addAction, \addToTail,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.744889782792 * Pseq([
				1
			],inf),
			'fb', 0.00001099467303085,
			'delay', 0.10301231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.00700000210000543560101 * Pseq([
				3,3,3,
				3,3,3,
				1,2,3,
			],inf),
			//\delay, ~pmodenv.(Pseq([0.00001,0.002,0.002,1,0.0004],inf), 8),
			//\delay2, ~pmodenv.(Pseq([0.30001,0.002,0.002,1,0.0004],inf), 7.123),
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			\bpfac, 3,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/4,
		),
	])
)).play;
)
