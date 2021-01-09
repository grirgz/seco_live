

~t = 195/4/60; TempoClock.default.tempo = ~t;
~swing = 0.3;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bilin,
			\note, Prand([
				6,8,
				6,8,\r,
				6,8,\r,
				10,11
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq( (1..12).mirror1 ),
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \default,
					\note, Pseq([
						Pseq((0..5).collect({ arg x; x + ( ( (1..5).choose-3 ) * 12 ) }).scramble-2),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1,
				));
				1.wait;
			}
		})
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			//\ctranspose, Pstep(Pseq([
				//Pn(0,16),
				//Pseq((0..15))
			//],inf),1/4),
			\out, BusDef(\sendbus1, \audio),

		)<>
		Pspawner({ arg sp;
			var players = List.new;
	   
			10.do {
				var dur = [1/4,1/8,1/2,1.0].choose;
				players.add(sp.par(
					
					Pbind(
					//\instrument, [\bilin,\default].choose,
					\instrument, ~holis_synthdefs.choose.postln,
					\fmfreq, Pstep(Pseq([1,4,8,16],inf),1),
					\note, Pseq([
						Pseq((0..5).scramble-2 + ( (1..35).choose-17 )),
					],inf),
					\dur, dur,
					\lag, dur.rand,
					\amp, 0.1,
				)));
				1.wait;
			};
			8.wait;
			players.do({ arg x; x.stop });
			4.wait;
		}).loop
		
	])
)).play;
);

~holis_instruments.choose.play
Pdef(\part).clear;

(
	~master.();
	// fx is strangeverb2
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		(Pbind(
			\ctranspose, Pstep(Pseq([
				Pseq((40..0).linexp(0,40,1,41)),
				Pn(0,116),
			],inf),1/4),
			\out, BusDef(\sendbus2, \audio),

		)<>
		Pspawner({ arg sp;
			var players = List.new;
	   
			10.do {
				var dur = [1/4,1/8,1/2,1.0].choose/2;
				players.add(sp.par(
					
					Pbind(
					//\instrument, [\bilin,\default].choose,
					\instrument, ~holis_synthdefs.choose.postln,
					\fmfreq, Pstep(Pseq([1,4,8,16],inf),1),
					\note, Pseq([
						Pseq((0..5).scramble-2 + ( (1..35).choose-17 )),
					],inf),
					\dur, dur,
					\lag, dur.rand,
					\amp, 0.1,
				)));
				1.wait;
			};
			8.wait;
			players.do({ arg x; x.stop });
			4.wait;
		})).loop
		
	])
)).play;
);



(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bilin,
			\note, Prand([
				6,8,
				6,8,\r,
				6,8,\r,
				10,11
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \default,
			\note, Pseq([
				Pseq( (1..12).mirror1 ),
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\out, BusDef(\bus1, \audio),
			\instrument, \default,
			\instrument, \longf,
			\note, Pseq([
				Pseq( (1..12).mirror1 ),
			],inf),
			\sustain, 0.1,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pmono(\rdnchorusverb,
			\inbus, BusDef(\bus1, \audio),
			\addAction, \addToTail,
			\mix, 0.05,
			'delay', 0.11034499684705497,
			'delay2', 0.2909850299557,
			\hpf, 10,
			\lpf, 20000,
			\indelay, 0.04,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.7453781512605,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert


(
	~master.();
	// fx is strangeverb2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		(Pbind(
			\ctranspose, Pstep(Pseq([
				Pseq((40..0).linexp(0,40,1,41)),
				Pn(0,116),
			],inf),1/4),
			\out, BusDef(\sendbus1, \audio),

		)<>
		Pspawner({ arg sp;
			var players = List.new;
			var ilist = [
						\stringsx,
						\perctone,
						\pluck,
						\sibass,
						\organ_tonewheel1,

			];
	   
			10.do { arg idx;
				var dur = [1/4,1/8,1/2,1.0].choose;
				players.add(sp.par(
					
					Pbind(
					//\instrument, [\bilin,\default].choose,
					//\instrument, ~holis_synthdefs.choose.postln,
					\instrument, ilist.choose.postln,
					\instrument, ilist.wrapAt(idx).postln,
					\fmfreq, Pstep(Pseq([1,4,8,16],inf),1),
					\note, Pseq([
						Pseq((0..5).scramble-2 + ( (1..35).choose-17 )),
					],inf),
					\dur, dur,
					\lag, dur.rand,
					\amp, 0.1,
				)));
				1.wait;
			};
			8.wait;
			players.do({ arg x; x.stop });
			4.wait;
		})).loop
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1086].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1687].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1841].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.41 * Pseq([
					1,Pwhite(0.1,0.4,1),
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[639].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1406].value, // 1406 cymbal
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 4,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.21 * Pseq([
					1
				],inf),

			),
		]),
	])
)).play;
);

(
	// fast
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio),
	
	) <>
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1086].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1687].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1841].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.41 * Pseq([
					1,Pwhite(0.1,0.4,1),
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[639].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1406].value, // 1406 cymbal
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 4,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.21 * Pseq([
					1
				],inf),

			),
		].collect({ arg pat;
	   
		Pbind(\dur, Pseg(Pseq([1/4,1/300,1/1000],inf),8)) <> pat;
		})),
	])
)).play;
);

