// different Ndefs for each parameter eg. 
(
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpfr: ControlSpec(0.1,4,\lin, 0, 1)
))).add;
)


Ndef(\mix, {var mix; mix = Ndef.kr(\lfo).linlin(-1,1,0.05,3.75)});
Ndef(\predelay, {var predelay; predelay = Ndef.kr(\lfo).linlin(-1, 1, 100.05, 700.15)});
Ndef(\lfo, {arg rate=2.5; var lfo; lfo = SinOsc.ar(rate)});


(
	Pdef(\test,
		Pmono(\saw,
			\dur, 1,
			\lpfr, Ndef(\mix).asMap,
			\freq, Ndef(\predelay).asMap,
			\amp, 1
		)
	).play;
)

// Pkey

Ndef(\lfo, {arg rate=0.5; var lfo; lfo = SinOsc.ar(rate).linlin(-1,1,0.05,0.75)});

(
Pdef(\reverbtest,
Pmono(\reverb,
\dur, 1,
\mix, Ndef(\lfo).asMap,
\delaytime, Pkey(\mix.linlin(0.05, 0.75, 0.05, 0.15)),
\in, ~reverbBus,
\amp, 1
)).play;
)


(
p = Pbind(
	\degree, Pwhite(-4, 11, 32),
	\pan, Env([-1, 0, -1], [2, Pseq([1,2],inf)], \sin),
	\dur, 0.125
).play;
)


(
Pdef(\zed, 
	Pmono(\default,
		\freq, 200,
		\dur, inf,
		\amp, 0.1,
	),
).play;
);

Pdef(\zed).stop
