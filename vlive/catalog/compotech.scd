//////////////// techniques de rhytme

- groove amp
- swing tempo
- offset/lag	
	- offset negatif: precipitation
	- offset positif: traine les pieds
- double: deux perc presque au meme moment
- modulate sustain
- offset start of sample
- modulate envelope
- hat style aspiration juste avant le snare ou le kick
- faire un rytme lent et faire un legato au max ou bien remplacer les longues notes par des tres rapides courtes notes regulieres, chaque type de percussion du rhytme lent peut etre remplacé par des textures differentes
- perc qui reviens regulierement mais a un interval regulier tres espacé
- stutter sample

// style (need examples..)
- break
- 4 to the floor

- duo: kick/snare
- trio: kick/hat/snare


////////////////// random techniques
- deux sequences d'une longueur differente pour faire au total une longue sequence qui est la multiplication de la longueur des deux
	- fonctionne aussi pour des frequences de lfo
- \isRest, .coin.not

///////////////// notation techniques
- \isRest, .coin.not
- \isRest, {[1,0].clump(8).choose}.dup(4).coin.not
- \isRest, Pkey(\legato)
- compute legato by reversing isRest pattern
- Pdict
- PmonoArtic


///////////////// the 8 step sequence: each step become it's own independent curve
\lpf, Pswitch1(
	{ Pseg(Pseq([exprand(100.1,12000.0),exprand(100.1,12000.0)],inf),rrand(4,18.5)) }.dup(8),
	Pseq((0..7),inf)
),
\amp, 0.1 * Pswitch1(
	8.collect({ arg x; Pseq(Array.series(x+5,0,1).normalize,inf)}),
	Pseq((0..7),inf)
),

////////////////// modulo is cool

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..20),inf) % Pseq((3..17),inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..20),inf).wrap(Pseq((3..7),inf),Pseq((3..17).mirror,inf)).trace,
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq((1..20),inf).wrap(Pseq((3..7),inf),Pseq((3..17).mirror,inf)).trace,
		\dur, Pseq([
			Pwrand([ 
				2, 1.0, 0.5, 0.25, 0.125,
				1.5, 0.75, 0.375, 0.1875, 0.09375,
		   	], ( (1..5)**2 ++ ( (1..5)**2 / 1.2 )).normalizeSum,inf)
		]),
		\amp, 0.1,
	)
).play;
);

///// get same frequence as note pattern

// setup
(
SynthDef(\snitch, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\snitch2, { arg out=0, amp=0.1, gate=1, pan=0, freq2=200;
	var sig;
	sig = SinOsc.ar(freq2.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch,
		\note, 0, // default = C4 = 261.626Hz = Do = 60.midicps
		\octave, 5, // default, octave 0 is 0.midicps = 8.176Hz
		\dur, 1,
		\amp, 0.1,
	),
).play;
)
// the Pkey(\freq) trick
(
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch2,
		\note, 0,
		\freq2, Pkey(\freq), // can break with multichannel in specific conditions
		\dur, 1,
		\amp, 0.1,
	),
).play;
)

// midicps

// 
( 60 + 0.03 ).midicps equalWithPrecision: ( 60.midicps * 0.03.midiratio );

(
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch2,
		\note2, 0,
		\freq2, ( Pkey(\note2)+60 ).midicps,
		\dur, 1,
		\amp, 0.1,
	),
).play;
)

// the midiratio trick


(
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch2,
		\note2, 0,
		\octave2, 5,
		//\freq2, 440 * (Pkey(\note2) - 9 + (Pkey(\octave2)-5 * 12)).midiratio,
		\freq2, Pkey(\note2).midicps * (Pkey(\octave2)*12).midiratio,
		\dur, 1,
		\amp, 0.1,
	),
).play;
)


///// degree2
// DegreeToKey and PdegreeToKey are used to convert from \degree to \note

