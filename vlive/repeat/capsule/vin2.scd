
Pdef.defaultQuant 

// demo
(
~t = 160/4/60; TempoClock.default.tempo = ~t;
Pdef(\part, Pdef(\zed, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (Pseq([0,1,2,3]+8+4,inf)/2/~t),
			\legato, 1,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);
//////////////////////////////////////// init

(
Pdef.defaultQuant = 1/4;
~t = 160/4/60; TempoClock.default.tempo = ~t;
ProtoDef(\rdn, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
ProtoDef(\rdn4, ProtoTemplateDef(\rdn));
~master = {
	ProtoDef(\simpleMixer).play;
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	ProtoDef(\rdn4).play;
};
BufDef(\distreg, "/home/ggz/Musique/sc/cliprec/rec_myrec_190707_190759.wav")
);
SampleTimeline('bigbass').edit
(
SampleTimeline('bigbass').eventList = XEventList.newFrom([
	(\absTime: 0.25, \dur: 52.0, \label: 'start', \playDur: 52.0, \relDur: 52.0, \sustain: 0, \type: 'start', ),
	(\absTime: 52.25, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('bigbass').buffer = BufDef('/home/ggz/Musique/sc/cliprec/rec_bigbass_190713_171701.wav');
);

(
SampleTimeline('rec_perc_t3_190717_194430').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 76.0, \label: 'start', \playDur: 76.0, \relDur: 76.0, \sustain: 0, \type: 'start', ),
	(\absTime: 76.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_perc_t3_190717_194430').buffer = BufDef('/home/ggz/Musique/sc/cliprec/rec_perc_t3_190717_194430.wav');
BufDef(\distkick, "/home/ggz/Musique/sc/cliprec/rec_perc_t3_190717_194430.wav");
);

(
SampleTimeline('rec_perc2_t1_190717_200249').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 120.0, \label: 'start', \playDur: 120.0, \relDur: 120.0, \sustain: 0, \type: 'start', ),
	(\absTime: 120.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_perc2_t1_190717_200249').buffer = BufDef('/home/ggz/Musique/sc/cliprec/rec_perc2_t1_190717_200249.wav');
);

(
SampleTimeline('rec_perc2_t2_190717_200249').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 120.0, \label: 'start', \playDur: 120.0, \relDur: 120.0, \sustain: 0, \type: 'start', ),
	(\absTime: 120.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_perc2_t2_190717_200249').buffer = BufDef('/home/ggz/Musique/sc/cliprec/rec_perc2_t2_190717_200249.wav');
);

(
BufDef(\distreg, "/home/ggz/Musique/sc/cliprec/rec_myrec_190707_190759.wav");
SampleTimeline('distreg').eventList = XEventList.newFrom([
	(\absTime: (3/16), \dur: 56.0, \label: 'start', \playDur: 80.0, \relDur: 56.0, \sustain: 0, \type: 'start', ),
	(\absTime: 56.0+(3/16), \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('distreg').buffer = BufDef('distreg');
);

//ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-PP1J-O13N", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.60195390291997,
	'gain', 1.0052997797722,
	'fb', 0.0023034886393382,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 22.107407427431,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 4.1822132443647,
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

//ProtoDef('rdn2').presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "4-FIE4-14SA", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.19478345215597,
	'gain', 0.77791010151461,
	'fb', 0.00010389974084947,
	'delay', 0.00015910384392722,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 16.538167833957,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 209.91254738447,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

//ProtoDef('rdn3').presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "4-QGK1-39O7", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.46579739809918,
	'fb', 0.00010795156148588,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 41.8647728829,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 78.246869344565,
	'fbdistamp', 0.65607499380699,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 895.96387598272,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



//ProtoDef('rdn4').presetCompileString.editorInsert
(
ProtoDef('rdn4').make('deldefault', 'rdn4', "4-QJRF-O0H8", BusDef(\sendbus4));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.2391360215375,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001416643274669,
	'shift', 0,
	'shift2', 0,
	'distamp', 22.107407427431,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 124.49377687991,
	'fbdistamp', 0.042086646959393,
	'fbdistmix', 0.0,
	'postlpf', 17298.354205213,
	'posthpf', 386.13954577665,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
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
);

//////////////////////////////////////////////////
////////////////// parts

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (Pseq((0..15),inf)/8+4/~t),
			\legato, 1,
			\legato, Pseq([
				2,0,1,0, 2,0,1,0,
				1,1,1/2,2, 0,0,1/2,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				3,6,6,6,
			],inf).stutter(4),
			\legato, Pseq([
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				1,0,0,1, 0,0,1,1,
			],inf),
			\lpf, 4000,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			//\lag, 0.04,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);






//////////////

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \otherbass,
			\note, Pseq([
				0,
			],inf),
			\detunediff, 0.00001,
			\oscmix, 0,
			\harmsubamp, 1/2,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				],8),

			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (Pseq((0..15),inf)/8+4/~t),
			\legato, 1,
			\legato, Pseq([
				2,0,1,0, 2,0,1,0,
				1,1,1/2,2, 0,0,1/2,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \otherbass,
			\note, Pseq([
				3,6,6,6,
			],inf).stutter(4),
			\detunediff, 0.1,
			\legato, Pseq([
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				1,0,0,1, 0,0,1,1,
			],inf),
			\lpf, 4000,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			//\lag, 0.04,
			\dur, 1/4,
			\amp, 0.1,
			\detunediff, 0.00001,
			\oscmix, 0,
			\harmsubamp, 1,
			\harmmainamp, 0.5,
			\harmoveramp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				],8),

			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
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
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (Pseq((0..15),inf)/8+4/~t),
			\legato, 1,
			\legato, Pseq([
				2,0,1,0, 2,0,1,0,
				1,1,1/2,2, 0,0,1/2,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \otherbass,
			\note, Pseq([
				5,3, 5,6, 6,6, 5,6
			],inf).stutter(4),
			\detunediff, 0.1,
			\legato, Pseq([
				3,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,1/2,
				1,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,1/2,0,
				2,0,0,0, 0,0,1,0,
				1,0,0,1, 0,1/2,0,1/2,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1/2,1/2,1/2,
			],inf),
			\lpf, 4000,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			//\lag, 0.04,
			\dur, 1/8,
			\amp, 0.1,
			\detunediff, 0.00001,
			\oscmix, 0,
			\harmsubamp, 1,
			\harmmainamp, 0.5,
			\harmoveramp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				],8),

			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
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
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([4,0,4,5, 4,2,4,3]+3,1)/16+1,
					Pseq([1,1,2,5, 11,12,13,14]+3,1)/16+1,
					Pseq([4,0,4,5, 4,2,4,3]+3,1)/16+1,
					Pseq([1,1,2,5, 11,12,13,14]+6,1)/16+1,
					//Pseq([4,4,4,4, 4,3,2,1]+1,1)/8+1,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,0,0,0, 1,0,1,0,
				0,1,1,1, 1,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16 * (1 + (0.10 * Pseq([1,-1],inf))),
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,

					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,

					1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,

					0,0,1,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				],8),

			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
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
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				Pseq([
					Pseq((0..15))/8+3
					//Pseq([4,4,4,4, 4,3,2,1]+1,1)/8+1,
				],inf) /~t
			),
			\legato, 1,
			\speed, 1,
			\legato, Pseq([
				1,0,0,0, 1,0,0,0,
				2,0,1,0, 0,0,1,0,
				2,0,0,0, 0,0,2,0,
				0,0,0,0, 2,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8 * (1 + (0.10 * Pseq([1,-1],inf))),
			\gain, 1/3,
			\lag, 0.04,
			//\out, BusDef(\sendbus3, \audio),
		),
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				Pseq([
					Pseq([4,0,4,5, 4,2,4,3]+3,1)/16+1,
					Pseq([1,1,2,5, 11,12,13,14]+3,1)/16+1,
					Pseq([4,0,4,5, 4,2,4,3]+3,1)/16+1,
					Pseq([1,1,2,5, 11,12,13,14]+6,1)/16+1,
					//Pseq([4,4,4,4, 4,3,2,1]+1,1)/8+1,
				],inf) /~t
			),
			\legato, 1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				1,0,1,1, 1,0,1,0,
				0,1,1,1, 1,0,1,0,

				0,0,0,0, 4,0,0,0,
				0,0,0,0, 4,0,0,0,
				4,0,0,0, 0,0,1,0,
				0,1,1,1, 1,0,1,0,

				4,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,1,1,


				2,0,1,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,1,1,

				0,1,0,0, 4,0,0,0,
				0,0,1,0, 4,0,0,0,
				1,1,0,1, 1,0,1,0,
				0,1,1,1, 1,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16 * (1 + (0.10 * Pseq([1,-1],inf))),
			\gain, 1/6,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);


//////////////////////



(
Pdef(\zed, 
	Ppar([
	]),
).play;
);

(
Pdef(\part, Pdef(\zed, 
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
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
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
		]),
		Pbind(\out, BusDef(\delay, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\pos, 3.67 + (
					Pseq([
						Pseq([
							0,0,0,0, 1,1,0,1,
							0,0,0,0, 8,1,0,1,
							3,2,0,1, 4,4,4,5,
							3,2,0,1, 4,4,4,5,
						]+6,1)/16+0,
						//Pseq([4,4,4,4, 4,3,2,1]+1,1)/8+1,
					],inf) /~t
				),
				\legato, 1,
				\legato, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
			
					1,0,1,0, 0,0,0,0,
					0,0,1,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/16 * (1 + (0.10 * Pseq([1,-1],inf))),
				\gain, 1/6,
				//\lag, 0.04,
				//\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\bufnum, BufDef('voices/kaspi.flac'),
				\pos, 3.67 + (
					Pseq([
						Pseq([
							0,0,0,0, 1,1,0,1,
							0,0,0,0, 8,1,0,1,
							3,2,0,1, 4,4,4,5,
							3,2,0,1, 4,4,4,5,
						]+6,1)/16+1,
						//Pseq([4,4,4,4, 4,3,2,1]+1,1)/8+1,
					],inf) /~t
				),
				\legato, 1,
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					4,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0,
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/16 * (1 + (0.10 * Pseq([1,-1],inf))),
				\gain, 1/6,
				//\lag, 0.04,
				//\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\bufnum, BufDef('voices/kaspi.flac'),
				\pos, 3.67 + (
					Pseq([
						Pseq([
							0,0,0,0, 1,1,0,1,
							0,0,0,0, 8,1,0,1,
							3,2,0,1, 4,4,4,5,
							3,2,0,1, 4,4,4,5,
						]+6,1)/16+3,
						//Pseq([4,4,4,4, 4,3,2,1]+1,1)/8+1,
					],inf) /~t
				),
				\speed, Pseq([
					Pseq((1..8).reverse/2),
					Pseq([
						1,
					],8),
				],inf),
				\speed, ~pmodenv.(Pseq([2,1,1],1), Pn(1/8,1)).loop,
				\legato, 1,
				\legato, Pseq([
					Pseq([
						0
					],16+8+16),
					1,1,1,1, 1,1,1,1,
					8,0,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/16 * (1 + (0.10 * Pseq([1,-1],inf))),
				\gain, 1/6,
				//\lag, 0.04,
				//\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,0,0,-3,
				],inf).stutter(2),
				\root, 5,
				\legato, Pseq([
					4,0,0,0, 0,0,0,1,
					2,0,0,0, 1,0,1,1,
					2,0,2,0, 2,0,2,0,
					2,0,0,0, 1,1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\lpf, 1000,
				\octave, 3,
				\dur, 1/4,
				\amp, 0.1,
			),
		]),
		Pmono(\fx_delay,
			\inbus, BusDef(\delay, \audio),
			\out, BusDef(\comp, \audio),
			\addAction, \addToTail,
			\lag, 0.0003,
			\delay, 0.04,
			\mix, 1,
			\dur, 1,
		),

		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\pregain, 1,
			\cpt, 0.05,
			\cpbelow, 1.0,
			\cpabove, 0.29,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\mix, 1,
			\gain, 2,
			\dur, 1,
			//\out, BusDef(\delay, \audio),
		),

		
	])
)).play;
);

