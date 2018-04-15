~t = 158/4/60; TempoClock.default.tempo = ~t; // sufferer 158
(
SynthDef(\bbb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( CuspN.ar(freq * 4 ! 2) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	env1 = EnvGen.kr(Env(2.01-[1,2,1],[0.1,0.8],-4), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	sig = HPF.ar(sig, \hpfr.kr(1.3) * freq);
	sig = Pan2.ar(sig, pan + [-1, 1], amp*[1,1]).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\plane, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * 4 * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar([ (1..8)/8 ]) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	pan = pan + sig.collect({ arg x;
		SinOsc.kr(1/x);
	});
	sig = LeakDC.ar(sig);
	sig = sig * 18;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\plane2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/8, (1..8) ) * \foldlevel.kr(1) + \foldbias.kr(1) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	pan = pan + sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ));
	});
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig * \gain.kr(18);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(),
))).add;
SynthDef(\planebass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * [1,1/2,2]* ( LFSaw.ar(freq * 4 * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/8 ) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	pan = pan + sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ));
	});
	sig = LeakDC.ar(sig);
	sig = sig * 18;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\plane3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * [1/2,1/4,1/3]) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/18 ) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	pan = pan + sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ));
	});
	sig = LeakDC.ar(sig);
	sig = sig * 7;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\plane4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(1) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/8 ) * \foldlevel.kr(1) + \foldbias.kr(1) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	pan = pan + sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ));
	});
	sig = LeakDC.ar(sig);
	sig = sig * \gain.kr(18);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\plane5, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(1) * \fmtab.kr((0..7)/7-0.5)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/8 ) * \foldlevel.kr(1) + \foldbias.kr(1) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.7) * env1 * freq, \rq.kr(0.5));
	pan = pan + sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ));
	});
	sig = LeakDC.ar(sig);
	sig = sig * \gain.kr(18);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
