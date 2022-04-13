
TrackTimeline(\bla2, TrackDef(\tlist))
TrackTimeline(\bla2).edit
TrackTimeline(\bla2).recorder
TrackTimeline(\bla2).clear
TrackTimeline(\bla8).tracks
PlayerWrapperGroup(TrackDef(\tlist).children)
TrackDef(\tlist).children.collect({ arg x; x.asCompileString.postln })
TrackDef(\tlist).children.collect({ arg x; PlayerWrapper(x.debug("dddd")) })

TrackDef(\tlist, TrackTemplateDef(\TrackList))
TrackDef(\tlist).edit
TrackDef(\tlist).childAt(0).changed(\play)
TrackDef(\tlist).childAt(0,0).changed(\play)
TrackDef(\tlist).clear
TrackDef(\tlist).children[0].children
ParamProto.init(true)

PlayerWrapper(TrackDef(\tlist).childAt(0))

ProtoDef(\GlobalLibrary).targetToLibId(Pdef(\bla))
ProtoDef(\GlobalLibrary).targetToLibId(TrackDef(\tlist).childAt(0).childAt(0))

TrackDef(\tlist).childAt(0).childAt(0).eventType
TrackDef(\tlist).childAt(0).childAt(0).key

	PlayerEvent((\absTime: 0.75, \clockTime: 62.226662798, \dur: 3.506503294, \midinote: 0.0, \playDur: 3.506503294, \receiver: { PlayerWrapper(TrackDef('tlist').childAt(0)) }, \relDur: 3.506503294, \sustain: 2.375, \type: 'player', )).play
PlayerWrapper(TrackDef('tlist').childAt(0)).playNow
TrackDef('tlist').childAt(0).playNow
TrackDef('tlist').childAt(0).play
PlayerWrapper(TrackDef('tlist').childAt(0)).stopNow

TrackTimeline(\bla2).recorder.startRecording
TrackTimeline(\bla2).recorder.stopRecording
TrackTimeline(\bla2).tracks[0].play
TrackTimeline(\bla2).tracks[0].stop
TrackTimeline(\bla2).presetCompileString.editorInsert
(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackDef('tlist').childAt(0)) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.75, \label: 'start', \playDur: 0.75, \relDur: 0.75, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.75, \clockTime: 62.226662798, \dur: 3.506503294, \midinote: 0.0, \playDur: 3.506503294, \receiver: { PlayerWrapper(TrackDef('tlist').childAt(0)) }, \relDur: 3.506503294, \sustain: 2.375, \type: 'player', )),
	(\absTime: 4.256503294, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

TrackTimeline(\bla2).eventList[1].receiver.target.index
TrackTimeline(\bla2).eventList[1].receiver.target.parentTrack
(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackTemplateDef('InstrumentTrack')) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.25439013799996, \label: 'start', \playDur: 0.25439013799996, \relDur: 0.25439013799996, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.25439013799996, \clockTime: 528.454390138, \dur: 111.641108515, \midinote: 0, \playDur: 111.641108515, \receiver: { PlayerWrapper(TrackTemplateDef('InstrumentTrack')) }, \relDur: 111.641108515, \sustain: 3.387038766, \type: 'player', )),
	(\absTime: 111.895498653, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackTemplateDef('InstrumentTrack')) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \label: 'start', \relDur: 0.25439013799996, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.25439013799996, \clockTime: 528.454390138, \midinote: 0, \receiver: { PlayerWrapper(TrackTemplateDef('InstrumentTrack')) }, \relDur: 0.25439013799996, \sustain: 3.387038766, \type: 'player', )),
]);
 }.value;




);

TrackTimeline(\bla2).recorder.eventList
(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackTemplateDef('InstrumentTrack')) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

(
Pdef(\bla, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,3,2,1],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);
TrackTimeline(\xoo, PlayerWrapperGroup([Pdef(\bla)])).edit


//////// CustomTrackList

TrackTimeline(\bla3, TrackDef(\ctlist)).edit
TrackTimeline(\bla).eventList[1].receiver.class
TrackTimeline(\bla).eventList[1].receiver.target.label
TrackTimeline(\bla).eventType
TrackTimeline(\bla2).mainTrack
TrackTimeline(\bla2).tracks

FileSystemProject.load("libdef/CustomTrackList.scd");
TrackDef(\ctlist, TrackTemplateDef(\CustomTrackList))
TrackDef(\ctlist).edit
TrackDef(\ctlist).existingChildren.first.existingChildren
TrackDef(\ctlist).source
TrackDef(\ctlist).childAt(0,0).eventType
TrackDef(\ctlist).childAt(0,0).trackKey
ProtoDef(\GlobalLibrary).clipFactories.instrumenttrackpart.getEventTargetKey(TrackTimeline(\bla).eventList[1])
ProtoDef(\GlobalLibrary).clipFactories.instrumenttrackpart.getEventTargetKey(TrackTimeline(\bla).eventList[1])
~libid = ProtoDef(\GlobalLibrary).eventToLibId( TrackTimeline(\bla).eventList[1] )
ProtoDef(\GlobalLibrary).libIdToWrapper( ~libid ).getTarget
ProtoDef(\GlobalLibrary).init_default_clip_factories

