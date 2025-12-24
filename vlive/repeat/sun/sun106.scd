
~t = 101/4/60; TempoClock.default.tempo = ~t;
~t = 101/2/60; TempoClock.default.tempo = ~t; // test
(
FileSystemProject.loadOnce("algokit/kits/PatKitDef_sample1.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
FileSystemProject.loadOnce("sndlib/synthplayrec.scd");
)
(
SynthDef(\snappad, {
	var snd, freq;
	freq = \freq.kr(440);
	// Four pulse waves (two one octave down) with randomly modulated pitches and pulse widths
	snd = Pulse.ar(
		freq * ({ LFNoise2.kr(0.3).range(-0.05, 0.05).midiratio }.dup(4)) * [1, 1/2, 1/2, 1],
		{ LFNoise2.kr(0.3).range(0.3, 0.7) }.dup(4)
	);
	snd = snd + SinOsc.ar(freq * ( LFSaw.ar(freq*[2,1/2,1,2]) * 4 + 1 ), mul: LFNoise1.kr(1!4).unipolar); 
	// Spread across stereo field
	snd = Splay.ar(snd);
	// Sharp hi cut made by cascading three lowpass filters
	3.do { snd = LPF.ar(snd, \ffreq.kr(1500)); };
	snd = snd * Env.asr(\at.kr(3), \sustainlevel.kr(1), \rel.kr(3), -4).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(0.1)));
}).add;
)
(
SynthDef(\fxsoftener, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = AllpassL.ar(sig, 0.1,0.0001 * SinOsc.ar(1/4).range(0.5,2)+0.02 ,1) + sig;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.9), \room.kr(4), \damp.kr(0.4));
	//sig = sig.fold2(0.001);
	//sig = HPF.ar(sig, \hpf.kr(10));
	sig = SelectX.ar(\mix.kr(0.9), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

///////

(
// drums
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5],1),8).loop,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		
	])
)).play;
);

(
// more drums
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5,1/5],1),8).loop,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1,1000],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[300].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.clap[273].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),

				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				]+0.2,1),

			],inf).coin.not,
			\hpmix, 1,
			\hpf, Pseq([
				Pser([
					100,200, 2000,
					500,8000, 2000,
				],8),

				8000,
				Pser([
					1400,10000,4000,
				],7),
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				].linlin(0,1,0.3,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1288].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 1,0,0,1, 
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07,
		),
		
	])
)).play;
);

(
// add chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5,1/5],1),8).loop,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1,1000],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[300].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.clap[273].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),

				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				]+0.2,1),

			],inf).coin.not,
			\hpmix, 1,
			\hpf, Pseq([
				Pser([
					100,200, 2000,
					500,8000, 2000,
				],8),

				8000,
				Pser([
					1400,10000,4000,
				],7),
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				].linlin(0,1,0.3,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1288].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 1,0,0,1, 
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \snappad,
			\fspread, 0.0000100474975,
			\fmadsr, Pseq([
				[ Env.adsr(10.1,10.1,0.1,7.1) ],
			],inf),
			\fmadsramt, 4.0,
			\fmf, 1.000,
			\fmoscmix, 1.0,
			\fma, 0.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\oscmix, 0,
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,3.4,0.7,4.1) ],
			],inf),
			\lpadsramt, 4.0,
			\lpf, 4100.0,
			\ffreq, 4100,
			\rq, 0.7,
			\note, Pseq([
				[0,3+12,7,12],
				[-1,3+12,7,13],
			],inf).stutter(8*4),
			\octave, 5,
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(5.1,5.1,0.8,2.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			//\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxsoftener,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lag, 0.0009,
			\gain, 2,
			\dur, 1,
		),
		
	])
)).play;
);

