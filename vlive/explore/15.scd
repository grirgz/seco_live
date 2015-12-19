(
TempoClock.default.tempo = 42.45/60;
~t = TempoClock.default.tempo;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = Ndef.defaultQuant;
)
(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,1.00001] *.x [1,1/2];
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig = SelectX.ar(\mix.kr(0.5) * 2 * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1), [sig, sig1, sig2]);
	sig.debug("sig");
	//sig = CombL.ar(sig, 0.1,1/freq,1) + sig;
	sig = RLPF.ar(sig, freq * SinOsc.kr(4).range(1,2) * \lpfac.kr(1), \rq1.kr(0.1));
	sig = (sig * \damp.kr(10)).tanh;
	sig = RLPF.ar(sig, \lpf2.kr(1000), \rq2.kr(0.7));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0051,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;

SynthDef(\bass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,1.00001] *.x [1,1/2];
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig = SelectX.ar(\mix.kr(0.5) * 2 * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1), [sig, sig1, sig2]);
	sig.debug("sig");
	//sig = CombL.ar(sig, 0.1,1/freq,1) + sig;
	sig = RLPF.ar(sig, freq * SinOsc.kr(4).range(1,2) * \lpfac.kr(1), \rq1.kr(0.1));
	sig = (sig * \damp.kr(10)).tanh;
	sig = RLPF.ar(sig, \lpf2.kr(1000), \rq2.kr(0.7));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0051,0.1,0.8,0.1)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Splay.ar(sig, 0, amp, pan);
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \bass2,
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf),
	\rq2, Ndef(\lfo1, { SinOsc.kr(1).range(0.1,0.91)  }),
	\lpf2, Ndef(\lfo2, { SinOsc.kr( Duty.kr(1/2/~t, 0, Dseq([
		1,2,8,4,
	],inf))).range(1200,40.91)  }),
	\root, 1,
	\legato, Pseq([
		Pwhite(0.1,0.9,12),
		Pwhite(0.7,1.1,2),
		Pwhite(1.1,2.0,2),
	],inf),
	\octave, 3,
	\dur, 1/8,
	\amp, 0.2
)).play;
);
(
Pdef(\plop, Pbind(
	\instrument, \bass2,
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf),
	\mix, Ndef(\lfo4, { SinOsc.kr(1/8).range(0,1)  }),
	\fspread, Ndef(\lfo3, { SinOsc.kr(1/4).range(0.005,1)  }),
	\damp, 10.1,
	\lpfac, Pseq([1,1/2,2,4],inf),
	\rq, Pseq([0.1,0.2,0.5,0.01],inf).stutter(4),
	\rq2, Ndef(\lfo1, { SinOsc.kr(1/8).range(0.4,0.11)  }),
	\lpf2, Pseq([1000,500],inf),
	\root, 1,
	\legato, Pseq([
		Pwhite(0.1,0.9,12),
		Pwhite(0.7,1.1,2),
		Pwhite(1.1,2.0,2),
	],inf),
	\octave, 3,
	\pan, Pseq([0,1,-1,0,0,0,0,0],inf) * 0.3,
	\dur, 1/8,
	\amp, 0.2
)).play;
);

(
Pdef(\plop, Pbind(
	\instrument, \bass2,
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf),
	\mix, Ndef(\lfo4, { SinOsc.kr(8).range(0,1)  }),
	\fspread, Ndef(\lfo3, { SinOsc.kr(4).range(0.005,1)  }),
	\damp, 1.1,
	\lpfac, Pseq([1,1/2,2,4],inf),
	\rq, Pseq([0.1,0.2,0.5,0.01],inf).stutter(4),
	\rq2, Ndef(\lfo1, { SinOsc.kr(1/8).range(0.4,0.11)  }),
	\lpf2, Pseq([1000,500]/2,inf),
	\root, 1,
	\legato, Pseq([
		Pwhite(0.1,0.9,12),
		Pwhite(0.7,1.1,2),
		Pwhite(1.1,2.0,2),
	],inf),
	\octave, 3,
	\pan, 0.3,
	\dur, 1/8,
	\amp, 0.2/2,
)).play;
);

