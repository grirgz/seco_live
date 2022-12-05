
(
	// good way to destroy a signal into click noise
SynthDef(\ampgate, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * (sig > \lvl.kr(0.1));

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
	// do not give really interesting result except adding gate noise like ampgate
SynthDef(\gatedfreeverb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	//sig = sig * (sig > \lvl.kr(0.1));
	sig = sig * (Amplitude.kr(sig).lagud(\lagu.kr(0.001),\lagd.kr(0.10)) > \lvl.kr(0.1));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1277].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\ifx1, \audio),
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2128].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\ifx1, \audio),
			\gain, 0.11,
		),
		Pmono(\gatedfreeverb,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.61,
			\room, 0.5,
			\lvl, 0.004,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