(
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch2,
		\degree2, 3,
		\octave2, 5,
		\scale2, Scale.dorian,
		\note2, PdegreeToKey(Pkey(\degree2), Pkey(\scale2)),
		\freq2, 440 * (Pkey(\note2) - 9 + (Pkey(\octave2)-5 * 12)).midiratio,
		\dur, 1,
		\amp, 0.1,
	),
).play;
)

(
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch2,
		\degree2, Pseq((0..7),inf),
		\octave2, 5,
		\scale2, Scale.locrian,
		\note2, PdegreeToKey(Pkey(\degree2), Pkey(\scale2)),
		\freq2, 440 * (Pkey(\note2) - 9 + (Pkey(\octave2)-5 * 12)).midiratio,
		\dur, 1/4,
		\amp, 0.1,
	),
).play;
)

(
	// test
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch,
		\degree, Pseq((0..7),inf), // default = C4 = 261.626Hz = Do = 60.midicps
		\octave, 5, // default, octave 0 is 0.midicps = 8.176Hz
		\scale, Scale.dorian,
		\dur, 1/4,
		\amp, 0.1,
	),
).play;
)

//// using event

Event.default
~ev = Event.default;
~ev[\degree] = 3;
~ev.use { ~freq.value }

(
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch2,
		\degree2, Pseq((0..7),inf),
		\octave2, 5,
		\scale2, Scale.locrian,
		\freq2, Pfunc({ arg ev;
			var evd = Event.default;
			evd[\degree] = ev[\degree2];
			evd[\scale] = ev[\scale2];
			evd[\octave] = ev[\octave2];
			evd.use { ~freq.value }
		}),
		\dur, 1/4,
		\amp, 0.1,
	),
).play;
)

(
	// doesnt work, todo
Pdef(\snitch, 
	Pbind(
		\instrument, \snitch2,
		\degree2, Pseq((0..7),inf),
		\octave2, 5,
		\scale2, Scale.locrian,
		\freq2, Pfunc({ arg ev;
			var evd = (
				degree: ev[\degree2],
				scale: ev[\scale2],
				octave: ev[\octave2],
			) <> Event.default;
			evd.use { ~freq.value }
		}),
		\dur, 1/4,
		\amp, 0.1,
	),
).play;
)

////////////////// fx
- delay network + feedback + dist
- echo
- sidechain
- compressor


///////////////// random arpegiate

\note, Pseq([
	[1,5,8],
	[1,6,10],
	[3,8,12, 0],
	[1,6,10, -2],
],inf).stutter(8).collect({ arg x; x.choose }),


////////////////////////////////
// 9th and 11th

~t = 170/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\chordlock, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * ( Gendy1.ar(freq * [1,1.01,1.001] * Gendy2.ar(1)) * 0.1 * env1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				[4,7,16],
				[4,7-12,16],
			],inf),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				10, // 7th
				14, // 9th
				17, // 11th
			],inf),
			\octave, Pseq([
				5,5,4,5,5,3,5,6,6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2,1/4],inf),
			\amp, 0.1,
		),
	])
)).play;
)

