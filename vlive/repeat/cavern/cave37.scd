~t = 72/1/60; TempoClock.default.tempo = ~t;

FileSystemProject.load("libdef/wip/RecordFactory.scd");
ProtoDef(\RecordFactory).edit

FileSystemProject.load("libdef/simplemixer.scd");
ProtoDef(\fxMixer).edit
ProtoDef(\fxMixer).play;
ProtoDef(\fxMixer).clear

(
	// recording
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[406].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\dur, 1/8 * Pseg(Pseq([1,0.1],inf),8),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	// recording
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[406].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\dur, 1/8 * Pseg(Pseq([1,0.1],inf),8),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[993].value,
			\isRest, Pseq([
				0,0,1,0, 1,1,1,0,
				0,0.2,1,0.4, 0.61,0.61,0.71,0.2,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\bufnum, ~buflib.snare[1731].value, 
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);
Ndef(\lfo1).quant = Pdef.defaultQuant;
Ndef(\lfo2).quant = Pdef.defaultQuant;
ProtoDef(\rdn).proxy.set(\delay2, Ndef(\lfo1, { XLine.kr(1,0.00001,32).poll }));
ProtoDef(\rdn).proxy.set(\delay, Ndef(\lfo2, { EnvGen.kr(Env([1,1,0.0001],[32,32]), 1); }));
(
ProtoDef(\rdn).proxy[1000] = \setn -> Pbind(
	\delay
	\dur, 1,
);
)

FileSystemProject.loadOnce("cavern/ClipTimeline_cave37_rec1.scd");
ClipTimeline(\cave37_rec1).edit

(
	// recording
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[406].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			//\dur, 1/8 * Pseg(Pseq([1,0.1],inf),8),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\bufnum, ~buflib.snare[1731].value, 
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\bufnum, ~buflib.snare[1732].value, 
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

(
	// recording
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\bufnum, ~buflib.snare[1731].value, 
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[406].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			//\dur, 1/8 * Pseg(Pseq([1,0.1],inf),8),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\bufnum, ~buflib.snare[1731].value, 
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1365].value, // long
			\legato, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,1,
				1,0,1,0, 2,0,1,0,
				1,0,1,0, 0,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,0,1,
				1,0,1,0, 1,0,1,0,
				16,0,0,0, 1,0,1,0,
				1,0,8,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,8,0,
				1,0,1,0, 1,0,1,0,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\lag, 0.01,
			\gain, 0.11 * Pseq([
				1,0.3,0.4,0.3,
			],inf),
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

FileSystemProject.load("libdef/CustomTrackList.scd");
TrackDef(\cave37rec, TrackTemplateDef(\CustomTrackList))
TrackDef(\cave37rec).childAt(0).trackTemplate = TrackTemplateDef(\SampleTimelineTrack)
TrackDef(\cave37rec).childAt(0).recBus = BusDef(\trackMixerDef_record_fxmixer1)
TrackDef(\cave37rec).edit
TrackDef(\cave37rec).childAt(0).childAt(0).source.recorder.recBus
TrackDef(\cave37rec).childAt(0).source
TrackDef(\cave37rec).presetCompileStringSavePath = "~/code/sc/seco/vlive/repeat/cavern/cave37/".standardizePath;
TrackDef(\cave37rec).savePresetCompileString
TrackDef(\cave37rec).loadPresetCompileString
TrackDef(\cave37rec).clear
TrackDef(\cave37rec).presetCompileStringSaveFile
TrackDef(\cave37rec).childAt(0,0).source
TrackDef(\cave37rec).childAt(0,0).score
TrackDef(\cave37rec).childAt(0).loadPresetCompileString
TrackDef(\cave37rec).childAt(1).loadPresetCompileString
TrackDef(\cave37rec).childAt(0,0).loadPresetCompileString
TrackDef(\cave37rec).childAt(0,0).source
TrackDef(\cave37rec).childAt(0,0)[\play].asCompileString
TrackDef(\cave37rec).childAt(0,0).proxy
TrackDef(\cave37rec).childAt(0,0).source.buffer.numFrames
TrackDef(\cave37rec).dataPath
FileSystemProject.load("libdef/PbindefEditor.scd");
FileSystemProject.load("libdef/controllers.scd")
SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer,

			\pos, 36/4 + Pseg(Pseq([0,1/2],inf),8) / ~t,
			\pos, 12/4 + Pseq([0,10,21,4],inf).stutter(8) + Pseg(Pseq([0,1],inf),16) / ~t,
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1/2,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\lag, 0.04,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer,
			\pos, 27/8/~t + Pseg(Pseq([0,1],1),8).loop,
			\speed, Pseg(Pseq([0.7,1]+0.4,1),8).loop,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,1,0,
				0,0,1,1, 0,0,0,0,
				1,0,0,1, 1,0,1,1,
				0,1,1,0, 0,1,0,0,
				1,0,1,0, 1,1,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.001) ],
			],inf),
			\dur, 1/16,
			\lag, 0.04,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1365].value, // long
			\legato, Pseq([
				0,0,0,4, 0,0,0,0,
				0,0,0,0, 0,0,0,4,
				0,0,1,0, 0,0,1,0,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\lag, 0.05,
			\gain, 0.08 * Pseq([
				1,0.3,0.4,0.3,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[366].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				0,0,0,1, 4,0,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 4,1,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 4,0,0,1,
				0,0,0,0, 4,0,0,0,
				1,0,0,1, 4,0,1,0,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\lag, 0.04,
			\gain, 0.11 * Pseq([
				1,0.3,0.4,0.2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer,

			\pos, 18/4/~t,
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\lag, 0.04,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer,
			\pos, 87/8/~t + Pseg(Pseq([0,4],inf),8),
			\speed, Pseg(Pseq([0.7,1],1),8).loop,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,1,0,
				1,1,0,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				1,1,0,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf)/5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.001) ],
			],inf),
			\dur, 1/8,
			\lag, 0.04,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1365].value, // long
			\legato, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,1,
				1,0,1,0, 2,0,1,0,
				1,0,1,0, 0,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,0,1,
				1,0,1,0, 1,0,1,0,
				16,0,0,0, 1,0,1,0,
				1,0,8,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,8,0,
				1,0,1,0, 1,0,1,0,
			],inf)/4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\lag, 0.05,
			\gain, 0.11 * Pseq([
				1,0.3,0.4,0.3,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer,
			\pos, 18*2+4/8/~t -0.03,
			\legato, Pseq([
				1/4,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.001) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\lag, 0.04,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave37_rec1_t0_220311_014225').buffer,
			\pos, Pseq([0,2,4,7,0],inf)/4+Pseq([0,10,40,25],inf).stutter(5)/~t,
			\legato, Pseg(Pseq([1,0.1],inf),8).loop,
			\dur, Pseq([3,1/4,1/2,1/8,1/8],inf),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2473].value, // metallic
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1234].value, 
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/4 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),4).loop / Pkey(\st),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\hpf, 1000,
			\dur, 1/1,
			\gain, 1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[919].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0.8,1/2,1,0.7,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, 0.04,
		),
		Pseq([
			//SampleTimeline('rec_cave37_rec1_t0_220311_014225').asPattern(0,1,1),
			//Plazy({
				//SampleTimeline('rec_cave37_rec1_t0_220311_014225').asPattern(10.rand.debug("merde"),1,1);
			//}),
			//SampleTimeline('rec_cave37_rec1_t0_220311_014225').asPattern(0,2,1),
			NoteTimeline(\nla).asPattern(1,1.5,1),
			Event.silent(1),
		],inf),
		//Pseq([
			//SampleTimeline('recorder.0.0score').asPattern(nil,nil,3),
			//SampleTimeline('recorder.0.1score').asPattern(nil,nil,1),
		//],inf),
		
	])
)).play;
);
Pdef(\part).clear;
Pdef(\zed).clear;