Pdef(\part).clear;


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1.5,
			\pos, Pseq([
				Prand((1..8)/8)
			],inf),
			\dur, 1/2+Prand([1/4,1/8,1/16],inf),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1.5,
			\pos, Pseq([
				Prand((1..8)/8)
			],inf),
			\dur, 1/2+Prand([1/4,1/8,1/16],inf),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1.5,
			\pos, Pseq([
				Prand((1..8)/8)
			],inf),
			\dur, 1/2+Prand([1/4,1/8,1/16],inf),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			\speed, 0.9,
			\pos, 3.67 + (
				Pseq([
					8 + Pseq([1,2,3,5]/3,3).stutter(8),
					2 + Pseq([0,1,2,3]/4+1,1).stutter(8),
				],inf)
			),
			\legato, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			//\speed, ~pmodenv.(Pseq([1,1.02,1,0.91,1,2,1/2],inf).stutter(2), Prand([0.1,1],inf)),
			\legato, 1,
			\speed, 1,
			\pos, 3.67 + (
				6 + ( Pseq([3,6,9],inf).stutter(4)/8 ) + 0.05
			),
			\legato, Pseq([
				0,0,1,0, 1,0,2,0,
				0,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,2,0,
				0,0,2,0, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				0,0,2,0, 0,0,1,0,
			],inf),
			\adsr, Prand([
				[ Env.adsr(0.02,0.1,0.8,0.4) ],
				[ Env.adsr(0.2,0.1,0.8,0.04) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),

		
	])
)).play;
);



/////////////////////////////////

(
NoteTimeline('vin2').eventList = XEventList.newFrom([
	(\absTime: 1.125, \dur: 0.375, \midinote: 95.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.375, \midinote: 87.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 75.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	(\absTime: 2.25, \dur: 0.375, \midinote: 62.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 2.625, \dur: 0.125, \midinote: 51.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 2.75, \dur: 0.25, \midinote: 51.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.375, ),
	(\absTime: 3.0, \dur: 0.25, \midinote: 43.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.25, \dur: 0.75, \midinote: 35.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.5, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ClipTimeline





(
	~master.();
	Pdef(\part).play;
	Pdef(\part, Pdef(\percs, 
		Ppar([

			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\sendbus2, \audio),
			),

			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\velamp, 1/3,
				\dur, 1/16,
				\out, BusDef(\sendbus2, \audio),
			)),
			PatKitDef(\bat).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					0,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.4,0.1) ],
				],inf),
				\velamp, 1/5,
				\dur, 1/16,
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
				\out, BusDef(\sendbus2, \audio),
			),
		])
	));
);

/////////////////////// ///////////////////////
// resampling


SampleTimeline(\distreg).edit


(
	~master.();
Pdef(\part, Pdef(\resamp, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\distreg),
			\pos, Pseq((0..54)/2 + (3/16))+0/~t,
			\hpf, 300,
			\hpmix, 1,
			\legato, 1,
			\dur, 1/2,
			\gain, 0.8,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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
			Pdef(\part, 
				Pbind(
					\instrument, \playersec,
					//\bufnum, BufDef('voices/feynman.flac'),
					\bufnum, BufDef('vipere/lovereggae.wav'),
					\pos, 3.67 + (Pseq((0..15),inf)/8+4/~t),
					\legato, 1,
					\legato, Pseq([
						2,0,1,0, 2,0,1,0,
						1,1,1/2,2, 0,0,1/2,1/2,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\gain, 1/4,
					\out, BusDef(\sendbus1, \audio),
				),
			).play
		)

		(
		Pdef(\part, Pdef(\zed, 
			Ppar([
				
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\distreg),
			\pos, Pseq((0..54)/2 + (1/8))+10/~t,
			\legato, 1,
			\dur, 1/2,
			\gain, 1,
		),
			])
		)).play;
		);

/////////////////////// ///////////////////////
/////////////////////// ///////////////////////


// intro


(
	~master.();
Pdef(\part, Pdef(\intro_old, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (Pseq((0..15),inf)/8+4/~t),
			\legato, 1,
			\legato, Pseq([
				2,0,1,0, 2,0,1,0,
				1,1,1/2,2, 0,0,1/2,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				3,6,6,6,
			],inf).stutter(4),
			\legato, Pseq([
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				1,0,0,1, 0,0,1,1,
			],inf),
			\lpf, 4000,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			//\lag, 0.04,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				0,0,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Psched([2,4],
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
							1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
				)),
		
		),
		Psched(4, 
			Ppar([
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,1,
							1,0,1,0, 1,1,1,1,
							1,0,1,0, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,0,1,
							1,1,1,1, 1,1,1,0,
						],inf),
						1,0,1,0, 1,0,1,0,
						1,1,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,1,0,1, 1,0,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
				)),
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,1,0,1,
						0,1,0,1, 0,0,0,0,
						0,1,0,1, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.171,
					\speed, 1.01,
					\lag, 1/16/~t,
					\dur, 1/8,
				)),
			]),
		),
		Psched([3,4],
			Ppar([
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
				)),
			]),
		),
		Psched(4,
			Ppar([
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
				)),
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
				)),
			]),
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\bigbass, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				3,6,6,6,
			],inf).stutter(4),
			\legato, Pseq([
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				1,0,0,1, 0,0,1,1,
			],inf),
			\lpf, 4000,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			//\lag, 0.04,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\main, 
	Ppar([
		Psched([0,8],Pdef(\intro2)),
		Psched([8,8+64],Pdef(\resamp)),
		Psched([24,8+64],Pdef(\bigbass)),
		
	])
)).play;
)



