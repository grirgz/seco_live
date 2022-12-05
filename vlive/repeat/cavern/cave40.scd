
~t = 152/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\pianpian, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,3,1],[Rand(0.01,0.051),Rand(0.1,1.8)]), 1);
	sig = LFCub.ar(freq * SinOsc.ar(8*~t).range(0.9/2,1/2) * ( Pulse.ar(freq + (1..10).scramble  ) * 0.1 * env1 + 1 ));
	sig = sig + SinOsc.ar(freq * [0,-12,6,12,24].midiratio, mul:1.2).fold(0.2);
	sig = sig + RLPF.ar(LFSaw.ar(freq/2 * ( SinOsc.ar(freq * 11.midiratio) * 0.11 + 1 )), freq*1.7, 0.7, mul:0.1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.3)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1!sig.size).range(-1,1.0), amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
);
);

(
Pdef(\pianpian, 
	Pbind(
		\instrument, \pianpian,
	)
);
);

FileSystemProject.load("libdef/piano.scd")
ProtoDef(\piano).startControl(Pdef(\melo))
ProtoDef(\piano).stopControl

NoteTimeline(\cave40_note1, Pdef(\pianpian)).edit


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( \out, BusDef(\sendbus1, \audio), )<>
		NoteTimeline(\cave40_note1).asPattern,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1441].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1579].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[348].value,
			//\bufnum, ~buflib.hat[800].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11/1.52,
		),
		
	])
)).play;
);

(
Pdef(\babass, 
	Pbind(
		\instrument, \basicbass,
		//\lpfr, ~pmodenv.(Pseq([1/3,8],1), 8).loop,
		\lpfr, Pseq([
			1,2,5,10,
		],inf).trace,
		\rq, 0.1,
	)
);
);

NoteTimeline(\cave40_note2, Pdef(\babass)).edit
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( \out, BusDef(\sendbus1, \audio), )<>
		NoteTimeline(\cave40_note1).asPattern,
		Pbind( \out, BusDef(\sendbus2, \audio), )<>
		NoteTimeline(\cave40_note2).asPattern,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1441].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1579].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[348].value,
			//\bufnum, ~buflib.hat[800].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11/1.52,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( \out, BusDef(\sendbus1, \audio), )<>
		NoteTimeline(\cave40_note1).asPattern,
		//Pbind( \out, BusDef(\sendbus2, \audio), )<>
		//NoteTimeline(\cave40_note2).asPattern,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1441].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1579].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,4,
			],inf).stutter(16),
			\dur, 1/8,
			\gain, 0.11,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[348].value,
			//\bufnum, ~buflib.hat[800].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11/1.52,
			\lag, 0.04,
		),
		
	])
)).play;
);

Log(\Param).level = \info
KitTimeline(\cave40_perc1).edit
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( \out, BusDef(\sendbus1, \audio), )<>
		NoteTimeline(\cave40_note1).asPattern,
		//Pbind( \out, BusDef(\sendbus2, \audio), )<>
		//NoteTimeline(\cave40_note2).asPattern,
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[1441].value,
			////\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,1,
				//1,0,0,1, 1,0,0,0,
				//0,0,0,0, 0,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.1,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1579].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[348].value,
			//\bufnum, ~buflib.hat[800].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11/1.52,
		),
		
	])
)).play;
);