NoteTimeline(\nla).edit
NoteTimeline(\nla).clear
NoteTimeline(\nla).presetCompileString.editorInsert
(
NoteTimeline('nla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 39.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.25, \midinote: 45.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.25, \midinote: 40.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.125, \midinote: 35.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.25, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.125, \midinote: 38.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.375, \midinote: 42.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.125, \midinote: 50.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.625, \dur: 0.25, \midinote: 56.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 64.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

NoteTimeline(\nla).asPattern(1,1,1).asStream.nextN(10,()).collect(_.postln)
Pfindur(1,NoteTimeline(\nla).asPattern).asStream.nextN(10,()).collect(_.postln)

(
Pdef(\zed, 
	Pseq([
		Prout({ arg ev;
			while({ ev.notNil }) {
				ev.debug("ev!!");
				ev = ev.yield;
				ev.debug("ev ret");
			};
			ev.debug("ev final ret");
			ev;
			nil;
		}) <>
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, Pn(1,4),
			\amp, 0.1,
		),
		Event.silent(1),
	],2),
).play;
);

(
Pdef(\zed, 
	Pseq([
		Prout({ arg ev;
			(note:1).yield;
			(note:2).yield;
			2;
		}),
		Event.silent(1),
	],2),
).play;
);

(
Pdef(\zed, 
	Pseq([
		Prout({ arg ev;
			(note:1).yield;
			(note:2).yield;
			nil;
			()
		}),
		Event.silent(1),
	],2),
).play;
);

(
Pdef(\zed, 
	Pseq([
		//Event.silent(1),
		SampleTimeline('cave37rec.0.0score').asPattern(0,1,1),
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, Pn(1,1),
			\amp, 0.1,
		),
	],inf),
).play;
);

(
	// find kick
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[919].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

////////////

(
Pdef(\rub, 
	Pbind(
		\instrument, \default,
	)
).play;
);

NoteTimeline(\test5, Pdef(\rub))
NoteTimeline(\test5).presetCompileString
NoteTimeline(\test4).param.asCompileString
