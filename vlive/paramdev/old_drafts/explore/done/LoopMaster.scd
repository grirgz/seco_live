
(
	// moved to Proto/timeline.scd
)


//////////////// tests

	(
	ParamProto.init(true);
NoteTimeline(\test_notetimeline).clear;
NoteTimeline(\test_notetimeline, Param(Pdef(\test_pdef), \midinote));
NoteTimeline(\test_notetimeline).asPattern.asStream.nextN(10,()).postln;
NoteTimeline(\test_notetimeline).asPattern.play
	)


(
);
NoteTimeline(\test_notetimeline).edit
NoteTimeline(\test_notetimeline).repeatCount = 1
NoteTimeline(\test_notetimeline).loopMaster
NoteTimeline(\test_notetimeline).clear;
NoteTimeline(\test_notetimeline).asPattern.asStream.nextN(10,())
NoteTimeline(\test_notetimeline).asPattern
NoteTimeline(\test_notetimeline).asPattern.play

NoteTimeline(\test_notetimeline).presetCompileString.editorInsert
(
	~test = UnitTest.new;
	~t = 135/4/60; TempoClock.default.tempo = ~t;
	Pdef(\test_pdef, Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1
	));
	ParamProto.init;
NoteTimeline(\test_notetimeline).clear;
NoteTimeline(\test_notetimeline, Param(Pdef(\test_pdef), \midinote));
NoteTimeline('test_notetimeline').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 53.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 56.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.25, \dur: 0.125, \midinote: 65.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.125, \midinote: 66.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.125, \midinote: 81.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.125, \midinote: 83.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.125, \midinote: 99.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.125, \midinote: 103.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


(
(
	\type: \rest,
	\play: {
		"bla".debug;
	}
).play
)

NoteTimeline(\test_notetimeline).cursor.changed(\cursor, \play)
NoteTimeline(\test_notetimeline).editor.cursor_timeline.play
NoteTimeline(\test_notetimeline).editor.cursor_timeline.cursor.changed(\cursor, \play)
NoteTimeline(\test_notetimeline).editor.cursor_timeline.
NoteTimeline(\test_notetimeline).repeatCount


ClipTimeline(\test_outer).edit
ClipTimeline(\test_outer).presetCompileString.editorInsert



(
ClipTimeline('test_outer').eventList = XEventList.newFrom([
	(\absTime: 0.375, \dur: 0.875, \legato: 1, \midinote: 1.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.625, \label: 'start', \playDur: 0.625, \relDur: 0.625, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.875, \dur: 2.25, \legato: 1, \midinote: 3.0, \playDur: 2.25, \relDur: 2.25, \sustain: 2.75, \timeline: { NoteTimeline('test_notetimeline') }, \type: 'pattern', )),
	(\absTime: 4.125, \dur: 1.75, \label: 'end', \playDur: 1.75, \relDur: 1.75, \type: 'end', ),
	(\absTime: 5.875, \dur: 0, \legato: 1, \midinote: 2.0, \playDur: 0, \relDur: 0, \sustain: 0.5, ),
]);
);


//// derouler les API


NoteTimeline(\test_notetimeline).asPatternEvent.play
ClipTimeline(\test_outer).asPattern.play
ClipTimeline(\test_outer).eventList[1].play
ClipTimeline(\test_outer).asPattern.asStream.nextN(10,())
ClipTimeline(\test_outer).asSelectedPattern.asStream.nextN(10,()).collect(_.postln)
ClipTimeline(\test_outer).asSelectedPattern.trace.play

(
	
)
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ).play
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'start', ).play
	(\absTime: 5.875, \dur: 1, \legato: 1, \midinote: 72.0, \playDur: 0, \relDur: 0, \sustain: 0.5, \type: \note).play



ijk
}jk
lkj
(
( 'playDur': 1.5, 'dur': 1, 'event_dropdur': 0.5, 'sustain': -0.5,
'isRest': true, 'delta': 1, 'relDur': 1.5, 'absTime': 1.5, 'type': \start,
'label': \start ).play

)
////////////////////////////////////////////////////////////////
// try to fix unwanted note bug


ClipTimeline(\test_outer).presetCompileString.editorInsert
(
ClipTimeline('test_outer').eventList = XEventList.newFrom([
	(\absTime: 1.5, \dur: 1.5, \label: 'start', \playDur: 1.5, \relDur: 1.5, \sustain: 0, \type: 'start', ),
	(\absTime: 3.0, \dur: 1.75, \label: 'end', \playDur: 1.75, \relDur: 1.75, \type: 'end', ),
	(\absTime: 4.75, \dur: 0, \legato: 1, \midinote: 1.0, \playDur: 0, \relDur: 0, \sustain: 3.0, ),
]);
);

(
ClipTimeline('test_outer').cursor.startPosition = 3;
ClipTimeline('test_outer').cursor.endPosition = 4;
ClipTimeline('test_outer').asSelectedPattern(1).play;
)

~el = ClipTimeline('test_outer').asSelectedPattern(1).asStream.nextN(2,())
Pseq(~el).play;

