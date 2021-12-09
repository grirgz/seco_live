SynthDef(\pling, {
	var freq = \freq.kr();
	var sig = (SinOsc.ar(freq) * SinOsc.ar(Rand(10,30)) * 0.2) + SinOsc.ar(freq * {Rand(2.91,3.02)}!2);
	var env = EnvGen.ar(Env.perc(\att.kr(0.01), \rel.kr(0.3)), doneAction: 2);
	sig = sig * env * \amp.kr(0.1);
	Out.ar(0, sig ! 2)
}).add;

Pbind(
	\instrument, \pling,
	\dur, Pwhite(0.003,0.05),
	\freq, Pwhite(285,300),
	\amp, Pwhite(0.01,0.1),
	\att, Pwhite(0.001,0.01),
	\rel, Pwhite(0.02, 0.1)
).play