SynthDef(\distguitar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	//sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = sig * EnvGen.ar(\asdr.kr(Env.adsr(0.001,0.01,0.2,0.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pmono(\bbb,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\lpfr, 1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 2,
			\amp, 0.1,
		),
		Pmono(\plane,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\lpfr, 1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		)),
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

		Pmono(\bbb,
			\note, Pseq([
				0,2,7,0,
			],2),
			\lpfr, 1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 2,
			\amp, 0.1,
		),
		Pmono(\planebass,
			\note, Pseq([
				0,2,7,0,
			],inf)+5,
			\env1, Pseq([
				[ Env([1,1,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\plane2,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/4,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		Pmono(\planebass,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pmono(\plane5,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\octave, 5,
			\env1, Pseq([
				[ Env([1,1,1],[0.1,0.8]) ]
			],inf),
			\fmtab, Pseq([
				[ [ 1/4, 1/2, 1/3, 1.01,	 3/2, 1/2.01, 1/3.01, 1/4.01 ] ]
			],inf),
			\gain,8,
			\lpfr, ~pmodenv.(Pseq([1/10,2],inf), 8),
			\foldbias, 0.5,
			\diff, 0.2,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/4,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		Pmono(\planebass,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pmono(\plane2,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,2,1],[0.1,0.8]) ]
			],inf),
			\gain,8,
			\fmr, 1/8,
			\lpfr, 1,
			\rq, 0.1,
			\foldbias, -1.5,
			\foldlevel, 1.5,
			\diff, 0.02 * Pseq([1,1/10],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,1,0,1, 0,0,0,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),

		Pmono(\planebass,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\plane2,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.2,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, 1/8,
			\lpfr, 2,
			\rq, 0.7,
			\foldbias, -1.5,
			\foldlevel, 1.5,
			\diff, 0.02 * Pseq([1,1/10],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\env1, Pseq([
				[ Env([1,1,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\plane2,
			\note, Pstep(Pseq([
				0,2,7,0,
			],inf),1),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.2,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,1/2,
			],inf),
			\lpfr, 2,
			\rq, 0.7 * Pseq([1,1,1/3],inf),
			\foldbias, -1.5,
			\foldlevel, 1.5,
			\diff, 0.02 * Pseq([1,10],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, PdurStutter(Pseq([1,4,3,8],inf), 1/2),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/4,1/7,1/5,1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.1 * Pseq([1,7,3],inf),
			\foldbias, -1.5,
			\foldlevel, 1.5,
			\diff, 0.02 * Pseq([1],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					4,0,0,0, 0,0,1,1,
					1,0,2,0, 0,0,2,0,
					3,0,0,1, 0,0,1,1,
					2,0,1,1, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00401099467303085,
			'delay', 0.0011001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1,1,1,1/4, 1,1,1,1,
				1,1,1,1, 1,1,1,1/10,
				1,1,1,1, 1,1/4,1,1,
				Pser([
					1,1,1/10,1/20,1,
				],8),
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				Pser([
					1,1,10,20,
				],8),
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00401099467303085,
			'delay', 0.0011001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\env1, Pseq([
				[ Env([1,1,1],[0.01,0.8],[-1,-1]) ],
			],inf),
			\hpf, 300,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.4,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.002 * Pseq([1],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.0051099467303085,
			'delay', 0.0010001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\env1, Pseq([
				[ Env([1,1,1],[0.01,0.8],[-1,-1]) ],
			],inf),
			\hpf, 300,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.4,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.002 * Pseq([1],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.0051099467303085,
			'delay', 0.0010001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.01) ],
			],inf),
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.000051099467303085,
			'delay', 0.4000001231 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.01) ],
			],inf),
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.001231 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.01) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.1,0, 0.1,0,
					0,0, 0.1,0,
					0.1,0, 0.1,0,
					0.1,0, 0,0,

					0.1,0, 0.1,0,
					0,0, 0.1,0,
					0.1,0, 0.1,0,
					0.1,0, 0,0,

					0.1,0, 0.1,0,
					0,0.1, 0.1,0,
					0.1,0, 0.1,0,
					0.1,0, 0,0,
				],1),
				Pseq([
					0.1,0, 0,0,
					0.1,0.1, 0,0,
					0.1,0, 0,0,
					0.1,0.1, 0,0,
				],1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.001231 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.01) ],
			],inf),
			\legato, Pseq([
				Pseq([
					0.1,0, 0.1,0,
					0,0, 0.1,0,
					0.1,0, 0.1,0,
					0.1,0, 0,0,

					0.1,0, 0.1,0,
					0,0, 0.1,0,
					0.1,0, 0.1,0,
					0.1,0, 0,0,

					0.1,0, 0.1,0,
					0,0.1, 0.1,0,
					0.1,0, 0.1,0,
					0.1,0, 0,0,
				],1),
				Pseq([
					0.1,0, 0,0,
					0.1,0.1, 0,0,
					0.1,0, 0,0,
					0.1,0.1, 0,0,
				],1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.000031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1,1000,
				1,50,
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 170 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.01) ],
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.000031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1,1000,
				1,50,
				10,
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
)

