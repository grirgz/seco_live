
// idée pour le clip https://www.youtube.com/watch?v=VvdOe10vrs4
(
	~t = 147/4/60; TempoClock.default.tempo = ~t;
	~swing = 0.36;
ProtoDef(\rdn, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
ProtoDef(\rdn4, ProtoTemplateDef(\rdn));
~master = {
//	ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	ProtoDef(\rdn4).play;
};
);



(
[\rdn, \rdn2, \rdn3, \rdn4].collect({ arg key;
	ProtoDef(key).presetCompileString;
}).join("\n\n").editorInsert
)

(
ProtoDef('rdn').make('deldefault', 'rdn', "5-Q22R-N3NP", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.54327130178234,
	'gain', 1.1138893662396,
	'fb', 0.00,
	'delay', 0.00010394574653723,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 79.279273894506,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 306.12862811127,
	'hpf', 17,
	'fbdistamp', 4.1822132443647,
	'fbdistmix', 0.91176470588235,
	'postlpf', 7900.7560271333,
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


ProtoDef('rdn2').make('deldefault', 'rdn2', "4-7B4T-9VJ5", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.51611149132281,
	'gain', 0.22718087316559,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 19.121088211933,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 209.91254738447,
	'fbdistamp', 2.0063147804941,
	'fbdistmix', 0.97899159663866,
	'postlpf', 17000,
	'posthpf', 1097.8064901843,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));


ProtoDef('rdn3').make('deldefault', 'rdn3', "4-4G3K-4U33", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0052997797722,
	'gain', 0.27891039806981,
	'fb', 0.019624385968609,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0,
	'distamp', 100.0,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.65607499380699,
	'fbdistmix', 1.0,
	'postlpf', 20000.0,
	'posthpf', 922.34955354165,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 0.3424188360028,
).keep(1));


ProtoDef('rdn4').make('deldefault', 'rdn4', "5-I4NN-MBJI", BusDef(\sendbus4));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.60195390291997,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 22.107407427431,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.042086646959393,
	'fbdistmix', 0.96638655462185,
	'postlpf', 17298.354205213,
	'posthpf', 20.0,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



(
SynthDef(\tredrone2, { arg lagf=0, freq=200, pan=0, amp=0.1, out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(lagf);
	freq = freq * [1, 5/3];
	sig = LFPulse.ar(freq * ( 1 + ( CuspL.ar(\cusfreq.kr(10) + [1,2,3],\cus2.kr(1.1),\cus3.kr(1)).lag(0.1) * ( CuspL.ar(0.1)/3 + 0.1+[ [0,0.01] ] ) * \fma.kr(1) ))).mean;
	sig.debug("kjkj");
	sig = sig /13;
	sig1 = sig;
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq.lag(1) * SinOsc.kr(1*~t * [1,3/5]).range(0,1) ).clip(20,19990), \rq.kr(0.5));
	sig = sig + BPF.ar(sig1, freq.lag(1) * 8);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\otherbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, harmsubamp=0.2,harmmainamp=1, harmdetuneamp=1, harmoveramp=0.2, detunediff=0.001;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1/2,1,1+detunediff,2];
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]) * [harmsubamp,harmmainamp,harmdetuneamp,harmoveramp];
	sig = sig.mean;
	sig = RLPF.ar(sig, \lpf.kr(2100), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\basicpad2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	env2 = Duty.ar(1/freq/2/~t, 0, Dseq([
		1,2,1,1,2,1/2,2,2,4
	],inf));
	env3 = EnvGen.kr(\lpenv3.kr(Env([0,1,0],[1.1,4.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[0.1,4.8])), 1);
	sig2 = LPF.ar(sig2, ( \lpf.kr(8000) * env1 ).clip(20,19990));
	sig3 = SinOsc.ar(freq * [1,( 1 )+\det.kr] * (1+ ( env2 * env3 * 0.01 )) * ( SinOsc.ar(( freq * env2 )+\det.kr) * 0.1 + 1 ));
	sig = [sig1, sig2, sig3].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);

////////////////////////////////////////////////
// CONTROL
(
Pdef(\chord1, Pbind(
	\instrument, \tredrone,
	\legato, 1,
	\cus3, Pwhite(0.01,10),
	\fma, 0.001 * Pseq([1,2,3,6],inf),
	\cus2, 1*10 * Pseq([1,2,3],inf),
	\cusfreq, Pexprand(0.1,1000),
	\lpfr, 3,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.9) ],
	],inf),
	\octave, 6,
	\dur, 1,
	\amp, 0.9
));
ProtoDef(\piano).startControl(Pdef(\chord1));
)

