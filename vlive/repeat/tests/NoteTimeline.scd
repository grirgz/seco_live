
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
