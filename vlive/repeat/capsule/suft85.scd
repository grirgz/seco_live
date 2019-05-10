~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\pdefgrid0_0, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/6,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 1,0,1,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0012099467303085,
			'delay', 0.000001001231 * Pseq([
				1,1000,10000,
			],inf).stutter(1),
			'delay2', 0.001000543560101 * Pseq([
				1/1000,1/100
				//1,1/1000,1/10,
			],inf),
			'distamp', 4.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),

		Pmono(\simplecomp,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2, \audio),
			\cpt, 0.05,
			\cpabove, 0.01,
			\cpbelow, 0.71,
			\pregain, 18,
			\mix, 0.3,
			\dur, 1,
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\lpf, 500,
			\lpf, ~pmodenv.(Pseq([100,500,300,400],inf), 8),
			\rq, 0.09,
			\octave, 3,
			\lag, 0.04,
			\dur, 1/8,
			\amp, 0.051,
		),

		Pswitch1(
			[
			Event.silent(1/16),
			Pbind(
				\instrument, \plastic,
				\diff,0.0001,
				\note, Pseq([
					0,12,
					0,-1,12,
				],inf),
				\isRest, Pseq([
					1,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.4) ],
				],inf),
				\dur, 1/16,
				\amp, 0.041,
			),
			Pbind(
				\instrument, \iron,
				\diff,0.0001,
				\note, Pseq([
					-12,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.041,
			),
			],
			Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ]+0,1),
				Pseq([ 1,1,1,1, 1,1,1,1, ]+0,1),
				Pseq([ 1,1,1,1, 1,1,1,1, ]+1,1),
				Pseq([ 0,0,0,0, 0,0,0,0, ]+0,1),

			],inf),


		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid0_1, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/6,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000001001231 * Pseq([
				1
			],inf).stutter(1),
			'delay2', 0.000000543560101 * Pseq([
				1
				//1,1/1000,1/10,
			],inf),
			'distamp', 4.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),

		Pmono(\simplecomp,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2, \audio),
			\cpt, 0.05,
			\cpabove, 0.01,
			\cpbelow, 1,
			\pregain, 18,
			\mix, 0.3,
			\dur, 1,
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\lpf, 500,
			\lpf, ~pmodenv.(Pseq([100,500,300,400],inf), 8),
			\rq, 0.09,
			\octave, 3,
			\lag, 0.04,
			\dur, 1/8,
			\amp, 0.051,
		),

		Pswitch1(
			[
			Event.silent(1/16),
			Pbind(
				\instrument, \default,
				\diff,0.0001,
				\note, Pseq([
					0,12,
					0,-1,12,
				],inf),
				\isRest, Pseq([
					1,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.4) ],
				],inf),
				\dur, 1/16,
				\amp, 0.041,
			),
			Pbind(
				\instrument, \iron,
				\diff,0.0001,
				\note, Pseq([
					-12,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\amp, 0.041,
			),
			],
			Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ]+0,1),
				Pseq([ 1,1,1,1, 1,1,1,1, ]+0,1),
				Pseq([ 1,1,1,1, 1,1,1,1, ]+1,1),
				Pseq([ 0,0,0,0, 0,0,0,0, ]+0,1),

			],inf),


		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid0_2, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\lpf, ~pmodenv.(Pseq([100,502],inf), 8),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid0_3, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 51], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 64, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,0,
					0,0,1,1, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.071,
			),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/6,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/6,
				\dur, 1/8,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000001001231 * Pseq([
				1
			],inf).stutter(1),
			'delay2', 0.000000543560101 * Pseq([
				1
				//1,1/1000,1/10,
			],inf),
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
			\out, BusDef(\sendbus2, \audio),
		),

		Pmono(\simplecomp,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2, \audio),
			\cpt, 0.05,
			\cpabove, 0.01,
			\cpbelow, 1,
			\pregain, 1,
			\mix, 0.3,
			\dur, 1,
		),

		
	])
)).play;
);

Pdef(\part).clear;