(
Pdef(\rbass, Pbind(
	\instrument, \bass2,
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf),
	\mix, Ndef(\lfo4, { SinOsc.kr(0.08).range(0,1)  }),
	\fspread, Ndef(\lfo3, { SinOsc.kr(0.014).range(0.005,1)  }),
	\damp, 10.1,
	\lpfac, Pseq([1,1/2,2,4],inf),
	\rq, Pseq([0.1,0.2,0.5,0.01],inf).stutter(4),
	\rq, 0.5,
	\rq2, Ndef(\lfo1, { SinOsc.kr(1/8).range(0.4,0.71)  }),
	\lpf2, Pseq([1000,500,4000,1000],inf),
	\root, 1,
	\legato, Pseq([
		Pwhite(0.1,0.9,12),
		Pwhite(0.7,1.1,2),
		Pwhite(1.1,2.0,2),
	],inf),
	\octave, 3,
	\pan, 0.3,
	\dur, 1/8,
	\amp, 0.2/2,
)).play;
);

(
Pdef(\shak, Pbind(
	\instrument, \bass,
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf) + [0,2,4],
	\scale, Scale.minor,
	//\rq2, Ndef(\lfo1, { SinOsc.kr(1).range(0.1,0.91)  }),
	//\lpf2, Ndef(\lfo2, { SinOsc.kr( Duty.kr(1/2/~t, 0, Dseq([
	//	1,2,8,4,
	//],inf))).range(1200,40.91)  }),
	\root, 1,
	\legato, Pseq([
		Pwhite(0.1,0.9,12),
		Pwhite(0.7,1.1,2),
		Pwhite(1.1,2.0,2),
	],inf) * Pwhite([0.9,0.56,0.3], [1,1,1.3])*0.2,
	\isRest, Pseq([
		0,0.5,
		0.8,0.5,
	],inf).coin.not,
	\octave, Ptuple([6,5,Prand([4,5,6],inf)],inf),
	\dur, 1/8,
	\pan, -0.3,
	\amp, 0.2/3,
)).play;
);
Pdef(\shak).clear

(
Pdef(\shak, Pbind(
	\instrument, \bass,
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf),
	\scale, Scale.minor,
	\rq2, Ndef(\lfo1, { SinOsc.kr(1).range(0.1,0.91)  }),
	\lpf2, Ndef(\lfo2, { SinOsc.kr( Duty.kr(1/2/~t, 0, Dseq([
		1,2,8,4,
	],inf))).range(9200,2140.91)  }),
	\root, 1,
	\legato, 1,
	\legato, Pseq([
		Pwhite(0,0.9,12),
		Pwhite(0,1.1,2),
		Pwhite(1.1,2.0,2),
	],inf) * 0.2, // * Pwhite([0.9,0.56,0.3], [1,1,1.3])*0.2,
	\isRest, Pseq([
		0,0.5,
		0.8,0.5,
	],inf).coin.not,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4,1,-4) ],
	],inf),
	\isRest, Pseq([
		1
	],inf).coin.not,
	\isRest, Pfunc({ arg x; x[\legato] < 0.09 }),
	\octave, Ptuple([6,5,Prand([4,5,6],inf)],inf),
	\octave, 6,
	\dur, 1/8,
	\amp, 0.2/3,
)).play;
);

