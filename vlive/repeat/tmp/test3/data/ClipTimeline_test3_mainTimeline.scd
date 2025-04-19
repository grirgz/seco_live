ClipTimeline('test3_mainTimeline').presetCompileStringSavePath = "repeat/tmp/test3/data/ClipTimeline_test3_mainTimeline.scd";

ClipTimeline('test3_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('test3_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;



