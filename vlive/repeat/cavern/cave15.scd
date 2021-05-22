
(
~t = 127/4/60; TempoClock.default.tempo = ~t;
	~swing = 1/3;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\degree, Pseq([
				-1,1,2,2, -1,5b,5,2,
			],inf),
			\mtranspose, 0,
			\scale, Scale.minor,
			\octave, 3,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,0, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.3,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\gain, 0.11,
			\isRest, true,

		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,0,1, 1,1,1,  1,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,-1],inf))),
			\gain, 0.11,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		)
		
	])
)).play;
);

(
	// extract drums
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/4,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/16,8/16 // real loop start is 4/16 to have aligned snare
			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,0,
				0,1,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			\isRest, true,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/16,
			],inf) / Pkey(\sampleTempo),
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/32	
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/4,
			\gain, 1/4,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.3/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1/2,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.5/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pseq((0..15))/16,
			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pseq((0..3))/16,
			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pseq((0..7)+16)/16,
			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
		),
		
	])
)).play;
);


(
SynthDef(\lili, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * Duty.kr(\dutyt.kr(1/16/2/~t), 0, Dseq([
		1,0,
	],inf));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lili,
			\note, Pseq([
				0,-1,-2,-3,
			],inf) + [0,3,7],
			\legato, 0.6,
			\octave, 6,
			\dur, 1,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		
		Pbind(
			\lag, 0.04,
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pser((0..15),16)/16,
				Pser((0..15),12)/16,
				Pser([1,2,4]+10,4)/16,

				Pser((0..15),16)/16,
				Pser((0..7)+16,12)/16,
				Pser([ 7,9 ],4)/16,

				Pser((0..15)+16,12)/16,
				Pser([1,2,4]+9,4)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
		),
		
	])
)).play;
);