(
);

(
Pdef(\chord1, Pbind(
	\instrument, \basicpad2,
	\legato, 1,
	\lpf, 9000,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
	],inf),
	\octave, 6,
	\dur, 1,
	\amp, 0.1
));
ProtoDef(\piano).startControl(Pdef(\chord1));
)

NoteTimeline(\chords).edit

///////////////////////////////////////////////////
// PARTS

(
// no fx
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 
				1,0,1,0, 
				1,0,1,0, 
				1,1,1,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([0.3,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\gain, 0.3 * Pseq([1,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
		)),
		Ppar([
			Pbind(
				\instrument, \basicpad2,
				\note, Pseq([
					Plazy({
						Pseq([
						   	{ (0..18).choose }!10 ,
						   	{ (0..18).choose }!10 ,
						],8)
					})
					
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.3,0.1,0.8,0.7) ],
				],inf),
				\octave, 6,
				\legato, 1,
				\dur, 2,
				\amp, 0.1,
			).trace,
		]),

		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,1,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([0.3,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\gain, 0.3 * Pseq([1,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		Ppar([
			Pbind(
				\instrument, \basicpad2,
				\note, Pseq([
					Plazy({
						Pseq([
						   	{ (0..18).choose }!10 ,
						   	{ (0..18).choose }!10 ,
						],8)
					})
					
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.3,0.1,0.8,0.7) ],
				],inf),
				\octave, 6,
				\legato, 1,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			).trace,
		]),
		Pbind(
			\instrument, \otherbass,
			\note, 0,
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),

		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\gain, Pkey(\gain) * Pseq([
				1,1,Pwhite(0.1,1,2), 1,1,1,Pwhite(0.1,1,1),
			],inf),
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
			\out, BusDef(\snarebus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snarebus, \audio),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus1, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,0,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,1,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([0.3,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\gain, 0.3 * Pseq([1,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		Ppar([
			Pbind(
				\instrument, \basicpad2,
				\note, Pseq([
					Plazy({
						Pseq([
						   	{ (0..18).choose }!10 ,
						   	{ (0..18).choose }!10 ,
						],8)
					})
					
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.3,0.1,0.8,0.7) ],
				],inf),
				\octave, 6,
				\legato, 1,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
				\isRest, true,
			),
			Pbind(
				\instrument, \basicpad2,
				\note, Pseq([
					Pseq([
						[0,1,4,7,8],
						[4,5,8],
					],8),
					Pseq([
						[0,1,4,8,9],
						[4,5,9],
					],8),
				],inf)+5,
				\adsr, Pseq([
					[ Env.adsr(0.03,0.1,0.8,0.9) ],
				],inf),
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,1, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,1,1,0,
				],inf).coin.not,
				\octave, 6,
				\legato, 0.1,
				\dur, 1/4,
				\swing, (1 + (~swing * Pseq([1,-1],inf))),
				\dur, 1/8 * Pkey(\swing),
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
		]),
		Pbind(
			\instrument, \otherbass,
			\note, Pseq([
				0,-2,2,1,
			],inf).stutter(4),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/vorster.flac'),
			\pos, Pseq([0,0.3,0.20,0.5, 1,2,1.1,2.2],inf)+Pseq([0,1,2.4,5],inf).stutter(8),
			\pos, Pseq([
				Pseq((0..40)).stutter(1)
			],inf),
			\legato, 1,
			\isRest, Pseq([
				1,0, 1,0, 1,1, 0,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 0,0, 1,1,
			],inf).coin.not,
			\dur, 1/2,
			\gain, 1/2,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/vorster.flac'),
			\pos, Pseq([0,0.3,0.20,0.5, 1,2,1.1,2.2],inf)+Pseq([0,1,2.4,5],inf).stutter(8),
			\pos, Pseq([
				Pseq((0..40)).stutter(1)
			],inf),
			\legato, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/2,
			\out, BusDef(\sendbus3, \audio),
		),

		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\gain, Pkey(\gain) * Pseq([
				1,1,Pwhite(0.1,1,2), 1,1,1,Pwhite(0.1,1,1),
			],inf),
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
			\out, BusDef(\snarebus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snarebus, \audio),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus1, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,0,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,1,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([0.3,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\gain, 0.3 * Pseq([1,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		Ppar([
			Pbind(
				\instrument, \basicpad2,
				\note, Pseq([
					Plazy({
						Pseq([
						   	{ (0..18).choose }!10 ,
						   	{ (0..18).choose }!10 ,
						],8)
					})
					
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.3,0.1,0.8,0.7) ],
				],inf),
				\octave, 6,
				\legato, 1,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
				\isRest, true,
			),
			Pbind(
				\instrument, \basicpad2,
				\note, Pseq([
					Pseq([
						[0,1,4,7,8],
						[4,5,8],
					],8),
					Pseq([
						[0,1,4,8,9],
						[4,5,9],
					],8),
				],inf)+5,
				\adsr, Pseq([
					[ Env.adsr(0.03,0.1,0.8,0.4) ],
				],inf),
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,1,1, 1,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,1, 1,1,1,0,
				],inf).coin.not,
				\octave, 6,
				\legato, 0.1,
				\dur, 1/4,
				\swing, (1 + (~swing * Pseq([1,-1],inf))),
				\dur, 1/8 * Pkey(\swing),
				\amp, 0.4,
				\out, BusDef(\sendbus3, \audio),
			),
		]),
		Pbind(
			\instrument, \otherbass,
			\note, Pstep(Pseq([
				0,-2,2,1,
			],inf),4),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,0,0,0.8,
				1,0,0,0, 0,0,0.1,0,
				2,0,2,0, 1,0,0,0,
				8,0,0,0, 0,0,0,0,

				4,0,0,0, 0,0,0,0.8,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 2,0,0,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/vorster.flac'),
			\pos, Pseq([0,0.3,0.20,0.5, 1,2,1.1,2.2],inf)+Pseq([0,1,2.4,5],inf).stutter(8),
			\pos, Pseq([
				Pseq((0..40)).stutter(1)
			],inf),
			\legato, 1,
			\isRest, Pseq([
				1,0, 1,0, 1,1, 0,0,
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,0, 0,0, 1,1,
			],inf).coin.not,
			\dur, 1/2,
			\gain, 1/1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/vorster.flac'),
			\pos, Pseq([0,0.3,0.20,0.5, 1,2,1.1,2.2],inf)+Pseq([0,1,2.4,5],inf).stutter(8),
			\pos, Pseq([
				Pseq((0..40)).stutter(1)
			],inf),
			\legato, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/1,
			\out, BusDef(\sendbus3, \audio),
		),

		
	])
)).play;
);


