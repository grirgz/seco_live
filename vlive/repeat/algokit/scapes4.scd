
(
(
SynthDef(\chordscape, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*[1,1.01,1.001]) * 1 ))) * 1 )) ) * ( Line.kr(0.0001,0.51,2) ) ))  );
	sig.postln;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	pan = pan + LFNoise1.kr(1/43 ! sig.size, mul:\panwizamp.kr(0.3));
	sig = Pan2.ar(sig, pan, amp).mean/2;

	Out.ar(out, sig);
}).add;
);
Pdef(\chordscape, Pbind(
	\instrument, \chordscape,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf),
	\legato, Ptuple(Pwhite(0.3,1.3)!3),
	\dur, 1,
	\amp, 0.2
)).play;

Pdef(\lead, PmonoArtic(  \default,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 1/8,
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf).stutter(1/Pkey(\dur) * 2).collect({ arg x; x.choose  }) + [-7,0,7].choose,
	//\legato, Ptuple(Pwhite(0.7,1.8)!3),
	//\legato, 1,
	\legato, 
	Pseq([
		{
			Pseq({[
				1,0,0,0,
				1,0,1,0,
				1,1,1,1,
				0,0,1,0,
				0,1,1,0,
				1,0,0,1,
				0,0,0,0,
			].clump(4).choose.stutter([1,2,4,4,4,8].choose)}.dup(4).flat,2);
		} ! 4,
		Pseq([
			0
		],16),
	].flat,inf),
	\isRest, Pkey(\legato).collect(_==0),
	\amp, 0.2
)).play;
);


///////////////////////////////////////////


(
SynthDef(\lead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, linetime=4;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig.fold2(\fold.kr(0.7) * ( (1..8)/8 + 1 ));
	sig.postln;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	pan = pan + LFNoise1.kr(1/23, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean/2;

	Out.ar(out, sig);
}).add;
Pdef(\chordscape).play;
Pdef(\lead, 
	
	PmonoArtic(  \lead,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 1/8,
	//\legato, Ptuple(Pwhite(0.7,1.8)!3),
	//\legato, 1,
	\amp, 0.2,
)
<>
	Pbind(
	\degree, Pkey(\degree).collect({ arg x; x.choose + [-7,0,7].choose }),
	\legato, Pseq([
		{
			Pseq({[
				1,0,0,0,
				1,0,1,0,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				0,0,1,0,
				0,1,1,0,
				1,0,0,1,
				//0,0,0,0,
				//1,1,1,1,
			].clump(4).choose}.dup(4).flat,4);
		} ! 4,
		Pser([
			1,1,1,0.71, 1,1,1,0.1
		],16),
	].flat,inf),
	\isRest, Pkey(\legato).collect(_==0),

	).stutter(Prand([1,1,1,2,4,8],inf)) 

	<>
	Pbind(
		
	\fold, Pseg(Pseq([1.1,0.1],inf),4),
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf).stutter(8),
	\octave, 5,
	)

).play;
)

(
SynthDef(\criz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, linetime=4;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig.fold2(\fold.kr(0.7) * ( (1..8)/8 + 1 ));
	sig.postln;
	sig = RLPF.ar(sig, \lpfr.kr(2.4) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	pan = pan + LFNoise1.kr(1/23, mul:0.3)/2;
	sig = Pan2.ar(sig, pan, amp).mean;

	Out.ar(out, sig);
}).add;
Pdef(\chordscape).play;
Pdef(\lead).play;
Pdef(\criz, 
	
	PmonoArtic(  \criz,
	//\note, Pseq([{rrand(1,24)}!3],inf),
	\dur, 1/8,
	//\legato, Ptuple(Pwhite(0.7,1.8)!3),
	//\legato, 1,
	\amp, 0.2,
)
<>
	Pbind(
	\degree, Pkey(\degree).collect({ arg x; x.choose + [-7,0,7].choose }),
	\legato, Pseq([
		{
			Pseq({[
				1,0,0,0,
				1,0,1,0,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				0,0,1,0,
				0,1,1,0,
				1,0,0,1,
				//0,0,0,0,
				//1,1,1,1,
			].clump(4).choose}.dup(4).flat,4);
		} ! 4,
		Pser([
			1,1,1,0.71, 1,1,1,0.1
		],16),
	].flat,inf),
	\isRest, Pkey(\legato).collect(_==0),

	).stutter(Prand([4],inf)) 

	<>
	Pbind(
		
	\fold, Pseg(Pseq([1.1,0.1],inf),4),
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[-1,1,4],
		[-1,1,4],
	],inf).stutter(8),
	\octave, 5,
	)

).play;
)

KitTimeline(\scape4, PatKitDef(\algokit)).edit

