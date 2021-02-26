
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
FileSystemProject.load("cavern/lib.scd");
)

// END
FileSystemProject.load("capsule/fxheavy.scd");

FileSystemProject(\simpleProject).mainTimeline
WindowDef(\Mai)
ParamProto.init(true)

SCVim.generateTagsFile
Help.gui
SCDoc.findHelpFile("Pdef")
HelpBrowser.openHelpFor("Pdef")
SCDoc.indexAllDocuments(clearCache: false) // regenerate
SCDoc.indexAllDocuments(clearCache: true) // regenerate
SCDoc.renderAll(true)
ParamViewToolBox

ExpandView
{arg base=400, amount=0.5; base * (SinOsc.kr(1) * amount + 1) }.plot(1);
{ SinOsc.ar(500) ! 2 * 0.1}.play;



///////////// auto generate a GUI for a synth controlled by keyboard
// 1) what system is used to listen to piano
//		- synth array with MIDIdef
//		- SeqPlayerGroup
// 2) need to put everything in busmode
// 3) need to reset the stream when changing the Pdef (or setting bus mode) ???
// 4) need to filter unwanted params

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\mysynth, 
	Pbind(
		\instrument, \saw,
		\lpfr, Pkeyd(\velocity, 1.1)
	)
);
);

ParamProto.init
~pgroup = ProtoTemplateDef(\SeqPlayerGroup).new(Pdef(\mysynth));

WindowDef(\PdefEditor).front(Pdef(\mysynth))

(
MIDIdef.noteOn(\piano, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).play;
});
MIDIdef.noteOff(\piano_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).stop;
});
)


	~pgroup.elAt(60).play((velocity:0.7));
	~pgroup.elAt(60).stop;

//////////

~p = Pdef(\mysynth).asStream;
~p = Pdef(\mysynth).asPattern.asStream;
Pdef(\mysynth).asPattern
Pdef(\mysynth).isKindOf(Pattern)
~p.next(())

(
Pdef(\mysynth, 
	Pbind(
		\instrument, \default,
	)
);
);




//////////////

// init quark prototypes, this is not class code. Needed for SeqPlayerGroup and PdefEditor
ParamProto.init; 

// define a pattern
(
Pdef(\mysynth, 
	Pbind(
		\instrument, \default,
	)
);
);

// edit it with the PdefEditor
WindowDef(\PdefEditor).front(Pdef(\mysynth))

// control it with MIDI
(
~pgroup = ProtoTemplateDef(\SeqPlayerGroup).new(Pdef(\mysynth));
MIDIdef.noteOn(\piano, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).play;
});
MIDIdef.noteOff(\piano_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	~pgroup.elAt(noteNum).stop;
});
)
