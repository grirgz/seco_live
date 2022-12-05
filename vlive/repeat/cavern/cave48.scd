~t = 145/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\gregrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\gregrain_pan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	//pan = Pulse.ar([freq,freq+10]).mean;
	pan = Drand([
		//Dwhite(-1.0,1,16).lag(0.1),
		Dbrown(-1.0,1,0.05,16),
		Dbrown(-1.0,1,0.5,16),
		Dbrown(-1.0,1,0.005,16),
	],inf);
	//pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\gregrain_pan_mad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	//pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	pan = Dbrown(-1.0,1.0,0.1,inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Ptuple  (
				[
				~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
				~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10.02,10,inf).stutter(2), 8).loop,
				]
			),
			\gdur, Ptuple  (
				[
				~pmodenv.(Pseq([10,1,0,2,10]/180,1) , 3).loop,
				~pmodenv.(Pseq([0,5,10]/180,1) , 8).loop,
				]
			),
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, Ptuple(Prand([4,5,6],inf).stutter(Prand([1,2,3,4],inf))!2),
			\pan, [-1,1],
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.3,
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,3,2,4,
			],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
			],inf) / Pkey(\st),
			\isRest, Pser([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,1,0,
				1,0,1,1, 0,1,0,1,
				1,1,0,1, 1,0,1,1,
			],Pseq([1,1,1,2,2,1,8],inf)).coin.not,
			\dur, PdurStutter(Pseq([1,1,1,2,2,1,8],inf), 1/2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.3,
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,1,0,1, 0,0,0,0,
				1,0,1,1, 1,0,0,1, 0,0,0,0, 0,0,0,0,
			]/3,inf).coin.not,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.3,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,0.9],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 0.5,1,
				],1),1),
			],inf) / Pkey(\st),
			//\dur, PdurStutter(Pdef(\ip1,Pseq([8,4],inf)), 1/2),
			\dur, PdurStutter(Pseq([8,4],inf), 1/2),
			\isRest, Pstutter(Pseq([8,4]/4,inf),Pseq([
				0,0,1,0,
				0,0,0,0,
				1,1,0,0,
			],inf)).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,0.9],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 0.5,1,
				],1),1),
			],inf).stutter(Pseq([1,1,1,1,4],inf)) / Pkey(\st),
			//\dur, PdurStutter(Pdef(\ip1,Pseq([8,4],inf)), 1/2),
			\dur, PdurStutter(Pseq([8,4],inf), 1/2),
			\isRest, Pstutter(Pseq([8,4],inf),Pseq([
				1,0,0,0, 0,1,1,1,
				1,0,0,0, 1,0,0,0,
			],inf)).coin.not,
			\gain, 0.3,
		),
	])
)).play;
);
Pdef(\part2).clear;

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2468].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\speed, Pseq([
				1,0.9,
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,1, 0,1,0,0,  1,0,0,0, 0,0,0,0,
					1,1,0,1, 1,0,1,0,  0,0,0,0, 1,0,0,0,
					0,0,0,1, 0,1,0,0,  1,0,0,0, 0,0,0,0,
					1,1,0,1, 0,1,1,0,  1,0,0,1, 1,0,0,1,
				],1)/3,
			],inf).coin.not,
			\dur, 1/16,
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\lag, 5/32/~t,
			\gain, 0.11 * Pseq([
				0.3,1,1,0.3, 1,0.3,0.4,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1889].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, Pseq([
				1,1,1.03,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,1,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,1, 0,0,0,0,
				1,0,0,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\legato, 2,
			\dur, 1/16,
			\gain, 0.07 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					1,1.3,1.8,2, 0.1,1,0.1,1,
				],8),
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[982].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, Pseq([
				1,0.9,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,2, 2,1,0.31,0.31,
				1,0.41,1,0.2, 2,1,0.31,1.31,
			],inf),
			\dur, 1/16,
			\gain, 0.03 * Pseq([
				Pser([
					1,1.0,0.8,0.3,
					0.5,0.9,1.0,0.5,
				],8*2),
				Pser([
					1
				],8),
				Pser([
					1,0.6,0.8,0.3,
				],8*2),
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.3,
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2468].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\speed, Pseq([
				1,0.9,
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,1, 0,1,0,0,  1,0,0,0, 0,0,0,0,
					1,1,0,1, 1,0,1,0,  0,0,0,0, 1,0,0,0,
					0,0,0,1, 0,1,0,0,  1,0,0,0, 0,0,0,0,
					1,1,0,1, 0,1,1,0,  1,0,0,1, 1,0,0,1,
				],1)/3,
			],inf).coin.not,
			\dur, 1/16,
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\lag, 5/32/~t,
			\gain, 0.11 * Pseq([
				0.3,1,1,0.3, 1,0.3,0.4,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1889].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, Pseq([
				1,1,1.03,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,1,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,1, 0,0,0,0,
				1,0,0,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\legato, 2,
			\dur, 1/16,
			\gain, 0.07 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					1,1.3,1.8,2, 0.1,1,0.1,1,
				],8),
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[982].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, Pseq([
				1,0.9,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,2, 2,1,0.31,0.31,
				1,0.41,1,0.2, 2,1,0.31,1.31,
			],inf),
			\dur, 1/16,
			\gain, 0.03 * Pseq([
				Pser([
					1,1.0,0.8,0.3,
					0.5,0.9,1.0,0.5,
				],8*2),
				Pser([
					1
				],8),
				Pser([
					1,0.6,0.8,0.3,
				],8*2),
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.3,
		),
	].collect  { arg pat;
		Prand([
			Pfindur(4,Pbind(\type, \rest)),
			Pfindur(2,Pbind(\type, \rest)),
			Pfindur(2,Pbind(\lag, 0.04)),
			Pfindur(4,Pbind(\lag, 0.04)),
			Pfindur(1,Pbind(\lag, 0.04)),
			Pfindur(1,Pbind(\out, BusDef(\sendbus1,\audio))),
			Pfindur(2,Pbind(\out, BusDef(\sendbus2,\audio))),
			Pfindur(4,Pbind(\out, BusDef(\sendbus3,\audio))),
		],inf)
		<>
		pat
		
	}
)
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,-1,-2, -3,-4,-4,-4,
				-4,-5,-5,-5, -4,-5,-2,-5,
			],inf),1/4),
			\octave, 5,
			\pan, 1,
			\legato, 1,
			\dur, 1/8,
			\gain, 1.3,
		),
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,-1,-2, -3,-4,-4,-4,
				-4,-5,-5,-5, -4,-5,-2,-5,
			],inf),1/4),
			\octave, 3,
			\legato, 1,
			\pan, -1,
			\dur, 1/4,
			\gain, 1.3,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, -1,-1,-1,-1,
				0,0,0,0, 0,0,0,0,
				-5,-5,-5,-5, -5,0,0,-5,
			],inf),1/4),
			\octave, 5,
			\pan, 1,
			\legato, 1,
			\dur, 1/8,
			\gain, 1.3,
			\out, BusDef(\sendbus5, \audio),
		),
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, -1,-1,-1,-1,
				0,0,0,0, 0,0,0,0,
				-5,-5,-5,-5, -5,0,0,-5,
			],inf),1/4),
			\octave, 3,
			\legato, 1,
			\pan, -1,
			\dur, 1/4,
			\gain, 1.3,
			//\lag, 0.04,
			\out, BusDef(\sendbus5, \audio),
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 3.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,-1,-2, -3,-4,-4,-4,
				-4,-5,-5,-5, -4,-5,-2,-5,
			]-4,inf),1/4),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 4,
			\pan, 1,
			\legato, 1/3,
			\dur, 1/8,
			\gain, 1.3,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,-1,-2, -3,-4,-4,-4,
				-4,-5,-5,-5, -4,-5,-2,-5,
			]+5,inf),1/4),
			\octave, 5,
			\pan, 1,
			\legato, 1,
			\dur, 1/8,
			\gain, 1.3,
			//\lag, 0.04,
			\out, BusDef(\sendbus5, \audio),
		),
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,-1,-2, -3,-4,-4,-4,
				-4,-5,-5,-5, -4,-5,-2,-5,
			],inf),1/4),
			\octave, 3,
			\legato, 1,
			\pan, -1,
			\dur, 1/4,
			\gain, 1.3,
			//\lag, 0.04,
			\out, BusDef(\sendbus5, \audio),
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,-1,-2, -3,-4,-4,-4,
				-4,-5,-5,-5, -4,-5,-2,-5,
			],inf),1/4),
			\octave, Prand([4,3,5,6],inf),
			\pan, 1,
			\legato, 1,
			\legato, 1 * Pseq([1,0.4,1,1, 0.3,1,1,0.3],inf),
			\dur, 1/8,
			\gain, 1.3,
			\out, BusDef(\sendbus5, \audio),
		),
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/180,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/4,
			\note, Pstep(Pseq([
				0,0,-1,-2, -3,-4,-4,-4,
				-4,-5,-5,-5, -4,-5,-2,-5,
			],inf),1/4),
			\octave, 3,
			\legato, 1 * Pseq([1,1,0.4,1, 0.3,1,1,0.3],inf),
			\pan, -1,
			\dur, 1/8,
			\gain, 1.3,
			\out, BusDef(\sendbus5, \audio),
		)
		
	])
)).play;
);


