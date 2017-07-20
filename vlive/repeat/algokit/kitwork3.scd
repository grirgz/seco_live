
Pdef(\drums, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).play
Pdef(\drums, PdrumStep(PatKitDef(\algokit).targets, Pdef(\kitwork3_p1), 1, key:\kitIndex)).play

Pdef(\drums).set(\out, BusDef(\sendbus0, \audio))
Pdef(\drums).set(\out, 0)
Pdef(\drums).set(\out, nil)
Pdef(\drums).play;
ProtoDef(\rdn).edit
ProtoDef(\rdn).play

// record loops
Pdef(\kit_workspace, Pdef(\drums)).play

(
	~patlist = {[
		Pbind(
			\kitIndex, Pseq([rrand(0,3)],inf),
			\isRest, Pseq( {[
				[ 1,0,0,0, 0,0,0,0, ],
				[ 1,1,0,0, 0,0,0,0, ],
				[ 1,0,1,0, 0,0,0,0, ],
				[ 1,0,1,0.5, 0,0,0,0, ],
				[ 1,0,0.21,0.5, 0,0,0,0, ],
				[ 1,0,0,0, 0,0,1,0, ],
				[ 1,0,1,0, 0,0,0,1, ],
				[ 1,0,0,1, 0,0,0,0, ],
				[ 1,0,0,0, 1,0,0,0, ],
				[ 1,0,0,1, 0,0,1,0, ],
				[ 1,0,1,0, 0,1,0,0, ],
				[ 1,1,1,1, 0,0,0,0, ],
				[ 1,0,1,1, 0,0,0,0, ],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.4),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+8],inf),
			\isRest, Pseq( {[
				[ 1,0,1,0,  ],
				[ 1,0,1,0,  ],
				[ 1,0,0,0,  ],
				[ 0,0,1,0,  ],
				[ 1,1,1,1,  ],
				[ 1,0.5,1,0,  ],
				[ 1,0.2,1,0.2,  ],
				[ 1,0.2,0.81,0.2,  ],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.1),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.1,
			\gain, Pkeyd(\gain,1) * Pseq({
				[
					1,0,0,0,
					1,0,1,0,
					0.5,0.7,1,0.7,
					0.5,0.7,0.3,0.7,
					1.0,0.7,0.3,0.7,
					0.5,0.7,1,0.7,
					0.2,0.7,1,0.7,
				].clump(4).choose
			}.dup(4).flatten ,inf),
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+4],inf),
			\isRest, Pseq( {[
				[ 0,0,0,0, 1,0,0,0,  ],
				[ 0,0,0,0, 1,0,0,0,  ],
				[ 0,0,0,0, 1,0,0,0.5,  ],
				[ 0,0.5,0,0, 1,0,0,0,  ],
				[ 0,0.5,0,0, 0,0,0.5,0,  ],
				[ 0,0,0,1, 0,0,0,1,  ],
				[ 0,0,1,0, 1,0,0,1,  ],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.2),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+4],inf),
			\isRest, Pseq( {[
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,0,0,
				],
				[ 
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
				],
				[ 
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
				],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.4),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.4
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,3)+4],inf),
			\isRest, Pseq( {[
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
				[ 
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.6),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.4
		),
		Pbind(
			\kitIndex, Pseq([rrand(0,11)],inf),
			\isRest, Pseq( {[
				[ 
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0.5,0,0.5,
						0,0,1,1, 1,1,1,1,
						0,0,0,0, 1,1,1,1,
						0,0,0,0, 0,0,1,1,
						0,0,0.4,0, 1,1,1,1,
						0,0,0,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						0,0.7,0,0, 0,0,1,0,
						1,0,1,0, 1,0,1,0,
					].clump(8).choose,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 1,1,1,1,
						0,0,0,0, 1,0,1,0,
						0,0,0,0, 0,0,1,0,
						0,0.7,0,0, 0,0,1,0,
					].clump(8).choose,
					[
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,0, 1,0,1,1,
						0,0,0,0, 1,1,1,1,
					].clump(8).choose,
				].flatten,
			].choose }.dup(4).flatten ,inf).coin.not,
			\sustain, rrand(0.051,0.2),
			\speed, rrand(1/2,2),
			\dur, 1/8,
			\amp, 0.4
		),


		Plazy({

			Pseq([
				Pbind(
					\instrument, \default,
					\isRest, Pser([
						0,
					],128/8/2).coin.not,
					\freq, 200,
					\dur, 1,
					\amp, 0.1
				),

				Pfindur(128/8/2,Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, 
					Pseq([
						Pseq( {[
							[ 1,0,1,0,  ],
							[ 1,0,1,0,  ],
							[ 1,0,0,0,  ],
							[ 0,0,1,0,  ],
							[ 1,1,1,1,  ],
							[ 1,0.5,1,0,  ],
							[ 1,0.2,1,0.2,  ],
							[ 1,0.2,0.81,0.2,  ],
						].choose }.dup(4).flatten ,8)
					],inf).coin.not,
					\sustain, rrand(0.051,0.1),
					\speed, rrand(1/2,2),
					\dur, [1/8,1/4,1/16].choose,
					\amp, 0.1,
					\gain, Pkeyd(\gain,1) * Pseq( { [
						1,0,0,0,
						1,0,1,0,
						0.5,0.7,1,0.7,
						0.5,0.7,0.3,0.7,
						1.0,0.7,0.3,0.7,
						0.5,0.7,1,0.7,
						0.2,0.7,1,0.7,
					].clump(4).choose }.dup(4).flatten ,inf),
				))
			])
		}).loop,
	]};

	Pdef(\kitwork3_p1, 
		Plazy({
			Ppar(
				~patlist.value.collect({ arg pat, idx; 
					Pbind(\trackIndex, idx) <> pat 
				})
			);
		})
	);
);