(
	PatKitDef(\suft85, [
		Pbind(
			\instrument, \iron,
			\diff,0.0001,
			\note, Pseq([
				0
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.041,
		),
		Pbind(
			\instrument, \iron,
			\diff,0.0001,
			\note, Pseq([
				12,
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.041,
		),
	])
)


PatKitDef(\suft85).edit
ProtoDef(\patkitdef_apc).activate(PatKitDef(\suft85))
ProtoDef(\apc40).activate(TrackDef(\pdefgrid))

(
SynthDef(\hihell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * rrand(1,0.9!10) * [[1,1.01]]).mean * 2;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar([ sig ], pan, amp).mean;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\pdefgrid1_0, 
	Ppar([
		Pbind(
			\instrument, \hihell,
			\note, Pseq([
				0,0,0,-1,
			],inf)+12,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef.defaultQuant
Pdef(\part).play
Pdef(\part, Pbind())

~c = TrackDef(\pdefgrid).childAt(1,0)
TrackDef(\pdefgrid).childAt(1,0).play;
TrackDef(\pdefgrid).childAt(1,0).stop
PlayerWrapper(~c).play
PlayerWrapper(~c).stop
PlayerWrapper(~c).quant



(
SynthDef(\hihell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,10,0],[10.1,0.8]), 1);
	sig = SinOsc.ar( SinOsc.ar((1..10) * 1000,(1..10))  + 1 * freq * \freqtab.kr(rrand(0.01!10,2)));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	//sig = sig.mean * amp;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\hihell2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * Duty.kr(1/8/~t * Drand([1,1/2,1/3],inf), 0, Dseq([
		1,1/4,
	],inf));
	env1 = EnvGen.kr(Env([1,10,0],[1.1,0.8]), 1);
	sig = SinOsc.ar( LFNoise1.ar(10.1!10 * env1) + 1 * freq );
	//sig = sig.collect({ arg isig, idx;
		//isig.tanh(idx/10)
	//});
	sig = sig.mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq * [1,1.0001]) * 1 + 1 ), \rq.kr(0.05));
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp) /2;
	sig = sig * amp / 8;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\pdefgrid2_0, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \hihell,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 7,
			\freqtab, Pseq([
				Pseq([
					[ [ 0.90422916293144, 0.92089000463486, 0.57637963294983, 0.96593114972115, 0.78215170264244, 0.25610881328583, 0.92332576155663, 0.58599744439125, 0.87972407221794, 0.95601333856583 ] ],
				],3),
 [ [ 0.9022916293144, 0.9089000463486, 0.7637963294983, 0.6593114972115, 0.8215170264244, 0.5610881328583, 0.92332576155663, 0.58599744439125, 0.87972407221794, 0.95601333856583 ] ],

			],inf).stutter(16),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/6 * Pseq([
				1,0.6,
			],inf),
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([1,2,1,4]*100,inf), 8),
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0,1, 0,1,0,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\speed, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \hihell2,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 7,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \tredrone,
			\legato, 1,
			\note, Pseq([
				[0,11,9,14],
				[0,11,9,-15]-1,
			],inf),
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.11,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\octave, 6,
			\dur, 4,
			\amp, 0.152,
		),
		Pbind(
			\instrument, \tredrone,
			\note, Pseq([
				[0,11,9,14],
				[0,11,9,-15]-1,
			],inf),
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 10.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid2_1, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \hihell,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 7,
			\freqtab, Pseq([
				Pseq([
					[ [ 0.90422916293144, 0.92089000463486, 0.57637963294983, 0.96593114972115, 0.78215170264244, 0.25610881328583, 0.92332576155663, 0.58599744439125, 0.87972407221794, 0.95601333856583 ] ],
				],3),
 [ [ 0.9022916293144, 0.9089000463486, 0.7637963294983, 0.6593114972115, 0.8215170264244, 0.5610881328583, 0.92332576155663, 0.58599744439125, 0.87972407221794, 0.95601333856583 ] ],

			],inf).stutter(16),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/6 * Pseq([
				1,0.6,
			],inf),
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \hihell2,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 7,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \tredrone,
			\legato, 1,
			\note, Pseq([
				[0,11,9,14],
				[0,11,9,-15]-1,
			],inf),
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.11,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\octave, 6,
			\dur, 4,
			\amp, 0.152,
		),
		Pbind(
			\instrument, \tredrone,
			\note, Pseq([
				[0,11,9,14],
				[0,11,9,-15]-1,
			],inf),
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 10.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\pan, -1,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq)  * [1,0.000001].reverse;
	sig * 0.1;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\tredrone, { arg lagf=0, freq=200, pan=0, amp=0.1, out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(lagf);
	freq = freq * [1, 5/3];
	sig = LFPulse.ar(freq * ( 1 + ( CuspL.ar(\cusfreq.kr(10) + [1,2,3],\cus2.kr(1.1),\cus3.kr(1)).lag(0.1) * ( CuspL.ar(0.1)/3 + 0.1+[ [0,0.01] ] ) * \fma.kr(1) ))).mean;
	sig.debug("kjkj");
	sig = sig /13;
	sig1 = sig;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq.lag(1) * SinOsc.kr(1*~t * [1,3/5]).range(0,1), \rq.kr(0.5));
	sig = sig + BPF.ar(sig1, freq.lag(1) * 8);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
(
Pdef(\demo, PmonoArtic(\tredrone,
	\legato, 1,
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
	\octave, 6,
	\degree, Pseq([
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[0,2,4]+2-12,
		[0,2,4],
		[0,2,4]+2,
		[0,2,4],
		[-20,-20,-20],
	],inf).stutter(8),
	\dur, 1,
	\amp, 0.4
)).play;
);
);



(
SynthDef(\brouha, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	phase = Phasor.ar(1, 1 ,0 + ( (1..10)/10+1 ),BufFrames.kr(bufnum));
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan * LFNoise1.kr((1..10)/15);
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp).mean * 8;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \brouha,
			\bufnum, BufDef("voices/kaspi.flac"),
			\freq, 200,
			\dur, 5,
			\amp, 0.1,
		),
	])
)).play;
);
