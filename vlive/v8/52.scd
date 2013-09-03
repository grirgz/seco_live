~name = \52;

SynthDef(\bass, { arg out=0,freq = 440, amp = 0.2, amp2 = 0.3, atk=0.2, sus=0.5, rel=0.5, ffreq=400, rq=0.3;
	var sig;
	sig = LFSaw.ar((freq), 0.5, amp).distort*4;
	sig = RLPF.ar(sig, ffreq, rq, amp2);
	sig = Pan2.ar(sig,0, EnvGen.kr(Env.linen(atk,sus, rel, 1, 0), doneAction: 2));
	Out.ar (out, sig);
}).add;

BusDef(~name+++\fx, \audio);

Veco(~name).play_node_hook = {
	"playhook".debug;
	Ndef(~name+++\fx).play;
};

Veco(~name).stop_node_hook = {
	Ndef(~name+++\fx).stop;
};


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, \bass,
	//\midinote, Pseq([45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,43,55,43,55,43,55,43,55], inf),
	\dur, 1/8,
	\amp, Pseq([1, 0.75], inf)/8,
	\isRest, Veco(~name).isrest,
	\atk, 0.02,
	\sus, 0.1,
	\out, BusDef(~name+++\fx),
	\rel, 0.01,
));
);

(
Ndef(~name+++\fx, {
	var sig;
	sig = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	sig = FreqShift.ar(sig, SinOsc.kr(1).range(-100,100)) + sig;
	sig = CombL.ar(sig, 0.1,0.01,1) + sig;
	sig;
	
})
);