(
// add bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5,1/5],1),8).loop,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1,1000],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[300].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.clap[273].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),

				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				]+0.2,1),

			],inf).coin.not,
			\hpmix, 1,
			\hpf, Pseq([
				Pser([
					100,200, 2000,
					500,8000, 2000,
				],8),

				8000,
				Pser([
					1400,10000,4000,
				],7),
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				].linlin(0,1,0.3,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1288].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 1,0,0,1, 
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \snappad,
			\fspread, 0.0000100474975,
			\fmadsr, Pseq([
				[ Env.adsr(10.1,10.1,0.1,7.1) ],
			],inf),
			\fmadsramt, 4.0,
			\fmf, 1.000,
			\fmoscmix, 1.0,
			\fma, 0.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\oscmix, 0,
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,3.4,0.7,4.1) ],
			],inf),
			\lpadsramt, 4.0,
			\lpf, 4100.0,
			\ffreq, 4100,
			\rq, 0.7,
			\note, Pseq([
				[0,3+12,7,12],
				[-1,3+12,7,13],
			],inf).stutter(8*4),
			\octave, 5,
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(5.1,5.1,0.8,2.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			//\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxsoftener,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lag, 0.0009,
			\gain, 2,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsramt, 1.0,
			\fmf, 1.0001,
			\fmoscmix, 0.0,
			\fma, 4.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.4,0.4,0.1) ],
			],inf),
			\lpadsramt, 6.0,
			\lpf, 100.0,
			\lpf, PmodEnv(Pseq([70,120,500],1), 8).loop,
			\rq, 0.5,
			\note, Pseq([
				Pser([
					7,3,0, 7,3,0, 7,3,
				],4*8),
				Pser([
					7,3,-1, 7,3,-1, 7,3,
				],4*8),
				Pser([
					-5,0,3,-5,0,3,-5,3,
					-5,0,3,-5,0,3,-5,3,
					-5,0,3,-5,0,3,-5,3,
					-5,3,7,-5,-4,7,-5,7,
				],4*8),
				Pser([
					-5,-1,0,-5,-1,0,-5,3,
					-5,-1,0,-5,-1,0,-5,3,
					-5,-1,0,-5,-1,0,-5,3,
					-5,-4,1,-5,1,3,-5,3,
				],4*8),
			],inf)-4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/4,
			\legato, Pseq([
				Pseq([
					0.7,
					0.7,
					1.0,
				],inf),
				3,0,0,1, 0,0,1,0,
				0,1,0,0, 2,0,1/2,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.51) ],
			],inf),
		),
		
	])
)).play;
);

(
SynthDef(\fxcymbal, { arg out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = in;
	//sig = sig * SinOsc.ar(300 * SinOsc.ar(1/4).range(1,100) );
	lfo1 = SinOsc.ar(1/75).range(2,1/100); 
	lfo2 = SinOsc.ar(1/34,pi).range(1,100); 
	//sig = Resonz.ar(sig,8901 * lfo1);
	//sig = ( sig*lfo2 ).clip2(0.01)/3;

	sig1 = sig * LFPulse.ar(16*~t).range(0,1); 
	sig2 = sig * LFPulse.ar(8*~t).range(0,1); 
	sig3 = sig * LFPulse.ar(12*~t).range(0,1); 
	sig = SelectX.ar(\trem.kr(0)*3, [sig, sig1, sig2,sig3]);

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// vary cymbal
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5,1/5],1),8).loop,
		),
		Pbind( // cymbal
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			//\hpf, PmodEnv(Pseq([4000,1,1000],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx2, \audio),
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[300].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.clap[273].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),

				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				]+0.2,1),

			],inf).coin.not,
			\hpmix, 1,
			\hpf, Pseq([
				Pser([
					100,200, 2000,
					500,8000, 2000,
				],8),

				8000,
				Pser([
					1400,10000,4000,
				],7),
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				].linlin(0,1,0.3,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1288].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 1,0,0,1, 
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \snappad,
			\fspread, 0.0000100474975,
			\fmadsr, Pseq([
				[ Env.adsr(10.1,10.1,0.1,7.1) ],
			],inf),
			\fmadsramt, 4.0,
			\fmf, 1.000,
			\fmoscmix, 1.0,
			\fma, 0.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\oscmix, 0,
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,3.4,0.7,4.1) ],
			],inf),
			\lpadsramt, 4.0,
			\lpf, 4100.0,
			\ffreq, 4100,
			\rq, 0.7,
			\note, Pseq([
				[0,3+12,7,12],
				[-1,3+12,7,13],
			],inf).stutter(8*4),
			\octave, 5,
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(5.1,5.1,0.8,2.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			//\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxcymbal,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\mix, 1,
			\lag, 0.0009,
			\gain, 2,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsramt, 1.0,
			\fmf, 1.0001,
			\fmoscmix, 0.0,
			\fma, 4.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.4,0.4,0.1) ],
			],inf),
			\lpadsramt, 6.0,
			\lpf, 100.0,
			\lpf, PmodEnv(Pseq([70,120,500],1), 8).loop,
			\rq, 0.5,
			\note, Pseq([
				Pser([
					7,3,0, 7,3,0, 7,3,
				],4*8),
				Pser([
					7,3,-1, 7,3,-1, 7,3,
				],4*8),
				Pser([
					-5,0,3,-5,0,3,-5,3,
					-5,0,3,-5,0,3,-5,3,
					-5,0,3,-5,0,3,-5,3,
					-5,3,7,-5,-4,7,-5,7,
				],4*8),
				Pser([
					-5,-1,0,-5,-1,0,-5,3,
					-5,-1,0,-5,-1,0,-5,3,
					-5,-1,0,-5,-1,0,-5,3,
					-5,-4,1,-5,1,3,-5,3,
				],4*8),
			],inf)-4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/4,
			\legato, Pseq([
				Pseq([
					0.7,
					0.7,
					1.0,
				],inf),
				3,0,0,1, 0,0,1,0,
				0,1,0,0, 2,0,1/2,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.51) ],
			],inf),
		),
		
	])
)).play;
);

