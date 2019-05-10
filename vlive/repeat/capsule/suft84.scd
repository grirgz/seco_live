
~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\pdefgrid0_0, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\freq2, Pseg(Pseq([55,91],inf),8),
			\bodyfreqenv, Plazy({ arg ev;
				[ Env([261, ev[\freq2], 21], [0.035, 0.08], curve: \exp) ];
			}).loop,
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
				1,0,0, 0,0,0,  1,0,0, 1,0,0,  
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
				0,0,0, 0,0,1,  0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  1,0,0, 1,0,0,  
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 1,0,0,  
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
			],inf).coin.not,
			\dur, 1/24,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  0,0,0, 0,0,0,  
				1,0,0, 0,0,0,  0,0,0, 0,1,0,  
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
			\dur, 1/24,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0, 0,0,1,  
				0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  
				0,0,0, 0,0,0,  
			],inf).coin.not,
			\sustain, 0.051,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.2) ],
			],inf),
			\velamp, 1/6,
			\dur, 1/12,
		)),
	])
)).play;
);




FileSystemProject.load("capsule/rdnpreset_suft84.scd");
(
Ndef(\rdn).quant=Pdef.defaultQuant;
Ndef(\rdn2).quant=Pdef.defaultQuant;
	~master = {
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		ProtoDef(\rdn3).play;
		ProtoDef(\simpleMixer).play;
	};
ProtoDef(\apc40).activate_bank_selector;
ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [
	\delay, 
	\delay2, 
	Param(Ndef(\rdn2), \delay),
	Param(Ndef(\rdn2), \delay2),

	Param(Ndef(\rdn3), \delay),
	Param(Ndef(\rdn3), \delay2),
]);
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));
ProtoDef(\rdnpreset_set).defineRdnGrid;
)
ProtoDef(\rdnpreset_set).eraseRdnGrid

TrackDef(\pdefgrid).edit

ProtoDef(\rdnpreset_set).saveAs("capsule/rdnpreset_suft84.scd")
ProtoDef(\rdnpreset_set).columns.first.source.first.presetCompileString
File

(
)
//

Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
ProtoDef(\apc40).midimap(\tk1, Param(Pdef(\trackmixer2), \send0, \unipolar))
WindowDef(\PdefEditor).front(Pdef(\trackmixer2))
Param(Pdef(\trackmixer2), \send0, \unipolar).edit
Pdef(\trackmixer2).set(\send0, 1)
Pdef(\trackmixer2).envir


PatKitDef(\bla).edit
PatKitDef(\bla2).edit
PatKitDef(\bla).children.first.play
PatKitDef(\bla).elAt(0)
TrackDef(\pdefgrid).childAt(4,0).source = PatKitDef(\bla).elAt(0)
TrackDef(\pdefgrid).childAt(4,0).proxy.play
TrackDef(\pdefgrid).childAt(4).source = PatKitDef(\bla).children


/// timeline

KitTimeline(\hey, PatKitDef(\bla)).edit
KitTimeline(\hey2, PatKitDef(\bla)).edit
ClipTimeline(\hoy).edit

ProtoDef(\patkitdef_apc).activate(PatKitDef(\ksh2b))
PatKitDef.all
PatKitDef(\ksh2b).edit

Pdef(\metronome).play

/////////////////////////////////////////////////////

(
Pdef(\part2, Pdef(\pdefgrid2_0, 
	Ppar([
		Pbind(\instrument, \modenvlag,
			\legato, 1,
			\target, Pseq([
				Pseq([
					0.1,
				],4),
				0.001,
				0.001,
				0.001,
				0.001,
			],inf),
			\out, BusDef(\stepfreqfac),
			\xtime, Pseq([
				1/4,
			],inf),
			\time, Pkey(\xtime)/~t/4,
			\dur, Pkey(\xtime),
			\amp, 0.1,
		),
		Pspawner({ arg sp;
			5.do {
				sp.par(
					Pmono( \accordeon,
						\freq, exprand(260,15000),
						\stepfreqfac, BusDef(\stepfreqfac, \control).asMap,
						\dur, 1,
						\amp, 0.1 * 0.5,
					)
				);
				0.5.wait;
			}
		})
		
	])
)).play;
);


