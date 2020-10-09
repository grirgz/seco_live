~t = 135/4/60; TempoClock.default.tempo = ~t;
~swing = 0.43;

ClipTimeline(\vin19).edit

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\sendbus3, \audio),
		)
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.041,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_223243').buffer,
			\dur, 1/8,
			\legato, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,2,0, 0,0,0,0,
				6,0,0,0, 0,0,1,0,
				0,0,2,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_223243').buffer,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\pos, Pseq([1 + (1/8)],inf)/~t,
			\speed, -0.812,
			//\lag, 0.071,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_223243').buffer,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\dur, 1/8,
			\pos, Pseq([1],inf)/~t,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_225351').buffer,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\dur, 1/8,
			\pos, Pseq([1],inf)/~t,
			\legato, Pseq([
				1,0,1/2,0, 1,0,1/2,0,
				1,0,1/2,0, 1,0,1/2,0,
				1,0,1,0, 1,0,2,0,
				4,0,0,0, 1/2,1/2,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_225351').buffer,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\dur, 1/8,
			\speed, 0.98,
			\pos, Pseq([1],inf)/~t,
			\legato, Pseq([
				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				4,0,0,0, 1/2,1/2,1,0,

				1,0,1/2,0, 1,0,1/2,0,
				0,0,1,0, 1,0,0,1,
				1,0,0,0, 4,0,0,0,
				0,1/2,0,0, 2,0,0,1,
			]/4,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_223243').buffer,
			\dur, 1/8,
			\legato, Pseq([
				1,0,5,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_223243').buffer,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\pos, Pseq([1 + (1/8)],inf)/~t,
			\speed, -1,
			\lag, 0.071,
			\legato, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin19_t0_200331_223243').buffer,
			\dur, 1/8,
			\pos, Pseq([1],inf)/~t,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[336].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[336].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.041,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					1,0,-1,0
				],inf).stutter(8),
				\legato, Pseq([
					1,0,0,0, 2,0,0,0,
					0,3,0,0, 0,0,1,0,
					4,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,1,
					3,0,0,0, 0,1,0,0,
					0,1,0,1, 0,0,2,0,
					7,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[336].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[91].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			]/2,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,1,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 2,
			//\lag, 0.041,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11/1.62,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.041,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
			\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					1,0,-1,0
				],inf).stutter(8),
				\legato, Pseq([
					1,0,0,0, 2,0,0,0,
					0,3,0,0, 0,0,1,0,
					4,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,1,
					3,0,0,0, 0,1,0,0,
					0,1,0,1, 0,0,2,0,
					7,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[336].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[91].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			]/2,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,1,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 2,
			//\lag, 0.041,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.041,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
			\isRest, true,
		),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.7) ],
				[ Env.adsr(0.01,0.1,0.8,0.07) ],
				[ Env.adsr(0.21,0.1,0.8,0.07) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						[0,3,7,13],
						[0,3,7-12,12]+6,
						[0,3-12,7,13],
						[0,3,7-12,3+12]+1,
					].collect(_.scramble),1);
				}).loop,
			],inf).stutter(4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\strum, 0.3,
			\legato, Pkey(\legato) * Pwhite(0.9,1.1,inf),
			\dur, 1/8,
			\amp, 0.4,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);