(
	// good chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\note, Pseq([
				Pseq([
					0,3,7,3,
				],3),
				Pseq([
					0,4,7,4,
				],3)-2,
				Pseq([
					0,3,7,3,
				],2),
			],inf),
			\ctranspose, -1,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			\lag, 0.04,
		),

		Pbind(
			\lag, 0.04,
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..63),64)+0/16+7,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
		
		Pbind(
			\lag, 0.04,
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pser((0..15),12)/16,
				Pser([1,2,4],4)/16,

				Pser((0..15),16)/16,
				Pser((0..7)+16,12)/16,
				Pser([ 7,9 ],4)/16,

				Pser((0..15)+16,12)/16,
				Pser([1,2,4]+9,4)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\isRest, true,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lili,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\note, Pseq([
				Pseq([
					0,3,7,3,
				],3),
				Pseq([
					0,4,7,4,
				],3)-2,
				Pseq([
					0,3,7,3,
				],2),
			],inf),
			\ctranspose, -1,
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,2,0,0,
				2,0,0,1, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..63),64)+0/16+7,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			\out, BusDef(\sendbus4, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1345].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\gain, 0.11,
			\isRest, true,

		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,0,1, 1,1,1,  1,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,-1],inf))),
			\gain, 0.11,
			\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lili,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\note, Pseq([
				Pseq([
					0,3,7,3,
				],3),
				Pseq([
					0,4,7,4,
				],3)-2,
				Pseq([
					0,3,7,3,
				],2),
			],inf),
			\ctranspose, -1,
			\octave, 4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,2,0,0,
				2,0,0,1, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,0.7],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..63),64)+0/16+7+4,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			\out, BusDef(\sendbus4, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1345].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1 * Pseq([
				1,0.7,0.8,0.6,
			],inf),
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,0, 1,0,1,1,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1/16,

			\gain, 0.15 * Pseq([
				1,0.7,0.8,0.6,
			],inf)
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1398].value,
			//\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\gain, 0.11 * Pseq([
				1,0.7,0.8,0.6,
			],inf)* Pwhite(0.5,1,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,0,1, 1,1,1,  1,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,-1],inf))),
			\lag, 0.04,
			\gain, 0.11,
			\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lili,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\dutyt, Pseq([
				4/16/~t,
				2/16/~t,
				1/16/~t,
				1/16/2/~t,
				4/16/~t,
				1/16/4/~t,
				1/16/8/~t,
			],inf),
			\note, Pseq([
				Pseq([
					3,3,0,3,
				],3),
				Pseq([
					0,0,7-12,0,
				],3)-2,
				Pseq([
					0,3,7-12,7-12,
				],2),
			],inf),
			\ctranspose, -1,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,2,0,0,
				2,0,0,1, 0,0,2,0,
				1,1,0,0, 1,0,0,1,
				2,0,1,0, 0,0,2,0,
				4,0,0,0, 0,2,0,0,
				2,0,0,1, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..63),64)+0/16+7+0,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			\out, BusDef(\sendbus4, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1345].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1 * Pseq([
				1,0.7,0.8,0.6,
			],inf),
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,0, 1,0,1,1,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1/16,

			\gain, 0.15 * Pseq([
				1,0.7,0.8,0.6,
			],inf)
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1398].value,
			//\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\gain, 0.11 * Pseq([
				1,0.7,0.8,0.6,
			],inf)* Pwhite(0.1,1,inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lili,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\dutyt, Pseq([
				4/16/~t,
				2/16/~t,
				1/16/~t,
				1/16/2/~t,
				4/16/~t,
				1/16/4/~t,
				1/16/8/~t,
			],inf),
			\note, Pseq([
				Pseq([
					3,3,0,3,
				],3),
				Pseq([
					0,0,7-12,0,
				],3)-2,
				Pseq([
					0,3,7-12,7-12,
				],2),
			],inf),
			\ctranspose, -1,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				1,0,0,0, 0,0,2,0,
				0,0,1,0, 2,0,0,1,
				1,0,0,0, 0,0,0,0,
				2,0,0,1, 0,0,2,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 2,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..63),64)+0/16+7+0,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			\out, BusDef(\sendbus4, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1345].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1 * Pseq([
				1,0.7,0.8,0.6,
			],inf),
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,0, 1,0,1,1,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1/16,

			\gain, 0.15 * Pseq([
				1,0.7,0.8,0.6,
			],inf)
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1398].value,
			//\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\gain, 0.11 * Pseq([
				1,0.7,0.8,0.6,
			],inf)* Pwhite(0.1,1,inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lili,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\dutyt, Pseq([
				Pseg(Pseq([1/32/2/~t,1/4/~t],inf),8),
			],inf),
			\note, Pseq([
				Pseq([
					3,3,0,3,
				],3),
				Pseq([
					0,0,7-12,0,
				],3)-2,
				Pseq([
					0,3,7-12,7-12,
				],2),
			],inf),
			\ctranspose, -1,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..63),64)+0/16+7+0,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			\out, BusDef(\sendbus4, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1345].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1 * Pseq([
				1,0.7,0.8,0.6,
			],inf),
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,0, 1,0,1,1,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1/16,

			\gain, 0.15 * Pseq([
				1,0.7,0.8,0.6,
			],inf)
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1398].value,
			//\bufnum, ~buflib.hat[227].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\gain, 0.11 * Pseq([
				1,0.7,0.8,0.6,
			],inf)* Pwhite(0.1,1,inf),
		),
	])
)).play;
);

(
	// loud bass
ProtoDef('rdn').make('deldefault', 'rdn', "5-O1GT-12M7", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.94117647058824,
	'gain', 0.5,
	'fb', 0.0001,
	'delay', 0.00026312860738959,
	'delay2', 0.0036561601440852 * Pseq([1,1,0.01],inf),
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.3012947724727 * Pseq([1,5],inf),
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

Ndef(\rdn).map(\delay, Ndef(\lfo1, { SinOsc.ar(1/9).range(0.00001,0.01)  }))
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-O1GT-12M7", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.94117647058824,
	'gain', 0.5,
	'fb', 0.0001,
	'delay', 0.00026312860738959,
	'delay2', 0.0036561601440852 * Pseq([1,1,0.01],inf),
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.3012947724727 * Pseq([1,5],inf),
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \lili,
			//\note, Pseq([
				//-3,0,-7,1
			//],inf),
			\dutyt, Pseq([
				Pseg(Pseq([1/32/2/~t,1/4/~t],inf),8),
			],inf),
			\note, Pseq([
				Pseq([
					3,3,0,3,
				],3),
				Pseq([
					0,0,7-12,0,
				],3)-2,
				Pseq([
					0,3,7-12,7-12,
				],2),
			],inf),
			\ctranspose, -1,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..7),8)+13/16+16+0,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,

				1,1,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,

			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				Pser((0..7),64)+0/16+6+0,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/4,
			\lag, 0.04,
			\out, BusDef(\lp, \audio),
		),
		PmonoArtic(\fx_rlpfrhpf,
			\inbus, BusDef(\lp, \audio),
			\addAction, \addToTail,
			\hpf, ~pmodenv.(Pseq([10000,100],1), 4).loop,
			\lpf, 18000,
			\lag, 0.0009,
			\dur, 4,
			\legato, Pseq([0.9],inf),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1345].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0.7,0.8,0.6,
			],inf),
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,0, 1,0,1,1,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.04,
			\dur, 1/8,

			\gain, 0.15 * Pseq([
				1,0.7,0.8,0.6,
			],inf),

		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1398].value,
			//\bufnum, ~buflib.hat[227].value,
			\legato, Pseq([
				Pseq([ 2,1,1,1, 2,1,1,1, ],1)/5,
				Pseq([ 2,1,1,1, 2,1,1,1, ],1)/5,
				Pseq([ 1,1,1,1, 16,0,0,0, ],1)/5,
				Pseq([ 2,1,1,1, 2,1,1,1, ],1)/5,
				//Pseq([ 2,1,10,0, 2,1,1,1, ],1)/5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\gain, 0.11 * Pseq([
				1,0.7,0.8,0.6,
			],inf)* Pwhite(0.1,1,inf),
		),
	])
)).play;
);