(
// add vbreak
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5,1/5],1),8).loop,
		),
		Pbind( // cymbal
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			//\hpf, PmodEnv(Pseq([4000,1,1000],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx2, \audio),
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[300].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.clap[273].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),

				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				]+0.2,1),

			],inf).coin.not,
			\hpmix, 1,
			\hpf, Pseq([
				Pser([
					100,200, 2000,
					500,8000, 2000,
				],8),

				8000,
				Pser([
					1400,10000,4000,
				],7),
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,1,
					0,0,0,0, 1,1,0,0,
					0,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 1,0,1,1,
				].linlin(0,1,0.3,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1288].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 1,0,0,1, 
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \snappad,
			\fspread, 0.0000100474975,
			\fmadsr, Pseq([
				[ Env.adsr(10.1,10.1,0.1,7.1) ],
			],inf),
			\fmadsramt, 4.0,
			\fmf, 1.000,
			\fmoscmix, 1.0,
			\fma, 0.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\oscmix, 0,
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,3.4,0.7,4.1) ],
			],inf),
			\lpadsramt, 4.0,
			\lpf, 4100.0,
			\ffreq, 4100,
			\rq, 0.7,
			\note, Pseq([
				[0,3+12,7,12],
				[-1,3+12,7,13],
			],inf).stutter(8*4),
			\octave, 5,
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(5.1,5.1,0.8,2.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
			//\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxcymbal,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\mix, 1,
			\trem, PmodEnv(Pwhite(0.0,1,8), 3).loop,
			\lag, 0.0009,
			\gain, 2,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsramt, 1.0,
			\fmf, 1.0001,
			\fmoscmix, 0.0,
			\fma, 4.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.4,0.4,0.1) ],
			],inf),
			\lpadsramt, 6.0,
			\lpf, 100.0,
			\lpf, PmodEnv(Pseq([70,120,500],1), 8).loop,
			\rq, 0.5,
			\note, Pseq([
				Pser([
					7,3,0, 7,3,0, 7,3,
				],4*8),
				Pser([
					7,3,-1, 7,3,-1, 7,3,
				],4*8),
				Pser([
					-5,0,3,-5,0,3,-5,3,
					-5,0,3,-5,0,3,-5,3,
					-5,0,3,-5,0,3,-5,3,
					-5,3,7,-5,-4,7,-5,7,
				],4*8),
				Pser([
					-5,-1,0,-5,-1,0,-5,3,
					-5,-1,0,-5,-1,0,-5,3,
					-5,-1,0,-5,-1,0,-5,3,
					-5,-4,1,-5,1,3,-5,3,
				],4*8),
			],inf)-4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/4,
			\legato, Pseq([
				Pseq([
					0.7,
					0.7,
					1.0,
				],inf),
				3,0,0,1, 0,0,1,0,
				0,1,0,0, 2,0,1/2,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.51) ],
			],inf),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 2 * ~t / Pkey(\st) * Pseq([
				1,1,1,1, 0.81,1,1,1,
			],inf),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)/8,
				(0..15)/8,

				Prand((0..4),12)/8,
				(12..15)/8,

				[ 0,1,2,3, ].scramble/8,
				[ 0,1,2,3, ].scramble/8+0.5,
				[ 0,1,2,3, ].scramble/8+1,
				[ 0,1,2,3, ].scramble/8+1.5,
				//(12..15)/8,

				//(0..15)/8,

				//(0..3)/8,
				//(0..3)/4+0.5,
				//(0..3)/8+1,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ Pwhite(0,0.7,3)+13,7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ Pwhite(0,0.7,3)+9,7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ Pwhite(4,4.7,3),7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ 4,4.3,4.6,7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3,3,3, ]/8,
				//(6..15)/8,
				
			].flat,inf),
			\pos, Pseq([
				(0..15)/8,
				(0..15)/8,

				Prand((0..4),12)/8,
				(12..15)/8,

				Prand((0..3),4)/8,
				//(0..3)/8,
				Prand((0..3),4)/8+0.5,
				//(0..3)/8+0.5,
				//Prand((0..3),4)/8+1,
				(0..3)/8+1,
				Prand((0..3),4)/8+1.5,
			].flat,inf),
			\dur, 1/16,
			\gain, 1/6,
		),
	])
)).play;
);

