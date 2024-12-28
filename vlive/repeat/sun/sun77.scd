
(
~t = 124/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("paramdev/drafts/arpegiator.scd");
FileSystemProject.load("libdef/Parp.scd");
)

(
SynthDef(\sh101, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq * ( \vcomod.kr(0) + 1 );
	sig = LFPulse.ar(freq,0,\pwidth.kr(0.5)) * \pulse.kr(0.5);
	sig = sig + (LFSaw.ar(freq) * \saw.kr(0.5));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(130) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	vcfmod = \vcfmod.kr(0) + 1;
	sig = MoogFF.ar(sig, ( \lpf.kr(930) * lpenv * lpfreq * vcfmod ).clip(20,20000), 1/\rq.kr(0.8)) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\supersaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq * ( \vcomod.kr(0) + 1 );
	// rand phase is important
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2!8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0), amp, pan);
	sig = RLPF.ar(sig, ( \lpf.kr(10.1)  ).clip(20,20000), \rq.kr(0.5));
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1363].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[404].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1076].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[319].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,-1,-3,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\envamt, Pseq([
				PmodEnv(Pseq([1,4],1), 1),
				PmodEnv(Pseq([1,8],1), 1),
				PmodEnv(Pseq([1,18],1), 1),
			],inf),
			\rq, Pseq([
				Plazy({ arg ev;
					Pseq([
						PmodEnv(Pseq([1,0.4],1), 8),
						PmodEnv(Pseq([0.4,1.4],1), 8),
					],1)
				}).loop,
			],inf),
			\lpf, 200,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		~parp.(NoteTimeline(\sun77melo1).asPattern, Pbind(
			\idx, Pseq([1,0,2,0],inf),
			\octaveshift, 1,
			\legato, 1,
			\dur, Pseq([1/8],inf),
		)),
		~parp.(NoteTimeline(\sun77melo1).asPattern, Pbind(
			\instrument, \sh101,
			\octaveshift, 0,
			\lpf, PmodEnv(Pseq([100,804],1), 8).loop,
			\envamt, 3,
			\idx, Prand([1,[2,0],2,4],inf),
			\legato, 1,
			\amp, 0.04,
			\dur, Pseq([1/4],inf),
		))
	])
)).play;
);

SampleTimeline(\kick, ~buflib.kick[1040].value).buffer.path

(
Pdef(\melo1, 
	Pbind(
		\instrument, \supersaw,
		\lpf, 400,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.11) ],
		],inf),
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))

NoteTimeline(\note1).edit
NoteTimeline(\sun77melo1, Pdef(\melo1)).edit
NoteTimeline(\sun77melo1).presetCompileString.editorInsert
(
NoteTimeline('sun77melo1').param = Param(Pdef('melo1'), 'midinote');
NoteTimeline('sun77melo1').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \clockTime: 13804.306834561, \dur: 0.0, \legato: 0.8, \midinote: 48.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.9196558512995, \velocity: 111, ),
	(\absTime: 0.0, \clockTime: 13804.241640663, \dur: 0.0, \legato: 0.8, \midinote: 67.0, \playDur: 0.0, \relDur: 0.0, \sustain: 7.7204761972662, \velocity: 85, ),
	(\absTime: 0.0, \clockTime: 13804.30730638, \dur: 0.0, \legato: 0.8, \midinote: 72.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \velocity: 96, ),
	(\absTime: 0.0, \clockTime: 13804.243757692, \dur: 2.0, \legato: 0.8, \midinote: 60.0, \playDur: 2.0, \relDur: 2.0, \sustain: 8.0, \velocity: 74, ),
	(\absTime: 2.0, \clockTime: 13806.197488656, \dur: 2.0, \legato: 0.8, \midinote: 50.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0228631128011, \velocity: 107, ),
	(\absTime: 4.0, \clockTime: 13808.198520631, \dur: 2.0, \legato: 0.8, \midinote: 52.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0827384782006, \velocity: 93, ),
	(\absTime: 6.0, \clockTime: 13810.207542768, \dur: 2.0, \legato: 0.8, \midinote: 53.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.75, \velocity: 60, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1363].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[404].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1076].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[319].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,-1,-3,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\envamt, Pseq([
				PmodEnv(Pseq([1,4],1), 1),
				PmodEnv(Pseq([1,8],1), 1),
				PmodEnv(Pseq([1,18],1), 1),
			],inf),
			\rq, Pseq([
				Plazy({ arg ev;
					Pseq([
						PmodEnv(Pseq([1,0.4],1), 8),
						PmodEnv(Pseq([0.4,1.4],1), 8),
					],1)
				}).loop,
			],inf),
			\lpf, 200,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		~parp.(NoteTimeline(\sun77melo1).asPattern(0,4), Pbind(
			\idx, Pseq([[1,0],[ 2,0 ],[0,1,2,3]],inf),
			\octaveshift, Pseq([2,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.6) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,900],1), 8).loop,
			\octaveshift, 1,
			\legato, 1/2,
			\dur, Pseq([1/2],inf),
		)),
		~parp.(NoteTimeline(\sun77melo1).asPattern(0,4), Pbind(
			\instrument, \sh101,
			\octaveshift, 0,
			\lpf, PmodEnv(Pseq([100,804],1), 8).loop,
			\envamt, 3,
			\idx, Prand([1,[2,0],2,4],inf),
			\legato, 1,
			\amp, 0.04,
			\dur, Pseq([1/4],inf),
		))
	])
)).play;
);

NoteTimeline(\sun77melo2, Pdef(\melo1)).edit
NoteTimeline(\sun77melo2, Pdef(\melo1)).presetCompileString.editorInsert
(
NoteTimeline('sun77melo2').param = Param(Pdef('melo1'), 'midinote');
NoteTimeline('sun77melo2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \clockTime: 15929.022395053, \dur: 0.0, \legato: 0.8, \midinote: 74.0, \playDur: 0.0, \relDur: 0.0, \sustain: 3.875, \velocity: 78, ),
	(\absTime: 0.0, \clockTime: 15929.080236099, \dur: 0.0, \legato: 0.8, \midinote: 80.0, \playDur: 0.0, \relDur: 0.0, \sustain: 3.875, \velocity: 21, ),
	(\absTime: 0.0, \clockTime: 15928.919891898, \dur: 4.0, \legato: 0.8, \midinote: 83.0, \playDur: 4.0, \relDur: 4.0, \sustain: 4.0, \velocity: 16, ),
	(\absTime: 4.0, \clockTime: 15932.708304045, \dur: 0.0, \legato: 0.8, \midinote: 81.0, \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, \velocity: 27, ),
	(\absTime: 4.0, \dur: 0.0, \midinote: 74.0, \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, ),
	(\absTime: 4.0, \clockTime: 15932.750868291, \dur: 4.0, \legato: 0.8, \midinote: 77.0, \playDur: 4.0, \relDur: 4.0, \sustain: 3.875, \velocity: 40, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1363].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[404].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1076].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[319].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,-1,-3,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\envamt, Pseq([
				PmodEnv(Pseq([1,4],1), 1),
				PmodEnv(Pseq([1,8],1), 1),
				PmodEnv(Pseq([1,18],1), 1),
			],inf),
			\rq, Pseq([
				Plazy({ arg ev;
					Pseq([
						PmodEnv(Pseq([1,0.4],1), 8),
						PmodEnv(Pseq([0.4,1.4],1), 8),
					],1)
				}).loop,
			],inf),
			\lpf, 200,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		~parp.(NoteTimeline(\sun77melo2).asPattern, Pbind(
			\idx, Pseq([0,2,0,1],inf),
			\octaveshift, Pseq([2,1],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.6) ],
			],inf),
			\lpf, PmodEnv(Pseq([300,1900],1), 8).loop,
			\octaveshift, 1,
			\legato, 1/2,
			\dur, Pseq([1/4],inf),
		)),
		NoteTimeline(\sun77melobass1).asPattern,
	])
)).play;
);

FileSystemProject.load("libdef/AutomationRack.scd")
Spec.add(\envamt, \lofreq)

(
Pdef(\melobass1, 
	Pbind(
		\instrument, \sh101,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.01) ],
		],inf),
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melobass1))

NoteTimeline(\sun77melobass1, Pdef(\melobass1)).edit
NoteTimeline(\sun77melobass1).presetCompileString.editorInsert
(
NoteTimeline('sun77melobass1').param = Param(Pdef('melobass1'), 'midinote');
NoteTimeline('sun77melobass1').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.011621862824541, \label: 'start', \playDur: 0.011621862824541, \relDur: 0.011621862824541, \sustain: 0, \type: 'start', ),
	(\absTime: 0.011621862824541, \clockTime: 23901.211621863, \dur: 2.7488507374328, \legato: 0.8, \midinote: 38, \playDur: 2.7488507374328, \relDur: 2.7488507374328, \sustain: 2.8195400622317, \velocity: 106, ),
	(\absTime: 2.7604726002573, \clockTime: 23903.9604726, \dur: 0.19896690009773, \legato: 0.8, \midinote: 26, \playDur: 0.19896690009773, \relDur: 0.19896690009773, \sustain: 0.23455957179976, \velocity: 97, ),
	(\absTime: 2.9594395003551, \clockTime: 23904.1594395, \dur: 0.32087317146943, \legato: 0.8, \midinote: 38, \playDur: 0.32087317146943, \relDur: 0.32087317146943, \sustain: 0.38118209769891, \velocity: 99, ),
	(\absTime: 3.2803126718245, \clockTime: 23904.480312672, \dur: 0.36367472162965, \legato: 0.8, \midinote: 26, \playDur: 0.36367472162965, \relDur: 0.36367472162965, \sustain: 0.3890154039982, \velocity: 107, ),
	(\absTime: 3.6439873934542, \clockTime: 23904.843987393, \dur: 0.38946389959892, \legato: 0.8, \midinote: 38, \playDur: 0.38946389959892, \relDur: 0.38946389959892, \sustain: 0.36745206440173, \velocity: 102, ),
	(\absTime: 4.0334512930531, \clockTime: 23905.233451293, \dur: 3.2980635415042, \legato: 0.8, \midinote: 32, \playDur: 3.2980635415042, \relDur: 3.2980635415042, \sustain: 3.3565670773387, \velocity: 127, ),
	(\absTime: 7.3315148345573, \clockTime: 23908.531514835, \dur: 0.31010524500016, \legato: 0.8, \midinote: 38, \playDur: 0.31010524500016, \relDur: 0.31010524500016, \sustain: 0.36101670412972, \velocity: 111, ),
	(\absTime: 7.6416200795575, \clockTime: 23908.84162008, \dur: 0.38134864829772, \legato: 0.8, \midinote: 32, \playDur: 0.38134864829772, \relDur: 0.38134864829772, \sustain: 0.40069974420112, \velocity: 74, ),
	(\absTime: 8.0229687278552, \clockTime: 23909.222968728, \dur: 2.9770312721448, \legato: 0.8, \midinote: 33, \playDur: 2.9770312721448, \relDur: 2.9770312721448, \sustain: 3.0532671217989, \velocity: 93, ),
	(\absTime: 11.0, \clockTime: 23912.183398869, \dur: 0.33473482735644, \legato: 0.8, \midinote: 32, \playDur: 0.33473482735644, \relDur: 0.33473482735644, \sustain: 0.35203288450066, \velocity: 126, ),
	(\absTime: 11.334734827356, \clockTime: 23912.534734827, \dur: 0.31606923786967, \legato: 0.8, \midinote: 33, \playDur: 0.31606923786967, \relDur: 0.31606923786967, \sustain: 0.44873087036467, \velocity: 110, ),
	(\absTime: 11.650804065226, \clockTime: 23912.850804065, \dur: 0.34919593477389, \legato: 0.8, \midinote: 32, \playDur: 0.34919593477389, \relDur: 0.34919593477389, \sustain: 0.24847516386217, \velocity: 95, ),
	(\absTime: 12.0, \clockTime: 23913.166639098, \dur: 1.5, \legato: 0.8, \midinote: 26.0, \playDur: 1.5, \relDur: 1.5, \sustain: 1.5, \velocity: 117, ),
	(\absTime: 13.5, \clockTime: 23914.14084803, \dur: 0.5, \legato: 0.8, \midinote: 38.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, \velocity: 123, ),
	(\absTime: 14.0, \clockTime: 23915.198247183, \dur: 2.0, \legato: 0.8, \midinote: 26.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, \velocity: 118, ),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
