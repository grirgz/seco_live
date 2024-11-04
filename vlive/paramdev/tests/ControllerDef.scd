
k = MKtl('nektar');
k = MKtl('icon');
k.postElements;
ProtoDef(\piano).startControl(Pdef(\melo))
FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
TrackDef(\pdefgrid).edit
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));

ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, [\delay, \delay2]);
ProtoDef(\apc40).activate_bank_selector
MKtl.find(\midi); // when was not connected

Modality	


(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
}, noteNum:8);
)
MIDIdef.trace

MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	PlayerWrapper(Pdef(\help)).togglePlay; // togglePlay method is added by PlayerWrapper
}, noteNum:8);
k = MKtl('icon', "icon-icontrols");
~icon_map_param.(MKtl('icon')[\kn][0], Param(Ndef(\rdn), \delay));
k[\kn].collect({ arg k; k })
k[\kn][0]
k.postElements;
TagSpec

MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	PlayerWrapper(Pdef(\help)).playNow
}, noteNum:59);
MIDIdef.noteOff(\track1_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	PlayerWrapper(Pdef(\help)).stopNow
}, noteNum:59);

(
SynthDef(\saw_help, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.5,4,\lin, 0, 1)
))).add;

Pdef(\help, 
	Pbind(
		\instrument, \saw_help,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;

MIDIdef.cc(\knob1, { arg val, channel, deviceId;
	[ val, channel, deviceId ].debug;
	Param(Pdef(\help), \lpfr).normSet(val/127); // normSet automatically map from 0..1 according to the spec of the param
}, 16); // change your midi cc number for your first knob
)

/////////////////////////




/////////////////////////////////////
///// write doc examples

(
// midi keyboard is pretty generic, every controller should work
ControllerDef(\piano_generic, { arg def, target; 
		var playergroup;
		playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
		MIDIdef.noteOn(\piano, { arg ... args;
			var midinote = args[1];
			args.debug("generic on");
			playergroup.elAt(midinote).play;
		});
		MIDIdef.noteOff(\piano_off, { arg ... args;
			var midinote = args[1];
			args.debug("generic off");
			playergroup.elAt(midinote).stop;
		});
});
// but maybe you have several MIDI keyboards and want to select a different for differents GUI
ControllerDef(\piano_nektar, { arg def, target; // do not forget first argument is self
		var playergroup;
		playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
		MIDIdef.noteOn(\piano, { arg ... args;
			var midinote = args[1];
			args.debug("on");
			playergroup.elAt(midinote).play;
		}, srcID:~nektar_device_id);
		MIDIdef.noteOff(\piano_off, { arg ... args;
			var midinote = args[1];
			args.debug("off");
			playergroup.elAt(midinote).stop;
		}, srcID:~nektar_device_id);
});
TagSpecDef(\controller_piano).addUnique(\piano_generic -> ControllerDef(\piano_generic));
TagSpecDef(\controller_piano).addUnique(\piano_nektar -> ControllerDef(\piano_nektar));
)