(
	~master.();
Pdef(\part, Pdef(\intro2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				0,0,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Psched([2,4],
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
							1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
				)),
		
		),
		Psched(4, 
			Ppar([
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,1,
							1,0,1,0, 1,1,1,1,
							1,0,1,0, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,0,1,
							1,1,1,1, 1,1,1,0,
						],inf),
						1,0,1,0, 1,0,1,0,
						1,1,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,1,0,1, 1,0,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
				)),
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,1,0,1,
						0,0,0,0, 0,1,0,1,
						0,1,0,1, 0,0,0,0,
						0,1,0,1, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.171,
					\speed, 1.01,
					\lag, 1/16/~t,
					\dur, 1/8,
				)),
			]),
		),
		Psched([3,4],
			Ppar([
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\out, BusDef(\sendbus1, \audio),
				)),
			]),
		),
		Psched(4,
			Ppar([
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\out, BusDef(\sendbus1, \audio),
				)),
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\out, BusDef(\sendbus2, \audio),
				)),
			]),
		)
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\resamp2, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\distreg),
			\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0.1,
			\legato, 1,
			\dur, 1/16,
			\gain, 0.8,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
				PatKitDef(\comkit).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,1,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\out, BusDef(\sendbus1, \audio),
				)),

		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pser([
						0,0,1,2, 6,0,10,11,
						0,10,10,9, 6,0,10,11,
						0,10,9,8, 6,0,10,11,
					],32+16)/8+9,
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,0,0,0, 0,0,1,1,
				0,0,1,1, 1,1,0,0,
				1,1,1,1, 0,0,1,1,
				0,0,1,1, 1,1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/6,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\resamp3, 
	Ppar([
		Pbind(\velamp, 0.9) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\out, BusDef(\sendbus2m, \audio),
			)),
			Pmono(\simpletrackmixer,
				\addAction, \addToTail,
				\lag, 0.0005,
				\inbus, BusDef(\sendbus2m),
				\pregain, 1,
				\postgain, 0,
				\delay, 0,
				\send0, 1,
				\send1, 1,
				\sendbus0, BusDef(\sendbus2, \audio, 2),
				\sendbus1, BusDef(\sendbus1, \audio, 2),
				\dur, 1,
			),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,1,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.051,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\velamp, 0.7,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1, 1,1, 1,1, 0,0,
					0,0, 1,1, 1,1, 1,1,
					1,1, 1,1, 0,0, 1,1,
					0,0, 1,1, 1,1, 1,1,
				],inf).coin.not,
				\sustain, 0.171 * Pseq([1,0.9],inf),
				\speed, 1.01 * Pseq([1,0.98],inf),
				//\lag, 1/16/~t,
				\gain, 0.2  * Pseq([1,0.7,Pseq([1,0.4],5),1,0.8, Pseq([
					1,0.1
				],6),],inf),
				//\lag, 0.04,
				\out, BusDef(\sendbus2, \audio),
				\dur, 1/8,
			)),
		]),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\distreg),
			\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0.1,
			\legato, 1,
			\dur, 1/16,
			\gain, 0.8,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pser([
						0,0,1,2, 6,0,10,11,
						0,10,10,9, 6,0,10,11,
						0,10,9,8, 6,0,10,11,
					],32+16)/8+9,
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,0,0,0, 0,0,1,1,
				0,0,1,1, 1,1,0,0,
				1,1,1,1, 0,0,1,1,
				0,0,1,1, 1,1,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/6,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),

		
		ClipTimeline(\perc).asPattern,
		
	])
)).play;

		ClipTimeline(\perc2).startRecording;
);


ClipTimeline(\perc).edit
ClipTimeline(\perc2).edit
ClipTimeline(\perc).quant = 4
ProtoDef(\simpleMixer).edit
PatKitDef(\comkit).edit

ClipTimeline(\perc2).presetCompileString.editorInsert
(
ClipTimeline('perc2').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 54, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 48, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('perc2').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \label: 'kick', \legato: 1, \midinote: 3.0, \playDur: 0.0, \relDur: 0.0, \sustain: 117.75, \timeline: { SampleTimeline('rec_perc_t3_190717_194430') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \event_dropdur: 0.28125, \legato: 1, \midinote: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 115.0, \timeline: { SampleTimeline('distreg') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \label: 'hi', \midinote: 1.0, \playDur: 0.0, \relDur: 0.0, \sustain: 120.0, \timeline: { SampleTimeline('rec_perc2_t1_190717_200249') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 9.625, \label: 'snare', \midinote: 2.0, \playDur: 9.625, \relDur: 9.625, \sustain: 120.0, \timeline: { SampleTimeline('rec_perc2_t2_190717_200249') }, \type: 'pattern', )),
	PatternEvent((\absTime: 9.625, \dur: 0.0, \midinote: 4.0, \playDur: 0.0, \relDur: 0.0, \sustain: 120.0, \timeline: { SampleTimeline('rec_perc2_t1_190717_200249') }, \type: 'pattern', )),
	PatternEvent((\absTime: 9.625, \dur: 6.625, \midinote: 5.0, \playDur: 6.625, \relDur: 6.625, \sustain: 120.0, \timeline: { SampleTimeline('rec_perc2_t2_190717_200249') }, \type: 'pattern', )),
	PatternEvent((\absTime: 16.25, \dur: 0.0, \midinote: 4.0, \playDur: 0.0, \relDur: 0.0, \sustain: 120.0, \timeline: { SampleTimeline('rec_perc2_t1_190717_200249') }, \type: 'pattern', )),
	PatternEvent((\absTime: 16.25, \dur: 47.75, \midinote: 5.0, \playDur: 47.75, \relDur: 47.75, \sustain: 120.0, \timeline: { SampleTimeline('rec_perc2_t2_190717_200249') }, \type: 'pattern', )),
	(\absTime: 64.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

1+1
ParamProto.init(true)
SampleTimeline('rec_perc2_t2_190717_200249').clear
SampleTimeline('rec_perc2_t2_190717_200249').play
SampleTimeline('rec_perc2_t2_190717_200249').edit
SampleTimeline('rec_perc2_t1_190717_200249').edit
SampleTimeline('rec_perc_t3_190717_194430').edit
SampleTimeline('rec_perc_t3_190717_194430').play
SampleTimeline('rec_perc_t3_190717_194430').asPattern.play
SampleTimeline('rec_perc_t3_190717_194430').clear
SampleTimeline('rec_perc_t3_190717_194430').outBus

ParamProto.init(true)
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		SampleTimeline('rec_perc_t3_190717_194430').asPattern,
		Psched(16,SampleTimeline('rec_perc2_t1_190717_200249').asPattern),
		Psched(24,SampleTimeline('rec_perc2_t2_190717_200249').asPattern),
		Psched(8,SampleTimeline('distreg').asPattern),
	])
)).play;
);

///////////////////////////////////// APC

Spec.add(\mamp, ControlSpec(0,1,\lin))
(
TrackDef(\kut, TrackTemplateDef(\playergrid));
ProtoDef(\apc40).activate(TrackDef(\kut));
ProtoDef(\apc40).map_track_mixer_faders;
~params = [\delay, \delay2, \distamp, \fb, nil, nil, nil, \mamp];
ProtoDef(\apc40).map_rdn_to_bank(0, \rdn, ~params);
ProtoDef(\apc40).map_rdn_to_bank(1, \rdn2, ~params);
ProtoDef(\apc40).map_rdn_to_bank(2, \rdn3, ~params);
ProtoDef(\apc40).map_rdn_to_bank(3, \rdn4, ~params);
ProtoDef(\apc40).activate_bank_selector;
)
ProtoDef(\apc40).ktl.elAt(\bt,\scene).do({arg e, i; e.debug(i); e[\on].action = nil})
ProtoDef(\apc40).ktl.elAt(\bt,\selection).do({arg e, i; e.debug(i); })
ProtoDef(\apc40).map_quant_chooser
TrackDef(\kut).edit
TrackDef(\kut).clear

(
TrackDef(\kut).childAt(6).source = [
	Pdef(\fxperc1),
	Pdef(\randperc1),
	Pdef(\randperc2),
	Pdef(\perc2),
];
TrackDef(\kut).childAt(7).source = [
	Pdef(\distbass1),
	Pdef(\distbass2),
];
)



