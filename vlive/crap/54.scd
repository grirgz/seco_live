
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;



	~a.get(\plop, { arg x; ~myenvvar = x });
(
Tdef(\hey, {
	var mylocal = 0;
	var syn;
	syn = Synth(\plop);
	syn.get(\freq, { arg x; mylocal = x });
	100.do {
		mylocal.postln;
		1.wait;
	}
	
}).play;
)

(
{
	var mylocal = 0;
	var syn;
	syn = Synth(\plop);
	syn.set(\freq, 150);
	syn.get(\freq, { arg x; mylocal = x; mylocal.postln; });
	
}.value;
)
