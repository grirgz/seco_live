// culpabilisation

~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1462].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Ptpar([
			4, Pfindur(16,Pmono(\playersec,
				\bufnum, BufDef('reckit/culp/culpabilisation.flac'),
				\dur, 1,
				\gain, 0.07,
				\amp, 0.1,
			)).loop,
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[747].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[119].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
		),
		Pmono(\drone1,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\drone1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


SampleTimeline(\culp).edit
SampleTimeline(\culp).loopMaster.getMetadataSlices
SampleTimeline(\culp).asMetadataSlice
SampleTimeline(\culp).clear

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1462].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Ptpar([
			4, Pfindur(16,Pmono(\playersec,
				\bufnum, BufDef('reckit/culp/culpabilisation.flac'),
				\dur, 1,
				\gain, 0.07,
				\amp, 0.1,
			)).loop,
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[747].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[119].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
		),
		Pmono(\drone1,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