(
	~map_smp_channel = { arg chidx, buffer, size=64, partsize=4, offset=0, lenfac=1;

		TrackDef(\kut).childAt(chidx).children.do(_.source_(nil));
		TrackDef(\kut).childAt(chidx).source = ( size/partsize ).asInteger.collect{ arg idx;
			Pdef(\kut_+++chidx+++\_+++idx, 
				Pmono(\playersec,
					\bufnum, SampleTimeline('rec_perc_t3_190717_194430').buffer,
					\bufnum, buffer,
					\pos, idx*partsize/~t,
					\legato, 1,
					\gain, 0.5,
					\dur, Pn(1/4,4*partsize*lenfac),
					\amp, 0.1,
				).loop

			)
		};
		TrackDef(\kut).childAt(chidx).children.collect({ arg ch; ch.playMode = nil;});
	};
	Pdef.defaultQuant = 2;
	~partsize = 4;
	~lenfac = 1;
	~map_smp_channel.(0, SampleTimeline('rec_perc_t3_190717_194430').buffer, 64, ~partsize, 0, ~lenfac);
	~map_smp_channel.(1, SampleTimeline('rec_perc2_t2_190717_200249').buffer, 64, ~partsize, 0, ~lenfac);
	~map_smp_channel.(2, SampleTimeline('rec_perc2_t1_190717_200249').buffer, 96, ~partsize, 0, ~lenfac);
	~map_smp_channel.(3, SampleTimeline('distreg').buffer, SampleTimeline('distreg').loopMaster.endEventAbsTime, ~partsize, SampleTimeline('distreg').loopMaster.startEventAbsTime, ~lenfac);
	~map_smp_channel.(4, SampleTimeline('bigbass').buffer, SampleTimeline('distreg').loopMaster.endEventAbsTime, ~partsize, SampleTimeline('bigbass').loopMaster.startEventAbsTime, ~lenfac);
	~map_smp_channel.(5, SampleTimeline('rec_perc_t3_190717_194430').buffer, 64, ~partsize, 0, ~lenfac);
	ProtoDef(\apc40).refresh;
);


		TrackDef(\kut).childAt(0).children.collect({"postln;".postln;});
		TrackDef(\kut).childAt(0).children.empty
		TrackDef(\kut).childAt(0).children.first.keys
		SparseArray
		TrackDef(\kut).childAt(0,0).
		TrackDef(\kut).childAt(0,0).playNow
		TrackDef(\kut).childAt(0,0).proxy.target.play
		TrackDef(\kut).childAt(0,0).proxy.play
		TrackDef(\kut).childAt(1,0).play
		TrackDef(\kut).childAt(1,0).stop
		TrackDef(\kut).childAt(1).stop
		TrackDef(\kut).childAt(1).play
		TrackDef(\kut).childAt(0,0).source

		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('rec_perc_t3_190717_194430'),
			\pos, Pseq((0..54*16)/16)+( idx*4 )/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0,
			\legato, 1,
			\dur, 1,
			\gain, 0.8,
		),

(
Pdef(\kkk, 

		Pmono(\playersec,
					\bufnum, SampleTimeline('rec_perc_t3_190717_194430').buffer,
		\pos, 0*4/~t,
		\legato, 1,
		\dur, 1/4,
		\amp, 0.1,
		)
).play;
);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, SampleTimeline('rec_perc_t3_190717_194430').buffer,
					\pos, Pseq((0..54*16)/16 + (3/16))+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\lpf, 9300,
					\lpmix, 0,
					\legato, 1,
					\lag, 0/10,
					\dur, Pseq([ 1,1.1,0.6,0.9 ],inf) * 0.1,
					\gain, 0.8,
				);
	])
)).play;
);

//////////////////////:

(
PatKitDef(\regkit, 
	16.collect({ arg x;
			StepEvent.newFrom([
				\instrument, \playersec,
				//\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\pos, 3.67 + (( x/16 + ( 2/8 ) + 2 )/~t),
				\legato, 1,
				\dur, 1/2,
				\gain, 0.6,
			].asEvent)
	}) ++
	16.collect({ arg x;
			StepEvent.newFrom([
				\instrument, \playersec,
				//\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\pos, 3.67 + (( x/16 + ( 2/8 ) + 8 )/~t),
				\legato, 1,
				\dur, 1/2,
				\gain, 0.6,
			].asEvent)
	})
	
);
)
[\fuck, 1].asEvent

PatKitDef(\regkit).edit
PatKitDef(\comkit).edit
PatKitDef(\comkit).presetCompileString.editorInsert
(
PatKitDef(\regkit).targets = [
	StepEvent.newFrom((instrument: 'playersec', out: 0, gain: 0.22452932564887, bufnum: BufDef('com/Kick/Kick AfroShop 1.wav'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', out: 0, gain: 0.3756734311759, bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Snare/Snare Gothik 3 V1.wav'))),
	StepEvent.newFrom((gain: 0.27994635610259, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Snare/Snare Gothik 6 V2.wav'))),
	nil,
	nil,
	StepEvent.newFrom((gain: 0.1067316, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/HiHat/ClosedHH Alphabetical 1.wav'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((gain: 0.58400151705547, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/HiHat/OpenHH Gothik 3 V1.wav'))),
	StepEvent.newFrom((gain: 0.32429679021268, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/HiHat/OpenHH Gothik 3 V2.wav'))),
];
);



			(
			StepEvent([
				\instrument, \playersec,
				//\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\pos, 3.67 + (0+8+4/2/~t),
				\legato, 1,
				\dur, 1/2,
				\gain, 1,
			].asEvent.debug("klsdj----:"++0).editorInsert)
			)
			[
				\instrument, \playersec,
				//\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\pos, 3.67 + (0+8+4/2/~t),
				\legato, 1,
				\dur, 1/2,
				\gain, 1,
			].asEvent.asCompileString.editorInsert
(
StepEvent.newFrom(( 'instrument': 'playersec', 'legato': 1, 'dur': 0.5, 'gain': 1, 
  'bufnum': BufDef('vipere/lovereggae.wav'), 'pos': 12.67 ))
);


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, BufDef(\distreg),
				\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\hpf, 300,
				\hpmix, 0.1,
				\legato, 1,
				\dur, Pseq(sin((0..16*8)/2pi/10))+0.05,
				\gain, 0.8,
			),
			Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\pos, Pseq((0..54*16)/16 + (3/16))+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\lpf, 9300,
				\speed, Pseq(cos((0..16*8)/2pi/4.2+( 1/4 )).range(0.8,1.2)),
				\lpmix, 1.1,
				\legato, 1,
				\dur, Pseq(cos((0..16*8)/2pi/2.1+( 1/4 )))+0.05,
				\gain, 0.8,
			),
			Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, BufDef('vipere/lovereggae.wav'),
				\pos, Pseq((0..54*16)/16 + (3/16))+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\lpf, 9300,
				\lpmix, 1.1,
				\legato, 1,
				\dur, Pseq(sin((0..16*8)/2pi/4.1+( 1/4 )))+0.05,
				\gain, 0.8,
			),
		])
	)).play;
);



(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Ppar(10.collect{ arg idx;
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					\pos, Pseq((0..54*16)/16 + (3/16))+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\lpf, 9300,
					\lpmix, 1.1,
					\legato, 1,
					\lag, idx/10,
					\dur, Pseq([ 1,1.1,0.6,0.9 ],inf) * 0.1,
					\gain, 0.8,
				);

			})

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Ppar(10.collect{ arg idx;
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					\pos, Pseq((0..14*16)/16 + (3/16),inf)+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\lpf, 9300,
					\lpmix, 1.1,
					\legato, 1,
					\lag, idx/10 * Pseg(Pseq([1,0.9,1/10,2],inf),8),
					\dur, Pseq([ 1,1.1,0.6,0.9 ],inf) * 0.1* Pseg(Pseq([1,0.9,1/10,2],inf),14),
					\gain, 0.8,
				);

			})

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Ppar(10.collect{ arg idx;
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					\pos, Pseq((0..14*16)/16 + (3/16),inf)+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\lpf, 9300,
					\lpmix, 1.1,
					\legato, 1,
					\speed, Pseg(Pseq([1,0.9,1/2,2],inf),Pseq([100],inf))+(idx/500),
					\lag, idx/10 * Pseg(Pseq([1,0.9,1/10,2],inf),8),
					\dur, Pseq([ 1,1.1,0.6,0.9 ],inf) * 0.1* Pseg(Pseq([1,0.9,1/10,2],inf),14),
					\gain, 0.8,
				);

			})

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Ppar(10.collect{ arg idx;
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					\pos, Pseq((0..14*16)/16 + (3/16),inf)+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\lpf, 9300,
					\lpmix, 1.1,
					\legato, 1,
					\speed, Pseg(Pseq([1,0.9,1/2,2],inf),Pseq([0.1,0.9,4],inf))+(idx/10),
					\lag, idx/10 * Pseg(Pseq([1,0.9,1/10,2],inf),8),
					\dur, Pseq([ 1,1.1,0.6,0.9 ],inf) * 0.1* Pseg(Pseq([1,0.9,1/10,2],inf),14),
					\gain, 0.8,
				);

			})

		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Ppar(10.collect{ arg idx;
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					\bufnum, BufDef(\distreg),
					\pos, Pseq((0..13*16)/16 + (3/16),inf)+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\hpf, 3300,
					\hpmix, 0.4,
					\legato, 1,
					\speed, Pseg(Pseq([1,0.9,1/2,2],inf),Pseq([50.1,40,10,1,0.9,4],inf))+(idx/10),
					\lag, idx/10 * Pseg(Pseq([1,0.9,1/10,2],inf),8),
					\dur, Pseq([ 1,1.1,0.6,0.9 ],inf) * 0.1* Pseg(Pseq([1,0.9,1/10,2],inf),14),
					\gain, 0.8,
				);

			}),
			Ppar(10.collect{ arg idx;
				Pbind(
					\instrument, \playersec_hlpf,
					\bufnum, BufDef('vipere/lovereggae.wav'),
					\pos, Pseq((0..13*16)/16 + (3/16),inf)+0/~t + Pseq([0,0,0,0,0.1,0,Pseq([1],4)],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\lpf, 5300,
					\lpmix, 0.4,
					\legato, 1,
					\lag, idx/10 * Pseg(Pseq([1,0.9,1/10,2],inf),8),
					\dur, Pseq([ 1,1.1,0.6,0.9 ],inf) * 0.1* Pseg(Pseq([1,0.9,1/10,2],inf),14),
					\gain, 0.8,
				);

			})

		])
	)).play;
);