/////
(
// add bass 2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind( // bass
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsramt, 1.0,
			\fmf, 1.0001,
			\fmoscmix, 0.0,
			\fma, 4.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.4,0.4,0.1) ],
			],inf),
			\lpadsramt, 6.0,
			\lpf, 100.0,
			\rq, 0.5,
			\note, Pseq([
				0,-1,0,0,
			],inf)-4,
			\octave, 3,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1/4,
			\legato, 1/2,
			\legato, Pseq([
				3,0,0,1, 0,0,1,0,
				0,1,0,0, 2,0,1/2,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
		),
		Pbind(
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, Pseq([
				[ Env.adsr(4.1,0.1,0.8,7.1) ],
			],inf),
			\fmadsramt, 1.0,
			\fmf, 1.0001,
			\fmoscmix, 0.0,
			\fma, 4.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,3.4,0.7,4.1) ],
			],inf),
			\lpadsramt, 2.0,
			\lpf, 1100.0,
			\rq, 0.5,
			\note, Pseq([
				[0,3,7],
				[-1,3,7,13],
			],inf).stutter(8*4),
			\octave, 5,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/8/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,7,6,7,5,4,7,3,
			],inf).stutter(1),
			\octave, 5,
			\dur, 1/4,
			\isRest, Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf).coin.not,
			\amp, 0.1/2,
			\isRest, true,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind( // bass
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsramt, 1.0,
			\fmf, 1.0001,
			\fmoscmix, 0.0,
			\fma, 4.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.4,0.4,0.1) ],
			],inf),
			\lpadsramt, 6.0,
			\lpf, 100.0,
			\rq, 0.5,
			\note, Pseq([
				0,-1,0,0,
			],inf)-4,
			\octave, 3,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1/4,
			\legato, 1/2,
			\legato, Pseq([
				3,0,0,1, 0,0,1,0,
				0,1,0,0, 2,0,1/2,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				8,5,4,3,
			],inf).stutter(8*2),
			\octave, 5,
			\dur, 1/8,
			\isRest, Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf).coin.not,
			\amp, 0.1/2 * Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,2,1,0,
			],inf).stutter(8*2),
			\octave, 5,
			\dur, 1/8,
			\isRest, Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf).coin.not,
			\amp, 0.1/2 * Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				12,8,10,8,
				//10,11,10,12,
			],inf).stutter(8*2),
			\octave, 5,
			\dur, 1/8,
			\isRest, Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf).coin.not,
			\amp, 0.1/2 * Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				15,14,
				10,11,10,12,11,
				0,0,8,12,
			],inf).stutter(1),
			\octave, 6,
			\dur, 1/8,
			\isRest, Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			]/2,inf).coin.not,
			\amp, 0.1/2 * Pseq([
				1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind( // bass
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsramt, 1.0,
			\fmf, 1.0001,
			\fmoscmix, 0.0,
			\fma, 4.7,
			\oscmix, Pseg(Pseq([0,1/3],inf),8),
			\spread, 0.10000000149012,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.4,0.4,0.1) ],
			],inf),
			\lpadsramt, 6.0,
			\lpf, 100.0,
			\rq, 0.5,
			\note, Pseq([
				0,-1,0,0,
			],inf)-4 + Pstep(Pseq([
				0,-2
			],inf),2),
			\octave, 3,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1/4,
			\legato, 1/2,
			\legato, Pseq([
				3,0,0,1, 0,0,1,0,
				0,1,0,0, 2,0,1/2,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
		),
		Prout{ arg ev;
			Pseq([
				[8,12,15],
				[10,15,18],
			],inf).do { arg line, idx;
				line.debug("line");
				ev = Pfindur(2,Ppar(
					line.collect { arg item, idx;
						Pbind(
							\instrument, \sh101,
							\note, Pseq([
								item,
							],inf).stutter(8*2),
							\octave, 4 + rrand(0,2),
							\dur, 1/8,
							\lpf, 100,
							\envamt, 14,
							\adsr, Pseq([
								[ Env.adsr(0.01,0.1,0.8,1.1) ],
							],inf),
							\isRest, Pseq([
								1,0.4,0.4,0.4, 0.4,0.4,0.4,0.4,
							],inf).coin.not,
							\isRest, Pseq([
								Prand([
									1,Pseq([1,0,],1)
								],1),
								0,1,0,1,1,0,0,
							],inf).coin.not,
							\amp, 0.1/2 * Pseq([
								1,0.4,0.4,0.4, 0.4,0.4,
							],inf),
							\out, BusDef(\sendbus1, \audio),
							\lag, -0.04,
						)
					};
				)).embedInStream;
			
			}
		},
		
	])
)).play;
);


