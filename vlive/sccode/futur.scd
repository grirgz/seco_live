(
s.waitForBoot({

	SynthDef(\singer, {
		| out=0, freq=440, amp=0.5, vibrato=6|
		var lfo, lfo2, lfo3, sig;
		lfo = SinOsc.kr(1/5, 0).range(250,1000);
		lfo2 = SinOsc.kr(1/5, 0).range(0.1,0.9);
		lfo3 = SinOsc.kr(vibrato).range(0.3, 1);
		sig = lfo3*RLPF.ar(in:VarSaw.ar(freq:Lag.ar(in:K2A.ar(freq), lagTime:0.3), iphase:0, width:lfo2, mul:amp), freq:lfo, rq:200/lfo);
		Out.ar(out, sig!2);
	}).add;

	s.sync;

	Pdef.defaultQuant_(0);
	Pdef(\bass, Pmono(\default, \dur, Pwhite(0.01, 0.1, inf), \freq, (Pgbrown(1,8,5) * 20).round(10), \amp, Pbrown(0.2,0.6,0.05)));
	Pdef(\computer, Pmono(\default, \dur, Pwhite(0.01, 0.1, inf), \freq, (Pgbrown(1,8,9) * 100).round(20), \amp, Pbrown(0.2,0.6,0.05)));
	Pdef(\soprano, Pmono(\singer, \dur, Pwhite(0.01, 0.1, inf), \freq, Pgbrown(1,8,0.05) * 200, \amp, Pbrown(0.2,0.6,0.05)/5, \vibrato, Pbrown(4,7,0.125)));
	Pdef(\soprano2, Pmono(\singer, \dur, Pwhite(0.01, 0.1, inf), \freq, Pbrown(3,6,0.1) * 100, \amp, Pbrown(0.2,0.6,0.05)/5, \vibrato, Pbrown(3,8,0.125)));

	fork {
		Pdef(\bass).play;
		10.wait;
		Pdef(\computer).play;
		10.wait;
		Pdef(\soprano).play;
		10.wait;
		Pdef(\soprano2).play;
		10.wait;
		Pdef(\computer).stop;
		20.wait;
		Pdef(\bass).stop;
		10.wait;
		Pdef(\soprano).stop;
		Pdef(\soprano2).stop;
		Pdef(\bass).play;
		Pdef(\soprano).play;
		10.wait;
		Pdef(\soprano2).play;
		10.wait;
		Pdef(\computer).play;
		20.wait;
		Pdef(\bass).stop;
		Pdef(\computer).stop;
		Pdef(\soprano).stop;
		Pdef(\soprano2).stop;
	}

});
)