(
		Pdef(\bip, Pbind(
			\instrument, \criz,
			\legato, 0.4,
			\degree, Pseq([
				[0,2,4],
				[0,2b,4],
				[-1,1,4],
				[-1,1,4],
			],inf).stutter(4).collect({ arg x;  x[1] }),
			\dur, 1/4,
			\isRest, Pseq([
				0,1, 1,1,
			],inf).coin.not,
			\amp, 0.1
		));
	Pdef(\scape, Ppar([
		Pbind(\sustain, 0.2) <> Pdef(\chordscape),
		Pdef(\lead),
		Pdef(\criz), 

	])).play;
Pdef(\drums2, ~kitlib.kit(Ppar([
	Pbind(
		\kitIndex, 0,
		\isRest, Pseq({[
			//1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			1,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
			1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			//1,0,0,0, 0,0,1,0,
		].clump(16).choose}.dup(4).flat,inf).coin.not,
		\freq, 200,
		\sustain, 0.1,
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 3,
		\isRest, Pseq({[
			0,0,0,0, 1,0,0,0,
		].clump(8).choose}.dup(4).flat,inf).coin.not,
		\freq, 200,
		\sustain, 0.1,
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 9,
		\isRest, Pseq({[
			1,0,0,0,
			1,0,1,0,
			0,0,1,0,
			1,1,1,1,
			0,1,1,0,
			1,0,0,1,
			0,1,0,0,
		].clump(4).choose}.dup(4).flat,inf).coin.not,
		\freq, 200,
		\speed, 1.5,
		\sustain, 0.1,
		\gain, 0.9,
		\gain, Pkey(\gain) * Pseq([
			0.3,0.5,1,0.5,
		],inf).stutter(2) * 2,
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 11,
		\isRest, Pseq({[
			1,0,0,0, 1,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,1,0, 0,0,1,0,

			1,0,1,0, 1,0,1,0,
			1,0,1,1, 1,0,1,1,
			1,1,1,1, 1,1,1,1,
		].clump(4).choose}.dup(32).flat,inf).coin.not,
		\freq, 200,
		\speed, Pseq([1.0,1.5],inf).stutter(2),
		\speed, Pseq({[
			1,1.5,
			1,1,
			1.5,1,
		].clump(2).choose}.dup(8).flat,inf),
		\sustain, 0.05,
		\pos, 0.3,
		\gain, 0.9,
		\lag, Pseq([0,0.02],inf),
		\gain, Pkey(\gain) * Pseq([
			0.3,0.5,1,0.5,
		],inf).stutter(2) * 2,
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 4,
		\isRest, Pseq({[
			0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			//0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
			//0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
		].clump(16).choose}.dup(4).flat,inf).coin.not,
		\freq, 200,
		\sustain, 0.1,
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 5,
		\isRest, Pseq({[
			0,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,1,0,
			0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
			1,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
			//0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			//0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
			//0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
		].clump(16).choose}.dup(4).flat,inf).coin.not,
		\freq, 200,
		\sustain, 0.1,
		\gain, 1,
		\dur, 1/8,
		\amp, 0.1
	),
]))).play;
)

(
	Pdef(\scape, Ppar([
		Pseq([
			Pfindur(16,
				Pbind(
					\dur, 1/8,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,1,1, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
						1,1,0,0, 0,1,1,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,1, 1,0,1,1,
						1,0,1,0, 1,0,1,0, 
						0,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.02
				) <> Pdef(\chordscape).stutter(8),
			),
			Pfindur(16,
				Pdef(\chordscape),
			),
		],inf),
		Pseq([
			Rest(32),
			Pfindur(32, Pdef(\lead)),
		],inf),
		Pseq([
			Rest(16),
			Pfindur(16, Pdef(\criz) ),
		],inf),

	])).play;
	Pdef(\drums, 
		Plazy({~kitlib.kit(Ppar([
			Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					//1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					//1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1
			),
			Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					//1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					//1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\pos, 0.08,
				\speed, 0.7,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1
			),
			Pbind(
				\kitIndex, 9,
				\instrument, \playerpansec,
				\isRest, Pseq({[
					1,0,0,0,
					1,0,1,0,
					0,0,1,0,
					1,1,1,1,
					0,1,1,0,
					1,0,0,1,
					0,1,0,0,
				].clump(4).choose}.dup(4).flat,inf).coin.not,
				\freq, 200,
				\speed, 1.5,
				\sustain, 0.1,
				\gain, 0.9,
				\gain, Pkey(\gain) * Pseq([
					0.3,0.5,1,0.5,
				],inf).stutter(2) * 2,
				\dur, 1/8,
				\pan, 0.2 * Pseq([Pn(0,25), Pn(1,2)],inf),
				\amp, 0.1
			),
			Pbind(
				\kitIndex, 11,
				\isRest, Pseq({[
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,

					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,1,
					1,1,1,1, 1,1,1,1,
				].clump(4).choose}.dup(32).flat,inf).coin.not,
				\freq, 200,
				\speed, Pseq([1.0,1.5],inf).stutter(2),
				\speed, Pseq({[
					1,1.5,
					1,1,
					1.5,1,
				].clump(2).choose}.dup(8).flat,inf),
				\sustain, 0.05,
				\pos, 0.3,
				\gain, 0.9,
				\lag, Pseq([0,0.02],inf),
				\gain, Pkey(\gain) * Pseq([
					0.3,0.5,1,0.5,
				],inf).stutter(2) * 2,
				\dur, 1/8,
				//\pan, -0.2 * Pseq((0..64).normalize,inf),
				\pan, 0.2 * Pseq([Pn(0,25), Pn(1,2)],inf),
				\amp, 0.1
			),
			Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
					//0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					//0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
				].clump(8).choose}.dup(4).flat,inf).coin.not,
				\freq, 200,
				\speed, 1.05,
				\sustain, Pseq([0.1,0.2,0.1,0.5],inf).stutter(8),
				\dur, 1/8,
				\amp, 0.1
			),
			Pbind(
				\kitIndex, 5,
				\isRest, Pseq({[
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\freq, 200,
				\sustain, 0.081,
				\pos, 0.10,
				\speed, 1.05,
				\gain, 0.81,
				\dur, 1/8,
				\amp, 0.1
			),
		]))})
	).play;
)