(
// play with rdn \nicereverb
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					1,6,1,1,
				],4),
				Pseq([
					0,7,0,0,
				],4),
			],inf),
			\legato, Pseq([
				1,0,0,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,5,
			],inf) - Pstep(Pseq([0],inf),2),
			\octave, 6,
			\dur, 1/8/2,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				13,12,
			],inf).stutter(8),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				10,
				//9,
			],inf).stutter(8),
			\octave, [3,4,5],
			\lpf, PmodEnv(Pseq([4000,100,440,1000],1), 2).loop,
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5],1),8).loop,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
		
	])
)).play;
);

//// play with chords
(
Pdef(\part, Pdef(\bdrums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.kick[1357].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\hpfmix, 1,
			\hpf, 800,
			\hpf, PmodEnv(Pseq([800,4],1), 8).loop,
			\lpfmix, 1,
			\lpf, 1000,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5 * Pseg(Pseq([1,1/5],1),8).loop,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1362].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([4000,1],1), 8).loop,
			\legato, 2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\legato, 4,
			\pan, 0.5,
			\dur, 1/8,
			\gain, 0.08,
		),
	])
)).play;
);
(
// [1,6,10,13] to [0,6,10,12]
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					1,6,1,1,
				],4),
				Pseq([
					0,6,0,0,
				],4),
			],inf),
			\legato, Pseq([
				1,0,0,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				13,12,
			],inf).stutter(8),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				10,
				//9,
			],inf).stutter(8),
			\octave, [3,4,5],
			\lpf, PmodEnv(Pseq([4000,100,440,1000],1), 2).loop,
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pdef(\bdrums1),
	])
)).play;
);

(
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					1,7,1,1,
				],4),
				Pseq([
					0,7,0,0,
				],4),
			],inf),
			\legato, Pseq([
				1,0,0,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				13,12,
			],inf).stutter(8),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				10,
				//9,
			],inf).stutter(8),
			\octave, [3,4,5],
			\lpf, PmodEnv(Pseq([4000,100,440,1000],1), 2).loop,
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
		Pdef(\bdrums1)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,6,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				10,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				13,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,6,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				10,
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				12,
			],inf),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,6,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				6,
			],inf),
			\octave, 6,
			\dur, 1/5,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				10,
			],inf),
			\octave, 5,
			\dur, 1/9,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				12,
			],inf),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);


