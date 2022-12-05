
//// creepy drones
(
~t = 199/4/60; TempoClock.default.tempo = ~t;

Ndef(\drone1).quant = 1;
Ndef(\drone1).addSpec(\chordamp, ParamArraySpec(\unipolar));
Ndef(\drone1).addSpec(\octamp, ParamArraySpec(\unipolar));
)

(
Ndef(\drone1).put(0, { arg freq=300, pan=0, amp=0.1;
	var sig;
	freq = \chord.kr([0,3,7,10]).midiratio *.x [1/3,1/2,1,2,3] * freq;
	freq.debug;
	freq.size.debug;
	sig = SinOsc.ar(freq * ( LFNoise1.ar(38 * LFNoise1.ar(1/10)) * 0.4 * Demand.ar(Impulse.ar(10)!freq.size, 0, Dwrand([0.01,0.1,1,10],[15.1,2,1,0.4].normalizeSum,inf)).lag(0.01) + 1 ));
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, ( sig*413 ).tanh/6]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, FreqShift.ar(sig, LFNoise1.kr(1/2).range(-100.0,100.0))]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, sig * ( LFNoise1.ar(1!freq.size).unipolar.pow(4) * 1 + 0 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig * ( SinOsc.ar(freq) * 10 + 1 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig + DelayL.ar(sig, 0.1, LFNoise1.ar(1!freq.size).unipolar*0.1 )]);
	sig.debug;
	sig.size.debug;
	sig = sig * ( \chordamp.kr([ 1,1,1,1 ]) *.x \octamp.kr([1,1,1,1,1]) );
	sig = Pan2.ar(sig, LFNoise1.kr(4!freq.size).range(-0.5,0.5).pow(33) + LFNoise1.kr(1/2!freq.size).range(-1.0,1.0), amp).mean;
	sig.debug;
	sig.size.debug;
	sig = CombL.ar(sig, 1/~t, 1/8/~t,1/~t)*0.4 + sig;
	sig.debug;
	sig.size.debug;
	sig * 2;
}).play;
);
Ndef(\drone1).play(BusDef(\sendbus3).index,2)
Ndef(\drone1).play(0,2)

(
Ndef(\drone1).put(10, \set -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf).stutter(2),
	\chord, Pseq([
		[ [0,3,7,12] ],
		[ [0,3,7,11] ],
		[ [0,2,3,5] ],
		[ [0,2,7,15] ],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
)).play;
)
Ndef(\drone1).put(10,nil)

WindowDef(\NdefEditor).front(Ndef(\drone1))
Ndef(\drone1).clear;

1/nil
4/~t

Ndef(\drone1).play;
ProtoDef(\rdn3).play;
(
Ndef(\drone1).put(10, \set -> Pbind(
	\freq, Pseq([300],inf).stutter(2),
	\chord, Pseq([
		[ [0,3,7,10] ],
		//[ [2,5,9,12] ],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
)).play;
)

(
Ndef(\drone1).put(10, \set -> Pbind(
	\freq, Pseq([300],inf).stutter(2),
	\chord, Pseq([
		Prout({ arg ev;
			var ar = [0,3,7,10];
			var idx;
			
			loop {
				idx = ar.size.rand;
				if(0.8.coin) {
					ar[idx] = ar[idx] - 1;
				};
				idx = ar.size.rand;
				if(0.1.coin) {
					ar[idx] = ar[idx] + 1;
				};
				[ ar ].yield;
				if(0.5.coin) {
					[ ar ].yield;
				};
			}
		}),
		//[ [2,5,9,12] ],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
)).play;
)

/////// program
// - drone1 sans chords et rdnmix=0 et qui commence par du silence et puis la note la plus aigu
// - monter toutes les notes
// - lancer le chord
// - lancer le solo hat et jouer avec le rdn2
// - lancer l'intro
// - reduire le drone1 a la note la plus aigu
// - lancer le drum1
// - monter rdnmix pour le drum1
// - lancer le drum1break
// - lancer le drum2
// - monter le postlph pour faire disparaitre un peu les drums
// - monter rdnmix pour le drone1
// - faire saturer le drone1 et rajouter les chords
// - baisser le drone1 et laisser que solo hat
// - lancer le drone2 avec chord seq 2
// - monter les notes du chord

(
	// intro
Pdef(\part, Pdef(\drumintro, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[386].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16)/16,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,0, 1,1,1,1,
				Pser([
					1,0,
				],64),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).reverse/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1617].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,


				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,


				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,0, 1,1,1,1,
				Pser([
					0,1,
				],64),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).scramble/32,inf),
		),
		
	])
)).play;
);

