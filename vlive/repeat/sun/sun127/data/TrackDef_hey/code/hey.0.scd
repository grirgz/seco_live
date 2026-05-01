
(
~currentTrack.initPdef(Pbind(
	\instrument, \playersec,
	\bufnum, ~buflib.kick[859].value,
	//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\gain, 0.1,
	\out, BusDef(\kicktrack, \audio),
))
)

// END

Pdef(~name).isPlaying
~currentTrack.elAt(0).stop