(
	// shock guitar with beat with compander
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.01) ],
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.000031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1,1000,
				1,50,
				10,
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 1.0,
				\out2, 0,
				\gain2, 0.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\cpbelow, 2.5,
			\cprelax, 0.2,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// sidechain guitar
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.001031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// double guitar
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0, 0.1,0, 0.1,0, 0.1,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,1,0,
				0,0,0,-1,
			],inf),1/8),
			\octave, 4,
			\hpf, 1300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0.0, 0.0,0.0, 0.1,0.0, 0.0,0.0,
				0.1,0.0, 0.0,0.0, 0.1,0.0, 0.0,0.0,
				0.1,0.0, 0.1,0.0, 0.1,0.0, 0.1,0.0,
				0.1,0.0, 0.1,0.0, 0.1,0.0, 0.1,0.0,
				0.1,0.0, 0.0,0.0, 0.1,0.1, 0.0,0.1,
				0.1,0.1, 0.1,0.1, 0.1,0.1, 0.0,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.001031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00011099467303085,
			'delay', 0.0001051031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.010000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 144.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 470 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// double guitar
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0, 0.1,0, 0.1,0, 0.1,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,1,0,
				0,0,0,-1,
			],inf),1/8),
			\octave, 8,
			\hpf, 130,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.4) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
			],inf),
			\legato, Pseq([
				4.1,0.0, 0.0,0.0, 0.1,0.0, 0.0,0.0,
				0.1,0.0, 0.0,0.0, 0.1,0.0, 0.0,0.0,
				0.1,0.0, 0.1,0.0, 0.1,0.0, 0.1,0.0,
				0.1,0.0, 0.1,0.0, 0.1,0.0, 0.1,0.0,
				0.1,0.0, 0.0,0.0, 0.1,0.1, 0.0,0.1,
				0.1,0.1, 0.1,0.1, 0.1,0.1, 0.0,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\env1, Pseq([
				[ Env([1,0.8,2],[0.1,0.8],[1,-1]) ],
			],inf),
			\gain,8,
			\fmr, 1/4,
			\lpfr, 1,
			\rq, 0.9,
			\foldbias, 0.5,
			\foldlevel, 0.5,
			\diff, 0.02 * Pseq([1,1/10],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.001031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00011099467303085,
			'delay', 0.0000201051031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,1, 1,1,1,1,
				1,10,20,30, 1,10,20,30,
				1/Pseq([
					1,10,20,30, 1,10,20,30,
				],1),
			],inf),
			'delay2', 0.010000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 44.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 470 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// double guitar
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),

		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 70,
			\env1, Pseq([
				[ Env([1,0.8,2],[0.1,0.8],[1,-1]) ],
				[ Env([1,0.8,0.2],[0.1,0.8],[1,-1]) ],
				[ Env([1,2,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,0.2,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,1,0.1],[0.1,0.8],[1,-1]) ],
			],inf).stutter(1),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
				[ Env.adsr(0.1,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,1, 0,1,0,1,
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
				1,0,12,0, 0,0,0,0,
				1,0,8,0, 0,0,0,0,
				1,0,1,0, 0,0,12,0,
				0,0,1,0, 0,0,0,1,
			],inf)/8,
			\diff, 0.01,
			\fmr, 1/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,1,0,
				0,0,0,-1,
			],inf),1/8),
			\octave, 8,
			\hpf, 130,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.4) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
			],inf),
			\legato, Pseq([
				4.1,0.0, 0.0,0.0, 0.1,0.0, 0.0,0.0,
				0.1,0.0, 0.0,0.0, 0.1,0.0, 0.0,0.0,
				0.1,0.0, 0.1,0.0, 0.1,0.0, 0.1,0.0,
				0.1,0.0, 0.1,0.0, 0.1,0.0, 0.1,0.0,
				0.1,0.0, 0.0,0.0, 0.1,0.1, 0.0,0.1,
				0.1,0.1, 0.1,0.1, 0.1,0.1, 0.0,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\env1, Pseq([
				[ Env([1,0.8,2],[0.1,0.8],[1,-1]) ],
			],inf),
			\gain,8,
			\fmr, 1/4,
			\lpfr, 1,
			\rq, 0.9,
			\foldbias, 0.5,
			\foldlevel, 0.5,
			\diff, 0.02 * Pseq([1,1/10],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.2344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.100900001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.15714285714286,
			'gain', 2.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.001031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00011099467303085,
			'delay', 0.0000201051031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,1, 1,1,1,1,
				1,10,20,30, 1,10,20,30,
				1/Pseq([
					1,10,20,30, 1,10,20,30,
				],1),
			],inf),
			'delay2', 0.010000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 44.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 470 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				3,4,
			],inf),1),
			\octave, 8,
			\dur, 1/16,
			\fmr,1/8,
			\env1, Pseq([
				[ Env([1,0.1,1],[1/8,1/8]/~t) ],
				[ Env([0.1,1,1],[1/8,1/8]/~t) ],
				[ Env([0.5,1,1],[1/8,1/8]/~t) ],
				[ Env([1,0.4,2],[1/8,1/8]/~t) ],
				[ Env([1,0.1,2],[1/8,1/8]/~t) ],
				[ Env([0.1,1,1],[1/8,1/8]/~t) ],
				[ Env([1.0,0.1,2.1],[1/4,0.8]/~t) ],
				[ Env([1,0.4,2],[1/8,0.8]/~t) ],
			],inf),
			\legato, Pseq([
				2,0,2,0, 2,0,2,0, 1,0,0,0, 1,0,0,0,
				2,0,2,0, 2,0,2,0, 4,0,0,0, 0,0,0,1,
				2,0,2,0, 2,0,2,0, 1,0,0,0, 1,0,1,0,
				2,0,0,0, 2,0,2,0, 4,0,0,0, 0,0,1,0,
			],inf),
			\lag, 0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\diff, 1/18,
			\rq, 0.1,
			\gain, 5,
			\amp, 0.1,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\planebass,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\octave, 3,
			\lpfr, 1,
			\diff, 0.1,
			\trigenv, 1,
			\fmamp, 1.5,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.2344889782792,
			'fb', 0.0001099467303085,
			'delay', 0.100900001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.15714285714286,
			'gain', 2.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.001031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 441.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 100 * Pseq([1,1/4],inf),
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\fx_reverb,
				\delayfac, 2.1,
				\inbus, BusDef(\sendbus3, \audio),
				\out, BusDef(\sendbus1, \audio),
				\dur, 1,
			),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

