

	(
	FileSystemProject.load("holis/main.scd");
	FileSystemProject.load("holis/partmain.scd");
	)
(
~t = 195/4/60; TempoClock.default.tempo = ~t;
~swing = 0.3;
)

(
SynthDef(\freecorde, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01, spread=1;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmr.kr(1.2)) * \fmamp.kr(1) + 1 )) * ( SinOsc.ar(freq * \amr.kr(0.2)) * \amamp.kr(1) + 1 );
	sig = sig * 0.9;
	sig = SelectX.ar( LFNoise1.ar((1..8)/12).range(0,1), sig  );
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

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
Pdef(\zed, 
	Pbind(
		\instrument, \freecorde,
		\amr, 1.01,
		\amamp,0.7,
		\fmamp, 0,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \freecorde,
					\amr, 1.01,
					\fmr, 1/1.99,
					\amamp,0.7,
					\fmamp, Pseg(Pwhite(0,1,inf),8),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\note, Pseq([
						Pseq([0,2,4,5,7,9,11,12].collect({ arg x; x + ( ( (1..5).choose-3 ) * 12 ) }).scramble-2),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1/10,
				));
				2.wait;
			}
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \freecorde,
					\amr, 1.01,
					\fmr, 1/1.99,
					\amamp,0.7,
					\fmamp, Pseg(Pwhite(0,1,inf),8),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\note, Pseq([
						Pseq([0,2,3,4,5,6,7,9,11,12].collect({ arg x; x + ( ( (1..5).choose-3 ) * 12 ) }).scramble-2),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1/10,
				));
				2.wait;
			}
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
					\ctranspose, Pstep(Pseq([
						0,2,
					],inf),2),
		)<>
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \freecorde,
					\amr, 1.01,
					\fmr, 1/1.99,
					\amamp,0.7,
					\fmamp, Pseg(Pwhite(0,1,inf),8),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\note, Pseq([
						Pseq([0,3,7,10,12].collect({ arg x; x + ( ( (1..5).choose-3 ) * 12 ) }).scramble-2),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1/10,
				));
				2.wait;
			}
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
					\mtranspose, Pstep(Pseq([
						//0,5,7,5,
						0,3,1,4,
						//0,3,-2,4,
					],inf),2),
					//\scale, Scale.choose.debug("scale"),
		)<>
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \freecorde,
					\amr, 1.01,
					\fmr, 1/1.99,
					\amamp,Pseg(Pwhite(0,1,inf),Prand([4,8],inf)),
					\fmamp, Pseg(Pwhite(0,1,inf),8),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\degree, Pseq([
						//Pseq([0,2,4,-1b, 0,2,4,0,2,4, 0,2,4,-1b, 1,3])
						Pseq([0,4, 0,2,4, 6,8,10]
							.collect({ arg x; x + ( ( (1..5).choose-3 ) * 7 ) })
							.collect({ arg x; if(0.5.coin) { x } { \r } })
							.scramble),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1/10,
				));
				2.wait;
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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\out, BusDef(\bus1, \audio),
			\instrument, \default,
			\note, Pseq([
				Pseq( (1..12).mirror1 ),
			],inf),
			\sustain, 0.1,
			\dur, 1/2,
			\amp, 0.1,
		),
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
			\mix, 0.95,
			'delay', 0.01034499684705497,
			'delay2', ~pmodenv.(Pseq([0.91,0.1,0.0001],1), 8).loop,
			'delay', ~pmodenv.(Pseq([0.91,0.1,0.0001],1), 8).loop,
			\hpf, 10,
			\lpf, 20000,
			\indelay, 0.04,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.7453781512605,
			\lag, 0.0009,
			\gain, 0.1,
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
					\amp, 0.1 * [1,1,0.7,1,1].wrapAt(idx),
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
				],4),
			],inf) - Pstep(Pseq((0..9),inf),8),
			\dur, Pexprand(1/20,1/4),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
