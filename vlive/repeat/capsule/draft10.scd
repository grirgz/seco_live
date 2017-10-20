(
SynthDef(\playersec_zix2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	speed = speed * EnvGen.kr(Env([0.21,1,1,0.2,1],[0.12,1,0.12,0.12]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = FreqShift.ar(LPF.ar(sig, 4000), 2300) + HPF.ar(sig, 4000);
	sig = HPF.ar(sig, 6000)*18;
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)

(
	// test triolet beat
	~master.();
	Pdef(\part, Pdef(\trio,
		Ppar([

			Pbind(\out, BusDef(\sendbus1))<>Ppar([
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1, 0,0,0,
						1,0,0, 0,1,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\instrument, \snapkick,
					\isRest, Pseq([
						1,0,0, 0,0,1,  0,0,0, 0,0,0,
						1,0,0, 0,1,0,  0,0,0, 1,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind(
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.07) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/3,
				),
				Pbind(
					\instrument, \snapclap,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/1,
					\dur, 1/8,
					\amp, 0.28,
					\isRest, true,
				),
				Pbind(
					\instrument, \snaretuned2,
					\isRest, Pseq([
						0
					],inf).coin.not,
					//\lag, 0.05,
					\sustain, 0.1/4,
					\dur, 1/8,
					\amp, 0.04,
					\isRest, true,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						0
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\sustain, 0.02,
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						//0.31, 0.31, 0.31, 0.31,
						0.01, 0.01, 0.01, 0.01,

					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.15,0.1,0.8,0.02) ],
					],inf),
					\dur, 1/8,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0272,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0,
					],inf).stutter(8),
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,1,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.1,
						],8*2)*1,
					],inf),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
			]),
			Pbind(\out, 0)<>Ppar([
				Pbind(
					\instrument, \playersec_fixzig_stereo,
					\instrument, \playersec_osczig_stereo,
					\instrument, Pseq([
						\playersec_osc,
						\playersec_osczig,
						\playersec_osczig_stereo,
					],inf),
					\trigfreq, 400 * 1/4 * Pseq([
						0,0,0,-1,
					],inf).midiratio,
					\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
					\pos, 0.4,
					\speed, Pseq([
						1,1.1,0.8,
					],inf),
					//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
					\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
					\pos, Pseq([
						~pmodsynth.({ LFSaw.kr(2/1*~t).range(0.2,1.2)*2 },2),
						~pmodsynth.({ LFSaw.kr(1/1*~t).range(0.2,1.2)*2 },2),
						~pmodsynth.({ LFSaw.kr(1/2*~t).range(0.2,1.2)*2 },4),
						~pmodsynth.({ LFSaw.kr(1/4*~t).range(0.2,1.2)*2 },4),
					],inf),
					\lpfr, 8,
					\legato, 0.5,
					\bufnum, BufDef(\table, "field/table.flac"),
					\bufnum, BufDef('loop/clean7_135bpm.flac'),
					\bufnum, BufDef('loop/loop3b_185bpm.flac'),
					\bufnum, BufDef('voices/feynman.flac'),
					\isRest, Pseq([
						1,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\legato, Pseq([
						7, 0,0,0, 0,0,0,0,
						7, 0,0,0, 0,0,0,0,
						0.8,0.8,0.8,0.8, 0,0,0,0,
						0.8,0.8,0.8,0.8, 0,0,0,0,
						4,0,0,0, 1,0,1,0,
						4,0,0,0, 0.81,0.8,0.81,0.8,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\freq, 200,
					\dur, 1/8,
					\gain, 30,
					\gain, 1/8,
					\amp, 0.1,
					\isRest, true,
				),
			])



		])
	)).play;
)

(
	// test triolet beat
	~master.();
	Pdef(\part, Pdef(\trio,
		Ppar([

			Pbind(\out, BusDef(\sendbus1))<>Ppar([
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,1,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,1, 0,1,0, 1,0,0, 1,0,0,

						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,1,0,
						1,0,0, 1,0,0, 1,0,0, 1,0,0,
						1,0,1, 0,1,0, 1,0,0, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,1,  0,0,1, 0,0,0,
						1,0,0, 0,0,0,  0,0,1, 0,1,0,

						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,1,  0,0,1, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,

						0,0,0, 0,0,0,  0,0,0, 1,0,1,
						0,0,1, 0,0,0,  0,0,1, 0,0,0,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,1,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
				Pbind(
					\instrument, \snapclap,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/1,
					\dur, 1/8,
					\amp, 0.28,
					\isRest, true,
				),
				Pbind(
					\instrument, \snaretuned2,
					\isRest, Pseq([
						0
					],inf).coin.not,
					//\lag, 0.05,
					\sustain, 0.1/4,
					\dur, 1/8,
					\amp, 0.04,
					\isRest, true,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						0
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\sustain, 0.02,
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						//0.31, 0.31, 0.31, 0.31,
						0.01, 0.01, 0.01, 0.01,

					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.15,0.1,0.8,0.02) ],
					],inf),
					\dur, 1/8,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0272,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0,
					],inf).stutter(8),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.1,
						],8*2)*1,
					],inf),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
			]),



		])
	)).play;
)

(
	// test triolet beat
	~master.();
	Pdef(\part, Pdef(\trio,
		Ppar([

			Pbind(\out, BusDef(\sendbus1))<>Ppar([
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
						1,0,0, 1,0,1, 1,0,0, 1,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.1,0.01,0.01

					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\instrument, \snapkick,
					\isRest, Pseq([

						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind( // hi snare
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
					\isRest, true,
				),
				Pbind(
					\instrument, \snapclap,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,0, 0,0,1,
						0,0,1, 0,0,0,  0,0,0, 0,0,1,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/1,
					\dur, 1/12,
					\amp, 0.28,
				),
				Pbind(
					\instrument, \snaretuned2,
					\isRest, Pseq([
						0
					],inf).coin.not,
					//\lag, 0.05,
					\sustain, 0.1/4,
					\dur, 1/8,
					\amp, 0.04,
					\isRest, true,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						0
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\sustain, 0.02,
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						//0.31, 0.31, 0.31, 0.31,
						0.01, 0.01, 0.01, 0.01,

					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.15,0.1,0.8,0.02) ],
					],inf),
					\dur, 1/8,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0272,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						0.1
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 1,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,0,1,
						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,

						18,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,1,0,
						0,0,0, 0,0,0, 0,0,0, 0,0,0,
						0,0,0, 0,0,0, 0,0,1, 0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, Pseq([\playersec_zix2],inf).stutter(8*4),
					\out, BusDef(\mixer5, \audio),
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, Pseq([
						2.2
					],inf).stutter(1),
					\isRest, Pseq([
						3,0,0,
					],inf).coin.not,
					\speed, 0.95,
					\legato, Pseq([
						Pser([
							0.4,0.1,0.1,
							0.2,0.1,0.1,
						],8*2)*2,
					],inf),
					\legato, Pseq([
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,1, 1,0,0,

							0,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 1,0,0, 2,0,0,
							20,0,0, 0,0,0, 0,0,0, 0,0,0,
							0,0,0, 0,0,0, 0,0,0, 0,0,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\gain, 0.6,
					\dur, 1/12,
					\amp, 0.1,
				),
			]),



		])
	)).play;
)



{ [ SinOsc.ar(2),SinOsc.ar(3),SinOsc.ar([3,5]).sum ]   }.plot(4)
