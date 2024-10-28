// play with chord seq
~t = 105/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("holis/synthdef.scd");
FileSystemProject.load("holis/partmain.scd");

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				[0,4,7],
				[4,7,11-12],
				[5,9,12-12],
				[7,11-12,14-12],
			],inf),1/2),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\cnote, Pstep(Pseq([
				[0,4,7],
				[4,7,11-12],
				[5,9,12-12],
				[7,11-12,14-12],
			],inf),1/2),
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\arp, Pseq([1,0,0,3,4,4,4],inf),
			\ctranspose, Pseq([0,0,0,0,0,-1,0,0,0,1],inf),
			\note, Pfunc({ arg ev;
				var it;
				it = ev[\cnote] % 12;
				it = it +.x [-12,0,12];
				it[ev[\arp]];
			}),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				[0,4,7],
				[4,7,11-12],
				[5,9,12-12],
				[7,11-12,14-12],
			],inf),1/2),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Ppar(
			Pbind(
				\instrument, \default,
				\cnote, Pstep(Pseq([
					[0,4,7],
					[4,7,11-12],
					[5,9,12-12],
					[7,11-12,14-12],
				],inf),1/2),
				\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
				\arp, Pseq([1,0,0,3,4,4,4],inf),
				\arp, Plazy({ arg ev;
					Pseq(rrand(0,9!8),4)
				}).loop,
				\ctranspose, Pseq([0,Prand([0,Pseq([0,1],1)],1),0,0,0,0,0,0,0,0,0,0,0,-1],inf),
				\note, Pfunc({ arg ev;
					var it;
					it = ev[\cnote] % 12;
					it = it +.x [-12,0,12];
					it.wrapAt(ev[\arp]);
				}),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
			) ! 4
		),
		
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\arp, Plazy({ arg ev;
			Pseq(rrand(0,9!ev[\plen]).postln,ev[\prepeat])
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar([
			Pdef(\arper) <> Pbind(\dur, 1/2, \octave, 3, \prepeat, 8),
			Pdef(\arper) <> Pbind(\dur, 1/4, \octave, 4, \plen, 2, \prepeat,100),
			Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \prepeat, 16),
			Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 6,
				\isRest, Pseq([
					1,0.4,0.4,0, 0,
				],inf).coin.not,
			),
		]) <>
		Pbind(
			\instrument, \default,
			\cnote, Pstep(Pseq([
				[0,4,7],
				[4,7,11-12],
				[5,9,12-12],
				[7,11-12,14-12],
			],inf),1/2),
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\arp, Pseq([1,0,0,3,4,4,4],inf),
			\plen, 8,
			\prepeat, 8,
			//\arp, Plazy({ arg ev;
				//Pseq(rrand(0,9!ev[\plen]),ev[\prepeat])
			//}).loop.trace,
			\ctranspose, Pseq([0,0,0,0,0,0,0,Prand([0,Pseq([0,1],1)],1),0,0,0,0,0,0,0,0,0,0,0,-1],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		)
		
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\arp, Plazy({ arg ev;
			Pseq(rrand(0,9!ev[\plen]).postln,ev[\prepeat])
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar([
			Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,100,
				\isRest, Pseq([
					1,1,0,0, 1,0,0,0,
				].rotate(rrand(0,8)),inf).coin.not,
			),
			Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,8,
				\isRest, Pseq([
					1,1,1,0, 0,0,0,0,
				].rotate(rrand(0,8)),inf).coin.not,
			),
			Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,100,
				\isRest, Pseq([
					1,1,1,0.3, 1,1,0,0,
					0,0,0,0, 0,0,0,0,
				].rotate(rrand(0,8)),inf).coin.not,
			),
			Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 6, \plen, 8, \prepeat,100,\amp,0.1*Pwhite(1/4,1),
				\isRest, Pseq([
					Pseq([
						1,1,1,0.3, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,0.3,
						1,1,1,1, 1,1,1,1,

						[
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,0,
						]!3,
					].flat.rotate(rrand(0,64)),1),
				],inf).coin.not,
			),
		]) <>
		Pbind(
			\instrument, \default,
			\cnote, Pstep(Pseq([
				[0,4,7],
				[4,7,11-12],
				[5,9,12-12],
				[7,11-12,14-12],
			],inf),1/2),
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\arp, Pseq([1,0,0,3,4,4,4],inf),
			\plen, 8,
			\prepeat, 8,
			//\arp, Plazy({ arg ev;
				//Pseq(rrand(0,9!ev[\plen]),ev[\prepeat])
			//}).loop.trace,
			//\ctranspose, Pseq([0,0,0,0,0,0,0,Prand([0,Pseq([0,1],1)],1),0,0,0,0,0,0,0,0,0,0,0,-1],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		)
		
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[4,7,11-12],
			[5,9,12-12],
			[7,11-12,14-12],
		],inf),1/2),
		\arp, Plazy({ arg ev;
			Pseq(rrand(0,9!ev[\plen]).postln,ev[\prepeat])
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,100,
			\isRest, Pseq([
				1,1,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,8,
			\isRest, Pseq([
				1,1,1,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,100,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,100,
			\isRest, Pseq([
				1,1,1,0.3, 0,1,0.5,0.5,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 6, \plen, 4, \prepeat,100,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[4,7,11-12],
			[5,9,12-12],
			[7,11-12,14-12],
		],inf),1/2),
		\arp, Plazy({ arg ev;
			Pseq(rrand(0,9!ev[\plen]).postln,ev[\prepeat])
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\isRest, Pseq([
				1,1,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,8*2,
			\isRest, Pseq([
				1,1,1,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\isRest, Pseq([
				1,1,1,0.3, 0,1,0.5,0.5,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 6, \plen, 4, \prepeat,8*8,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
	])
)).play;
);

///////////

// from synthdefault in catalog
(
SynthDef(\Piano_rhodeySC, {
	//FM Rhodes Synthethizer
	|
	// standard meanings
	out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1,
	// all of these range from 0 to 1
	vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1
	|
	var env1, env2, env3, env4;
	var osc1, osc2, osc3, osc4, snd;

	lfoSpeed = lfoSpeed * 12;

	freq = freq * 2;

	env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
	env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
	env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
	env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

	osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
	osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
	osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
	osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
	snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

	// using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
	//snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	snd = snd * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = Pan2.ar(snd, pan, amp);

	Out.ar(out, snd);
//By Nathan Ho aka Snappizz
//http://sccode.org/1-522
}).add;
SynthDef(\harpsichord_pluck, {
	|amp=0.1, freq=440, pan=0, atk=0, rel=0, trig= 1, maxdelaytime= 0.2, decaytime= 7, coef= 0.1|
	var env, sig, delay;
	env = EnvGen.kr(Env.linen(atk, decaytime, rel), doneAction: Done.freeSelf);
	sig = PinkNoise.ar(amp); //Can use white noise here, but Pink is more realistic
	delay = freq.reciprocal;
	sig = Pluck.ar(sig, trig, maxdelaytime , delay , decaytime , coef ) //fundamental
	+ Pluck.ar(sig, trig, maxdelaytime , delay/2 , decaytime , coef ); //octave higher
	Out.ar(0, Pan2.ar(sig , pan));
//Harpsichord based on Pluck Ugen
//By Zé Craum

}).add;
SynthDef(\violin, {
	| out=0, midinote=60, gate=1, amp=0.8 |
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.1), gate, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(out, sig!2);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
SynthDef(\kalimba, {
	//Kalimba based on bank of ressonators
	|out = 0, freq = 440, amp = 0.1, mix = 0.1, relMin = 2.5, relMax = 3.5|
	var snd;
	// Basic tone is a SinOsc
	snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.005, Rand(relMin, relMax), 1, -8), doneAction: 2);
	// The "clicking" sounds are modeled with a bank of resonators excited by enveloped pink noise
	snd = (snd * (1 - mix)) + (DynKlank.ar(`[
		// the resonant frequencies are randomized a little to add variation
		// there are two high resonant freqs and one quiet "bass" freq to give it some depth
		[240*ExpRand(0.9, 1.1), 2020*ExpRand(0.9, 1.1), 3151*ExpRand(0.9, 1.1)],
		[-7, 0, 3].dbamp,
		[0.8, 0.05, 0.07]
	], PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01))) * mix);
	Out.ar(out, Pan2.ar(snd, 0, amp));
//By Nathan Ho aka Snappiz
//http://sccode.org/1-51l
}).add;
SynthDef(\glockenspiel, {
	|freq = 440, t60=6, pitchy=1, amp=0.25, gate=1, pan = 0|
	var sig, exciter;
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = DynKlank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60	 // ring times
		],
		exciter,
		freqscale: freq);
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(0, Pan2.ar(sig, pan, amp));
//This is the same used for glockenspiel, xylophone, marimba and regular bell, what changes is only the ring time t60
//By nicolaariutti and edited by Zé Craum
//	http://sccode.org/1-5ay#c835
}).add;
SynthDef(\xilophone, {
	|out = 0, freq = 440, t60=1, pitchy=1, amp=0.25, gate=1, pan = 0|
	var sig, exciter;
	exciter = WhiteNoise.ar() * EnvGen.ar(Env.perc(0.001, 0.05), gate) * 0.25;
	sig = DynKlank.ar(
		`[
			[1, 2, 2.803, 3.871, 5.074, 7.81, 10.948, 14.421],   // freqs
			[1, 0.044, 0.891, 0.0891, 0.794, 0.1, 0.281, 0.079], // amplitudes
			[1, 0.205, 1, 0.196, 0.339, 0.047, 0.058, 0.047]*t60     // ring times
		],
		exciter,
		freqscale: freq);
	DetectSilence.ar(sig, 0.001, 0.5, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, amp));
//This is the same used for glockenspiel, xylophone, marimba and regular bell, what changes is only the ring time t60
//By nicolaariutti and edited by Zé Craum
//	http://sccode.org/1-5ay#c835
}).add;
SynthDef(\strings, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
					var env, in, delay, f1, f2;
					f1 = freq.lag(freqLag);
					f2 = freq.lag(freqLag * 0.5);
					delay = 0.25 / f2;
					env = Env.asr(0, 1, 0.3);
					in = WhiteNoise.ar(180);
					in = CombL.ar(in, delay, delay, 1);
					in = Resonz.ar(in, f1, 0.001).abs;
					in = in * EnvGen.kr(env, gate, doneAction:2);
					Out.ar(out, Pan2.ar(in, pan, amp));

//From SC Examples Folder
// some small pieces
// Julian Rohrhuber, 2007
}).add;
)

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[4,7,11-12],
			[5,9,12-12],
			[7,11-12,14-12],
		],inf),1/2),
		\arp, Plazy({ arg ev;
			Pseq(rrand(0,9!ev[\plen]).postln,ev[\prepeat])
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \Piano_rhodeySC,
			\isRest, Pseq([
				1,1,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,8*2,
			\instrument, \harpsichord_pluck,
			\isRest, Pseq([
				1,1,1,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\instrument, \violin,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\instrument, \kalimba,
			\isRest, Pseq([
				1,1,1,0.3, 0,1,0.5,0.5,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 6, \plen, 4, \prepeat,8*8,
			\instrument, \glockenspiel,
			\amp, 0.01,
			\t60, 1,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[4,7,11-12],
			[5,9,12-12],
			[7,11-12,14-12],
		],inf),1/2),
		\arp, Plazy({ arg ev;
			Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \Piano_rhodeySC,
			\isRest, Pseq([
				1,1,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,8*2,
			\instrument, \harpsichord_pluck,
			\isRest, Pseq([
				1,1,1,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\instrument, \violin,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\instrument, \kalimba,
			\isRest, Pseq([
				1,1,1,0.3, 0,1,0.5,0.5,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 6, \plen, 4, \prepeat,8*8,
			\instrument, \glockenspiel,
			\amp, 0.01,
			\t60, 1,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[0,3,7],
			Pseq([
				[0,4,7]-5,
			],2),
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			it.debug("it");
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\lpf, 400,
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,8*2,
			\arp, Pseq([6,5,3,0],inf),
			\amp, 0.1/5,
			\instrument, \organ_tonewheel4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\instrument, \violin,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\instrument, \kalimba,
			\isRest, Pseq([
				1,1,1,0.3, 0,1,0.5,0.5,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 6, \plen, 4, \prepeat,8*8,
			\instrument, \glockenspiel,
			\amp, 0.01,
			\t60, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[0,3,7],
			Pseq([
				[0,4,7]-5,
				[0,7,10]-5,
			],1),
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			it.debug("it");
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\lpf, 400,
			\amp, 0.1/2,
			\arp, Pseq([0,0,4,4,4,4,0,0],inf),
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 7, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 6, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-NOUF-LHCJ", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.49159663865546,
	'gain', 0.14453781512605,
	'fb', 0.00091968463500716,
	'delay', 0.0001,
	'delay2', 1.0,
	'shift', 0.16806722689076,
	'shift2', 0.0,
	'distamp', 11.674193588235,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-P24D-F9PL", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.94117647058824,
	'fb', 0.0001,
	'delay', 0.62852032692401,
	'delay2', 0.70589400866187,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 8.0050001526646,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[0,3,7],
			Pseq([
				[0,4,7]-5,
				[0,7,10]-5,
			],1),
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			it.debug("it");
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\lpf, 400,
			\amp, 0.1/2,
			\arp, Pseq([0,0,4,4,4,4,0,0],inf),
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 7, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,4,
			\instrument, \strings,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\legato, 1,
			\amp, 0.1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,4,
			\instrument, \strings,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\amp, 0.1,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);


///////////////////////////////////////

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[0,4,7]+5,
			[0,3,7]-3,
			[0,4,7]-5,
		],inf),1/2),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			it.debug("it");
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\lpf, 400,
			\amp, 0.1/2,
			\arp, Pseq([0,0,4,4,4,4,0,0],inf),
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			//\isRest, true,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 7, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([3],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,4,
			\instrument, \strings,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\legato, 1,
			\amp, 0.1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,4,
			\instrument, \strings,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\amp, 0.1,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		//\cnote, Pstep(Pseq([
			//[0,4,7],
			//[0,4,7]+5,
			//[0,3,7]-3,
			//[0,4,7]-5,
		//],inf),1/2),
		\cnote, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
			Pstep(Pseq([
				[1,3,3,2,1,1]+7, // up do maj
				[1,1,3,3,2,1]+7, // down fa maj
				[1,3,3,1,1,1]+4, // up la min
				[1,3,3,2,1,1]+2, // up sol maj
				//[1,1,3,3,2,1], // la# min
				//[1,3,3,2,1,1]+1, // fa# maj
				//[1,1,3,3,2,1], // la# min
			],1),1/2),
		],inf),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote];
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/6, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\arp, Pseq([0],inf),
			\lpf, 2000,
			\amp, 0.1/4,
			\legato, 0.1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 4, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			//\arp, Pseq([3],inf),
			\arp, Pseq([0],inf) + Pseq((0..10),inf).stutter(32),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,0,1,1,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/10, \octave, 4, \plen, 2, \prepeat,8*16,
			\instrument, \strings,
			\arp, Pseq([5],inf),
			\amp, 0.1/4,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		//\cnote, Pstep(Pseq([
			//[0,4,7],
			//[0,4,7]+5,
			//[0,3,7]-3,
			//[0,4,7]-5,
		//],inf),1/2),
		\cnote, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
			Pstep(Pseq([
				[1,3,3,2,1,1]+7, // up do maj
				[1,1,3,3,3,1]+7, // down fa maj
				[1,3,3,1,1,1]+4, // up la min
				[1,3,3,2,1,1]+2, // up sol maj
				//[1,1,3,3,2,1], // la# min
				//[1,3,3,2,1,1]+1, // fa# maj
				//[1,1,3,3,2,1], // la# min
			],1),1/2),
		],inf),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote];
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\arp, Pseq([0],inf),
			\lpf, 2000,
			\amp, 0.1/4,
			\legato, 0.1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 4, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			//\arp, Pseq([3],inf),
			\arp, Pseq([0,1],inf)+1,
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,0,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 2, \prepeat,8*16,
			\instrument, \Piano_rhodeySC,
			//\arp, Pseq([3],inf),
			//\arp, [0,1,2,3,4,5],
			\arp, Pseq([ [0], [1,2,3,4,5]],inf),
			\amp, 0.1/8,
			\strum, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 0,1,0,0,
			],inf).coin.not,
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		//\cnote, Pstep(Pseq([
			//[0,4,7],
			//[0,4,7]+5,
			//[0,3,7]-3,
			//[0,4,7]-5,
		//],inf),1/2),
		\cnote, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
			Pstep(Pseq([
				[1,3,3,2,1,1]+7, // up do maj
				[1,1,3,3,3,1]+7, // down fa maj
				[1,3,3,1,1,1]+4, // up la min
				[1,3,3,2,1,1]+2, // up sol maj
				//[1,1,3,3,2,1], // la# min
				//[1,3,3,2,1,1]+1, // fa# maj
				//[1,1,3,3,2,1], // la# min
			],1),1/2),
		],inf),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote];
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			16.collect { arg idx;
				Pdef(\arper) <> Pbind(\dur, 1/(1..16).choose, \octave, rrand(3,6), \plen, 2, \prepeat,8*16,
					\instrument, ~holis_synthdefs.choose,
					\arp, Pseq([Pseq(rrand(0,5!8))],inf),
					\amp, 0.1/4,
					\legato, rrand(0.1,1),
					\isRest, Pseq([
						Pseq(rrand(0.0,1!8)),
						//1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				)

			}
		)
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(
			8.collect { arg idx;
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					\bufnum, [
						~buflib.kick[~buflib.kick.size.rand.debug("k")],
						~buflib.snare[~buflib.snare.size.rand.debug("k")],
						~buflib.hat[~buflib.hat.size.rand.debug("k")],
						~buflib.clap[~buflib.clap.size.rand.debug("k")],
					].choose.value,
					\isRest, Pseq([
						Pseq(rrand(0.0,1.0!8)),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/(1..16).choose,
					\gain, 0.1,
				)
			}
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			12.collect { arg idx;
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/camelcactus.flac'),
					\pos, rrand(0.0,129),
					\speed, rrand(0.5,2),
					\isRest, Pseq([
						Pseq(rrand(0.0,1.0!8)),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/(1..16).choose,
					\legato, rrand(0.1,1),
					\gain, 1/8,
					\out, BusDef(\sendbus1, \audio),
				)
			}
		)
		
	])
)).play;
);
BufDef('vipere/camelcactus.flac').duration

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			12.collect { arg idx;
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('vipere/camelcactus.flac'),
					\pos, rrand(0.0,129),
					\speed, rrand(0.5,2),
					\isRest, Pseq([
						Pseq(rrand(0.0,1.0!8)),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/(1..16).choose,
					\legato, rrand(0.1,1),
					\gain, 1/8,
				)
			}
		),
		Ppar(
			8.collect { arg idx;
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					\bufnum, [
						~buflib.kick[~buflib.kick.size.rand.debug("k")],
						~buflib.snare[~buflib.snare.size.rand.debug("k")],
						~buflib.hat[~buflib.hat.size.rand.debug("k")],
						~buflib.clap[~buflib.clap.size.rand.debug("k")],
					].choose.value,
					\isRest, Pseq([
						Pseq(rrand(0.0,1.0!8)),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/(1..16).choose,
					\gain, 0.1,
					\out, BusDef(\sendbus1, \audio),
				)
			}
		)
		
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[966].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,1,0,
				0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/5,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[287].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1591].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/24,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[293].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,1,0,0,
			],inf).coin.not,
			\dur, 1/20,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[129].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Ppar(
			{
				thisThread.randSeed = rrand(1,100000).debug("seed");
				//4894
				5.collect { arg idx;
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, [
							//~buflib.kick[~buflib.kick.size.rand.debug("k")],
							//~buflib.snare[~buflib.snare.size.rand.debug("k")],
							~buflib.hat[~buflib.hat.size.rand.debug("k")],
							//~buflib.clap[~buflib.clap.size.rand.debug("k")],
						].choose.value,
						\isRest, Pseq([
							Pseq(rrand(0.0,1.0!8)),
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/(1..16).choose,
						\gain, 0.1,
						\out, BusDef(\sendbus1, \audio),
					)
				}
			}.value
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(
			5.collect { arg idx;
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					\bufnum, [
						//~buflib.kick[~buflib.kick.size.rand.debug("k")],
						//~buflib.snare[~buflib.snare.size.rand.debug("k")],
						~buflib.hat[~buflib.hat.size.rand.debug("k")],
						//~buflib.clap[~buflib.clap.size.rand.debug("k")],
					].choose.value,
					\isRest, Pseq([
						Pseq(rrand(0.0,1.0!8)),
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/(1..16).choose,
					\gain, 0.1,
					\out, BusDef(\sendbus1, \audio),
				)
			}
		)
	])
)).play;
);

