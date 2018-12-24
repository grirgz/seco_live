
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(121) * ( SinOsc.ar(121.01) * ( SinOsc.ar(121) * ( SinOsc.ar(121 * [1,2,1/2,1.01]) * 1 + 1 ) + 1 ) + 1 ) + 1 ));
	sig = Pan2.ar(sig, pan, amp).mean * 2;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(121) * ( SinOsc.ar(121) * ( LFSaw.ar(120) * ( SinOsc.ar(421 * [1,2,1/2,1.01]) * 1 + 1 ) + 1 ) + 1 ) + 1 ));
	sig = Pan2.ar(sig, pan, amp).mean * 2;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(421) * ( SinOsc.ar(421) * ( LFCub.ar(420 * ( SinOsc.ar(110) * 1 + 1 )) * ( SinOsc.ar(1/10 * [1,2,1/2,1.01]) * 1 + 1 ) + 1 ) + 1 ) + 1 ));
	sig = Pan2.ar(sig, pan, amp).mean * 2;
}).play;
);

(
Ndef(\zed, { arg freq=1200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = XLine.kr(2,0.2,10);
	mod2 = XLine.kr(0.2,2,10);
	sig = SinOsc.ar(freq  * ( SinOsc.ar(421 * mod1) * ( SinOsc.ar(421* mod2) * ( LFCub.ar(420 * ( SinOsc.ar(110) * 1 + 1 )) * ( SinOsc.ar(1/10 * [1,2,1/2,1.01]) * 1 + 1 ) + 1 ) + 1 ) + 1 ));
	sig = Pan2.ar(sig, pan, amp).mean * 2;
}).play;
);

///////////////////
(
~t = 135/4/60; TempoClock.default.tempo = ~t;
ProtoDef(\rdn).outBus = 0;
ProtoDef(\rdn2).outBus = 0;
ProtoDef(\rdn2).inBus = BusDef(\sendbus1, \audio);
)

(
SynthDef(\hinoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = XLine.kr(2,0.2,10);
	mod2 = XLine.kr(0.2,2,10);
	sig = SinOsc.ar(freq  * ( SinOsc.ar(421 * mod1) * ( SinOsc.ar(421* mod2) * ( LFCub.ar(420 * ( SinOsc.ar(110) * 1 + 1 )) * ( SinOsc.ar(1/10 * [1,2,1/2,1.01]) * 1 + 1 ) + 1 ) + 1 ) + 1 ));
	sig = Pan2.ar(sig, pan, amp).mean * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\basicsin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	ProtoDef(\rdn).play;
Pdef(\zed, 
	Pmono( \hinoise,
		\degree, Pseq([0],inf),
		\freq, 1200,
		\dur, 1,
		\amp, 0.1,
		//\out, BusDef(\sendbus1, \audio),
	)
).play;
);

	ProtoDef(\rdn2, ProtoTemplateDef(\rdn))
	ProtoDef(\rdn2).edit
~master.()
	(
	)
(
	ProtoDef(\rdn).play;
Pdef(\zed, 
	Pbind( \instrument,\hinoise,
		\degree, Pseq([0],inf),
		\freq, 1200,
		\legato,0.1,
		\dur, 1,
		\amp, 0.1,
		\out, BusDef(\sendbus1, \audio),
	)
).play;
);

	ProtoDef(\rdn2).edit;
	ProtoDef(\rdn).edit;
	Ndef(\rdn2).edit
	Pdef(\part).clear;
(
ProtoDef(\rdn).play;
ProtoDef(\rdn2).play;
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \hinoise,
		\out, BusDef(\fx1, \audio),
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,1,0,0, 0,0,0,0,
		],inf).coin.not,
			\freq, 1200,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\amp, 0.1/2,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0, 1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16 * (1 + (0.06 * Pseq([1,-1],inf))),
			\out, BusDef(\sendbus1, \audio),
		)),

		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,0,
				0,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
)

(
ProtoDef(\rdn).play;
ProtoDef(\rdn2).play;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,-1,0,2,
			],inf).stutter(8),
			//\adsr, Pseq([
				//[ Env.adsr(0.001,0.1,0.8,0.4) ],
			//],inf),
			\out, BusDef(\fx1, \audio),
			\octave, Prand([3,7],inf),
			\legato, Pseq([
				1,1,1,1,
			],inf)*0.3,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

(
~mymaster = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
}
)

	ProtoDef(\rdn).clear
(
	~mymaster.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\speed, 1.1,
				\sustain, 0.1/2,
				\gain, 1/2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
					1,0,0,1, 1,0,1,0,
					1,1,0,0, 1,0,1,0,
					1,0,1,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \basicsin,
				\note, Pseq([
					0,3,4,4,8-12,8-12,3,0,
				],inf).stutter(1) + 
				Pseq([
					0
				],inf),
				\octave, 3,
				\diff, 0.001,
				\fmr, 1/4,
				\lpfr, 1/2,
				\dur, 1/2,
				\lag, 0.04,
				\amp, 0.1/82,
			),
		]),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,5,
				],inf).stutter(2) + 
				Pseq([
					[0,3,8],
					[0,4,8],
					[0,3,8],
					[0,3,6],
				],inf),
				\octave, 8,
				\diff, 0.001,
				\fmr, 1/4,
				\lpfr, 1/2,
				\dur, 1,
				\lag, 0.04,
				\amp, 0.1/3/3,
				\out, BusDef(\sendbus0, \audio),
			),
	])
)).play;
)

		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\speed, 1.1,
				\sustain, 0.1/2,
				\gain, 1/2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
					1,0,0,1, 1,0,1,0,
					1,1,0,0, 1,0,1,0,
					1,0,1,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),

