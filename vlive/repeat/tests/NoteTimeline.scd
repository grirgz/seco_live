
NoteTimeline(\bla).edit

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
).play;
);
ProtoDef(\piano).startControl(Pdef(\melo))

NoteTimeline(\bla).isRecording
NoteTimeline(\bla).startRecording
NoteTimeline(\bla).recorder
NoteTimeline(\bla).recorder.isRecording
NoteTimeline(\bla).recorder.stopRecording
NoteTimeline(\bla).recorder.startRecording
NoteTimeline(\bla).recorder.target


SimpleController(Pdef(\melo)).put(\play, { "kjkjkjk".debug })
Updater
Pdef(\melo).addDependant({ "hkh".debug; })
Pdef(\melo).play
Pdef(\melo).stop


/////////////

// testing recording


NoteTimeline(\bla).edit
NoteTimeline(\bla).param
NoteTimeline(\bla).stopRecording
NoteTimeline(\bla).startRecording
NoteTimeline(\bla).recorder.eventList
NoteTimeline(\bla).recorder.startRecording
NoteTimeline(\bla).recorder.isRecording
NoteTimeline(\bla).recorder.eventLoop.isRecording
NoteTimeline(\bla).recorder.eventLoop.isRecording = true
NoteTimeline(\bla).recorder.eventLoop.startRec
NoteTimeline(\bla).recorder.eventLoop.hash
NoteTimeline(\bla).recorder.hash
NoteTimeline(\bla).recorder.priv_eventLoop
NoteTimeline(\bla).recorder.data_eventLoop = 1
NoteTimeline(\bla).recorder.keys
NoteTimeline(\bla).recorder.isFrozen
NoteTimeline(\bla).recorder.azee = 123
NoteTimeline(\bla).recorder[\data_eventLoop] = 1
NoteTimeline(\bla).recorder.data_eventLoop
NoteTimeline(\bla).recorder.stopRecording
NoteTimeline(\bla).recorder.target
NoteTimeline(\bla).recorder.hash
NoteTimeline(\bla).recorder


NoteTimeline(\bla).keys
NoteTimeline(\bla).blabla = 123
NoteTimeline(\bla).blabla 

NoteTimeline(\bla).blabla = 123
NoteTimeline(\bla).blabla = 123
ProtoTemplateDef(\PlayerGroupRecorder).keys
ProtoTemplateDef(\PlayerGroupRecorder).sdf= 23
ProtoTemplateDef(\PlayerGroupRecorder).sdf
ProtoTemplateDef(\PlayerGroupRecorder).hash
~b = ProtoTemplateDef(\PlayerGroupRecorder).new
~b.hash
~b.blabla = 123
~b.blabla


ProtoDef(\piano).startControl(Pdef(\melo))
NoteTimeline(\bla2).edit
NoteTimeline(\bla2).param = Pdef(\bla2, Pbind(\instrument, \basicbass, \lpf, 3000, \amp, 0.01));
NoteTimeline(\bla3).edit

ClipTimeline(\cc).edit
ClipTimeline(\cc).quant_ref
ClipTimeline(\cc).get_quantx
ClipTimeline(\cc).getHalo(\gridquant)
ClipTimeline(\cc).addHalo(\gridquant, Point(1/2,1))
ClipTimeline(\cc).clipList.clipList
ClipTimeline(\cc).quant
MIDIKeyboardView
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(1) * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

ParamProto.init(true)