// other

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				[4,7,16],
				[4,7-12,16],
			],inf),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				9,
				11,
				15,
			],inf),
			\octave, Pseq([
				5,5,4,5,5,3,5,6,6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2,1/4],inf),
			\amp, 0.1,
		),
	])
)).play;
)
///// magic chords

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \chordlock,
			\degree, Pseq([
				[0,4, 8,9,13], // Cmaj11
				[1,5, 10,11,14], // Dmin11
				[0,4, 14-6,14-5,14-1], // major formula
				[0,4, 14-5,14-4,14-1]+1, // minor formula
			],inf),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				[0,4, 7-1,7,7+1,7+4], // Cmaj9
				[0,4, 14-1,14,14+1,14+4],
				[0,4, 14-1,14,7+1,7+4],
				[0,4, 21-1,21,14+1,14+4],
			],inf),
			\octave, 4,
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\degree, Pkey(\degree) % Pstep(Pseq([64,21,14,7],inf),4),
			\dur, Pkey(\dur) * Pstep(Pseq([1,1,2,4,1/2],inf),8),
		) <>
		Ppar([
			Pbind(\degree, 0, \dur, 1/3),
			Pbind(\degree, 4 + Pseq([\r,\r,0],inf), \dur, 1/4),
			Pbind(\degree, 8, \dur, 1/5),
			Pbind(\degree, 9, \dur, 1/4),
			Pbind(\degree, 13 + Pseq([0,\r,\r,0],inf), \dur, 1/5),
			Pbind(\degree, 12+4 + Pseq([0,\r,0,0],inf), \dur, 1/2),
		])<>
		Pbind(
			\mtranspose, Pstep(Pseq([0,3],inf),4),
			\instrument, \chordlock,
			//\degree, Pseq([
				//[0,4, 8,9,13], // Cmaj11
				//[1,5, 10,11,14], // Dmin11
				//[0,4, 14-6,14-5,14-1], // major formula
				//[0,4, 14-5,14-4,14-1]+1, // minor formula
			//],inf),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////////////////////////


// rand gain for upbeat render well
(
Pdef(\part, Pdef(\ze_hat_ksh2b, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[703].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0.7,
			],inf) * Pseq([
				1,Pwhite(0.01,0.5,1),
			],inf),
		),
	])
)).play;
);

/////////////// don't forget sometime overlapping sounds give cool results


(
SynthDef(\ploux2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1,0.1],[0.1,0.8,1])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([1,2,1,0.1],[0.1,0.8,1])), 1);
	sig = SinOsc.ar(freq * env1.round(\roundfreq.kr(0.3)));
	sig = sig + SinOsc.ar(freq * env1);
	sig = sig.fold(\fold.kr(1) * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([1,3],inf),8)*40*Pseq([1,1,1.2],inf),
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,2.1],[0.1,0.2,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,1,0.31,0.07],inf),7),
			\sustain, 2,
			\amp, 0.02,
		),
		Pbind(
			\instrument, \ploux2,
			\freq, Pseg(Pseq([1,1.13,0.98],inf),1.1)*321.4,
			\at, Pseg(Pseq([0,1],inf),8),
			\dec, Pseg(Pseq([3,0.1],inf),3),
			\roundfreq, Pseg(Pseq([0,0.01,1,0.4],inf),9),
			\env1, Pfunc({ arg ev;
				[Env([ev[\at],ev[\dec],1,0.1]/100+1,[0.1,0.1,1])]
			}),
			\env2, Pfunc({ arg ev;
				[Env([ev[\dec],ev[\at],0.61,0.01],[0.4,0.1,1])]
			}),
			\dur, Pseg(Pseq([0.1,0.05,1,1],inf),8),
			\sustain, 1,
			\amp, 0.02,
		),
		
	])
)).play;
);

///////////////
// use powerset to generate all combination, nice idea but take lot of code to generate a few lines that could be coped colled faster

~hatcombi = [ [ 0, 1, 0, 1, 0, 1, 0, 1 ], [ 1, 1, 1, 1, 1, 1, 1, 1 ], [ 0, 1, 0, 1, 1, 1, 1, 1 ], [ 1, 0, 1, 0, 1, 0, 1, 0 ], [ 0, 1, 0, 1, 1, 0, 1, 0 ], [ 1, 1, 1, 1, 1, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 1, 0, 0, 0, 0 ], [ 1, 1, 1, 1, 0, 0, 0, 0 ], [ 1, 0, 1, 0, 0, 0, 0, 0 ] ];
]

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				Plazy({ arg ev;
									var lib = [

										[0,1],
										[1,1],
										[1,0],
										[0,0],
									].powerset.debug("p").collect({ arg set;
										var acc = [];
										if(set.size == 1) {
											4.do {
												acc = acc ++ set[0];
											}
										} {
											if(set.size == 2) {
												2.do {
													acc = acc ++ set[0];
												};
												2.do {
													acc = acc ++ set[1];
												};
											}
										};
										[set, acc].debug("sa");
										acc
									}).select({ arg x; x.size > 0 }).postln;
									Pseq({ Pseq(lib.choose) }.dup( 8 ),4)
				}).loop,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\velamp, 1/6,
			\dur, 1/8,
		)),
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		
	])
)).play;
);

