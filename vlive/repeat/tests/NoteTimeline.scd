
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
FileSystemProject.load("capsule/PatKitDef_ksh.scd")
KitTimeline(\bla, PatKitDef(\ksh2)).edit
NoteTimeline(\bla).wrapper.elAt(0)
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

(
Pdef(\mono, 
	PmonoArtic(
		 \monobo,
		 \legato, 1,
	)
);
);

(
SynthDef(\monobo, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(XLine.ar(0.1,1000,2)) * 0.51 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

NoteTimeline(\mono, Pdef(\mono)).edit


//////////////////////////////////////// test recording with scripted midi input


//// draft
//m = MIDIOut(0, MIDIClient.destinations[0].uid)
m = MIDIOut(0, MIDIClient.destinations[2].uid)
m.noteOn(0, 60, 60);
m.noteOff(0, 60, 60);
m.uid
MIDIClient.destinations.do(_.postln)
{ SinOsc.ar(500) ! 2 * 0.1}.play;
m.uid = 123;
m.noteOn(16, 61, 60);
m.allNotesOff(16);
ProtoDef(\piano).stopControl(Pdef(\melo))

(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug("track1 debug");
	
});
)


// see libdef/controllers.scd


(
MIDIdef.noteOn(\piano, { arg ... args;
	//var midinote = args[1];
	args.debug("fakepiano on");
	//playergroup.elAt(midinote).play;
}).fix;
)

/////// test 1
// init midi F4-j


(
ControllerDef(\fakepiano, { arg def, target; 
		var playergroup;
		"FAKEPIANO GO!".debug;
		playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
		~sc_device_id = 8388613;
		MIDIdef.noteOn(\piano, { arg ... args;
			var midinote = args[1];
			args.debug("fakepiano on");
			playergroup.elAt(midinote).play;
		}, srcID: ~sc_device_id).fix;
		MIDIdef.noteOff(\piano_off, { arg ... args;
			var midinote = args[1];
			args.debug("fakepiano off");
			playergroup.elAt(midinote).stop;
		}, srcID: ~sc_device_id).fix;
}, [ \piano ]);
)
ControllerDef(\fakepiano).startControl( NoteTimeline(\testmidi) )

m = MIDIOut(0, MIDIClient.destinations[2].uid); // connect to sc midi port 0
m.noteOn(0, 60, 60); // should hear the note
m.noteOff(0, 60, 60);

NoteTimeline(\testmidi).edit; // selecting fakepiano and recording should work



////// test 2


(
Tdef(\testsendmidi, {
	m = MIDIOut(0, MIDIClient.destinations[2].uid); // connect to sc midi port 0
	10.do { arg i;
		m.noteOn(0, 60+i, 60); // should hear the note
		1.wait;
		m.noteOff(0, 60+i, 60);
	};
	
});
Tdef(\testsendmidi).play;
)
Tdef.defaultQuant


//// test 0
// push nektar key same time as kick and see if it's one the line


FileSystemProject.load("sndlib/buflib.scd");
FileSystemProject.load("libdef/synthplayrec.scd"); // playersec
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1579].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

NoteTimeline(\testmidi).edit; 
