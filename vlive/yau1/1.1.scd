
(
SynthDef(\yaumixer, {
	var sig;
	sig = In.ar(0,8);
	sig = sig.clump(2);
	sig = sig.mean;
	Out.ar(0,sig);

}).add;
)

Synth.tail(1, \yaumixer)
