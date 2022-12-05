TrackDef('recgrid').childAt(1, 0).score = ClipTimeline('recgrid.1.0score');


ClipTimeline('recgrid.1.0score').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('recgrid.1.0score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 7.5, \timeline: { SampleTimeline('rec_cave50_mainTimeline_t0_220921_222144') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.5, \midinote: 1.0, \playDur: 0.5, \relDur: 0.5, \sustain: 8.0, \timeline: { SampleTimeline('rec_cave50_mainTimeline_t1_220921_222144') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.5, \dur: 4.0, \legato: 1, \midinote: 2.0, \playDur: 4.0, \relDur: 4.0, \sustain: 2.0, \timeline: { SampleTimeline('recgrid.0.1score') }, \type: 'pattern', )),
	PatternEvent((\absTime: 4.5, \dur: 3.5, \legato: 1, \midinote: 2.0, \playDur: 3.5, \relDur: 3.5, \sustain: 2.0, \timeline: { SampleTimeline('recgrid.0.2score') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

SampleTimeline('rec_cave50_mainTimeline_t1_220921_222144').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 206.0, \label: 'start', \playDur: 206.0, \relDur: 206.0, \sustain: 0, \type: 'start', ),
	(\absTime: 206.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave50_mainTimeline_t1_220921_222144').buffer = BufDef('cliprec/rec_cave50_mainTimeline_t1_220921_222144.wav');
SampleTimeline('recgrid.0.1score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('recgrid.0.1score').buffer = BufDef('/tmp/rec_recgrid.0.1score_220921_225109.wav');
SampleTimeline('rec_cave50_mainTimeline_t0_220921_222144').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 206.0, \label: 'start', \playDur: 206.0, \relDur: 206.0, \sustain: 0, \type: 'start', ),
	(\absTime: 206.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave50_mainTimeline_t0_220921_222144').buffer = BufDef('cliprec/rec_cave50_mainTimeline_t0_220921_222144.wav');
SampleTimeline('recgrid.0.2score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 2.0, \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('recgrid.0.2score').buffer = BufDef('/tmp/rec_recgrid.0.2score_220921_230526.wav');

