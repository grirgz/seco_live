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
SynthDef(\chordlock, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.1,3.8])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1,1/20,1],[0.1,3.8])), 1);
	env2 =  ( Gendy1.ar(freq * [1,1.01,1.001] * env3 * Gendy2.ar(1)) * \fmamp.kr(0.1) * env1 + 1 );
	sig1 = SinOsc.ar(freq * env2);
	sig2 = LFSaw.ar(freq * env2);
	sig3 = SinOsc.ar(freq * ( sig1 * 0.1 + 1 ));
	sig = SelectX.ar(\mix.kr(0.7)*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig + BPF.ar(sig, \bpfr.kr(3.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\chordlock, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.1,3.8])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1,1/20,1],[0.1,3.8])), 1);
	env2 =  ( Gendy1.ar(freq * [1,1.01,1.001] * env3 * Gendy2.ar(1)) * \fmamp.kr(0.1) * env1 + 1 );
	env4 = EnvGen.kr(\env4.kr(Env([0,0.3,1],[0.5,8.8])), 1);
	sig1 = SinOsc.ar(freq * env2);
	sig2 = LFSaw.ar(freq * env2);
	sig3 = SinOsc.ar(freq * ( sig1 * 0.1 + 1 ));
	sig = SelectX.ar( env4, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig + BPF.ar(sig, \bpfr.kr(3.1) * freq, \rq.kr(0.5));
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
				9,
				11,
			],inf),
			\octave, Pseq([
				5,5,4,5,5,3,5,6,6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2],inf),
			\amp, 0.1,
		),
	])
)).play;
)
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

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				0,-1,
			],inf).stutter(2),
			\octave, 3,
			\lpfr, 2,
			\dur, 1,
			\amp, 0.1,
		),
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
				5,5,4, 5,5,3, 5,6,5, 6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				0,4,0,7,
			],inf),
			\octave, Pseq([
				6,
			],inf),
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseq([1/8,1/2,1/4,2],inf),
			\amp, 0.1,
		),
	])
)).play;
)


(
SynthDef(\basslok, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Pulse.ar(freq * [1,1.00001]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basslok,
			\note, Pseq([
				0,3,
			],inf).stutter(2),
			\octave, 3,
			\lpfr, 4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basslok,
			\note, Pseq([
				0,4,
			],inf).stutter(2),
			\octave, 3,
			\lpfr, 4,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				[4,7,16],
				[4,7-12,16],
			],inf),
			\fmamp, 0.1,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\note, Pseq([
				9,
				11,
				15,
			],inf),
			\octave, Pseq([
				5,5,4, 5,5,3, 5,6,5, 6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\note, Pseq([
				0,4,0,7,
			],inf),
			\octave, Pseq([
				6,
			],inf),
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseq([1/8,1/2,1/4,2],inf),
			\amp, 0.1,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([361, 51, 51], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 0,1,1,1,
				1,0,1,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
				0,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.1,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),


		Pbind(
			\instrument, \basslok,
			\note, Pseq([
				0,4,
			],inf).stutter(2),
			\octave, 3,
			\sustain, 0.1,
			\lag, Pseq([
				0,0,
				0,0,
				0,1/8/~t,
				0,0,
				0,1/4/~t,
				0,0,
				1/4/~t,0,
			],inf),
			\lpfr, 4,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				[4,7,16],
				[4,7-12,16],
			],inf),
			\octave, 6,
			\fmamp, 0.1,
			\strum,1/16,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\note, Pseq([
				9,
				11,
				15,
			],inf),
			\octave, Pseq([
				5,5,4, 5,5,3, 5,6,5, 6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\note, Pseq([
				0,4,0,7,
			],inf),
			\octave, Pseq([
				6,
			],inf),
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseq([1/8,1/2,1/4,2],inf),
			\amp, 0.1,
		),
	])
)).play;
)

ProtoDef(\rdn).edit
ProtoDef(\rdn2).edit
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
(
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(\out, BusDef(\sendbus0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([361, 51, 51], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,1,0,1, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.2,
			),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 0,1,1,1,
					1,0,1,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),

			Pbind(
				\instrument, \basslok,
				\note, Pseq([
					0,4,
				],inf).stutter(2),
				\octave, 3,
				\sustain, 0.1,
				\lag, Pseq([
					0,0,
					0,0,
					0,1/8/~t,
					0,0,
					0,1/4/~t,
					0,0,
					1/4/~t,0,
				],inf),
				\lpfr, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),


		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \chordlock,
				\note, Pseq([
					[4,7,16],
					[4,7-12,16],
				],inf),
				\octave, 6,
				\fmamp, 0.1,
				\strum,1/16,
				\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\legato, 1/2,
				\dur, 2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \chordlock,
				\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\note, Pseq([
					9,
					11,
					15,
				],inf),
				\octave, Pseq([
					5,5,4, 5,5,3, 5,6,5, 6,
				],inf),
				\legato, 1/2,
				\dur, Pseq([1,1/2,1/4],inf),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \chordlock,
				\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\note, Pseq([
					0,4,0,7,
				],inf),
				\octave, Pseq([
					6,
				],inf),
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, Pseq([1/8,1/2,1/4,2],inf),
				\amp, 0.1,
			),
		]),
	])
)).play;
)

