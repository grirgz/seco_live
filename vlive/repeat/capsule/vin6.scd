
(
	~t = 197/4/60; TempoClock.default.tempo = ~t;
	~swing = 0.36;
	Pdef.defaultQuant = 4;
ProtoDef(\rdn, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
ProtoDef(\rdn4, ProtoTemplateDef(\rdn));
~master = {
//	ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	ProtoDef(\rdn4).play;
};
);




(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
);

ClipTimeline(\ret).edit
ClipTimeline(\ret).quant
SampleTimeline(\hihi)
BufDef('./rec_recme_t1_190729_235532.wav')
BufDef.paths

/////////////

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\lag, 0.0) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0,1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		ClipTimeline(\ret).asPattern,
		
	])
)).play;
);

Pdef(\metronome).play
Pdef(\metronome).stop