SynthDef(\oscsampler4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0, finepos=0, range=0.01,
						lpmix=0.5, ffreq=500, rq=0.1, spread=0.8, fshift=0;
	// env longer
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	osc = SinOsc.ar(freq*[1.001,0.999,1]);
	//osc = osc.sum;
	pos = EnvGen.kr(\posenv.kr(Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])),gate, levelScale:\levelScale.kr(1), timeScale:\timeScale.kr(1)) + pos;
	range = (range + (\framerange.kr(0)/BufFrames.ir(bufnum)));
	phase = osc * range + pos + finepos.lag(\fineposlag.kr(0));

	bufsig = BufRd.ar(2, bufnum, phase*BufFrames.ir(bufnum), 1);
	bufsig = bufsig.sum;
	ou = bufsig;
	ffreqtab = \ffreqtab.kr(1!8);
	ou = FreqShift.ar(ou, fshift);
	ou2 = RLPF.ar(ou, (ffreq * ffreqtab).clip(10,18000), rq);
	ou = SelectX.ar(lpmix, [ou, ou2]);
	ou2 = HPF.ar(ou, (\hpfreq.kr(180) * ffreqtab).clip(10,18000));
	ou = SelectX.ar(\hpmix.kr(0), [ou, ou2]);

	ou2 = (ou * \distpreamp.kr(18)).tanh / \distamp.kr(1);
	ou = SelectX.ar(\distmix.kr(0), [ou, ou2]);
	ou.debug("oscsampler4");
	ou = ou.clump(2).flop.collect({
		DelayL.ar(ou, 0.02,0.02.rand) + ou;
	})/3;
	ou.debug("oscsampler4, 2");
	ou = ou.flat;
	ou.debug("oscsampler4, 3");
	ou = Splay.ar(ou, spread, amp, pan);

	ou = ou * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	
	Out.ar(out, ou);
}, metadata:(specs:(
	finepos: ControlSpec(-0.001,0.001,\lin, 0, 1),
	range: ControlSpec(-0.01,0.01,\lin, 0, 1),
	adsr: \env -> [nil, nil, nil, nil, Env.adsr(0.01,0.1,0.8,0.1)],
	posenv: \env -> [nil, nil, nil, nil, Env([1,0,0.5,0.2, 0.2], [0.2,0.1,0.1,0.1])],
	fshift: ControlSpec(-2000,2000,\lin,0,0),
	spread: \unipolar.asSpec,
	lpmix: \unipolar.asSpec,
	pos: \unipolar.asSpec,
))).store;


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \oscsampler3,
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\posenv, [
				Env([0,0,1,0.05,0.1], [0.2,0.1,1.1,0.1]) 
			],
			\levelScale, 0.01,
			\timeScale, 2,
			\pos, 0.19,
			\framerange, 5,
			\freq, 500,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


SampleTimeline(\bigbass).edit
SampleTimeline(\bigbass).play
SampleTimeline(\bigbass).presetCompileString.editorInsert
(
SampleTimeline(\bigbass).buffer = BufDef( '~/Musique/sc/cliprec/rec_bigbass_190713_171701.wav' );
SampleTimeline('bigbass').eventList = XEventList.newFrom([
	(\absTime: 3.21875, \dur: 4.0, \label: 'start', \playDur: 4.0, \relDur: 4.0, \sustain: 0, \type: 'start', ),
	(\absTime: 7.21875, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pkey(\pos) + ( Pser([0,1,2,3]/2,6)/~t ),
				\dur, 1/2,
			),
			Pfindur(1, Pbind(
				\pos, Pkey(\pos) + Pwhite(0,8.0,inf).stutter(4),
				\dur, 1/8,
			))
		],inf)
		<>
		Pbind(
				\instrument, \playersec,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, 3.308 + ( Prand([0,1,2,3,4]*8,inf)/~t ),
				\legato, 1,
				\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\distreg),
			\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0.1,
			\legato, 1,
			\dur, 1/16,
			\gain, 0.8,
		),
		
	])
)).play;
);

ClipTimeline(\bla).edit

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pkey(\pos) + ( Pser([0,1,2,3]/2,6)/~t ),
				\dur, 1/2,
			),
			Pfindur(1, Pbind(
				\pos, Pkey(\pos) + Pwhite(0,8.0,inf).stutter(4),
				\dur, 1/8,
			))
		],inf)
		<>
		Pbind(
				\instrument, \playersec,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, 3.308 + ( Pseq([
					Pseq([0,1,2,3,4]*8,1),
					Prand([0,1,2,3,4]*8,1),
				],inf).stutter(Pseq([8,2,4],inf))/~t ),
				\legato, 1,
				\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\distreg),
			\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0.1,
			\legato, 1,
			\dur, 1/16,
			\gain, 0.8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pkey(\pos) + ( Pser([0,1,2,3]/2,6)/~t ),
				\dur, 1/2,
			),
			Pfindur(1, Pbind(
				\pos, Pkey(\pos) + Pwhite(0,8.0,inf).stutter(4),
				\dur, 1/8,
			))
		],inf)
		<>
		Pbind(
				\instrument, \playersec,
				\bufnum, 
				Prand([
					BufDef(\distkick),
SampleTimeline(\rec_perc2_t2_190717_200249).buffer,
SampleTimeline(\rec_perc2_t1_190717_200249).buffer,
				],inf),
				\pos, 3.308 + ( Pseq([
					Pser([0,1,2,3,4]*8,8),
					Prand([0,1,2,3,4]*8,8),
					Pseq([
						Pser([0,1,2,3,4]*8,8),
						Prand([0,1,2,3,4]*8,8),
					],1)+32,
				],inf).stutter(Pseq([8,2,4],inf))/~t ),
				\legato, 1,
				\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, SampleTimeline(\rec_perc2_t2_190717_200249).buffer,
			\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0.1,
			\legato, 1,
			\dur, 1/16,
			\gain, 0.8,
		),
		
	])
)).play;
);

