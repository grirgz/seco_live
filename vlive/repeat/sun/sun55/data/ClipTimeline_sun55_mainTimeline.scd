ClipTimeline('sun55_mainTimeline').presetCompileStringSavePath = "repeat/sun/sun55/data/ClipTimeline_sun55_mainTimeline.scd";

ClipTimeline('sun55_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': BusDef('trackMixerDef_record_mixer0'), 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': BusDef('trackMixerDef_record_mixer1'), 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('sun55_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 100.0, \timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 64.0, \label: 'ghostdrums', \midinote: 0, \playDur: 64.0, \relDur: 64.0, \sustain: 12.0, \timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626') }, \type: 'pattern', )),
	(\absTime: 64.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('sun55_mainTimeline').recordedEvents = [ PatternEvent((playDur: 8.0, dur: 8.0, sustain: 132.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_033928') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 132.0, midinote: 1, timeline: { SampleTimeline('rec_sun55_mainTimeline_t1_240423_033928') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 136.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_034339') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 136.0, midinote: 1, timeline: { SampleTimeline('rec_sun55_mainTimeline_t1_240423_034339') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 88.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_035848') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 24.0, midinote: 0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_040146') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 0.0, dur: 0.0, sustain: 100.0, midinote: 1.0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239') }, relDur: 0.0, type: 'pattern', absTime: 0.0)), PatternEvent((dur: 64.0, absTime: 0.0, playDur: 64.0, midinote: 0, type: 'pattern', relDur: 64.0, timeline: { SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626') }, label: 'ghostdrums', sustain: 12.0)) ];

SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 12.0, \label: 'start', \playDur: 12.0, \relDur: 12.0, \sustain: 0, \type: 'start', ),
	(\absTime: 12.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_sun55_mainTimeline_t0_240423_042626').buffer = BufDef('cliprec/rec_sun55_mainTimeline_t0_240423_042626.wav');
SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 100.0, \playDur: 100.0, \relDur: 100.0, \sustain: 0, \type: 'start', ),
	(\absTime: 100.0, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_sun55_mainTimeline_t0_240423_040239').buffer = BufDef('cliprec/rec_sun55_mainTimeline_t0_240423_040239.wav');