(
	~mymaster.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\speed, 1.1,
				\sustain, 0.1/2,
				\gain, 1/2,
				\dur, 1/8,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,1,
					1,0,0,1, 1,0,1,0,
					1,1,0,0, 1,0,1,0,
					1,0,1,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \basicsin,
				\note, Pseq([
					0,3,4,4,8-12,8-12,3,0,
				],inf).stutter(1) + 
				Pseq([
					0
				],inf),
				\octave, 3,
				\diff, 0.001,
				\fmr, 1/4,
				\lpfr, 1/2,
				\dur, 1/2,
				\lag, 0.04,
				\amp, 0.1/82,
			),
		]),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,5,
				],inf).stutter(2) + 
				Pseq([
					[0,3,8],
					[0,4,8],
					[0,3,8],
					[0,3,6],
				],inf),
				\octave, 8,
				\diff, 0.001,
				\fmr, 1/4,
				\env1, Pseq([
					[ Env([1,2,1],[0.1,0.8]) ],
					[ Env([1,2,1],[1.1,0.8]) ],
					[ Env([1,0,1],[0.1,0.8]) ],
				],inf),
				\legato, Pseq([
					1,
				],inf).stutter(8),
				\lpfr, 1/2,
				\dur, 1,
				\amp, 0.1/3,
				\out, BusDef(\fx2, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\fx2, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.5714285714286,
				'gain', 0.1344889782792,
				'fb', 0.0002099467303085 * Pseq([
					1,1,1, 1,1,1,
					1,1,1,1000,1000,1000,
				],inf),
				'delay', 0.000600001231 * Pseq([
					1,1,10,
					1,1,100,
					1,1,1,
					1,1/10,1/10,
				],inf).stutter(1),
				'delay2', 0.010000543560101 * Pseq([
					1,1/100,1/10,1/1000,
				],inf).stutter(16*4),
				'distamp', 10.361836201538 * Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					],8),
					1,1, 1,1, 1,1, 0,0,
					1,1, 1,1, 0,0, 0,0,
					1,1, 0,0, 1,1, 1,1,
					1,1, 1,1, 1,0, 1,1,
					1,1, 0,0, 0,0, 1,1,
					1,1, 1,1, 0,0, 1,0,
				],inf),
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 14.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/16,
				\out, BusDef(\mixer1, \audio),
			),
			Pbind(
				\instrument, \iron,
				\note, Pseq([
					0,5,
				],inf).stutter(2) + 
				Pseq([
					[0,3,8],
					[0,4,8],
					[0,3,8],
					[0,3,6],
				],inf),
				\octave, 8,
				\diff, 0.001,
				\fmr, 1/4,
				\lpfr, 1/2,
				\dur, 1,
				\lag, 0.04,
				\amp, 0.1/3/3,
				\out, BusDef(\mixer2, \audio),
			),
	])
)).play;
)

/////////////
(
MKtl('icon', "icon-icontrols");
~icon_map_param.(MKtl('icon')[\kn][0], Param(Ndef(\rdn), \gain, ControlSpec(0,1/2,\lin)));
~icon_map_param.(MKtl('icon')[\kn][1], Param(Ndef(\rdn), \delay));
~icon_map_param.(MKtl('icon')[\kn][2], Param(Ndef(\rdn), \delay2));
~icon_map_param.(MKtl('icon')[\kn][3], Param(Ndef(\rdn), \fb));
~icon_map_param.(MKtl('icon')[\kn][4], Param(Ndef(\rdn), \distamp));

~icon_map_param.(MKtl('icon')[\sl][0], Param(Ndef(\rdn2), \gain, ControlSpec(0,1/2,\lin)));
~icon_map_param.(MKtl('icon')[\sl][1], Param(Ndef(\rdn2), \delay));
~icon_map_param.(MKtl('icon')[\sl][2], Param(Ndef(\rdn2), \delay2));
~icon_map_param.(MKtl('icon')[\sl][3], Param(Ndef(\rdn2), \fb));
~icon_map_param.(MKtl('icon')[\sl][4], Param(Ndef(\rdn2), \distamp));
)

, Param(Ndef(\rdn2), \delay)
~icon_map_param.(P)
~icon_map_param.(MKtl('icon')[\kn][0], Param(Ndef(\rdn), \delay))
k[\kn].collect({ arg k; k })
k[\sl][0]
k[\kn][0].action = { "kjkj".postln }
k.postElements;


ProtoDef(\rdn).presetCompileString.editorInsert
(
RandDelayNetwork('deldefault').make('rdn', "5-EO2N-US0");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.5,
	'fb', 0.0001,
	'delay', 0.0013610004466106,
	'delay2', 0.00011560912813836,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 20.651929314796,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 1.8821720709248,
	'fbdistmix', 0.99579831932773,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);