////////////// Dealing with rests

// silence arbitrary parts of a pattern
// need to use Pswitch1 instead of Pstep because Pkey should execute each time
// Pkey(\isRest).keep(1) doesn't work because it repeat the same

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\isRest, Pswitch1([
				Pkey(\isRest),
				true,
			],Pstep( 
				Pseq([
					Pn(0,6), 
					Pn(1,2)
				],inf),
		   	1/2)),
		)
		<>
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq([0,1,2,3]),
			],inf),
			\isRest, Pseq([
				1,1,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, Prand([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pfindur(3,Pbind()),
			Pfindur(1,Pbind(\type, \rest)),
		],inf)
		<>
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq([0,1,2,3]),
			],inf),
			\isRest, Pseq([
				1,1,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, Prand([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\type, Pstep(Pseq([
				Pkey(\type).keep(1), \rest
			],inf), Pseq([3,1],inf))
		)
		<>
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq([0,1,2,3]),
			],inf),
			\isRest, Pseq([
				1,1,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, Prand([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PschedMute(Pseq([0,1,3,3,1],inf)) // API could change
		<>
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pseq([0,1,2,3]),
			],inf),
			\isRest, Pseq([
				1,1,0,1, 1,1,1,1,
			],inf).coin.not,
			\dur, Prand([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
);


//////////////// fast cluster of notes become its own sound


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq(12.collect { arg idx;
						Pseq([
							0,idx,
						],inf) + Pseq((1..4),inf).stutter(2) - Pseq((1..6).mirror,1).stutter(8);
					})
				}).loop,
			],inf),
			\dur, 1/64,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


////////////////////// loop sound and add elements each time


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
	   
			loop {
				sp.par(Pbind(
					\instrument, \default,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\note, Pseq([
						Pseq([0,2,4,5,7,9,11,12].collect({ arg x; x + ( ( (1..5).choose-3 ) * 12 ) }).scramble-2),
					],inf),
					\dur, 1/4,
					\lag, ( 1/4 ).rand,
					\amp, 0.1/2,
				));
				2.wait;
			}
		})
		
	])
)).play;
);


//////////////////////////////////////////////////////
///////////////// mtranspose ctranspose root
// \mtranspose use degree indexing
// \ctranspose use note indexing
// \root is same as ctranspose
// \gtranspose is like ctranspose but use provided scale instead of 12TET
~t = 185/4/60; TempoClock.default.tempo = ~t;

(
// \degree and \ctranspose
// since we use ctranspose instead of mtranspose, every chord is major
// does not follow scale
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,0],inf),
		\ctranspose, Pseq([0,2,4,5],inf).stutter(4),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
// \note and \ctranspose
// since we use ctranspose instead of mtranspose, every chord is major
// does not follow scale
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\note, Pseq([0,4,7,0],inf),
		\ctranspose, Pseq([0,2],inf).stutter(4),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
// \degree and \mtranspose
// follow the scale
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,0],inf),
		\mtranspose, Pseq([0,1],inf).stutter(4), 
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
// \note and \mtranspose
// does not work, does not transpose
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\note, Pseq([0,4,7,0],inf),
		\mtranspose, Pseq([0,1],inf).stutter(4),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);


//// use both

(
// note 9 is La
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,2],inf),
		\mtranspose, Pseq([0,1,2,3],inf).stutter(4),
		\ctranspose, 9, // now scale start at La, but still in major scale
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
// degree 5 is La
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,2],inf),
		\mtranspose, Pseq([0,1,2,3],inf).stutter(4) + 5, // now we are in minor scale
		\ctranspose, -9, // minor scale but starting at do
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
// with \mtranspose, 1, every chord is minor
// but we now start at Ré, to start again at Do, we remove 2 to ctranspose
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,2],inf),
		\ctranspose, Pseq([0,2,4,5],inf).stutter(4)-2,
		\mtranspose, 1,
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

