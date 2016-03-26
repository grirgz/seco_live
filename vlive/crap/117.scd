c = [];
10.do { arg i; 
	c = c.add([0,1].choose)
};
c.debug;


{ [0,1].choose } ! 10


(
SynthDef("raygun", {arg amp = 0.5, sinfreq = 1000, glissf = 0.001, att = 0.01, rel = 0.9;
    var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
    var snd = SinOsc.ar(gliss);
    var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
    snd = snd * env * amp;
    Out.ar(0, snd);
}).add;
)

(
Pbind(
    \instrument, "raygun",
    \dur, Pseq([0.75,0.75,0.75,0.75,0.25,0.25,0.25]*0.5, inf),
	\amp, 0.4
).play;
)



// Jared Shimada
// MUSC 115 Final (Experimental Sound Design)
// Winter 2016
// tEtRiS: tHeMe AnD vArIaTiOnS

//Synths

(
SynthDef("Synth1", { arg freq = 440, modfreq = 1, amp = 0.5, attack = 0.01, dur = 2, pos = 0;
var carrier, modulator, env;
modulator = LFSaw.kr(modfreq).range(0, 1);
carrier = LFSaw.ar(freq: freq, mul: modulator);
env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
carrier = carrier * env;
Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
SynthDef("Synth2", { arg freq = 440, modfreq = 1, amp = 0.5, attack = 0.01, dur = 1, pos = 0;
var carrier, modulator, env;
modulator = LFSaw.kr(modfreq).range(0, 1);
carrier = LFTri.ar(freq: freq, mul: modulator);
env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
carrier = carrier * env;
Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
SynthDef("Synth3", { arg freq = 440, modfreq = 1, amp = 0.5, attack = 0.01, dur = 2, pos = 0;
var carrier, modulator, env;
modulator = LFTri.kr(modfreq).range(0, 1);
carrier = LFTri.ar(freq: freq, mul: modulator);
env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
carrier = carrier * env;
Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
SynthDef("Synth4", { arg freq = 440, modfreq = 1, amp = 0.2, attack = 0.01, dur = 2, pos = 0;
var carrier, modulator, env;
modulator = LFSaw.kr(modfreq).range(0, 1);
carrier = SinOsc.ar(freq: freq, mul: modulator);
env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
carrier = carrier * env;
Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
SynthDef("hihat", {arg amp = 0.5, att = 0.01;
    var snd = WhiteNoise.ar(amp);
    var env = EnvGen.kr(Env.perc(att, 0.1), doneAction: 2);
    snd = HPF.ar(snd * env, 500000);
	Out.ar([0,1], snd);
}).add;
)


// Pbinds

// Main Tetris Melody

(
~soprano1=Pbind(
	\instrument, "Synth3",
	\midinote, Pseq([76, 71, 72, 74, 72, 71, 69, 69, 72, 76, 74, 72, 71, 71, 72, 74, 76, 72, 69, 69, 69, 74, 74, 77, 81, 79, 77, 76, 76, 72, 76, 74, 72, 71, 71, 72, 74, 76, 72, 69, 69, 69], 1),
	\dur, Pseq([1, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, Rest(0.5), 0.5, 1, 1, 1, 1, 1, Rest(1), Rest(0.5), 1, 0.5, 1, 0.5, 0.5, 1, Rest(0.5), 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, 1, 1, 1, 1, Rest(1)], 1),
	\legato, 0.3,
	\amp, 0.50,
	\tempo, 100/60,
);
~soprano1.play;
)

(
~alto1=Pbind(
	\instrument,"Synth3",
	\midinote, Pseq([71, 71, 68, 69, 71, 76, 74, 69, 68, 64, 64, 64, 69, 72, 72, 71, 69, 68, 68, 64, 68, 69, 71, 71, 72, 72, 69, 69, 64, 64, 64, 64, 65, 65, 65, 69, 72, 72, 72, 71, 69, 67, 67, 64, 67, 69, 67, 65, 64, 68, 64, 67, 69, 71, 67, 72, 67, 69, 64, 64, 64, 64, 64],1),
		\dur, Pseq([0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, Rest(0.5),  0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(1.5), Rest(0.5), 0.5, Rest(0.5), 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, Rest(1), 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, Rest(1.5)],1),
	\legato, 0.01,
	\amp, 0.4,
	\tempo, 100/60,
);
~alto1.play;
)


(~bass1=Pbind(
	\instrument, "Synth2",
	\midinote, Pseq([40, 52, 40, 52, 40, 52, 40, 52, 45, 57, 45, 57, 45, 57, 45, 57, 44, 56, 44, 56, 40, 52, 40, 52, 45, 57, 45, 57, 45, 57, 47, 48, 50, 38, 38, 38, 38, 38, 45, 41, 36, 48, 48, 48, 36, 43, 43, 43, 47, 59, 59, 59, 59, 52, 52, 56, 45, 52, 45, 52, 45, 45],1),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.5, 0.5, 1, Rest(1)], 1),
	\legato, 1,
	\amp, 0.6,
	\tempo, 100/60,
);
~bass1.play;
)


(
~soprano2=Pbind(
	\instrument, "Synth3",
	\midinote, Pseq([64, 60, 62, 59, 60, 57, 56, 59, 59, 64, 60, 62, 59, 60, 64, 69, 68, 68 ], 1),
	\dur, Pseq([2, 2, 2, 2, 2, 2, 2, 1, Rest(1), 2, 2, 2, 2, 1, 1, 2, 2, Rest(2)],1),
	\amp, 0.2,
	\legato, 3,
	\tempo, 100/60,
);
~soprano2.play;
)

(
~alto2=Pbind(
	\instrument, "Synth3",
	\midinote, Pseq([60, 57, 59, 56, 57, 52, 52, 56, 56, 60, 57, 59, 56, 57, 60, 64, 62, 62], 1),
	\dur, Pseq([2, 2, 2, 2, 2, 2, 2, 1, Rest(1), 2, 2, 2, 2, 1, 1, 2, 2, Rest(2)], 1),
	\amp, 0.40,
	\legato, 3,
	\tempo, 100/60,
);
~alto2.play;
)

(
~bass2=Pbind(
	\instrument, "Synth2",
	\midinote, Pseq([57, 64, 57, 64, 57, 64, 57, 64, 56, 64, 56, 64, 56, 64, 56, 64, 57, 64, 57, 64, 57, 64, 57, 64, 56, 64, 56, 64, 64, 57, 64, 57, 64, 57, 64, 57, 64, 56, 64, 56, 64, 56, 64, 56, 64, 57, 64, 57, 64, 57, 64, 57, 64, 56, 64, 56, 64, 64],1),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, Rest(2), 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, Rest(2)],1),
	\amp, 0.55,
	\legato, 1,
	\tempo, 100/60,
);
~bass2.play;
)



// Ending of Melody
(
~soprano1_ending=Pbind(
	\instrument, "Synth3",
	\midinote, Pseq([76, 71, 72, 74, 72, 71, 69, 69, 72, 76, 74, 72, 71, 71, 72, 74, 76, 72, 69, 69, 69, 74, 74, 77, 81, 79, 77, 76, 76, 72, 76, 74, 72, 71, 71, 72, 74, 76, 72, 69, 69, 69], 1),
	\dur, Pseq([1, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, Rest(0.5), 0.5, 1, 1, 1, 1, 1, Rest(1), Rest(0.5), 1, 0.5, 1, 0.5, 0.5, 1, Rest(0.5), 0.5, 1, 0.5, 0.5, 1, 0.5, 0.5, 1, 1, 1, 1, 1, Rest(4)], 1),
	\legato, 0.3,
	\amp, 0.50,
	\tempo, 100/60,
);
~soprano1_ending.play;
)

(
~alto1_ending=Pbind(
	\instrument,"Synth3",
	\midinote, Pseq([71, 71, 68, 69, 71, 76, 74, 69, 68, 64, 64, 64, 69, 72, 72, 71, 69, 68, 68, 64, 68, 69, 71, 71, 72, 72, 69, 69, 64, 64, 64, 64, 65, 65, 65, 69, 72, 72, 72, 71, 69, 67, 67, 64, 67, 69, 67, 65, 64, 68, 64, 67, 69, 71, 67, 72, 67, 69, 64, 64, 64, 64, 64],1),
		\dur, Pseq([0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, Rest(0.5),  0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(1.5), Rest(0.5), 0.5, Rest(0.5), 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, Rest(1), 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, Rest(4.5)],1),
	\legato, 0.01,
	\amp, 0.4,
	\tempo, 100/60,
);
~alto1_ending.play;
)


(~bass1_ending=Pbind(
	\instrument, "Synth2",
	\midinote, Pseq([40, 52, 40, 52, 40, 52, 40, 52, 45, 57, 45, 57, 45, 57, 45, 57, 44, 56, 44, 56, 40, 52, 40, 52, 45, 57, 45, 57, 45, 57, 47, 48, 50, 38, 38, 38, 38, 38, 45, 41, 36, 48, 48, 48, 36, 43, 43, 43, 47, 59, 59, 59, 59, 52, 52, 56, 45, 52, 45, 52, 45, 45],1),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.5, Rest(0.5), 0.5, 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, 0.5, 0.5, 0.5, 0.5, 1, Rest(1)], 4),
	\legato, 1,
	\amp, 0.6,
	\tempo, 100/60,
);
~bass1_ending.play;
)




// Variation 1

(
~drums=Pbind(
	\instrument,"hihat",
	\dur, Pseq([Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(0.5), 0.25, 0.25, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, Rest(0.5), 0.5, 0.5, 0.5], 4),
	\amp, 0.5,
	\tempo, 130/60,
);
~drums.play;
)

(~var1_soprano1=Pbind(
	\instrument, "Synth1",
	\midinote, Pseq([[76, 71], 71, 72, 74, 76, 74, 72, 71, 69, 72, 76, 77, 76, 74, 72, 71, 72, 74, 76, 74, 72, 71, 69, 69, 69, 0, 74, 77, 81, 79, 77, 76, 72, 76, 77, 76, 74, 72, 71, 72, 74, 76, 74, 72, 71, 69, 69, 69, 0],1),
	\dur, Pseq([1, 0.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 1.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 1.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 1, 1, 1, Rest(1), 1.5, 0.5, 1, 0.5, 0.5, 1.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 1.5, 0.5, 0.5, 0.25, 0.25, 0.5, 0.5, 1, 1, 1, Rest(1)],1),
	\amp, 0.2,
	\legato, 1,
	\tempo, 130/60,
);~var1_soprano1.play;
)

(~var1_bass1=Pbind(
	\instrument, "Synth3",
	\midinote, Pseq([40, 52, 40, 52, 40, 52, 40, 52, 45, 57, 45, 57, 45, 57, 45, 57, 44, 56, 44, 56, 40, 52, 40, 52, 45, 57, 45, 57, [45, 57], [33, 45], [35, 47], [36, 48], 38, 50, 38, 50, 38, 50, 38, 50, 36, 48, 36, 48, 36, 48, 36, 48, 44, 56, 44, 56, 40, 52, 40, 52, 45, 57, 45, 57, [45, 57], 0], 1),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, Rest(1) ], 1),
	\amp, 0.7,
	\legato, 1,
	\tempo, 140/60,
);~var1_bass1.play;
)