(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1,
			\st, 136/8/60,
			\speed, 1/Pseq([8,4,8,2],inf)/1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					1, 2,
				],1),1),
				Pseg(Pseq([
					0, 2,
				],1),1),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				Plazy({ arg ev;
					var seq;
					Pseq([
						seq = Pseq([
							1,1,1,1, 0,0,0,0,
						].scramble,1),
						Pseq([
							1,1,1,1, 1,1,0,0,
						].scramble,1),
						seq,

						Pseq([
							1,1,1,1, 0,0,0,0,
						].scramble,1),


						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					],1);
				}).loop,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([1,2,8,2,4],inf), 1/2),
			\gain, 0.1,
		),
	])
)).play;
);


Pdef(\part2).clear;
(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/amenbreak.wav'),
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\st, 136/8/60,
			\speed, 1/Pseq([2,2,2,4, 2,2,1,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([
					//1, 2,
				//],1),1),
				Pseg(Pseq([
					0, 2,
				],1),2),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				Plazy({ arg ev;
					var seq;
					Pseq([
						seq = Pseq([
							1,1,0,0, 0,0,0,0,
						].scramble,1),
						Pseq([
							1,1,1,1, 0,0,0,0,
						].scramble,1),
						seq,

						Pseq([
							1,1,1,0, 0,0,0,0,
						].scramble,1),


						//1,1,1,1, 1,1,1,1,
						//1,1,1,1, 1,1,1,1,
						//0,0,0,0, 0,0,0,0,
						//1,1,1,1, 1,1,1,1,
					],4);
				}).loop,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([1,2,8,2,4],inf), 1/2),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf) / Pkey(\st),
			\isRest, Pseq([
				Plazy({ arg ev;
					var seq;
					Pseq([
						seq = Pseq([
							1,1,1,1, 0,0,0,0,
						].scramble,1),
						Pseq([
							1,1,1,1, 1,1,0,0,
						].scramble,1),
						seq,

						Pseq([
							1,1,1,1, 0,0,0,0,
						].scramble,1),


						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					],1);
				}).loop,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.3,
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/amenbreak.wav'),
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\st, 136/8/60,
				\speed, 1/Pseq([2,2,2,4, 2,2,1,4],inf) * ~t / Pkey(\st),
				\pos, Pseq([
					//Pseg(Pseq([
						//1, 2,
					//],1),1),
					Pseg(Pseq([
						0, 2,
					],1),2),
				],inf) / Pkey(\st),
				\isRest, Pseq([
					Plazy({ arg ev;
						var seq;
						Pseq([
							seq = Pseq([
								1,1,0,0, 0,0,0,0,
							].scramble,1),
							Pseq([
								1,1,1,1, 0,0,0,0,
							].scramble,1),
							seq,
			
							Pseq([
								1,1,1,0, 0,0,0,0,
							].scramble,1),
			
			
							//1,1,1,1, 1,1,1,1,
							//1,1,1,1, 1,1,1,1,
							//0,0,0,0, 0,0,0,0,
							//1,1,1,1, 1,1,1,1,
						],4);
					}).loop,
				],inf).coin.not,
				\dur, PdurStutter(Pseq([1,2,8,2,4],inf), 1/2),
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, 92.10/4/60,
				\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
				\pos, Pseq([
					Pseg(Pseq([
						2, 3,
					],1),4),
					Pseg(Pseq([
						1, 2,
					],1),4),
				],inf) / Pkey(\st),
				\isRest, Pseq([
					Plazy({ arg ev;
						var seq;
						Pseq([
							seq = Pseq([
								1,1,1,1, 0,0,0,0,
							].scramble,1),
							Pseq([
								1,1,1,1, 1,1,0,0,
							].scramble,1),
							seq,
			
							Pseq([
								1,1,1,1, 0,0,0,0,
							].scramble,1),
			
			
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							0,0,0,0, 0,0,0,0,
							1,1,1,1, 1,1,1,1,
						],1);
					}).loop,
				],inf).coin.not,
				\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
				\gain, 0.3,
			),
		]),
	])
)).play;
);

