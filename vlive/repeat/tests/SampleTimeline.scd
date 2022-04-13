


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


////////////// test length of waveform with tempo

~t = 1.3; TempoClock.default.tempo = ~t;


// record with tempo=1 with one kick per beat, waveform is expected length of 8 beats
~t = 1; TempoClock.default.tempo = ~t;


// record with tempo=2 with one kick per beat, waveform is 1/4 of expected length, end marker is a 8 beat like expected
~t = 2; TempoClock.default.tempo = ~t;

// record with tempo=4 with one kick per beat, waveform is 1/16 of expected length, end marker is a 8 beat like expected
~t = 4; TempoClock.default.tempo = ~t;

// hypothesis: length = 1/~t/~t = 1/4/4 = 1/16

(
Pdef.defaultQuant = 4;
FileSystemProject.load("sndlib/buflib.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
)
(
Pdef(\zed, 
	Pbind(
		\instrument, \playersec,
		//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\bufnum, ~buflib.kick[1010].value,
		\isRest, Pseq([
			1,
		],inf).coin.not,
		\dur, 1,
		\gain, 0.4,
	),
).play;
);

SampleTimeline(\testempo).edit

//// bug with preview of SampleTimeline waveform in ClipTimeline

ClipTimeline(\test).edit
ClipTimeline(\test).presetCompileString.editorInsert
(
ClipTimeline('test').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('test').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \legato: 1, \midinote: 0.0, \playDur: 8.0, \relDur: 8.0, \sustain: 9.0, \timeline: { SampleTimeline('amen') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

SampleTimeline('amen').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 6.9866666666667, \playDur: 6.9866666666667, \relDur: 6.9866666666667, \sustain: 0, \type: 'start', ),
	(\absTime: 6.9866666666667, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('amen').buffer = BufDef('amen', "vipere/amenbreak.wav");


);


SampleTimeline(\amen).buffer = BufDef(\amen2, "vipere/amenbreak.wav");
SampleTimeline(\amen).edit

(
SampleTimelineView.mydraw = { arg xthis;
	
		var bounds = xthis.virtualBounds;
		var height = bounds.height;
		var width = bounds.width;
		var viewport = xthis.viewport;
		var waveformImage = xthis.waveformImage;
		var bufferDuration = xthis.bufferDuration;
		var visiblebounds;
		var parentTimeline = xthis.parentTimeline; // defined in preview mode
		var draw_width, draw_height;
		var areasize = xthis.areasize;
		var tempo = xthis.clock.tempo;
		//debug("blaaa");
		if(waveformImage.notNil) {
			// xfactor is displayedSeconds/totalSeconds * imageWidth
			//var xfactor = this.areasize.x / ( bufferDuration / this.clock.tempo ) * waveformImage.width; // bug
			var xoffset, image_portion_width;
			var yoffset, image_portion_height;
			var viewport_left, viewport_width;
			var viewport_top, viewport_height;
			var xfactor, yfactor;

			// in preview mode, draw_width is the clip width
			// in SampleTimeline, it is areasize.x
			draw_width = if(parentTimeline.notNil) {
				parentTimeline.pixelRectToGridRect(bounds).width;
				areasize.x;
			} {
				areasize.x;
			};

			//Pen.drawImage(Point(0,0), waveformImage, bounds);

			// in SampleTimeline, bounds is always equal to visible area
			// in ClipTimeline node preview, bounds is the rect of the node, so can be outside window
			// if clip is not visible, visiblebounds.width is negative
			visiblebounds = if(parentTimeline.notNil) { 
				parentTimeline.virtualBounds.sect(bounds);
			} {
				bounds;
			};

			// compute width of image (fromRect):
			// xfactor: clip_width_in_beats / buffer_duration_in_beats
			//		if the clip is half the buffer duration, total width should be halved	
			// visibility_ratio = visible_bounds / clip_bounds
			//		is equivalent to viewport.width
			// 		if half of the clip is out of parent bounds, total width should be halved
			// w = image.width * xfactor * visibility_ratio
			xfactor = draw_width / ( bufferDuration * tempo ); 
			viewport_width = if(parentTimeline.notNil) {
				(visiblebounds.width / bounds.width);
				viewport.width;
			} {
				viewport.width;
			};
			image_portion_width = waveformImage.width * xfactor * viewport_width;

			//[bounds, visiblebounds, xthis.parentTimeline.virtualBounds].debug("bounds");

			// xoffset: if clip is ahead of parent left border, visiblebounds.left > bounds.left
			// xoffset should be 0, 
			// else should be visiblebounds.left - bounds.left * some_factor
			// if clip start a parentbound 0, and viewport j
			// bound offset: (visiblebounds.left - bounds.left)
			//		if left border of clip is visible, is 0
			//		if the first 100 pixels of the clip are hidden, is 100
			// ratio left offset: (visiblebounds.left - bounds.left) / bounds.width
			//		is equivalent to viewport.origin.x
			//		if left clip border is visible, is 0
			//		if half of clip is hidden, is 1/2
			//		if only last pixel of clip is visible, is 0.999
			//		if clip hidden far in the left, is > 1
			// xoffset = image.width * xfactor * ratio_left_offset
			viewport_left = if(parentTimeline.notNil) {
				(visiblebounds.left - bounds.left) / bounds.width;
			} {
				viewport.origin.x;
			};
			xoffset = waveformImage.width * xfactor * viewport_left;

			/////

			draw_height = if(parentTimeline.notNil) {
				parentTimeline.pixelRectToGridRect(bounds).height
			} {
				areasize.y;
			};
			yfactor = 1;
			viewport_top = if(parentTimeline.notNil) {
				(bounds.bottom - visiblebounds.bottom) / bounds.height;
			} {
				viewport.origin.y;
			};
			//viewport_top.debug("viewport_top");
			viewport_height = if(parentTimeline.notNil) {
				(visiblebounds.height / bounds.height)
			} {
				viewport.height;
			};

			image_portion_height = waveformImage.height * viewport_height;
			yoffset = waveformImage.height * viewport_top;


			//Rect(0,0,10,10).sect(Rect(100,100,10,10))
			//Rect(100,100,10,10).sect(Rect(0,0,10,10))

			waveformImage.drawInRect(visiblebounds, Rect(
				xoffset,
				yoffset,
				image_portion_width, 
				image_portion_height
			).flipScreen(waveformImage.height));
		} {
			Log(\Param).debug("drawImageWaveform: waveformImage is nil");
		}
}
)



~r = Rect(0,0,10,10)
~r.top
~r.bottom
~r.origin.y

ParamTimeline(\bli).edit

(
WindowDef(\win, { arg def;
	VLayout (
		View.new.background_(Color.red),
		View.new.background_(Color.white.lighten(Color.red, 0.2)),
	)
}).front;
);

~t
~t = 185/4/60; TempoClock.default.tempo = ~t;
ClipTimeline(\test).edit
ClipTimeline(\grand).edit
Log(\Param).level =  \debug
ClipTimeline(\geant).edit
ClipTimeline(\test).presetCompileString.editorInsert
(
ClipTimeline('test').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('test').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 9.0, \timeline: { SampleTimeline('amen') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \legato: 1, \midinote: 1.0, \playDur: 8.0, \relDur: 8.0, \sustain: 8.875, \timeline: { NoteTimeline('testnote') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

SampleTimeline('amen').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 6.9866666666667, \playDur: 6.9866666666667, \relDur: 6.9866666666667, \sustain: 0, \type: 'start', ),
	(\absTime: 6.9866666666667, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
BufDef(\amen2, "vipere/amenbreak.wav");
SampleTimeline('amen').buffer = BufDef('amen2');

NoteTimeline('testnote').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \midinote: 35.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.625, ),
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 19.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.375, ),
	(\absTime: 0.125, \dur: 0.875, \midinote: 49.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.5, ),
	(\absTime: 1.0, \dur: 0.625, \midinote: 56.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.625, ),
	(\absTime: 1.625, \dur: 0.75, \midinote: 42.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.5, ),
	(\absTime: 2.375, \dur: 0.625, \midinote: 57.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.5, ),
	(\absTime: 3.0, \dur: 0.875, \midinote: 42.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.625, ),
	(\absTime: 3.875, \dur: 0.5, \midinote: 69.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4.375, \dur: 0.75, \midinote: 60.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.75, ),
	(\absTime: 5.125, \dur: 0.5, \midinote: 76.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.625, ),
	(\absTime: 5.625, \dur: 0.875, \midinote: 67.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.625, ),
	(\absTime: 6.5, \dur: 0.125, \midinote: 78.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.625, ),
	(\absTime: 6.625, \dur: 0.75, \midinote: 71.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.875, ),
	(\absTime: 7.375, \dur: 0.125, \midinote: 89.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.625, ),
	(\absTime: 7.5, \dur: 0.5, \midinote: 83.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

);


NoteTimeline(\testnote).edit
NoteTimeline(\testnote).presetCompileString.editorInsert
(
);


///////////////////////////////////
// test SampleTimelineTrack recorderView


FileSystemProject.load("libdef/CustomTrackList.scd");
TrackDef(\tlist, TrackTemplateDef(\CustomTrackList));
TrackDef(\tlist).edit
TrackDef(\tlist).showRecorderView
TrackDef(\tlist).childAt(0,1).togglePlay
TrackDef(\tlist).childAt(0).recorderView

(
Pdef(\part, 
	Pbind(
		\instrument, \default,
		\degree, Pwhite(0,12,inf),
		\dur, 1,
		\amp, 0.1,
		\out, BusDef(\trackMixerDef_record_fxmixer1, \audio),
	)
).play;
);

TrackDef(\fx, TrackTemplateDef(\playergrid))
TrackDef(\fx).edit
TrackDef(\fx).clear
TrackDef(\fx).childAt(0,0).source
		TagSpecDef(\ProtoPlayer).addUnique(\rdn -> ProtoDef(\rdn));
		TagSpecDef(\ProtoPlayer).addUnique(\rdn2 -> ProtoDef(\rdn2));
		TagSpecDef(\ProtoPlayer).addUnique(\rdn3 -> ProtoDef(\rdn3));
		TagSpecDef(\ProtoPlayer).addUnique(\rdn4 -> ProtoDef(\rdn4));


TrackTimeline(\tlist_rec, TrackDef(\tlist)).edit
ClipTimeline(\testrec).edit
ParamTimeline(\rdn_delay).edit



SampleTimeline(\ttt).edit
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,3,2,1],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

////////////////////////////////
// test tempo change


SampleTimeline(\bla).edit
SampleTimeline(\bla).buffer = BufDef('cliprec/rec_cave38rec.0.3score_220412_200517.wav');
SampleTimeline(\bla).presetCompileString.editorInsert
~t = 1; TempoClock.default.tempo = ~t;
(
SampleTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('bla').buffer = BufDef('cliprec/rec_cave38rec.0.3score_220412_200517.wav');
);