(
	// polyrythm orig
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[966].value,
			\bufnum, ~buflib.kick[1266].value,
			//\bufnum, ~buflib.kick[1498].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,1,0,
				0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/5,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[287].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1591].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/24,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[293].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,1, 0,1,0,1,
				0,0,1, 0,0,1, 0,1,
				//1,0,1,0, 0,1,0,0,
				//1,0,0,1, 0,0,1,0,
				//0,1,0,0,
			],inf).coin.not,
			\dur, 1/( 8*2 ),
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[129].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Ppar(
			{
				thisThread.randSeed = rrand(1,100000).debug("seed");
				thisThread.randSeed = 99543;
				//4894
				5.collect { arg idx;
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, [
							//~buflib.kick[~buflib.kick.size.rand.debug("k")],
							//~buflib.snare[~buflib.snare.size.rand.debug("k")],
							~buflib.hat[~buflib.hat.size.rand.debug("h")],
							//~buflib.clap[~buflib.clap.size.rand.debug("k")],
						].choose.value,
						\isRest, Pseq([
							Pseq(rrand(0.0,1.0!8)),
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/(1..16).choose,
						\gain, 0.1,
						\out, BusDef(\sendbus1, \audio),
						//\isRest, true,
					)
				}
			}.value
		),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-AN60-DEBM", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.48319327731092,
	'gain', 0.68487394957983,
	'fb', 0.00032737717297666,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 43.0976690163,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 20.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

//ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-AEA1-K7FN", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.07563025210084,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.47937156455582,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.1647570563372,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
//ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-65UR-2DQL", BusDef('sendbus1'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.73529411764706,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 22.758459260748,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 1232.9514112674,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


//ProtoDef(\rdn3).presetCompileString.editorInsert
(
	// hifreq
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-KMK8-LMQ7", BusDef('sendbus1'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.47899159663866,
	'fb', 0.0001,
	'delay', 0.0005080218046913,
	'delay2', 0.0033838551534282,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.42682721311638,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 131.93430290754,
	'lpf', 17000,
	'hpf', 4421.4814854863,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 870.33301418488,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
	// polyrythm calmer
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[966].value,
			\bufnum, ~buflib.kick[1266].value,
			//\bufnum, ~buflib.kick[1498].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,1,0,
				1,0,0,0,0,
			],inf).coin.not,
			\dur, 1/5,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[287].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1591].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],4),

				Pseq([
					0,0,0,0, 0,0,1,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],4),

				Pseq([
					0,0,0,0, 0,0,1,0,
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
				],3),

				Pseq([
					0,0,0,0, 0,0,1,0,
					0,0,0,1, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\dur, 1/24,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[293].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,1, 0,1,0,1,
				0,0,1, 0,0,1, 0,1,
				//1,0,1,0, 0,1,0,0,
				//1,0,0,1, 0,0,1,0,
				//0,1,0,0,
			],inf).coin.not,
			\dur, 1/( 8*2 ),
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[129].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Ppar(
			{
				thisThread.randSeed = rrand(1,100000).debug("seed");
				thisThread.randSeed = 99543;
				//4894
				5.collect { arg idx;
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, [
							//~buflib.kick[~buflib.kick.size.rand.debug("k")],
							//~buflib.snare[~buflib.snare.size.rand.debug("k")],
							~buflib.hat[~buflib.hat.size.rand.debug("h")],
							//~buflib.clap[~buflib.clap.size.rand.debug("k")],
						].choose.value,
						\isRest, Pseq([
							Pseq(rrand(0.0,1.0!8)),
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/(1..16).choose,
						\gain, 0.1,
						\out, BusDef(\sendbus1, \audio),
						//\isRest, true,
					)
				}
			}.value
		),
		
	])
)).play;
);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
	// lofidist
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-DLEM-16EN", BusDef('sendbus1'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.63865546218487,
	'fb', 0.0001,
	'delay', 0.0019684194472866,
	'delay2', 0.00015910384392722,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 22.758459260748,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 1232.9514112674,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
	// polyrythm 
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[966].value,
			\bufnum, ~buflib.kick[1266].value,
			//\bufnum, ~buflib.kick[1498].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0,0, 1,1,0,0,0,
				1,0,0,0,0, 1,1,0,0,1,
			],inf).coin.not,
			\dur, 1/10,
			\dur, Pkey(\dur) * (1 + (0.7 * Pseq([1,-1],inf))),
			\legato, Pseq([2,0.51],inf)*0.8,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[287].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1591].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/24,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[293].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,1, 0,1,0,1,
				0,0,1, 0,0,1, 0,1,
				//1,0,1,0, 0,1,0,0,
				//1,0,0,1, 0,0,1,0,
				//0,1,0,0,
			],inf).coin.not,
			\dur, 1/( 8*2 ),
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[129].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[255].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[14].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,1,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.07,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[419].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1, 0,0,1, 0,0,1, 0,0,1,
				0,0,1, 1,0,0, 0,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12/2,
			\gain, 0.07,
			\out, BusDef(\sendbus1, \audio),
		),
		Ppar(
			{
				thisThread.randSeed = rrand(1,100000).debug("seed");
				//thisThread.randSeed = 99543;
				//4894
				5.collect { arg idx;
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, [
							//~buflib.kick[~buflib.kick.size.rand.debug("k")],
							//~buflib.snare[~buflib.snare.size.rand.debug("k")],
							~buflib.hat[~buflib.hat.size.rand],
							//~buflib.clap[~buflib.clap.size.rand.debug("k")],
						].choose.value,
						\isRest, Pseq([
							Pseq(rrand(0.0,1.0!8)),
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/(1..16).choose,
						\gain, 0.1,
						\out, BusDef(\sendbus1, \audio),
						\isRest, true,
					)
				}
			}.value
		),
		
	])
)).play;
);