NoteTimeline('sun77melobass1').automationRack.paramList = [ Param(Pdef('melobass1'), 'envamt') ];
ParamTimeline('AutomationRack_noteTimeline_sun77melobass1_envamt').param = Param(Pdef('melobass1'), 'envamt');
ParamTimeline('AutomationRack_noteTimeline_sun77melobass1_envamt').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0090072814637097, \level: 0.29834030055321, \next_absTime: 0.0090072814637097, \next_level: 0.28816256770378, \playDur: 0.0090072814637097, \relDur: 0.0090072814637097, \sustain: 0.0090072814637097, ),
	(\absTime: 0.0090072814637097, \dur: 0.023505381101131, \level: 0.28816256770378, \next_absTime: 0.032512662564841, \next_level: 0.27576937890666, \playDur: 0.023505381101131, \relDur: 0.023505381101131, \sustain: 0.023505381101131, ),
	(\absTime: 0.032512662564841, \dur: 0.041335828835145, \level: 0.27576937890666, \next_absTime: 0.073848491399986, \next_level: 0.3981071705535, \playDur: 0.041335828835145, \relDur: 0.041335828835145, \sustain: 0.041335828835145, ),
	(\absTime: 0.073848491399986, \dur: 0.012331733865722, \level: 0.3981071705535, \next_absTime: 0.086180225265707, \next_level: 0.60862458052322, \playDur: 0.012331733865722, \relDur: 0.012331733865722, \sustain: 0.012331733865722, ),
	(\absTime: 0.086180225265707, \dur: 0.0065496035349497, \level: 0.60862458052322, \next_absTime: 0.092729828800657, \next_level: 0.96961222509273, \playDur: 0.0065496035349497, \relDur: 0.0065496035349497, \sustain: 0.0065496035349497, ),
	(\absTime: 0.092729828800657, \dur: 0.011688131497067, \level: 0.96961222509273, \next_absTime: 0.10441796029772, \next_level: 1.4557919874767, \playDur: 0.011688131497067, \relDur: 0.011688131497067, \sustain: 0.011688131497067, ),
	(\absTime: 0.10441796029772, \dur: 0.0053410447690112, \level: 1.4557919874767, \next_absTime: 0.10975900506673, \next_level: 1.8535917800603, \playDur: 0.0053410447690112, \relDur: 0.0053410447690112, \sustain: 0.0053410447690112, ),
	(\absTime: 0.10975900506673, \dur: 0.01058680999995, \level: 1.8535917800603, \next_absTime: 0.12034581506668, \next_level: 2.7327385451467, \playDur: 0.01058680999995, \relDur: 0.01058680999995, \sustain: 0.01058680999995, ),
	(\absTime: 0.12034581506668, \dur: 0.0059299734639353, \level: 2.7327385451467, \next_absTime: 0.12627578853062, \next_level: 3.1622776601684, \playDur: 0.0059299734639353, \relDur: 0.0059299734639353, \sustain: 0.0059299734639353, ),
	(\absTime: 0.12627578853062, \dur: 0.015819484968233, \level: 3.1622776601684, \next_absTime: 0.14209527349885, \next_level: 3.9320879394759, \playDur: 0.015819484968233, \relDur: 0.015819484968233, \sustain: 0.015819484968233, ),
	(\absTime: 0.14209527349885, \dur: 0.0085075087663427, \level: 3.9320879394759, \next_absTime: 0.1506027822652, \next_level: 4.3688027276613, \playDur: 0.0085075087663427, \relDur: 0.0085075087663427, \sustain: 0.0085075087663427, ),
	(\absTime: 0.1506027822652, \dur: 0.43568308506656, \level: 4.3688027276613, \next_absTime: 0.58628586733175, \next_level: 3.9320879394759, \playDur: 0.43568308506656, \relDur: 0.43568308506656, \sustain: 0.43568308506656, ),
	(\absTime: 0.58628586733175, \dur: 0.013323405266419, \level: 3.9320879394759, \next_absTime: 0.59960927259817, \next_level: 3.5288761528294, \playDur: 0.013323405266419, \relDur: 0.013323405266419, \sustain: 0.013323405266419, ),
	(\absTime: 0.59960927259817, \dur: 0.0082792278662964, \level: 3.5288761528294, \next_absTime: 0.60788850046447, \next_level: 3.1622776601684, \playDur: 0.0082792278662964, \relDur: 0.0082792278662964, \sustain: 0.0082792278662964, ),
	(\absTime: 0.60788850046447, \dur: 0.014697908067319, \level: 3.1622776601684, \next_absTime: 0.62258640853179, \next_level: 2.5431781165436, \playDur: 0.014697908067319, \relDur: 0.014697908067319, \sustain: 0.014697908067319, ),
	(\absTime: 0.62258640853179, \dur: 0.0085868408677925, \level: 2.5431781165436, \next_absTime: 0.63117324939958, \next_level: 2.2889566371776, \playDur: 0.0085868408677925, \relDur: 0.0085868408677925, \sustain: 0.0085868408677925, ),
	(\absTime: 0.63117324939958, \dur: 0.012525126334367, \level: 2.2889566371776, \next_absTime: 0.64369837573395, \next_level: 2.0684761215393, \playDur: 0.012525126334367, \relDur: 0.012525126334367, \sustain: 0.012525126334367, ),
	(\absTime: 0.64369837573395, \dur: 0.010869028828893, \level: 2.0684761215393, \next_absTime: 0.65456740456284, \next_level: 1.6364223535703, \playDur: 0.010869028828893, \relDur: 0.010869028828893, \sustain: 0.010869028828893, ),
	(\absTime: 0.65456740456284, \dur: 0.015506997737248, \level: 1.6364223535703, \next_absTime: 0.67007440230009, \next_level: 1.2026184852842, \playDur: 0.015506997737248, \relDur: 0.015506997737248, \sustain: 0.015506997737248, ),
	(\absTime: 0.67007440230009, \dur: 0.0081521237334528, \level: 1.2026184852842, \next_absTime: 0.67822652603354, \next_level: 1.122018454302, \playDur: 0.0081521237334528, \relDur: 0.0081521237334528, \sustain: 0.0081521237334528, ),
	(\absTime: 0.67822652603354, \dur: 0.018934787596663, \level: 1.122018454302, \next_absTime: 0.6971613136302, \next_level: 1.0537483074485, \playDur: 0.018934787596663, \relDur: 0.018934787596663, \sustain: 0.018934787596663, ),
	(\absTime: 0.6971613136302, \dur: 0.0091931409369863, \level: 1.0537483074485, \next_absTime: 0.70635445456719, \next_level: 0.94555309452051, \playDur: 0.0091931409369863, \relDur: 0.0091931409369863, \sustain: 0.0091931409369863, ),
	(\absTime: 0.70635445456719, \dur: 0.017299074665061, \level: 0.94555309452051, \next_absTime: 0.72365352923225, \next_level: 0.81215246224567, \playDur: 0.017299074665061, \relDur: 0.017299074665061, \sustain: 0.017299074665061, ),
	(\absTime: 0.72365352923225, \dur: 0.0084487089989125, \level: 0.81215246224567, \next_absTime: 0.73210223823116, \next_level: 0.78266792380166, \playDur: 0.0084487089989125, \relDur: 0.0084487089989125, \sustain: 0.0084487089989125, ),
	(\absTime: 0.73210223823116, \dur: 0.015509774300881, \level: 0.78266792380166, \next_absTime: 0.74761201253204, \next_level: 0.75678533953167, \playDur: 0.015509774300881, \relDur: 0.015509774300881, \sustain: 0.015509774300881, ),
	(\absTime: 0.74761201253204, \dur: 0.037333198732085, \level: 0.75678533953167, \next_absTime: 0.78494521126413, \next_level: 0.71123191504266, \playDur: 0.037333198732085, \relDur: 0.037333198732085, \sustain: 0.037333198732085, ),
	(\absTime: 0.78494521126413, \dur: 0.01834947970201, \level: 0.71123191504266, \next_absTime: 0.80329469096614, \next_level: 0.69123367838868, \playDur: 0.01834947970201, \relDur: 0.01834947970201, \sustain: 0.01834947970201, ),
	(\absTime: 0.80329469096614, \dur: 0.030996944431536, \level: 0.69123367838868, \next_absTime: 0.83429163539768, \next_level: 0.64938919024829, \playDur: 0.030996944431536, \relDur: 0.030996944431536, \sustain: 0.030996944431536, ),
	(\absTime: 0.83429163539768, \dur: 0.01031555483496, \level: 0.64938919024829, \next_absTime: 0.84460719023264, \next_level: 0.60862458052322, \playDur: 0.01031555483496, \relDur: 0.01031555483496, \sustain: 0.01031555483496, ),
	(\absTime: 0.84460719023264, \dur: 0.019476563233184, \level: 0.60862458052322, \next_absTime: 0.86408375346582, \next_level: 0.55903066125197, \playDur: 0.019476563233184, \relDur: 0.019476563233184, \sustain: 0.019476563233184, ),
	(\absTime: 0.86408375346582, \dur: 0.01145891543274, \level: 0.55903066125197, \next_absTime: 0.87554266889856, \next_level: 0.54999967729685, \playDur: 0.01145891543274, \relDur: 0.01145891543274, \sustain: 0.01145891543274, ),
	(\absTime: 0.87554266889856, \dur: 0.020602589669579, \level: 0.54999967729685, \next_absTime: 0.89614525856814, \next_level: 0.45123556316079, \playDur: 0.020602589669579, \relDur: 0.020602589669579, \sustain: 0.020602589669579, ),
	(\absTime: 0.89614525856814, \dur: 0.018205797794508, \level: 0.45123556316079, \next_absTime: 0.91435105636265, \next_level: 0.42389970070986, \playDur: 0.018205797794508, \relDur: 0.018205797794508, \sustain: 0.018205797794508, ),
	(\absTime: 0.91435105636265, \dur: 0.019179003538738, \level: 0.42389970070986, \next_absTime: 0.93353005990139, \next_level: 0.3981071705535, \playDur: 0.019179003538738, \relDur: 0.019179003538738, \sustain: 0.019179003538738, ),
	(\absTime: 0.93353005990139, \dur: 0.28524677279711, \level: 0.3981071705535, \next_absTime: 1.2187768326985, \next_level: 0.45405235378055, \playDur: 0.28524677279711, \relDur: 0.28524677279711, \sustain: 0.28524677279711, ),
	(\absTime: 1.2187768326985, \dur: 0.018510960766434, \level: 0.45405235378055, \next_absTime: 1.2372877934649, \next_level: 0.71123191504266, \playDur: 0.018510960766434, \relDur: 0.018510960766434, \sustain: 0.018510960766434, ),
	(\absTime: 1.2372877934649, \dur: 0.030398772567423, \level: 0.71123191504266, \next_absTime: 1.2676865660324, \next_level: 1.3364306696902, \playDur: 0.030398772567423, \relDur: 0.030398772567423, \sustain: 0.030398772567423, ),
	(\absTime: 1.2676865660324, \dur: 0.011391370568163, \level: 1.3364306696902, \next_absTime: 1.2790779366005, \next_level: 1.7153371292946, \playDur: 0.011391370568163, \relDur: 0.011391370568163, \sustain: 0.011391370568163, ),
	(\absTime: 1.2790779366005, \dur: 0.01901236406411, \level: 1.7153371292946, \next_absTime: 1.2980903006646, \next_level: 1.8784574000783, \playDur: 0.01901236406411, \relDur: 0.01901236406411, \sustain: 0.01901236406411, ),
	(\absTime: 1.2980903006646, \dur: 0.012165491203632, \level: 1.8784574000783, \next_absTime: 1.3102557918683, \next_level: 2.1905140393794, \playDur: 0.012165491203632, \relDur: 0.012165491203632, \sustain: 0.012165491203632, ),
	(\absTime: 1.3102557918683, \dur: 0.022099450496171, \level: 2.1905140393794, \next_absTime: 1.3323552423644, \next_level: 2.4943163605033, \playDur: 0.022099450496171, \relDur: 0.022099450496171, \sustain: 0.022099450496171, ),
	(\absTime: 1.3323552423644, \dur: 0.014236573300877, \level: 2.4943163605033, \next_absTime: 1.3465918156653, \next_level: 2.6609788555039, \playDur: 0.014236573300877, \relDur: 0.014236573300877, \sustain: 0.014236573300877, ),
	(\absTime: 1.3465918156653, \dur: 0.024888161933632, \level: 2.6609788555039, \next_absTime: 1.3714799775989, \next_level: 2.9783407113981, \playDur: 0.024888161933632, \relDur: 0.024888161933632, \sustain: 0.024888161933632, ),
	(\absTime: 1.3714799775989, \dur: 0.012582531100634, \level: 2.9783407113981, \next_absTime: 1.3840625086996, \next_level: 3.0728853527758, \playDur: 0.012582531100634, \relDur: 0.012582531100634, \sustain: 0.012582531100634, ),
	(\absTime: 1.3840625086996, \dur: 0.023067127898685, \level: 3.0728853527758, \next_absTime: 1.4071296365983, \next_level: 3.1622776601684, \playDur: 0.023067127898685, \relDur: 0.023067127898685, \sustain: 0.023067127898685, ),
	(\absTime: 1.4071296365983, \dur: 0.22505059046671, \level: 3.1622776601684, \next_absTime: 1.632180227065, \next_level: 3.2542704500728, \playDur: 0.22505059046671, \relDur: 0.22505059046671, \sustain: 0.22505059046671, ),
	(\absTime: 1.632180227065, \dur: 0.020728320498165, \level: 3.2542704500728, \next_absTime: 1.6529085475631, \next_level: 3.2656663429062, \playDur: 0.020728320498165, \relDur: 0.020728320498165, \sustain: 0.020728320498165, ),
	(\absTime: 1.6529085475631, \dur: 0.030051041438128, \level: 3.2656663429062, \next_absTime: 1.6829595890013, \next_level: 2.3231380735858, \playDur: 0.030051041438128, \relDur: 0.030051041438128, \sustain: 0.030051041438128, ),
	(\absTime: 1.6829595890013, \dur: 0.015931870297209, \level: 2.3231380735858, \next_absTime: 1.6988914592985, \next_level: 1.0537483074485, \playDur: 0.015931870297209, \relDur: 0.015931870297209, \sustain: 0.015931870297209, ),
	(\absTime: 1.6988914592985, \dur: 0.026481726232305, \level: 1.0537483074485, \next_absTime: 1.7253731855308, \next_level: 0.49502054284156, \playDur: 0.026481726232305, \relDur: 0.026481726232305, \sustain: 0.026481726232305, ),
	(\absTime: 1.7253731855308, \dur: 0.016688950232492, \level: 0.49502054284156, \next_absTime: 1.7420621357633, \next_level: 0.46068271479173, \playDur: 0.016688950232492, \relDur: 0.016688950232492, \sustain: 0.016688950232492, ),
	(\absTime: 1.7420621357633, \dur: 0.32823179853222, \level: 0.46068271479173, \next_absTime: 2.0702939342955, \next_level: 0.49502054284156, \playDur: 0.32823179853222, \relDur: 0.32823179853222, \sustain: 0.32823179853222, ),
	(\absTime: 2.0702939342955, \dur: 0.026988644436642, \level: 0.49502054284156, \next_absTime: 2.0972825787321, \next_level: 0.78266792380166, \playDur: 0.026988644436642, \relDur: 0.026988644436642, \sustain: 0.026988644436642, ),
	(\absTime: 2.0972825787321, \dur: 0.034731044266664, \level: 0.78266792380166, \next_absTime: 2.1320136229988, \next_level: 1.4054780593825, \playDur: 0.034731044266664, \relDur: 0.034731044266664, \sustain: 0.034731044266664, ),
	(\absTime: 2.1320136229988, \dur: 0.026477029732632, \level: 1.4054780593825, \next_absTime: 2.1584906527314, \next_level: 1.6731706830703, \playDur: 0.026477029732632, \relDur: 0.026477029732632, \sustain: 0.026477029732632, ),
	(\absTime: 2.1584906527314, \dur: 0.015481167498365, \level: 1.6731706830703, \next_absTime: 2.1739718202298, \next_level: 2.1016156012194, \playDur: 0.015481167498365, \relDur: 0.015481167498365, \sustain: 0.015481167498365, ),
	(\absTime: 2.1739718202298, \dur: 0.026144211667997, \level: 2.1016156012194, \next_absTime: 2.2001160318978, \next_level: 2.5932448145784, \playDur: 0.026144211667997, \relDur: 0.026144211667997, \sustain: 0.026144211667997, ),
	(\absTime: 2.2001160318978, \dur: 0.016240380235104, \level: 2.5932448145784, \next_absTime: 2.2163564121329, \next_level: 2.850100113375, \playDur: 0.016240380235104, \relDur: 0.016240380235104, \sustain: 0.016240380235104, ),
	(\absTime: 2.2163564121329, \dur: 0.02959800742974, \level: 2.850100113375, \next_absTime: 2.2459544195626, \next_level: 3.2503856669661, \playDur: 0.02959800742974, \relDur: 0.02959800742974, \sustain: 0.02959800742974, ),
	(\absTime: 2.2459544195626, \dur: 0.017281187669141, \level: 3.2503856669661, \next_absTime: 2.2632356072318, \next_level: 3.3301011537961, \playDur: 0.017281187669141, \relDur: 0.017281187669141, \sustain: 0.017281187669141, ),
	(\absTime: 2.2632356072318, \dur: 0.031282051433664, \level: 3.3301011537961, \next_absTime: 2.2945176586654, \next_level: 3.32679455209, \playDur: 0.031282051433664, \relDur: 0.031282051433664, \sustain: 0.031282051433664, ),
	(\absTime: 2.2945176586654, \dur: 0.031607181499567, \level: 3.32679455209, \next_absTime: 2.326124840165, \next_level: 3.3236156469872, \playDur: 0.031607181499567, \relDur: 0.031607181499567, \sustain: 0.031607181499567, ),
	(\absTime: 2.326124840165, \dur: 0.020387145865243, \level: 3.3236156469872, \next_absTime: 2.3465119860302, \next_level: 3.4171544339899, \playDur: 0.020387145865243, \relDur: 0.020387145865243, \sustain: 0.020387145865243, ),
	(\absTime: 2.3465119860302, \dur: 0.033244893933443, \level: 3.4171544339899, \next_absTime: 2.3797568799637, \next_level: 3.6744980184774, \playDur: 0.033244893933443, \relDur: 0.033244893933443, \sustain: 0.033244893933443, ),
	(\absTime: 2.3797568799637, \dur: 0.031314499134169, \level: 3.6744980184774, \next_absTime: 2.4110713790978, \next_level: 2.8964047541389, \playDur: 0.031314499134169, \relDur: 0.031314499134169, \sustain: 0.031314499134169, ),
	(\absTime: 2.4110713790978, \dur: 0.015912277267489, \level: 2.8964047541389, \next_absTime: 2.4269836563653, \next_level: 1.9698789882163, \playDur: 0.015912277267489, \relDur: 0.015912277267489, \sustain: 0.015912277267489, ),
	(\absTime: 2.4269836563653, \dur: 0.029656347367563, \level: 1.9698789882163, \next_absTime: 2.4566400037329, \next_level: 0.34403139982746, \playDur: 0.029656347367563, \relDur: 0.029656347367563, \sustain: 0.029656347367563, ),
	(\absTime: 2.4566400037329, \dur: 0.019292884098832, \level: 0.34403139982746, \next_absTime: 2.4759328878317, \next_level: 0.21594815018631, \playDur: 0.019292884098832, \relDur: 0.019292884098832, \sustain: 0.019292884098832, ),
	(\absTime: 2.4759328878317, \dur: 0.065404662833316, \level: 0.21594815018631, \next_absTime: 2.541337550665, \next_level: 0.23648377559313, \playDur: 0.065404662833316, \relDur: 0.065404662833316, \sustain: 0.065404662833316, ),
	(\absTime: 2.541337550665, \dur: 0.016314266667905, \level: 0.23648377559313, \next_absTime: 2.557651817333, \next_level: 0.29515750604194, \playDur: 0.016314266667905, \relDur: 0.016314266667905, \sustain: 0.016314266667905, ),
	(\absTime: 2.557651817333, \dur: 0.033481243099232, \level: 0.29515750604194, \next_absTime: 2.5911330604322, \next_level: 1.3723396858745, \playDur: 0.033481243099232, \relDur: 0.033481243099232, \sustain: 0.033481243099232, ),
	(\absTime: 2.5911330604322, \dur: 0.034158880363975, \level: 1.3723396858745, \next_absTime: 2.6252919407962, \next_level: 2.4160521724543, \playDur: 0.034158880363975, \relDur: 0.034158880363975, \sustain: 0.034158880363975, ),
	(\absTime: 2.6252919407962, \dur: 0.021708669668442, \level: 2.4160521724543, \next_absTime: 2.6470006104646, \next_level: 2.850100113375, \playDur: 0.021708669668442, \relDur: 0.021708669668442, \sustain: 0.021708669668442, ),
	(\absTime: 2.6470006104646, \dur: 0.030539714065526, \level: 2.850100113375, \next_absTime: 2.6775403245301, \next_level: 3.076557991758, \playDur: 0.030539714065526, \relDur: 0.030539714065526, \sustain: 0.030539714065526, ),
	(\absTime: 2.6775403245301, \dur: 0.019087790165941, \level: 3.076557991758, \next_absTime: 2.6966281146961, \next_level: 3.2419718672526, \playDur: 0.019087790165941, \relDur: 0.019087790165941, \sustain: 0.019087790165941, ),
	(\absTime: 2.6966281146961, \dur: 0.034749506834487, \level: 3.2419718672526, \next_absTime: 2.7313776215306, \next_level: 3.4576835599895, \playDur: 0.034749506834487, \relDur: 0.034749506834487, \sustain: 0.034749506834487, ),
	(\absTime: 2.7313776215306, \dur: 0.032473556067998, \level: 3.4576835599895, \next_absTime: 2.7638511775986, \next_level: 3.452556133845, \playDur: 0.032473556067998, \relDur: 0.032473556067998, \sustain: 0.032473556067998, ),
	(\absTime: 2.7638511775986, \dur: 0.036957190430257, \level: 3.452556133845, \next_absTime: 2.8008083680288, \next_level: 3.5288761528294, \playDur: 0.036957190430257, \relDur: 0.036957190430257, \sustain: 0.036957190430257, ),
	(\absTime: 2.8008083680288, \dur: 0.021269971100992, \level: 3.5288761528294, \next_absTime: 2.8220783391298, \next_level: 3.715460731018, \playDur: 0.021269971100992, \relDur: 0.021269971100992, \sustain: 0.021269971100992, ),
	(\absTime: 2.8220783391298, \dur: 0.03642818886874, \level: 3.715460731018, \next_absTime: 2.8585065279985, \next_level: 4.05361948327, \playDur: 0.03642818886874, \relDur: 0.03642818886874, \sustain: 0.03642818886874, ),
	(\absTime: 2.8585065279985, \dur: 0.021790077735204, \level: 4.05361948327, \next_absTime: 2.8802966057337, \next_level: 4.4192090960338, \playDur: 0.021790077735204, \relDur: 0.021790077735204, \sustain: 0.021790077735204, ),
	(\absTime: 2.8802966057337, \dur: 0.032953752262983, \level: 4.4192090960338, \next_absTime: 2.9132503579967, \next_level: 4.3688027276613, \playDur: 0.032953752262983, \relDur: 0.032953752262983, \sustain: 0.032953752262983, ),
	(\absTime: 2.9132503579967, \dur: 0.020001900600619, \level: 4.3688027276613, \next_absTime: 2.9332522585973, \next_level: 1.7153371292946, \playDur: 0.020001900600619, \relDur: 0.020001900600619, \sustain: 0.020001900600619, ),
	(\absTime: 2.9332522585973, \dur: 0.03638051190137, \level: 1.7153371292946, \next_absTime: 2.9696327704987, \next_level: 0.12066248518456, \playDur: 0.03638051190137, \relDur: 0.03638051190137, \sustain: 0.03638051190137, ),
	(\absTime: 2.9696327704987, \dur: 0.038722016299289, \level: 0.12066248518456, \next_absTime: 3.008354786798, \next_level: 0.24098272173845, \playDur: 0.038722016299289, \relDur: 0.038722016299289, \sustain: 0.038722016299289, ),
	(\absTime: 3.008354786798, \dur: 0.023789804032276, \level: 0.24098272173845, \next_absTime: 3.0321445908303, \next_level: 0.54001422380256, \playDur: 0.023789804032276, \relDur: 0.023789804032276, \sustain: 0.023789804032276, ),
	(\absTime: 3.0321445908303, \dur: 0.038472370200907, \level: 0.54001422380256, \next_absTime: 3.0706169610312, \next_level: 1.2416152941127, \playDur: 0.038472370200907, \relDur: 0.038472370200907, \sustain: 0.038472370200907, ),
	(\absTime: 3.0706169610312, \dur: 0.021090190733958, \level: 1.2416152941127, \next_absTime: 3.0917071517651, \next_level: 1.488153524562, \playDur: 0.021090190733958, \relDur: 0.021090190733958, \sustain: 0.021090190733958, ),
	(\absTime: 3.0917071517651, \dur: 0.036218475932401, \level: 1.488153524562, \next_absTime: 3.1279256276976, \next_level: 1.7641610958869, \playDur: 0.036218475932401, \relDur: 0.036218475932401, \sustain: 0.036218475932401, ),
	(\absTime: 3.1279256276976, \dur: 0.022806300097727, \level: 1.7641610958869, \next_absTime: 3.1507319277953, \next_level: 1.9038719289785, \playDur: 0.022806300097727, \relDur: 0.022806300097727, \sustain: 0.022806300097727, ),
	(\absTime: 3.1507319277953, \dur: 0.036108339136263, \level: 1.9038719289785, \next_absTime: 3.1868402669315, \next_level: 2.1037577172342, \playDur: 0.036108339136263, \relDur: 0.036108339136263, \sustain: 0.036108339136263, ),
	(\absTime: 3.1868402669315, \dur: 0.025729883232998, \level: 2.1037577172342, \next_absTime: 3.2125701501645, \next_level: 2.2351934617733, \playDur: 0.025729883232998, \relDur: 0.025729883232998, \sustain: 0.025729883232998, ),
	(\absTime: 3.2125701501645, \dur: 0.042576995467243, \level: 2.2351934617733, \next_absTime: 3.2551471456318, \next_level: 2.3936047015374, \playDur: 0.042576995467243, \relDur: 0.042576995467243, \sustain: 0.042576995467243, ),
	(\absTime: 3.2551471456318, \dur: 0.050866883200797, \level: 2.3936047015374, \next_absTime: 3.3060140288326, \next_level: 2.4483279733993, \playDur: 0.050866883200797, \relDur: 0.050866883200797, \sustain: 0.050866883200797, ),
	(\absTime: 3.3060140288326, \dur: 0.025445809566008, \level: 2.4483279733993, \next_absTime: 3.3314598383986, \next_level: 2.5854632995436, \playDur: 0.025445809566008, \relDur: 0.025445809566008, \sustain: 0.025445809566008, ),
	(\absTime: 3.3314598383986, \dur: 0.040341884101508, \level: 2.5854632995436, \next_absTime: 3.3718017225001, \next_level: 2.8846350026727, \playDur: 0.040341884101508, \relDur: 0.040341884101508, \sustain: 0.040341884101508, ),
	(\absTime: 3.3718017225001, \dur: 0.023364174030576, \level: 2.8846350026727, \next_absTime: 3.3951658965307, \next_level: 3.0515354742047, \playDur: 0.023364174030576, \relDur: 0.023364174030576, \sustain: 0.023364174030576, ),
	(\absTime: 3.3951658965307, \dur: 0.042448214233445, \level: 3.0515354742047, \next_absTime: 3.4376141107641, \next_level: 3.2873567962035, \playDur: 0.042448214233445, \relDur: 0.042448214233445, \sustain: 0.042448214233445, ),
	(\absTime: 3.4376141107641, \dur: 0.11641312406937, \level: 3.2873567962035, \next_absTime: 3.5540272348335, \next_level: 3.4251712703437, \playDur: 0.11641312406937, \relDur: 0.11641312406937, \sustain: 0.11641312406937, ),
	(\absTime: 3.5540272348335, \dur: 0.041042787899642, \level: 3.4251712703437, \next_absTime: 3.5950700227331, \next_level: 4.322194873085, \playDur: 0.041042787899642, \relDur: 0.041042787899642, \sustain: 0.041042787899642, ),
	(\absTime: 3.5950700227331, \dur: 0.042229875030898, \level: 4.322194873085, \next_absTime: 3.637299897764, \next_level: 9.3271581381134, \playDur: 0.042229875030898, \relDur: 0.042229875030898, \sustain: 0.042229875030898, ),
	(\absTime: 3.637299897764, \dur: 0.025686125700304, \level: 9.3271581381134, \next_absTime: 3.6629860234643, \next_level: 27.027028599359, \playDur: 0.025686125700304, \relDur: 0.025686125700304, \sustain: 0.025686125700304, ),
	(\absTime: 3.6629860234643, \dur: 0.047629632765165, \level: 27.027028599359, \next_absTime: 3.7106156562295, \next_level: 39.165210240131, \playDur: 0.047629632765165, \relDur: 0.047629632765165, \sustain: 0.047629632765165, ),
	(\absTime: 3.7106156562295, \dur: 0.028622816669667, \level: 39.165210240131, \next_absTime: 3.7392384728992, \next_level: 43.881094681187, \playDur: 0.028622816669667, \relDur: 0.028622816669667, \sustain: 0.028622816669667, ),
	(\absTime: 3.7392384728992, \dur: 0.046999394497107, \level: 43.881094681187, \next_absTime: 3.7862378673963, \next_level: 51.243356089158, \playDur: 0.046999394497107, \relDur: 0.046999394497107, \sustain: 0.046999394497107, ),
	(\absTime: 3.7862378673963, \dur: 0.12340772536845, \level: 51.243356089158, \next_absTime: 3.9096455927647, \next_level: 52.814897727643, \playDur: 0.12340772536845, \relDur: 0.12340772536845, \sustain: 0.12340772536845, ),
	(\absTime: 3.9096455927647, \dur: 0.045988770732947, \level: 52.814897727643, \next_absTime: 3.9556343634977, \next_level: 52.487251571283, \playDur: 0.045988770732947, \relDur: 0.045988770732947, \sustain: 0.045988770732947, ),
	(\absTime: 3.9556343634977, \dur: 0.043236393368716, \level: 52.487251571283, \next_absTime: 3.9988707568664, \next_level: 42.853461224263, \playDur: 0.043236393368716, \relDur: 0.043236393368716, \sustain: 0.043236393368716, ),
	(\absTime: 3.9988707568664, \dur: 0.04513782693175, \level: 42.853461224263, \next_absTime: 4.0440085837981, \next_level: 13.625407138696, \playDur: 0.04513782693175, \relDur: 0.04513782693175, \sustain: 0.04513782693175, ),
	(\absTime: 4.0440085837981, \dur: 0.026845784032048, \level: 13.625407138696, \next_absTime: 4.0708543678302, \next_level: 11.820823621641, \playDur: 0.026845784032048, \relDur: 0.026845784032048, \sustain: 0.026845784032048, ),
	(\absTime: 4.0708543678302, \dur: 0.14053758033697, \level: 11.820823621641, \next_absTime: 4.2113919481671, \next_level: 11.08212953285, \playDur: 0.14053758033697, \relDur: 0.14053758033697, \sustain: 0.14053758033697, ),
	(\absTime: 4.2113919481671, \dur: 0.04619977843322, \level: 11.08212953285, \next_absTime: 4.2575917266004, \next_level: 9.3586016951148, \playDur: 0.04619977843322, \relDur: 0.04619977843322, \sustain: 0.04619977843322, ),
	(\absTime: 4.2575917266004, \dur: 0.24292372622949, \level: 9.3586016951148, \next_absTime: 4.5005154528299, \next_level: 8.9125093813375, \playDur: 0.24292372622949, \relDur: 0.24292372622949, \sustain: 0.24292372622949, ),
	(\absTime: 4.5005154528299, \dur: 0.031828450202738, \level: 8.9125093813375, \next_absTime: 4.5323439030326, \next_level: 6.9791646993171, \playDur: 0.031828450202738, \relDur: 0.031828450202738, \sustain: 0.031828450202738, ),
	(\absTime: 4.5323439030326, \dur: 0.052623981799115, \level: 6.9791646993171, \next_absTime: 4.5849678848317, \next_level: 6.2338864884221, \playDur: 0.052623981799115, \relDur: 0.052623981799115, \sustain: 0.052623981799115, ),
	(\absTime: 4.5849678848317, \dur: 0.049105263766251, \level: 6.2338864884221, \next_absTime: 4.634073148598, \next_level: 5.5943728258036, \playDur: 0.049105263766251, \relDur: 0.049105263766251, \sustain: 0.049105263766251, ),
	(\absTime: 4.634073148598, \dur: 0.047422640600416, \level: 5.5943728258036, \next_absTime: 4.6814957891984, \next_level: 5.394931131856, \playDur: 0.047422640600416, \relDur: 0.047422640600416, \sustain: 0.047422640600416, ),
	(\absTime: 4.6814957891984, \dur: 0.032220113502262, \level: 5.394931131856, \next_absTime: 4.7137159027006, \next_level: 5.1476925232363, \playDur: 0.032220113502262, \relDur: 0.032220113502262, \sustain: 0.032220113502262, ),
	(\absTime: 4.7137159027006, \dur: 0.047034665265528, \level: 5.1476925232363, \next_absTime: 4.7607505679662, \next_level: 4.6763631858627, \playDur: 0.047034665265528, \relDur: 0.047034665265528, \sustain: 0.047034665265528, ),
	(\absTime: 4.7607505679662, \dur: 0.030592552531743, \level: 4.6763631858627, \next_absTime: 4.7913431204979, \next_level: 4.479608634505, \playDur: 0.030592552531743, \relDur: 0.030592552531743, \sustain: 0.030592552531743, ),
	(\absTime: 4.7913431204979, \dur: 0.050549517600302, \level: 4.479608634505, \next_absTime: 4.8418926380982, \next_level: 4.3045224533576, \playDur: 0.050549517600302, \relDur: 0.050549517600302, \sustain: 0.050549517600302, ),
	(\absTime: 4.8418926380982, \dur: 0.050718394231808, \level: 4.3045224533576, \next_absTime: 4.89261103233, \next_level: 4.2197631679654, \playDur: 0.050718394231808, \relDur: 0.050718394231808, \sustain: 0.050718394231808, ),
	(\absTime: 4.89261103233, \dur: 0.027068600666098, \level: 4.2197631679654, \next_absTime: 4.9196796329961, \next_level: 4.1697957644855, \playDur: 0.027068600666098, \relDur: 0.027068600666098, \sustain: 0.027068600666098, ),
	(\absTime: 4.9196796329961, \dur: 0.05551255973478, \level: 4.1697957644855, \next_absTime: 4.9751921927309, \next_level: 4.0826037497141, \playDur: 0.05551255973478, \relDur: 0.05551255973478, \sustain: 0.05551255973478, ),
	(\absTime: 4.9751921927309, \dur: 0.066886464901472, \level: 4.0826037497141, \next_absTime: 5.0420786576324, \next_level: 4.1851842481221, \playDur: 0.066886464901472, \relDur: 0.066886464901472, \sustain: 0.066886464901472, ),
	(\absTime: 5.0420786576324, \dur: 0.027877486765647, \level: 4.1851842481221, \next_absTime: 5.069956144398, \next_level: 4.3147668438741, \playDur: 0.027877486765647, \relDur: 0.027877486765647, \sustain: 0.027877486765647, ),
	(\absTime: 5.069956144398, \dur: 0.04826152953683, \level: 4.3147668438741, \next_absTime: 5.1182176739349, \next_level: 4.7156356942575, \playDur: 0.04826152953683, \relDur: 0.04826152953683, \sustain: 0.04826152953683, ),
	(\absTime: 5.1182176739349, \dur: 0.048749139896245, \level: 4.7156356942575, \next_absTime: 5.1669668138311, \next_level: 5.0445867040465, \playDur: 0.048749139896245, \relDur: 0.048749139896245, \sustain: 0.048749139896245, ),
	(\absTime: 5.1669668138311, \dur: 0.033622331335209, \level: 5.0445867040465, \next_absTime: 5.2005891451663, \next_level: 5.3568010433169, \playDur: 0.033622331335209, \relDur: 0.033622331335209, \sustain: 0.033622331335209, ),
	(\absTime: 5.2005891451663, \dur: 0.053855772999668, \level: 5.3568010433169, \next_absTime: 5.254444918166, \next_level: 5.9766765585742, \playDur: 0.053855772999668, \relDur: 0.053855772999668, \sustain: 0.053855772999668, ),
	(\absTime: 5.254444918166, \dur: 0.030837326467008, \level: 5.9766765585742, \next_absTime: 5.285282244633, \next_level: 6.2949026530193, \playDur: 0.030837326467008, \relDur: 0.030837326467008, \sustain: 0.030837326467008, ),
	(\absTime: 5.285282244633, \dur: 0.051392520232184, \level: 6.2949026530193, \next_absTime: 5.3366747648652, \next_level: 7.3463353284277, \playDur: 0.051392520232184, \relDur: 0.051392520232184, \sustain: 0.051392520232184, ),
	(\absTime: 5.3366747648652, \dur: 0.027746128398576, \level: 7.3463353284277, \next_absTime: 5.3644208932637, \next_level: 8.0009397790946, \playDur: 0.027746128398576, \relDur: 0.027746128398576, \sustain: 0.027746128398576, ),
	(\absTime: 5.3644208932637, \dur: 0.061280912635993, \level: 8.0009397790946, \next_absTime: 5.4257018058997, \next_level: 10.210838592198, \playDur: 0.061280912635993, \relDur: 0.061280912635993, \sustain: 0.061280912635993, ),
	(\absTime: 5.4257018058997, \dur: 0.033411175863876, \level: 10.210838592198, \next_absTime: 5.4591129817636, \next_level: 11.16410905853, \playDur: 0.033411175863876, \relDur: 0.033411175863876, \sustain: 0.033411175863876, ),
	(\absTime: 5.4591129817636, \dur: 0.055340388833429, \level: 11.16410905853, \next_absTime: 5.514453370597, \next_level: 12.712226233062, \playDur: 0.055340388833429, \relDur: 0.055340388833429, \sustain: 0.055340388833429, ),
	(\absTime: 5.514453370597, \dur: 0.029576313634607, \level: 12.712226233062, \next_absTime: 5.5440296842316, \next_level: 13.625407138696, \playDur: 0.029576313634607, \relDur: 0.029576313634607, \sustain: 0.029576313634607, ),
	(\absTime: 5.5440296842316, \dur: 0.056590649834106, \level: 13.625407138696, \next_absTime: 5.6006203340658, \next_level: 16.273029523238, \playDur: 0.056590649834106, \relDur: 0.056590649834106, \sustain: 0.056590649834106, ),
	(\absTime: 5.6006203340658, \dur: 0.035370290097489, \level: 16.273029523238, \next_absTime: 5.6359906241632, \next_level: 17.915794348334, \playDur: 0.035370290097489, \relDur: 0.035370290097489, \sustain: 0.035370290097489, ),
	(\absTime: 5.6359906241632, \dur: 0.053517382169957, \level: 17.915794348334, \next_absTime: 5.6895080063332, \next_level: 21.168297003418, \playDur: 0.053517382169957, \relDur: 0.053517382169957, \sustain: 0.053517382169957, ),
	(\absTime: 5.6895080063332, \dur: 0.034592520762089, \level: 21.168297003418, \next_absTime: 5.7241005270953, \next_level: 23.748354191795, \playDur: 0.034592520762089, \relDur: 0.034592520762089, \sustain: 0.034592520762089, ),
	(\absTime: 5.7241005270953, \dur: 0.053685245100496, \level: 23.748354191795, \next_absTime: 5.7777857721958, \next_level: 28.030859650376, \playDur: 0.053685245100496, \relDur: 0.053685245100496, \sustain: 0.053685245100496, ),
	(\absTime: 5.7777857721958, \dur: 0.036527162570565, \level: 28.030859650376, \next_absTime: 5.8143129347663, \next_level: 30.290122069081, \playDur: 0.036527162570565, \relDur: 0.036527162570565, \sustain: 0.036527162570565, ),
	(\absTime: 5.8143129347663, \dur: 0.057664612799272, \level: 30.290122069081, \next_absTime: 5.8719775475656, \next_level: 32.591122957225, \playDur: 0.057664612799272, \relDur: 0.057664612799272, \sustain: 0.057664612799272, ),
	(\absTime: 5.8719775475656, \dur: 0.032523683068575, \level: 32.591122957225, \next_absTime: 5.9045012306342, \next_level: 35.135178315646, \playDur: 0.032523683068575, \relDur: 0.032523683068575, \sustain: 0.032523683068575, ),
	(\absTime: 5.9045012306342, \dur: 0.058248687932064, \level: 35.135178315646, \next_absTime: 5.9627499185663, \next_level: 41.496751002976, \playDur: 0.058248687932064, \relDur: 0.058248687932064, \sustain: 0.058248687932064, ),
	(\absTime: 5.9627499185663, \dur: 0.036188017398672, \level: 41.496751002976, \next_absTime: 5.9989379359649, \next_level: 44.363346810616, \playDur: 0.036188017398672, \relDur: 0.036188017398672, \sustain: 0.036188017398672, ),
	(\absTime: 5.9989379359649, \dur: 0.058219652299158, \level: 44.363346810616, \next_absTime: 6.0571575882641, \next_level: 42.708371241737, \playDur: 0.058219652299158, \relDur: 0.058219652299158, \sustain: 0.058219652299158, ),
	(\absTime: 6.0571575882641, \dur: 0.036253549333196, \level: 42.708371241737, \next_absTime: 6.0934111375973, \next_level: 30.931061752596, \playDur: 0.036253549333196, \relDur: 0.036253549333196, \sustain: 0.036253549333196, ),
	(\absTime: 6.0934111375973, \dur: 0.05599120179977, \level: 30.931061752596, \next_absTime: 6.1494023393971, \next_level: 22.287210293507, \playDur: 0.05599120179977, \relDur: 0.05599120179977, \sustain: 0.05599120179977, ),
	(\absTime: 6.1494023393971, \dur: 0.034869425169745, \level: 22.287210293507, \next_absTime: 6.1842717645668, \next_level: 17.052415301899, \playDur: 0.034869425169745, \relDur: 0.034869425169745, \sustain: 0.034869425169745, ),
	(\absTime: 6.1842717645668, \dur: 0.062450819565129, \level: 17.052415301899, \next_absTime: 6.2467225841319, \next_level: 13.975474090047, \playDur: 0.062450819565129, \relDur: 0.062450819565129, \sustain: 0.062450819565129, ),
	(\absTime: 6.2467225841319, \dur: 0.056752584536298, \level: 13.975474090047, \next_absTime: 6.3034751686682, \next_level: 11.820823621641, \playDur: 0.056752584536298, \relDur: 0.056752584536298, \sustain: 0.056752584536298, ),
	(\absTime: 6.3034751686682, \dur: 0.034744338096061, \level: 11.820823621641, \next_absTime: 6.3382195067643, \next_level: 10.692312101306, \playDur: 0.034744338096061, \relDur: 0.034744338096061, \sustain: 0.034744338096061, ),
	(\absTime: 6.3382195067643, \dur: 0.061230795967276, \level: 10.692312101306, \next_absTime: 6.3994503027316, \next_level: 10.478134343835, \playDur: 0.061230795967276, \relDur: 0.061230795967276, \sustain: 0.061230795967276, ),
	(\absTime: 6.3994503027316, \dur: 0.036529462766339, \level: 10.478134343835, \next_absTime: 6.4359797654979, \next_level: 10.856539549382, \playDur: 0.036529462766339, \relDur: 0.036529462766339, \sustain: 0.036529462766339, ),
	(\absTime: 6.4359797654979, \dur: 0.060253452767938, \level: 10.856539549382, \next_absTime: 6.4962332182658, \next_level: 15.503945486832, \playDur: 0.060253452767938, \relDur: 0.060253452767938, \sustain: 0.060253452767938, ),
	(\absTime: 6.4962332182658, \dur: 0.034621350765519, \level: 15.503945486832, \next_absTime: 6.5308545690314, \next_level: 19.35979147783, \playDur: 0.034621350765519, \relDur: 0.034621350765519, \sustain: 0.034621350765519, ),
	(\absTime: 6.5308545690314, \dur: 0.064075501668412, \level: 19.35979147783, \next_absTime: 6.5949300706998, \next_level: 23.876684366495, \playDur: 0.064075501668412, \relDur: 0.064075501668412, \sustain: 0.064075501668412, ),
	(\absTime: 6.5949300706998, \dur: 0.037051399434858, \level: 23.876684366495, \next_absTime: 6.6319814701346, \next_level: 26.400417497734, \playDur: 0.037051399434858, \relDur: 0.037051399434858, \sustain: 0.037051399434858, ),
	(\absTime: 6.6319814701346, \dur: 0.062661899599334, \level: 26.400417497734, \next_absTime: 6.694643369734, \next_level: 27.743437797826, \playDur: 0.062661899599334, \relDur: 0.062661899599334, \sustain: 0.062661899599334, ),
	(\absTime: 6.694643369734, \dur: 0.059473312965565, \level: 27.743437797826, \next_absTime: 6.7541166826995, \next_level: 30.497882734765, \playDur: 0.059473312965565, \relDur: 0.059473312965565, \sustain: 0.059473312965565, ),
	(\absTime: 6.7541166826995, \dur: 0.1066380335651, \level: 30.497882734765, \next_absTime: 6.8607547162646, \next_level: 30.608088951076, \playDur: 0.1066380335651, \relDur: 0.1066380335651, \sustain: 0.1066380335651, ),
	(\absTime: 6.8607547162646, \dur: 0.035993753834191, \level: 30.608088951076, \next_absTime: 6.8967484700988, \next_level: 27.908674634111, \playDur: 0.035993753834191, \relDur: 0.035993753834191, \sustain: 0.035993753834191, ),
	(\absTime: 6.8967484700988, \dur: 0.063507317132462, \level: 27.908674634111, \next_absTime: 6.9602557872313, \next_level: 21.388948063835, \playDur: 0.063507317132462, \relDur: 0.063507317132462, \sustain: 0.063507317132462, ),
	(\absTime: 6.9602557872313, \dur: 0.039659214500716, \level: 21.388948063835, \next_absTime: 6.999915001732, \next_level: 16.710741538182, \playDur: 0.039659214500716, \relDur: 0.039659214500716, \sustain: 0.039659214500716, ),
	(\absTime: 6.999915001732, \dur: 0.068062780566834, \level: 16.710741538182, \next_absTime: 7.0679777822988, \next_level: 11.333779353158, \playDur: 0.068062780566834, \relDur: 0.068062780566834, \sustain: 0.068062780566834, ),
	(\absTime: 7.0679777822988, \dur: 0.036050337101187, \level: 11.333779353158, \next_absTime: 7.1040281194, \next_level: 9.6676951150728, \playDur: 0.036050337101187, \relDur: 0.036050337101187, \sustain: 0.036050337101187, ),
	(\absTime: 7.1040281194, \dur: 0.065160859197931, \level: 9.6676951150728, \next_absTime: 7.169188978598, \next_level: 8.7752526872934, \playDur: 0.065160859197931, \relDur: 0.065160859197931, \sustain: 0.065160859197931, ),
	(\absTime: 7.169188978598, \dur: 0.071771486233047, \level: 8.7752526872934, \next_absTime: 7.240960464831, \next_level: 8.9125093813375, \playDur: 0.071771486233047, \relDur: 0.071771486233047, \sustain: 0.071771486233047, ),
	(\absTime: 7.240960464831, \dur: 0.037232069502352, \level: 8.9125093813375, \next_absTime: 7.2781925343334, \next_level: 10.072689733617, \playDur: 0.037232069502352, \relDur: 0.037232069502352, \sustain: 0.037232069502352, ),
	(\absTime: 7.2781925343334, \dur: 0.062099474864226, \level: 10.072689733617, \next_absTime: 7.3402920091976, \next_level: 17.521752254942, \playDur: 0.062099474864226, \relDur: 0.062099474864226, \sustain: 0.062099474864226, ),
	(\absTime: 7.3402920091976, \dur: 0.038606963935308, \level: 17.521752254942, \next_absTime: 7.3788989731329, \next_level: 19.948957357214, \playDur: 0.038606963935308, \relDur: 0.038606963935308, \sustain: 0.038606963935308, ),
	(\absTime: 7.3788989731329, \dur: 0.069348431166873, \level: 19.948957357214, \next_absTime: 7.4482474042998, \next_level: 23.279912479428, \playDur: 0.069348431166873, \relDur: 0.069348431166873, \sustain: 0.069348431166873, ),
	(\absTime: 7.4482474042998, \dur: 0.090335154232889, \level: 23.279912479428, \next_absTime: 7.5385825585327, \next_level: 22.654471750853, \playDur: 0.090335154232889, \relDur: 0.090335154232889, \sustain: 0.090335154232889, ),
	(\absTime: 7.5385825585327, \dur: 0.038372082100977, \level: 22.654471750853, \next_absTime: 7.5769546406336, \next_level: 21.96527170268, \playDur: 0.038372082100977, \relDur: 0.038372082100977, \sustain: 0.038372082100977, ),
	(\absTime: 7.5769546406336, \dur: 0.069298821865232, \level: 21.96527170268, \next_absTime: 7.6462534624989, \next_level: 10.856539549382, \playDur: 0.069298821865232, \relDur: 0.069298821865232, \sustain: 0.069298821865232, ),
	(\absTime: 7.6462534624989, \dur: 0.068005618635652, \level: 10.856539549382, \next_absTime: 7.7142590811345, \next_level: 6.8296538395342, \playDur: 0.068005618635652, \relDur: 0.068005618635652, \sustain: 0.068005618635652, ),
	(\absTime: 7.7142590811345, \dur: 0.039189464263472, \level: 6.8296538395342, \next_absTime: 7.753448545398, \next_level: 5.5943728258036, \playDur: 0.039189464263472, \relDur: 0.039189464263472, \sustain: 0.039189464263472, ),
	(\absTime: 7.753448545398, \dur: 0.071231982899917, \level: 5.5943728258036, \next_absTime: 7.8246805282979, \next_level: 5.2586191185688, \playDur: 0.071231982899917, \relDur: 0.071231982899917, \sustain: 0.071231982899917, ),
	(\absTime: 7.8246805282979, \dur: 0.065842998701555, \level: 5.2586191185688, \next_absTime: 7.8905235269995, \next_level: 5.2241314344542, \playDur: 0.065842998701555, \relDur: 0.065842998701555, \sustain: 0.065842998701555, ),
	(\absTime: 7.8905235269995, \dur: 0.039255148101802, \level: 5.2241314344542, \next_absTime: 7.9297786751013, \next_level: 4.9951915152007, \playDur: 0.039255148101802, \relDur: 0.039255148101802, \sustain: 0.039255148101802, ),
	(\absTime: 7.9297786751013, \dur: 0.071743187363609, \level: 4.9951915152007, \next_absTime: 8.0015218624649, \next_level: 4.1515940743794, \playDur: 0.071743187363609, \relDur: 0.071743187363609, \sustain: 0.071743187363609, ),
	(\absTime: 8.0015218624649, \dur: 0.043733313032135, \level: 4.1515940743794, \next_absTime: 8.045255175497, \next_level: 3.7908742759032, \playDur: 0.043733313032135, \relDur: 0.043733313032135, \sustain: 0.043733313032135, ),
	(\absTime: 8.045255175497, \dur: 0.06861751006727, \level: 3.7908742759032, \next_absTime: 8.1138726855643, \next_level: 3.6114274021114, \playDur: 0.06861751006727, \relDur: 0.06861751006727, \sustain: 0.06861751006727, ),
	(\absTime: 8.1138726855643, \dur: 0.039103583934775, \level: 3.6114274021114, \next_absTime: 8.152976269499, \next_level: 3.4048255336683, \playDur: 0.039103583934775, \relDur: 0.039103583934775, \sustain: 0.039103583934775, ),
	(\absTime: 8.152976269499, \dur: 0.076474340199638, \level: 3.4048255336683, \next_absTime: 8.2294506096987, \next_level: 3.1622776601684, \playDur: 0.076474340199638, \relDur: 0.076474340199638, \sustain: 0.076474340199638, ),
	(\absTime: 8.2294506096987, \dur: 0.067697531332669, \level: 3.1622776601684, \next_absTime: 8.2971481410314, \next_level: 2.9005657152428, \playDur: 0.067697531332669, \relDur: 0.067697531332669, \sustain: 0.067697531332669, ),
	(\absTime: 8.2971481410314, \dur: 0.041237889501645, \level: 2.9005657152428, \next_absTime: 8.338386030533, \next_level: 2.7419589605438, \playDur: 0.041237889501645, \relDur: 0.041237889501645, \sustain: 0.041237889501645, ),
	(\absTime: 8.338386030533, \dur: 0.075329172297643, \level: 2.7419589605438, \next_absTime: 8.4137152028306, \next_level: 2.5392105958251, \playDur: 0.075329172297643, \relDur: 0.075329172297643, \sustain: 0.075329172297643, ),
	(\absTime: 8.4137152028306, \dur: 0.042260792368324, \level: 2.5392105958251, \next_absTime: 8.455975995199, \next_level: 2.4777206642639, \playDur: 0.042260792368324, \relDur: 0.042260792368324, \sustain: 0.042260792368324, ),
	(\absTime: 8.455975995199, \dur: 0.071295602134342, \level: 2.4777206642639, \next_absTime: 8.5272715973333, \next_level: 2.407228616914, \playDur: 0.071295602134342, \relDur: 0.071295602134342, \sustain: 0.071295602134342, ),
	(\absTime: 8.5272715973333, \dur: 0.049476152929856, \level: 2.407228616914, \next_absTime: 8.5767477502632, \next_level: 2.3585006373968, \playDur: 0.049476152929856, \relDur: 0.049476152929856, \sustain: 0.049476152929856, ),
	(\absTime: 8.5767477502632, \dur: 0.074293834299169, \level: 2.3585006373968, \next_absTime: 8.6510415845623, \next_level: 2.3129719430705, \playDur: 0.074293834299169, \relDur: 0.074293834299169, \sustain: 0.074293834299169, ),
	(\absTime: 8.6510415845623, \dur: 0.044142084199848, \level: 2.3129719430705, \next_absTime: 8.6951836687622, \next_level: 2.2795098084793, \playDur: 0.044142084199848, \relDur: 0.044142084199848, \sustain: 0.044142084199848, ),
	(\absTime: 8.6951836687622, \dur: 0.074341607371025, \level: 2.2795098084793, \next_absTime: 8.7695252761332, \next_level: 2.2655951525042, \playDur: 0.074341607371025, \relDur: 0.074341607371025, \sustain: 0.074341607371025, ),
	(\absTime: 8.7695252761332, \dur: 0.044740775832906, \level: 2.2655951525042, \next_absTime: 8.8142660519661, \next_level: 2.3504353273767, \playDur: 0.044740775832906, \relDur: 0.044740775832906, \sustain: 0.044740775832906, ),
	(\absTime: 8.8142660519661, \dur: 0.07165561443253, \level: 2.3504353273767, \next_absTime: 8.8859216663986, \next_level: 2.622400242933, \playDur: 0.07165561443253, \relDur: 0.07165561443253, \sustain: 0.07165561443253, ),
	(\absTime: 8.8859216663986, \dur: 0.042047436931171, \level: 2.622400242933, \next_absTime: 8.9279691033298, \next_level: 2.7585745853494, \playDur: 0.042047436931171, \relDur: 0.042047436931171, \sustain: 0.042047436931171, ),
	(\absTime: 8.9279691033298, \dur: 0.079179998501786, \level: 2.7585745853494, \next_absTime: 9.0071491018316, \next_level: 2.9293333469572, \playDur: 0.079179998501786, \relDur: 0.079179998501786, \sustain: 0.079179998501786, ),
	(\absTime: 9.0071491018316, \dur: 0.042741978500999, \level: 2.9293333469572, \next_absTime: 9.0498910803326, \next_level: 3.004914065674, \playDur: 0.042741978500999, \relDur: 0.042741978500999, \sustain: 0.042741978500999, ),
	(\absTime: 9.0498910803326, \dur: 0.078172503664973, \level: 3.004914065674, \next_absTime: 9.1280635839976, \next_level: 3.3024823278689, \playDur: 0.078172503664973, \relDur: 0.078172503664973, \sustain: 0.078172503664973, ),
	(\absTime: 9.1280635839976, \dur: 0.047155997199297, \level: 3.3024823278689, \next_absTime: 9.1752195811969, \next_level: 3.4206563797715, \playDur: 0.047155997199297, \relDur: 0.047155997199297, \sustain: 0.047155997199297, ),
	(\absTime: 9.1752195811969, \dur: 0.075717875100963, \level: 3.4206563797715, \next_absTime: 9.2509374562978, \next_level: 3.6162914143574, \playDur: 0.075717875100963, \relDur: 0.075717875100963, \sustain: 0.075717875100963, ),
	(\absTime: 9.2509374562978, \dur: 0.043285967531119, \level: 3.6162914143574, \next_absTime: 9.294223423829, \next_level: 3.6848107818619, \playDur: 0.043285967531119, \relDur: 0.043285967531119, \sustain: 0.043285967531119, ),
	(\absTime: 9.294223423829, \dur: 0.081486895534908, \level: 3.6848107818619, \next_absTime: 9.3757103193639, \next_level: 3.9142200737397, \playDur: 0.081486895534908, \relDur: 0.081486895534908, \sustain: 0.081486895534908, ),
	(\absTime: 9.3757103193639, \dur: 0.043785542868136, \level: 3.9142200737397, \next_absTime: 9.419495862232, \next_level: 4.080393299967, \playDur: 0.043785542868136, \relDur: 0.043785542868136, \sustain: 0.043785542868136, ),
	(\absTime: 9.419495862232, \dur: 0.07602406416845, \level: 4.080393299967, \next_absTime: 9.4955199264004, \next_level: 4.3180051369822, \playDur: 0.07602406416845, \relDur: 0.07602406416845, \sustain: 0.07602406416845, ),
	(\absTime: 9.4955199264004, \dur: 0.048941107397695, \level: 4.3180051369822, \next_absTime: 9.5444610337981, \next_level: 4.571307170788, \playDur: 0.048941107397695, \relDur: 0.048941107397695, \sustain: 0.048941107397695, ),
	(\absTime: 9.5444610337981, \dur: 0.080785200203536, \level: 4.571307170788, \next_absTime: 9.6252462340017, \next_level: 5.06402074485, \playDur: 0.080785200203536, \relDur: 0.080785200203536, \sustain: 0.080785200203536, ),
	(\absTime: 9.6252462340017, \dur: 0.044639240495599, \level: 5.06402074485, \next_absTime: 9.6698854744973, \next_level: 5.4967753838258, \playDur: 0.044639240495599, \relDur: 0.044639240495599, \sustain: 0.044639240495599, ),
	(\absTime: 9.6698854744973, \dur: 0.086611755603371, \level: 5.4967753838258, \next_absTime: 9.7564972301006, \next_level: 6.2366239501516, \playDur: 0.086611755603371, \relDur: 0.086611755603371, \sustain: 0.086611755603371, ),
	(\absTime: 9.7564972301006, \dur: 0.045319982928049, \level: 6.2366239501516, \next_absTime: 9.8018172130287, \next_level: 6.5993280037577, \playDur: 0.045319982928049, \relDur: 0.045319982928049, \sustain: 0.045319982928049, ),
	(\absTime: 9.8018172130287, \dur: 0.077538974233903, \level: 6.5993280037577, \next_absTime: 9.8793561872626, \next_level: 7.4289660383861, \playDur: 0.077538974233903, \relDur: 0.077538974233903, \sustain: 0.077538974233903, ),
	(\absTime: 9.8793561872626, \dur: 0.050762442137056, \level: 7.4289660383861, \next_absTime: 9.9301186293997, \next_level: 8.4937291591986, \playDur: 0.050762442137056, \relDur: 0.050762442137056, \sustain: 0.050762442137056, ),
	(\absTime: 9.9301186293997, \dur: 0.079498991599394, \level: 8.4937291591986, \next_absTime: 10.009617620999, \next_level: 10.501471630912, \playDur: 0.079498991599394, \relDur: 0.079498991599394, \sustain: 0.079498991599394, ),
	(\absTime: 10.009617620999, \dur: 0.045542527801445, \level: 10.501471630912, \next_absTime: 10.0551601488, \next_level: 11.330735071706, \playDur: 0.045542527801445, \relDur: 0.045542527801445, \sustain: 0.045542527801445, ),
	(\absTime: 10.0551601488, \dur: 0.086000893363234, \level: 11.330735071706, \next_absTime: 10.141161042164, \next_level: 14.094104764367, \playDur: 0.086000893363234, \relDur: 0.086000893363234, \sustain: 0.086000893363234, ),
	(\absTime: 10.141161042164, \dur: 0.046733398998185, \level: 14.094104764367, \next_absTime: 10.187894441162, \next_level: 15.73144555987, \playDur: 0.046733398998185, \relDur: 0.046733398998185, \sustain: 0.046733398998185, ),
	(\absTime: 10.187894441162, \dur: 0.080715307602077, \level: 15.73144555987, \next_absTime: 10.268609748764, \next_level: 18.320207569766, \playDur: 0.080715307602077, \relDur: 0.080715307602077, \sustain: 0.080715307602077, ),
	(\absTime: 10.268609748764, \dur: 0.052367484699062, \level: 18.320207569766, \next_absTime: 10.320977233463, \next_level: 21.443717486759, \playDur: 0.052367484699062, \relDur: 0.052367484699062, \sustain: 0.052367484699062, ),
	(\absTime: 10.320977233463, \dur: 0.078639335766638, \level: 21.443717486759, \next_absTime: 10.39961656923, \next_level: 27.692613730734, \playDur: 0.078639335766638, \relDur: 0.078639335766638, \sustain: 0.078639335766638, ),
	(\absTime: 10.39961656923, \dur: 0.047999145535869, \level: 27.692613730734, \next_absTime: 10.447615714766, \next_level: 29.067114237291, \playDur: 0.047999145535869, \relDur: 0.047999145535869, \sustain: 0.047999145535869, ),
	(\absTime: 10.447615714766, \dur: 0.084302158466016, \level: 29.067114237291, \next_absTime: 10.531917873232, \next_level: 30.570859993331, \playDur: 0.084302158466016, \relDur: 0.084302158466016, \sustain: 0.084302158466016, ),
	(\absTime: 10.531917873232, \dur: 0.079471692999505, \level: 30.570859993331, \next_absTime: 10.611389566231, \next_level: 28.495329767221, \playDur: 0.079471692999505, \relDur: 0.079471692999505, \sustain: 0.079471692999505, ),
	(\absTime: 10.611389566231, \dur: 0.051214476898167, \level: 28.495329767221, \next_absTime: 10.662604043129, \next_level: 20.717680857557, \playDur: 0.051214476898167, \relDur: 0.051214476898167, \sustain: 0.051214476898167, ),
	(\absTime: 10.662604043129, \dur: 0.086459027901583, \level: 20.717680857557, \next_absTime: 10.749063071031, \next_level: 12.842721891418, \playDur: 0.086459027901583, \relDur: 0.086459027901583, \sustain: 0.086459027901583, ),
	(\absTime: 10.749063071031, \dur: 0.049220108434383, \level: 12.842721891418, \next_absTime: 10.798283179465, \next_level: 8.8072101191294, \playDur: 0.049220108434383, \relDur: 0.049220108434383, \sustain: 0.049220108434383, ),
	(\absTime: 10.798283179465, \dur: 0.086876609268074, \level: 8.8072101191294, \next_absTime: 10.885159788733, \next_level: 6.1243432767712, \playDur: 0.086876609268074, \relDur: 0.086876609268074, \sustain: 0.086876609268074, ),
	(\absTime: 10.885159788733, \dur: 0.047811701966566, \level: 6.1243432767712, \next_absTime: 10.9329714907, \next_level: 5.2594738895762, \playDur: 0.047811701966566, \relDur: 0.047811701966566, \sustain: 0.047811701966566, ),
	(\absTime: 10.9329714907, \dur: 0.082105142999353, \level: 5.2594738895762, \next_absTime: 11.015076633699, \next_level: 5.2125996131674, \playDur: 0.082105142999353, \relDur: 0.082105142999353, \sustain: 0.082105142999353, ),
	(\absTime: 11.015076633699, \dur: 0.087145324501762, \level: 5.2125996131674, \next_absTime: 11.102221958201, \next_level: 6.5704452511477, \playDur: 0.087145324501762, \relDur: 0.087145324501762, \sustain: 0.087145324501762, ),
	(\absTime: 11.102221958201, \dur: 0.048859062797419, \level: 6.5704452511477, \next_absTime: 11.151081020998, \next_level: 8.5162942770149, \playDur: 0.048859062797419, \relDur: 0.048859062797419, \sustain: 0.048859062797419, ),
	(\absTime: 11.151081020998, \dur: 0.092277122366795, \level: 8.5162942770149, \next_absTime: 11.243358143365, \next_level: 12.668680054718, \playDur: 0.092277122366795, \relDur: 0.092277122366795, \sustain: 0.092277122366795, ),
	(\absTime: 11.243358143365, \curve: 0, \dur: 0.052094168033364, \level: 12.668680054718, \next_absTime: 11.295452311399, \next_level: 15.002782356784, \playDur: 0.052094168033364, \relDur: 0.052094168033364, \sustain: 0.052094168033364, ),
	(\absTime: 11.295452311399, \curve: 0, \dur: 0.084764626801189, \level: 15.002782356784, \next_absTime: 11.3802169382, \next_level: 15.32008003777, \playDur: 0.084764626801189, \relDur: 0.084764626801189, \sustain: 0.084764626801189, ),
	(\absTime: 11.3802169382, \curve: 0, \dur: 0.053681081797549, \level: 15.32008003777, \next_absTime: 11.433898019997, \next_level: 11.390397134929, \playDur: 0.053681081797549, \relDur: 0.053681081797549, \sustain: 0.053681081797549, ),
	(\absTime: 11.433898019997, \curve: 0, \dur: 0.085306711400335, \level: 11.390397134929, \next_absTime: 11.519204731398, \next_level: 6.7341908125767, \playDur: 0.085306711400335, \relDur: 0.085306711400335, \sustain: 0.085306711400335, ),
	(\absTime: 11.519204731398, \dur: 0.051174510666897, \level: 6.7341908125767, \next_absTime: 11.570379242065, \next_level: 5.8719371369989, \playDur: 0.051174510666897, \relDur: 0.051174510666897, \sustain: 0.051174510666897, ),
	(\absTime: 11.570379242065, \dur: 0.09095084420187, \level: 5.8719371369989, \next_absTime: 11.661330086266, \next_level: 4.5029939651122, \playDur: 0.09095084420187, \relDur: 0.09095084420187, \sustain: 0.09095084420187, ),
	(\absTime: 11.661330086266, \dur: 0.053753782998683, \level: 4.5029939651122, \next_absTime: 11.715083869265, \next_level: 3.9251402805099, \playDur: 0.053753782998683, \relDur: 0.053753782998683, \sustain: 0.053753782998683, ),
	(\absTime: 11.715083869265, \dur: 0.085941626533895, \level: 3.9251402805099, \next_absTime: 11.801025495799, \next_level: 3.4719013651966, \playDur: 0.085941626533895, \relDur: 0.085941626533895, \sustain: 0.085941626533895, ),
	(\absTime: 11.801025495799, \dur: 0.053481701164856, \level: 3.4719013651966, \next_absTime: 11.854507196964, \next_level: 3.3347222499737, \playDur: 0.053481701164856, \relDur: 0.053481701164856, \sustain: 0.053481701164856, ),
	(\absTime: 11.854507196964, \dur: 0.088933723800437, \level: 3.3347222499737, \next_absTime: 11.943440920764, \next_level: 3.1356475667224, \playDur: 0.088933723800437, \relDur: 0.088933723800437, \sustain: 0.088933723800437, ),
	(\absTime: 11.943440920764, \dur: 0.055353789099172, \level: 3.1356475667224, \next_absTime: 11.998794709863, \next_level: 2.9181442148278, \playDur: 0.055353789099172, \relDur: 0.055353789099172, \sustain: 0.055353789099172, ),
	(\absTime: 11.998794709863, \dur: 0.087611142898822, \level: 2.9181442148278, \next_absTime: 12.086405852762, \next_level: 2.5027037251566, \playDur: 0.087611142898822, \relDur: 0.087611142898822, \sustain: 0.087611142898822, ),
	(\absTime: 12.086405852762, \dur: 0.050941585970577, \level: 2.5027037251566, \next_absTime: 12.137347438733, \next_level: 2.1883712381534, \playDur: 0.050941585970577, \relDur: 0.050941585970577, \sustain: 0.050941585970577, ),
	(\absTime: 12.137347438733, \dur: 0.096000218232803, \level: 2.1883712381534, \next_absTime: 12.233347656966, \next_level: 1.980941896373, \playDur: 0.096000218232803, \relDur: 0.096000218232803, \sustain: 0.096000218232803, ),
	(\absTime: 12.233347656966, \dur: 0.052048027631827, \level: 1.980941896373, \next_absTime: 12.285395684597, \next_level: 1.8535917800603, \playDur: 0.052048027631827, \relDur: 0.052048027631827, \sustain: 0.052048027631827, ),
	(\absTime: 12.285395684597, \dur: 0.094006113267824, \level: 1.8535917800603, \next_absTime: 12.379401797865, \next_level: 1.7354359379957, \playDur: 0.094006113267824, \relDur: 0.094006113267824, \sustain: 0.094006113267824, ),
	(\absTime: 12.379401797865, \dur: 0.053376530566311, \level: 1.7354359379957, \next_absTime: 12.432778328432, \next_level: 1.6568192454677, \playDur: 0.053376530566311, \relDur: 0.053376530566311, \sustain: 0.053376530566311, ),
	(\absTime: 12.432778328432, \dur: 0.087207883530937, \level: 1.6568192454677, \next_absTime: 12.519986211963, \next_level: 1.5363996209521, \playDur: 0.087207883530937, \relDur: 0.087207883530937, \sustain: 0.087207883530937, ),
	(\absTime: 12.519986211963, \dur: 0.05876724870177, \level: 1.5363996209521, \next_absTime: 12.578753460664, \next_level: 1.4453772604854, \playDur: 0.05876724870177, \relDur: 0.05876724870177, \sustain: 0.05876724870177, ),
	(\absTime: 12.578753460664, \dur: 0.087326536035107, \level: 1.4453772604854, \next_absTime: 12.666079996699, \next_level: 1.342520051075, \playDur: 0.087326536035107, \relDur: 0.087326536035107, \sustain: 0.087326536035107, ),
	(\absTime: 12.666079996699, \dur: 0.056245527866849, \level: 1.342520051075, \next_absTime: 12.722325524566, \next_level: 1.2540192394264, \playDur: 0.056245527866849, \relDur: 0.056245527866849, \sustain: 0.056245527866849, ),
	(\absTime: 12.722325524566, \dur: 0.092646685763611, \level: 1.2540192394264, \next_absTime: 12.81497221033, \next_level: 1.1654226250316, \playDur: 0.092646685763611, \relDur: 0.092646685763611, \sustain: 0.092646685763611, ),
	(\absTime: 12.81497221033, \dur: 0.086124547204236, \level: 1.1654226250316, \next_absTime: 12.901096757534, \next_level: 1.0793272870269, \playDur: 0.086124547204236, \relDur: 0.086124547204236, \sustain: 0.086124547204236, ),
	(\absTime: 12.901096757534, \dur: 0.060075898200012, \level: 1.0793272870269, \next_absTime: 12.961172655734, \next_level: 1.0270118832543, \playDur: 0.060075898200012, \relDur: 0.060075898200012, \sustain: 0.060075898200012, ),
	(\absTime: 12.961172655734, \dur: 0.087749083595554, \level: 1.0270118832543, \next_absTime: 13.04892173933, \next_level: 0.94390118937929, \playDur: 0.087749083595554, \relDur: 0.087749083595554, \sustain: 0.087749083595554, ),
	(\absTime: 13.04892173933, \dur: 0.056169672934629, \level: 0.94390118937929, \next_absTime: 13.105091412264, \next_level: 0.93852928593867, \playDur: 0.056169672934629, \relDur: 0.056169672934629, \sustain: 0.056169672934629, ),
	(\absTime: 13.105091412264, \dur: 0.093139174503449, \level: 0.93852928593867, \next_absTime: 13.198230586768, \next_level: 0.95224748982462, \playDur: 0.093139174503449, \relDur: 0.093139174503449, \sustain: 0.093139174503449, ),
	(\absTime: 13.198230586768, \dur: 0.053455283999938, \level: 0.95224748982462, \next_absTime: 13.251685870768, \next_level: 1.0496448523735, \playDur: 0.053455283999938, \relDur: 0.053455283999938, \sustain: 0.053455283999938, ),
	(\absTime: 13.251685870768, \dur: 0.097821513700183, \level: 1.0496448523735, \next_absTime: 13.349507384468, \next_level: 1.2494353246003, \playDur: 0.097821513700183, \relDur: 0.097821513700183, \sustain: 0.097821513700183, ),
	(\absTime: 13.349507384468, \dur: 0.094181325264799, \level: 1.2494353246003, \next_absTime: 13.443688709733, \next_level: 1.6872828364985, \playDur: 0.094181325264799, \relDur: 0.094181325264799, \sustain: 0.094181325264799, ),
	(\absTime: 13.443688709733, \dur: 0.058095461132325, \level: 1.6872828364985, \next_absTime: 13.501784170865, \next_level: 1.9820198270736, \playDur: 0.058095461132325, \relDur: 0.058095461132325, \sustain: 0.058095461132325, ),
	(\absTime: 13.501784170865, \dur: 0.092428852898593, \level: 1.9820198270736, \next_absTime: 13.594213023764, \next_level: 2.7980440237908, \playDur: 0.092428852898593, \relDur: 0.092428852898593, \sustain: 0.092428852898593, ),
	(\absTime: 13.594213023764, \dur: 0.054053957035649, \level: 2.7980440237908, \next_absTime: 13.648266980799, \next_level: 3.1381152368206, \playDur: 0.054053957035649, \relDur: 0.054053957035649, \sustain: 0.054053957035649, ),
	(\absTime: 13.648266980799, \dur: 0.10025530716666, \level: 3.1381152368206, \next_absTime: 13.748522287966, \next_level: 3.9674665459277, \playDur: 0.10025530716666, \relDur: 0.10025530716666, \sustain: 0.10025530716666, ),
	(\absTime: 13.748522287966, \dur: 0.056733319066552, \level: 3.9674665459277, \next_absTime: 13.805255607032, \next_level: 4.5601055740163, \playDur: 0.056733319066552, \relDur: 0.056733319066552, \sustain: 0.056733319066552, ),
	(\absTime: 13.805255607032, \dur: 0.098028476935724, \level: 4.5601055740163, \next_absTime: 13.903284083968, \next_level: 5.6963891651999, \playDur: 0.098028476935724, \relDur: 0.098028476935724, \sustain: 0.098028476935724, ),
	(\absTime: 13.903284083968, \dur: 0.056171660027758, \level: 5.6963891651999, \next_absTime: 13.959455743996, \next_level: 6.6651016470122, \playDur: 0.056171660027758, \relDur: 0.056171660027758, \sustain: 0.056171660027758, ),
	(\absTime: 13.959455743996, \dur: 0.095333075503731, \level: 6.6651016470122, \next_absTime: 14.0547888195, \next_level: 8.9125093813375, \playDur: 0.095333075503731, \relDur: 0.095333075503731, \sustain: 0.095333075503731, ),
	(\absTime: 14.0547888195, \dur: 0.059217803733191, \level: 8.9125093813375, \next_absTime: 14.114006623233, \next_level: 10.510792794295, \playDur: 0.059217803733191, \relDur: 0.059217803733191, \sustain: 0.059217803733191, ),
	(\absTime: 14.114006623233, \dur: 0.092882512064534, \level: 10.510792794295, \next_absTime: 14.206889135297, \next_level: 13.562036560332, \playDur: 0.092882512064534, \relDur: 0.092882512064534, \sustain: 0.092882512064534, ),
	(\absTime: 14.206889135297, \dur: 0.061202734766994, \level: 13.562036560332, \next_absTime: 14.268091870064, \next_level: 15.685722368576, \playDur: 0.061202734766994, \relDur: 0.061202734766994, \sustain: 0.061202734766994, ),
	(\absTime: 14.268091870064, \dur: 0.094651566334505, \level: 15.685722368576, \next_absTime: 14.362743436399, \next_level: 18.78199113433, \playDur: 0.094651566334505, \relDur: 0.094651566334505, \sustain: 0.094651566334505, ),
	(\absTime: 14.362743436399, \dur: 0.058270910798456, \level: 18.78199113433, \next_absTime: 14.421014347197, \next_level: 22.663574578855, \playDur: 0.058270910798456, \relDur: 0.058270910798456, \sustain: 0.058270910798456, ),
	(\absTime: 14.421014347197, \dur: 0.095850181336573, \level: 22.663574578855, \next_absTime: 14.516864528534, \next_level: 26.175748308885, \playDur: 0.095850181336573, \relDur: 0.095850181336573, \sustain: 0.095850181336573, ),
	(\absTime: 14.516864528534, \dur: 0.1062608307293, \level: 26.175748308885, \next_absTime: 14.623125359263, \next_level: 25.907543752764, \playDur: 0.1062608307293, \relDur: 0.1062608307293, \sustain: 0.1062608307293, ),
	(\absTime: 14.623125359263, \dur: 0.057446516435448, \level: 25.907543752764, \next_absTime: 14.680571875699, \next_level: 20.7648245837, \playDur: 0.057446516435448, \relDur: 0.057446516435448, \sustain: 0.057446516435448, ),
	(\absTime: 14.680571875699, \dur: 0.10649758599902, \level: 20.7648245837, \next_absTime: 14.787069461698, \next_level: 13.343067521353, \playDur: 0.10649758599902, \relDur: 0.10649758599902, \sustain: 0.10649758599902, ),
	(\absTime: 14.787069461698, \dur: 0.07930614266661, \level: 13.343067521353, \next_absTime: 14.866375604364, \next_level: 9.2671559326615, \playDur: 0.07930614266661, \relDur: 0.07930614266661, \sustain: 0.07930614266661, ),
	(\absTime: 14.866375604364, \dur: 0.098231409134314, \level: 9.2671559326615, \next_absTime: 14.964607013499, \next_level: 6.1243432767712, \playDur: 0.098231409134314, \relDur: 0.098231409134314, \sustain: 0.098231409134314, ),
	(\absTime: 14.964607013499, \dur: 0.061672613133851, \level: 6.1243432767712, \next_absTime: 15.026279626632, \next_level: 5.1918365449581, \playDur: 0.061672613133851, \relDur: 0.061672613133851, \sustain: 0.061672613133851, ),
	(\absTime: 15.026279626632, \dur: 0.097502742766665, \level: 5.1918365449581, \next_absTime: 15.123782369399, \next_level: 4.4251977427389, \playDur: 0.097502742766665, \relDur: 0.097502742766665, \sustain: 0.097502742766665, ),
	(\absTime: 15.123782369399, \dur: 0.057989383265522, \level: 4.4251977427389, \next_absTime: 15.181771752665, \next_level: 4.0797636611155, \playDur: 0.057989383265522, \relDur: 0.057989383265522, \sustain: 0.057989383265522, ),
	(\absTime: 15.181771752665, \dur: 0.099548200269055, \level: 4.0797636611155, \next_absTime: 15.281319952934, \next_level: 3.5191090572015, \playDur: 0.099548200269055, \relDur: 0.099548200269055, \sustain: 0.099548200269055, ),
	(\absTime: 15.281319952934, \dur: 0.059573820130026, \level: 3.5191090572015, \next_absTime: 15.340893773064, \next_level: 3.307211360903, \playDur: 0.059573820130026, \relDur: 0.059573820130026, \sustain: 0.059573820130026, ),
	(\absTime: 15.340893773064, \dur: 0.10769170496496, \level: 3.307211360903, \next_absTime: 15.448585478029, \next_level: 2.9448245119727, \playDur: 0.10769170496496, \relDur: 0.10769170496496, \sustain: 0.10769170496496, ),
	(\absTime: 15.448585478029, \dur: 0.056946490567498, \level: 2.9448245119727, \next_absTime: 15.505531968596, \next_level: 2.7694689065704, \playDur: 0.056946490567498, \relDur: 0.056946490567498, \sustain: 0.056946490567498, ),
	(\absTime: 15.505531968596, \dur: 0.10436570360253, \level: 2.7694689065704, \next_absTime: 15.609897672199, \next_level: 2.5757113486677, \playDur: 0.10436570360253, \relDur: 0.10436570360253, \sustain: 0.10436570360253, ),
	(\absTime: 15.609897672199, \dur: 0.062966469431558, \level: 2.5757113486677, \next_absTime: 15.67286414163, \next_level: 2.563944764086, \playDur: 0.062966469431558, \relDur: 0.062966469431558, \sustain: 0.062966469431558, ),
	(\absTime: 15.67286414163, \dur: 0.32713585836973, \level: 2.563944764086, \playDur: 0.32713585836973, \relDur: 0.32713585836973, ),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);