////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[6,10,13,15],
				[5,10,13,15],
				[4,10,13,15],
				[5,9,12,15],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				1,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
				1,0,1,1, 1,1,1,1,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[6,10,13,15],
				[5,10,13,15],
				[4,10,13,15],
				[5,9,12,15],
			],inf),
			\octave, 6,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,1,3,Prand([1,Pseq([3,0],1)],inf)
			],inf),
			\octave, Pbrown(4,6).round(1),
			\dur, 1/8/2,
			\amp, 0.08,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[6,10],
				[5,10],
				[4,10],
				[5,9],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,1,3,Prand([1,Pseq([3,0],1)],inf)
			],inf),
			\octave, Pbrown(4,6).round(1),
			\dur, 1/8/2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				[6,10,15,13],
				[5,10,15,13],
				[4,10,15,13],
				[3,9,15,12],
				//[4,9,15,13],
			].stutter(2).flat,inf),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				[6,10,15,13],
				[5,10,15,13],
				[4,10,15,13],
				[3,9,15,12],
				//[4,9,15,13],
			].stutter(2).flat,inf),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \prophet5pwmstrings,
			\instrument, \Piano_rhodeySC,
			\modIndex, PmodEnv(Pseq([0,1],1), 8).loop,
			\note, Pseq([
				Pfin(8*2, Pseq([ 3,Prand([1,0,Pseq([1,0])]) ],inf) ),
				Pfin(8*2, Pseq([ 5,Prand([3,1,0],2) ],inf) ),
				Pfin(8*2, Pseq([ 6,Prand([5,3,1,0,Pseq([1,0])],2) ],inf) ),
				Pfin(8*2, Pseq([ 3,Prand([-3,3,9,15,12,0],2) ],inf) ),
			],inf),
			\lpf, PmodEnv(Pseq([8000,200],1), 8).loop,
			\octave, 5,
			\dur, 1/16,
			\amp, 0.1/2 * Pseq([
				1,1,1,Plazy({ Pn([0.5,0.2,0.7,1,0].choose,rrand(1,3)) }),
			],inf),
		),
		Pbind(
			\instrument, \prophet5pwmstrings,
			\instrument, \Piano_rhodeySC,
			\modIndex, PmodEnv(Pwhite(0,1,8), 8).loop,
			\note, Pseq([
				Pfin(8*2, Pseq([ 3,Prand([1,0,Pseq([1,0])]) ],inf) ),
				Pfin(8*2, Pseq([ 5,Prand([3,1,0],2) ],inf) ),
				Pfin(8*2, Pseq([ 6,Prand([5,3,1,0,Pseq([1,0])],2) ],inf) ),
				Pfin(8*2, Pseq([ 3,Prand([-3,3,9,15,12,0],2) ],inf) ),
			],inf),
			\lpf, PmodEnv(Pseq([8000,200],1), 8).loop,
			\octave, 6,
			\dur, 1/16,
			\amp, 0.1/2 * Pseq([
				0,Plazy({ Pn(rrand(0.1,1),rrand(1,5)) }),
			],inf),
		),
		Pbind(
			\instrument, \prophet5pwmstrings,
			\note, Pseq([
				Pfin(8*2, Pseq([ 3,Prand([1,0,Pseq([1,0])]) ],inf) ),
				Pfin(8*2, Pseq([ 5,Prand([3,1,0],2) ],inf) ),
				Pfin(8*2, Pseq([ 6,Prand([5,3,1,0,Pseq([1,0])],2) ],inf) ),
				Pfin(8*2, Pseq([ 3,Prand([-3,3,9,15,12,0],2) ],inf) ),
			],inf),
			\cutoff, PmodEnv(Prand([8000,200,14000,4000,16000],8), 2).loop,
			\octave, Pseq([7,7,Prand([7,7,7,6,Pseq([7,7,6,6])])],inf),
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.7,0.1,0.8,0.7) ],
			],inf),
			\legato, Pseq([
				3,0,0,6, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				2,0,0,0, 4,0,0,0,
				7,0,0,0, 0,0,0,1,
				4,0,0,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2 * Pseq([
				Plazy({ Pn(rrand(0.1,1),rrand(1,5)) }),
			],inf),
		),
		Pdef(\smpdrums4),
		//Pdef(\smpdrums1),
		Pdef(\smpdrums3),
	])
)).play;
);

