~t = 125/2/60; TempoClock.default.tempo = ~t;

// notetimeline au hasard
FileSystemProject.load("sun/fmgen.scd")


(
NoteTimeline('bassline').param = Param(Pdef('bass'), 'midinote');
NoteTimeline('bassline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.75, \midinote: 42.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.875, \midinote: 60.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.375, ),
	(\absTime: 1.625, \dur: 1.0, \midinote: 49.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.875, ),
	(\absTime: 2.625, \dur: 1.375, \midinote: 32.0, \playDur: 1.375, \relDur: 1.375, \sustain: 0.375, ),
	(\absTime: 4.0, \dur: 0.5, \midinote: 43.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4.5, \dur: 1.125, \midinote: 57.0, \playDur: 1.125, \relDur: 1.125, \sustain: 0.875, ),
	(\absTime: 5.625, \dur: 0.625, \midinote: 23.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.625, ),
	(\absTime: 6.25, \dur: 1.0, \midinote: 37.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.75, ),
	(\absTime: 7.25, \dur: 0.75, \midinote: 16.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.5, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);
NoteTimeline(\bassline).edit
NoteTimeline(\bassline).clear
NoteTimeline(\bassline).play


(
Pdef('bass', Pbind(
	\instrument, \saw,
)).setVal(
'lpfr', 2.05,
).setVal(
	'out', BusDef(\sendbus1,\audio,2),
);

);


(
ProtoDef('rdn').make('deldefault', 'rdn', "5-QS5J-H0IF", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.48739495798319,
	'gain', 0.24789915966387,
	'fb', 0.0001,
	'delay', 0.11902282447787,
	'delay2', 0.0028985772146511,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
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
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		NoteTimeline(\bassline).asPattern,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1538].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,

					1,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],1),

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[750].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[750].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1130].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,1,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,0.71,0.4, 0.7,0.4,0.7,1,
				0.7,1,0,0, 1,0,0.51,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4 * Pseq([
				Pwhite(0.7,1,1),
				Pwhite(0.4,1,1),
				Pwhite(0.9,1,1),
				Pwhite(0.2,1,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[147].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,1, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
				]/2,1),
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.7,1,1),
				Pwhite(0.2,1,1),
			],inf),
		),
		
	])
)).play;
);


(
Pdef(\melo, 
	Pbind(
		\instrument, ~fmgen_short.(14007,10),
		\amp, 0.02,
	)
)
);


~fmgen_short.(14007,10)
~fmgen_cluster2.({ 100000.rand }!100.rand; 10000.rand)
Pdef(\melo).play
ProtoDef(\piano).startControl(Pdef(\melo))


(
Pbindef(\coco, 
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);
Pbindef(\coco).edit

FileSystemProject.load("libdef/ModulatorRack.scd")
TrackDef(\ModulatorRack).edit