(
	// solo hat
Pdef(\part2, Pdef(\solohat, 
	Pbind(\out, BusDef(\sendbus2, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[386].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,1, 1,1, 1,0, 1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16)/16,inf)* Pseg(Pseq([0,1],inf),Pwhite(1,10.0,inf)),
		),
	])
)).play;
);

(
	// drum1
Pdef(\part, Pdef(\drum1, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[386].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16)/16,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).reverse/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1617].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).scramble/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[308].value,
			\isRest, Pseq([
				//1,0,0,1,0,0,1,0,
				//1,0,1,0,0,1,0,0,
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,1,0, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,1, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf),
		),
		
	])
)).play;
);

(
	// drum1 break
Pdef(\part, Pdef(\drum1break, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[386].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				Pseq([
					0
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16)/16,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).reverse/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1617].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).scramble/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[308].value,
			\isRest, Pseq([
				//1,0,0,1,0,0,1,0,
				//1,0,1,0,0,1,0,0,
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,1,0, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,1, 0,0,1, 0,0,1,
				Pseq([
					0
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf),
		),
		
	])
)).play;
);

(
	// drum2
Pdef(\part, Pdef(\drum2, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[386].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,1, 1,1, 1,0, 1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16)/16,inf)* Pseg(Pseq([0,1],inf),Pwhite(1,10.0,inf)),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).reverse/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1617].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).scramble/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[308].value,
			\isRest, Pseq([
				//1,0,0,1,0,0,1,0,
				//1,0,1,0,0,1,0,0,
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,1,0, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,1, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf)* Pseg(Pseq([0,1],inf),Pwhite(1,10.0,inf)),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[364].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseg(Pseq([0,1],inf),Pwhite(1,10.0,inf)),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[308].value,
			\isRest, Pseq([
				//1,0,0,1,0,0,1,0,
				//1,0,1,0,0,1,0,0,
				0,1, 0,0,1, 0,0,1,
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,1,0, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,1, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11 * Pwhite(0.1,1,inf),
		),
		
	])
)).play;
);

(
	// drum2 + pigs
Pdef(\part, Pdef(\drum2pigs, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[386].value,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,1, 1,1, 1,0, 1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16)/16,inf)* Pseg(Pseq([0,1],inf),Pwhite(1,10.0,inf)),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,1,1,1,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).reverse/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1617].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).scramble/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[308].value,
			\isRest, Pseq([
				//1,0,0,1,0,0,1,0,
				//1,0,1,0,0,1,0,0,
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,1,0, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,1, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf)* Pseg(Pseq([0,1],inf),Pwhite(1,10.0,inf)),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[364].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseg(Pseq([0,1],inf),Pwhite(1,10.0,inf)),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[308].value,
			\isRest, Pseq([
				//1,0,0,1,0,0,1,0,
				//1,0,1,0,0,1,0,0,
				0,1, 0,0,1, 0,0,1,
				0,0,1, 0,0,1, 0,1,
				0,0,1, 0,1,0, 0,1,
				0,0,1, 0,0,1, 0,1,
				0,1, 0,0,1, 0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11 * Pwhite(0.1,1,inf),
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([1,1,2,4],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					2, 3,
				],1),4),
				Pseg(Pseq([
					1, 2,
				],1),4),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([1,1,1,4,2,1,8],inf), 1/2),
			\gain, 0.5,
		),
	])
)).play;
);