//////////////////// resequence

(
PatKitDef(\kitwork3).targets = 
PatKitDef(\algokit).targets.collect(_.copy) ++
8.collect({ arg idx;
	StepEvent.newFrom((
		instrument: \playersec_hlpf,
		hpf: 50,
		lpf: 1500,
		speed: 2,
		bufnum: BufDef('loop/loop1_185bpm.flac'),
		pos: idx/4/~t + 0.04,
	))
}) ++ 8.collect({ arg idx;
	StepEvent.newFrom((
		instrument: \playersec_hlpf,
		hpf: 150,
		lpf: 4500,
		speed: 1,
		bufnum: BufDef('loop/loop1_185bpm.flac'),
		pos: idx/4/~t + 0.04,
	))
}) ++ 8.collect({ arg idx;
	StepEvent.newFrom((
		instrument: \playersec_hlpf,
		hpf: 3500,
		lpf: 6500,
		speed: 2,
		bufnum: BufDef('loop/loop2_185bpm.flac'),
		pos: idx/4/~t + 0.04,
	))
})
)
PatKitDef(\kitwork3).edit
KitTimeline(\kitwork3_reseq, PatKitDef(\kitwork3)).edit


(
TrackDef(\kitwork3, TrackDef(\playergrid));
TrackDef(\kitwork3).source = [
	[
		KitTimeline(\kitwork3_reseq),
		nil,
	],
];
);

WindowDef(\multigrid).front;

