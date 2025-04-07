
~t = 165/4/60; TempoClock.default.tempo = ~t;
SampleTimeline(\smp).edit

SampleTimeline(\smp)

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1624].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1911].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Plazy({ arg ev;
			Pbind(\speed, ~t * 60/70 * 2) <> Pseq([
				Pfindur(2,SampleTimeline(\smp).asPatternSlice("s1")),
				Pfindur(1,SampleTimeline(\smp).asPatternSlice("s2")),
				Pfindur(1,SampleTimeline(\smp).asPatternSlice("s2")),
				//Pfindur(1,SampleTimeline(\smp).asPatternSlice("s1")),
				//Pfindur(1,SampleTimeline(\smp).asPatternSlice("s2b")),
				Pfindur(2,SampleTimeline(\smp).asPatternSlice("s3")),
				Pfindur(2,SampleTimeline(\smp).asPatternSlice("s4")),
			],1)
		}).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		ClipTimeline(\loop1).asPattern,
	])
)).play;
);

ClipTimeline(\loop1).edit
