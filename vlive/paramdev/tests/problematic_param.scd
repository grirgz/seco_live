
// problematic params
// - bus
// - bus.asMap
// - \instrument

// also test:
// - control bus
// - audio bus
// - stereo bus (when mapped, appear as an array, so can break things)


////////////// test instrument

(
// first define a few synthdef and add them to the tag \mysynthlist
SynthDef(\saw_help, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1)
))).add;
TagSpecDef(\mysynthlist).addUnique(\saw_help);

SynthDef(\pulse, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1)
))).add;
TagSpecDef(\mysynthlist).addUnique(\pulse);

TagSpecDef(\mysynthlist).addUnique(\default); // also add default instrument


// define a pattern
Pdef(\help, 
	Pbind(
		// instrument will be defined by GUI
		\degree, Pwalk((0..20), Pseq((1..12)-2,inf) % Pseq((2..7),inf)),
		\dur, 1/2,
		\amp, 0.1,
	)
);
)

(
// define a GUI and display it to control instrument of the pattern
WindowDef(\help, { arg def;
	VLayout (
		PlayerWrapper(Pdef(\help)).asView,
		Param(Pdef(\help), \instrument, TagSpecDef(\mysynthlist)).asView,
		// asView call asValuePopUpMenu since spec is TagSpec
		// it use param.get which call pdef.getVal
		// since inBusMode is false (detect syntax of mapped bus), it set the value directly
		Param(Pdef(\help), \lpfr, ControlSpec(0.1,5,\lin)).asView,
		nil
	)
}).front;
)




/////////////////////////////////////
(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\pulse, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFPulse.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\modsin, { arg out=0, amp=0.1, gate=1, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.kr(freq).unipolar + 0.5;
	//sig.poll;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.kr(out, sig);
}).add;
);

(
Pdef(\part, 
	Ppar([
		Pdef(\mod, 
			Pbind(
				\instrument, \modsin,
				\freq, 2,
				\out, BusDef(\mod1, \control),
				\dur, 1,
			)
		),
		Pdef(\mod2, 
			Pbind(
				\instrument, \modsin,
				\freq, 12,
				\out, BusDef(\mod2, \control),
				\dur, 1,
			)
		),
		Pdef(\test, 
			Pbind(
				\degree, Pseq([0],inf),
				\dur, 1,
				\amp, 0.1,
			)
		),
	]),
).play;
);

Pdef(\test).get(\lpfr)

(
WindowDef(\problem, { arg def;
	VLayout (
		Param(Pdef(\test), \instrument, TagSpec([\saw, \pulse])).asBusPopUpMenu, // bad name!
		Param(Pdef(\test), \lpfr, TagSpec([BusDef(\mod1, \control), BusDef(\mod2, \control)].collect({ arg x; x.key -> x.asMap }))).asBusPopUpMenu,
		Param(Pdef(\test), \out, TagSpec([0->0] ++ [BusDef(\rout1, \audio), BusDef(\rout2, \audio)].collect({ arg x; x.key -> x }))).asPopUpMenu,
		nil
	)
	
}).front;
)



/////////////
(
s.boot;
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1)
))).add;

Pdef(\melo, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq((1..20),inf) % Pseq((3..15),inf),
		\dur, 1/4,
		\amp, 0.1,
	)
);
)
(
SynthDef(\modulator, { arg out=0, gate=1, freq=1, modScale=1, modBias=0.5;
	var sig;
	sig = SinOsc.kr(freq).unipolar * modScale + modBias;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.kr(out, sig);
}).add;

Pdef(\demo, 
	Ppar([
		Pdef(\mod1, // need a Pdef around Pbind to control it
			Pmono( \modulator,
				\out, BusDef(\mod1, \control),
				\dur, 1,
			),
		),
		Pdef(\mod2, 
			Pmono( \modulator,
				\out, BusDef(\mod2, \control), 
				\dur, 1,
			),
		),
		Pdef(\melo, 
			Pbind(
				\instrument, \saw,
				\degree, Pseq((1..20).mirror,inf) % Pseq((3..15),inf),
				\dur, 1/4,
				\amp, 0.1,
			)
		)
	]),
).play;
)

(
WindowDef(\mywindow, {
	VLayout (
		PlayerWrapper(Pdef(\demo)).asView,
		Param(Pdef(\melo), \lpfr, ParamMappedControlBusSpec()).asValuePopUpMenu, 
		StaticText.new.string_("Mod 1").align_(\center),
		Param(Pdef(\mod1), \freq, \lofreq).asView,
		Param(Pdef(\mod1), \modScale, ControlSpec(0,4,\lin)).asView,
		StaticText.new.string_("Mod 2").align_(\center),
		Param(Pdef(\mod2), \freq, \lofreq).asView,
		Param(Pdef(\mod2), \modScale,  ControlSpec(0,4,\lin)).asView,
		nil
	)
}).front;
)