(
Pdef(\hats1, 
	PatKitDef(\algokit).asPattern(Ppar([
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, 
					Pseq([
						Pseq( {[
							[ 1,0,1,0,  ],
							[ 1,0,1,0,  ],
							[ 1,0,0,0,  ],
							[ 0,0,1,0,  ],
							[ 1,1,1,1,  ],
							[ 1,0.5,1,0,  ],
							[ 1,0.2,1,0.2,  ],
							[ 1,0.2,0.81,0.2,  ],
						].choose }.dup(4).flatten ,8)
					],inf).coin.not,
					\sustain, rrand(0.051,0.1),
					\speed, rrand(1/2,2),
					\dur, [1/8,1/4,1/16].choose,
					\amp, 0.1,
					\gain, Pkeyd(\gain,1) * Pseq( { [
						1,0,0,0,
						1,0,1,0,
						0.5,0.7,1,0.7,
						0.5,0.7,0.3,0.7,
						1.0,0.7,0.3,0.7,
						0.5,0.7,1,0.7,
						0.2,0.7,1,0.7,
					].clump(4).choose }.dup(4).flatten ,inf),
				),
				Pbind(
					\kitIndex, Pseq([rrand(0,3)+8],inf),
					\isRest, 
					Pseq([
						Pseq( {[
							[ 1,0,1,0,  ],
							[ 1,0,1,0,  ],
							[ 1,0,0,0,  ],
							[ 0,0,1,0,  ],
							[ 1,1,1,1,  ],
							[ 1,0.5,1,0,  ],
							[ 1,0.2,1,0.2,  ],
							[ 1,0.2,0.81,0.2,  ],
						].choose }.dup(4).flatten ,8)
					],inf).coin.not,
					\sustain, rrand(0.051,0.1),
					\speed, rrand(1/2,2),
					\dur, [1/8,1/4,1/16].choose,
					\amp, 0.1,
					\gain, Pkeyd(\gain,1) * Pseq( { [
						1,0,0,0,
						1,0,1,0,
						0.5,0.7,1,0.7,
						0.5,0.7,0.3,0.7,
						1.0,0.7,0.3,0.7,
						0.5,0.7,1,0.7,
						0.2,0.7,1,0.7,
					].clump(4).choose }.dup(4).flatten ,inf),
				)
		
	]))
);
)

(
SynthDef(\ramp1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var line = XLine.kr(1,4,\sustain.kr);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(freq/2 * line) * ( line-1 ) )) * line );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\ramp2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * XLine.kr(1,1,\sustain.kr));
	sig = LPF.ar(sig, 5000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\ramp1, 
	
	Pseq([
			Pbind(
			\instrument, \ramp1,
			\degree, Pseq([0],1),
			\octave, 3,
			\legato, 1,
			\dur, 4,
			\amp, 0.1
		)
	],1),

);
);


(
TrackDef(\kitwork3).childAt(0).mixer.play;
Pdef(\main, 
	Pseq([
		Ppar([
			Ppar([
				Pseq([
					Rest(6),
					Pbind(\dur, 1) <> Pdef(\ramp1),
					Rest(1/2),
					Pbind(\instrument, \ramp2, \dur, 1/2) <> Pdef(\ramp1),
				],1),
				Pfindur(7, Pdef(\hats1)),
			],inf),
			KitTimeline(\kitwork3_reseq).asPattern,
		]),
		
	],inf)
).play;
)

KitTimeline(\kitwork3_house, PatKitDef(\kitwork3)).edit


(
SynthDef(\scab1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr((1..8)/8/8,pi) * XLine.kr(0.001,2,4) ))  );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\scab2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr((1..8)/8/8,pi) * XLine.kr(0.001,2,4) )) * XLine.kr(1,8,4) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

Pdef(\scab1, 
	
	Pseq([
			Pbind(
			\instrument, Pseq([\scab1],1),
			\degree, Pseq([
				[0,2,4],
			],inf),
			\isRest, Pseq([
				//0,0,0,1,
				1
			],inf).coin.not,
			\legato, 1,
			\dur, 4,
			\amp, 0.1
		),
			Pbind(
			\instrument, Pseq([\scab2],1),
			\degree, Pseq([
				[0,2,4],
			],inf),
			\isRest, Pseq([
				//0,0,0,1,
				1
			],inf).coin.not,
			\legato, 4/8,
			\dur, 4,
			\amp, 0.1
		)
	],inf),
).play;

);
