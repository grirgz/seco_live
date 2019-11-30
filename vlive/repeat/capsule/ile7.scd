
(
	TempoClock.default.tempo = 190/60;
	//Pdef.defaultQuant = 2;
	//Ndef.defaultQuant = 0;
	Tdef.defaultQuant = 2;
	Pdef(\archeo).play
	~t = TempoClock.default.tempo;
	s.waitForBoot {
		FileSystemProject.load("barlok1/archeolib.scd")
	};

)

(
	~qdo.({
		Pdef(\main).stop;
		Ndef(\myfx1).play;
		Tdef(\fx).play;
	}, 4);
	Pdef(\archeo).play;
)
Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo2));
Ndef(\myfx1).clear
	Pdef(\archeo).stop;


(
Pdef(\part, Pdef(\scram, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\out, BusDef(\fx1, \audio),
			//\freq, Pseg(Pexprand(80,1001,inf),8),
			\octave, 3,
			\legato, 1,
			\lpfr, 2,
			\note, Pseq([
				0,-5,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,1,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\archkick, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1966].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/2,
			\out, BusDef(\fx1, \audio),
			\gain, 0.3,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\archkick, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1966].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/1,
			\out, BusDef(\fx1, \audio),
			\gain, 0.3,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\archsnare, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1966].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.4,
			\dur, 1/2,
			\gain, 0.3,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\archsnare, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1966].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.4,
			\dur, 1/1,
			\gain, 0.3,
		),
		
	])
)).play;
);

ProtoDef(\myfx1).edit;

Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo2));
Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
Ndef(\myfx1).put(100, \pset -> ( Pbind(\fb, Pkey(\fb) * 041) <> Pdef(\fxrev1) ));
RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugk7", BusDef(\fx1)); // calm
RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C7", BusDef(\fx1)); // slow rise 2

(
Pdef(\part, Pdef(\randperc, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Kick/*".pathMatch.choose),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/1,
			\gain, 0.2,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(\lag, 0.04,
			\out, BusDef(\fx1, \audio),
		
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/Snare/*".pathMatch.choose),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],4),
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],4),
					0,0,0,0, 1,0,0,1,
					1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
				\dur, 1/2,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo("/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.choose),
				\dur, 1/4,
			\sustain, 0.2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				1,1,1,1, 1,0,0,0,
				0,0,0,0, 1,1,1,1,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,0,1,0, 1,0,1,0,
				],4),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
				\gain, 0.2,
			),
		]),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('vipere/moeten.flac'),
			\dur, 1,
			\out, BusDef(\fx1, \audio),
			\gain, 1,
		)
		
	])
)).play;
);