(
Pdef(\shak, Pbind(
	\instrument, \bass,
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf),
	\scale, Scale.minor,
	\rq2, Ndef(\lfo1, { SinOsc.kr(1).range(0.1,0.91)  }),
	\lpf2, Ndef(\lfo2, { SinOsc.kr( Duty.kr(1/2/~t, 0, Dseq([
		1,2,8,4,
	],inf))).range(9200,2140.91)  }),
	\mix, Ndef(\lfo4, { SinOsc.kr(1/8).range(0,1)  }),
	\fspread, Ndef(\lfo3, { SinOsc.kr(1/4).range(0.005,1)  }),
	\damp, 10.1,
	\lpfac, Pseq([1,1/2,2,4],inf),
	\root, 1,
	\legato, 1,
	\legato, Pseq([
		Pwhite(0,0.2,1),
		Pwhite(1,7.1,1),
		Pwhite(0,0,6),
	],inf), // * Pwhite([0.9,0.56,0.3], [1,1,1.3])*0.2,
	\isRest, Pseq([
		0,0.5,
		0.8,0.5,
	],inf).coin.not,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.4,1,-4) ],
	],inf),
	\isRest, Pseq([
		1
	],inf).coin.not,
	\isRest, Pfunc({ arg x; x[\legato] < 0.09 }),
	\octave, Ptuple([6,5,Prand([4,5,6],inf)],inf),
	\octave, 6,
	\dur, 1/8,
	\amp, 0.2/3,
)).play;
);


(
SynthDef(\vous, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * ( 1 + ( SinOsc.ar(freq * \fmfac.kr(1)) * \fmamp.kr(1) ));
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq);
	sig = SelectX.ar(\mix.kr(0.5) * SinOsc.kr((1..3)).range(0,1), [sig, sig1]);
	sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
	sig = BRF.ar(sig, \brf.kr(3000), \brq.kr(0.56));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.02), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\vous, Pbind(
	\fmamp, 40,
	\fmfac, Ndef(\vouslfo1, { SinOsc.kr(1/7).range(1/4,200)  }),
	\lpf, Ndef(\vouslfo2, { SinOsc.kr(1).range(4100,7122)  }),
	\instrument, \vous,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\vous, Pbind(
	\fmamp, 40,
	\fmfac, Ndef(\vouslfo1, { LFPulse.kr(4*~t).range(1/4,2)  }),
	\lpf, Ndef(\vouslfo2, { SinOsc.kr(1 * ( 1 + ( SinOsc.kr(1/4*~t) * 8 ))).range(400,7122) + SinOsc.kr(1/8).range(2000,1)  }),
	\brf, Ndef(\vouslfo4, { SinOsc.kr(1/8 * ( 1 + ( SinOsc.kr(1/4*~t) * 9 ))).range(400,7122) + SinOsc.kr(1/8).range(2000,1)  }),
	\instrument, \vous,
	\spread, Ndef(\vouslfo3, { SinOsc.kr(1/4).range(0.050,1)  }),
	\degree, Pseq([
		Pseq([
			0,1,1,1
		],3),
		Pser([
			\r
		],4),

	],inf),
	\root, 1,
	\dur, 1/8,
	\amp, 0.1/2,
)).play;
);

PdefAllGui.new

(
Pdef(\vous, Pbind(
	\fmamp, 40,
	\fmfac, Ndef(\vouslfo1, { LFPulse.kr(1*~t).range(1/4,2)  }),
	\lpf, Ndef(\vouslfo2, { SinOsc.ar(1/44 * ( 1 + ( SinOsc.kr(1/4*~t) * 8 ))).range(400,7122) + SinOsc.kr(1/8).range(2000,1)  }),
	\brf, Ndef(\vouslfo4, { SinOsc.kr(1/48 * ( 1 + ( SinOsc.kr(1/4*~t) * 9 ))).range(400,7122) + SinOsc.kr(1/8).range(2000,1)  }),
	\instrument, \vous,
	\spread, Ndef(\vouslfo3, { SinOsc.kr(1/44).range(0.050,1)  }),
	\degree, Pseq([
		Pseq([
			0,1,1,1
		],3),
		Pser([
			\r
		],4),

	],inf),
	\root, 1,
	\dur, 1/8,
	\amp, 0.1/2,
)).play;
);

