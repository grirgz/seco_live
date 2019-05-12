~t = 135/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

	(
		Spec.add(\gain, ControlSpec(0,1,\lin));
	ProtoDef(\rdn, ProtoTemplateDef(\rdn)).inbus_(BusDef(\sendbus1));
	ProtoDef(\rdn2, ProtoTemplateDef(\rdn)).inbus_(BusDef(\sendbus2));
	ProtoDef(\rdn3, ProtoTemplateDef(\rdn)).inbus_(BusDef(\sendbus3));
	ProtoDef(\rdn4, ProtoTemplateDef(\rdn)).inbus_(BusDef(\sendbus4));
	~master = {
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		ProtoDef(\rdn3).play;
		ProtoDef(\rdn4).play;
	}
	)

////////////// control

FileSystemProject.load("libdef/pdeftrack.scd");
FileSystemProject.load("libdef/apc.scd");
Pdef(\pdefgrid0_0, Pbind(\note, Pseq([0,1],inf), \dur, 1/8));
Pdef(\pdefgrid0_1, Pbind(\note, Pseq([3,4],inf), \dur, 1/8));
TrackDef(\pdefgrid).edit
ProtoDef(\apc40).activate(TrackDef(\pdefgrid));
ProtoDef(\apc40).ktl
		MKtl(\apc, "akai-apc40mkii");

(
["","2","3","4"].do { arg sidx, idx;
	ProtoDef(\apc40).map_rdn_to_bank(idx, \rdn+++sidx, [
		\delay, \delay2, \distamp,\fb,
		\pitchmix,\hpf,\lpf,\gain,
	]);
};
)

ProtoDef(\apc40).activate_bank_selector

////

	ProtoDef(\rdn4).edit;
TrackDef(\pdefgrid).childAt(7,0).source = Pdef(\part); Pdef(\part).envir = ()