(
SynthDef(\playersec_scratch, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	speed = speed * ( LFSaw.kr(\fmf.kr(8*~t), \fmp.kr(0)) * \fma.kr(1) + 1 );
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		SampleTimeline('rec_vin19_t0_200331_232041').asPattern,
		Pbind(
			 \instrument, \playersec_scratch,
			\bufnum, BufDef('voices/dasmicro.flac'),
			\fmf, Pseq([1],inf),
			\fmp, Pseq([2/4 * 2pi],inf),
			\pos, Pseq([0],inf)+2,
			//\trigger, Pseq([1],inf),
			\fma, Pseq([
				0,	1,1/2,
			],inf),
			\legato, Pseq([
				0,0,1,1, 0,1,0,1,
				2,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\gain, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			 \instrument, \playersec_scratch,
			\bufnum, BufDef('voices/dasmicro.flac'),
			\fmf, Pseq([1],inf),
			\fmp, Pseq([1/4 * 2pi],inf),
			\pos, Pseq([0],inf)+3.5,
			//\trigger, Pseq([1],inf),
			\fma, Pseq([
				0,	1/2,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\gain, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		SampleTimeline('rec_vin19_t0_200331_232041').asPattern,
		Pbind(
			 \instrument, \playersec_scratch,
			\bufnum, BufDef('voices/dasmicro.flac'),
			\fmf, Pseq([1],inf),
			\fmp, Pseq([2/4 * 2pi],inf),
			\pos, Pseq([0],inf)+2,
			//\trigger, Pseq([1],inf),
			\fma, Pseq([
				0,	1,1/2,
			],inf),
			\legato, Pseq([
				0,0,1,1, 0,1,0,1,
				2,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\gain, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			 \instrument, \playersec_scratch,
			\bufnum, BufDef('voices/dasmicro.flac'),
			\fmf, Pseq([1],inf),
			\fmp, Pseq([1/4 * 2pi],inf),
			\pos, Pseq([0],inf)+3.5,
			//\trigger, Pseq([1],inf),
			\fma, Pseq([
				0,	1/2,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\gain, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			 \instrument, \playersec_scratch,
			\bufnum, BufDef('voices/dasmicro.flac'),
			\fmp, Pseq([0/4 * 2pi],inf),
			\pos, Pseq([0],inf)+7,
			\fmf, Pseq([
				Pn(8,8),
				Pn(4,8),
				Pn(1/2,8),
				Pn(8,8),
			],inf),
			\fma, Pseq([
				1/4, 1/4, 1/4, 1/4, 1/4, 0, 0, 1/4,
				1/4, 1/4, 1/4, 1/4, 1/4, 0, 0, 1/4,
				1/2, 1/4, 1/2, 1/2, 1/4, 0, 0, 1/4,
				0,0,0,0, 0,0,0,0,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,0,2,0, 0,3,0,0,
				3,0,0,2, 0,3,0,0,
				2,0,2,0, 0,3,0,0,
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\gain, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		SampleTimeline('rec_vin19_t0_200331_232041').asPattern,
		Pbind(
			 \instrument, \playersec_looper,
			\bufnum, BufDef('voices/dasmicro.flac'),
			\pos, Pseq([0],inf)+2,
			\trigfreq, Pseq([
				8, 12, 4, 12,
			],inf)*~t,
			\legato, Pseq([
				2,0,0,0, 0,0,0,1,
				0,0,2,0, 2,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\gain, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			 \instrument, \playersec_looper,
			\bufnum, BufDef('voices/dasmicro.flac'),
			\pos, Pseq([0],inf)+4,
			\pos, ~pmodenv.(Pseq([1,2,1,4],inf), 8),
			\trigfreq, Pseq([
				~pmodenv.(Pseq([8,2,1,4],inf), 8),
				8, 12, 4, 12,
			],inf)*~t,
			\legato, Pseq([
				0,0,2,0, 0,0,0,0,
				0,1,0,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/8],inf),
			\gain, 1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \sonar,
				\note, Pseq([
					0,-1,
				],inf).stutter(8),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.7,0.4,0.1) ],
				],inf),
				\rq, Pseq([
					0.051
				],inf),
				\legato, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					7,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					2,0,0,2, 0,2,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, Pseq([
					Pseq([ 0,0,0,0, 0,0,0,0, ],1)+6,
					Pseq([ 0,0,0,0, 0,0,0,0, ],1)+6,
					Pseq([ 0,0,0,1, 0,0,0,0, ],1)+6,
					Pseq([ 1,0,0,1, 0,0,0,0, ],1)+6,
				],inf),
				\dur, 1/8,
				\amp, 5.1,
			),
			Pbind(
				\instrument, \sonar2,
				\note, Pseq([
					0,-1,
				],inf).stutter(8),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					7,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					3,0,0,0, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\rq, Pseq([
					0.051
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/2,
			),
		]),
	])
)).play;
);
