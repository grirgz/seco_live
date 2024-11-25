
ClipTimeline(\bla).edit
ClipTimeline(\bla10).edit
NoteTimeline(\bla3).edit
NoteTimeline(\bla3).eventList
NoteTimeline(\bla).edit
ParamTimeline(\bla).edit
KitTimeline(\bla).edit
TrackTimeline(\bla).edit
ParamTimeline(\bla).isRecording

//////////////// test cliplist

ClipTimeline(\aze1).edit
ClipTimeline(\aze1).presetCompileString.editorInsert
TrackDef(\test, \CustomTrackList).edit
(
ClipTimeline('aze2').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('aze2').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.25, \dur: 7.75, \legato: 1, \midinote: 2.0, \playDur: 7.75, \receiver: PlayerWrapper(NoteTimeline('fds')), \relDur: 7.75, \sustain: 5.75, \type: 'player', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

~ev = PlayerEvent((\absTime: 0.25, \dur: 7.75, \legato: 1, \midinote: 2.0, \playDur: 7.75, \receiver: PlayerWrapper(NoteTimeline('fds')), \relDur: 7.75, \sustain: 5.75, \type: 'player', ))



ClipTimeline(\aze1).clipList.
ClipTimeline(\aze1).edit

NoteTimeline(\df).isKindOf(ProtoClass)
NoteTimeline(\df).eventType
PlayerWrapper(NoteTimeline(\df)).asCompileString
NoteTimeline(\df).asCompileString
ClipTimeline(\aze1).clipList.clipList
ClipTimeline(\aze1).clipList.clipList.last.last.value.edit
~libid = ClipTimeline(\aze2).clipList.clipList.last
PlayerWrapper(ClipTimeline(\aze2).clipList.clipList.last.last.value).edit
TagSpecDef(\TrackListPart).list.first.value.isKindOf(ProtoClass)
TagSpecDef(\TrackListPart).list.first.value.eventType
~libid = [\TrackListPart, TagSpecDef(\TrackListPart).list.first]
~lib.libIdToWrapper(~libid)
~lib.targetToLibId(TagSpecDef(\TrackListPart).list.first.value)
~lib = ProtoDef(\GlobalLibrary)
~lib.clipFactories
~lib
~lib.libIdToTarget(~libid)
~lib.eventToLibId(~ev)

/////////// test preview

SampleTimeline(\sss).buffer = BufDef(\amen, "vipere/amenbreak.wav");
SampleTimeline(\sss).edit
ClipTimeline(\bla).edit;

NoteTimeline(\nono).edit

ClipTimeline(\super).edit




(
ClipTimeline('bla').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.25, \dur: 7.75, \legato: 1, \midinote: 2.0, \playDur: 7.75, \relDur: 7.75, \sustain: 3.125, \timeline: { NoteTimeline('nono') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

NoteTimeline('nono').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 73.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 66.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 60.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.375, \midinote: 54.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.25, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 63.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.375, \midinote: 51.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 47.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);


ClipTimeline(\bla).edit;


);




NoteTimeline(\nono).presetCompileString.editorInsert
ClipTimeline(\bla).presetCompileString.editorInsert

(
NoteTimeline('nono').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 0.125, \midinote: 73.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 66.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 60.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.375, \midinote: 54.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.125, \dur: 0.25, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 63.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.375, \midinote: 51.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 47.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

ClipTimeline('bla').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.25, \dur: 2.75, \legato: 1, \midinote: 2.0, \playDur: 2.75, \relDur: 2.75, \sustain: 3.125, \timeline: { NoteTimeline('nono') }, \type: 'pattern', )),
	PatternEvent((\absTime: 3.0, \dur: 5.0, \legato: 1, \midinote: 1.0, \playDur: 5.0, \relDur: 5.0, \sustain: 4.25, \timeline: { SampleTimeline('sss') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;

SampleTimeline('sss').eventList = TimelineEventList.newFrom([
	(\absTime: 0.375, \dur: 0.625, \label: 'start', \playDur: 0.625, \relDur: 0.625, \sustain: 0, \type: 'start', ),
	(\absTime: 1.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);


);


/////////////////

ClipTimeline(\bla2).edit


////////// test with Ndef

//// Ndef event should stop when stopping timeline
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,4,20);
	sig = SinOsc.ar(freq * lfo1 * ( SinOsc.ar(freq+lfo1 * [1,1/4,1/8]) * lfo1 + 1 ) );
	sig = sig * SinOsc.ar([1,4,8]).unipolar.sum; 
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

ClipTimeline(\bla).edit
ClipTimeline(\bla).presetCompileString.editorInsert
(
ClipTimeline('bla').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('bla').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 0.5, \dur: 7.5, \legato: 1, \midinote: 1.0, \playDur: 7.5, \receiver: PlayerWrapper(Ndef('zed')), \relDur: 7.5, \sustain: 7.5, \type: 'player', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);






~x= ClipTimeline(\bla).eventList[1].play
~x.release;
ClipTimeline(\bla).eventList[1]
ClipTimeline(\bla).eventList[1].playNow
ClipTimeline(\bla).eventList[1].playMethod
ClipTimeline(\bla).eventList[1].stop
ClipTimeline(\bla).eventList[1].stopNow
ClipTimeline(\bla).eventList[1].receiver.play
ClipTimeline(\bla).eventList[1].receiver.reset
ClipTimeline(\bla).eventList[1].receiver.stop
ClipTimeline(\bla).eventList[1].receiver.end
ClipTimeline(\bla).eventList[1]

~x = (note:3, sustain:100).play;
~x.stop
~x.release



/// now test quant


Ndef(\zed).quant = 4
Ndef(\zed).quant = 0
Ndef(\zed).end
Ndef(\zed).play

/////////////


TrackDef(\aa3, \playergrid).edit
TrackDef(\aa3).eventType
TrackDef(\aa3).protoClass
TrackDef(\tt, \CustomTrackList).edit
TrackDef(\aa2).
TagSpecDef(\playergrid).list
ClipTimeline(\aze1).edit


/////////////////////////////////////////
///// stopping clips when stopping ClipTimeline

// problem with stopping ClipTimeline: Ndef doesnt stop

/////// test with Pdef
// no problem because it is a PatternEvent: embeded in stream

(
FileSystemProject.load("libdef/CustomTrackList.scd");
FileSystemProject.load("libdef/PbindefEditor.scd");
)

(
Pdef(\pdeftester, 
	Pbind(
		\instrument, \default,
		//\degree, Pseq([Pwhite(Pseq([Pn(0,7), Pseq((0..24))],inf),32,inf) ],inf) % Pseq((0..32),inf),
		\degree, Pseq((0..32),inf) + Pwhite(0,10,inf).stutter(4) - 5 + Pseq([0,2,4,2, -7,2+7,4-7,2],inf),
		\octave, 3,
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);
