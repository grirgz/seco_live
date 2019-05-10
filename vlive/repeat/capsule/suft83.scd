
// 1 echo

(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\freq, 70,
			\dur, 1,
			\amp, 0.1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				0,0,0,1, 1,0,0,1,
		
				1,0,0,0, 0,0,1,1,
				0,0,0,1, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
				0,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\isRest, true,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0.5, 0.5,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0.51,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					1,0,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseq([
				Pseq([
					1,1,
				],2),
				Pseq([
					Pseries(1,10,0.1),
				],1),
			],inf),
			\gain, 0.3,
			\dur, 1/12,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/1,
			\dur, 1/16,
			\out, BusDef(\echoer2, \audio),
		)),
		Pmono(\echoer,
			\inbus, BusDef(\echoer2, \audio),
			\delay, ~pmodenv.(Pseq([1/1,1/5]/11,inf), 8),
			\itrig,Pseq([0,1],inf),
			\gain, 0.2 * Pseq([
				1,1,1,1, 1,1,0,0,
			],inf),
			\mix, 0.4,
			\dur, 1/2,
		),
		Pbind(
			\instrument, \deval,
			\note, Pseq([
					[0,3,4],
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,1,
			],inf) * 0.8,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piouc,
			\freq, 1200,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],3 * 2),
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,1,
				],1),
			],inf).coin.not,
			
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\piouc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,1.01]).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\boom, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([461, 94, 81], [0.035, 4.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 1.4, 1.3) ],
		
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
			\out, BusDef(\boom, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\boom, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.002099467303085,
			'delay', 0.001600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
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
		),
		Pbind(
			\instrument, \born,
			\freq, 200,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 0,0,1/3,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \born,
			\freq, 700,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				0,1,1,0, 1,0,2,0,
				0,0,0,1, 0,0,1/3,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),

		
	])
)).play;
);

(
SynthDef(\born, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.0001,1,1/21],[6.1,3.8]), 1);
	sig = LFSaw.ar(freq * [1,2,1/2,1.01]).mean;
	sig = sig.fold2( env1 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\deval, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(Env([0,2,1],[1.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1],[1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,1/8,1],[2.1,2.8]), 1);
	env4 = EnvGen.kr(Env([0,0,1/8,1],[2,2.1,2.8]/1), 1);
	lfo1 = SinOsc.ar(30 * env3).range(1/2,1);
	lfo2 = LFTri.ar(10 * env2).range(2,1);
	freq = freq * Duty.kr(1/16/~t, 0, Drand([
		1,2,3/2,
	],inf));
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(lfo2 *72 * ( 1 + ( SinOsc.kr(1/12) * 1 ))) * env4 )));
	sig = sig * (LFSaw.ar(freq)*env1+1);
	sig = RLPF.ar(sig, \lpf.kr(10000) * env2, \rq.kr(0.5)) + ( sig );
	sig = RLPF.ar(sig, 1000 * env3 * lfo1, 0.5) + ( sig/4 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * 0.15;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pfindur(4,
				Pdef(\intro),
			),
			Pfindur(8,
				Pdef(\boom),
			),
		],inf),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,

				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/6,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.041,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/11,
			\dur, 1/16,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				Pser([
					1,1,
				],8* 6),
				Pser([
					0,0,
				],8* 2),
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/2,
			\octave, 3,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \born,
			\freq, 500,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,4,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \born,
			\freq, 700,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				0,1,1,0, 1,0,2,0,
				0,0,0,1, 0,0,1/3,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piouc,
			\freq, Pseg(Pseq([1000,501,100,10000],inf),2),
			\legato, 0.2,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, 
			Pseq([
				~pmodenv.(Pseq([1,2,1,4]/10,1), 2),
				Pseq([
					1/10,
				],2),
			],inf),
			\itrig,1,
			\dur, 1,
		),
		Pbind(
			\instrument, \downer,
			\note, Pseq([
				0,4,3,6,
			],inf).stutter(8),
			\octave, 6,
			\dur, 1/16,
			\lpfm, ~pmodenv.(Pseq([1,2,40,4],inf), 2),
			\legato, 0.8*Pseq([
				3,0,0,3, 0,0,3,0,
				1,1,1,1, 2,0,2,0,
				1,0,2,0, 0,2,0,1,
				0,0,2,0, 0,0,2,0,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0,2,0,
				1,0,2,0, 0,2,0,1,
				0,0,2,0, 0,0,2,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.07,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/6,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.041,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/11,
			\dur, 1/16,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				Pser([
					1,1,
				],8* 6),
				Pser([
					0,0,
				],8* 2),
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/2,
			\octave, 3,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \born,
			\freq, 500,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,4,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \born,
			\freq, 700,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,2,0,
				0,1,1,0, 1,0,2,0,
				0,0,0,1, 0,0,1/3,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pbind(
			\instrument, \piouc,
			\freq, Pseg(Pseq([1000,501,100,10000],inf),2),
			\note, Pseq([
				0,2,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.2,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\echoer,
			\inbus, BusDef(\echoer, \audio),
			\delay, 
			Pseq([
				Pseq([
					0.3,
				],2),
			],inf),
			\itrig,1,
			\dur, 1,
			\out, BusDef(\hpf, \audio),
		),
		Pbind(
			\instrument, \downer,
			\note, Pseq([
				0,4,3,6,
			],inf).stutter(8),
			\octave, 6,
			\dur, 1/16,
			\lpfm, ~pmodenv.(Pseq([1,2,40,4],inf), 2),
			\legato, 0.8*Pseq([
				3,0,0,3, 0,0,3,0,
				1,1,1,1, 2,0,2,0,
				1,0,2,0, 0,2,0,1,
				0,0,2,0, 0,0,2,0,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0,2,0,
				1,0,2,0, 0,2,0,1,
				0,0,2,0, 0,0,2,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.07,
			\out, BusDef(\echoer, \audio),
		),
		Pmono(\fx_hpf,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\hpf, \audio),
			\mix, 1,
			\hpf, ~pmodenv.(Pseq([10,10,2000],inf), 4),
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \downer,
			\note, Pseq([
				0,4,3,6,
			],inf).stutter(8),
			\octave, 6,
			\dur, 1/16,
			\legato, 0.8*Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0,2,0,
				1,0,2,0, 0,2,0,1,
				0,0,2,0, 0,0,2,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\downer, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.9,0.85],[0.1,0.1]), 1);
	sig = LFSaw.ar(freq  * [1,2,3,4,3/2,5/4],mul:[1,1,0.7,0.5]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq * ( SinOsc.ar(\lpfm.kr(12)) * 1 + 1 ) * env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
