~name = \54;


SynthDef(~name, { arg out=0,freq = 440, amp = 0.2, amp2 = 0.3, atk=0.2, sus=0.5, rel=0.5, ffreq=400, rq=0.3, doneAction=2, gate=1;
	var sig;
	//sig = LFSaw.ar((freq), 0.5, amp);
	sig = LFSaw.ar((freq), 0.5, amp).distort;
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	sig = Splay.ar(sig, 0.8,1,0);
	Out.ar(out, sig);
}).add;


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\midinote, Pseq([45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,45,57,43,55,43,55,43,55,43,55], inf),
	\dur, 1/8,
	\isRest, Veco(~name).isrest,
	\atk, 0.02,
	\sus, 0.1,
	\rel, 0.01,
));
);
