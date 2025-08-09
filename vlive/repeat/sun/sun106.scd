
~t = 101/4/60; TempoClock.default.tempo = ~t;
(
FileSystemProject.loadOnce("algokit/kits/PatKitDef_sample1.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
)
(
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
		Pbind(
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
