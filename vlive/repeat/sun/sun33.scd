

~t = 88/2/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1503].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1632].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bacao Rhythm & Steel Band - Bacao Suave.wav'),
			\legato, 1,
			\st, 103/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				
				Pseg(Pseq([
					0,0.5,
				]+1.5,1),1/2) / Pkey(\st),
				Pseg(Pseq([
					0,0.5,
				]+2.5,1),1/2) / Pkey(\st),
				Pseg(Pseq([
					0,0.5,
				]+1,1),1/2) / Pkey(\st),
				Pseg(Pseq([
					0,0.5,
				]+2.5,1),1/2) / Pkey(\st),
			],inf),
			\isRest, Pseq([
				1,0.7,0.5,
				1,0.7,0.5,
				1,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bacao Rhythm & Steel Band - Bacao Suave.wav'),
			\legato, 1/4 * Pseq([
				1,Prand([1,0.4],2),Pwhite(0.1,1,1),
			],inf),
			\st, 103/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\pos, Pseq([
				3,4,4,4,
				3,4,4,4,
				9,4,4,4,
				3,4,4,4,
			]/8,inf) / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				Plazy({ arg ev;
					var ar = 1!8;
					ar[rrand(1,ar.size-1)] = 0;
					Pseq(ar,1);
				}),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				Plazy({ arg ev;
					var ar = 1!8;
					3.do { arg item, idx;
						ar[rrand(1,ar.size-1)] = rrand(0.7,1);
					};
					Pseq(ar,2);
				}),
			],inf),
			\lag, 0.04,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\pos, Pseq([
				//(0..15),

				(0..7)+8,
				(0..7)+8,
				(0..7)+24,
				(0..7)+16,
			].flatten/8+0.6,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\pos, Pseq([
				//(0..15),
				32,32,32,32, 36,40,39,40,
				32,30,31,29, 36,40,38,27,

				0,1,5,6,4,7,8,9,
				8,12,14,13,12,13,12,24,

				0,1,2,2,2,2,4,0,
				8,12,14,13,12,13,12,24,

				0,1,2,0,4,3,10,5,
				8,1,2,0,12,13,10,5,

				0,1,2,0,4,3,10,5,
				(0..7)+8,
			].flatten/8+0.6,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);


