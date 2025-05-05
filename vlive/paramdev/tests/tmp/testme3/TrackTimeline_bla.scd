TrackTimeline('bla').presetCompileStringSavePath = "paramdev/tests/tmp/testme3/TrackTimeline_bla.scd";

TrackTimeline('bla').tracks = TrackDef('bla');
{
TrackTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 3.125, \label: 'start', \playDur: 3.125, \relDur: 3.125, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 3.125, \dur: 4.875, \legato: 1, \midinote: 0.0, \playDur: 4.875, \receiver: PlayerWrapper(TrackDef('bla').sectionAt(0)), \relDur: 4.875, \sustain: 2.875, \type: 'player', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;