//ProtoDef(\rdn4).presetCompileString.editorInsert
(
ProtoDef('rdn4').make('deldefault', 'rdn4', "5-AUCL-PT5D", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.39937176023131,
	'gain', 0.9327731092437,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.047018514892999,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.7696979983161,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);


(
	// polyrythm 
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[966].value,
			\bufnum, ~buflib.kick[1266].value,
			//\bufnum, ~buflib.kick[1498].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0,0, 1,1,0,0,0,
				1,0,0,0,0, 1,1,0,0,1,
			],inf).coin.not,
			\dur, 1/10,
			\dur, Pkey(\dur) * (1 + (0.7 * Pseq([1,-1],inf))),
			\legato, Pseq([2,0.51],inf)*0.8,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[287].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1591].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/24,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[293].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,1, 0,1,0,1,
				0,0,1, 0,0,1, 0,1,
				//1,0,1,0, 0,1,0,0,
				//1,0,0,1, 0,0,1,0,
				//0,1,0,0,
			],inf).coin.not,
			\dur, 1/( 8*2 ),
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[129].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[255].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[14].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,1,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.07,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[419].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1, 0,0,1, 0,0,1, 0,0,1,
				0,0,1, 1,0,0, 0,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12/2,
			\gain, 0.07,
			\out, BusDef(\sendbus1, \audio),
		),
		Ppar(
			{
				thisThread.randSeed = rrand(1,100000).debug("seed");
				//thisThread.randSeed = 99543;
				//4894
				5.collect { arg idx;
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, [
							//~buflib.kick[~buflib.kick.size.rand.debug("k")],
							//~buflib.snare[~buflib.snare.size.rand.debug("k")],
							~buflib.hat[~buflib.hat.size.rand],
							//~buflib.clap[~buflib.clap.size.rand.debug("k")],
						].choose.value,
						\isRest, Pseq([
							Pseq(rrand(0.0,1.0!8)),
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/(1..16).choose,
						\gain, 0.1,
						\out, BusDef(\sendbus1, \audio),
						\isRest, true,
					)
				}
			}.value
		),
		Pbind(
			\instrument, \basicbass,
			\lpf, 4000,
			\note, Pseq([
				0,2,0,-1
			],inf),
			\legato, Pseq([
				7,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
						\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

(
	// polyrythm 
ProtoDef(\FxManager).play;
ProtoDef(\rdn2).stop;
ProtoDef(\rdn4).play; // long bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[966].value,
			\bufnum, ~buflib.kick[1266].value,
			//\bufnum, ~buflib.kick[1498].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0,0, 1,1,0,0,0,
				1,0,0,0,0, 1,1,0,0,1,
			],inf).coin.not,
			\dur, 1/10,
			\dur, Pkey(\dur) * (1 + (0.7 * Pseq([1,-1],inf))),
			\legato, Pseq([2,0.51],inf)*0.8,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[287].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1591].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/24,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[293].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,1, 0,1,0,1,
				0,0,1, 0,0,1, 0,1,
				//1,0,1,0, 0,1,0,0,
				//1,0,0,1, 0,0,1,0,
				//0,1,0,0,
			],inf).coin.not,
			\dur, 1/( 8*2 ),
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[129].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[255].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[14].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,1,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.07,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[419].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,1, 0,0,1, 0,0,1, 0,0,1,
				//0,0,1, 1,0,0, 0,0,1, 1,0,1,
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/12/2,
			\gain, 0.07,
			\out, BusDef(\sendbus1, \audio),
		),
		Ppar(
			{
				thisThread.randSeed = rrand(1,100000).debug("seed");
				thisThread.randSeed = 96792;
				//4894
				5.collect { arg idx;
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, [
							//~buflib.kick[~buflib.kick.size.rand.debug("k")],
							//~buflib.snare[~buflib.snare.size.rand.debug("k")],
							~buflib.hat[~buflib.hat.size.rand],
							//~buflib.clap[~buflib.clap.size.rand.debug("k")],
						].choose.value,
						\isRest, Pseq([
							Pseq(rrand(0.0,1.0!8)),
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/(1..16).choose,
						\gain, 0.1,
						\out, BusDef(\sendbus1, \audio),
						//\isRest, true,
					)
				}
			}.value
		),
		Pbind(
			\instrument, \basicbass,
			\lpf, 4000,
			\note, Pseq([
				0,0,0,0,
				0,0,0,-1
			],inf),
			\legato, Pseq([
				7,0,0,0, 0,0,0,1,
				7,0,0,0, 0,0,0,1,
				7,0,0,0, 0,0,0,1,
				6,0,0,0, 0,0,1,1,

				7,0,0,0, 0,0,0,1,
				5,0,0,0, 0,1,0,1,
				7,0,0,0, 0,0,0,1,
				1,2,0,4, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
						\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

(
	// polyrythm drumloop
//ProtoDef(\FxManager).play;
//ProtoDef(\rdn2).stop;
//ProtoDef(\rdn4).play; // long bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[966].value,
			\bufnum, ~buflib.kick[1266].value,
			//\bufnum, ~buflib.kick[1498].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0,0, 1,1,0,0,0,
				1,0,0,0,0, 1,1,0,0,1,
			],inf).coin.not,
			\dur, 1/10,
			\dur, Pkey(\dur) * (1 + (0.7 * Pseq([1,-1],inf))),
			\legato, Pseq([2,0.51],inf)*0.8,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[129].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,1,0,
				//0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[255].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[14].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,1,0,0, 0,0,0,
				0,0,0,1, 0,0,0,
				0,0,0,1, 0,0,1,
				//0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/7,
			\gain, 0.07,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[419].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,1, 0,0,1, 0,0,1, 0,0,1,
				//0,0,1, 1,0,0, 0,0,1, 1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/12/2,
			\gain, 0.07 * Pseq([
				Pwhite(0.1,1,1),Pwhite(0.8,1,7),
			],inf),
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Ppar(
			{
				thisThread.randSeed = rrand(1,100000).debug("seed");
				thisThread.randSeed = 31844;
				//4894
				5.collect { arg idx;
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, [
							//~buflib.kick[~buflib.kick.size.rand.debug("k")],
							//~buflib.snare[~buflib.snare.size.rand.debug("k")],
							~buflib.hat[~buflib.hat.size.rand],
							//~buflib.clap[~buflib.clap.size.rand.debug("k")],
						].choose.value,
						\isRest, Pseq([
							Pseq(rrand(0.0,1.0!8)),
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						\dur, 1/(1..16).choose,
						\gain, 0.1,
						\out, BusDef(\sendbus1, \audio),
						//\isRest, true,
					)
				}
			}.value
		),
		Pbind(
			\instrument, \basicbass,
			\lpf, 4000,
			\note, Pseq([
				0,0,0,0,
				0,0,0,-1
			],inf),
			\legato, Pseq([
				7,0,0,0, 0,0,0,1,
				7,0,0,0, 0,0,0,1,
				7,0,0,0, 0,0,0,1,
				6,0,0,0, 0,0,1,1,

				7,0,0,0, 0,0,0,1,
				5,0,0,0, 0,1,0,1,
				7,0,0,0, 0,0,0,1,
				1,2,0,4, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
						\out, BusDef(\sendbus4, \audio),
						\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2, 0,
			]+0,1),1).loop / Pkey(\st),
			\pos, Pseq([
				//(0..3)+0,
				//(0..3)+4,
				(0..7),
				0,1,2,8, 4,12,7,12,
				0,6,12,6, 4,6,7,6,
				(0..7)+16,
				8,9,10,8, 20,21,22,23,
				(0..7)+24,
				//(0..7),
				//(0..3)+4,
			].flat/8,inf)/ Pkey(\st),
			\dur, 1/16,
			\gain, 1/2,
			\isRest, Pseq([
				1,0.6,
				1,1,1,0.6,
			],inf).coin.not,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
	])
)).play;
);