(
NoteTimeline('sun77melobass1').param = Param(Pdef('melobass1'), 'midinote');
NoteTimeline('sun77melobass1').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.011621862824541, \label: 'start', \playDur: 0.011621862824541, \relDur: 0.011621862824541, \sustain: 0, \type: 'start', ),
	(\absTime: 0.011621862824541, \clockTime: 23901.211621863, \dur: 2.7488507374328, \legato: 0.8, \midinote: 38, \playDur: 2.7488507374328, \relDur: 2.7488507374328, \sustain: 2.8195400622317, \velocity: 106, ),
	(\absTime: 2.7604726002573, \clockTime: 23903.9604726, \dur: 0.19896690009773, \legato: 0.8, \midinote: 26, \playDur: 0.19896690009773, \relDur: 0.19896690009773, \sustain: 0.23455957179976, \velocity: 97, ),
	(\absTime: 2.9594395003551, \clockTime: 23904.1594395, \dur: 0.32087317146943, \legato: 0.8, \midinote: 38, \playDur: 0.32087317146943, \relDur: 0.32087317146943, \sustain: 0.38118209769891, \velocity: 99, ),
	(\absTime: 3.2803126718245, \clockTime: 23904.480312672, \dur: 0.36367472162965, \legato: 0.8, \midinote: 26, \playDur: 0.36367472162965, \relDur: 0.36367472162965, \sustain: 0.3890154039982, \velocity: 107, ),
	(\absTime: 3.6439873934542, \clockTime: 23904.843987393, \dur: 0.38946389959892, \legato: 0.8, \midinote: 38, \playDur: 0.38946389959892, \relDur: 0.38946389959892, \sustain: 0.36745206440173, \velocity: 102, ),
	(\absTime: 4.0334512930531, \clockTime: 23905.233451293, \dur: 3.2980635415042, \legato: 0.8, \midinote: 32, \playDur: 3.2980635415042, \relDur: 3.2980635415042, \sustain: 3.3565670773387, \velocity: 127, ),
	(\absTime: 7.3315148345573, \clockTime: 23908.531514835, \dur: 0.31010524500016, \legato: 0.8, \midinote: 38, \playDur: 0.31010524500016, \relDur: 0.31010524500016, \sustain: 0.36101670412972, \velocity: 111, ),
	(\absTime: 7.6416200795575, \clockTime: 23908.84162008, \dur: 0.38134864829772, \legato: 0.8, \midinote: 32, \playDur: 0.38134864829772, \relDur: 0.38134864829772, \sustain: 0.40069974420112, \velocity: 74, ),
	(\absTime: 8.0229687278552, \clockTime: 23909.222968728, \dur: 2.9770312721448, \legato: 0.8, \midinote: 33, \playDur: 2.9770312721448, \relDur: 2.9770312721448, \sustain: 3.0532671217989, \velocity: 93, ),
	(\absTime: 11.0, \clockTime: 23912.183398869, \dur: 0.33473482735644, \legato: 0.8, \midinote: 32, \playDur: 0.33473482735644, \relDur: 0.33473482735644, \sustain: 0.35203288450066, \velocity: 126, ),
	(\absTime: 11.334734827356, \clockTime: 23912.534734827, \dur: 0.31606923786967, \legato: 0.8, \midinote: 33, \playDur: 0.31606923786967, \relDur: 0.31606923786967, \sustain: 0.44873087036467, \velocity: 110, ),
	(\absTime: 11.650804065226, \clockTime: 23912.850804065, \dur: 0.34919593477389, \legato: 0.8, \midinote: 32, \playDur: 0.34919593477389, \relDur: 0.34919593477389, \sustain: 0.24847516386217, \velocity: 95, ),
	(\absTime: 12.0, \clockTime: 23913.166639098, \dur: 1.5, \legato: 0.8, \midinote: 26.0, \playDur: 1.5, \relDur: 1.5, \sustain: 1.5, \velocity: 117, ),
	(\absTime: 13.5, \clockTime: 23914.14084803, \dur: 0.5, \legato: 0.8, \midinote: 38.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, \velocity: 123, ),
	(\absTime: 14.0, \clockTime: 23915.198247183, \dur: 2.0, \legato: 0.8, \midinote: 26.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, \velocity: 118, ),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

