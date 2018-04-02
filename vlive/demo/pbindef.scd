

(
Pdef(\plop, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..40),inf),
		\degree, Pseq([
			7,0,3,0,
		],inf),
		\mtranspose, Pstep(Pseq([
			0,2,5,7,
		],inf),1),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);


// this restart the pattern
Pbindef(\plop, \isRest, true)
Pbindef(\plop, \isRest, nil)

// this restart the pattern
Pbindef(\plop, \muter, Rest(1),)
Pbindef(\plop, \muter, nil)

///////////////////////

(
Pdef(\plop, 
	Pbind(
		\isRest,
	)
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..40),inf),
		\degree, Pseq([
			7,0,3,0,
		],inf),
		\mtranspose, Pstep(Pseq([
			0,2,5,7,
		],inf),1),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

//////////////////

(
SynthDef("Pdefhelp", { arg out, freq, sustain=1, amp=1, pan;
    var env, u=1;
    env = EnvGen.kr(Env.perc(0.03, sustain), 1, doneAction: Done.freeSelf);
    5.do { var d; d = exprand(0.01, 1); u = SinOsc.ar(d * 300, u, rrand(0.1,1.2) * d, 1) };
    Out.ar(out, Pan2.ar(SinOsc.ar(u + 1 * freq, 0, amp * env), pan));
}).add;
)
s.boot;


x = PbindProxy.new;
x.set(\instrument, \Pdefhelp);

x.play;

x.set(\degree, Pseq([0, 2, 5b, 1b], inf));
x.set(\dur, 0.1);
x.set(\degree, Pseq([1b, 5, 3, 1b, 6, 2, 5, 0, 3, 0, 2], inf));
x.set(\legato, Prand([1.0, 2.4, 0.2], inf), \mtranspose, -3);
x.set(\mtranspose, nil); // remove key

x.set(\degree, Pseq([1, 2, 3, 4, 5, 6], 1));
x.play;

x.set( \degree, Pseq([1, 2, 3, 4, 5, 6], 3), \dur, 0.02);
x.play;

x.set(\degree, Pseq([1, 2, 3, 4, 5, 6], 3), \dur, 0.1);
x.play;


// embed in other patterns:
(
x.set(\degree, Pseq([1b, 5, 3, 1b, 6, 2, 5, 0, 3, 0, 2], inf));
Ppar([
x,
Pbindf(x, \ctranspose, 4)
]).play;
)

x.at(\legato).quant =1/4;
x.set(\legato, 0.9)
x.set(\legato, 0.1)

x.set(\degree, Pseq([1b, 5, 1b, 4, 0], inf), \dur, 0.4);



PbindefDictionary(\pbass, 
	Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, 1,
		\amp, 0.1,
	),
)

PbindefDictionary(\pbass)[0] // default
PbindefDictionary(\pbass)[1]
PbindefDictionary(\pbass)[-1].set(\fmr, Pseq([1,0]))


////////////////////////////////////////////////

// Pmono

(
SynthDef(\longboy, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * XLine.kr(4,1,1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pdef(\post, Pbind()) <>
		Pmono(\longboy,
			\note, Pseq([
				0, 1, 3,
			],inf),
			\diff, 0.01,
			\dur, 1,
			\lpfr, 1,
			\amp, 0.1,
		) <>
		Pdef(\pre, Pbind())

		
	])
)).play;
)

(
	// work, change without restarting the synth
	// problem: can't overwrite or filter keys
Pdef(\pre, 
	Pbind(
		\lpfr, Pseq([1,0.7,1/2],inf),
	)
);
);

(
	// doesnt work, silent the synth
Pdef(\post, 
	Pbind(
		\lpfr, 2,
	)
);
);

///////////////////
// another approach: no key in Pmono

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\longboy) <>
		Pdef(\post, Pbind()) <>
		Pdef(\pre, Pbind(
			\note, Pseq([
				0, 1, 3,
			],inf),
			\diff, 0.01,
			\dur, 1,
			\lpfr, 1,
			\amp, 0.1,
			
		))

		
	])
)).play;
)

(
	// work, change without restarting the synth
Pdef(\post, 
	Pbind(
		\lpfr, Pseq([1,0.7,1/2],inf),
		\dur, 1/2,
	)
);
);

(
	// work
	Pbindef(\post, \lpfr, Pseq([2,1,1/2,0.2],inf))
)
