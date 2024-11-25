////////////////////// test tags
///////// test halo tags
// ok

(
SynthDef(\testtagsys, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\testtagnice, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

SynthDesc(\testtagsys).addTag(\pad).addTag(\nice); // this work, but need to be run again each time we redefine synthdef
SynthDesc(\testtagnice).addTag(\nice); // this work, but need to be run again each time we redefine synthdef


ParamProto.init
WindowDef(\GlobalLibrary_select).front

////////// test TagSpecDef tags
// ok



TagSpecDef(\SynthDefTags).addUnique(\testtagsys -> [\verynice, \ugly]);
TagSpecDef(\SynthDefTags).addUnique(\testtagnice -> [\verynice, \pad]);
TagSpecDef(\SynthDefTags).asDict[\testtagsys]
TagSpecDef(\SynthDefTags).asSet

WindowDef(\GlobalLibrary_select).front

////////// test system objects hidding
// ok



TagSpecDef(\SynthDefTags).addUnique(\Pmod_constant_9_kr -> [\system]);

WindowDef(\GlobalLibrary_select).front(nil,nil,\SynthDef)


////////// test categories

FileSystemProject.load("capsule/PatKitDef_comkit.scd");
(
WindowDef(\GlobalLibrary_select).front(nil, { arg ok;
	ok.debug("ok");
}, [ \Kit ]);
)
(
WindowDef(\GlobalLibrary).front(nil, { arg ok;
	ok.debug("ok");
});
)
ProtoDef(\GlobalLibrary).edit