(
Pdef(\calmdrums, ~kitlib.kit(Ppar([
	Pbind(
		\kitIndex, 1,
		\isRest, Pseq({[
			//1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			1,0,1,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,1, 0,0,0,0,
			//1,0,0,0, 0,0,1,0,
		].clump(8).choose}.dup(8).flat,inf).coin.not,
		\freq, 200,
		\sustain, 0.1,
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 1,
		\isRest, Pseq({[
			//1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			0,0,0,0, 0,0,0,1,
			0,0,0,0, 0,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			//1,0,0,0, 0,0,1,0,
		].clump(8).choose}.dup(8).flat,inf).coin.not,
		\freq, 200,
		\pos, 0.08,
		\speed, 0.7,
		\sustain, 0.1,
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 5,
		\isRest, Pseq({[
			0,0,0,0, 1,0,0,0,
			//0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
			//0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
		].clump(8).choose}.dup(4).flat,inf).coin.not,
		\freq, 200,
		\speed, 1.05,
		\sustain, Pseq([0.1,0.2,0.1,0.5],inf).stutter(8),
		\dur, 1/8,
		\amp, 0.1
	),
	Pbind(
		\kitIndex, 5,
		\isRest, Pseq({[
			0,1,0,0, 0,0,0,0,
			0,0,0,0, 0,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,1,
		].clump(8).choose}.dup(8).flat,inf).coin.not,
		\freq, 200,
		\sustain, 0.081,
		\pos, 0.10,
		\speed, 1.05,
		\gain, 0.81,
		\dur, 1/8,
		\amp, 0.1
	),
]))).play;
)

(
Pdef(\main, 
	Pseq([
		//Pseq([
		//	Pfindur(7, Pdef(\drums)),
		//	Pfindur(1, Pdef(\drums2)),
		//],1),
		Pfindur(8,Ppar([
			//Pseq([
			//	Pfindur(7, Pdef(\drums)),
			//	Pfindur(1, Pdef(\drums2)),
			//],inf),
			Pbind(\sustain, 0.2) <> Pdef(\chordscape),
		])),
		Pfindur(8,Ppar([
			Pseq([
				Pfindur(7, Pdef(\calmdrums)),
				Pfindur(1, Pdef(\drums)),
			],inf),
			Pdef(\chordscape),
		])),
		Pfindur(128,Ppar([
			Pseq([
				Pfindur(14, Pdef(\drums)),
				Pfindur(2, Pdef(\calmdrums)),
				Pfindur(12, Pdef(\drums)),
				Pfindur(4, Pdef(\drums2)),

				Pfindur(14, Pdef(\calmdrums)),
				Pfindur(2, Pdef(\drums2)),
				Pfindur(14, Pdef(\drums)),
				Pfindur(2, Pdef(\drums2)),
			],inf),
			Pseq([
				Pfindur(16,
					Pbind(
						\dur, 1/8,
						\isRest, Pseq({[
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,1,1, 0,0,0,0,
							1,0,1,0, 0,0,1,0,
							1,1,0,0, 0,1,1,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,1, 1,0,1,1,
							1,0,1,0, 1,0,1,0, 
							0,0,0,0, 0,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.02
					) <> Pdef(\chordscape).stutter(8),
				),
				Pfindur(16,
					Pdef(\chordscape),
				),
			],inf),
			Pseq([
				Rest(32),
				Pfindur(32, Pdef(\lead)),
			],inf),
			Pseq([
				Rest(16),
				Pfindur(16, Pdef(\criz) ),
			],inf),
		])),
	],1),
).play;
)
