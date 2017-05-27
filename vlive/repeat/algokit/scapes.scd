
(
SynthDef(\scape1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, scat=0.1;
	var sig;
	var size = 8;
	var ar = (1..8)/8;
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq * (ar*scat+1));
	sig = sig + LFCub.ar(freq * (ar*1+1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.kr(1 * ~t * (ar*scat+1) * SinOsc.kr(8*~t,mul:0.3,add:1));
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

Pdef(\scape, PmonoArtic(\scape1,
	\degree, Pseq([0],inf),
	\octave, 4,
	\legato, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,0.5,
	],inf),
	\scat, Pseq([0.01,1,4,8],inf),
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\scape2, PmonoArtic(\scape1,
	\degree, Pseq([0],inf),
	\octave, 4,
	\legato, Pseq([
		1,1,0,1, 1,1,0,1,
		1,1,1,1, 1,1,1,0.5,
	],inf),
	\scat, Pseq([0.01,0.1],inf),
	\dur, 1/8,
	\amp, 0.1
));
Pdef(\scape3, PmonoArtic(\scape1,
	\degree, Pseq([
		0,0,0,3, 0,0,0,3,
		0,0,0,3, 0,3,0,3,

		0,0,0,3, 0,0,0,3,
		0,0,0,3, 3,0,0,3,
	],inf),
	\octave, 4,
	\legato, Pseq([
		1,1,0.5,1, 1,1,0.2,1,
		1,1,1,1, 1,1,1,0.1,
	],inf),
	\scat, Pseq([
		10,0.01,10,0.1,
		10,0.01,10,0.1,
		10,0.01,10,0.1,
		1,0.1,10,0.1,
	],inf),
	\dur, 1/8,
	\amp, 0.1
));
);

(
	~makeGhost = { arg num, seq, pat;
		var seqs = num.collect({ arg idx; { seq.clump(8).choose }.dup(4).flat });
		var refseq;
		seqs.do { arg curseq;
			refseq = refseq ?? { 0 ! curseq.size };
			curseq.do{ arg val, validx;
				if(refseq[validx] == 1) {
					//curseq.debug("kjk");
					curseq[validx] = 0;
				} {
					if(val == 1) {
						//[seqs, curseq, refseq, val, validx].debug("kjkiii");
						refseq[validx] = 1
					}
				}
			}
		};
		Ppar(
			num.collect({ arg idx;
				Pbind(
					\isRest, Pseq(seqs[idx],inf).coin.not,
				) <> pat.value(idx);
			})
		)

	};
	Pdef(\drums3,
		Ppar([
			~kitlib.kit(

				~makeGhost.(3, 
					[
						1,0,1,0, 0,0,0,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,1,
						1,0,0,1, 0,0,1,0,
					],
					{ arg idx;
						[
							Pbind(
								\kitIndex, 0,
								\sustain, 0.2,
								\speed, 1.0,
								\dur, 1/8,
								\amp, 0.1
							),
							Pbind(
								\kitIndex, 0,
								\sustain, 0.2,
								\speed, 1.0,
								\pos, 0.2,
								\dur, 1/8,
								\amp, 0.1
							),
							Pbind(
								\kitIndex, 0,
								\speed, 1.5,
								\sustain, 0.4,
								\dur, 1/8,
								\amp, 0.1
							)
						].wrapAt(idx)
					}
				)
			),
			// hat
			~kitlib.kit(
				~makeGhost.(3, 
					[
						1,0,1,0, 1,0,0,1,
						0,1,1,0, 1,0,0,1,
						1,0,1,1, 0,1,0,1,
						1,0,0,0, 0,1,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
					],
					{ arg idx;
						[
							Pbind(
								\kitIndex, 9,
								\speed, 0.9,
								\sustain, Pseq([0.04,0.02],inf).stutter(2),
								\dur, 1/8,
								\amp, 0.1
							),
							Pbind(
								\kitIndex, 9,
								\speed, 0.8,
								\sustain, 0.08,
								\dur, 1/8,
								\amp, 0.1
							),
							Pbind(
								\kitIndex, 9,
								\speed, 1.1,
								\sustain, 0.1,
								\dur, 1/8,
								\amp, 0.1
							)
						].wrapAt(idx)
					}
				)

			),
			~kitlib.kit(
				~makeGhost.(3, 
					[
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0.41,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0.4,
					],
					{ arg idx;
						[
							Pbind(
								\kitIndex, 5,
								\sustain, 0.2,
								\speed, 1.0,
								\dur, 1/8,
								\amp, 0.1
							),
							Pbind(
								\kitIndex, 5,
								\sustain, 0.2,
								\speed, 1.0,
								\pos, 0.2,
								\dur, 1/8,
								\amp, 0.1
							),
							Pbind(
								\kitIndex, 5,
								\speed, 1.5,
								\sustain, 0.4,
								\dur, 1/8,
								\amp, 0.1
							)
						].wrapAt(idx)
					}
				)

			),
	])

);
Pdef(\drums,
	Ppar([
		~kitlib.kit(Pbind(
			\kitIndex, 0,
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 0,0,1,0,
				],3),
				1,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
		~kitlib.kit(Pbind(
			\kitIndex, 4,
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
		// hat
		~kitlib.kit(Pbind(
			\kitIndex, 9,
			\speed, 0.8,
			\gain, 0.9,
			\speed, Pkey(\speed) * Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf).linlin(0,1,1,1/2),
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
		~kitlib.kit(Pbind(
			\kitIndex, 10,
			\speed, 0.8,
			\gain, 0.4,
			\speed, Pkey(\speed) * Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf).linlin(0,1,0.81,1/2),
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],2),
				Pseq([
					1,0,0,1, 0,0,1,0,
				],2),
				Pseq([
					0,0,1,1, 0,0,1,0,
				],2),
				0,1,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
	])

);

Pdef(\drums2,
	Ppar([
		~kitlib.kit(Pbind(
			\kitIndex, 0,
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 0,0,1,0,
				],3),
				1,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
		~kitlib.kit(Pbind(
			\kitIndex, 4,
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
		// hat
		~kitlib.kit(Pbind(
			\kitIndex, 9,
			\speed, 0.8,
			\gain, 0.9,
			\speed, Pkey(\speed) * Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf).linlin(0,1,1,1/2),
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,1,1,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
				],7),
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
		~kitlib.kit(Pbind(
			\kitIndex, 10,
			\speed, 0.8,
			\gain, 0.4,
			\speed, Pkey(\speed) * Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf).linlin(0,1,0.81,1/2),
			\sustain, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
					0,0,1,1, 1,1,1,1,
				],2),
				Pseq([
					1,0,0,1, 0,0,1,1,
				],2),
				Pseq([
					0,0,1,1, 1,1,1,1,
				],2),
				0,1,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		)),
	])

);
);

// END

(
Pdef(\main, 
	Pseq([
		Pfindur(8,Ppar([
			Pdef(\scape),
			Pdef(\drums),
		])),
		Pfindur(8,
			Ppar([
				Pdef(\scape2),
				Pdef(\drums2),
			]),
		),
		Pfindur(8,Ppar([
			Pdef(\scape3),
			Pdef(\drums3),
		])),
	],inf),
).play;
);