(
Pdef(\part, Pdef(\smpdrums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 2 * ~t / Pkey(\st) * Pseq([
				1,1,1,1, 0.81,1,1,1,
			],inf),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)/8,
				(0..15)/8,

				Prand((0..4),12)/8,
				(12..15)/8,

				[ 0,1,2,3, ].scramble/8,
				[ 0,1,2,3, ].scramble/8+0.5,
				[ 0,1,2,3, ].scramble/8+1,
				[ 0,1,2,3, ].scramble/8+1.5,
				//(12..15)/8,

				//(0..15)/8,

				//(0..3)/8,
				//(0..3)/4+0.5,
				//(0..3)/8+1,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ Pwhite(0,0.7,3)+13,7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ Pwhite(0,0.7,3)+9,7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ Pwhite(4,4.7,3),7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3, ]/8,
				//[ 4,4.3,4.6,7, ]/8,
				//[ 8,9,10,11, ]/8,
				//(12..15)/8,

				//[ 0,1,1,3,3,3, ]/8,
				//(6..15)/8,
				
			].flat,inf),
			\pos, Pseq([
				(0..15)/8,
				(0..15)/8,

				Prand((0..4),12)/8,
				(12..15)/8,

				Prand((0..3),4)/8,
				//(0..3)/8,
				Prand((0..3),4)/8+0.5,
				//(0..3)/8+0.5,
				//Prand((0..3),4)/8+1,
				(0..3)/8+1,
				Prand((0..3),4)/8+1.5,
			].flat,inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/6,
		),

	])
)).play;
);
(
Pdef(\part, Pdef(\smpdrums2, // cropped
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 2 * ~t / Pkey(\st) * Pseq([
				1,1,1,1, 0.81,1,1,1,
			],inf),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)/8,
				(0..15)/8,

				Prand((0..4),12)/8,
				(12..15)/8,

				Prand((0..3),4)/8,
				//(0..3)/8,
				Prand((0..3),4)/8+0.5,
				//(0..3)/8+0.5,
				//Prand((0..3),4)/8+1,
				(0..3)/8+1,
				Prand((0..3),4)/8+1.5,
			].flat,inf),
			\isRest, Pseq([
				1,1,1,0, 1,0,1,0,
				1,0,1,1, 1,0,0,1,
				1,0,0,0, 1,1,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playerbalancesec,
			//\bufnum, ~buflib.hat[1846].value,
			//\bufnum, ~buflib.hat[1793].value,
			//\bufnum, ~buflib.hat[1347].value,
			\bufnum, ~buflib.hat[635].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
				0,0,0,0, 
				1,0,1,0, 1,0,1,0, 
			],inf).coin.not,
			\pan, 0.5,
			\dur, 1/8/2,
			\gain, 0.08,
		),

	])
)).play;
);