( // add regular drums, doesnt' work
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
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
		Pseq([
			Pbind(
				\pos, Pkey(\pos) + ( Pser([0,1,2,3]/2,6)/~t ),
				\dur, 1/2,
			),
			Pfindur(1, Pbind(
				\pos, Pkey(\pos) + Pwhite(0,8.0,inf).stutter(4),
				\dur, 1/8,
			))
		],inf)
		<>
		Pbind(
				\instrument, \playersec,
				\bufnum, 
				Prand([
					BufDef(\distkick),
SampleTimeline(\rec_perc2_t2_190717_200249).buffer,
SampleTimeline(\rec_perc2_t1_190717_200249).buffer,
				],inf),
				\pos, 3.308 + ( Pseq([
					Pser([0,1,2,3,4]*8,8),
					Prand([0,1,2,3,4]*8,8),
					Pseq([
						Pser([0,1,2,3,4]*8,8),
						Prand([0,1,2,3,4]*8,8),
					],1)+32,
				],inf).stutter(Pseq([8,2,4],inf))/~t ),
				\legato, 1,
				\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, SampleTimeline(\rec_perc2_t2_190717_200249).buffer,
			\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0.1,
			\legato, 1,
			\dur, 1/16,
			\gain, 0.8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pbind(
				\pos, Pkey(\pos) + ( Pser([0,1,2,3]/2,6)/~t ),
				\dur, 1/2,
			),
			Pfindur(1, Pbind(
				\pos, Pkey(\pos) + Pwhite(0,8.0,inf).stutter(4),
				\dur, 1/8,
			))
		],inf)
		<>
		Pbind(
				\instrument, \playersec,
				\bufidx, Prand([0],inf),
				\bufnum, 
				Pindex([
					BufDef(\distkick),
				],Pkey(\bufidx)),
				\pos,  ( Pseq([
					Pser([0,1,2,3,4]*8,8),
					Prand([0,1,2,3,4]*8,8),
					Pseq([
						Pser([0,1,2,3,4]*8,8),
						Prand([0,1,2,3,4]*8,8),
					],1)+32,
				],inf).stutter(Pseq([8,2,4],inf))/~t ) + Pindex([0],Pkey(\bufidx)),
				\legato, 1,
				\gain, 1,
		),
		Pseq([
			Pbind(
				\pos, Pkey(\pos) + ( Pser([0,1,2,3].stutter(4)/2,6)/~t ),
				\dur, 1/8,
			),
			Pfindur(1, Pbind(
				\pos, Pkey(\pos) + Pwhite(0,8.0,inf).stutter(4),
				\dur, 1/8,
			))
		],inf)
		<>
		Pbind(
				\instrument, \playersec,
				\bufnum, 
				Prand([
SampleTimeline(\rec_perc2_t1_190717_200249).buffer,
SampleTimeline(\rec_perc2_t2_190717_200249).buffer,
				],inf),
				\pos, 0 + ( Pseq([
					Pser([0,1,2,3,4]*8,8),
					Prand([0,1,2,3,4]*8,8),
					Pseq([
						Pser([0,1,2,3,4]*8,8),
						Prand([0,1,2,3,4]*8,8),
					],1)+32,
				],inf).stutter(Pseq([8,2,4],inf))/~t ),
				\legato, 1,
				\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, SampleTimeline(\rec_perc2_t1_190717_200249).buffer,
			\pos, Pseq((0..54*16)/16 + (3/16))+0/~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\hpf, 300,
			\hpmix, 0.1,
			\legato, 1,
			\dur, 1/16,
			\gain, 0.8,
		),
		
	])
)).play;
);


