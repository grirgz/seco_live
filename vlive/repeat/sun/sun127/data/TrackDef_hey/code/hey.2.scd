
(
~currentTrack.initPdef(Pbind(
	\instrument, \playersec,
	\bufnum, ~buflib.snare[1666].value,
	//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
	],inf),
	\legato, 0.5,
	\dur, 1/8,
	\gain, 0.11,
))
)

// END

Pdef(~name).isPlaying
Pdef(~name).stop
Pdef(~name).play
