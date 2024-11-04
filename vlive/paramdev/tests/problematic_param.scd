
// problematic params
// - bus
// - bus.asMap
// - \instrument
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