(~var1_soprano2=Pbind(
	\instrument, "Synth1",
	\midinote, Pseq([76, 72, 69, 71, 72, 74, 71, 64, 68, 71, 72, 69, 72, 71, 69, 68, 71, 68, 64, 76, 72, 69, 71, 72, 74, 71, 64, 68, 71, 72, 72, 73, 74, 75, 76, 71, 68, 64, 68, 71, 76, 77,], 1),
	\dur, Pseq([2, 0.5, 0.5, 0.5, 0.5, 2, 0.5, 0.5, 0.5, 0.5, 2, 0.5, 0.5, 0.5, 0.5, 1.5, 0.25, 0.25, 2,  2, 0.5, 0.5, 0.5, 0.5, 2, 0.5, 0.5, 0.5, 0.5, 2, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], 1),
	\amp, 0.2,
	\legato, 1,
	\tempo, 130/60,
);~var1_soprano2.play;
)

(~var1_bass2=Pbind(
	\instrument, "Synth3",
	\midinote, Pseq([45, 57, 45, 57, 45, 57, 45, 57, 44, 56, 44, 56, 44, 56, 44, 56, 41, 53, 41, 53, 41, 53, 41, 53, 40, 52, 40, 52, 40, 52, 40, 52, 45, 57, 45, 57, 45, 57, 45, 57, 44, 56, 44, 56, 44, 56, 44, 56, 41, 53, 41, 53, 41, 53, 41, 53, 40, 52, 40, 52, 40, 52, 40, 52], 1),
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], 1),
	\amp, 0.75,
	\legato, 1,
	\tempo, 130/60,
);~var1_bass2.play;
)

