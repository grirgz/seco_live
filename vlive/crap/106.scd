
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Decay.ar(Impulse.ar(1), 0.01, mul: WhiteNoise.ar);
	//sig1 = WhiteNoise.ar;
	sig1 = BPF.ar(sig1, 8700);
	sig1 = Ringz.ar(sig1, freq, 0.4);
	sig1 = sig1 * 2;
	sig = sig + sig1;
	//sig = sig1;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = Pluck.ar(PinkNoise.ar, Impulse.kr(0), 4/freq, 1/freq, 0.1,0.2);
	sig = HPF.ar(sig, 400);
	sig = sig*3;
	//sig = sig1;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = LPF.ar(sig, freq*4);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.4,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([[0,2,4]],inf),
	\octave, 6,
	\sustain, 0.1,
	\isRest, Pseq([
		0,1,1,1, 0,1,1,1,
	],inf).coin.not,
	\amp, 0.1,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
	],inf),
	\dur, 1/8,
)).play;
);

(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\degree, Pseq([0,0,3,3],inf).stutter(8),
	\octave, 3,
	\sustain, 0.2,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.1,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
	],inf),
	\dur, 1/8,
)).play;
);

TempoClock.default.tempo = 0.7:


(
    {
        var freq, numparts;
        numparts = 50;
        freq = SinOsc.kr(Array.fill(numparts, {Rand(0.05, 0.2)}),
            Array.fill(numparts, {Rand(0, 1.0)})).range(1000, 3000);
        LeakDC.ar(
            Pan2.ar(
                Pluck.ar(
                    WhiteNoise.ar(0.1).dup(numparts),
                    Impulse.kr(Array.fill(numparts, {Rand(10, 12)})),
                    100.reciprocal, freq.reciprocal, 2, Rand(0.01, 0.2), mul: 1),
                Array.fill(numparts, {Rand.new(-1.0, 1.0)}))
            .sum
            );
        }.play(s);
)



(
    {Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
        coef:MouseX.kr(-0.999, 0.999))
    }.play(s)
)