///// what if i want to use F major scale ?
// F is number 5 in \note index
// we want chromatic transpose
// \mtranspose, 5, would only play white keys starting from A (since mtranspose use \degree index)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq((0..7),inf),
			\ctranspose, 5, // f major scale
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

///////


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\ctranspose, Pseq([
			0,5,7,5,
		],inf).stutter(4),
		\degree, Pseq([0,2b,4,0],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
	// using scale is equivalent to using bemol
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\ctranspose, Pseq([
			0,5,7,5,
		],inf).stutter(4),
		\scale, Scale.minor,
		\degree, Pseq([0,2,4,0],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

//////
(
	// ctranspose does not follow scale
	// should be minor chord
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\ctranspose, Pseq([
			9,14,16,14,
		],inf).stutter(4),
		\degree, Pseq([0,2,4,0],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);
(
	// mtranspose follow scale
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\mtranspose, Pseq([
			5,8,9,8,
		],inf).stutter(4),
		\degree, Pseq([0,2,4,0],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
	// equivalent to changing scale
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\mtranspose, Pseq([
			5,8,9,8,
		],inf).stutter(4),
		// minor scale built on 5eme degree
		// 5eme degree = 9 demi tons 
		// (en debutant a 0, donc en solfege le 6eme degree )
		\root, -9, 
		\degree, Pseq([0,2,4,0],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
	// same
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\ctranspose, Pseq([
			0,5,7,5,
		],inf).stutter(4),
		\scale, Scale.minor,
		\degree, Pseq([0,2,4,0],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);


//////////////// guitar composition

// guitar strings notes are [4,9,2, 7,11,4]
// with correct octaves: [4,9,2+12, 7+12,11+12,4+12+12]
// chords are applied by adding fret count for each string
// strumming is done with \amp
// from algokit/guitar.scd

(
Pdef(\zed, Pbind(
	\instrument, \default,
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pstep(Pseq([
			[1,3,3,2,1,1], // fa maj
			[1,1,3,3,2,1], // la# min
			[1,3,3,2,1,1]+1, // fa# maj
			[1,1,3,3,2,1], // la# min
		],1),1),
	],inf),
	\octave, 4,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/4,
	\amp, 0.1 * Pseq([
		//[\rest,\rest,\rest,\rest,\rest],
		//[0,1,0,0,1,0],
		//[0,1,0,0,1,0].rotate(rrand(0,6)),
		Plazy({ arg ev;
			Pseq([
				[0,1,0,0,1,0].rotate(rrand(0,6)),
				[0,1,0,0,1,0].rotate(rrand(0,6)),
				[0,1,0,0,1,0].rotate(rrand(0,6)),
				[0,1,0,0,1,0].rotate(rrand(0,6)),
			],4)
		}).loop,
		//[0,1,0,0,1,0],
	],inf),
)).play;
)

/////////////// Pconst
// create various rhytms
// \dur, Pconst(1,Prand([1/2,1/2,1/4,1/8,1/6],inf).stutter(4)).loop.trace,


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1248].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[821].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 3,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \default,
			\adsr, Pseq([
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),

			\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
				Pstep(Pseq([
					[1,3,3,2,1,1], // fa maj
					[1,1,3,3,2,1], // la# min
					[1,3,3,2,1,1]+1, // fa# maj
					[1,1,3,3,2,1], // la# min
				],1),1),
			],inf),
			\octave, 4,
			\isRest, Pseq([
				false
			],inf),
			//\note, [4,0,3,6,1,4],
			\dur, Pconst(1,Prand([1/2,1/2,1/4,1/8,1/6],inf).stutter(4)).loop.trace,
			\amp, 0.1 * Pseq([
				//[\rest,\rest,\rest,\rest,\rest],
				//[0,1,0,0,1,0],
				//[0,1,0,0,1,0].rotate(rrand(0,6)),
				Plazy({ arg ev;
					Pstep(Pseq([
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),
					],4), 1)
				}).loop.trace,
				//[0,1,0,0,1,0],
			],inf),
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1248].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[821].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 3,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1904].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, Pconst(1,Prand([1/2,1/2,1/4,1/8,1/6],inf).stutter(4)).loop.trace,
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1248].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[821].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 3,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1888].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, Pconst(1/2,Prand([1/2,1/2,1/4,1/8,1/16],inf).stutter(Prand([2,4],inf))).loop.trace,
			\gain, 0.11,
		),
	])
)).play;
);