(
	// random stutter trap
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[190].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[734].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000,1).stutter(16)/16,
				Pseq([
					
					Pwhite(0,1000,1).stutter(8)/16,
					Pwhite(0,1000,1).stutter(8)/16,
				],1),

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),

	])
)).play;
);

(
	// fixed stutter trap 
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[190].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[734].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				//Pwhite(0,1000,1).stutter(16)/16,
				Pser([643]/16,16),
				Pser([346,347]/16,16),
				Pser([643]/16,16),
				Pser([243]/16,8),
				Pser([343]/16,8),
				//Pseq([
					//Pser([128],16),
					//Pser([13],16),
				//],1),

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1 * PdurStutter(Pseq([8],inf), 1/2),
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),

	])
)).play;
);

(
	// fixed stutter trap durstut
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[190].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[734].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				//Pwhite(0,1000,1).stutter(16)/16,
				Pser([643]/16,16),
				Pser([346,347]/16,16),
				Pser([243]/16,16),
				Pser([343]/16,16),
				//Pseq([
					//Pser([128],16),
					//Pser([13],16),
				//],1),

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1 * PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),

	])
)).play;
);

(
	// fixed stutter trap variation
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[190].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[734].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\speed, Pseq([1,2],inf),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				//Pwhite(0,1000,1).stutter(16)/16,
				Pser([643]/16,16),
				Pser([346,347]/16,16),
				Pser([243]/16,16),
				Pser([343]/16,16),
				//Pseq([
					//Pser([128],16),
					//Pser([13],16),
				//],1),

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1 * PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),

	])
)).play;
);


(
	// fixed stutter trap staccato
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pseq([
					3,3,0,3,
				],3),
				Pseq([
					0,0,7-12,0,
				],3)-2,
				Pseq([
					0,3,7-12,7-12,
				],2),
			],inf),
			\lpf, 350,
			\rq, 0.7,
			\ctranspose, -1,
			\legato, Pseq([
				2,0,0,0, 0,0,0,1,
				2,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,1,
				0,0,2,0, 0,0,2,0,
			],inf) * Prand([1,0],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[190].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[734].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				//Pwhite(0,1000,1).stutter(16)/16,
				Pser([643]/16,16),
				Pser([346,347]/16,16),
				Pser([243]/16,16),
				Pser([343]/16,16),
				//Pseq([
					//Pser([128],16),
					//Pser([13],16),
				//],1),

			],inf) / Pkey(\sampleTempo),
				\legato, Pseq([
				Pseq([0.1,0.31,1,0.31],4),
				Pseq([0,0,0,0],4),
				Pseq([1,1,0,0],2),
				Pseq([1,1,1,1],2),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1 * PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([0.1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000)/16,

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			\lag, 0.04,
			//\out, BusDef(\lp, \audio),
		),

	])
)).play;
);

(
	ProtoDef(\simpleMixer).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1,1.2,1,1],inf),1/8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				340,450,

			],inf).stutter(16)/16 / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			//\lag, 0.04,
			//\out, BusDef(\lp, \audio),
			\out, BusDef(\mixer0, \audio).index,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//Pser((0..15),16)+8/16+10,
				//Pser((0..7),8)+03/16+1+0,
				Pwhite(0,1000,1).stutter(16)/16,
				Pseq([
					
					Pwhite(0,1000,1).stutter(8)/16,
					Pwhite(0,1000,1).stutter(8)/16,
				],1),

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 1/8,
			//\lag, 0.04,
			//\out, BusDef(\lp, \audio),
			//\out, BusDef(\sendbus5, \audio),
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, 1.3,
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pseq((0..15))/16+1,
			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,
				1,1,1,1, 1,1,0,0,
				1,1,0,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,1,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			//\lag, 0.04,
			\gain, 1/4,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[734].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato,3,
			\gain, 0.11,
			//\lag, 0.04,
			\out, BusDef(\mixer3, \audio),
			//\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);