//////////////////////////////////////////////////////////////////////////////////////


(
	// hibou
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.8,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.02031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1000,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxbus3, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxbus3, \audio),
			\delay, 1/8/~t,
			\fb, 0,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// hibou2
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.8,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.02031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxbus3, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxbus3, \audio),
			\delay, 1/8/~t,
			\fb, 0,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// hibou3
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.7,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.02031 * Pseq([
				1,1,1,1, 1,1,1,1/102,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/Pseq([4,2,8],inf)/~t,
			\fb, 0.8,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// hibou3
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.7,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.00031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
	// dub!!
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,1,0,1,
						0,1,1,0, 0,0,1,1,
						0,1,0,0, 0,1,0,1,
						1,0,0,0, 0,0,0,1,
					],inf),

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.7,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,1,0, 1,0,8,0, 0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,1, 0,0,1,0,
				8,0,7,0, 8,0,8,0, 0,0,0,0, 0,1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.01,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, Pseq([
				6,5,7,8,6,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1,8,5,10,0.5
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,6,0, 1,0,1,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 10,0,0,0, 0,0,1,0, 1,0,0,0,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.02,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 7,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				20,
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,1,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp,0.051,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.00031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
	// dub!! with duber percu
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf),

				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/16,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.7,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,1,0, 1,0,8,0, 0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,1, 0,0,1,0,
				8,0,7,0, 8,0,8,0, 0,0,0,0, 0,1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.01,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, Pseq([
				6,5,7,8,6,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1,8,5,10,0.5
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,6,0, 1,0,1,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 10,0,0,0, 0,0,1,0, 1,0,0,0,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.02,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 7,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				20,
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,1,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp,0.051,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.00031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.00231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)


(
	// dub!! diff fx
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf),

				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/16,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 400 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				2,0,2,0, 2,0,1,1,
				4,0,0,0, 2,0,2,0,
				1,1,1,1, 2,0,1,1,
				1,1,0,0, 2,0,2,0,
				1,1,2,0, 2,0,1,1,
				2,0,1,1, 2,0,2,0,
			],inf)*0.7,
			\lag,0.04,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,1,0, 1,0,8,0, 0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,1, 0,0,1,0,
				8,0,7,0, 8,0,8,0, 0,0,0,0, 0,1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.01,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, Pseq([
				6,5,7,8,6,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1,8,5,10,0.5
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,6,0, 1,0,1,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 4,0,0,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 4,0,1,0,
				0,0,0,0, 10,0,0,0, 0,0,1,0, 1,0,0,0,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.02,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 7,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				20,
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,1,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp,0.051,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.0031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.010000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.01051099467303085,
			'delay', 0.0000231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.080000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
	// dub!! quieter bass
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,

					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
					0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
					],inf),

				],inf).coin.not,
				\sustain, 0.071,
				\speed, Pwhite(0.99,1.01),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.1) ],
				],inf),
				\gain, 0.05,
				\dur, 1/16,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
				1,1, 0,1, 1,0, 1,1,
				1,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.2 * Pseq([1,1/2,0.8,0.4],inf),
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\lag, 0.04, // important!
		),

		Pbind(
			\instrument, \basicbass,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 3,
			\dur, 1/8,
			\lpf, 200 * Pseq([
				1,1.2, 0.81,1,
			],inf),
			\rq, 0.7,
			\legato, Pseq([
				1,0,0,1, 2,0,0,0,
				2,0,1,1, 3,0,0,0,
				1,0,0,1, 2,0,1,1,
				2,0,1,1, 2,0,1,0,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus3, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \distguitar,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 5,
			\hpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.1,0.1) ],
			],inf),
			\legato, Pseq([
				0.1,0
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, PdurStutter(Pseq([4,2,8],inf), 1/2),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2),
			\octave, 8,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,1,0, 1,0,8,0, 0,0,1,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,1, 0,0,1,0,
				8,0,7,0, 8,0,8,0, 0,0,0,0, 0,1,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.01,
		),
		Pbind(
			\instrument, \plane2,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, Pseq([
				5,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				1
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,0,4,0, 10,0,2,0, 0,0,0,0, 10,0,1,0,
				0,0,4,0, 10,0,20,0, 0,0,0,0, 10,0,10,0,
				0,0,0,0, 10,0,20,0, 0,0,1,0, 1,0,10,0,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp,0.02,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 7,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1/Pseq([
				20,
			],inf),
			\fmr, 2,
			\lpfr,4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
			],inf),
			\lag, 0.04,
			\legato, Pseq([
				0,1,
			],inf)/10*2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp,0.051,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.000031 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1,1,1,2
			],inf).stutter(1),
			'delay2', 0.410000543560101 * Pseq([
				1,2,3,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', Pseq([
				100,700,600,
			],inf)*10,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,10,1,1, 1,1,1,1,
				1,100,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxecho, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fxecho, \audio),
			\delay, 1/6/~t,
			\decay, 1.8,
			\hpf, 4000,
			\pfmix, 1,
			\dur, 1,
			\amp, 0.1,
			//\out, BusDef(\fxbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			'wet10', 1.0,
			\mix, 0,
			'mix', 0.45714285714286,
			'gain', 1.844889782792,
			'fb', 0.001051099467303085,
			'delay', 0.0000231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1) *.x Pseq([
				1
			],inf),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1
			],inf),
			'posthpf', 17 * Pseq([
				1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\out, BusDef(\fxbus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\fxbus1, \audio),
				\out, BusDef(\fxbus2, \audio),
				\gain, 0.0,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono(\fx_compander,
			\inbus, BusDef(\fxbus2, \audio),
			\sideinbus, BusDef(\fxbus1, \audio),
			\mix, 1,
			\cpbelow, 1,
			\cpabove, 0.1,
			\cprelax, 0.1,
			\cpt,0.05,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)
/////////////////////////////////////

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pdef(\plane2, Pbind(
			\instrument, \plane2,
			\note, Pseq([
				0,2,7,0,
			],inf),
			\octave, 7,
		));	
	])
)).play;
)

Pdef(\plane2).unset(\legato)

s.boot
FileSystemProject.load("libdef/tracks.scd");

WindowDef(\PdefEditor).front(Pdef(\plane2));

Param(Pdef(\plane2), \fmr).inBusMode
Param(Pdef(\plane2), \fmr).setBusMode(false)