// Variation 2

(~var2_soprano1=Pbind(
	\instrument, "Synth4",
	\midinote, Pseq([76, 75, 74, 75, 76, 75, 74, 75, 76, 75, 74, 75, 76, 74, 72, 71, 69, 72, 73, 74, 75, 76, 75, 74, 73, 72, 71, 72, 74, 73, 72, 71, 70, [69, 81], [71, 83], [72, 84], [69, 81], 0, 74, 70, 71, 72, 73, 74, 76, 74, 72, 74, 72, 74, 72, 74, 72, 71, 69, 68, 64, 68, 71, 74, 76, 72, 68, 64, 62, 64, 66, 68, 69, 64, [69, 81], 0], 1),
	\dur, Pseq([0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1, 0.25, 0.25, 0.25, 0.25, 1, 0.25, 0.25, 0.25, 0.25, 1.5, 0.5, 1, 0.25, 0.25, 0.25, 0.25, 0.75, 0.25, 1, 1, Rest(1), 1, 0.25, 0.25, 0.25, 0.25, 1, 0.25, 0.25, 0.25, 0.25, 1.5, 0.5, 1, 0.25, 0.25, 0.25, 0.25, 1, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1, 1, 1, Rest(1)], 1),
	\amp, 0.70,
	\legato, 1,
	\tempo, 145/60,
);
~var2_soprano1.play;
)

