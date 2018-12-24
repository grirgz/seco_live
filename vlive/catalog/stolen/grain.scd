//////////////////////
// GRANULAR SAMPLING
//////////////////////

// Replace path (a string of characters) with a path to a wav or aiff file on your computer 
b = Buffer.readChannel(server: s, path: "/home/ruviaro/Music/wheels-mono.wav", channels: [0]);
b = BufDef.mono(\moeten, "voices/02_moeten.flac")

// Load synthdef
(
SynthDef("grain-asr", {arg buffer, rate = 1, startPos = 0, gate = 1, att = 0.01, rel = 0.1, amp = 1, pan = 0;
	var env, snd;
	env = Env.asr(att, amp, rel).kr(gate: gate, doneAction: 2);
	snd = PlayBuf.ar(1, buffer, rate: rate, startPos: startPos * BufSamples.kr(buffer));
	snd = snd * env;
	Out.ar(0, Pan2.ar(snd, pan));
}).add;
)


// Pattern examples

// Ex. 1
(
Pbind(
	\instrument, "grain-asr",
	\buffer, b,
	\startPos, 0.1, // 0.0=beginning of sample, 0.5=half way into sample, 1.0=end of sample
	\dur, 2,
	\att, 0.001,
	\rel, 1,
	\rate, Pwhite(1, 1.5), // 1=original speed, 0.5=half speed, 2=twice speed, etc.
	// a negative number for \rate makes sound goes backward
	\amp, 0.75,
	\pan, Pwhite(-1.0, 1.0),
	\legato, 1
).play;
)

// Ex. 2
(
Pbind(
	\instrument, "grain-asr",
	\buffer, b,
	\startPos, Pseq([0.04, 0.12, 0.215, 0.78], inf),
	\dur, 1/4,
	\att, 0.001,
	\rel, 0.01,
	\rate, -1, // normal speed, but reverse
	\amp, 0.75,
	\pan, Pwhite(-1.0, 1.0),
	\legato, 0.7
).play;
)

// Ex. 3
(
Pbind(
	\instrument, "grain-asr",
	\buffer, b,
	\startPos, Pseq([0.4, 0.32, 0.6215, 0.8], inf) + Pwhite(0.0, 0.1),
	\dur, 1/4,
	\att, 0.001,
	\rel, 1,
	\rate, Prand([Pn(-2, 4), 1, -4], inf),
	\amp, 0.75,
	\pan, Pwhite(-1.0, 1.0),
	\legato, 1
).play;
)


// EX. 4
(
Pbind(
	\instrument, "grain-asr",
	\buffer, b,
	\startPos, Prand([0.44, 0.32, 0.6215, 0.8], inf),
	\dur, Pwhite(1/19, 1/25),
	\att, 0.001,
	\rel, 0.01,
	\rate, Pn(Pgeom(1, 1.1, 20)),
	\amp, Pwhite(0.2, 0.75),
	\pan, Pwhite(-1.0, 1.0),
	\legato, 1
).play;
)

// Ex. 5
(
Pbind(
	\instrument, "grain-asr",
	\buffer, b,
	\startPos, Pwhite(0.0, 0.1),
	\dur, 1/20,
	\att, 0.1,
	\rel, 0.4,
	\rate, Pseq([1, 5, 3, 3.3], inf),
	\amp, Pwhite(0.02, 0.95),
	\pan, Pwhite(-1.0, 1.0),
	\legato, Pn(Pgeom(0.1, 1.05, 40))
).play;
)