//////////////////////////////
/// draft trap



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pser([459]/16,3*3*4),
				Pser([453]/16,3*4),

			]+8,inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([6*2],inf), 1/2),
			\gain, 1/4,
			//\lag, 0.04,
			//\out, BusDef(\lp, \audio),
			//\out, BusDef(\sendbus5, \audio),
			//\out, BusDef(\mixer1, \audio),
			\out, BusDef(\enver, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\enver, \audio),
			\legato, Pseq([
				6,0,0,0, 0,0,6,0,
				0,0,0,0, 4,0,0,0,
			]*0.2,inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1,1,[\lin,\lin,2]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/16,
			],inf) / Pkey(\sampleTempo),
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/32	
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/4,
			\gain, 1/4,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.3/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1/2,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.5/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
	])
)).play;
);

(
SynthDef(\leady, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 100;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * [1/2,1,2,3,4,5]) * [0.4,0.81,0.4,0.3,0.2,0.1] * LFSaw.ar(freq+( (0..num-1)/(num-1) * \fmfac.kr(1) )).linlin(
		-1,1, 
		SinOsc.kr(1/7).range(2,16).neg,
		SinOsc.kr(1/8).range(2,16),
	)/1 ;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( (0..num-1)/(num-1)+1 ) * ( env1 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Splay.ar(sig, \spread.kr(1.0) * LFNoise1.kr(1/2).range(0.0,1.0), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \leady,
			\dutyt, Pseq([
				1/16/4/~t,
			],inf),
			\note, Pseq([
				0,0,0,0, 1,1,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.4) ],
			],inf),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fmfac, ~pmodenv.(Pseq([1,7,11,0.04],1), 3).loop,
			\dur, 1,
			\amp, 0.1/2,
			\out, BusDef(\flan, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\flan, \audio),
			\addAction, \addToTail,
			\mix, 1/2,
			\modfreq, 0.4,
			\modamp,1.2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \leady,
			\dutyt, Pseq([
				1/16/4/~t,
			],inf),
			\note, Pseq([
				0,0,0,0, 1,1,1,0,
			],inf)+[0+12,7,9+12],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.4) ],
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/2,2,1,4]+2.3,1), 8).loop,
			\fmfac, ~pmodenv.(Pseq([3.1,0.07],1), 4).loop,
			\dur, 1,
			\amp, 0.1/2 * [1,0.7,0.3],
			\out, BusDef(\flan, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\flan, \audio),
			\out, BusDef(\filter, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\modfreq, 0.4,
			\modamp,1.2,
			\lag, 0.0008,
			\dur, 1,
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\filter, \audio),
			\out, BusDef(\verb2, \audio),
			\addAction, \addToTail,
			\lag, 0.0011,
			\lpf, 
			Pseq([
				~pmodenv.(Pseq([19000,7000,10,100],1), 1/2),
				~pmodenv.(Pseq([19000,7000,10,100],1), 1/2),
				~pmodenv.(Pseq([19000,7000,10,100],1), 1/2),
				~pmodenv.(Pseq([19000,7000,10,100],1), 1/2),

				~pmodenv.(Pseq([19000,7000,10,100],1), 1/2),
				~pmodenv.(Pseq([100,1200,100,200],1), 1/2),
				~pmodenv.(Pseq([100,200,2100,200],1), 1/2),
				~pmodenv.(Pseq([700,200,100,200],1), 1/2),
			],inf),
			\lpmix,1,
			\hpf, 300,
			\hpmix,1,
			\mix, 1,
			\lag, 0.0010,
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb2, \audio),
			\out, BusDef(\comp, \audio),
			\addAction, \addToTail,
			\room,1.71,
			\mix,0.21,
			\lag, 0.0019,
			\gain, 1,
			\dur, 1,
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.031,
			\mix, 1,
			\pregain, 1,
			\cpabove, 0.1,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf) * Pseg(Pseq([0.1,1,1.5],inf),1),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pser([459]/16,3*3*4),
				Pser([446]/16,3*4),

			]+8,inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([6],inf), 1/2),
			\gain, 1/2,
			//\lag, 0.04,
			//\out, BusDef(\lp, \audio),
			//\out, BusDef(\sendbus5, \audio),
			//\out, BusDef(\mixer1, \audio),
			\out, BusDef(\enver, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\enver, \audio),
			\legato, Pseq([
				6,0,0,0, 0,0,6,0,
				0,0,0,0, 4,0,0,0,
			]*0.4,inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,1.0,1.1,1,[\lin,\lin,2]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([2],inf),8),
			\pos, Pseq([
				Pser([559]/16,3*3*4),
				Pser([546]/16,3*4),

			],inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([6],inf), 1/2),
			\gain, 1/6,
			//\lag, 0.04,
			//\out, BusDef(\lp, \audio),
			//\out, BusDef(\sendbus5, \audio),
			//\out, BusDef(\mixer1, \audio),
			//\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 0.2,
			\gain, 1/2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/16,
			],inf) / Pkey(\sampleTempo),
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/32	
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/4,
			\gain, 1/6,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			//\isRest, true,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/3,
			//\isRest, true,
		),
		Pbind( // snare ext
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.3/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1/2,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind( // snare ext2
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.5/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \leady,
			\note, Pseq([
				0,
			],inf),
			\dur, 1,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpfr, ~pmodenv.(Pseq([3,5],1), 8).loop,
			\octave,5,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\legato, Pseq([1,1,1,1],inf),
			\sampleTempo, 128/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				Pser([459]/16,3*3*4),
				Pser([453]/16,3*4),

			]+8,inf) / Pkey(\sampleTempo),
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([6*2],inf), 1/2),
			\gain, 1/4,
			//\lag, 0.04,
			//\out, BusDef(\lp, \audio),
			//\out, BusDef(\sendbus5, \audio),
			//\out, BusDef(\mixer1, \audio),
			\out, BusDef(\enver, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\enver, \audio),
			\legato, Pseq([
				6,0,0,0, 0,0,6,0,
				0,0,0,0, 4,0,0,0,
			]*0.2,inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1,1,[\lin,\lin,2]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/16,
			],inf) / Pkey(\sampleTempo),
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sampleTempo, 127/4/60,
			\pos, Pseq([
				4/32	
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/4,
			\gain, 1/4,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.3/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))), // 0.16
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1/2,
			\gain, 1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/heavydub1.flac'),
			\sampleTempo, 127/4/60,
			\speed, Pseg(Pseq([1],inf),8),
			\pos, Pseq([
				//4/16,
				//8/16,
				12.5/16,
				//Pseq(( 0..3 )+4)/16,
			],inf) / Pkey(\sampleTempo),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/2,
			//\isRest, true,
		),
	])
)).play;
);