(
Pdef(\vous, 
	
	Ppar([
		Pbind(\instrument, \bass),
		Pbind(\instrument, \vous),
	]) <>
	Pbind(
	\fmamp, 40,
	\fmfac, Ndef(\vouslfo1, { LFPulse.kr( Duty.kr(1/8/~t, 0, Dseq([
		2,1/2,2,4,
		8,16,1,8,
	],inf))*~t).range(1/4,2)  }),
	\lpf, Ndef(\vouslfo2, { SinOsc.ar(1/44 * ( 1 + ( SinOsc.kr(1/4*~t) * 8 ))).range(400,7122) + SinOsc.kr(1/8).range(2000,1)  }),
	\brf, Ndef(\vouslfo4, { SinOsc.kr(1/48 * ( 1 + ( SinOsc.kr(1/4*~t) * 9 ))).range(400,7122) + SinOsc.kr(1/8).range(2000,1)  }),
	\instrument, \vous,
	\spread, Ndef(\vouslfo3, { SinOsc.kr(1/44).range(0.050,1)  }),
	\degree, Pseq([
		Pseq([
			0,1,1,1
		],3),
		Pser([
			\r
		],4),

	],inf),
	\root, 1,
	\dur, 1/8,
	\amp, 0.1/2,
).stutter(2)
).play;
);
Pdef(\vous).play

(
Pdef(\kour, 
	
		Pbind(\instrument, \vous)
		<>
	Pbind(
	\fmamp, 40,
	\fmfac, Ndef(\vouslfo1, { LFPulse.kr( Duty.kr(1/8/~t, 0, Dseq([
		2,1/2,2,4,
		8,16,1,8,
	],inf))*~t).range(1/4,2)  }),
	\lpf, Ndef(\vouslfo2, { SinOsc.ar(1/44 * ( 1 + ( SinOsc.kr(1/4*~t) * 8 ))).range(2400,172) + SinOsc.kr(1/8).range(2000,1)  }),
	\brf, Ndef(\vouslfo4, { SinOsc.kr(1/48 * ( 1 + ( SinOsc.kr(1/4*~t) * 9 ))).range(4400,17122) + SinOsc.kr(1/8).range(2000,1)  }),
	\instrument, \vous,
	\spread, Ndef(\vouslfo3, { SinOsc.kr(1/44).range(0.050,1)  }),
	\degree, Pseq([
		Pseq([
			0,1,1,0-12+1
		],3),
		Pser([
			\r
		],4),

	],inf),
	\root, 1,
	\dur, 1/8,
	\amp, 0.1/2,
	//\out, BusDef(\fx1),
).stutter(2)
).play;
);

(
	Pdef(\viak2, Pspawner({ arg sp;
		var num=7;
		num.do { arg x;
			sp.par(
				Pbind(
					\instrument, [\vous,\bass,\bass2].wrapAt(x+1),
					\degree, x,
					\legato, 0.1,
					\sustain, 0.1,
					\octave, [2,3,4,5,6].wrapAt(x),
					\octave, Pseq([3,4,5,6],inf),
					\dur, 1 + x / num * 2,
					//\dur, ( (( x+1 )**2)/16 ).debug("dur"),
					//\dur, x+1 / 16,
					\amp, 0.1
				);
			);
			( 1/4 ).wait;
		}
		
	})
).play;
);

PdefAllGui.new

