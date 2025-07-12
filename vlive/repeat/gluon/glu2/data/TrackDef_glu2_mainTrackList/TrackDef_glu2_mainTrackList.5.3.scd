

TrackDef('glu2_mainTrackList').childAt(5, 3).score = ClipTimeline('glu2_mainTrackList.5.3score');
ClipTimeline('glu2_mainTrackList.5.3score').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('glu2_mainTrackList.5.3score').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 15.0, \legato: 1, \midinote: 1.0, \pattern: Pdef('hipass1'), \playDur: 15.0, \relDur: 15.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 15.0, \dur: 1.0, \legato: 1, \midinote: 0.0, \pattern: Pdef('trans1'), \playDur: 1.0, \relDur: 1.0, \sustain: 2.0, \type: 'pattern', )),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;