/////////////////////////////
(
	// hip hop
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 1,
				],1),2),
				Pseg(Pseq([
					1, 2,
				],1),2),
				Pseq([
					//Pseg(Pseq([
						//0.0, 0.25,
					//],1),1/2),
					Pseg(Pseq([
						0, 0.2,0.5
					],1),Pseq([0.2,0.3])),
					Pseg(Pseq([
						0.25, 0.5,
					],1),1/2),
					Pseg(Pseq([
						0, 0.2,0.5
					],1),Pseq([0.4,0.1])),
					Pseg(Pseq([
						0.45, 0.5,
					],1),1/2),
				],1),

				Pseg(Pseq([
					0, 1,
				],1),2),
				Pseg(Pseq([
					0.0, 0.5,
				],1),1),
				Pseg(Pseq([
					0.0, 0.12,
				]+0.5,1),1),

				Pseg(Pseq([
					0, 1,
				],1),2),
				Pseg(Pseq([
					0.0, 0.1,
				],1),1),
				Pseg(Pseq([
					0.5, 1,
				],1),1),
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 0.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[258].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1414].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.13,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[155].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 0,0,0,0,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[386].value,
			\isRest, Pseq([
				1
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16)/16,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[53].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).reverse/32,inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1617].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.1,1,inf) * Pseq((1..16*2).scramble/32,inf),
		),
		
	])
)).play;
);





Ndef(\drone1).play
Ndef(\drone1).play(BusDef(\sendbus3).index,2)

/////////////////////////////////////////////

(
Ndef(\drone1).put(0, { arg freq=300, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = \chord.kr([0,3,7,10]).midiratio *.x [1/3,1/2,1,2,3] * freq;
	freq.debug;
	freq.size.debug;
	sig = LFPulse.ar(freq * ( LFNoise1.ar(38 * LFNoise1.ar(1/10)) * 0.4 * Demand.ar(Impulse.ar(10)!freq.size, 0, Dwrand([0.01,0.1,1,10],[15.1,2,1,0.4].normalizeSum,inf)).lag(0.01) + 1 ));
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq * LFNoise1.kr(1/2!freq.size).range(0.1,4.0), \rq.kr(0.5));
	sig = sig1 + RHPF.ar(sig, \lpfr.kr(1.1) * freq * LFNoise1.kr(1/2!freq.size).range(0.1,4.0), \rq.kr(0.5), mul:0.5);
	sig = sig / 2;
	sig = SelectX.ar( LFSaw.kr(13* LFNoise1.ar(1!freq.size)).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, ( sig*413 ).tanh/6]);
	sig = SelectX.ar( LFNoise1.kr(3!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, FreqShift.ar(sig, LFNoise1.kr(1/2).range(-100.0,100.0))]);
	sig = SelectX.ar( LFNoise1.kr(23!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, sig * ( LFNoise1.ar(1!freq.size).unipolar.pow(4) * 1 + 0 )]);
	sig = SelectX.ar( LFNoise1.kr(33!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig * ( SinOsc.ar(freq) * 10 + 1 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig + DelayL.ar(sig, 0.1, LFNoise1.ar(1!freq.size).unipolar*0.1 )]);
	sig.debug;
	sig.size.debug;
	sig = sig * ( \chordamp.kr([ 1,1,1,1 ]) *.x \octamp.kr([1,1,1,1,1]) );
	sig = Pan2.ar(sig, LFNoise1.kr(4!freq.size).range(-0.5,0.5).pow(33) + LFNoise1.kr(1/2!freq.size).range(-1.0,1.0), amp).mean;
	sig.debug;
	sig.size.debug;
	sig = CombL.ar(sig, 1/~t, 1/8/~t,1/~t)*0.4 + sig;
	sig.debug;
	sig.size.debug;
	sig * 2;
}).play;
);