//////////////////// chaotic chords
// spawn random notes
// change chord with compose

(
SynthDef(\kipik, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * ( SinOsc.ar(freq*\fmfr.kr(2)) * \fma.kr(1) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			loop  {
				sp.par(
					Pbind(
						\instrument, \kipik,
						\degree, Pseq([ [0,4,7,9,11].choose ],inf),
						\octave, [3,4,5,6].choose,
						\sustain, 0.1,
						//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
						\lpfr, rrand(0.6,4),
						\dur, rrand(1/4,3),
						\amp, 0.1/2,
						\out, BusDef(\ifx1, \audio),
					)
				);
				rrand(1,4.0).wait;
			}
		}),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/4/~t,
			//\delay, ~pmodenv.(Pseq([1,1/2,1,1/4]/8/~t,1), 8).loop,
			\decay, 8,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\ctranspose, Pstep(Pseq([
				0,7,
			],inf),8),
		) <>
		Pspawner({ arg sp;
			loop  {
				sp.par(
					Pfindur(rrand(8.0,32),Pbind(
						\instrument, \kipik,
						\note, Pseq([ [0,4,7,9,11].choose ],inf),
						\octave, [3,4,5,3,4,5,6].choose,
						\sustain, 0.1,
						\fmfr, [1/2,1/3,2,1].choose,
						//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
						\lpfr, exprand(0.6,4),
						\dur, rrand(1/4,3),
						\amp, 0.1/2,
						\out, BusDef(\ifx1, \audio),
					))
				);
				rrand(1,4.0).wait;
			}
		}),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/4/~t,
			//\delay, ~pmodenv.(Pseq([1,1/2,1,1/4]/8/~t,1), 8).loop,
			\decay, 8,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);


/////////////////////////
//////// mute parts of parts 

(
Pdef(\part, Pdef(\housedrum, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\hats, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[217].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1, 
				1,1,1,1, 0,0,0,0,
				1,1,0,0, 1,1,0,0, 
				0,0,1,1, 0,0,1,1, 
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0, 
				0,0,1,0, 0,0,1,0, 
				0,0,0,0, 1,0,0,0, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1360].value,
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

// acting on event type
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\muter, Pstep(Pseq([
				0,1,1,1,
			],inf), 1),
			\rester, Pfunc({ arg ev; if(ev[\muter].coin == true) { 1 } { ev[\type] = \rest; 0 }; }),
		)<>
		Pdef(\hats),
		Pbind(
			\muter, Pstep(Pseq([
				1,1,1,0,
			],inf), 1),
			\rester, Pfunc({ arg ev; if(ev[\muter].coin == true) { 1 } { ev[\type] = \rest; 0 } }),
		)<>
		Pdef(\housedrum)
	])
)).play;
);

// acting on gain and amp
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\muter, Pstep(Pseq([
				0,1,1,1,
			],inf), 1),
			\gain, Pkey(\gain) * Pkey(\muter),
			\amp, Pkey(\amp) * Pkey(\muter),
		)<>
		Pdef(\hats),
		Pbind(
			\muter, Pstep(Pseq([
				1,1,1,0,
			],inf), 1),
			\gain, Pkey(\gain) * Pkey(\muter),
			\amp, Pkey(\amp) * Pkey(\muter),
		)<>
		Pdef(\housedrum)
	])
)).play;
);

		Pbind(
			\muter, Pstep(Pseq([
				0,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,0,0,
				1,1,1,1,
				1,1,1,1,
				1,1,1,1,
				1,1,1,0,
			],inf), 1),
			//\gain, Pkey(\gain) * Pkey(\muter),
			//\amp, Pkey(\amp) * Pkey(\muter),
			\rester, Pfunc({ arg ev; if(ev[\muter].coin == true) { 1 } { ev[\type] = \rest } }),
		)<>
		Pdef(\housedrum),


