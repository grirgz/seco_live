
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