(
SynthDef(\nappy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var cfreq = freq * \chord.kr(1!4);
	var num = 4 * 2 * 5;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var amps;
	freq.poll(label:"freq");
	lfo1 = SinOsc.kr(0.1) * 0.001 * \lfo1range.kr(1);
	lfo3 = LFNoise1.kr(0.1!num).range(0.3,3); 
	lfo5 = LFNoise1.kr(0.1!num).range(0.3,0.7); 
	lfo2 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1, timeScale: lfo3, levelScale: lfo5);
	lfo4 = EnvGen.kr(Env([1,2,1],[0.7,0.8]), 1, timeScale: lfo3);
	cfreq = cfreq *.x [1 - lfo1,1 + lfo1] * [ [1/2,1,2,7,9] ];
	amps = [0.6,1,0.6,0.1,0.1];
	cfreq.debug("cfreq");
	sig = SelectX.ar( LFNoise1.kr(1/2!num).range(0.0,1.0) ,[
		SinOsc.ar(cfreq) * amps,
		LFSaw.ar(cfreq) * amps,
	].collect(_.flatten)) * 5;
	sig.debug("sig");
	//sig = sig * ( SinOsc.ar(freq/2 * ( SinOsc.ar(freq/4 + Rand(0.0,1!sig.size)) * 0.71 + 1 )) * 0.7 + 1 );
	sig = sig * sig.fold( ( SinOsc.kr(0.11) * 0.1 + 1 ).neg, ( SinOsc.kr(0.3) * 1 + 1 ) );
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).poll, \rq.kr(0.5) * lfo4);
	sig = RLPF.ar(sig, ( \lpf.kr(10001.1) * lfo2 ).clip(10,20000).poll, \rq.kr(0.5) * lfo4);
	sig = HPF.ar(sig,\hpf.kr(30));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\nappy_choose, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var cfreq = freq * \chord.kr(1!4);
	var num = 4 * 2 * 5;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var amps;
	cfreq = freq * TWChoose.kr(Dust.kr(1!4),\chord.kr(1!4));

	freq.poll(label:"freq");
	lfo1 = SinOsc.kr(0.1) * 0.001 * \lfo1range.kr(1);
	lfo3 = LFNoise1.kr(0.1!num).range(0.3,3); 
	lfo5 = LFNoise1.kr(0.1!num).range(0.3,0.7); 
	lfo2 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1, timeScale: lfo3, levelScale: lfo5);
	lfo4 = EnvGen.kr(Env([1,2,1],[0.7,0.8]), 1, timeScale: lfo3);
	cfreq = cfreq *.x [1 - lfo1,1 + lfo1] * [ [1/2,1,2,7,9] ];
	amps = [0.6,1,0.6,0.1,0.1];
	cfreq.debug("cfreq");
	sig = SelectX.ar( LFNoise1.kr(1/2!num).range(0.0,1.0) ,[
		SinOsc.ar(cfreq) * amps,
		LFSaw.ar(cfreq) * amps,
	].collect(_.flatten)) * 5;
	sig.debug("sig");
	//sig = sig * ( SinOsc.ar(freq/2 * ( SinOsc.ar(freq/4 + Rand(0.0,1!sig.size)) * 0.71 + 1 )) * 0.7 + 1 );
	sig = sig * sig.fold( ( SinOsc.kr(0.11) * 0.1 + 1 ).neg, ( SinOsc.kr(0.3) * 1 + 1 ) );
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).poll, \rq.kr(0.5) * lfo4);
	sig = RLPF.ar(sig, ( \lpf.kr(10001.1) * lfo2 ).clip(10,20000).poll, \rq.kr(0.5) * lfo4);
	sig = HPF.ar(sig,\hpf.kr(30));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nappy,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nappy_choose,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([300,1200]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \leady,
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			].collect(_[0]),inf),
			\note, Pseq([
				0,
				-1,
			],inf) * Pkey(\chord),
			\octave,5,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.01],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/100,
		),
		
	])
)).play;
);