/////////////////////
/// compose drums using delays


(
SynthDef(\fx_fatecho, { arg out=0, gate=1, lfofreq=0.5, lfoamp = 0.1, pan=0;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=10;
	var fbin;
	var fbsig;
	sig = in;

	fbin = FbNode(2, \fbdelaymax.kr(0.6));
	sig = sig + ( fbin.delay(\fbdelay.kr(0.2)) * \fb.kr(0.7) );

	sig = sig.collect { arg isig, idx;
		var xsig;
		//xsig = (sig.wrapAt(idx+1)*\crosstalk.kr(0.2));
		xsig = sig;
		isig = FreqShift.ar(isig + xsig, ExpRand(\shiftmin.kr(0.001),\shiftmax.kr(0.1)!num) * ( LFNoise1.kr(lfofreq!num) * lfoamp + 1 )).mean + isig;
		isig = DelayL.ar(isig, \delaymax.kr(0.1), ExpRand(\delaymin.kr(0.001),\delaymax.kr!num) * ( LFNoise1.kr(lfofreq!num) * lfoamp + 1 )).mean + isig;
		isig;
	};

	//sig.debug("sig");
	sig = Pan2.ar(sig, pan + ( [1,-1] * \panspread.kr(0.8) ) + LFNoise1.kr(\panlfofreq.kr(1/2)!2,mul:\panlfoamp.kr(0.2)), 1).mean;

	fbsig = sig;
	fbsig = HPF.ar(fbsig, \hpf.kr(30));
	fbin.write(fbsig);

	//sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);

	sig = Limiter.ar(sig, \limiter.kr(0.4));

	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,-1,-1,-2,-2,-3,-3,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\pan, Pseq([-1,1],inf),
			\legato, 0.1,
			\out, BusDef(\ifx1, \audio),
			//\isRest, true,
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, 1/Pseq([1,3,4,16,8],inf)/~t,
			\gain, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1187].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx2, \audio),
			//\isRest, true,
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pseq([1,2,3,4,8],inf)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 1.5,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pkey(\score),
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx3, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pseq([1,2,4,8],inf)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 1.5,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
			\out, BusDef(\ifx4, \audio),
		),
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx4, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([1,1,0],inf),
			\mix, 0.8,
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pseq([4,8,16,2],inf)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 2,
			\dur, 1,
		),
		Pbind(
			\instrument, \simplegran_adsrcomp,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,0,-1,-1,-2,-2,-3,-3,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				Pseg(Pseq([0,0.01],inf),8)+4.2,
				//~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf) + Pseq([0,3],inf),
			\lpmix, 0.71,
			\lpfr, 8,
			\rq, 0.8,
			\resmix, 0.41,
			\bwr, ~pmodenv.(Pseq([0.1,2,1,14],1), 8).loop,
			\resfr, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1)*4,
				1,2,8,1/2,
			],inf),
			//\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			//\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				1,0.7, 0.7,0.7, 0.7,0.7, 1,0.7,
				0.5,0.7, 1,0.7, 0.7,0.7, 1,0.7,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0.7, 0.9,0.7,
			],inf).coin.not,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 0.7,

		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\fx_fatecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.8,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([
					1,0,1,1, 0,1,1,0,
				],7),
			],inf),
			\delaymax, 0.04,
			\lfoamp , 0.01,
			\lfofreq, 0.3,
			\shiftmax, 40,
			\fb, 0.7,
			\fbdelay, Pseq([1,2,3,4,1/5,1/10,1/2,1/3],inf)/4/~t,
			\fbdelay, 1/Pstep(Pseq([1,2,3,4,8],inf),2)/~t,
			//\fbdelay, Pseq([1,1/4],inf)/4/~t,
			\gain, 1.5,
			\dur, 1/2,
		),
		Pbind(\out, BusDef(\ifx1, \audio)) <>
		Ppar([
			
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[879].value,
				\score, Pseq([
					1,0,0.4,0, 0.3,0,0.3,0,
					0,0,0.5,0.5, 0,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.15 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[771].value,
				\score, Pseq([
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,1,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.05) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pkey(\score),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1090].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\score, Pseq([
					0.2,0,1,0, 0.2,0.2,1,0.2,
					0.2,0,0.2,0.1, 0.2,0,1,0.2,
				],inf),
				\isRest, Pkey(\score).coin.not,
				\dur, 1/8,
				\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
			),
		]),
	])
)).play;
);