(
	// higher
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(\out, BusDef(\sendbus0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([361, 51, 51], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,1,0,1, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.2,
			),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 0,1,1,1,
					1,0,1,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),

			Pbind(
				\instrument, \basslok,
				\note, Pseq([
					0,4,
				],inf).stutter(2),
				\octave, 3,
				\sustain, 0.1,
				\lag, Pseq([
					0,0,
					0,0,
					0,1/8/~t,
					0,0,
					0,1/4/~t,
					0,0,
					1/4/~t,0,
				],inf),
				\lpfr, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),


		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \chordlock,
				\note, Pseq([
					[4,7,16],
					[4,7-12,16],
				],inf),
				\octave, Prand([6,7],inf),
				\fmamp, 0.1,
				\strum,1/16,
				\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\legato, 1/2,
				\dur, 2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \chordlock,
				\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\note, Pseq([
					9,
					11,
					15,
				],inf),
				\octave, Pseq([
					5,5,4, 5,5,3, 5,6,5, 6,
				],inf),
				\legato, 1/2,
				\dur, Pseq([1,1/2,1/4],inf),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \chordlock,
				\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				\note, Pseq([
					0,4,0,7,
				],inf),
				\octave, Pseq([
					7,
				],inf),
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, Pseq([1/8,1/2,1/4,2],inf),
				\amp, 0.1,
			),
		]),
	])
)).play;
)

(
	// hat
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(\out, BusDef(\sendbus0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([361, 51, 51], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,1,0,1, 0,1,0,0,
				],inf).coin.not,
				\amp, 0.2,
			),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					0,0,0,0, 0,1,1,1,
					1,0,1,0, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,1,
					0,1,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 0.1,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),

			Pbind(
				\instrument, \basslok,
				\note, Pseq([
					0,4,
				],inf).stutter(2),
				\octave, 3,
				\sustain, 0.1,
				\lag, Pseq([
					0,0,
					0,0,
					0,1/8/~t,
					0,0,
					0,1/4/~t,
					0,0,
					1/4/~t,0,
				],inf),
				\lpfr, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[834].value,
				\sustain, 1,
				\dur, 1/8,
				\gain, 0.2,
				\lag, 0.04,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[844].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.2,
				\lag, 0.04,
			),
		]),

		//Pbind(\out, BusDef(\sendbus1, \audio)) <>
		//Ppar([
			//Pbind(
				//\instrument, \chordlock,
				//\note, Pseq([
					//[4,7,16],
					//[4,7-12,16],
				//],inf),
				//\octave, Prand([6,7],inf),
				//\fmamp, 0.1,
				//\strum,1/16,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\legato, 1/2,
				//\dur, 2,
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\note, Pseq([
					//9,
					//11,
					//15,
				//],inf),
				//\octave, Pseq([
					//5,5,4, 5,5,3, 5,6,5, 6,
				//],inf),
				//\legato, 1/2,
				//\dur, Pseq([1,1/2,1/4],inf),
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \chordlock,
				//\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
				//\note, Pseq([
					//0,4,0,7,
				//],inf),
				//\octave, Pseq([
					//7,
				//],inf),
				//\sustain, 0.1,
				//\adsr, Pseq([
					//[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//],inf),
				//\dur, Pseq([1/8,1/2,1/4,2],inf),
				//\amp, 0.1,
			//),
		//]),
	])
)).play;
)

/////////////////////////:



(
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([361, 51, 51], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 0,1,1,1,
				1,0,1,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.1,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
				0,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.1,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/ridecast.flac'),
			\dur, 1/8,
			\pos, 0.04,
			//\speed, ~pmodenv.(Pseq([1,1,1.1,2,1,4]/2,inf), 1/2),
			//\speed, Pseg(Pseq([0,1],inf),8),
			\speed, 1.2,
			\legato, 4.2,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1),
				Pseq([
					1,0,
				],8),
			],inf).coin.not,
			\gain, 1,
		),


		Pbind(
			\instrument, \basslok,
			\note, Pseq([
				0,4,
			],inf).stutter(2),
			\octave, 3,
			\sustain, 0.1,
			\lag, Pseq([
				0,0,
				0,0,
				0,1/8/~t,
				0,0,
				0,1/4/~t,
				0,0,
				1/4/~t,0,
			],inf),
			\lpfr, 4,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\note, Pseq([
				[4,7,16],
				[4,7-12,16],
			],inf),
			\octave, 6,
			\fmamp, 0.1,
			\strum,1/16,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\legato, 1/2,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\note, Pseq([
				9,
				11,
				15,
			],inf),
			\octave, Pseq([
				5,5,4, 5,5,3, 5,6,5, 6,
			],inf),
			\legato, 1/2,
			\dur, Pseq([1,1/2,1/4],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \chordlock,
			\mix, ~pmodenv.(Pseq([0,1],inf), Pwhite(1.0,8)),
			\note, Pseq([
				0,4,0,7,
			],inf),
			\octave, Pseq([
				6,
			],inf),
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseq([1/8,1/2,1/4,2],inf),
			\amp, 0.1,
		),
	])
)).play;
)
