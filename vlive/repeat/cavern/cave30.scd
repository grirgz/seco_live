
~t = 138/4/60; TempoClock.default.tempo = ~t;

(
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\FxManager).play;
};
~master.();
)

(
SynthDef(\bassup, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.051,1],[0.01,0.2], [0,\exp]), 1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq+1) * 0.41 + 1 ));
	sig = sig + SinOsc.ar(freq/2 * env1 * ( SinOsc.ar(freq/2+1) * 0.41 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[753].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \bassup,
			\note, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf)-1,
			\octave, 3,
			\legato, Pseq([
				3,0,0,3, 0,0,4,0,
				0,0,6,0, 0,0,0,0,
			],inf) * 0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,0.01,0.1,1,[0,-1]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[308].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1.01,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[762].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 1,0,1,1, 1,0,1,0,
				0,1,1,0, 1,0,1,0, 1,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
				0,1,1,0, 1,0,1,0, 1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
	// stage1
	~master.();
Pdef(\part, Pdef(\stage1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[753].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \bassup,
			\note, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf)-1,
			\octave, 3,
			\legato, Pseq([
				3,0,0,3, 0,0,4,0,
				0,0,6,0, 0,0,0,0,
			],inf) * 0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,0.01,0.1,1,[0,-1]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[308].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1.01,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[762].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 1,0,1,1, 1,0,1,0,
				0,1,1,0, 1,0,1,0, 1,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0, 1,0,1,0, 1,0,1,0,
				0,1,1,0, 1,0,1,0, 1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
	// end break
	~master.();
Pdef(\part, Pdef(\endbreak1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[753].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \bassup,
			\note, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf)-1,
			\octave, 3,
			\legato, Pseq([
				3,0,0,3, 0,0,4,0,
				0,0,6,0, 0,0,0,0,
				3,0,0,3, 0,0,4,0,
				0,0,0,0, 0,3,0,0,
			],inf) * 0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,0.01,0.1,1,[0,-1]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[308].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1.01,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[762].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0, 1,0,1,1, 1,0,1,0,
				0,1,1,0, 1,0,1,0, 1,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0, 1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0, 0,0,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(4,Pdef(\stage1)),
			Pfindur(4,Pdef(\endbreak1)),
		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[753].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
	])
)).play;
);



(
ClipTimeline(\mixerRecorder).tracks = ProtoDef(\simpleMixer).tracks.collect({ arg track, idx;
	(
		index: idx,
		recordArmed: true,
		recordBus: track.inbus,
		muted: false,
	)
});
)

ClipTimeline(\mixerRecorder).edit


FileSystemProject.load("ClipTimeline")