(
Pdef(\gana, 
	
		Pbind(\instrument, \bass2)
		<>
	Pbind(
	\fmamp, 40,
	\fmfac, Ndef(\vouslfo1, { LFPulse.kr( Duty.kr(1/8/~t, 0, Dseq([
		2,1/2,2,4,
		8,16,1,8,
	],inf))*~t).range(1/4,2)  }),
	\lpf, Ndef(\vouslfo2, { SinOsc.ar(1/44 * ( 1 + ( SinOsc.kr(1/4*~t) * 8 ))).range(2400,172) + SinOsc.kr(1/8).range(2000,1)  }),
	\brf, Ndef(\vouslfo4, { SinOsc.kr(1/48 * ( 1 + ( SinOsc.kr(1/4*~t) * 9 ))).range(4400,17122) + SinOsc.kr(1/8).range(2000,1)  }),
	\instrument, \vous,
	\octave, 6,
	\spread, Ndef(\vouslfo3, { SinOsc.kr(1/44).range(0.050,1)  }),
	\legato, Pseq([1,3,1],inf)/8,
	\degree, Pseq([
		Pser([
			0,1,\r
		],12),
		Pser([
			\r
		],4),

	],inf),
	\root, 1,
	\dur, 1/8,
	\amp, 0.1/2,
	\amp, Pkey(\amp) * Pseg(Pseq([0.3,1],inf),18),
	\out, BusDef(\fx1),
).stutter(2)
).play;
);



(
SynthDef(\baze, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * ( 1 + ( SinOsc.ar(freq) * \fmamp.kr(10) ));
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	//sig = SelectXFocus.ar(\oscmix.kr(0.5)*2 + SinOsc.ar( ((0..7)/7 - 0.5 * \fspread.kr(4) + 1) ).range(-1,1), [sig1, sig2, sig3], \oscfoc.kr(0.5));
	sig = SelectXFocus.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3], \oscfoc.kr(0.5));
	sig = LPF.ar(sig, \lpf.kr(4700), \rq.kr(0.5));
	//sig = sig + FreqShift.ar(sig, [0, 100,200,300]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Splay.ar(sig, \spread.kr(0.001), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sleng, Pbind(
	\degree, Pseq([
		0,1,1,1, 0,1,1,1,
		0,1,1,1, 4,\r,4b,\r,
	],inf),
	\scale, Scale.minor,
	\root, 1,
	\dur, 1/8,
	\octave, 3,
)).play;
);

(
Pdef(\baze, 
	Pbind(
		\instrument, \baze,
		\oscmix, Ndef(\bazel1, { SinOsc.kr(1).range(0,1)  }),
		\oscfoc, Ndef(\bazel2, { SinOsc.kr(1/3).range(0,1)  }),
		\amp, 0.1/1.5
	)
	<> Pdef(\sleng)
).play;
);

(
Pdef(\baze, 
	PmonoArtic( \baze,
		\oscmix, Ndef(\bazel1, { SinOsc.kr(1).range(0,0.1)  }),
		\oscfoc, Ndef(\bazel2, { SinOsc.kr(1/3).range(0,1)  }),
		\legato, Pseq([
			Pser([1],12),
			Pser([0.5],4),
		],inf),
		\out, BusDef(\fx1, \audio,2),
		\amp, 0.1
	)
	<> Pdef(\sleng)
).play;
);

BusDef(\fx1, \audio,2)

(
Ndef(\fxgor).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = CrossoverDistortion.ar(sig, 1/2, SinOsc.kr([1,1.1]/4).range(1,2))/1;
	sig = BRF.ar(sig, 4000);
	sig = BRF.ar(sig, 9000 * SinOsc.kr(1/4).range(2,1));
	sig = Pan2.ar(sig, pan, amp);
	sig = SelectX.ar(\mix.kr(0.5).lag(0.4), [in, sig]);
}).play;
Ndef(\fxgor).set(\inbus, BusDef(\fx1, \audio, 2));
);

(
Ndef(\fxgor)[1] = \set -> Pbind(
	\mix, Pseq([0,0,0,1],inf),
	\dur, 1/2,
);
)

(
Ndef(\fxgor)[1] = \set -> Pbind(
	\mix, Pseq([
		0,1,0,0,
		0,1,0,1,
		0,0,0,0,
		1,1,1,1,
	],inf),
	\dur, 1/8,
);
)