(
SynthDef(\drumloopfx, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var ffreq = 1400;
	sig = in;
	//sig = sig * SinOsc.ar(ffreq);
	sig = HPF.ar(sig, 500);
	sig = LPF.ar(sig, 6000);
	//sig = AllpassL.ar(sig, 0.1,0.07,1) + sig;
	sig = FreqShift.ar(sig, -4000);
	sig = HPF.ar(sig, 5000);
	sig = LPF.ar(sig, 16000);
	sig = Resonz.ar(in, 7000,0.1)*2 + sig;
	sig = FreqShift.ar(sig, -2000);
	sig = Compander.ar(sig, in, \cpt.kr(0.2), \cpbelow.kr(0.201), \cpabove.kr(0.09), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = Compander.ar(in, in, \cpt.kr(0.1), \cpbelow.kr(3.201), \cpabove.kr(1.09), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = DelayL.ar(sig, 0.1,0.01 * ( SinOsc.kr(2*~t) * 0.7 + 1 )) + sig;
	sig = sig * 0.5;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
Pdef(\part, Pdef(\smpdrums3, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 2 * ~t / Pkey(\st) * Pseq([
				1,1,1,1, 0.81,1,1,1,
			],inf),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)/8,
				(0..15)/8,

				(0..3)/8,
				(0..3)/8+0.5,
				Prand((0..3),4)/8+1,
				(0..3)/8+1.5,

				//Prand((0..3),4)/8,
				(0..3)/8,
				Prand((0..3),4)/8+0.5,
				//(0..3)/8+0.5,
				//Prand((0..3),4)/8+1,
				(0..3)/8+1,
				Prand((0..3),4)/8+1.5,
			].flat,inf),
			\dur, 1/16,
			\gain, 1/6,
			\out, BusDef(\smpfx, \audio),
		),
		Pmono(\drumloopfx,
			\inbus, BusDef(\smpfx, \audio),
			\addAction, \addToTail,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),

	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Ptpar([
			0, Pbind(
				\instrument, \organ_tonewheel0,
				\note, Pseq([
					[6,10,15,13],
					[5,10,15,13],
					[4,10,15,13],
					[3,9,15,12],
					//[4,9,15,13],
				].stutter(2).flat,inf),
				\octave, 4,
				\dur, 1/8,
				\amp, 0.1,
			),
			4, Pbind(
				\instrument, \Piano_rhodeySC,
				\modIndex, PmodEnv(Pseq([0,1],1), 8).loop,
				\note, Pseq([
					Pfin(8*2, Pseq([ 3,Prand([1,0,Pseq([1,0])]) ],inf) ),
					Pfin(8*2, Pseq([ 5,Prand([3,1,0],2) ],inf) ),
					Pfin(8*2, Pseq([ 6,Prand([5,3,1,0,Pseq([1,0])],2) ],inf) ),
					Pfin(8*2, Pseq([ 3,Prand([-3,3,9,15,12,0],2) ],inf) ),
				],inf),
				\lpf, PmodEnv(Pseq([8000,200],1), 8).loop,
				\octave, 5,
				\dur, 1/16,
				\amp, 0.1/2 * Pseq([
					1,1,1,Plazy({ Pn([0.5,0.2,0.7,1,0].choose,rrand(1,3)) }),
				],inf),
			),
			8, Pbind(
				\instrument, \Piano_rhodeySC,
				\modIndex, PmodEnv(Pwhite(0,1,8), 8).loop,
				\note, Pseq([
					Pfin(8*2, Pseq([ 3,Prand([1,0,Pseq([1,0])]) ],inf) ),
					Pfin(8*2, Pseq([ 5,Prand([3,1,0],2) ],inf) ),
					Pfin(8*2, Pseq([ 6,Prand([5,3,1,0,Pseq([1,0])],2) ],inf) ),
					Pfin(8*2, Pseq([ 3,Prand([-3,3,9,15,12,0],2) ],inf) ),
				],inf),
				\lpf, PmodEnv(Pseq([8000,200],1), 8).loop,
				\octave, 6,
				\dur, 1/16,
				\amp, 0.1/2 * Pseq([
					0,Plazy({ Pn(rrand(0.1,1),rrand(1,5)) }),
				],inf),
			),
			12, Pbind(
				\instrument, \prophet5pwmstrings,
				\note, Pseq([
					Pfin(8*2, Pseq([ 3,Prand([1,0,Pseq([1,0])]) ],inf) ),
					Pfin(8*2, Pseq([ 5,Prand([3,1,0],2) ],inf) ),
					Pfin(8*2, Pseq([ 6,Prand([5,3,1,0,Pseq([1,0])],2) ],inf) ),
					Pfin(8*2, Pseq([ 3,Prand([-3,3,9,15,12,0],2) ],inf) ),
				],inf),
				\cutoff, PmodEnv(Prand([8000,200,14000,4000,16000],8), 2).loop,
				\octave, Pseq([7,7,Prand([7,7,7,6,Pseq([7,7,6,6])])],inf),
				\dur, 1/16,
				\adsr, Pseq([
					[ Env.adsr(0.7,0.1,0.8,0.7) ],
				],inf),
				\legato, Pseq([
					3,0,0,6, 0,0,0,0,
					7,0,0,0, 0,0,0,0,
					2,0,0,0, 4,0,0,0,
					7,0,0,0, 0,0,0,1,
					4,0,0,0, 0,3,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1/2 * Pseq([
					Plazy({ Pn(rrand(0.1,1),rrand(1,5)) }),
				],inf),
			),
			16, Pdef(\bdrums1),
			20, Pdef(\smpdrums3),
		]),
	])
)).play;
);


(
Pdef(\part, Pdef(\smpdrums4, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 137/8/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				(0..15)/8,
				(0..15)/8,

				(0..3)/8,
				(0..3)/8+0.5,
				Prand((0..3),4)/8+1,
				(0..3)/8+1.5,

				//Prand((0..3),4)/8,
				(0..3)/8,
				Prand((0..3),4)/8+0.5,
				//(0..3)/8+0.5,
				//Prand((0..3),4)/8+1,
				(0..3)/8+1,
				Prand((0..3),4)/8+1.5,
			].flat,inf) / Pkey(\st) + 0.01,
			\dur, 1/8,
			\gain, 1/8,
		)

	])
)).play;
);