BufDef(\rah, "cliprec/rec_recme_t1_190729_235532.wav")
BufDef.relpath_to_abspath("rec_recme_t1_190729_235532.wav")
BufDef.clear(\bla2)
BufDef.paths
BufferPool.release("cliprec/rec_recme_t0_190729_235532.flac"	)
SampleTimeline('rec_recme_t0_190729_235532', "cliprec/rec_recme_t0_190729_235532.flac")
SampleTimeline('rec_recme_t0_190729_235532')[\init].asCompileString
SampleTimeline('rec_recme_t0_190729_235532').clear

(
SampleTimeline('rec_recme_t0_190729_235532', 'rec_recme_t0_190729_235532.wav');
SampleTimeline('rec_recme_t1_190729_235532', 'rec_recme_t1_190729_235532.wav');
SampleTimeline('rec_recme_t2_190729_235532', 'rec_recme_t2_190729_235532.wav');
SampleTimeline('rec_recme_t3_190729_235532', 'rec_recme_t3_190729_235532.wav');
)

ClipTimeline(\recme).presetCompileString.editorInsert
(
ClipTimeline('recme').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': 42, 'muted': false ), ( 'index': 1, 'recordArmed': true, 'recordBus': 48, 'muted': false ), ( 'index': 2, 'recordArmed': true, 'recordBus': 54, 'muted': false ), ( 'index': 3, 'recordArmed': true, 'recordBus': 60, 'muted': false ) ];
ClipTimeline('recme').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 53.0, \label: 'start', \playDur: 53.0, \relDur: 53.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 53.0, \dur: 43.0, \midinote: 3.0, \playDur: 43.0, \relDur: 43.0, \sustain: 74.0, \timeline: { SampleTimeline('rec_recme_t0_190729_234702') }, \type: 'pattern', )),
	(\absTime: 96.0, \dur: 135.0, \label: 'end', \playDur: 135.0, \relDur: 135.0, \type: 'end', ),
	PatternEvent((\absTime: 231.0, \dur: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 320.0, \timeline: { SampleTimeline('rec_recme_t0_190729_235532') }, \type: 'pattern', )),
	PatternEvent((\absTime: 231.0, \dur: 0.0, \midinote: 1, \playDur: 0.0, \relDur: 0.0, \sustain: 320.0, \timeline: { SampleTimeline('rec_recme_t1_190729_235532') }, \type: 'pattern', )),
	PatternEvent((\absTime: 231.0, \dur: 0.0, \midinote: 2, \playDur: 0.0, \relDur: 0.0, \sustain: 320.0, \timeline: { SampleTimeline('rec_recme_t2_190729_235532') }, \type: 'pattern', )),
	PatternEvent((\absTime: 231.0, \dur: 0, \midinote: 3.0, \playDur: 0, \relDur: 0, \sustain: 320.0, \timeline: { SampleTimeline('rec_recme_t3_190729_235532') }, \type: 'pattern', )),
]);
);

