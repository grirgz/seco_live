ClipTimeline('glu2_mainTimeline').presetCompileStringSavePath = "repeat/gluon/glu2/data/ClipTimeline_glu2_mainTimeline.scd";

ClipTimeline('glu2_mainTimeline').tracks = [ ( 'recordSourceLabel': '0', 'muted': false, 'index': 0, 'recordArmed': true, 
  'recordBus': 0, 'recordSource': 0 ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('glu2_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 1.0, \pattern: Pbindef('clapsrc', ( 'dur': Rest(1.0), 'delta': 1.0 ), 1), \playDur: 0.0, \relDur: 0.0, \sustain: 2.25, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \midinote: 0, \playDur: 8.0, \relDur: 8.0, \sustain: 5.0, \timeline: { SampleTimeline('rec_glu2_mainTimeline_t0_250505_025846') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('glu2_mainTimeline').recordedEvents = [ PatternEvent((playDur: 8.0, dur: 8.0, sustain: 5.0, midinote: 0, timeline: { SampleTimeline('rec_glu2_mainTimeline_t0_250505_025846') }, relDur: 8.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_glu2_mainTimeline_t0_250505_025846').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 5.0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_glu2_mainTimeline_t0_250505_025846').buffer = BufDef('cliprec/rec_rec_glu2_mainTimeline_t0_250505_025846_250505_025846.wav');
SampleTimeline('rec_glu2_mainTimeline_t0_250505_025846').postPatternPreset = (  );


