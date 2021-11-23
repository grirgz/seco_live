ClipTimeline('cave30_mainTimeline').presetCompileStringSavePath = "repeat/cavern/cave30/data/ClipTimeline_cave30_mainTimeline.scd";

ClipTimeline('cave30_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'muted': false, 'recordBus': 0, 'index': 4, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 5, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 6, 'recordArmed': true, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 7, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 8, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 9, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 10, 'recordArmed': false, 
  'solo': false ) ];
{
ClipTimeline('cave30_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 0.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t0_211105_175033-48", \midinote: 2.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t0_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 0.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t1_211105_175033-48", \midinote: 3.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t1_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 0.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t2_211105_175033-48", \midinote: 4.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t2_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 0.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t3_211105_175033-48", \midinote: 5.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t3_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 0.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t4_211105_175033-48", \midinote: 6.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t4_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 0.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t5_211105_175033-48", \midinote: 7.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 7.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t6_211105_175033-48", \midinote: 8.0, \playDur: 7.0, \relDur: 7.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t6_211105_175033') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 8.0, \label: 'end', \playDur: 8.0, \relDur: 8.0, \type: 'end', ),
	PatternEvent((\absTime: 16.0, \dur: 2.0, \event_dropdur: 5, \label: "rec_cave30_mainTimeline_t6_211105_181014-4", \midinote: 5.0, \playDur: 2.0, \relDur: 2.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014') }, \type: 'pattern', )),
	PatternEvent((\absTime: 18.0, \dur: 2.0, \event_dropdur: 51.0, \label: "rec_mixerRecorder_t2_211105_175033-48-51", \midinote: 4.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.0, \timeline: { SampleTimeline('rec_mixerRecorder_t2_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 20.0, \dur: 1.0, \event_dropdur: 50.0, \label: "rec_mixerRecorder_t5_211105_175033-48-50", \midinote: 7.0, \playDur: 1.0, \relDur: 1.0, \sustain: 2.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 21.0, \dur: 1.0, \event_dropdur: 49.0, \label: "rec_mixerRecorder_t2_211105_175033-48-49", \midinote: 4.0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, \timeline: { SampleTimeline('rec_mixerRecorder_t2_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 22.0, \dur: 0.0, \event_dropdur: 50.0, \label: "rec_mixerRecorder_t5_211105_175033-48-50", \midinote: 7.0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 22.0, \dur: 2.0, \event_dropdur: 5, \label: "rec_cave30_mainTimeline_t6_211105_181014-4", \midinote: 5.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, \timeline: { SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014') }, \type: 'pattern', )),
	PatternEvent((\absTime: 24.0, \dur: 0.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t1_211105_175033-48", \midinote: 4.0, \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t1_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 24.0, \dur: 0.0, \event_dropdur: 50.0, \label: "rec_mixerRecorder_t5_211105_175033-48-50", \midinote: 7.0, \playDur: 0.0, \relDur: 0.0, \sustain: 2.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 24.0, \dur: 2.0, \event_dropdur: 144.0, \label: "rec_mixerRecorder_t6_211105_175033-144", \midinote: 8.0, \playDur: 2.0, \relDur: 2.0, \sustain: 16.0, \timeline: { SampleTimeline('rec_mixerRecorder_t6_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 26.0, \dur: 2.0, \event_dropdur: 50.0, \label: "rec_mixerRecorder_t5_211105_175033-48-50", \midinote: 7.0, \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 28.0, \dur: 4.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t5_211105_175033-48", \midinote: 7.0, \playDur: 4.0, \relDur: 4.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 32.0, \dur: 6.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t2_211105_175033-48", \midinote: 3.0, \playDur: 6.0, \relDur: 6.0, \sustain: 5.0, \timeline: { SampleTimeline('rec_mixerRecorder_t2_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 38.0, \dur: 2.0, \event_dropdur: 92.0, \label: "rec_mixerRecorder_t5_211105_175033-92", \midinote: 7.0, \playDur: 2.0, \relDur: 2.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 40.0, \dur: 2.0, \event_dropdur: 4.0, \label: "rec_cave30_mainTimeline_t6_211105_181014-4", \midinote: 6.0, \playDur: 2.0, \relDur: 2.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014') }, \type: 'pattern', )),
	PatternEvent((\absTime: 42.0, \dur: 4.0, \event_dropdur: 50.0, \label: "rec_mixerRecorder_t5_211105_175033-48-50", \midinote: 7.0, \playDur: 4.0, \relDur: 4.0, \sustain: 2.0, \timeline: { SampleTimeline('rec_mixerRecorder_t5_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 46.0, \dur: 5.0, \event_dropdur: 4.0, \label: "rec_cave30_mainTimeline_t6_211105_181014-4", \midinote: 6.0, \playDur: 5.0, \relDur: 5.0, \sustain: 4.0, \timeline: { SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014') }, \type: 'pattern', )),
	PatternEvent((\absTime: 51.0, \dur: 10.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t1_211105_175033-48", \midinote: 8.0, \playDur: 10.0, \relDur: 10.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t1_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 61.0, \dur: 16.0, \midinote: 3.0, \playDur: 16.0, \relDur: 16.0, \sustain: 12.0, \timeline: { SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014') }, \type: 'pattern', )),
	PatternEvent((\absTime: 77.0, \dur: 23.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t1_211105_175033-48", \midinote: 9.0, \playDur: 23.0, \relDur: 23.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t1_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 100.0, \dur: 12.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t1_211105_175033-48", \midinote: 7.0, \playDur: 12.0, \relDur: 12.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t1_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 112.0, \dur: 11.0, \event_dropdur: 48.0, \label: "rec_mixerRecorder_t1_211105_175033-48", \midinote: 6.0, \playDur: 11.0, \relDur: 11.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_mixerRecorder_t1_211105_175033') }, \type: 'pattern', )),
	PatternEvent((\absTime: 123.0, \dur: 0, \event_dropdur: 32.0, \label: "rec_mixerRecorder_t6_211105_175033-32", \midinote: 5.0, \playDur: 0, \relDur: 0, \sustain: 20.0, \timeline: { SampleTimeline('rec_mixerRecorder_t6_211105_175033') }, \type: 'pattern', )),
]);
 }.value;
ClipTimeline('cave30_mainTimeline').recordedEvents = [ PatternEvent((playDur: 0, dur: 0, sustain: 12.0, midinote: 6, timeline: { SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014') }, relDur: 0, type: 'pattern', absTime: 24.0)) ];

SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 12.0, \label: 'start', \playDur: 12.0, \relDur: 12.0, \sustain: 0, \type: 'start', ),
	(\absTime: 12.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_cave30_mainTimeline_t6_211105_181014').buffer = BufDef('cliprec/rec_cave30_mainTimeline_t6_211105_181014.wav');
SampleTimeline('rec_mixerRecorder_t0_211105_175033').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mixerRecorder_t0_211105_175033').buffer = BufDef('/tmp/rec_mixerRecorder_t0_211105_175033.wav');
SampleTimeline('rec_mixerRecorder_t1_211105_175033').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mixerRecorder_t1_211105_175033').buffer = BufDef('/tmp/rec_mixerRecorder_t1_211105_175033.wav');
SampleTimeline('rec_mixerRecorder_t4_211105_175033').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mixerRecorder_t4_211105_175033').buffer = BufDef('/tmp/rec_mixerRecorder_t4_211105_175033.wav');
SampleTimeline('rec_mixerRecorder_t5_211105_175033').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mixerRecorder_t5_211105_175033').buffer = BufDef('/tmp/rec_mixerRecorder_t5_211105_175033.wav');
SampleTimeline('rec_mixerRecorder_t2_211105_175033').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mixerRecorder_t2_211105_175033').buffer = BufDef('/tmp/rec_mixerRecorder_t2_211105_175033.wav');
SampleTimeline('rec_mixerRecorder_t3_211105_175033').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mixerRecorder_t3_211105_175033').buffer = BufDef('/tmp/rec_mixerRecorder_t3_211105_175033.wav');
SampleTimeline('rec_mixerRecorder_t6_211105_175033').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 184.0, \playDur: 184.0, \relDur: 184.0, \sustain: 0, \type: 'start', ),
	(\absTime: 184.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_mixerRecorder_t6_211105_175033').buffer = BufDef('/tmp/rec_mixerRecorder_t6_211105_175033.wav');