(
	// slow
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1086].value,
				\isRest, Pseq([
					1,0,0,0, 0,1,0,0,
					0,0,0,0, 0,1,0,1,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1687].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0.71, 0,0,0.71,0,
					0,0,0,0, 0,0.71,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					2,1,1,1, 1,1.3,1,1,
				],inf)/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1841].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.41 * Pseq([
					1,Pwhite(0.1,0.4,1),
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1726].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,1,0,
					1,1,1,1, 0,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.11 * Pwhite(0.1,0.8),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[639].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
				\gain, 0.11 * Pwhite(0.5,0.8),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1406].value, // 1406 cymbal
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 4,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.21 * Pseq([
					1
				],inf),

			),
		]),
	])
)).play;
);

(
	// slow
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1086].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1687].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					2,1,1,1, 1,1.3,1,1,
				],inf)/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1841].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.41 * Pseq([
					1,Pwhite(0.1,0.4,1),
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1406].value, // 1406 cymbal
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 4,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.21 * Pseq([
					1
				],inf),

			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\fear1),
			\lag, 0.04,
			\legato, 0.9,
			\dur, 8,
			\gain, 1,
		)
	])
)).play;
);

(
Ndef(\rdn).put(100, \pset -> Pbind(
	\mix, Pseq([
		0,0,0,0,
		1,0,0,0, 
	],inf) * 0.5,
	\dur, 1/4,
))
)
(
Ndef(\rdn).put(100, \pset -> Pbind(
	\mix, Pseq([
		1,1,1,1, 
		1,1,1,0, 
		1,0,1,1, 
		0,0,1,0,
		0,0,1,1, 
		0,0,1,0, 
		0,0,1,0, 
		1,1,1,1,
	],inf) * 0.5,
	\dur, 1/4,
))
)

(
Ndef(\rdn).put(100, \pset -> Pbind(
	\mix, Pseq([
		0,0,1,1, 
		1,1,1,0, 
		0,0,1,0, 
		1,1,1,1, 
	],inf) * 0.5,
	\dur, 1/4,
)).quant_(1)
)
Ndef(\rdn).put(100, nil)

Ndef(\rdn).set(\delay, Ndef(\lfo1, { SinOsc.ar(3*~t).exprange(0.00001,0.002)  }))
Ndef(\lfo1).quant=1

Ndef(\rdn).set(\delay, Ndef(\lfo1))
Ndef(\rdn).set(\delay, 0.1)
Ndef(\rdn).set(\delay2, Ndef(\lfo1))

(
Ndef(\lfo1, { arg freq=3;
	SinOsc.ar(freq.poll).exprange(0.0000001,0.0002)  
});
Ndef(\lfo1).put(100, \set-> Pbind(
	\freq, Pseq([
		4,4,
		1,3,
		8,3,
	],inf)*~t,
	\dur, 1,
))
)


(
SynthDef(\down, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\ploc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\down,
			\freq, ~pmodenv.(Pseq([200,102],1), 32, 1, \exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\down,
			\freq, ~pmodenv.(Pseq([200,102],1), 30, 1, \exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \ploc,
			\note, Pseq([
				Prand([
					0,1,4,6,
				],4),
				Prand([
					0,1,3,4,
				],4)-3,
			],inf),
			\dur, Pexprand(1/20,1/4),
			\amp, 0.1,
		),
	])
)).play;
);
~pmodenv.def.argNames

(
SynthDef(\down, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freqs = freq* ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	env1 = EnvGen.kr(Env([1,2,1],[ [0.1,20.8] ]), 1).mean;
	sig = SinOsc.ar(freqs * ( SinOsc.kr([1,1.2]*0.1) * 0.1 + 1 ));
	sig2 = SinOsc.ar(freqs * 1 * ( SinOsc.ar((1..10)*freq * env1) * 0.1 + 1 )).fold2( SinOsc.ar(freq * env1).range(0.17,0.01));
	sig2 = HPF.ar(sig2, 1400);
	sig2 = RLPF.ar(sig2, \lpfr2.kr(4.1) * freq, \rq.kr(0.5));
	sig2 = Splay.ar(sig2, \spread.kr(0.8), 1, pan);
	sig3 = LFSaw.ar(freqs).mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = [sig, sig2,sig3].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\ploc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pmono(\down,
			   	\freq, ~pmodenv.(Pseq([200,102],1), 32, 1, \exp).loop,
			   	\dur, 1,
			   	\amp, 0.1,
			   ),
			0.31, Pmono(\down,
			   	\freq, ~pmodenv.(Pseq([5000,2000,200,102],1), 32, 1, \exp).loop,
			   	\dur, 1,
			   	\amp, 0.1,
			   ),
			1.4, Pmono(\down,
			   	\freq, ~pmodenv.(Pseq([2000,200,102],1), 32, 1, \exp).loop,
			   	\dur, 1,
			   	\amp, 0.1,
			   ),
		]),
		Pbind(
			\instrument, \ploc,
			\note, Pseq([
				Prand([
					0,1,4,6,
				],4),
				Prand([
					0,1,3,4,
				],4)-3,
			],inf),
			\dur, Pexprand(1/20,1/4),
			\amp, 0.1,
		),
	])
)).play;
);

///////


(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	sig = sig * \gain.kr(1);
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
);
Ndef(\soundin).play(0,2)
Ndef(\soundin).edit;
