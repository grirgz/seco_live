

PatKitDef(\newkit).edit
PatKitDef(\newkit).presetCompileString.editorInsert
(
~ppg.targets = [
	StepEvent.newFrom((instrument: 'playersec', out: BusDef(\sendbus1), gain: 0.22452932564887, bufnum: BufDef('com/Kick/Kick AfroShop 1.wav'))),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', out: BusDef(\sendbus2), gain: 0.3756734311759, bufnum: BufDef('//home/ggz/Musique/sc/samplekit/com/Snare/Snare Gothik 3 V1.wav'))),
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


KitTimeline(\line1, PatKitDef(\newkit)).edit
KitTimeline(\line1, PatKitDef(\newkit)).presetCompileString.editorInsert
(
KitTimeline('line1').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.125, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 0.25, \dur: 0.125, \kitIndex: 13.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 0.375, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.5, \dur: 0.125, \kitIndex: 4.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 0.625, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 0.75, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.875, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 1.0, \dur: 0.125, \kitIndex: 13.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 1.125, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 1.25, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 1.375, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 1.5, \dur: 0.0, \kitIndex: 4.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 1.5, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 1.625, \dur: 0.125, \kitIndex: 12.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 1.75, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 1.875, \dur: 0.125, \kitIndex: 8.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

NoteTimeline(\line1, Pdef(\bass)).edit;
NoteTimeline(\line1, Pdef(\bass)).postChain
NoteTimeline(\line1, Pdef(\bass)).clear
NoteTimeline(\line1, Pdef(\bass)).presetCompileString.editorInsert
(
NoteTimeline('line1').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.375, \kitIndex: 0.0, \midinote: 34, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 0.375, \dur: 0.375, \kitIndex: 0.0, \midinote: 34, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 0.75, \dur: 0.5, \kitIndex: 0.0, \midinote: 34, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
	(\absTime: 1.25, \dur: 0.5, \kitIndex: 0.0, \midinote: 34, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 1.75, \dur: 0.25, \midinote: 34.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ClipTimeline(\part1).edit
ClipTimeline(\part1).presetCompileString.editorInsert
(
ClipTimeline('part1').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 3.0, \pattern: Pdef('masterSetup'), \playDur: 0.0, \relDur: 0.0, \sustain: 3.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \legato: 1, \midinote: 2.0, \pattern: Pdef('ghost'), \playDur: 8.0, \relDur: 8.0, \sustain: 56.0, \type: 'pattern', )),
	PatternEvent((\absTime: 8.0, \dur: 8.0, \label: 'drums', \legato: 1, \midinote: 1.0, \playDur: 8.0, \relDur: 8.0, \sustain: 48.0, \timeline: { KitTimeline('line1') }, \type: 'pattern', )),
	PatternEvent((\absTime: 16.0, \dur: 48.0, \label: 'bass', \legato: 1, \midinote: 0.0, \playDur: 48.0, \relDur: 48.0, \sustain: 64.0, \timeline: { NoteTimeline('line1') }, \type: 'pattern', )),
	(\absTime: 64.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



(
SynthDef(\longbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1/2,1],[0.3,0.8]), 1);
	env2 = EnvGen.kr(Env([0,0.01,1],[1.3,0.8]), 1);
	env3 = EnvGen.kr(Env([0,Rand(1,10.0),0],[0.3,0.8]), 1);
	env4 = ( SinOsc.kr(2) * 0.3 + 1 ) * ( SinOsc.ar(freq) * 0.91 + 1 );
	sig = LFPulse.ar(freq * ( SinOsc.ar(freq+env2) * env1 + 1 ));
	sig = sig + SinOsc.ar(freq * ( SinOsc.ar(freq+env3) * env1 + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(1000) * env4, \rq.kr(0.5));
	sig = sig * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


		(
			Pdef(\bass, 
				Pbind(
					\instrument, \longbass,
					\note, Pseq([
						0,
					],inf),
					//\lpf, ~pmodenv.(Pseq([100,8000],1), Pn(1/4,1)),
					\octave, 3,
					\dur, 1,
					\amp, 0.1,
					//\out, BusDef(\sendbus1, \audio),
				),
			)
		)
		Pdef(\bass).stop

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);
Pdef(\part).stop
ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "6-KUSS-8GNG", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.1138893662396,
	'gain', 0.86193770992747,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.021683753109874,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 13.497461607899,
	'pitchlag', 1.0,
	'pitchmix', 0.15546218487395,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.46172657538954,
	'fbdistmix', 0.97478991596639,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 0.62246888439954,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', 0.0,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 0.83208571689933,
).keep(1));

);



ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('del3full', 'rdn2', "5-BQPG-1CQI", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.12277019371543,
	'gain', 1.8602632679004,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.25808615404181,
	'delay3', 0.00013111339374216,
	'distamp', 20.263883924964,
	'distamp2', 2.2322328540381,
	'distamp3', 0.39123434672283,
	'shift', 0,
	'shift2', 0,
	'shift3', 0,
	'shiftmix', 1.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 128.16005488832,
	'stereo', 0.0,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 333.97893177422,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-68FA-6LFG", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.18504562572587,
	'gain', 0.63363107768463,
	'fb', 0.0001,
	'delay', 0.42682721311638,
	'delay2', 0.00011674193588235,
	'shift', 0,
	'shift2', 0,
	'distamp', 0.22539339047348,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 1035.8949358462,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
ProtoDef(\rdn4).presetCompileString.editorInsert
(
ProtoDef('rdn4').make('deldefault', 'rdn4', "4-5Q5Q-1SIK", BusDef(\sendbus1));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.49030948368072,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 22.758459260748,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 6833.5038123161,
	'hpf', 710.31365523618,
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



(
Pdef(\masterSetup, 
	Prout({ arg ev;
		"setup!".postln;
		ProtoDef(\rdn).play;
		ProtoDef(\rdn2).play;
		ProtoDef(\rdn3).play;
	}),
).play;
);


(
Pdef(\ghost, 
	Pbind(\out, BusDef(\sendbus3, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \tredrone,
			\degree, Pseq([
				[0],
				[-1],
			],inf),
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\ctranspose, -2+12,
			\dur, 1,
			\amp, 0.4,
			//\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \tredrone,
			\degree, Pstep(Pseq([
				9,
				12,
				9,
				8,
			],inf),1),
			\ctranspose, -2+12,
			\legato, Pseq([
				3,0,0,0, 0,3,0,0,
				3,0,0,0, 0,0,0,1,
				3,0,0,1, 0,3,0,0,
			],inf),
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16,
			\amp, 0.1,
			//\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \tredrone,
			\degree, Pseq([
				13,12,11,14,
			],inf),
			\ctranspose, -2,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,2,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 3,0,0,1,
			],inf),
	\cus3, { rrand(0.01,10) }.dup(3),
	\fma, 0.01,
	\cus2, [1,2,3]*10,
	\cusfreq, [1,2,3]/3,
	\lpfr, 2,
	\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		),
	]),
).play;
);