//////////

(
SynthDef(\fmsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv;
	var fmenv;
	lpenv = EnvGen.kr(Env([0,1,0],[0.01,0.4]), 1) * \lpenvamt.kr(2) + 1;
	fmenv = EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1) * \fmenvamt.kr(3) + 1;
	sig = LFPulse.ar(freq + (LFSaw.ar(freq * 1 * [2,1,1/2,1.001,2], 1/2)*100 * fmenv + 1) );
	//sig = DFM1.ar(sig, \lpf.kr( 30 ) * lpenv, 1/\rq.kr(0.2));
	sig = MoogFF.ar(sig, \lpf.kr( 400 ) * lpenv, 1/\rq.kr(0.4));
	sig = DelayL.ar(sig, 0.1,0.0001 * ( SinOsc.kr(0.1) * 1 + 1 )) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,0,-1,0, 2,0,-1,-1,
			],inf),
			\fmenvamt, PmodEnv(Pseq([1,9],1), 8).loop,
			\lpf, PmodEnv(Pseq([100,900],1), 5).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo3, 
	Pbind(
		\instrument, \fmsaw,
	)
)
);


/////////////////////////////////////////
NoteTimeline(\sun77melo3, Pdef(\melo3)).edit
MIDIOut.findPort ("synthv1") 

(
Pdef(\zed, 
	Pbind(
		\type, \midi,
		\midicmd, \noteOn,
		\midiout, MIDIOut(0),
		\chan, 0,
		\degree, Pseq([0,4,2,1],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

NoteTimeline(\sun77melo3, Pdef(\melo3)).edit

