
~currentTrack.initPdef(
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[1750].value,
		\bufnum, ~buflib.hat[1835].value,
		//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\isRest, Pseq([
			0,0,1,0, 0,0,1,0,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/8,
		\gain, 0.15,
	),
);

// END

~e = Pdef(~name).asStream.nextN(10,())[0]
~el = Pdef(~name).asStream.nextN(10,())
Pseq(~el).play
~e.play
Pdef(~name).play
Pdef(~name).source
Pdef(~name).source
Pdef(~name).clear
Pdef(~name).clear
Pdef(~currentTrack.parentTrack.elAt(0).codeFilePrefix).clear