(
	// down
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
				\instrument, \playersec,
				\bufidx, Prand([0],inf),
				\bufnum, SampleTimeline(\rec_perc_t3_190717_194430).buffer,
				\pos,  ( Pseq((0..15)/4+61+( 3/4 ),inf).stutter(2)/~t),
				\speed, Pseq((1..32).log.reverse,inf),
				\dur, 1/8,
				\legato, 1,
				\gain, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pseq([
			
			Pbind(
					\instrument, \playersec,
					\bufidx, Prand([0],inf),
					\bufnum, BufDef(\distkick),
					\pos,  ( Pseq((0..15)/4+61+( 3/4 ),inf).stutter(2)/~t),
					\speed, Pseq((1..32).log,1),
					\dur, 1/8,
					\legato, 1,
					\gain, 1/4,
			),
			Pfindur(16,
				Ppar([
					Pbind(
							\instrument, \playersec,
							\bufidx, Prand([0],inf),
							\bufnum, BufDef(\distkick),
							\pos,  ( Pseq([0,5,2,4]/4+5+( 3/4 ),inf).stutter(1)/~t),
							\speed, Pseq([1,1.2],inf),
							\isRest, Pseq([
								1,0,0,0, 0,0,0,0, 
							],inf).coin.not,
							\dur, 1/8,
							\legato, 2,
							\gain, 1/4,
					),
					Pbind(
							\instrument, \playersec,
							\bufidx, Prand([0],inf),
							\bufnum, BufDef(\distkick),
							\pos,  ( Pseq((0..8*32)/100/4+48+( 3/4 ),inf).stutter(1)/~t),
							\speed, Pseq([1,1.2],inf),
							\isRest, Pseq([
								0,0,0,0, 0,0,0,0,
								1,1,1,1, 0,0,0,0,
								1,0,0,0, 0,0,0,0,
								0,0,0,0, 1,1,1,1,
							],inf).coin.not,
							\dur, 1/8,
							\legato, 1,
							\gain, 1/4,
					),
					Pbind(
							\instrument, \playersec,
							\bufidx, Prand([0],inf),
							\bufnum, BufDef(\distkick),
							\pos,  ( Pseq([0,5,2,4]/4+35+( 3/4 ),inf).stutter(1)/~t),
							\speed, Pseq([1,1.2],inf),
							\isRest, Pseq([
								0,0,0,0, 1,0,0,0, 
								0,0,0,0, 1,0,0,1, 
							],inf).coin.not,
							\dur, 1/8,
							\legato, 2,
							\gain, 1/4,
					),
					Pbind(
							\instrument, \playersec,
							\bufidx, Prand([0],inf),
							\bufnum, BufDef(\distkick),
							\pos,  ( Pseq((0..8*32)/50/4+10+( 3/4 ),inf).stutter(1)/~t),
							\speed, Pseq([1,1.2],inf),
							\dur, 1/8,
							\legato, 1,
							\gain, 1/4,
					),
				]),
			),
			Pbind(
					\instrument, \playersec,
					\bufidx, Prand([0],inf),
					\bufnum, BufDef(\distkick),
					\pos,  ( Pseq((0..15)/4+61+( 3/4 ),inf).stutter(2)/~t),
					\speed, Pseq((1..32).log.reverse,1),
					\dur, 1/8,
					\legato, 1,
					\gain, 1/4,
			),
		],1),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
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
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					Prand([
						Pseq([
							0.5,
						],4),
						Pseq([
							1,0.7,
						],4),
						Pseq([
							1,0.3,0.7,0.3
						],2),
					],1),
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1,0.5,0.7,0.3,
					1,0.5,0.3,1,
					1,1,0.3,0.31,
				],inf),
				\gain, 1/9,
				\dur, 1/8,
			)),
		Pbind(
				\instrument, \playersec,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, ( Pseq([
					8,7,
					//Pseq([0,1,2,3,4]*8,1),
					//Prand([0,1,2,3,4]*8,1),
				],inf)/~t ) + 0.2 - 0.00,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,1,
					1,1,0,0, 1,0,1,1,
					0,0,0,0, 1,0,1,1,
					1,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,1,
					1,1,0,0, 1,0,1,1,
					0,1,1,0, 1,0,1,1,
					1,1,0,1, 1,1,0,1,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 1/4,
		),
		Pbind(
				\instrument, \playersec_hlpf,
				\hpf, 5000,
				\hpmix, 1,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, ( Pseq([
					38,27,
					//Pseq([0,1,2,3,4]*8,1),
					//Prand([0,1,2,3,4]*8,1),
				],inf)/~t ) + 0.2 - 0.00 + Pseg(Pseq([0,1],inf),8),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 1/4 * Pseq([1,1/2,1/3,1/4],inf),
		),
		Pbind(
				\instrument, \playersec,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, ( Pseq([
					3*8,5*4,3*8+1,
					//Pseq([0,1,2,3,4]*8,1),
					//Prand([0,1,2,3,4]*8,1),
				],inf).stutter(Pseq([6,1,1],inf))/~t ) + 0.2 - 0.00,
				\legato, 1,
				\gain, 1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					Prand([
						Pseq([
							0.5,
						],4),
						Pseq([
							1,0.7,
						],4),
						Pseq([
							1,0.3,0.7,0.3
						],2),
					],1),
				],inf).coin.not,
				\sustain, 0.1 * Pseq([
					1,0.5,0.7,0.3,
					1,0.5,0.3,1,
					1,1,0.3,0.31,
				],inf),
				\gain, 1/9,
				\dur, 1/8,
			)),
		Pbind(
				\instrument, \playersec,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, ( Pseq([
					8,7,
					//Pseq([0,1,2,3,4]*8,1),
					//Prand([0,1,2,3,4]*8,1),
				],inf)/~t ) + 0.2 - 0.00,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,1,
					1,1,0,0, 1,0,1,1,
					0,0,0,0, 1,0,1,1,
					1,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,1,
					1,1,0,0, 1,0,1,1,
					0,1,1,0, 1,0,1,1,
					1,1,0,1, 1,1,0,1,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 1/4,
		),
		Pbind(
				\instrument, \playersec_hlpf,
				\hpf, 5000,
				\hpmix, 1,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, ( Pseq([
					38,27,
					//Pseq([0,1,2,3,4]*8,1),
					//Prand([0,1,2,3,4]*8,1),
				],inf)/~t ) + 0.2 - 0.00 + Pseg(Pseq([0,1],inf),8),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 1/4 * Pseq([1,1/2,1/3,1/4],inf),
		),
		Pbind(
				\instrument, \playersec,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, ( Pseq([
					3*8,5*4,3*8+1,
					//Pseq([0,1,2,3,4]*8,1),
					//Prand([0,1,2,3,4]*8,1),
				]+2,inf).stutter(Pseq([6,1,1],inf))/~t ) + 0.2 - 0.00,
				\legato, 1,
				\gain, 1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
				\instrument, \playersec,
				\bufnum, SampleTimeline(\bigbass).buffer,
				\pos, (( Pseq([
					3*8,5*4,3*8+1,
					//Pseq([0,1,2,3,4]*8,1),
					//Prand([0,1,2,3,4]*8,1),
				],inf).stutter(Pseq([6,1,1]*4,inf)) + Pseq([0,1,2,3]/4,inf) + Pseq([0,0,0,0,0,3,0,12],inf).stutter(4))/~t ) + 0.2 - 0.00,
				\legato, 1,
				\dur, 1/4,
				\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([4,0,4,5, 4,2,4,3]+3,1)/16+1,
					Pseq([1,1,2,5, 11,12,13,14]+3,1)/16+1,
					Pseq([4,0,4,5, 4,2,4,3]+3,1)/16+1,
					Pseq([1,1,2,5, 11,12,13,14]+6,1)/16+1,
					//Pseq([4,4,4,4, 4,3,2,1]+1,1)/8+1,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,0,1,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,0, 1,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16 * (1 + (0.10 * Pseq([1,-1],inf))),
			\gain, 1/4,
			//\lag, 0.04,
			//\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

/////////////////////


(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,1, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\speed, Pseq([1,1.1,1,1.3],inf),
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\speed, Pseq([1,1.1,1,1.13],inf),
			\speed, 1,
			\velamp, Pseq([
				0.051,0.3, 0.051,0.3,
				0.4,0.1, 0.051,0.4,
				0,0,
				0.1,0.1, 0.4,0.1,
				0,0,
				0.01,0.051, 0.4,0.01,
				0.21,0.051, 0.04,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\velamp] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 0,
			\speed, 1,
			\speed, Pseq([1,1.1,1,1.13],inf),
			\velamp, Pseq([
				0,0,
				0.051,0.3, 0.051,0.3,
				0,0,
				0.4,0, 0.051,0.4,
				0,0,
				0.1,0.1, 0.4,0.1,
				0,0,
				0.01,0.051, 0.4,0.01,
				0,0,
				0.21,0.051, 0.04,0.01,
				0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\velamp] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\randperc1, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\speed, Pseq([1,1.1,1,1.3],inf),
			\isRest, Pseq([
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\speed, Pseq([1,1.1,1,1.13],inf),
			\speed, 1,
			\velamp, Pseq([
				0.051,0.3, 0.051,0.3,
				0.4,0.1, 0.051,0.4,
				0,0,
				0.1,0.1, 0.4,0.1,
				0,0,
				0.01,0.051, 0.4,0.01,
				0.21,0.051, 0.04,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\velamp] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\speed, 1,
			\speed, Pseq([1,1.1,1,1.13],inf),
			\velamp, Pseq([
				0,0,
				0.051,0.3, 0.051,0.3,
				0,0,
				0.4,0, 0.051,0.4,
				0,0,
				0.1,0.1, 0.4,0.1,
				0,0,
				0.01,0.051, 0.4,0.01,
				0,0,
				0.21,0.051, 0.04,0.01,
				0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\velamp] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\randperc2, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\speed, Pseq([1,1.1,1,1.3],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkit).asPattern(Pbind(
			\kitIndex, 4,
			\speed, Pseq([1,1.1,1,1.13],inf),
			\speed, 1,
			\velamp, Pseq([
				0.051,0.3, 0.051,0.3,
				0.4,0.1, 0.051,0.4,
				0,0,
				0.1,0.1, 0.4,0.1,
				0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0.01,0.051, 0.4,0.01,
				0.21,0.051, 0.04,0.01,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0.21,0,0.051, 0,0.04,0,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
				0.21,0,0.051, 0,0.04,0,0.01,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\velamp] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\speed, 1,
			\speed, Pseq([1,1.1,1,1.13],inf),
			\velamp, Pseq([
				0,0,
				0.051,0.3, 0.051,0.3,
				0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0.4,0, 0.051,0.4,
				0,0,
				0.1,0.1, 0.4,0.1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,
				0.01,0.051, 0.4,0.01,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,
				0.21,0.051, 0.04,0.01,
				0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\velamp] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
	])
)).play;
);

(
Pdef(\perc2, 
	PatKitDef(\comkit).asPattern(Pbind(
		\kitIndex, 0,
		\isRest, Pseq([
			1,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,1,0,
			1,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,0,1,
			1,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,0,1,
		],inf).coin.not,
		\sustain, 0.1,
		\velamp, 1,
		\dur, 1/16,
		\out, BusDef(\sendbus1, \audio),
	)),
	PatKitDef(\comkit).asPattern(Pbind(
		\kitIndex, 5,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0.51,0,
			1,0,0,0.81, 0,0,0.51,0,
		],inf).coin.not,
		\sustain, 0.1,
		\velamp, 1,
		\dur, 1/16,
		\out, BusDef(\sendbus1, \audio),
	)),
),
)

(
Pdef(\distbass1, 
	Pbind(
		\instrument, \otherbass,
		\note, Pseq([
			3,6,6,6,
		],inf).stutter(4),
		\detunediff, 0.1,
		\legato, Pseq([
			3,0,0,0, 0,2,0,0,
			3,0,0,0, 0,2,0,0,
			3,0,0,0, 0,2,0,0,
			1,0,0,1, 0,0,1,1,
		],inf),
		\lpf, 4000,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\octave, 3,
		//\lag, 0.04,
		\dur, 1/4,
		\amp, 0.1,
		\detunediff, 0.00001,
		\oscmix, 0,
		\harmsubamp, 1,
		\harmmainamp, 0.5,
		\harmoveramp, 0.2,
		\out, BusDef(\sendbus1, \audio),
	),
)
)

(
Pdef(\distbass2, 
	Ppar([
		Pbind(
			\instrument, \otherbass,
			\note, Pseq([
				3,6,6,6,
			],inf).stutter(4),
			\detunediff, 0.1,
			\legato, Pseq([
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				1,0,0,1, 0,0,1,1,
			],inf),
			\lpf, 4000,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			//\lag, 0.04,
			\dur, 1/4,
			\amp, 0.1,
			\detunediff, 0.00001,
			\oscmix, 0,
			\harmsubamp, 1,
			\harmmainamp, 0.5,
			\harmoveramp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
	]),
)
)

PatKitDef(\comkit).edit
PatKitDef(\bat).edit
PatKitDef(\rim).edit
PatKitDef.all.keys


//////////////


ProtoDef(\piano).startControl

(
Pdef(\part, Pdef(\fxperc1, 
		Pbind(\velamp, 0.4) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 1.1,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,1,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.051,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\velamp, 0.7,
				\dur, 1/8,
				\out, BusDef(\sendbus3, \audio),
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1, 1,1, 1,1, 0,0,
					0,0, 1,1, 1,1, 1,1,
					1,1, 1,1, 0,0, 1,1,
					0,0, 1,1, 1,1, 1,1,
				],inf).coin.not,
				\sustain, 0.171 * Pseq([1,0.9],inf),
				\speed, 1.01 * Pseq([1,0.98],inf),
				//\lag, 1/16/~t,
				\gain, 0.2  * Pseq([1,0.7,Pseq([1,0.4],5),1,0.8, Pseq([
					1,0.1
				],6),],inf),
				//\lag, 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
			)),
		]),
	),
).play;
)


(
Pdef(\part, Pdef(\perc1, 
		Pbind(\velamp, 0.4) <>
		Ppar([
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 1.1,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,1,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.051,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\velamp, 0.7,
				\dur, 1/8,
			)),
			PatKitDef(\comkit).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1, 1,1, 1,1, 0,0,
					0,0, 1,1, 1,1, 1,1,
					1,1, 1,1, 0,0, 1,1,
					0,0, 1,1, 1,1, 1,1,
				],inf).coin.not,
				\sustain, 0.171 * Pseq([1,0.9],inf),
				\speed, 1.01 * Pseq([1,0.98],inf),
				//\lag, 1/16/~t,
				\gain, 0.2  * Pseq([1,0.7,Pseq([1,0.4],5),1,0.8, Pseq([
					1,0.1
				],6),],inf),
				//\lag, 0.04,
				\dur, 1/8,
			)),
		]),
	),
).play;
)