NoteTimeline(\cave40_note1).presetCompileString.editorInsert
(
NoteTimeline('cave40_note1').param = Param(Pdef('pianpian'), 'midinote');
NoteTimeline('cave40_note1').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \clockTime: 713.19618632443, \dur: 0.0, \kitIndex: 69, \midinote: 69, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1963767863333, ),
	(\absTime: 0.0, \clockTime: 713.19989185263, \dur: 0.0, \kitIndex: 74, \midinote: 74, \playDur: 0.0, \relDur: 0.0, \sustain: 0.21082946439992, ),
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \clockTime: 713.21251006296, \dur: 0.5, \kitIndex: 76, \midinote: 76, \playDur: 0.5, \relDur: 0.5, \sustain: 0.19605255639999, ),
	(\absTime: 0.5, \clockTime: 713.64198830876, \dur: 0.0, \kitIndex: 69, \midinote: 69, \playDur: 0.0, \relDur: 0.0, \sustain: 0.16540677746673, ),
	(\absTime: 0.5, \clockTime: 713.68818912676, \dur: 0.0, \kitIndex: 76, \midinote: 76, \playDur: 0.0, \relDur: 0.0, \sustain: 0.13606249219981, ),
	(\absTime: 0.5, \clockTime: 713.66292577423, \dur: 0.5, \kitIndex: 74, \midinote: 74, \playDur: 0.5, \relDur: 0.5, \sustain: 0.14230921973319, ),
	(\absTime: 1.0, \clockTime: 714.1318836159, \dur: 0.0, \kitIndex: 69, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.21545656606679, ),
	(\absTime: 1.0, \clockTime: 714.1891298825, \dur: 0.0, \kitIndex: 76, \midinote: 76, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1550931278, ),
	(\absTime: 1.0, \clockTime: 714.16239935756, \dur: 0.5, \kitIndex: 74, \midinote: 74, \playDur: 0.5, \relDur: 0.5, \sustain: 0.17586709826662, ),
	(\absTime: 1.5, \clockTime: 714.61574291816, \dur: 0.0, \kitIndex: 69, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.2352118578666, ),
	(\absTime: 1.5, \clockTime: 714.64156276676, \dur: 0.0, \kitIndex: 74, \midinote: 74, \playDur: 0.0, \relDur: 0.0, \sustain: 0.18742066893344, ),
	(\absTime: 1.5, \clockTime: 714.64489357443, \dur: 0.5, \kitIndex: 76, \midinote: 76, \playDur: 0.5, \relDur: 0.5, \sustain: 0.19311561746656, ),
	(\absTime: 2.0, \clockTime: 715.12034734383, \dur: 0.0, \kitIndex: 69, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.21531568486671, ),
	(\absTime: 2.0, \clockTime: 715.14864703823, \dur: 0.0, \kitIndex: 74, \midinote: 74, \playDur: 0.0, \relDur: 0.0, \sustain: 0.18492142413334, ),
	(\absTime: 2.0, \clockTime: 715.15259706096, \dur: 0.375, \kitIndex: 76, \midinote: 76, \playDur: 0.375, \relDur: 0.375, \sustain: 0.18525966720006, ),
	(\absTime: 2.375, \clockTime: 715.63316630043, \dur: 0.125, \kitIndex: 74, \midinote: 74, \playDur: 0.125, \relDur: 0.125, \sustain: 0.19812749066659, ),
	(\absTime: 2.5, \clockTime: 715.61015494443, \dur: 0.0, \kitIndex: 69, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.2332598776668, ),
	(\absTime: 2.5, \clockTime: 715.6587547341, \dur: 0.5, \kitIndex: 76, \midinote: 76, \playDur: 0.5, \relDur: 0.5, \sustain: 0.17467593633341, ),
	(\absTime: 3.0, \clockTime: 716.11176667123, \dur: 0.0, \kitIndex: 69, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.24215396766658, ),
	(\absTime: 3.0, \clockTime: 716.13803799783, \dur: 0.0, \kitIndex: 74, \midinote: 74, \playDur: 0.0, \relDur: 0.0, \sustain: 0.19310099506674, ),
	(\absTime: 3.0, \clockTime: 716.16645955823, \dur: 0.5, \kitIndex: 76, \midinote: 76, \playDur: 0.5, \relDur: 0.5, \sustain: 0.16671224466654, ),
	(\absTime: 3.5, \clockTime: 716.62424792816, \dur: 0.0, \kitIndex: 74, \midinote: 74.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.2330031788, ),
	(\absTime: 3.5, \clockTime: 716.6562973093, \dur: 0.0, \kitIndex: 69, \midinote: 69.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.17031967840012, ),
	(\absTime: 3.5, \clockTime: 716.6917377395, \dur: 0.0, \kitIndex: 76, \midinote: 76.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1676489370667, ),
	(\absTime: 3.5, \dur: 0.5, \midinote: 83.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 4.0, \clockTime: 717.13469587476, \dur: 0.0, \kitIndex: 68, \midinote: 68.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.23712808513335, ),
	(\absTime: 4.0, \clockTime: 717.1710442187, \dur: 0.0, \kitIndex: 74, \midinote: 74, \playDur: 0.0, \relDur: 0.0, \sustain: 0.18096534166671, ),
	(\absTime: 4.0, \clockTime: 717.2113820357, \dur: 0.5, \kitIndex: 76, \midinote: 76, \playDur: 0.5, \relDur: 0.5, \sustain: 0.13841885953343, ),
	(\absTime: 4.5, \clockTime: 717.5961912853, \dur: 0.0, \kitIndex: 68, \midinote: 68.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1964902302667, ),
	(\absTime: 4.5, \clockTime: 717.66281196823, \dur: 0.0, \kitIndex: 74, \midinote: 74, \playDur: 0.0, \relDur: 0.0, \sustain: 0.13201995086661, ),
	(\absTime: 4.5, \clockTime: 717.70211493883, \dur: 0.5, \kitIndex: 76, \midinote: 76, \playDur: 0.5, \relDur: 0.5, \sustain: 0.094768296266579, ),
	(\absTime: 5.0, \clockTime: 718.09464375923, \dur: 0.0, \kitIndex: 68, \midinote: 68.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.21918211519994, ),
	(\absTime: 5.0, \clockTime: 718.15998396503, \dur: 0.0, \kitIndex: 74, \midinote: 74, \playDur: 0.0, \relDur: 0.0, \sustain: 0.15073873439997, ),
	(\absTime: 5.0, \clockTime: 718.20786887463, \dur: 0.5, \kitIndex: 76, \midinote: 76, \playDur: 0.5, \relDur: 0.5, \sustain: 0.11692784426668, ),
	(\absTime: 5.5, \clockTime: 718.54324285136, \dur: 0.0, \kitIndex: 68, \midinote: 68.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.24483742886673, ),
	(\absTime: 5.5, \clockTime: 718.66040336583, \dur: 0.0, \kitIndex: 76, \midinote: 76, \playDur: 0.0, \relDur: 0.0, \sustain: 0.10964670226667, ),
	(\absTime: 5.5, \clockTime: 718.61106369843, \dur: 0.5, \kitIndex: 74, \midinote: 74.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.16113521013324, ),
	(\absTime: 6.0, \clockTime: 719.1011845989, \dur: 0.0, \kitIndex: 76, \midinote: 76.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.14734627679991, ),
	(\absTime: 6.0, \clockTime: 719.09812097556, \dur: 0.0, \kitIndex: 74, \midinote: 74.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.14395813979991, ),
	(\absTime: 6.0, \clockTime: 719.05053118536, \dur: 0.375, \kitIndex: 68, \midinote: 68.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.19301755846664, ),
	(\absTime: 6.375, \clockTime: 719.57361669443, \dur: 0.125, \kitIndex: 74, \midinote: 74.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.16715287620002, ),
	(\absTime: 6.5, \clockTime: 719.57654524423, \dur: 0.0, \kitIndex: 76, \midinote: 76.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.16531846293333, ),
	(\absTime: 6.5, \clockTime: 719.49344822236, \dur: 0.375, \kitIndex: 68, \midinote: 68.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25749139846675, ),
	(\absTime: 6.875, \dur: 0.125, \midinote: 74.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.05, ),
	(\absTime: 7.0, \clockTime: 720.03582423256, \dur: 0.0, \kitIndex: 74, \midinote: 74.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.18398359426669, ),
	(\absTime: 7.0, \clockTime: 720.03141491523, \dur: 0.0, \kitIndex: 76, \midinote: 76.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1963430208001, ),
	(\absTime: 7.0, \clockTime: 719.95095429916, \dur: 0.5, \kitIndex: 68, \midinote: 68.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.29015422499981, ),
	(\absTime: 7.5, \clockTime: 720.5294503075, \dur: 0.0, \kitIndex: 74, \midinote: 74.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.22189060446669, ),
	(\absTime: 7.5, \clockTime: 720.46407359636, \dur: 0.0, \kitIndex: 68, \midinote: 68.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.28822041766671, ),
	(\absTime: 7.5, \clockTime: 720.5924906963, \dur: 0.0, \kitIndex: 76, \midinote: 76.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.16066694626659, ),
	(\absTime: 7.5, \dur: 0.5, \midinote: 70.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


NoteTimeline(\cave40_note2).presetCompileString.editorInsert
(
NoteTimeline('cave40_note2').param = Param(Pdef('babass'), 'midinote');
NoteTimeline('cave40_note2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0011248080963924, \label: 'start', \playDur: 0.0011248080963924, \relDur: 0.0011248080963924, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0011248080963924, \clockTime: 3839.2011248081, \dur: 3.4468859094663, \instrument: 'pianpian', \kitIndex: 50, \midinote: 38, \playDur: 3.4468859094663, \relDur: 3.4468859094663, \sustain: 3.375, ),
	(\absTime: 3.4480107175627, \clockTime: 3842.6480107176, \dur: 0.59094962546669, \instrument: 'pianpian', \kitIndex: 45, \midinote: 33, \playDur: 0.59094962546669, \relDur: 0.59094962546669, \sustain: 0.51722703006681, ),
	(\absTime: 4.0389603430294, \clockTime: 3843.238960343, \dur: 2.5143887398667, \instrument: 'pianpian', \kitIndex: 44, \midinote: 32, \playDur: 2.5143887398667, \relDur: 2.5143887398667, \sustain: 2.2048692094663, ),
	(\absTime: 6.5533490828961, \clockTime: 3845.7533490829, \dur: 0.81574111066675, \instrument: 'pianpian', \kitIndex: 44, \midinote: 32, \playDur: 0.81574111066675, \relDur: 0.81574111066675, \sustain: 0.67655633453296, ),
	(\absTime: 7.3690901935629, \clockTime: 3846.5690901936, \dur: 0.51347742946655, \instrument: 'pianpian', \kitIndex: 44, \midinote: 32, \playDur: 0.51347742946655, \relDur: 0.51347742946655, \sustain: 0.42004202880025, ),
	(\absTime: 7.8825676230294, \clockTime: 3847.082567623, \dur: 0.11743237697056, \instrument: 'pianpian', \kitIndex: 44, \midinote: 32, \playDur: 0.11743237697056, \relDur: 0.11743237697056, \sustain: 0.125, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



	KitTimeline(\cave40_perc1).childAt(0).play;
	KitTimeline(\cave40_perc1).wrapper.childAt(0).play
	(
	Tdef(\bla, {
	KitTimeline(\cave40_perc1).wrapper.childAt(0).play;
	0.1.wait;
	KitTimeline(\cave40_perc1).wrapper.childAt(0).play;
	0.1.wait;
	KitTimeline(\cave40_perc1).wrapper.childAt(0).play;
	( 0.1/2 ).wait;
	KitTimeline(\cave40_perc1).wrapper.childAt(0).play;
	0.1.wait;
	KitTimeline(\cave40_perc1).wrapper.childAt(0).play;
		
	}).play;
	)
(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug("track1");
	KitTimeline(\cave40_perc1).wrapper.childAt(noteNum+4+12 % 32).play
});
MIDIdef.noteOff(\track1_off, { arg velocity, noteNum, channel, deviceId;
	[ velocity, noteNum, channel, deviceId ].debug;
	KitTimeline(\cave40_perc1).wrapper.childAt(noteNum+4+12 % 32).stop
});
)


(
ProtoDef(\rdn3).proxy.set(\fb, Ndef(\lfo1, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus3, \audio)), 2); 
	var sig;
	sig = Amplitude.kr(in,add:0.1).pow(2).lagud(0,2).poll * 4;
	
}));
)
~buflib.snare[1579].value
