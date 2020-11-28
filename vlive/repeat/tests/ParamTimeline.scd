(
	s.boot;
Ndef(\bla, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\zozo, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Ndef(\bla).edit
Ndef(\bla).get(\freq)
Ndef(\bla).get(\freq).asCachedBus.getCached
Ndef(\bla).getVal(\freq)
Ndef(\bla).inBusMode(\freq)
\c2.asBus.set(400)
\c2.asBus.numChannels
ParamTimeline(\bla3, Param(Ndef(\bla), \freq)).edit
ParamTimeline(\bla4, Param(Ndef(\bla), \lpfr)).edit
ParamTimeline(\zozo, Param(Pdef(\zozo), \freq)).edit

~t = 185/2/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[790].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
	])
)).play;
);

(
Ndef(\bla, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq/(1..8) * ( SinOsc.kr(0.31) * 0.41 + 1 )) * 0.1 + 1 ));
	//sig = DC.ar(0);
	sig = sig + LFPulse.ar(freq/4 * ( SinOsc.ar(freq*((1..8) * LFNoise1.kr(1/2).range(0.0,1.0)+1) * ( SinOsc.kr(0.31) * 0.41 + 1 )) * 0.1 + 1 ));
	sig = RHPF.ar(sig, \lpfr.kr(0.3) * freq, \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan) * 0.8;
}).play;
)