ClipTimeline(\recme).edit
ClipTimeline(\recme2).edit
ProtoDef(\simpleMixer).edit


/////////

13/5
8/3

(
SynthDef(\fmbell2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	env1 = EnvGen.kr(Env([0,1,0],[0.01,1.1]), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.3]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * env1 + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1);
	sig3 = SinOsc.ar(freq * (10/3 -0.00122) * sig1 + 2.04) * env2;
	sig4 = LFCub.ar(freq * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig3 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0,1,2.1,1,-1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0], amp).sum;
	Out.ar(out, sig);
}).add;
)

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\gain, Pkey(\gain) * Pseq([
				1,1,Pwhite(0.1,1,2), 1,1,1,Pwhite(0.1,1,1),
			],inf),
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
			\out, BusDef(\snarebus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snarebus, \audio),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus1, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,1, 
				1,0,1,1, 1,0,1,0, 

				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,1,1,1, 
				0,0,0,0, 0,0,1,0, 

				1,1,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,0,1,0, 1,1,1,1, 

				1,1,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,0,0, 
				0,0,1,0, 0,1,1,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([0.3,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\gain, 0.3 * Pseq([1,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \fmbell2,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1) + [0, 12],
			\decay, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				2,0,0,0.20, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\decay] <= 0 }),
			\adsr, Pseq([
				Pfunc  { arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\decay]) ];
				}
			],inf),
			\legato, 0.1,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \otherbass,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1),
			\lpf, 5000,
			\octave, 2,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,

				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\gain, Pkey(\gain) * Pseq([
				1,1,Pwhite(0.1,1,2), 1,1,1,Pwhite(0.1,1,1),
			],inf),
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
			\out, BusDef(\snarebus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snarebus, \audio),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus1, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,

				1,1,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,0,0, 
				0,0,1,0, 0,1,1,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([0.3,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\gain, 0.3 * Pseq([1,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \fmbell2,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1),
			\decay, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				2,0,0,0.20, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\decay] <= 0 }),
			\adsr, Pseq([
				Pfunc  { arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\decay]) ];
				}
			],inf),
			\legato, 0.1,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \fmbell2,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1) + Ptuple([12,12+Pseq([0,1,2]+6,inf)]) + Pseq([8,5,3,0, 4,3,2,0]*2,inf),
			\decay, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,1,1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\decay] <= 0 }),
			\adsr, Pseq([
				Pfunc  { arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\decay]) ];
				}
			],inf),
			\legato, 0.1,
			\swing, (1 + (~swing * Pseq([1,-1],inf).stutter(2))),
			\dur, 1/16 * Pkey(\swing),
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \otherbass,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1),
			\lpf, 5000,
			\octave, 2,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,

				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