(~var2_bass1=Pbind(
	\instrument, "Synth4",
	\midinote, Pseq([40, 52, 51, 52, 53, 52, 51, 52, 47, 48, 50, 52, 47, 48, 50, 52, 45, 57, 56, 55, 54, 53, 52, 51, 48, 47, 46, 45, 44, 43, 42, 41, 40, 52, 51, 52, 53, 52, 51, 52, 47, 48, 50, 52, 47, 48, 50, 52, 45, 44, 43, 42, 41, 40, 39, 38, [33, 45], [35, 47], [36, 48], [37, 49], 45, 50, 49, 50, 52, 50, 45, 50, 56, 55, 54, 53, 52, 51, 50, 49, 43, 48, 47, 48, 50, 48, 55, 52, 55, 54, 53, 52, 51, 50, 49, 48, 47, 40, 47, 52, 50, 48, 47, 48, 40, 52, 50, 48, 50, 52, 44, 40, 45, 40, [33 ,45], 0], 1),
	\dur, Pseq([0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1, 1/3, 1/3, 1/3, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1, 1, 1, Rest(1)], 1),
	\amp, 0.75,
	\legato, 1,
	\tempo, 145/60,
);
~var2_bass1.play;
)

(~var2_soprano2=Pbind(
	\instrument, "Synth4",
	\midinote, Pseq ([76, 77, 76, 74, 72, 71, 72, 74, 76, 74, 76, 74, 72, 71, 69, 71, 72, 74, 72, 74, 72, 71, 69, 68, 69, 71, 72, 71, 64, 68, 69, 71, 64, 76, 77, 76, 74, 72, 71, 72, 74, 76, 74, 76, 74, 72, 71, 69, 71, 72, 74, 72, 74, 72, 71, 69, 68, 69, 71, 72, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 84, [76, 83, 88]], 1),
	\dur, Pseq ([2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1, 0.25, 0.25, 0.25, 0.25, 2, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1], 1),
	\amp, 0.55,
	\legato, 1,
	\tempo, 145/60,
);
~var2_soprano2.play;
)