SynthDef(\ploc2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,1/2],[0.01,0.1,1]), 1);
	sig = LFSaw.ar(freq * [1,1.00001 ]).mean;
	sig = sig + SinOsc.ar(freq * [1,1.01]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq* env1, \rq.kr(0.5));
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
		0, Pmono(\down,
			\freq, ~pmodenv.(Pseq([200,102],1), 30, 1, \exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
			0.31, Pmono(\down,
				   \freq, ~pmodenv.(Pseq([5000,2000,200,102],1), 32, 1, \exp).loop,
				   \dur, 1,
				   \amp, ~pmodenv.(Pseq([0,1,1,1]*0.05,1), 8).loop,
			   ),
			1.4, Pmono(\down,
				   \freq, ~pmodenv.(Pseq([2000,200,102],1), 32, 1, \exp).loop,
				   \dur, 1,
				   \amp, 0.1,
				   \amp, ~pmodenv.(Pseq([0,1,1,1]*0.05,1), 8).loop,
			   ),
		]),
		Pbind(
			\instrument, \ploc2,
			\note, Pseq([
				Prand([
					0,1,4,6,
				],4),
				Prand([
					0,1,3,4,
				],4),
			],inf) - Pstep(Pseq((0..9),inf),8),
			\lpfr, ~pmodenv.(Pseq([10,1],1), 32).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, Pexprand(1/20,1/4),
			\amp, 0.1*0.5,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\part2, 
		Pbind(
			\instrument, \ploc2,
			\note, Pseq([
				Prand([
					0,1,4,6,
				],4),
				Prand([
					0,1,3,4,
				],4),
			],inf) - Pstep(Pseq((0..9),inf),8),
			\lpfr, ~pmodenv.(Pseq([10,1],1), 32).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, Pexprand(1/20,1/4),
			\amp, 0.1*0.5,
			\out, BusDef(\sendbus1, \audio),
		),
).play;
);


(
Ndef(\fx1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	lfo1 = EnvGen.kr(Env([1,20,1],[0.01,0.08]), TDuty.kr(1/8/~t, 0, Dseq([
		1,0,0,1, 0,0,1,0,
	],inf)));
	lfo2 = EnvGen.kr(Env([0,3,0],[0.01,0.1]), TDuty.kr(1/8/~t, 0, Dseq([
		1,0,0,1, 0,0,1,0,
	],inf)));
	//sig = sig * SinOsc.ar(freq * ( SinOsc.kr(lfo1) * 1 + 1 ));
	//sig = Latch.ar(sig, SinOsc.ar(1000) );
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.1)  ) + sig;
	
		isig = DelayL.ar(isig, 0.4,0.4 * LFNoise1.kr(1/2).range(0.01,1.0))+isig;
		isig = DelayL.ar(isig, 0.4,0.4 * LFNoise1.kr(1/2).range(0.01,1.0))+isig;
		isig = DelayL.ar(isig, 0.4,0.4 * LFNoise1.kr(1/2).range(0.01,1.0))+isig;
		isig = DelayL.ar(isig, 0.4,0.4 * LFNoise1.kr(1/2).range(0.01,1.0))+isig;
		isig = LFPulse.ar(isig + 1 * 100)+1 * isig;
		//isig = DelayL.ar(isig, 0.4,0.4 * LFNoise1.kr(1/2).range(0.1,1.0))+isig;
		//isig = DelayL.ar(isig, 0.4,0.4 * LFNoise1.kr(1/2).range(0.1,1.0))+isig;
		isig = isig.tanh;
		Amplitude.ar(isig).poll;
		isig = HPF.ar(isig, 20);
		//isig = Compander.ar(isig, isig, \cpt.kr(1.0), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
		isig;
	});
	sig = sig * 0.1;
	//sig1 = PinkNoise.ar(0.1) * lfo2;
	//sig = sig * ( sig1 + 1 );
	sig = LeakDC.ar(sig);
	sig = sig.tanh;
	sig = Limiter.ar(sig);
	//sig = ( sig * lfo1 ).tanh/10;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
}).play;
);

(
Ndef(\fx1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	lfo1 = EnvGen.kr(Env([1,200,1],[0.01,0.08]), TDuty.kr(1/8/~t, 0, Dseq([
		1,0,0,1, 0,0,1,0,
	],inf)));
	lfo2 = EnvGen.kr(Env([0,3,0],[0.01,0.1]), TDuty.kr(1/8/~t, 0, Dseq([
		1,0,0,1, 0,0,1,0,
	],inf)));
	lfo3 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), TDuty.kr(1/8/~t, 0, Dseq([
		1,0,0,1, 0,0,1,0,
	],inf)));
	//sig = sig * SinOsc.ar(freq * ( SinOsc.kr(lfo1) * 1 + 1 ));
	//sig = Latch.ar(sig, SinOsc.ar(1000) );
	sig1 = SelectX.ar(lfo3, [ DC.ar(0),sig]);
	sig2 = CombL.ar(sig1, 1/~t, 0.1*( 1/lfo1 ) + [ [0,0.1,0.01] ],9/~t).flop.mean;
	sig.debug("sig");
	sig = SelectX.ar( LFNoise1.kr(1/6).range(0.0,1.0), [ sig, sig2]);

	//sig1 = PinkNoise.ar(0.1) * lfo2;
	//sig = sig * ( sig1 + 1 );
	sig = LeakDC.ar(sig);
	sig = sig.tanh;
	sig = Limiter.ar(sig);
	//sig = ( sig * lfo1 ).tanh/10;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
}).play;
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