(
Ndef(\fxgor)[1] = \set -> Pbind(
	\mix, Pseq([
		1,1,0,1,
		0.5,1,0,1,
		0,1,0.71,1,
		1,1,0,1,
	],inf) + 1 /2,
	\dur, 1/8,
);
)


(
SynthDef(\pulse, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * [1,1], 0, \pw.kr(0.8) * [1,\pwp.kr(1.1)]);
	sig = Ringz.ar(sig, freq, 0.01)/10;
	sig = BRF.ar(sig, 4200 * [1,1.1]);
	sig = BRF.ar(sig, 7200);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\pulse2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * [1,1], 0, \pw.kr(0.8) * [1,\pwp.kr(1.1)]);
	sig = Ringz.ar(sig, freq, 0.01)/10;
	sig = BRF.ar(sig, 200 * [1,1.1]);
	sig = BRF.ar(sig, 400);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\pulse, Pbind(
	\instrument, \pulse,
	\degree, Pseq([0],inf),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\pulse, Pbind(
	\instrument, \pulse,
	\pw, Pseq([0.1,0.5,0.2,0.8,0.5],inf).stutter(Pseq([3,1,2],inf)),
	\amp, 0.1
) <> Pdef(\sleng)

).play;
);

(
Pdef(\pulse, Pbind(
	\instrument, \pulse,
	\pw, Pseq([0.1,0.5,0.2,0.8,0.5],inf).stutter(Pseq([3,1,2],inf)),
	\isRest, Pseq([
		Prand([
			Pseq([1,1,1,1]),
			Pseq([1,0,1,1]),
			Pseq([1,1,0,0]),
		],1),
	],inf).coin.not,
	\lag, Pseq([
		Prand([
			Pseq([0,0.051,0,0]),
			Pseq([0,0,0,0]),
		],1),
	],inf),
	\amp, 0.1
) <> Pdef(\sleng)

).play;
);

(
Pdef(\pulse2, Pbind(
	\instrument, \pulse2,
	\pw, Pseq([0.5,0.8],inf).stutter(Pseq([12,4],inf)),
	\isRest, Pseq([
		Prand([
			Pseq([1,1,1,1]),
			Pseq([1,0,1,1]),
			Pseq([1,1,0,0]),
		],1),
	],inf).coin.not,
	\lag, Pseq([
		Prand([
			Pseq([0,0,0,0]),
			Pseq([0,0,0,0]),
		],1),
	],inf),
	\octave, 3,
	\out, BusDef(\fx1, \audio,2),
	\amp, 0.1
) <> Pdef(\sleng)

).play;
);

(
Pdef(\pulse2, Pbind(
	\instrument, \pulse2,
	\pw, Pseq([0.5,0.8],inf).stutter(Pseq([12,4],inf)),
	\isRest, Pseq([
		Prand([
			Pseq([1,1,1,1]),
			Pseq([1,0.9,1,1]),
			Pseq([1,1,0.9,0.9]),
		],1),
	],inf).coin.not,
	\legato, 0.1,
	\lag, Pseq([
		Prand([
			Pseq([0,0,0,0]),
			Pseq([0,0,0,0]),
		],1),
	],inf),
	\octave, 3,
	\out, BusDef(\fx1, \audio,2),
	\amp, 0.1
) <> Pdef(\sleng)

).play;
);

PdefAllGui.new


(
WindowDef(\yep, {
	var tv = TreeView.new;
	var tvi;
	tv.addItem(["yep", "yoi"]);
	tvi = tv.addItem(["yep", "yoi"]);
	tvi.addChild(["yep", "yoi"]);
	tvi.addChild(["yep", "yoi"]);
	tvi.addChild(["yep", "yoi"]);
	tv.addItem(["yep", "yoi"]);
	tv.addItem(["yep", "yoi"]);
	tv.columns = ["hhh", "hiii"];
	tv;
}).front
)
