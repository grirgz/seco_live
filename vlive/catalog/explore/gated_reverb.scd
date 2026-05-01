
/// pink noise reverb

(
SynthDef(\pink, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = PinkNoise.ar;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fx_freeverb2_gated, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in * \ingain.kr(1);
	sig = FreeVerb2.ar(sig[0],sig[1], \verbmix.kr(1), \room.kr(0.5), \damp.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	//sig = Gate.ar(sig, Amplitude.kr(in));
	sig = sig * (Amplitude.kr(in).poll.lagud(0,1) > 0.01);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pink,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2_gated,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2_gated,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

