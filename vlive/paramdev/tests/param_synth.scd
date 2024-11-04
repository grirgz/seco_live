
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	adsr: ParamEnvSpec.adsr,
	lpfr: \unipolar,
	spread: ControlSpec(0.001,1,\exp),
))).add;
);

GroupDef(\midigroup);
~synth = Synth(\saw, [\freq, 80], GroupDef(\midigroup));


Param(~synth, \freq).set(100);
Param(~synth, \freq).edit
Param(GroupDef(\midigroup), \freq).edit
Param(~synth, \freq).getVal
Param(~synth, \freq).wrapper
Param(~synth, \freq).default
Param(~synth, \freq).target.getSynchronous(\freq)
~synth.methods


//////// elegant MIDI auto gui
// drawback: no bus to change running synth

(
	~noteTable = nil!128;
	~paramModel = IdentityDictionary.new;
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	if(~noteTable[noteNum].notNil) {
		~noteTable[noteNum].release;
	};
	~noteTable[noteNum] = Synth(\saw, [\freq, noteNum.midicps, \amp, velocity/127/10 +0.05] ++ ~paramModel.asPairs);
});
MIDIdef.noteOff(\track1_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	if(~noteTable[noteNum].notNil) {
		~noteTable[noteNum].release;
		~noteTable[noteNum] = nil;
	};
});
)

SynthDesc(\saw).asParamGroup(~paramModel).selectCustomParams.edit


/////////////// group solution
// problem with updating the group
// and param values are stored nowhere
// no need for bus



//////////////// 
