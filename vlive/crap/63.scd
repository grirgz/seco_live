(
SynthDef(\test, { arg out, freq=800, pmf=1.0, pan, gatex=1, amp=0.1;
    var env, u;
    env = EnvGen.kr(Env.perc(0.001, 0.04, 0.4), gatex, doneAction:2); // envelope
    u = SinOsc.ar(freq * Rand(0.9, 1.1), SinOsc.ar(pmf, 0, pi), env);
    Out.ar(out, Pan2.ar(u, pan))
}).add;
);

(
Pdef(\testing,
    Pbind(
        \instrument, \test,
        \sustain, 0.5,
        \amp, 0.1,
        \pmf, Prand([1, 20, 300], inf),
        \pan, Prand([0, -1, 1], inf),
        \dur, Prand([0.01, 0.1, 0.25, 0.3], inf),
        \out, 0
));
)

Pdef(\testing).play;



(
SynthDef(\perc, { | out=0, freq=200, width=0.5, density=5, pan=0, amp=0.1, xgate=1 |
    var sound, env;
    sound = RLPF.ar(PinkNoise.ar, freq, width/freq);
    sound = Dust.kr(60)*sound;
	sound = SinOsc.ar(Rand(100,500));
    env = EnvGen.kr(Env.perc(0.1,1.1), Trig.kr(1,0.1), doneAction:2);
    Out.ar(out, Pan2.ar(sound, pan, amp));
}).add;
)

(
Pdef(\testing,
    Pbind(
        \instrument, \perc,
        \amp, 0.1,
		\sustain, 0.1,
        \pan, Prand([0, -1, 1], inf),
        \dur, Prand([0.01, 0.1, 0.25, 0.3], inf),
));
)
Pdef(\testing).play;

