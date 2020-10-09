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
		\note, 0, // default
		\octave, 5, // default
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
		\freq2, Pkey(\freq),
		\dur, 1,
		\amp, 0.1,
	),
).play;
)

// midicps

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
		\freq2, 440 * (Pkey(\note2) - 9 + (Pkey(\octave2)-5 * 12)).midiratio,
		\dur, 1,
		\amp, 0.1,
	),
).play;
)


// DegreeToKey and PdegreeToKey are used to convert from \degree to \note


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

/////////////////////////


// rand gain for upbeat render well
(
Pdef(\part, Pdef(\ze_hat_ksh2b, 
	Ppar([
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\lag, 0.04,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.2 * Pseq([
				1,0.7,
			],inf) * Pseq([
				1,Pwhite(0.01,0.5,1),
			],inf),
			\amp, 0.1,
			//\lag, 0.04,
			//\out, BusDef(\fx1, \audio),
		)),
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
			\amp, 0.1,
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
			\amp, 0.1,
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
		   	,1/2)),
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
