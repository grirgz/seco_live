~t = 135/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\rampap4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([1,2,1/2],[0.02,4.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1/2],[0.02,4.8]), 1);
	env3 = Duty.kr(1/24/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,1, 0,0,1,  1,1,0, 1,0,1,
			],1),
			Dseq([
				1,0,1, 1,0,0,  1,1,0, 1,0,1,
			],1),
		],1),
		1,1,0, 1,0,1,  1,1,0, 1,0,1,
	],inf))+( 1/2 );
	sig = SinOsc.ar(freq * [1,1.001].flop * [1/2,1,2] * env1 * ( SinOsc.ar(freq) * 1/2 * env3 + 1 )).mean;
	sig2 = LFSaw.ar(freq * [1,1.001].flop * [1/2,1,2] * env1 * ( SinOsc.ar(freq) * 1/2 * env3 + 1 )).mean;
	sig2 = RLPF.ar(sig, \lpfr.kr(1.1) * freq *env3* SinOsc.ar(freq * env2, mul:0.4 * env3,add:1) , \rq.kr(0.5));
	//sig = sig + ( sig2 * SinOsc.ar(freq/8).unipolar  );
	sig = sig + ( sig2  );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig.debug("sig");
	sig = sig *amp;
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\rampap3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = SinOsc.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/8!3).range(0,1);
	sig2 = sig2.mean;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/9!3).range(0,1);
	sig3 = sig3.mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * env2 * freq, \rq.kr(0.5));
	sig = SelectX.ar( lfo1, [sig1, sig2, sig3] ) * 1;
	sig = [sig, SelectX.ar( lfo2, [sig1, sig2, sig3] ) * 1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp * 2;

	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\rampap2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.01,1.3]), 1);
	sig = LFSaw.ar(freq * [1,1 + \det.kr(0.0001)].flop * [1,5/4,6/5]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\rampap, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// TODO: cleanup tempo ref and add parameters
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env3 = EnvGen.kr(Env([1,2,1],[0.2,1.8]), 1);
	freq = freq * env3;
	env1 = EnvGen.kr(Env([1,2.2,1],[1.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(2.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = RLPF.ar(sig, env2 * 1000, 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig*5;
	Out.ar(out, sig);
}).add;
SynthDef(\rampap1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env3 = EnvGen.kr(Env([1,2,1],[0.2,1.8]), 1);
	//freq = freq * env3;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,4.8])), 1);
	env2 = EnvGen.kr(\fmenv.kr(Env([0,22,1],[4.1,4.8])), 1);
	sig1 = LFPulse.ar(freq * [1,1+\det.kr(0.00001)] * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);
	sig2 = sig2 * 1;
	sig = SelectX.ar(\oscmix.kr(0.5), [sig1, sig2]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
		
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseg(Pseq([0,1],1),15/12),
				Pseg(Pseq([0,1],1),9/12),
			],inf),
			\velamp, 1/5,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/12,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\lpf, 8600,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1/2,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \pluck,
			\note, Pseq([
				0,4,3,2,
			],inf),
			\isRest, Pseq([
				0,0,0, 1,1,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1/5,
		),
		Pbind(
			\instrument, \rampap,
			\note, Pseq([
				[0,11,13,16]
			],inf).stutter(24),
			\octave, 3,
			\det, Pseg(Pseq([0.0001,0.01],inf),8),
			\legato, Pseq([
				15,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				15,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 6,0,0,  0,0,0, 3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1,
			\isRest, true,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(3),
			\legato, Pseq([
				1,0,0, 3,0,0,  0,0,0, 0,0,1,
				1,0,0, 0,1,1,  0,0,1, 1,0,1,
				1,0,0, 3,0,0,  0,0,0, 0,0,1,
				1,0,0, 0,1,0,  0,0,1, 0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,1,  0,0,0, 0,0,1,
				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
		
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\speed, Pseq([
				Pseg(Pseq([2,1],1),15/12),
				Pseg(Pseq([2,1],1),9/12),
			],inf),
			\velamp, 1/3,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/12,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono(\fx_reverb,
			\inbus, BusDef(\sendbus1),
			\addAction, \addToTail,
			\lag, 0.0005,
			\lpf, 8600,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, 1/4,
			\mix, Pseg(Pseq([0,1],inf),16),
			\gain, 1,
			\dur, 1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, Pseg(Pseq([0,1],inf),8),
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1,
			\gain,2,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pluck,
			\score, Pseq([
				Pseg(Pseq([2,1],1),9/12),
				Pseg(Pseq([2,1],1),3/12),
				Pseg(Pseq([2,1],1),6/12),
				Pseg(Pseq([2,1],1),3/12),
				Pseg(Pseq([2,1],1),3/12),
			],inf),
			\freq, Pkey(\score) * 500,
			\coef, Pkey(\score) * 0.1,
			\decay, Pkey(\score)-1 * 1.1,
			\isRest, Pseq([
				1,1,1, 1,1,1,  1,1,1, 1,1,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1/5,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \rampap2,
			\note, Pseq([
				[0,11,13,16]
			],inf).stutter(24),
			\octave, 6,
			\det, Pseg(Pseq([0.0001,0.01],inf),8),
			\legato, Pseq([
				15,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 9,0,0,  0,0,0, 0,0,0,
				15,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 6,0,0,  0,0,0, 3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \brownbass,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(3),
			\legato, Pseq([
				8,0,0, 0,0,0,  0,0,0, 0,0,1,
				0,0,0, 8,0,0,  0,0,0, 0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/12,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,1,  0,0,0, 0,0,1,
				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
		
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\velamp, 1/3,
			\sustain, 0.1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \rampap3,
			\freq, Pseq([
				[500,501,490,1000.1,251]
			],inf)* Pseq([
				2, 1, 2, 2,
				2, 1,1.5,3/4,
				2, 2, 1, 2,
				2, 1,1.5,3/4,
				2, 2, 2, 2,
				2, 1,1.5,3/4,
			],inf).stutter(3),
			\legato, Pseq([
				4,0,0, 0,0,0,  1,0,0, 4,0,0,
				0,0,0, 0,0,0,  6,0,0, 0,0,0,
				6,0,0, 0,0,0,  3,0,0, 3,0,0,
				6,0,0, 0,0,0,  3,0,0, 3,0,0,
				3,0,0, 6,0,0,  0,0,0, 3,0,0,
				3,0,0, 6,0,0,  0,0,0, 3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/12,
			\amp, 0.1/2,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1/2,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1,
			\gain,1,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