(
SynthDef(\brouille, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/14/~t, 0, Dseq([
		1,Dwhite(0.5,1.5,1),1,1,1.1,
	],inf));
	lfo2 = Duty.kr(1/8/~t, 0, Dseq([
		1,Dwhite(0.5,1.5,1),1,1,1.1,
	],inf));
	lfo3 = Duty.ar(1999, 0, Dseq([
		1,Dwhite(0.5,1.5,4),1,1,1.1,
	],inf));
	env1 = EnvGen.kr(Env([1,1.12,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.41,1.8]), 1);
	sig1 = SinOsc.ar(freq * ( lfo1 * 0.21 * env1 + 1 ));
	sig2 = SinOsc.ar(freq * [1,4/3,11.midiratio] * ( lfo2 * 0.21 * env1 + 1 )).mean;
	sig3 = LFSaw.ar(freq * ( lfo3 * 0.21 * env2 + 1 ) * ( lfo1 * 0.51 + 1 ));
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = ( [sig1, sig2, sig3] * [env2, env1, env4] ).mean;
	//sig = SelectX.ar(\mix.kr(1)*2 * env3, [sig1, sig2, sig3]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.7)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\brouille, 
	Pbind(
		\instrument, \brouille,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);

(
Pdef(\brouille2, 
	Pbind(
		\instrument, \brouille2,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\perc1),
		NoteTimeline(\brouille).asPattern,
	])
)).play;
);

(
Pdef(\basicbass, 
	Pbind(
		\instrument, \basicbass,
		\lpf, 2000,							
		\dur, 1,
		\amp, 0.1/2,
	),
);
);

ProtoDef(\piano).startControl(Pdef(\brouille2))
ProtoDef(\piano).startControl(Pdef(\basicbass))
ProtoDef(\piano).stopControl

ParamProto.init(true)
NoteTimeline(\brouille, Pdef(\brouille)).edit
NoteTimeline(\brouille).edit
NoteTimeline(\brouille).presetCompileString.editorInsert
(
NoteTimeline('brouille').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \amp: 0.1, \clockTime: 15851.118167283, \degree: 0, \dur: 1.5, \instrument: 'brouille', \kitIndex: 67, \midinote: 67.0, \playDur: 1.5, \relDur: 1.5, \sustain: 1.5200744939993, ),
	(\absTime: 1.5, \amp: 0.1, \clockTime: 15852.648632543, \degree: 0, \dur: 0.5, \instrument: 'brouille', \kitIndex: 73, \midinote: 74.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.409577151333, ),
	(\absTime: 2.0, \amp: 0.1, \clockTime: 15853.127891944, \degree: 0, \dur: 1.5, \instrument: 'brouille', \kitIndex: 66, \midinote: 66.0, \playDur: 1.5, \relDur: 1.5, \sustain: 1.5, ),
	(\absTime: 3.5, \amp: 0.1, \clockTime: 15854.604746917, \degree: 0, \dur: 0.5, \instrument: 'brouille', \kitIndex: 74, \midinote: 73.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

NoteTimeline(\brouille).startControl
NoteTimeline(\brouille).clear
NoteTimeline(\brouille)[\startControl]
NoteTimeline(\basicbass)[\startControl]
NoteTimeline(\brouille)[\controller].startControl(NoteTimeline(\brouille))
NoteTimeline(\basicbass, Pdef(\basicbass)).edit
~nektar_device_id

(
SynthDef(\brouille2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.ar(freq, 0, Dseq([
		1,Dwhite(0.5,1.5,1),1,1,1.1,
	],inf));
	lfo2 = Duty.ar(freq+1, 0, Dseq([
		1,Dwhite(0.5,1.5,1),1,1,1.1,
	],inf));
	lfo3 = Duty.ar(freq+2, 0, Dseq([
		1,Dwhite(0.5,1.5,4),1,1,1.1,
	],inf));
	env1 = EnvGen.kr(Env([0,1.12,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0,1,1.10],[0.01,0.8]), 1);
	env3 = EnvGen.kr(Env([0,1,0.70],[0.01,1.8]), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.41,1.8]), 1);
	sig1 = SinOsc.ar(freq * ( lfo1 * 0.21 * env1 + 1 ));
	sig2 = SinOsc.ar(freq * [1,3.midiratio,9.midiratio] * ( lfo2 * 0.21 * env1 + 1 ), mul:[1,0.3,0.1]).mean;
	sig3 = LFSaw.ar(freq * [1/2,1, 1/4] * ( lfo3 * 0.21 * env2 + 1 ) * ( lfo1 * 0.51 + 1 )).mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = ( [sig1, sig2, sig3] * [env2, env1, env4] ).mean;
	//sig = SelectX.ar(\mix.kr(1)*2 * env3, [sig1, sig2, sig3]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.7)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


intro 4
verse 16
pre 4
chorus 8
verse 8
pre 4
chorus 8
bridge 8
chorus 8

(4+16+4+8+8+4+8+8+8)*2
(4+16+4+8+8+4+8+8+8)/60*2/~t

ClipTimeline(\vin2main).edit
ClipTimeline(\vin2main).tracks.size
ClipTimeline(\vin2main).areasize
ClipTimeline(\vin2main).presetCompileString.editorInsert
(
ClipTimeline('vin2main').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
ClipTimeline('vin2main').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \legato: 1, \midinote: 3.0, \pattern: Pdef('perc1'), \playDur: 8.0, \relDur: 8.0, \sustain: 8.0, \type: 'pattern', )),
	(\absTime: 8.0, \dur: 32.0, \label: "verse1", \playDur: 32.0, \relDur: 32.0, \type: 'locator', ),
	(\absTime: 40.0, \dur: 8.0, \label: "pre", \playDur: 8.0, \relDur: 8.0, \type: 'locator', ),
	(\absTime: 48.0, \dur: 16.0, \label: "chorus1", \playDur: 16.0, \relDur: 16.0, \type: 'locator', ),
	(\absTime: 64.0, \dur: 16.0, \label: "verse2", \playDur: 16.0, \relDur: 16.0, \type: 'locator', ),
	(\absTime: 80.0, \dur: 8.0, \label: "pre", \playDur: 8.0, \relDur: 8.0, \type: 'locator', ),
	(\absTime: 88.0, \dur: 16.0, \label: "chorus2", \playDur: 16.0, \relDur: 16.0, \type: 'locator', ),
	(\absTime: 104.0, \dur: 16.0, \label: "bridge", \playDur: 16.0, \relDur: 16.0, \type: 'locator', ),
	(\absTime: 120.0, \dur: 16.0, \label: "chorus3", \playDur: 16.0, \relDur: 16.0, \type: 'locator', ),
	(\absTime: 136.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



PatKitDef(\comkithi).edit
PatKitDef(\comkithi).presetCompileString.editorInsert
(
PatKitDef('comkithi').targets = [
	StepEvent.newFrom((instrument: 'playersec', out: 0, gain: 0.22452932564887, bufnum: BufDef('com/Kick/Kick AfroShop 1.wav'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', out: 0, gain: 0.3756734311759, bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Snare/Snare Gothik 3 V1.wav'))),
	StepEvent.newFrom((gain: 0.27994635610259, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Snare/Snare Gothik 6 V2.wav'))),
	nil,
	nil,
	StepEvent.newFrom((gain: 0.1067316, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/HiHat/ClosedHH Alphabetical 1.wav'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((gain: 0.58400151705547, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/HiHat/OpenHH Gothik 3 V1.wav'))),
	StepEvent.newFrom((gain: 0.32429679021268, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/HiHat/OpenHH Gothik 3 V2.wav'))),
	StepEvent.newFrom((gain: 0.32429679021268, instrument: 'playersec', bufnum: BufDef('com/HiHat/OpenHH Gothik 3 V3.wav'))),
	nil,
	StepEvent.newFrom((gain: 0.30130666224929, instrument: 'playersec', bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/HiHat/OpenHH Tracid 4.wav'))),
];
);



(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1/5,
			\dur, 1/16,
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
		PatKitDef(\comkithi).asPattern(Pbind(
			\kitIndex, 12,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\sustain, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 2,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkithi).asPattern(Pbind(
			\kitIndex, 16,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),
		PatKitDef(\comkithi).asPattern(Pbind(
			\kitIndex, 14,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\velamp, 1,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		)),

		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (Pseq((0..15),inf)/8+4/~t),
			\legato, 1,
			\legato, Pseq([
				2,0,1,0, 2,0,1,0,
				1,1,1/2,2, 0,0,1/2,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			\out, BusDef(\sendbus4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('vipere/lovereggae.wav'),
			\pos, 3.67 + (
				
				Pseq([
					Pseq([0,2,1,3,  8,8,8,9,4,5,6,7, 16,16,16,17],3)/8+4,
					Pseq([Pseq([0,2,1,3]+8),  8,8,8,9,4,5,6,7, 16,16,16,17],1)/8+3,
				],inf)
				
				/~t),
			\legato, 1,
			\legato, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				3,6,6,6,
			],inf).stutter(4),
			\legato, Pseq([
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				3,0,0,0, 0,2,0,0,
				1,0,0,1, 0,0,1,1,
			],inf),
			\lpf, 4000,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			//\lag, 0.04,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);