(~var2_bass2=Pbind(
	\instrument, "Synth4",
	\midinote, Pseq ([40, 52, 47, 52, 44, 47, 52, 40, 47, 52, 40, 52, 44, 52, 47, 52, 38, 50, 49, 50, 52, 50, 51, 50, 62, 60, 59, 57, 55, 53, 52, 50, 48, 60, 59, 60, 57, 60, 55, 60, 59, 57, 55, 53, 52, 50, 48, 47, 44, 40, 44, 47, 50, 60, 59, 57, 56, 52, 56, 59, 52, 40, 52, 47, 52, 44, 47, 52, 40, 47, 52, 40, 52, 44, 52, 47, 52, 38, 50, 49, 50, 52, 50, 51, 50, 62, 60, 59, 57, 55, 53, 52, 50, 48, 60, 59, 60, 57, 60, 55, 60, 59, 57, 55, 53, 52, 50, 48, 47, 44, 40, 44, 47, 50, 60, 59, 57, 56, 52, 56, 59, [40, 47, 52]], 1),
	\dur, Pseq ([0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 1], 1),
	\amp, 0.65,
	\legato, 1,
	\tempo, 145/60,
);
~var2_bass2.play;
)

// Ending of Variation 2

(~var2_soprano1_ending=Pbind(
	\instrument, "Synth4",
	\midinote, Pseq([74, 70, 71, 72, 73, 74, 76, 74, 72, 74, 72, 74, 72, 74, 72, 71, 69, 68, 64, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 76, [69, 81], [64, 76], [81, 93]], 1),
	\dur, Pseq([1, 0.25, 0.25, 0.25, 0.25, 1, 0.25, 0.25, 0.25, 0.25, 1.5, 0.5, 1, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3, 0.4, 0.5, 0.5, 0.6, 0.6, 0.7, 0.7, 1.2, 1.5, 1], 1),
	\amp, 0.65,
	\legato, 1,
	\tempo, 145/60,
);
~var2_soprano1_ending.play;
)

(~var2_bass1_ending=Pbind(
	\instrument, "Synth4",
	\midinote, Pseq([45, 50, 49, 50, 52, 50, 45, 50, 56, 55, 54, 53, 52, 51, 50, 49, 43, 48, 47, 48, 50, 48, 55, 52, 55, 54, 53, 52, 51, 50, 49, 48, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 40, 44, 42, 44, 40, [45, 57], [40, 52], [33, 45]], 1),
	\dur, Pseq([0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.26, 0.27, 0.28, 0.29, 0.3, 0.4, 0.5, 0.5, 0.6, 0.6, 0.7, 0.7, 1.2, 1.5, 6], 1),
	\amp, 0.65,
	\legato, 1,
	\tempo, 145/60,
);
~var2_bass1_ending.play;
)

s.record;
s.stopRecording;


(
Pspawner({arg maestro;
	maestro.par(~soprano1);
	maestro.par(~alto1);
	maestro.par(~bass1);
	32.wait;
	maestro.par(~soprano2);
	maestro.par(~alto2);
	maestro.par(~bass2);
	32.wait;
	maestro.par(~soprano1_ending);
	maestro.par(~alto1_ending);
	maestro.par(~bass1_ending);
	32.wait;
	maestro.par(~var1_soprano1);
	maestro.par(~var1_bass1);
	maestro.par(~drums);
	32.wait;
	maestro.par(~var1_soprano1);
	maestro.par(~var1_bass1);
	maestro.par(~drums);
	32.wait;
	maestro.par(~var1_soprano2);
	maestro.par(~var1_bass2);
	maestro.par(~drums);
	32.wait;
	maestro.par(~var1_soprano1);
	maestro.par(~var1_bass1);
	maestro.par(~drums);
	32.5.wait;
	maestro.par(~var2_soprano1);
	maestro.par(~var2_bass1);
	32.wait;
	maestro.par(~var2_soprano1);
	maestro.par(~var2_bass1);
	32.wait;
	maestro.par(~var2_soprano2);
	maestro.par(~var2_bass2);
	32.wait;
	maestro.par(~var2_soprano1);
	maestro.par(~var2_bass1);
	32.wait;
	maestro.par(~var2_soprano1_ending);
	maestro.par(~var2_bass1_ending)
}).play;

)
TempoClock.default.tempo = 6.3


