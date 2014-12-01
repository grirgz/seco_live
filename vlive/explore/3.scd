(
SynthDef('snaredrum', {

var drumosc, filterenv, volenv, drumoutput, snaposc, snapenv, fulloutput;

drumosc = {Pulse.ar(50)};
filterenv = {Line.ar(1, 0, 0.2, doneAction: 0)};
volenv = {Line.ar(1, 0, 0.6, doneAction: 2)};
drumoutput = {LPF.ar(drumosc,(filterenv *100) + 30)};

snaposc = {BPF.ar(HPF.ar(WhiteNoise.ar(1),500),1500)};
snapenv = {Line.ar(1, 0, 0.2, doneAction: 0)};

fulloutput = (drumoutput * volenv) + (snaposc * snapenv);
//fulloutput = (drumoutput * volenv);

Out.ar(0,
Pan2.ar(fulloutput, 0)
)

}).add;
)

t = Synth('snaredrum');



(
SynthDef('clap', {

var claposc, clapenv, clapnoise, clapoutput;

clapnoise = {BPF.ar(LPF.ar(WhiteNoise.ar(1),7500),1500)};
clapenv = {Line.ar(1, 0, 0.6, doneAction: 2)};

clapoutput = {Mix.arFill(7,
{arg i;
EnvGen.ar(
Env.new(
[0,0,1,0],
[0.01 * i,0,0.04]
)
) * clapnoise * 0.5
}
)};

Out.ar(0,
Pan2.ar(clapoutput * clapenv, 0)
)

}).add;
)

t = Synth('clap');


// Example
(
Ppar([
Pbind(
\instrument, \hihat,
\dur, Pseq([Rest(1/4), 1/4], inf),
\ffreq, 9000,
\rel, 0.1,
\amp, 0.2
),
Pbind(
\instrument, \kick,
\dur, 1/2,
\amp, 0.9,
\rel, 0.12,
\glissf, 0.99
),
Pbind(
\instrument, \snare,
\dur, Pseq([Rest(1/2), 1/2], inf),
\amp, 0.25,
\rel, 0.1
)
]).play;
)

// Basic drum kit
(
SynthDef(\hihat, {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
var snd = WhiteNoise.ar(amp);
var env = Env.perc(att, rel).kr(doneAction: 2);
snd = HPF.ar(snd * env, ffreq);
Out.ar(out, Pan2.ar(snd, pan));
}).add;
SynthDef(\snare, {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
var snd1 = WhiteNoise.ar(amp);
var snd2 = SinOsc.ar(sinfreq,0,amp);
var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
Out.ar(out, Pan2.ar(sum, pan));
}).add;
SynthDef(\kick, {arg out = 0, amp = 0.3, sinfreq = 60, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
var snd = SinOsc.ar(gliss);
var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
snd = snd * env * amp;
Out.ar(out, Pan2.ar(snd, pan));
}).add;
)

(
Pdef(\drumkit, Ppar([

	Pbind(
		\instrument, \hihat,
		\dur, 1/8,
		\ffreq, 9000,
		\isRest, Pdefn(\hihat),
		\rel, 0.1,
		\amp, 0.2
	),
	Pbind(
		\instrument, \kick,
		\isRest, Pdefn(\kick),
		\dur, 1/8,
		\amp, 0.9,
		\rel, 0.12,
		\glissf, 0.99
	),
	Pbind(
		\instrument, \snare,
		\isRest, Pdefn(\snare),
		\dur, 1/8,
		\amp, 0.25,
		\rel, 0.1
	)
])).play
)

(
Pdefn(\kick, Pseq([
	1,0,0,0, 0,0,0,0,
	0,0,0,0, 0,0,0,0,
	1,0,0,1, 0,0,0,0,
	0,0,0,0, 0,0,0,0,
],inf).coin.not );
Pdefn(\snare, Pseq([
	0,0,0,0, 0,0,0,0,
	1,0,0,0, 0,0,0,0,
	0,0,0,0, 0,0,0,0,
	1,0,0,1, 1,0,0,0,
	0,0,0,0, 0,0,0,0,
	1,0,0,0, 1,0,1,0,
],inf).coin.not );
Pdefn(\hihat, Pseq([
	0,0,0,0, 1,0,0,0,
],inf).coin.not );
)


(
Ndef(\, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
