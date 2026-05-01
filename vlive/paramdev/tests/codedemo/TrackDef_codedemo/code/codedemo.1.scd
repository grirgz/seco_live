
(
~currentTrack.initPdef(
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1010].value,
		\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\dur, 1/8,
		\gain, 0.1,
	)
);
)