(
SynthDef(\deon, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, stepfreqfac=1;
	var sig;
	freq = freq * [1,1.001];
	sig = LFSaw.ar(freq * ( SinOsc.ar(stepfreqfac.reciprocal * freq) * stepfreqfac + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = ( sig*100 ).tanh;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part2, Pdef(\pdefgrid2_1, 
	Ppar([
		Pbind(\instrument, \modenvlag,
			\legato, 1,
			\target, Pseq([
				Pseq([
					0.01,
				],4),
				Pseq([
					2.1,
				],4),
			],inf),
			\out, BusDef(\stepfreqfac),
			\xtime, Pseq([
				1/4,
			],inf),
			\time, Pkey(\xtime)/~t/4,
			\dur, Pkey(\xtime),
			\amp, 0.1,
		),
		Ppar([
			Psched([ 0,1 ], Pbind(
				\instrument, \deon,
				\freq, Pseq(exprand(200.0,10000!10).sort.reverse),
				\legato, 2,
				\isRest, Pseq([
					0,0,
					Plazy({ arg ev;
						Pseq([
						0,0,1,0, 1,0,1,1,
						0,1,0,0, 1,0,1,1,
						0,0,0,1, 0,0,1,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,1,0,
						].clump(8).choose)
					}),
				],inf).trace.coin.not,
				\dur, 1/16,
				\amp, 0.1,
			)),
			Psched(
				[ 1,2 ], 
				Ppar([
					Plazy({ arg ev;
						Pbind(
							\instrument, \accordeon,
							\stepfreqfac, 0.001,
							\freq, Pseq(exprand(200.0,10000!10)),
							\dur, 1,
							\legato, 1,
							\amp, 0.1/2,
						)
					})!8,
				].flat),
			),
		]).loop,
		
		
	])
)).play;
);

/////////////////////////
(
SynthDef(\docdro, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fspread=0.01, modfreq;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var seq1, seq2, seq3, seq4, seq5, seq6, seq7, seq8;
	var ofreq = freq;
	freq = freq + modfreq;
	ofreq = freq;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	freq = freq * [1/2,1,2,1/4];
	sig = SinOsc.ar(freq);
	sig1 = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
	sig2 = LFCub.ar(ofreq+[-1,1]);
	sig2.debug("sig");

	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig3 = LFSaw.ar(ofreq * [1,1/2], mul:[1,1/2]).mean/2;
	seq1 = Duty.kr(1/16/~t, 0, Dseq([
		1,2,3,1/4,
		1,1,1/8,1/4,
	],inf));
	seq1 = SelectX.kr(\seqmix.kr(0.0), [1, seq1]);
	sig3 = RHPF.ar(sig3, (\hpf.kr(2000) * seq1 * env1).clip(20,19990));

	sig = [sig1,sig2,sig3].mean / 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\pdefgrid1_0, 
	Ppar([
		Pbind(
			\instrument, \docdro,
			\note, Pseq([
				[0,2,7],
				[0,2,6],
			],inf),
			\note, Pseq([
				40,40,40,40,
				40,39,38,37,
			],inf),
			\legato, Pseq([
				5,0,0,0, 0,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\modfreq, ~pmodenv.(Pseq([0,0,0,-20],inf), 1),
			\hpf, Pseq([
				3000,2000,3200,
			],inf),
			\hpf, ~pmodenv.(Pseq([100,2000,781,14000],inf), 8),
			\seqmix, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1/2,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 0.1,
			\gain,2,
			\dur, 1,
			\amp, 0.1/2,
			\out, BusDef(\mixer0, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid1_1, 
	Ppar([
		Pbind(
			\instrument, \docdro,
			\note, Pseq([
				[0,2,7],
				[0,2,6],
			],inf),
			\note, Pseq([
				40,40,40,40,
				40,39,38,37,
			],inf),
			\legato, Pseq([
				1,0,0,0, 0,1,1,1,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\modfreq, ~pmodenv.(Pseq([0,0,0,-20],inf), 1),
			\hpf, Pseq([
				3000,2000,3200,
			],inf),
			\hpf, ~pmodenv.(Pseq([100,2000,781,14000],inf), 8),
			\seqmix, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
			],inf),
			\dur, 1/4,
			\amp, 0.1/2,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1/2,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 0.1,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		
	])
)).play;
);


Pdef(\part).clear


///////////////// perc
(
	~swing = 0.2;
Pdef(\part, Pdef(\pdefgrid0_0, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 74, 51], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.1) ],

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
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
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
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 0,0, 0,1, 1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
				\out, BusDef(\sendbus3, \audio),
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/6,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			)),
		]),
	   	Pmono(\simpletrackmixer,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus3, \audio, 2),
			\dur, 1,
		)
		//<>Pdef(\trackmixer2, Pbind()),
	]),
)).play;
);

(
	~swing = 0.2;
Pdef(\part, Pdef(\pdefgrid0_1, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 74, 51], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.1) ],

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
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
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
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 0,0, 0,1, 1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
				\out, BusDef(\sendbus3, \audio),
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/6,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			)),
		]),
	   	Pmono(\simpletrackmixer,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus3, \audio, 2),
			\dur, 1,
		)
		//<>Pdef(\trackmixer2, Pbind()),
	]),
)).play;
);

(
	~swing = 0.2;
Pdef(\part, Pdef(\pdefgrid0_2, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 1,1,1,1,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 74, 51], [0.035, 0.08], curve: \exp) ],
				\bodyenv, [ Env.linen(0.005, 0.1, 0.1) ],

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
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
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
		]),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1, 0,0, 0,1, 1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0.3,0, 0.3,0,0,0.3,
					0,0,0.3,0, 0.3,0,0,0.3,
					0,0,0.3,0, 0.3,0,0,0.3,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
				\out, BusDef(\sendbus3, \audio),
			),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,1,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 1,0,0,0,
					0,0,1,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,1, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 
					0,0,0,0, 0,0,0,1, 
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/6,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			)),
		]),
	   	Pmono(\simpletrackmixer,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus2),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus3, \audio, 2),
			\dur, 1,
		)
		//<>Pdef(\trackmixer2, Pbind()),
	]),
)).play;
);



