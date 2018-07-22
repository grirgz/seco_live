// arthropod head problem

~t = 170/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\tassbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * LFSaw.ar(freq+0.1) ;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\tassbass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * SinOsc.ar(freq+0.1 * SinOsc.kr(\fmf.kr(3/~t)).range(0.92,1)) ;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

ProtoDef(\rdn).edit
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2).edit
(
~master_simple = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
}
)

(
Pdef(\part, Pdef(\noir_fast, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,1, 0,0,0,
					1,0,1, 0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 1,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/12,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],4),
				Pseq([
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,0,1,
					0,0,0, 0,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,

					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,1, 1,0,1, 1,1,1,
				],3),
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \tassbass,
			\octave, 3,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				6,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/6,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		
	])
)).play;
)


(
	// init
TrackDef(\noirgrid, TrackTemplateDef(\playergrid))
//TrackDef(\noirgrid).childAt(0,0).source = ProtoClass((play:{ "hello".postln }, isPlaying:false))
ProtoDef(\apc40).activate(TrackDef(\noirgrid))
)

(
	// init 2
TrackDef(\noirgrid).childAt(6,0).source = Ndef(\rdn);
TrackDef(\noirgrid).childAt(7,0).source = Ndef(\rdn2);

TrackDef(\noirgrid).childAt(0,0).source = Pdef(\noir_intro);
TrackDef(\noirgrid).childAt(0,1).source = Pdef(\noir_slow);
TrackDef(\noirgrid).childAt(0,2).source = Pdef(\noir_fast);

ProtoDef(\apc40).render_grid;

	ProtoDef(\apc40).mapParam([\sl, 0, 6], Param(Ndef(\rdn), \gain, ControlSpec(0,2,\lin)));
	ProtoDef(\apc40).mapParam([\sl, 0, 7], Param(Ndef(\rdn2), \gain, ControlSpec(0,2,\lin)));

	ProtoDef(\apc40).mapParam([\sl, 0, 0], ProtoDef(\simpleMixer).tracks[0].asParam(\send1));
	ProtoDef(\apc40).mapParam([\sl, 0, 1], ProtoDef(\simpleMixer).tracks[1].asParam(\send1));
	ProtoDef(\apc40).mapParam([\sl, 0, 2], ProtoDef(\simpleMixer).tracks[2].asParam(\send0));

~master = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\simpleMixer).play;
};
)


(
	~master.();
Pdef(\part, Pdef(\noir_slow, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					1,0,0, 1,0,0,
					0,0,0, 0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0, 0,0,0,
					1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/12,
			)),
		]),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
				   	0,0,0, 0,0,0,
				   	0,0,0, 0,0,0,
				   	0,0,0, 0,0,0,
					0,0,0, 1,0,1,
				   	0,0,0, 0,0,0,
				   	0,0,0, 0,0,0,
				   	0,0,0, 0,0,0,
					1,0,1, 1,0,0, 
				],inf).coin.not,
				\lag, 0.04,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/12,
			)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],4),
				Pseq([
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,0,1,
					0,0,0, 0,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,

					0,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,1, 1,0,1, 1,0,1, 1,0,1,
					1,0,1, 1,0,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,1, 1,0,1, 1,1,1,
				],3),
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \tassbass2,
			\octave, 3,
			\note, Pseq([
				0,
			],inf),
			\fmf, Pseq([
				Pser([3],7), 6,
				Pser([3],7), 12,
				Pser([3],7), 1/3,
				Pser([1],7), 12,
			],inf).stutter(12),
			\legato, Pseq([
				Pseq([
					6,0,0, 0,0,0,  0,0,0, 0,0,0,
				],7),
				6,0,0, 0,0,0,  0,0,0, 0,0,1,
				Pseq([
					6,0,0, 0,0,0,  0,0,0, 0,0,0,
				],7),
				6,0,0, 0,0,0,  1,0,1, 0,0,0,
				Pseq([
					6,0,0, 0,0,0,  0,0,0, 0,0,0,
				],7),
				6,0,0, 0,0,0,  0,0,0, 1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/6,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		
	])
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\noir_intro, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/12,
				\isRest, Pseq([
					Pseq([
						0,
					],12*14),
					1,0,1, 0,0,0,
					1,0,1, 0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\rim).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					Pseq([
						0,
					],12*14),
					0,0,0, 1,0,0,
					0,0,1, 1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/12,
			)),
		]),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				1,0,1, 1,0,1, 1,0,1, 1,0,1,
				1,0,1, 1,1,1, 1,0,1, 1,0,1,
				0,0,0, 0,0,0, 1,0,1, 1,0,1,
				1,0,1, 1,0,1, 1,0,1, 1,0,1,
				1,0,1, 1,0,1, 1,0,1, 1,0,1,
				1,0,1, 1,1,1, 1,0,1, 1,0,1,
				0,0,0, 0,0,0, 1,0,1, 1,0,1,
				1,0,1, 1,0,1, 1,0,1, 1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \tassbass,
			\octave, 3,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				6,0,0, 0,0,0,  0,0,0, 0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/6,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		
	])
)).play;
)
