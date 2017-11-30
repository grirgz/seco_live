
Pbind(
	\instrument, \,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
);

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Plazy({ Pseq(Array.fill(4, {rrand(0, 4)}).normalizeSum) }).loop,
	\dur, Plazy({ Pseq(Array.fill(4, {rrand(0.1, 1.0)}).normalizeSum) }).loop,
	\amp, 0.1,
)).play;
);

{ 4.do { "lk".postln; } }

f=Pseq([220, 440, 330], 6).asStream; { 4.do { { SinOsc.ar(f.next) * 0.1 }.play } }

SynthDef(\sin, {
	Out.ar(out=)
})

(
SynthDef(\osc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Splay.ar(SinOsc.ar(Pulse.ar([1,2]) * 20, 0, 2) + SinOsc.ar(freq));
	//sig = SinOsc.ar(freq); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pbind(
	\instrument, \default,
	\freq, Pseq([220, 440, 330], 6),
	\dur, 1,
	\amp, 0.1,
).play;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		
	])
)).play;
)
