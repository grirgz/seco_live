
~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Ndef(\, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
SynthDef(\delayman, { arg out=0, gate=1;
	var sig;
	var size = 8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
	sig = DelayL.ar([sig], \maxdelay.ir(1), \delaytab.kr(0!size) * SinOsc.ar(\lfotab.kr(0!size), mul:\lfomultab.kr(0!size), add:1)).sum + sig;
	LocalOut.ar(sig);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sourceman, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Ppar(
			Pbind(
				\instrument, \sourceman,
				\freq, Pexprand(100.0,1000),
				\dur, Pexprand(0.1,2),
				\legato, 0.1,
				\oscmix, Pwhite(0.0,1),
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			) ! 4 
		),
		Pmono(\delayman,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1),
			\delaytab, Pseq([
				[ [ 1.1,0.0234,0.3,0.5, 0,0,0,0, ] ]
			],inf),
			\lfotab, Pseq([
				[ [ 0.1,0.0234,0.3,0, 0,0,0,0, ] ]
			],inf),
			\lfomultab, Pseq([
				[ [ 0.1,0.0234,1,0, 0,0,0,0, ] ]
			],inf),
			\fb, 0.09,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Ppar(
			Pbind(
				\instrument, \sourceman,
				\note, Pseq([
					Prand([0,3,7,9,11,13]),
				],inf),
				\dur, Pexprand(0.1,2),
				\legato, 0.1,
				\oscmix, Pwhite(0.0,1),
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			) ! 2 
		),
		Pmono(\delayman,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1),
			\delaytab, Pseq([
				[ (0..7) ]
			],inf),
			\lfotab, Pseq([
				[ ( 1/10 )!8 ]
			],inf),
			\lfomultab, Pseq([
				[ 1 ! 8 ]
			],inf),
			\fb, 0.09,
			\dur, 1,
		),
		Pmono(\fx_limiter,
			\inbus, BusDef(\lim, \audio),
			\dur, 1,
		),
	])
)).play;
);


(
SynthDef(\somebass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1/8,1/20],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1/8,1/10],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([0.1,1/21,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq + [0,1]).mean;
	sig2 = RLPF.ar(sig2, \lpf.kr(1000) * env1, \rq.kr(0.5));
	sig3 = LFNoise1.ar(1000 + [0,1]).mean;
	sig3 = WhiteNoise.ar;
	sig3 = sig3 * ( LFSaw.ar(freq / env2)  * env3 + 1);
	//sig3 = RHPF.ar(sig3, 19000 * env2, \rq.kr(0.5));
	sig3 = BPF.ar(sig3, 19000 * env2, \rq.kr(0.5));
	sig3 = sig3 * EnvGen.kr(Env([0,1/12,0],[0.4,0.8], [1,-1]), 1);
	sig4 = LFSaw.ar(freq *8 );
	sig4 = RHPF.ar(sig4, 8000 * EnvGen.kr(Env([1,2,3],[0.1,0.8]), 1), \rq.kr(0.5));
	sig4 = sig4 * EnvGen.kr(Env([0,1/1.2,1],[0.1,4.8]), 1);
	sig = [sig1,sig2,sig3,sig4].sum;
	//sig = sig4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\zed, 
	Pbind(
		\instrument, \somebass,
		\degree, Pseq([0],inf),
		\octave, 3,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
