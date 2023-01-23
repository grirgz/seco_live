(
FileSystemProject.loadOnce("cavern/main.scd");
~t = 165/2/60; TempoClock.default.tempo = ~t;
FileSystemProject('cavern/cave53').loadProject;
)

(
SynthDef(\tump2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = FSinOsc.ar(freq* (1..8) * [ \chord.kr([1,3/2]) ]) * (LFNoise1.kr(6!2!8) * ( 1/( (1..8)**(\harm.kr(1))+1 ) ) * 0.8).max(0);
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.3,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump2,
			\chord, Pseq([
				[[1.01,1]],
				[[1/2,2]],
				[[2,1]],
				[[1,3.midiratio]],
			],inf),
			\note, Pstep(Pseq([0,-1, 0,-6, -9,-1, -10,-9],inf),Pseq([3,1],inf))+8,
			\harm, Pseg(Pseq([0,0.01,1,10],inf),8),
			\harm, Pseq([0.01,10,10],inf),
			\octave, 3,
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,2.1) ],
				[ Env.adsr(0.01,0.21,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 2.8,
		),
		Pbind(
			\instrument, \tump2,
			\chord, Pseq([
				[[1.01,1]],
				[[1/2,2]],
				[[2,1]],
				[[1,3.midiratio]],
			],inf),
			\note, Pstep(Pseq([0,-1, 0,-6, -9,-1, -10,-9],inf),Pseq([3,1],inf))+8,
			\harm, Pseg(Pseq([1,10],inf),8),
			//\harm, Pseq([10,10],inf),
			\octave, 5,
			//\freq, 70,
			\legato,1,
			\adsr, Pseq([
				//[ Env.adsr(0.001,0.01,0.4,2.1) ],
				[ Env.adsr(0.01,0.21,0.4,1.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2].scramble/8,8) }).loop,
			\amp, 2.8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump2,
			\chord, Pseq([
				[[1.01,1]],
			],inf),
			\note, Pstep(Pseq([0,-1, 0,-6, -9,-1, -10,-9],inf),Pseq([3,1],inf))+8,
			\harm, Pseg(Pseq([0,0.01,1,10],inf),8),
			\harm, Pseq([10,10],inf),
			\octave, 4,
			//\freq, 70,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2]/8,8) }).loop,
			\amp, 2.8,
			//\lag, 0.04,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[305].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[107].value,
			\bufnum, ~buflib.clap[376].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				//0,1,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer3, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump2,
			\chord, Pseq([
				[[1.01,1]],
			],inf),
			\note, Pstep(Pseq([0,-1, 0,-6, -9,-1, -10,-9],inf),Pseq([3,1],inf))+8,
			\harm, Pseg(Pseq([0,0.01,1,10],inf),8),
			\harm, Pseq([10,10],inf),
			\octave, 3,
			//\freq, 70,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2]/8,8) }).loop,
			\amp, 2.8,
			//\lag, 0.04,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[305].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[107].value,
			\bufnum, ~buflib.clap[376].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,0,
				//0,1,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1574].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer3, \audio),
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tump2,
			\chord, Pseq([
				[[1.01,1]],
			],inf),
			\note, Pstep(Pseq([0,-1, 0,-6, -9,-1, -10,-9],inf),Pseq([3,1],inf))+8,
			\harm, Pseg(Pseq([0,0.01,1,10],inf),8),
			\harm, Pseq([10,10],inf),
			\octave, 4,
			//\freq, 70,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\dur, Plazy({ Pseq([3,3,2]/8,8) }).loop,
			\amp, 2.8,
			//\lag, 0.04,
			\out, BusDef(\mixer0, \audio),
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[305].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
				\out, BusDef(\mixer1, \audio),
			),
			32, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.07,
				\out, BusDef(\mixer2, \audio),
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[107].value,
				\bufnum, ~buflib.clap[376].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					//0,0,1,0, 0,1,0,1,
					0,0,1,0, 0,0,1,0,
					//0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\mixer3, \audio),
			),
		])
		
	])
)).play;
);


/////////////////////

(
SynthDef(\oscsampler3c, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*\harmtab.kr([1.001,0.999,1]));
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	bufsig = Compander.ar(bufsig, bufsig, \cpt.kr(0.4), \cpbelow.kr(0.50), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
)

Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3c,
		\pos, 0.012,
		//\fshift, -148,
		//\fshift, 100,
		\lpmix, 0.81,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\posenv, Pseq([
			[ Env([0.000,0.000000,0.0014].integrate.postln,[0.02,8.4]) ],
		],inf),
		\harmtab, Pseq([
			[ [1,1.01,1.001] ],
			[ [1.0001,1,1.00001] ],
			[ [1.011,1,0.991] ],
			[ [1,2,3] ],
		],inf).stutter(8),
		\pos, Pseg(Pseq([0.5,1],inf),32),
		\levelScale, 8,
		\timeScale, 1.5,
		\range, 0.0001,
		\ffreq, 5000,
		\note, Pseq([
			0,3,5,
		],inf).stutter(8),
		\octave, 5,
		\bufnum, BufDef('voices/feynman.flac'),
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\ffreqtab, Pseq([
			[ (1..8) ],
			[Array.geom(8,4.1,0.8).postln],
			[Array.geom(8,1.1,0.8).postln]+1,
		],inf).stutter(8),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.01) ],
		],inf),
		\legato, 1.0,
		\dur, 1/4,
		\legato, Pseq([
			2,0,0,1, 4,0,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\amp, 1 * Pkey(\amp),
	)
).play