(
SynthDef(\nappy2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var cfreq;
	var num = 4 * 2 * 5;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var amps;

	cfreq = freq * TWChoose.kr(Dust.kr(1!num),\chord.kr(1!4) *.x [1/2,1,2], 1!(4*3),1);
	//cfreq = freq * \chord.kr(1!4);
	cfreq.poll;

	sig = SinOsc.ar(cfreq);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.3 * LFNoise1.kr(1/2!num).range(0.1,2.0)]), Dust.kr(1!num))*3;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\dreamer, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sig = CombL.ar(sig, 4/~t, 1/5/~t * \delayfac.kr(1),4/~t) + sig;
	sig = AllpassL.ar(sig, 4/~t, 1/4/~t* \delayfac.kr,4/~t) + sig;

	
	sig = SelectX.ar(\mix.kr(0.3), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\dreamer, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sig.debug("sig");
	sig = AllpassL.ar([ sig ], 4/~t, 1/4/~t * LFNoise1.kr(1/2!10).range(0.001,0.1) * \delayfac.kr,4/~t).mean + sig;

	
	sig = SelectX.ar(\mix.kr(0.3), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\dreamer, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sig.debug("sig");
	sig = CombL.ar([ sig ], 4/~t, 1/4/~t * LFNoise1.kr(1/2!10).range(0.001,1.1) * \delayfac.kr,4/~t).mean + sig;

	
	sig = SelectX.ar(\mix.kr(0.3), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \nappy2,
			\note, Pseq([
				0,
				-1,
			],inf),
			\octave,5,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4]+18,1), 8).loop,
			\lpf, ~pmodenv.(Pseq([100,1200]+18,1), 8).loop,
			\lfo1range, ~pmodenv.(Pseq([0,0.0001],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\chord, Pseq([
				[ [0,3,7,9].midiratio ],
				[ [0,3,7,10].midiratio ],
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\dreamer,
			\inbus, BusDef(\fx1, \audio),
			\mix, 0.2,
			\gain, 2.2,
			\mix, 0.6,
			\gain,1,
			//\delayfac, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


[1/2 ! 2, 1/4 ! 4, 1/6 ! 6, 1/8 ! 8, [[1]]].flat

Pwrand([Pseq([1,2]),3],[0.1,0.5],inf).asStream.nextN(10)
