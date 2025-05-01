
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("holis/synthdef.scd");
);

(
SynthDef(\grosfil, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var ff;
	ff = \ff.kr(1);
	lfo1 = SinOsc.ar(1/2*ff*~t).range(0,1);
	lfo2 = SinOsc.ar(3*ff*~t).range(0.5,1.5);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) * lfo1 + 1)).mean;
	sig1 = LFPulse.ar(freq*[2,3]).sum * ( SinOsc.ar(4*ff*~t).range(0,1) * 1 );
	sig = sig + sig1;
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\grosfilfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var ff;
	ff = \ff.kr(1);
	lfo1 = SinOsc.ar(1/2*ff*~t).range(0,1);
	lfo2 = SinOsc.ar(3*ff*~t).range(0.5,1.5);
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1/3)) * \fmamp.kr(0.5) + 1 ) * ((0..7)/7 - 0.5 * \fspread.kr(0.1) * lfo1 + 1)).mean;
	sig1 = LFPulse.ar(freq*[2,3]).sum * ( SinOsc.ar(4*ff*~t).range(0,1) * 1 );
	sig = sig + sig1;
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

//////////////////
(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

NoteTimeline(\sun61_chords).edit
NoteTimeline(\sun61_chords).presetCompileString.editorInsert
(
NoteTimeline('sun61_chords').param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('sun61_chords').eventList = TimelineEventList.newFrom([
	(\absTime: -0.043069010000011, \clockTime: 176.15693099, \dur: 0.0032084700000041, \kitIndex: 62, \midinote: 62, \playDur: 0.0032084700000041, \relDur: 0.0032084700000041, \sustain: 3.883874658, ),
	(\absTime: -0.039860540000006, \clockTime: 176.16013946, \dur: 0.0014803850000078, \kitIndex: 55, \midinote: 55, \playDur: 0.0014803850000078, \relDur: 0.0014803850000078, \sustain: 1.858501098, ),
	(\absTime: -0.038380154999999, \clockTime: 176.161619845, \dur: 0.038380154999999, \kitIndex: 59, \midinote: 59, \playDur: 0.038380154999999, \relDur: 0.038380154999999, \sustain: 1.997053083, ),
	(\absTime: 0.0, \dur: 2.045541182, \label: 'start', \playDur: 2.045541182, \relDur: 2.045541182, \sustain: 0, \type: 'start', ),
	(\absTime: 2.045541182, \clockTime: 178.245541182, \dur: 0.055312313000002, \kitIndex: 59, \midinote: 59, \playDur: 0.055312313000002, \relDur: 0.055312313000002, \sustain: 1.781220125, ),
	(\absTime: 2.100853495, \clockTime: 178.300853495, \dur: 1.884879907, \kitIndex: 53, \midinote: 53, \playDur: 1.884879907, \relDur: 1.884879907, \sustain: 1.742450985, ),
	(\absTime: 3.985733402, \clockTime: 180.185733402, \dur: 0.036514928000003, \kitIndex: 62, \midinote: 62, \playDur: 0.036514928000003, \relDur: 0.036514928000003, \sustain: 3.381648356, ),
	(\absTime: 4.02224833, \clockTime: 180.22224833, \dur: 0.0013731640000003, \kitIndex: 58, \midinote: 58, \playDur: 0.0013731640000003, \relDur: 0.0013731640000003, \sustain: 1.760348784, ),
	(\absTime: 4.023621494, \clockTime: 180.223621494, \dur: 1.975071916, \kitIndex: 53, \midinote: 53, \playDur: 1.975071916, \relDur: 1.975071916, \sustain: 1.842530557, ),
	(\absTime: 5.99869341, \clockTime: 182.19869341, \dur: 0.019922070000007, \kitIndex: 57, \midinote: 57, \playDur: 0.019922070000007, \relDur: 0.019922070000007, \sustain: 1.84975566, ),
	(\absTime: 6.01861548, \clockTime: 182.21861548, \dur: 1.356629641, \kitIndex: 52, \midinote: 52, \playDur: 1.356629641, \relDur: 1.356629641, \sustain: 1.845566357, ),
	(\absTime: 7.375245121, \clockTime: 183.575245121, \dur: 0.62475487899999, \kitIndex: 60, \midinote: 60, \playDur: 0.62475487899999, \relDur: 0.62475487899999, \sustain: 0.464638579, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,2,
			],inf),
			\octave, 5,
			\dur, Prand([1,2],inf) * 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \grosfil,
			\note, Pseq([
				Pseq((0..11))
			],inf),
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Prand([0,4,7] +.x [-12,0,12])
			],inf),
			\octave, 6,
			\dur, Prand([1/2,1,1/4,2],inf) * 2,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(\out, BusDef(\ifx1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \grosfil,
				\note, Pseq([
					Pseq((0..11))
				],inf),
				\legato,0.95,
				\ff, ~pmodenv.(Pseq([0.1,1,2,10,100],1), 4).loop,
				\octave, 4,
				\dur, 2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \grosfil,
				\note, Pseq([
					0,2,
				],inf),
				\ff, 3,
				\octave, 5,
				\dur, Prand([1,2],inf) * 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \grosfil,
				\note, Pseq([
					Prand([0,4,7] +.x [-12,0,12])
				],inf),
				\ff, ~pmodenv.(Pseq([0.1,1,2],1), 8).loop,
				\octave, 5,
				\dur, Prand([1/2,1,1/4,2],inf) * 2,
				\amp, 0.1/2,
			),
		]),
		Pmono(\fx_chorus,
			\fb, 0.40000000596046,
			\maxdelay, 0.20000000298023,
			\delay, 0.010099999606609,
			\diff, 0.40009999275208,
			\modfreq, 1/8.1000003814697,
			\modamp, 0.47999998927116,
			\lpf, 15000.0,
			\hpf, 50.0,
			\mix, 0.51,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

//

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-PGM9-2468", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.27310924369748,
	'gain', 0.32352941176471,
	'fb', 0.0001,
	'delay', 0.79279273894506,
	'delay2', 0.82407433098937,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.1839525795804,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.30252100840336,
	'postlpf', 17000,
	'posthpf', 563.13150824477,
	'wetamp', 0.46579739809918,
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


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \basicbass,
				\lpf, ~pmodenv.(Prand([2,4,8,10]*100,10), Prand([2,8,10],inf)).loop,
				\rq, 0.5,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\note, Pseq([
					Pseq((0..11))
				],inf),
				\legato,0.95,
				\octave, 3,
				\dur, 2,
				\amp, 0.1/2,
			),
		Pbind(\out, BusDef(\ifx1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \grosfil,
				\note, Pseq([
					0,2,
				],inf),
				\ff, 3,
				\ff, ~pmodenv.(Prand([10,30,100,300,0.1,1,2],1), 16).loop,
				\octave, 5,
				\dur, Prand([1,2],inf) * 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \grosfil,
				\note, Pseq([
					Prand([0,4,7] +.x [-12,0,12])
				],inf),
				\ff, ~pmodenv.(Pseq([0.1,1,2],1), 8).loop,
				\octave, 5,
				\dur, Prand([1/2,1,1/4,2],inf) * 2,
				\amp, 0.1/2,
			),
		]),
		Pmono(\fx_chorus,
			\fb, 0.40000000596046,
			\maxdelay, 0.20000000298023,
			\delay, 0.010099999606609,
			\diff, 0.40009999275208,
			\modfreq, 1/8.1000003814697,
			\modamp, 0.47999998927116,
			\lpf, 15000.0,
			\hpf, 50.0,
			\mix, 0.51,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

//

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-N978-5DF9", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.34453781512605,
	'gain', 0.98319327731092,
	'fb', 0.0001,
	'delay', 0.42682721311638,
	'delay2', 0.85659021536855,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 2.9839388300193,
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
	'wetamp', 2.1696721607597,
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
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-70O0-5J99", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.45798319327731,
	'gain', 0.76470588235294,
	'fb', 0.0028978297094592,
	'delay', 0.0001,
	'delay2', 0.62852032692401,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.22539339047348,
	'pitchlag', 0.001,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 203.90757370655,
	'wetamp', 0.46579739809918,
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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind(
				\instrument, \basicbass,
				\lpf, ~pmodenv.(Prand([2,4,8,10]*100,10), Prand([2,8,10],inf)).loop,
				\rq, 0.5,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\note, Pseq([
					Pseq((0..11))
				],inf),
				\legato,0.95,
				\octave, 3,
				\dur, 2,
				\amp, 0.1/2,
			),
		Ppar([
			Pbind(
				\instrument, \grosfilfm,
				\note, Pseq([
					0,2,
				],inf),
				\fmr, Prand([
					2
				],inf).stutter(16),
				\ff, 3,
				\ff, ~pmodenv.(Prand([10,30,100,300,0.1,1,2],1), 16).loop,
				\octave, 5,
				\dur, Prand([1,2],inf) * 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(
				\instrument, \grosfilfm,
				\note, Pseq([
					Prand([0,4,7] +.x [-12,0,12])
				],inf),
				\fmr, Pseq([
					Prand((0..8)/4)
				],inf),
				\ff, ~pmodenv.(Pseq([0.1,1,2],1), 8).loop,
				\octave, 5,
				\dur, Prand([1/2,1,1/4,2],inf) * 2,
				\amp, 0.1/2,
				\out, BusDef(\sendbus2, \audio),
			),
		]),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[963].value,
			\bufnum, ~buflib.kick[225].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2218].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \basicbass,
			\lpf, ~pmodenv.(Prand([2,4,8,10]*100,10), Prand([2,8,10],inf)).loop,
			\rq, 0.5,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				Pseq((0..11))
			],inf),
			\legato,0.95,
			\octave, 3,
			\dur, 2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \grosfilfm,
			\note, Pseq([
				0,2,
			],inf),
			\fmr, Prand([
				2
			],inf).stutter(16),
			\ff, 3,
			\ff, ~pmodenv.(Prand([10,30,100,300,0.1,1,2],1), 16).loop,
			\octave, 5,
			\dur, Prand([1,2],inf) * 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \grosfilfm,
			\note, Pseq([
				Prand([0,4,7] +.x [-12,0,12])
			],inf),
			\fmr, Pseq([
				Prand((0..8)/4)
			],inf),
			\ff, ~pmodenv.(Pseq([0.1,1,2],1), 8).loop,
			\octave, 5,
			\dur, Prand([1/2,1,1/4,2],inf) * 2,
			\amp, 0.1/2,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);