////////////// utiliser un rythme ternaire au milieu d'un rythme binaire
//// probleme: impossible de mettre un Rest, et pas utilisable dans le \isRest


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\legato, 0.3,
			\note, Pseq([
				0,4,4,4, [1,2,3],4,4,4,
			],inf),
			\octave, 3,
			\strum, 1/3,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);



/////////// grace note and flam

(
// use multichannel
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1637].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lag, Pseq([
				[0,-0.035],0,0,0, 0,0,0,0,
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				[1,1/4],1,1/2,1, 1/2,1,1/2,1,
			],inf),
		),
		
	])
)).play;
);


///////// arpegiator

~t = 145/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7],
			[4,7,11-12],
			[5,9,12-12],
			[7,11-12,14-12],
		],inf),1/2),
		\arp, Plazy({ arg ev;
			if(ev[\arp].notNil) {
				ev[\arp]
			} {
				Pseq(rrand(0,9!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = it +.x [-12,0,12];
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 2, \prepeat,8*16,
			\isRest, Pseq([
				1,1,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,8*2,
			\isRest, Pseq([
				1,1,1,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,400,
			\isRest, Pseq([
				1,1,1,0.3, 0,1,0.5,0.5,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 6, \plen, 4, \prepeat,8*8,
			\arp, Pseq([
				0,3,2,3, 2,3,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(rrand(0,8)),inf).coin.not,
		),
	])
)).play;
);


/// stutter whole Pbind with Pstep


(
Pdef(\zed, 
	Pbind(
		\note, Pseq([0,1,4,5],inf),
		\dur, 1/8,
	) <> Pstep(Pbind(\octave, Pseq([6,5],inf), \legato, Pseq([1,0.1],inf)), 1)
).play;
);


//////////////////////
// dotted bassline


~t = 122/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("holis/synthdef.scd");
(
// 1/8 bassline
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,\r,\r,
				0,\r,\r,
				0,\r,\r,
				0,\r,\r,
				0,\r,0,\r,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
// 1/4 bassline
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,\r,\r,
				0,\r,\r,
				0,\r,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

(
// 1/8 bassline
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					0,\r,\r,
					0,\r,\r,
					0,\r,\r,
					0,\r,\r,
					0,\r,\r,
					0,

					\r,\r,
					0,\r,\r,
					0,\r,\r,
					0,\r,\r,
					0,\r,3,
					0,7,
				],1)+9,

				Pseq([
					0,\r,\r, 0,\r,\r, 
					0,\r,\r, 0,\r,\r, 
					0,\r,4, 0,
				],1)+5,
				Pseq([
					\r,\r,0, \r,\r,0,
					\r,\r, 0,\r,\r, 
					0,\r,3, 0, 7,
				],1)+4,
			],inf),
			\rq, 0.5,
			\octave, [2,3],
			\pulse, 1,
			\envamt, 6,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.1,0.1) ], // pluck filter env
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4,1,-4) ], // pluck too
			],inf),
			\lpf, PmodEnv(Pseq([400,2000],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1 * [0.4,1]/1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);
