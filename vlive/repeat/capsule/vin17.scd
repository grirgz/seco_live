
~t = 145/2/60; TempoClock.default.tempo = ~t;
(
ProtoDef(\rdn3).play;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono(
			\playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\loop, 1,
			\dur, 1,
			\gain, 1/8,
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
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\pos, Pseq([
				0,10,15,
				0,11,15,
			],inf).stutter(Pseq([
				Prand([
					Pseq([ 3,3,2 ],1),
					Pseq([ 3,2,3 ],1),
					Pseq([ 2,3,3 ],1),
					Pseq([ 6,1,1 ],1),
				],1),
			],inf)) + Pseg(Pseq([0,0.1],inf),8)+10,
			\legato, 1,
			\dur, 1/4,
			\gain, 1/8,
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
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[329].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				Prand([
					Pseq([ 1,0,0,0, 1,0,0,1, ],1),
					Pseq([ 1,1,0,1, 1,0,0,1, ],1),
					Pseq(0.5!8,1),
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.051,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[509].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				Prand([
					Pseq([ 1,0,0,0, 1,0,0,1, ],1),
					Pseq([ 1,1,0,1, 1,0,0,1, ],1),
					Pseq(0.5!8,1),
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.5,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2271].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1157].value,
			\isRest, Pseq([
				Pswitch1( Pseg(Pwhite(0.0,1,inf),Pwhite(4.0,16))!8, Pseq((0..7),inf) )
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.31 * Pswitch1( Pseg(Pwhite(0.0,1,inf),Pwhite(4.0,16))!8, Pseq((0..7),inf) ),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\pos, Pseq([
				0,10,15,
				0,11,15,
			],inf).stutter(Pseq([
				Prand([
					Pseq([ 3,3,2 ],1),
					Pseq([ 3,2,3 ],1),
					Pseq([ 2,3,3 ],1),
					Pseq([ 6,1,1 ],1),
				],1),
			],inf)) + Pseg(Pseq([0,0.1],inf),8)+10,
			\legato, 1,
			\dur, 1/4,
			\gain, 0.8,
			\out, BusDef(\sendbus3, \audio),
		)
	])
)).play;
);


/////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[862].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1049].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lag, -0.04,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\pos, Pseq([
				0,10,15,12,
			],inf).stutter(Pseq([
				2
			],inf)) + Pseg(Pseq([0,0.1],inf),8)+10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lag, -0.04,
			\legato, 1,
			\isRest, Pseq([
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
		)
		
	])
)).play;
);

(
// sidechain
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[862].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.2,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1049].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lag, -0.04,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\pos, Pseq([
				0,10,15,12,
				5,17,15,17,
			],inf).stutter(Pseq([
				2
			],inf)) + Pseg(Pseq([0,0.1],inf),8)+10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lag, -0.04,
			\legato, 1,
			\isRest, Pseq([
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\rdnback, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[862].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1049].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\pos, Pseq([
				0,10,15,
				0,11,15,
			],inf).stutter(Pseq([
				Prand([
					Pseq([ 3,3,2 ],1),
					Pseq([ 3,2,3 ],1),
					Pseq([ 2,3,3 ],1),
					Pseq([ 6,1,1 ],1),
				],1),
			],inf)) + Pseg(Pseq([0,0.1],inf),8)+10,
			\lag, -0.04,
			\legato, 1,
			\dur, 1/4,
			\gain, 0.2,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1125].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lag, -0.04,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[509].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,1,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				Prand([
					Pseq([ 1,0,0,0, 1,0,0,1, ],1),
					Pseq([ 1,1,0,1, 1,0,0,1, ],1),
					Pseq(0.5!8,1),
				],2),
			],inf).coin.not,
			\lag, -0.04,
			\dur, 1/8,
			\gain, 0.5,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);
