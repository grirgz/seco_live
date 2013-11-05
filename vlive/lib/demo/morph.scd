(
~name = "saw";
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=300, rq=0.3;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

)


blend([Env.adsr(0.1,0.1,0.8,0.2)],[Env.adsr(0.7,0.7,0.5,0.4)],0.5).asCompileString


Pdef(~name).play;


(
// preset 1

~a = Pdef(~name, ~morph.(\bla, 2.1, Pbind(
	\freq, 100,
	\ffreq, 1300,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));

);

(
// preset 2

~a = Pdef(~name, ~morph.(\bla, 1, Pbind(
	\freq, 1500,
	\ffreq, 200,
)) <> Pbind(
	\instrument, ~name,
	\dur, 1,
));

);
