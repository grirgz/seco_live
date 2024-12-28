ProtoClassDef(\FxTimeline, ProtoClass(( // can't use ProtoTemplateDef, clash with key and prAdd
	parent: ProtoClassDef(\ClipTimeline),
	all: { PresetDictionary.new(\fxTimeline) },
	eventType: \fxTimeline,

	new: { arg self, name;
		//"so many strange".debug;

		if(self.all[name].notNil) {
			self = self.all[name]
		} {
			self = ProtoClass((parent: ProtoClassDef(\FxTimeline)));
			self.addInstance(name).init;
		};
	
		self;
	},

	init: { arg self;
		// TODO: make accept a PlayerWrapperGroup as optional argument to handle recording
		self.basicInit;
		self.areasize = 10@4;

		//self.eventFactory = ~class_player_event_factory.new;
		//self.eventFactory.eventLoop = self.eventloop;
		//self.eventFactory.mode = \note;
		//self.eventFactory.playmode = \gate;
		//self.eventFactory.fullrecord = false;

		self.tracks = self.areasize.y.collect({ arg idx; (
			index: idx,
			recordBus: 0,
			recordArmed: false,
			muted: false,
		)});
		self.tracks_bypassed = Set.new;
		self.recorder = ProtoTemplateDef(\SampleClipTimelineMultiTrackRecorder).new(self) !? { arg x; {x} };

		self.clipList = ProtoClassDef(\ClipTimelineClipList).new(self) !? { arg x; {x} };
		//"=============clipTimeline: end init".debug;

		self;
	},

)));


//////// GUI

ProtoTemplateDef(\FxTimelineView, (
	parent: ProtoTemplateDef(\ClipTimelinePanelView),

));
);

// END

ProtoInst(\FxTimeline, \bla).edit
ProtoDef(\bla, ProtoClassDef(\FxTimeline).new)

ClipTimeline(\fx).edit

BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
SampleTimeline(\amen).buffer = BufDef(\amen)
SampleTimeline(\amen).edit
~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\stut1, 
	Pmono(\ifx_stutter,
		\out, BusDef(\ifxbus1, \audio, 2),
		\addAction, \addToTail,
		//\mix, Pseq([0,1],inf),
		\mix, 1,
		\wet, 1,
		\time, 1/4/~t,
		\group, GroupDef.pattern(\ifx1, GroupDef.pattern(\ifx, nil, \addAfter)),
		\lag, 0.0004,
		\dur, 1,
	),
);
);

(
Pdef(\chainout, 
	Pmono(\ifx_out,
		\inbus, BusDef(\ifxbus1, \audio, 2),
		\addAction, \addToTail,
		\group, GroupDef.pattern(\ifx, \addAfter),
		\lag, 0.0009,
		\dur, 1,
	),
);
);

(
Pdef(\augusto, 
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef.stereo('vbreaks/Augusto Alguero - Ballet Del Arbitro Bueno.wav'),
		\legato, 1,
		\st, 105/2/60,
		\speed, 1 * ~t / Pkey(\st),
		\pos, Pseg(Pseq([
			0, 2,
		]+0,1),2).loop / Pkey(\st),
		\dur, 1/8,
		\gain, 1/8,
	),
);
);

(
Pdef(\help, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\group, GroupDef(\group1),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\help).play
CmdPeriod.stop