FileSystemProject.load("libdef/PbindefEditor.scd");
Spec.add(\chord, ControlSpec(0,12,\lin,1,0))

~t = 185/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, TrackDef(\ctlist).childAt(1,2).score.buffer,
			\legato, 1 * Pseg(Pseq([1,0.1],inf),8),
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st) * Pseq([
				Pseq([
					Pseq([0,0,3,2, 1,-3,8,9],1),
					Pseq([
						1,3,
					],1),
				],inf).midiratio,
			],inf),
			//\pos, Pseg(Pseq([
				//0, 1,
			//],1),2).loop / Pkey(\st),
			\pos, Pseq([
				0,2,4,2,
				9,10,12,3,
			],inf),
			\legato, Pseq([
				3,0,0,1, 1,1,2,0,
			],inf) * Pseg(Pseq([1,0.1],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1 * Pseq([
				1,0.5,0.8,0.4,
				1,0.5,1,0.4,
				0.4,0.7,1,0.4,
			],inf),
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Ptuple([
					Pseq([
						Pseq((0..7),1),
						Pseq([0],16)
					],inf).stutter(Pseq([8,4,12,4,12],inf)),
					4-12+
					Pseq([
						Pseq([0],16),
						Pseq((0..7),1),
					],inf).stutter(Pseq([8,4,12,4,12],inf)),
					8+12 +
					Pseq([
						Pseq([0],16),
						Pseq([0],16),
						Pseq((0..7),1),
					],inf).stutter(Pseq([8,4,12,4,12],inf)),
				]),
			],inf).trace,
			\octave, 5,
			\strum, Pseg(Pseq([0,1],inf),8),
			\dur, 1,
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
			\ch0, Pseq([
				//4,3,2,1,0,
				0 + Pseq([
					Pseq([0],12),
					Prand([
						Pseq((0..3),1),
						Pseq((0..12),1),
						-1 * Pseq((0..12),1),
					],1),
				],inf),
			],inf).stutter(8),
			\ch1, Pseq([
				//4,3,2,1,0,
				4 - Pseq([
					Pseq((0..12),1),
					Prand([
						Pseq((0..12),1),
						Pseq([0],12),
						Pseq([0],8),
					],1),
				],inf),
			],inf).stutter(8),
			\ch2, Pseq([
				//4,3,2,1,0,
				7 - Pseq([
					Pseq([0],12),
					Pseq([0],12),
					Pseq((0..12),1)
					Pgate
				],inf),
			],inf).stutter(8),
			\note, Pseq([
				Ptuple([Pkey(\ch0),Pkey(\ch1),Pkey(\ch2), Pkey(\ch1)]),
			],inf),
			//\strum, Pseg(Pseq([0,1],inf),32),
			\strum, Prand([0,1/16,1/8,0,0,0],inf),
			\dur, 1/4,
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
			//\ch0gate, Pwrand([true, false],[0.1,1],inf),
			//\ch1gate, Pwrand([true, false],[0.1,1],inf),
			//\ch2gate, Pwrand([true, false],[0.1,1],inf),
			\chidx, Pseq([
				Prand([0,1,2,3,3,3],1),
				3,
				3,
				3,
			],inf),
			\ch0gate, Pbinop('==', Pkey(\chidx), 0),
			\ch1gate, Pbinop('==', Pkey(\chidx), 1),
			\ch2gate, Pbinop('==', Pkey(\chidx), 2),
			\ch0, Pseq([
				0 + Pseq([
					Pgate(Prand([
						Pseq((0..12),1),
						-1 * Pseq((0..12),1),
					],1),1,\ch0gate),
				],inf),
			],inf).stutter(4),
			\ch1, Pseq([
				4 + Pseq([
					Pgate(Prand([
						Pseq((0..12),1),
						-1 * Pseq((0..12),1),
					],1),1,\ch1gate),
				],inf),
			],inf).stutter(4),
			\ch2, Pseq([
				7 + Pseq([
					Pgate(Prand([
						Pseq((0..12),1),
						-1 * Pseq((0..12),1),
					],1),1,\ch2gate),
				],inf),
			],inf).stutter(4),
			\note, Pseq([
				Ptuple([Pkey(\ch0),Pkey(\ch1),Pkey(\ch2), Pkey(\ch1)]),
			],inf),
			//\strum, Pseg(Pseq([0,1],inf),32),
			\strum, Prand([0,1/16,1/8,0,0,0],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);
