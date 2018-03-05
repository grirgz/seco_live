// ==========
// Synth
// ==========

// Run this block once (it creates the synth) 
(
SynthDef("spacey", { arg freq, amp;
	var snd, env;
	env = Env.perc(level: amp).kr(2);
	snd = LFSaw.ar(freq: freq, mul: env);
	snd = RLPF.ar(
		in: snd,
		freq: LFNoise1.kr(2).range(500, 20000),
		rq: 0.2
	);
	Out.ar(0, snd);
}).add;
)

// ==========
// Patterns
// ==========

// bass line (alternating with a rest)
(
b = Pbind(
	\instrument, "spacey",
	\midinote, Prand([\rest, Pseq([24, 31, 36, 43, 48, 55])], inf),
	\dur, 0.2,
	\amp, 0.5
).play;
)

b.stop;


// middle arpeggio
(
m = Pbind(
	\instrument, "spacey",
	// \midinote, Pseq([60, 63, 67, 74], inf), // compare this line and below 
	\midinote, Pseq([60, Prand([63, 65]), 67, Prand([70, 72, 74])], inf),
	\dur, 0.13,
	\amp, 0.4
).play;
)

m.stop;


// random note melody (5 to 7 notes, from listed notes only)
// note that this one is not infinite
(
r = Pbind(
	\instrument, "spacey",
	\midinote, Prand([74, 75, 77, 79, 81], rrand(5, 7)),
	\dur, 0.13,
	\amp, 0.3
).play;
)




// putting it all together
// note the use of Pbindef (a variation of Pbind that allows you to re-run the code in real time without stopping the sound)
(
Pbindef(\wow,
	\instrument, "spacey",
	\midinote, Pseq([
		// bass run
		Prand([\rest, Pseq([24, 31, 36, 43, 48, 55])]),
		
		// middle part (plays twice)
		Pseq([60, Prand([63, 65]), 67, Prand([70, 72, 74])], 2),
		
		// ending melody of 3 to 9 notes
		Prand([74, 75, 77, 79, 81], rrand(3, 9))
	], inf),
	\dur, 0.13,
	\amp, 0.5
).play;
)

Pbindef(\wow).stop;
Pbindef(\wow).play;
Pbindef(\wow, \dur, 0.2);




// Adding some reverb
Ndef(\rev).play;

// Reverb 1
Ndef(\rev, { ReplaceOut.ar(0, Limiter.ar(Mix(FreeVerb.ar(In.ar(0), mix: 0.5, room: 0.9)))) }).play;

// Reverb 2
(
Ndef(\rev, {
	var snd = In.ar(In.ar(0));
	6.do({ snd = AllpassN.ar(snd, 0.05, [0.05.rand, 0.05.rand], 4) });
	ReplaceOut.ar(0, Limiter.ar(Mix(snd), 0.9))
});
)

// stop reverb
Ndef(\rev).clear(1);