////////////////// score
(
Pdef(\part, Pdef(\pdefgrid0_0, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
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
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid0_1, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
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
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,1,1,1,
				],inf).coin.not,
				\sustain, 0.071,
				\gain, 0.1,
				\dur, 1/16,
				\out, BusDef(\sendbus2, \audio),
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.171,
				\speed, 1.1,
				\gain, 0.01,
				\lag, 1/4*~t,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
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
				\out, BusDef(\sendbus3, \audio),
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid0_2, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
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
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \basicbass,
				\freq, 90,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, ~pmodenv.(Pseq([100,78,61,54],inf), 8),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid0_3, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 0,0,1,1,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \basicbass,
				\freq, 90,
				\dur, 1,
				\legato, 0.2,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, ~pmodenv.(Pseq([100,78,61,54],inf), 8),
				\dur, 1/1.2 * Pseg(Pseq([1,2],inf),8),
				\legato, 0.2,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.18 * Pseq([1,0.7],inf),
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				   	0,0,0,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\lag, 1/16/~t,
				\dur, 1/8,
				\amp, 0.18 * Pseq([1,0.7],inf),
				\out, BusDef(\sendbus3, \audio),
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,1,1, 0,1,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,1,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,1,1,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,1, 0,1,0,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,0,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,1,
					0,0,1,0, 0,1,1,1,
					0,0,1,0, 0,1,1,1,
					0,0,1,0, 0,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					0,1,0,1, 0,0,0,0,
					0,1,0,1, 0,0,0,0,
					0,1,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,1,0,
					0,1,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.091,
				\speed, 0.95,
				\gain, 0.04,
				\dur, 1/16,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/kaspi.flac'),
				\dur, 1/8,
				\legato, Pseq([
					0,0,1,0.5, 0,1,0.5,0.5,
					1,0,0,0, 0,0,2,0,
					1,0,0,0.2, 0,0,2,0,
					4,0,0,0, 2,0,2,0,
					1,0,1,0, 1,1,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\pos, ~pmodenv.(Pseq([0,0.2,0.6,1],inf), 1),
				\gain, 1,
				\out, BusDef(\sendbus4, \audio),
			),
	])
)).play;
);
(
Pdef(\part, Pdef(\pdefgrid0_4, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 0,0,1,1,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
		]),
		
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			Pbind(
				\instrument, \basicbass,
				\freq, 90,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, ~pmodenv.(Pseq([100,78,61,54],inf), 8),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\pdefgrid0_5, 
	Ppar([
		
			Pbind(
				\instrument, \basicbass,
				\freq, ~pmodenv.(Pseq([4000,2180,621,54],inf), 7),
				\isRest, Pseq([
					0,0,0,0, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\lpf, 3000,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,1, 1,1,1,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\freq, ~pmodenv.(Pseq([100,180,6221,54],inf), 7),
				\lpf, ~pmodenv.(Pseq([100,180,6221,54],inf), 4),
				\dur, 1/16,
				\legato, 0.4,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\freq, ~pmodenv.(Pseq([10,780,6221,54],inf), 8),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef(\rdn).make(\deldefault, 'rdn', "6-S5J9-K480");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1,
	'fb', 0.00055930782406139,
	'delay', 0.0001,
	'delay2', 0.00023428684237322,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.3463059962866,
	'pitchlag', 1.0,
	'pitchmix', 0.46218487394958,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
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


ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef(\rdn2).make('deldefault', 'rdn2', "6-JT51-2KGE");
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.60195390291997,
	'fb', 0.0001,
	'delay', 0.00034499684705497,
	'delay2', 0.2297970969047,
	'shift', 0,
	'shift2', 0.042016806722689,
	'distamp', 9.8083654454067,
	'pitchlag', 0.125,
	'pitchmix', 0.0042016806722689,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 117.47286445047,
	'fbdistamp', 0.41954181236735,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef(\rdn3).make('deldefault', 'rdn3', "6-179R-RC1");
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.19478345215597,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.00012613637220374,
	'shift', 0,
	'shift2', 0,
	'distamp', 0.1,
	'pitchlag', 1.0,
	'pitchmix', 0.86554621848739,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 2.1386455896411,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

// vener
ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef(\rdn3).make('deldefault', 'rdn3', "6-7LJS-9CKI");
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.19478345215597,
	'fb', 0.012400023407998,
	'delay', 0.0001,
	'delay2', 0.0046117477677083,
	'shift', 0,
	'shift2', 0,
	'distamp', 11.674193588235,
	'pitchlag', 1.0,
	'pitchmix', 0.86554621848739,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 2.1386455896411,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


//////////////////


(
SynthDef(\rebond, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(0.01,3,2);
	freq = freq * [1,11/14,5/9];
	sig = SinOsc.ar(freq) * LFPulse.ar(freq+( [1,2,3,4] )/lfo1);  
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop.mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \rebond,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\rebond, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var osig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(0.01,3,20);
	//freq = freq * [1,11/14,5/9];
	freq = freq * \freqtab.kr([1,11/14,5/9,1]);
	sig = SinOsc.ar(freq) * LFPulse.ar(freq+( [1,2,3,4] )/lfo1);  
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	osig = sig;
	sig1 = Splay.ar(osig, 1, amp, pan);
	sig2 = Pan2.ar(osig, pan, amp).flop.mean;
	sig = SelectX.ar(\mix.kr(0.5), [sig1, sig2]);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\ting, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = exprand(100,10000!10) * ExpRand(0.9,1.02!10);
	sig = LFSaw.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop.mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \rebond,
			 \mix, ~pmodenv.(Pseq([0,1],inf), 1.2),
			 \freqtab, Pseq([
			 	[ [1,11/14,5/9,7/17] ],
			 	[ [1,6/14,3/10,7/17] ],
			 ],inf),
			 \mix, 0.5,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Psched(4,Pbind(
			\instrument, \ting,
			\freq, 200,
			\legato, 1/2,
			\dur, 2,
			\amp, 0.081,
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \rebond,
			 \mix, ~pmodenv.(Pseq([0,1],inf), 1.2),
			 \freqtab, Pseq([
			 	[ [1,11/14,5/9,7/17] ],
			 	[ [1,6/14,3/10,7/17] ],
			 ],inf),
			 \mix, 0.5,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Psched(8,Pbind(
			\instrument, \ting,
			\freq, 200,
			\dur, 1,
			\amp, 0.081,
		)),
	])
)).play;
);


(
Pdef(\ting, 
	Pbind(
		\instrument, \ting,
		\freq, 200,
		\dur, 1,
		\amp, 0.081,
	),
);

Pdef(\rebond, 
	Pmono(
		 \rebond,
		 \mix, ~pmodenv.(Pseq([0,1],inf), 1.2),
		 \freqtab, Pseq([
			 [ [1,11/14,5/9,7/17] ],
			 [ [1,6/14,3/10,7/17] ],
		 ],inf),
		 \mix, 0.5,
		\freq, 200,
		\dur, 1,
		\amp, 0.1,
	),
);
)

Pdef(\zed).clear;
Pdef(\part).clear;
Pdef(\part).envir = ()

ClipTimeline(\suft90).edit
ClipTimeline(\suft90).eventList.print
ClipTimeline(\suft90).presetCompileString.editorInsert
(
ClipTimeline('suft90').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 2.0, \midinote: 0.0, \pattern: Pdef('rebond'), \playDur: 2.0, \relDur: 2.0, \sustain: 4.0, \type: 'pattern', )),
	PatternEvent((\absTime: 2.0, \dur: 2.0, \midinote: 1.0, \pattern: Pdef('ting'), \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, \type: 'pattern', )),
	PatternEvent((\absTime: 4.0, \dur: 0.0, \midinote: 0.0, \pattern: Pdef('rebond'), \playDur: 0.0, \relDur: 0.0, \sustain: 4.0, \type: 'pattern', )),
	PatternEvent((\absTime: 4.0, \dur: 4.0, \midinote: 1.0, \pattern: Pdef('ting'), \playDur: 4.0, \relDur: 4.0, \sustain: 2.0, \type: 'pattern', )),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



(
SynthDef(\rez, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fm=50, timeScale=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,2,1],[0.1,0.8]), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,1],[0.3,0.8]), 1, timeScale:timeScale);
	sig1 = SinOsc.ar(freq*[1,1.001] * ( SinOsc.ar(env1*fm) * env2 + 1 ));
	sig2 = SinOsc.ar(freq * ( SinOsc.ar(env1*fm*[1,1.001]) * env2 + 1 ));
	sig3 = SinOsc.ar(freq*[1,1.001] * ( SinOsc.ar(env1*fm) * env2 + 1 ).tanh);
	sig = SelectX.ar(\mix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig =sig* amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \rez,
			\mix, ~pmodenv.(Pseq([0,1,0.2],inf), 3),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\note, Pseq([
				10,0,3,2
			],inf),
			\fm, 50,
			\dur, 1/2,
			\amp, 0.1,
		),	
		Pbind(
			\instrument, \rez,
			\mix, ~pmodenv.(Pseq([0,1,0.2],inf), 1.3),
			\timeScale, Pwhite(1.1,4),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.4) ],
			],inf),
			\note, Pseq([
				10,12,3,2
			],inf),
			\fm, Pkey(\freq),
			\dur, 2,
			\amp, 0.1,
		),	
		Pbind(
			\instrument, \rez,
			\mix, ~pmodenv.(Pseq([0,1,0.2],inf), 1.3),
			\timeScale, Pwhite(1.1,4),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.4) ],
			],inf),
			\note, Pseq([
				10,12,3,2
			],inf)+Pseq([3,3,2,2,4],inf),
			\lag, Pwhite(0.01,0.1),
			\fm, Pkey(\freq),
			\dur, 2,
			\amp, 0.1,
		),	
	])
)).play;
);

~master.()

//////////////////

ClipTimeline(\suft90).edit
ClipTimeline(\suft90).clear
ClipTimeline(\suft90).presetCompileString.editorInsert
(
ClipTimeline('suft90').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0, \label: 'start', \playDur: 0, \relDur: 0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0, \dur: 1, \midinote: 0, \playDur: 1, \relDur: 1, \sustain: 4.6040871610001, \timeline: { ProtoTemplateDef(\SampleTimeline).new('rec_suft90_190512_022540') }, \type: 'pattern', )),
	(\absTime: 1, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);
ProtoTemplateDef(\SampleTimeline).new('rec_suft90_190512_022540').buffer
BufDef('/tmp/rec_suft90_190512_022540.wav')