(
SynthDef(\oscsampler3d, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0.1,4,0.9,1],[0.1,0.1,0.8])), gate);
	osc = SinOsc.ar(freq*\harmtab.kr([1.001,0.999,1]));
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	bufsig = Compander.ar(bufsig, bufsig, \cpt.kr(0.4), \cpbelow.kr(0.50), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (freq * \lpfr.kr(1) * ffreqtab * env1).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).add;
)

(
Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3c,
		\pos, 0.012,
		//\fshift, -148,
		//\fshift, 100,
		\lpmix, 0.81,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\posenv, Pseq([
			[ Env([0.000,0.000100,0.0001].integrate.postln,[0.02,8.4]) ],
		],inf),
		\harmtab, Pseq([
			//[ [1,1.01,1.001] ],
			//[ [1.000001,1,1.00001] ],
			//[ [1.011,1,0.991] ],
			[ [1,2,3] ],
		],inf).stutter(8),
		\pos, Pseg(Pseq([0,1],inf),32),
		\levelScale, 8,
		\timeScale, 1.5,
		\range, 0.0001,
		\ffreq, 5000,
		\note, Pseq([
			0,3,5,
		],inf).stutter(8),
		\octave, 3,
		\bufnum, BufDef('voices/feynman.flac'),
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\ffreqtab, Pseq([
			[ (1..8) ],
			[Array.geom(8,4.1,0.8).postln],
			[Array.geom(8,1.1,0.8).postln]+1,
		],inf).stutter(8),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.01) ],
		],inf),
		\legato, 1.0,
		\dur, 1/4,
		\legato, Pseq([
			1,1,1,1, 1,1,1,1,
			2,0,0,1, 4,0,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\amp, 1 * Pkey(\amp),
	)
).play
)

(
Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3d,
		\pos, 0.012,
		\fshift, -148,
		//\fshift, 100,
		\lpmix, 0.81,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\lpenv, Pseq([
			[ Env([1,2,1,4.1],[0.01,0.1,1]) ]
		],inf),
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\posenv, Pseq([
			[ Env([0.000,0.00001,0.00001].integrate.postln,[0.02,8.4]) ],
		],inf),
		\harmtab, Pseq([
			//[ [1,1.01,1.001] ],
			//[ [1.000001,1,1.00001] ],
			//[ [1.011,1,0.991] ],
			[ [1,2,3] ],
		],inf).stutter(8),
		\pos, Pseg(Pseq([0,1],inf),32),
		\levelScale, 8,
		\timeScale, 1.5,
		\range, 0.0001,
		\ffreq, 5000,
		\freq, Pexprand(60.0,1400),
		\freq, Pbrown(60,100,1),
		\octave, 3,
		\bufnum, BufDef('voices/feynman.flac'),
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\ffreqtab, Pseq([
			[ (1..8) ],
			[Array.geom(8,4.1,0.8).postln],
			[Array.geom(8,1.1,0.8).postln]+1,
		],inf).stutter(8),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.01) ],
		],inf),
		\legato, 1.0,
		\dur, 1/4,
		\legato, Pseq([
			1,1,1,1, 1,1,1,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\amp, 1 * Pkey(\amp),
	)
).play
)

(
Pdef(\sample, 
	Pbind(
		\instrument, \oscsampler3c,
		\pos, 0.012,
		\fshift, -148,
		//\fshift, 100,
		\lpmix, 0.81,
		\hpmix, 0.0,
		\hpfreq, 10,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
		],inf),
		\posenv, Pseq([
			[ Env([0.000,0.0005100,0.001].integrate.postln,[0.02,8.4]) ],
		],inf),
		\harmtab, Pseq([
			//[ [1,1.01,1.001] ],
			//[ [1.000001,1,1.00001] ],
			//[ [1.011,1,0.991] ],
			[ [1,2,3] ],
			[ [1,4/3,3] ],
		],inf).stutter(8),
		\pos, Pseg(Pseq([0,1],inf),32),
		\levelScale, 8,
		\timeScale, 1.5,
		\range, 0.0001,
		\ffreq, 5000,
		\freq, Pexprand(60.0,1400),
		\freq, Pbrown(60,100,1),
		\octave, 3,
		\bufnum, BufDef('voices/feynman.flac'),
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\ffreqtab, Pseq([
			[ (1..8) ],
			[Array.geom(8,4.1,0.8).postln],
			[Array.geom(8,1.1,0.8).postln]+1,
		],inf).stutter(8),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,0.1) ],
		],inf),
		\legato, 1.0,
		\dur, 1/4,
		\legato, Pseq([
			1,1,1,1, 1,1,1,1,
		],inf)*0.1,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\amp, Pseq([
			1,0.5,0.7,0.2,
		],inf) + Pwhite(-1.0,1)/2 * 0.1,
		\amp, 1 * Pkey(\amp),
	)
).play
)
