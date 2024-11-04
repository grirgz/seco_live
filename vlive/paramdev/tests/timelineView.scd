
//ParamProto.init
ClipTimeline(\bla).edit
ParamViewToolBox.color_light;
(
	// try to find more clear grid drawing
~mygridx = { arg factor, x, oidx, idx;
	[factor, x, oidx, idx].debug("f, x, oi, i");

	Pen.lineDash = FloatArray[1];
	if( oidx % 16 == 0 ) { 
		Pen.alpha = 0.6;
		Pen.width = 2;
	} { 
		if(oidx % 4 == 0) {
			Pen.alpha = 0.4;
			Pen.width = 1;

		} {
			Pen.alpha = 0.4;
			Pen.width = 1;
			Pen.lineDash = FloatArray[2.0,2.0];
		}
	};


}
)

///////////////////////// Muting tracks
ParamProto.init(true);
~t = 185/4/60; TempoClock.default.tempo = ~t;

ParamProto.init; s.boot;
ClipTimeline(\mumu).edit
\gain.asSpec
Spec.add(\gain, ControlSpec(0,1,\lin,0,1))
ClipTimeline(\mumu).clear
ClipTimeline(\mumu).presetCompileString.editorInsert
(
ClipTimeline('mumu').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': true, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('mumu').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 2.375, \label: 'start', \playDur: 2.375, \relDur: 2.375, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 2.375, \dur: 9.5, \midinote: 2.0, \playDur: 9.5, \relDur: 9.5, \sustain: 2.25, \timeline: { SampleTimeline('rec_mumu_t2_201024_225246') }, \type: 'pattern', )),
	(\absTime: 11.875, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('mumu').recordedEvents = [ PatternEvent((playDur: 9.5, dur: 9.5, sustain: 2.25, midinote: 2.0, timeline: { SampleTimeline('rec_mumu_t2_201024_225246') }, relDur: 9.5, type: 'pattern', absTime: 2.375)) ];

SampleTimeline('rec_mumu_t2_201024_225246').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 6.0, \playDur: 6.0, \relDur: 6.0, \sustain: 0, \type: 'start', ),
	(\absTime: 6.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mumu_t2_201024_225246').buffer = BufDef(\amen, "vipere/amenbreak.wav");


);

SampleTimeline('rec_mumu_t2_201024_225246').clear

(
ClipTimeline('mumu').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': true ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('mumu').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.75, \label: 'start', \playDur: 0.75, \relDur: 0.75, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.75, \dur: 7.25, \legato: 1, \midinote: 1.0, \pattern: Pdef('melo'), \playDur: 7.25, \relDur: 7.25, \sustain: 7.125, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);


(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..10),inf),
		\dur, 1/4,
		\amp, 0.1,
	)
);
);
Pdef(\melo).play






/////////////////////// clip loop

~t = 150/2/60; TempoClock.default.tempo = ~t;
ParamProto.init; s.boot;
ClipTimeline(\zozo).clear; ParamProto.init(true); 

ClipTimeline(\zozo).edit
(
ClipTimeline('zozo').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('zozo').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 2.0, \dur: 12.75, \event_dropdur: 128, \legato: 1, \midinote: 2.0, \playDur: 12.75, \relDur: 12.75, \sustain: 7.125, \timeline: { SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139') }, \type: 'pattern', )),
	(\absTime: 14.75, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 728.0, \label: 'start', \playDur: 728.0, \relDur: 728.0, \sustain: 0, \type: 'start', ),
	(\absTime: 728.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139').buffer = BufDef('./rec_vin31_mainTimeline_t3_201005_152139.wav');


);

SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139').samplePattern(256).play
SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139').samplePattern(256).play
ClipTimeline(\zozo).play
Pembed(ClipTimeline(\zozo).eventList[1]).play



(
Pdef(\zed, 
	Pmono(\SampleTimeline_player,
		\startSeconds, Pseq([256 / ~t, Pn(0,inf)]),
		\bufnum, SampleTimeline(\rec_vin31_mainTimeline_t3_201005_152139).buffer,
		\dur, 1,
		\amp, 0.1,
	).trace,
).play;
);







/////////////////////////////


~ev = Event.default
~ev = PatternEvent.default
~ev.use { ~freq.value }
~ev.use { ~freq.value }
~ev.use { ~startOffset.value }
ClipTimeline(\vin31_mainTimeline).eventList.collect({ arg x; x.event_dropdur.postln; }).select(_.notNil)
FileSystemProject.current.mainTimeline



/////////////////////// selection

~t = 150/2/60; TempoClock.default.tempo = ~t;
ParamProto.init; s.boot;
ClipTimeline(\zozo).clear; ParamProto.init(true); 

ClipTimeline(\zozo).edit
ClipTimeline(\zozo).addHistorySnapshot
ClipTimeline(\zozo).eventLoop.lists.size
ClipTimeline(\zozo).eventLoop.pushList
ClipTimeline(\zozo).eventLoop.cloneAndPushList
ClipTimeline(\zozo).eventList= ClipTimeline(\zozo).eventList.clone
ClipTimeline(\zozo).presetCompileString.editorInsert
(
ClipTimeline('zozo').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('zozo').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 2.0, \dur: 1.0, \event_dropdur: 128, \legato: 1, \midinote: 2.0, \playDur: 1.0, \relDur: 1.0, \sustain: 7.125, \timeline: { SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139') }, \type: 'pattern', )),
	PatternEvent((\absTime: 3.0, \dur: 3.0, \event_dropdur: 129.625, \label: "rec_vin31_mainTimeline_t3_201005_152139-129.6", \legato: 1, \midinote: 1.0, \playDur: 3.0, \relDur: 3.0, \sustain: 1.875, \timeline: { SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139') }, \type: 'pattern', )),
	PatternEvent((\absTime: 6.0, \dur: 8.75, \event_dropdur: 129.625, \label: "rec_vin31_mainTimeline_t3_201005_152139-129.6", \legato: 1, \midinote: 1.0, \playDur: 8.75, \relDur: 8.75, \sustain: 1.875, \timeline: { SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139') }, \type: 'pattern', )),
	(\absTime: 14.75, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 728.0, \label: 'start', \playDur: 728.0, \relDur: 728.0, \sustain: 0, \type: 'start', ),
	(\absTime: 728.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin31_mainTimeline_t3_201005_152139').buffer = BufDef('./rec_vin31_mainTimeline_t3_201005_152139.wav');


);

//// NoteTimeline

ParamProto.init; s.boot;
NoteTimeline(\nono).clear; ParamProto.init(true); 
NoteTimeline(\nono).edit
NoteTimeline(\nono).presetCompileString.editorInsert
(
NoteTimeline('nono').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	(\absTime: 0.5, \dur: 0.0, \midinote: 56.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.125, \midinote: 56.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.0, \midinote: 67.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.25, \midinote: 67.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.0, \midinote: 64.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.125, \midinote: 64.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.0, \midinote: 56.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.125, \midinote: 56.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 1.125, \dur: 0.0, \midinote: 54.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 6.875, \midinote: 54.0, \playDur: 6.875, \relDur: 6.875, \sustain: 0.1, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



///////////////////////


VLayout

(
w = Window.new;
w.bounds = nil;
w.layout = VLayout(
	[Button().states_([["Foo"]]), stretch:1, align:\bottomLeft],
	20,
	[TextView().string_("Bar\nBar\nBar\n"), s:3],
	[nil, s:1]
);
w.front;
)


(
WindowDef(\bla, { arg def;
	VLayout (
		Button.new;
	)
}).front;
)
