


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pseq([300,450,234,699],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
s.boot;
ParamProto.init(true)
SampleTimeline(\bla3).edit
SampleTimeline(\bla2).recorder.filename
SampleTimeline(\bla2).recorder.temporaryRecordFolder
SampleTimeline(\bla2).editor.exportSelectionToBufferEditor
SampleTimeline(\bla2).cursor.startPosition
SampleTimeline(\bla2).selection_cursor.startPosition == SampleTimeline(\bla2).selection_cursor.endPosition
SampleTimeline(\bla2).tempoClock
SampleTimeline(\bla2).bufferInfo.bufferData
SampleTimeline(\bla2).buffer
SampleTimeline(\bla2).askBufferData
SampleTimeline(\bla2).bufferInfo.bufferData = nil
SampleTimeline(\bla2).clear
SampleTimeline(\bla2).presetCompileString.editorInsert
SampleTimeline.proto.recordDirectory
NoteTimeline(\bla).edit
BufDef(\rocksteady, "vipere/rocksteady.flac")
BufDef(\rocksteady).clear
(
SampleTimeline('bla2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 12.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('bla2').buffer = BufDef(\rocksteady, "vipere/rocksteady.flac");
);

ClipTimeline(\clip).edit
(
ClipTimeline('clip').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('clip').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 2.0, \dur: 6.0, \legato: 1, \midinote: 1.0, \playDur: 6.0, \relDur: 6.0, \sustain: 5.5, \timeline: { SampleTimeline('bla2') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

);

SampleTimeline(\mysample, BufDef(Platform.resourceDir +/+ "sounds/a11wlk01.wav")); // create a SampleTimeline with a loaded buffer
SampleTimeline(\mysample).edit; // edit a SampleTimeline named \mysample

// you can load a buffer from the GUI, or from the code with:
SampleTimeline(\mysample).buffer = BufDef('/path/to/my/sample2.wac');


(
Pdef(\test, 
	Pseq([
		SampleTimeline(\mysample).asPattern(nil,nil,1), // play from start to end cursors and repeat 1 time
		SampleTimeline(\mysample).asPattern(0,1,2), // play from beat 0 to beat 1 and repeat 2 times
		SampleTimeline(\mysample).asPatternAbs(0,1,2), // same but 0 is start of buffer instead of start cursor
	],1),
).play;
)
Buffer
(
Pdef(\zed, 
	Pseq([
		SampleTimeline(\bla2).asPattern(nil,nil,1), // play from start to end cursors and repeat 1 time
		SampleTimeline(\bla2).asPattern(0,1,2), // play from beat 0 to beat 1 and repeat 2 times
		SampleTimeline(\bla2).asPatternAbs(0,1,2), // same but 0 is start of buffer instead of start cursor
	],1),
).play;
);

(
Pdef(\zed, 
	Pseq(
		( 8*4 ).collect { arg x; SampleTimeline(\bla2).asPatternAbs(0+( x/4 ),(x+1)/4 ,x+1) }, inf
	)
).play;
);
(
Pdef(\zed, 
	Prand(
		( 8*4 ).collect { arg x; SampleTimeline(\bla2).asPatternAbs(0+( x/4 ),(x+1)/4 ,1) }, inf
	)
).play;
);
(
Pdef(\zed, 
	Pindex(
		( 8*4 ).collect { arg x; SampleTimeline(\bla2).asPatternAbs(0+( x/4 ),(x+1)/4 ,1) },
		Prand((0..8*4),inf).stutter(2)
	)
).play;
);



SampleTimeline('bla2').buffer = BufDef(\rocksteady, "vipere/rocksteady.flac");
SampleTimeline('bla2').edit
