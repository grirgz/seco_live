
TrackTimeline(\bla2, TrackDef(\tlist))
TrackTimeline(\bla2).edit
TrackTimeline(\bla2).recorder
TrackTimeline(\bla2).clear
TrackTimeline(\bla8).tracks
PlayerWrapperGroup(TrackDef(\tlist).children)
TrackDef(\tlist).children.collect({ arg x; x.asCompileString.postln })
TrackDef(\tlist).children.collect({ arg x; PlayerWrapper(x.debug("dddd")) })

TrackDef(\tlist, TrackTemplateDef(\TrackList))
TrackDef(\tlist).edit
TrackDef(\tlist).childAt(0).changed(\play)
TrackDef(\tlist).childAt(0,0).changed(\play)
TrackDef(\tlist).clear
TrackDef(\tlist).children[0].children
ParamProto.init(true)

PlayerWrapper(TrackDef(\tlist).childAt(0))

ProtoDef(\GlobalLibrary).targetToLibId(Pdef(\bla))
ProtoDef(\GlobalLibrary).targetToLibId(TrackDef(\tlist).childAt(0).childAt(0))

TrackDef(\tlist).childAt(0).childAt(0).eventType
TrackDef(\tlist).childAt(0).childAt(0).key

	PlayerEvent((\absTime: 0.75, \clockTime: 62.226662798, \dur: 3.506503294, \midinote: 0.0, \playDur: 3.506503294, \receiver: { PlayerWrapper(TrackDef('tlist').childAt(0)) }, \relDur: 3.506503294, \sustain: 2.375, \type: 'player', )).play
PlayerWrapper(TrackDef('tlist').childAt(0)).playNow
TrackDef('tlist').childAt(0).playNow
TrackDef('tlist').childAt(0).play
PlayerWrapper(TrackDef('tlist').childAt(0)).stopNow

TrackTimeline(\bla2).recorder.startRecording
TrackTimeline(\bla2).recorder.stopRecording
TrackTimeline(\bla2).tracks[0].play
TrackTimeline(\bla2).tracks[0].stop
TrackTimeline(\bla2).presetCompileString.editorInsert
(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackDef('tlist').childAt(0)) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.75, \label: 'start', \playDur: 0.75, \relDur: 0.75, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.75, \clockTime: 62.226662798, \dur: 3.506503294, \midinote: 0.0, \playDur: 3.506503294, \receiver: { PlayerWrapper(TrackDef('tlist').childAt(0)) }, \relDur: 3.506503294, \sustain: 2.375, \type: 'player', )),
	(\absTime: 4.256503294, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

TrackTimeline(\bla2).eventList[1].receiver.target.index
TrackTimeline(\bla2).eventList[1].receiver.target.parentTrack
(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackTemplateDef('InstrumentTrack')) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.25439013799996, \label: 'start', \playDur: 0.25439013799996, \relDur: 0.25439013799996, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.25439013799996, \clockTime: 528.454390138, \dur: 111.641108515, \midinote: 0, \playDur: 111.641108515, \receiver: { PlayerWrapper(TrackTemplateDef('InstrumentTrack')) }, \relDur: 111.641108515, \sustain: 3.387038766, \type: 'player', )),
	(\absTime: 111.895498653, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackTemplateDef('InstrumentTrack')) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \label: 'start', \relDur: 0.25439013799996, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.25439013799996, \clockTime: 528.454390138, \midinote: 0, \receiver: { PlayerWrapper(TrackTemplateDef('InstrumentTrack')) }, \relDur: 0.25439013799996, \sustain: 3.387038766, \type: 'player', )),
]);
 }.value;




);

TrackTimeline(\bla2).recorder.eventList
(
TrackTimeline('bla2').tracks = PlayerWrapperGroup[ PlayerWrapper(TrackTemplateDef('InstrumentTrack')) ];
{
TrackTimeline('bla2').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8, \label: 'start', \playDur: 8, \relDur: 8, \sustain: 0, \type: 'start', ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

(
Pdef(\bla, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,3,2,1],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);
TrackTimeline(\xoo, PlayerWrapperGroup([Pdef(\bla)])).edit