(
ProtoDef('rdn').make('deldefault', 'rdn', "5-Q22R-N3NP", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.54327130178234,
	'gain', 1.1138893662396,
	'fb', 0.0081407308714432,
	'delay', 0.00010394574653723,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 79.279273894506,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 306.12862811127,
	'hpf', 17,
	'fbdistamp', 4.1822132443647,
	'fbdistmix', 0.91176470588235,
	'postlpf', 7900.7560271333,
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


ProtoDef('rdn2').make('deldefault', 'rdn2', "4-7B4T-9VJ5", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.51611149132281,
	'gain', 0.22718087316559,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 19.121088211933,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 209.91254738447,
	'fbdistamp', 2.0063147804941,
	'fbdistmix', 0.97899159663866,
	'postlpf', 17000,
	'posthpf', 1097.8064901843,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));


ProtoDef('rdn3').make('deldefault', 'rdn3', "4-4G3K-4U33", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0052997797722,
	'gain', 0.27891039806981,
	'fb', 0.019624385968609,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0,
	'distamp', 100.0,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.65607499380699,
	'fbdistmix', 1.0,
	'postlpf', 20000.0,
	'posthpf', 922.34955354165,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 0.3424188360028,
).keep(1));


ProtoDef('rdn4').make('deldefault', 'rdn4', "5-I4NN-MBJI", BusDef(\sendbus4));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.60195390291997,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 22.107407427431,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.042086646959393,
	'fbdistmix', 0.96638655462185,
	'postlpf', 17298.354205213,
	'posthpf', 20.0,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);




(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\gain, Pkey(\gain) * Pseq([
				1,1,Pwhite(0.1,1,2), 1,1,1,Pwhite(0.1,1,1),
			],inf),
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus1, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],6),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.5,
			\dur, 1/8,
			\out, BusDef(\snarebus, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snarebus, \audio),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus1, \audio, 2),
			\send1, 1,
			\sendbus1, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,

				1,1,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,0,0, 
				0,0,1,0, 0,1,1,1, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2 * Pseq([0.3,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 13,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\gain, 0.3 * Pseq([1,0.3,1,0.3],inf),
			\dur, 1/8,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \fmbell2,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1),
			\decay, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
				2,0,0,0.20, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\decay] <= 0 }),
			\adsr, Pseq([
				Pfunc  { arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\decay]) ];
				}
			],inf),
			\legato, 0.1,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \fmbell2,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1) + Ptuple([12,12+Pseq([0,1,2]+6,inf)]) + Pseq([8,5,3,0, 4,3,2,0]*2,inf),
			\decay, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,1,1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\decay] <= 0 }),
			\adsr, Pseq([
				Pfunc  { arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\decay]) ];
				}
			],inf),
			\legato, 0.1,
			\swing, (1 + (~swing * Pseq([1,-1],inf).stutter(2))),
			\dur, 1/16 * Pkey(\swing),
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \otherbass,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1),
			\lpf, 5000,
			\octave, 2,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,

				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);