(
SynthDef("AM2", { arg freq = 440, modfreq = 12, amp = 0.5, attack = 0.01, dur = 1, pos = 0;
	var carrier, modulator, env;
	modulator = LFSaw.kr(modfreq).range(0, 1);
	carrier = LFSaw.ar(freq: freq, mul: modulator);
	env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
	carrier = carrier * env;
	Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

//Example Melody

(
a=Pbind(
\instrument, "AM2",
\degree, Pseq([0,1,2,3,4,5,6,7,6,5,4,3,2,1],inf),
\amp, 0.70,
\dur, 0.125,
\modfreq, 12, // add different values
).play;
)


(
SynthDef("Triangular AM", { arg freq = 440, modfreq = 5, amp = 0.5, attack = 0.01, release = 0.1, pos = 0, gate = 1;
	var carrier, modulator, env;
	modulator = SinOsc.kr(modfreq).range(0, 1); // provides amplitude modulation for wobble
	carrier = LFTri.ar(freq: freq, mul: modulator); // provides triangle wave for an interesting harmonic
	env = Env.asr(
		attackTime: attack,
		sustainLevel: amp,
		releaseTime: release).kr(doneAction: 2, gate: gate);
	carrier = carrier * env;
	Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
// Using these settings you can produce a pulsating wobble sound
~wobble = Pbind(
	\instrument, "Triangular AM",
	\scale, Scale.aeolian,
	\ctranspose, -12,
	\degree, Pseq([
		[-7,-3, 0, 2, 4, 7],
		[-8, -4, -1, 1, 3, 6],
		[-9, -5, -2, 0, 2, 5],
		[-5, -1, 2, 4, 6, 9],
		[-4, 0, 3, 5, 7, 10],
		], inf),
	\dur, Pseq([Pn(4, 3), 2, 2], inf),
	\amp, 0.4,
	\modfreq, Pseq([Pn(6.5, 3), 2, 6.5], inf),
	\attack, 2,
	\release, 1.2,
	\pos, [-1, -0.7, -0.2, 0.2, 0.7, 1],
	\gate, 0,
);
)

~wobble.play;


// Wine Glass Sound
(
SynthDef("AM", { arg freq = 523.25, modfreq = 1, amp = 0.5, attack = 2, dur = 5, pos = 0;
	var carrier, modulator, env;
	modulator = SinOsc.kr(modfreq).range(0, 1);
	carrier = SinOsc.ar(freq: freq, mul: modulator);
	env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
	carrier = carrier * env;
	Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
Pbind(
\instrument, "AM",
	\note, 15,
	\dur, 10,
	\amp, Pwhite(0.5, 0.1),
	\att, 1,
	\rel, 10
).play;
)




// changes to the modfreq in SynthDef "AM1" -- rougher rubbing against the glass
(
SynthDef("AM1", { arg freq = 523.25, modfreq = 10, amp = 0.5, attack = 2, dur = 5, pos = 0;
	var carrier, modulator, env;
	modulator = SinOsc.kr(modfreq).range(0, 1);
	carrier = SinOsc.ar(freq: freq, mul: modulator);
	env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
	carrier = carrier * env;
	Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
Pbind(
\instrument, "AM1",
	\note, 15,
	\dur, 10,
	\amp, Pwhite(0.5, 0.1),
	\att, 1,
	\rel, 10
).play;
)




// even higher modfreq -- greater number of voices
(
SynthDef("AM2", { arg freq = 523.25, modfreq = 1000, amp = 0.5, attack = 2, dur = 5, pos = 0;
	var carrier, modulator, env;
	modulator = SinOsc.kr(modfreq).range(0, 1);
	carrier = SinOsc.ar(freq: freq, mul: modulator);
	env = Env.perc(attackTime: attack, releaseTime: dur - attack, level: amp).kr(2);
	carrier = carrier * env;
	Out.ar(0, Pan2.ar(carrier, pos))
}).add;
)

(
Pbind(
\instrument, "AM2",
	\note, 15,
	\dur, 10,
	\amp, Pwhite(0.5, 0.1),
	\att, 1,
	\rel, 10
).play;
)
