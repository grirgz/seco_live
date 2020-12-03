ClipTimeline('testproj8_mainTimeline').presetCompileStringSavePath = "repeat/capsule/testproj8/dataClipTimeline_testproj8_mainTimeline.scd";

ClipTimeline('testproj8_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('testproj8_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8, \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \dur: 0, \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;