(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('./rec_recme_t0_190729_235532.wav'),
				\pos, 
				Pseq([
					Pseq([
						Pseq((0..7),1)+64/~t,
					],3),
					Pser([Rest()],8)
				],inf),
				\legato, 1,
				\dur, 1,
				\gain, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('./rec_recme_t1_190729_235532.wav'),
				\pos, Pseq([
					//Pseq([0],8)+5/~t,
					Pseq([
						Pseq((0..7),1).stutter(2)+54/~t,
					],3),
					Pser([Rest()],8)
				],inf),
				\speed, 1.3,
				\legato, Pseq([1,0.31,1,0.5],inf).stutter(4),
				\dur, 2 * PdurStutter(Pseq([4,2,2],inf), 1/2),
				\gain, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('./rec_recme_t2_190729_235532.wav'),
				\pos, 
				Pseq([
					//Pseq([0],8)+5/~t,
					Pseq([
						Pseq((0..7),1).stutter(2)+64/~t,
					],3),
					Pser([Rest()],16)
				],inf),
				\speed, 1.3,
				\legato, Pseq([1,1,1,0.9],inf),
				\dur, 1/2 * PdurStutter(Pseq([1,4],inf), 1/2),
				\gain, 1,
			),
		]),
		Pbind(
			\instrument, \otherbass,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1),
			\lpf, 5000,
			\octave, 2,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,

				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\lag, 0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('./rec_recme_t0_190729_235532.wav'),
				\pos, 
				Pseq([
					Pseq([
						Pseq((0..7),1)+64/~t,
					],3),
					Pser([Rest()],8)
				],inf),
				\legato, 1,
				\dur, 1,
				\gain, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('./rec_recme_t1_190729_235532.wav'),
				\pos, Pseq([
					//Pseq([0],8)+5/~t,
					Pseq([
						Pseq((0..7),1).stutter(2)+54/~t,
					],3),
					Pser([Rest()],8)
				],inf),
				\speed, 1.3,
				\legato, Pseq([1,0.31,1,0.5],inf).stutter(4),
				\dur, 2 * PdurStutter(Pseq([4,2,2],inf), 1/2),
				\gain, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('./rec_recme_t2_190729_235532.wav'),
				\pos, 
				Pseq([
					//Pseq([0],8)+5/~t,
					Pseq([
						Pseq((0..7),1).stutter(2)+64/~t,
					],3),
					Pser([Rest()],16)
				],inf),
				\speed, 1.3,
				\legato, Pseq([1,1,1,0.9],inf),
				\dur, 1/2 * PdurStutter(Pseq([1,4],inf), 1/2),
				\gain, 1,
			),
		]),
		Pbind(
			\instrument, \otherbass,
			\note, Pstep(Pseq([
				1,0,3,2,
			],inf),1),
			\lpf, 5000,
			\octave, 2,
			\swing, (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8 * Pkey(\swing),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,

				4,0,0,0, 0,0,0,0.8,
				0,0,0,0, 0,0,0,0.8,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);


//////////////////////////


(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
);
Ndef(\soundin).play(0,2)
ProtoDef(\rdn).edit

ClipTimeline(\ret).edit
SampleTimeline(\hihi)
BufDef('./rec_recme_t1_190729_235532.wav')
BufDef.paths
