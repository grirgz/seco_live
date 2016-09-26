
// http://frodebeats.com/drums

// basic bass drum

(
SynthDef(\basic_bass_drum, { arg out=0, gate=1;
	var adsr_freq, adsr_amp, osc, vca, filter;
	adsr_freq = EnvGen.kr(Env.adsr(0.001,0.01,0.1,0.1), gate, doneAction:0);
	adsr_amp = EnvGen.kr(Env.adsr(0.01,0.01,0.8,0.1), gate, doneAction:2);
	osc = SinOsc.ar(adsr_freq * 500);
	vca = osc * adsr_amp;
	filter = LPF.ar(vca) ! 2;
	Out.ar(out, filter);
}).add;
);

(
Pdef(\kick, 
	Pbind(
		\instrument, \basic_bass_drum,
		\sustain, 0.1,
		\dur, 1,
		\amp, 0.1
	)
).play;
)