(
Ndef(\drone1).put(10, \set -> Pbind(
	\freq, 100 * Pseq([0,1,0,-1, 9,8,0,6].midiratio,inf).stutter(2),
	\chord, Pseq([
		[ [0,4,8,4+12] ],
		[ [0,3,7,10] ],
		[ [0,3,7,9] ],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
)).play;
)


(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[259].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1414].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.13,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([
					1,1,1,1,
					1,2,2,2,
					1,1,1,4,
					4,1,1,1,
					1,1,2,1,
					1,4,2,1,
				1,2,4,1,
				1/2,1,1/2,1,
			],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 1,
				],1),2),
				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					1, 2,
				],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([
				Pseq([4,1],8),
				2,8,1,1, 1,1,1,8,
			],inf), 1/2),
			\gain, 0.5,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[259].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,0,1,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1414].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.13,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/Pseq([
				4,4,4,4,
				1/2,1,1/2,1,
			],inf) * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 1,
				],1),1),
				Pseg(Pseq([
					0, 2,
				],1),2),
				Pseg(Pseq([
					1, 2,
				],1),2),
			],inf) / Pkey(\st),
			\dur, PdurStutter(Pseq([
				Pseq([4,1],8),
				2,8,1,1, 1,1,1,8,
			],inf), 1/2),
			\gain, 0.5,
		),
	])
)).play;
);


///////////////////////////////////////////////////////////////////////////////////



(
Ndef(\drone1).put(0, { arg freq=300, pan=0, amp=0.1;
	var sig;
	freq = \chord.kr([0,3,7,10]).midiratio *.x [1/3,1/2,1,2,3] * freq;
	freq.debug;
	freq.size.debug;
	sig = SinOsc.ar(freq * ( LFNoise1.ar(38 * LFNoise1.ar(1/10)) * 0.4 * Demand.ar(Impulse.ar(10)!freq.size, 0, Dwrand([0.01,0.1,1,10],[15.1,2,1,0.4].normalizeSum,inf)).lag(0.01) + 1 ));
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, ( sig*413 ).tanh/6]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, FreqShift.ar(sig, LFNoise1.kr(1/2).range(-100.0,100.0))]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, sig * ( LFNoise1.ar(1!freq.size).unipolar.pow(4) * 1 + 0 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig * ( SinOsc.ar(freq) * 10 + 1 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig + DelayL.ar(sig, 0.1, LFNoise1.ar(1!freq.size).unipolar*0.1 )]);
	sig.debug;
	sig.size.debug;
	sig = sig * ( \chordamp.kr([ 1,1,1,1 ]).poll(label:"chordamp") *.x \octamp.kr([1,1,1,1,1]).poll(label:"octamp") );
	sig = Pan2.ar(sig, LFNoise1.kr(4!freq.size).range(-0.5,0.5).pow(33) + LFNoise1.kr(1/2!freq.size).range(-1.0,1.0), amp).mean;
	sig.debug;
	sig.size.debug;
	sig = CombL.ar(sig, 1/~t, 1/8/~t,1/~t)*0.4 + sig;
	sig.debug;
	sig.size.debug;
	sig * 2;
}).play;
);

Ndef(\drone1).map(\chordamp, Ndef(\dronelfo1));
Ndef(\drone1).map(\octamp, Ndef(\dronelfo2));
Ndef(\drone1).set(\amp, 0.2)

Ndef(\dronelfo2, Ndef(\dronelfo1).source)
Ndef(\dronelfo2).clear
Ndef(\dronelfo2).numChannels
(
Ndef(\dronelfo1, {
	var delfac, del;
	delfac = 10;
	del = (0..7)*delfac;
	EnvGen.kr(Env([0,0,1],[del, delfac]), 1);
})
)



(
Ndef(\dronelfo1_chordamp, {
	var delfac, del;
	delfac = 10;
	del = (0..3)*delfac;
	EnvGen.kr(Env([0,0,1],[del, delfac]), 1);
})
)

(
Ndef(\dronelfo1_octamp, {
	var delfac, del;
	delfac = 10;
	del = (0..4)*delfac;
	EnvGen.kr(Env([0,0,1],[del, delfac]), 1);
})
)
Ndef(\drone1).map(\chordamp, Ndef(\dronelfo1_chordamp));
Ndef(\drone1).map(\octamp, Ndef(\dronelfo1_octamp));
