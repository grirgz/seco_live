~t = 127/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			\note, Pseq([
				\AM, \AM, \AM7_d, \AM7, \DM, \Dm, \AM, \AM,
				\Fsm, \Fsm, \FM, \FM, \AM, \AM, \D0M, \AM,
			],inf),
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[702].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,0,1,
				0,1,1,0, 0,0,1,0,
				1,0,0,1, 0,0,1,1,
				0,1,1,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.7,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2158].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[807].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.81 * Pseq([1,0.2],inf),
			\gain, 0.11 * Pseq([1,0.1],inf),
		),
		
		
	])
)).play;
);

Pseq([ \AM, \AM7, \DM, \Dm, \AM, \AM, ],1).asStream.nextN(10)
Pseq([ \Fm, \Fsm],1).asStream.nextN(10)
Pseq([ \AM, \AM7, \Adom7, \Adim7, \A7sus2, \A7flat5, \A7, \Cm_g],1).asStream.nextN(10)
Pseq([ \AM7, \AM7_d],1).asStream.nextN(10)
( Pseq([ \AM7, \A9M7],1) % 312 ).asStream.nextN(10)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				\AM, \AM_a, \AM7_d, \AM7, \DM, \Dm, \AM, \AM,
				\Fsm, \Fsm, \FM, \FM, \AM, \AM, \DM, \AM,
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
ChordNotes
ChordSymbol.shapes.keys

SynthDescLib.global[\basicpad].makeWindow


/////////////////


(
SynthDef(\pluri, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = 10.collect { arg idx;
		SinOsc.ar(freq * Rand(0.5,2)) * ( SinOsc.ar(Rand(0.1,1)).clip(0.2,1)-0.2 );
	}.sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Synth(\pluri);

(
SynthDef(\pluri, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = 10.collect { arg idx;
		var igate = Duty.kr(Rand(0.1,2), 0, Dshuf([
			1,0,0,0,
		],inf));
		SinOsc.ar(freq * Rand(0.5,3)) * EnvGen.kr(Env.adsr(Rand(0.01,1),0.1,0.8,Rand(0.01,1)), igate, doneAction:0);
	}.sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pluri, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = 10.collect { arg idx;
		var igate = Duty.kr(Rand(0.1,0.4), 0, Dshuf([
			1,0,0,0,
		],inf));
		SinOsc.ar(freq * Rand(0,24).midiratio) * EnvGen.kr(Env.adsr(Rand(0.01,0.1),0.1,0.8,Rand(0.01,0.1)), igate, doneAction:0);
	}.sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Ndef(\bla, \pluri).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\ctranspose, Pstep(Pseq([0,5,0,0,7,5,0,0],inf),1),
		)<>
		Ppar( 10.collect { arg item, idx;
			Pbind(
				\instrument, [\basicpad, \sinchord].choose,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\note, rrand(0,24*2),
				\legato, 0.2,
				\dur, rrand(0.1,0.4),
				\isRest, Pshuf([
					1,0,0,0,
				],inf).coin.not,
				\octave, 3,
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			)
		})
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,0,0,4,3,0,0],inf),1),
		)<>
		Ppar( 10.collect { arg item, idx;
			Pbind(
				\instrument, [\basicpad, \sinchord].choose,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\degree, rrand(0,7*4),
				\legato, 0.2,
				\dur, rrand(0.1,0.4),
				\isRest, Pshuf([
					1,0,0,0,
				],inf).coin.not,
				\octave, 3,
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			)
		})
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-TU0B-6MP6", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.49159663865546,
	'gain', 0.68243243243243,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.53838436220335,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mtranspose, Pstep(Pseq([0,3,0,0,4,3,0,0],inf),1),
		)<>
		Ppar( 20.collect { arg item, idx;
			Pbind(
				\instrument, [\basicpad, \sinchord].choose,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\degree, \Cm9.asDegrees.choose + [0,7,14].choose,
				\legato, 0.2,
				\dur, rrand(0.1,2.4),
				\isRest, Pshuf([
					1,0,0,0,
				],inf).coin.not,
				\octave, 3,
				\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			)
		})
		
	])
)).play;
);

\Cm11.asDegrees
(
var a, b;
a = Pshuf([1, 2, 3, 4, 5], 3);    // repeat 3 times
b = a.asStream;
16.do({ b.next.postln; });
)
