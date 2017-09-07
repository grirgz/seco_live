
BufDef.loadDialog(\sample1)
(
KitTimeline(\sample1, PatKitDef(\sample1));
KitTimeline(\sample2, PatKitDef(\sample1));
KitTimeline(\sample3, PatKitDef(\sample1));
KitTimeline(\sample4, PatKitDef(\sample1));
KitTimeline(\samplev1, PatKitDef(\sample1));
KitTimeline(\samplev2, PatKitDef(\sample1));
FileSystemProject.load("algokit/lines/KitTimeline_sample1.scd");
FileSystemProject.load("algokit/lines/KitTimeline_sample2.scd");
FileSystemProject.load("algokit/lines/KitTimeline_sample3.scd");
FileSystemProject.load("algokit/lines/KitTimeline_samplev1.scd");
)

KitTimeline(\sample1, PatKitDef(\sample1)).edit
KitTimeline(\sample1, PatKitDef(\sample1)).presetCompileString.editorInsert
PatKitDef(\sample1).presetCompileString.editorInsert;
PatKitDef(\sample1).edit
PatKitDef(\sample1).presetCompileStringSavePath = "algokit/kits/PatKitDef_sample1.scd"
PatKitDef(\sample1).clear



(
TrackDef(\grid1, TrackDef(\playergrid));
TrackDef(\grid1).source = [
	[
		ProtoDef(\rdn)
	],
	[
		KitTimeline(\sample1),
		Pdef(\smpremix),
		KitTimeline(\sample2),
		KitTimeline(\sample3),
		KitTimeline(\sample4),
	],
	[
		Pdef(\drums)
	],
	[
		KitTimeline(\samplev1),
		KitTimeline(\samplev2),
	],
	[
		ProtoDef(\rdn2, ProtoTemplateDef(\rdn))
	],
	[
		Pdef(\scratch)
	],
];
4.do { arg idx; TrackDef(\grid1).childAt(idx).mixer.play; };
);

//TrackDef(\grid1).edit;
WindowDef(\multigrid).front;
(
Pdef(\smpremix, 
	Pseq([
		KitTimeline(\sample1).asPattern(0,4).source,
		KitTimeline(\sample1).asPattern(0,2).source,
		KitTimeline(\sample1).asPattern(0,1).source,
		KitTimeline(\sample1).asPattern(6,1).source,
		KitTimeline(\sample1).asPattern(0,8).source,
	],4)
).play;
)


KitTimeline('sample2', PatKitDef(\sample1)).edit
Pdef(\drums, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).stop;
KitTimeline('sample3', PatKitDef(\sample1)).edit
KitTimeline('samplev1', PatKitDef(\sample1)).edit

(
SynthDef(\scratch, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	var range = \range.kr(0.1);
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum)) * (SinOsc.ar(\lfofreq.kr(2)).range(0,\range.kr(0.1)) +1);
	phase = (LFTri.ar(\lfofreq.kr(1)/range/2, 2/4).range(0,range).lag(\flag.kr(0.1)) +1) + \pos.kr(0.2) / BufDur.kr(bufnum) * BufFrames.kr(bufnum);
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	sig = BufRd.ar(2, bufnum, phase);
	sig = AllpassC.ar(sig, 1/2, LFSaw.ar([52.0001,52]/4 * XLine.kr(2.01,[1/3,1/3.002],[3.01,3.1])).unipolar*0.3* XLine.kr(1.01,2,4), 0.005);
	sig = RLPF.ar(sig, \lpf.kr(5000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\scratch, PmonoArtic(  \scratch,
	\bufnum, BufDef('smp/beastie.flac'),
	\lfofreq, 2,
	\lfofreq, Pseq([
		2,2,2,2,2,2,
		1,1,1,2,2,2,
	],inf) * 1 * ~t / 4,
	\flag, 0.0,
	\legato, Pseq([
		1,1,1, 1,1,1,
		1,1,1, 1,1,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\range, 1/47,
	\pos, 2.9,
	\degree, Pseq([0],inf),
	\dur, 1/3,
	\amp, 0.3,
)).play;
);


ProtoDef(\rdn).presetCompileString.editorInsert
(
// nice ambiance, good perc!
RandDelayNetwork('deldefault').make('rdn', "4-PHHP-6IJ3");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.59663865546218,
	'gain', 1.7435855820224,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.00017869024337358,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.1,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.32494978841347,
	'fbdistmix', 0.91596638655462,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.20503372119697,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

MasterEQ(2);
MasterEQ.start;

(
SynthDef(\scratch2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	var range = \range.kr(0.1);
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum)) * (SinOsc.ar(\lfofreq.kr(2)).range(0,\range.kr(0.1)) +1);
	phase = (LFTri.ar(freq * ( [1,2,4] /400 +1) * ( 1 + ( SinOsc.ar(\lfofreq.kr(4)*~t) * 1 )) , 2/4).unipolar * \range.kr) + \pos.kr(0.2).lag(1.7)* ((1..3)/\fspread.kr(18)+1) / BufDur.kr(bufnum) * BufFrames.kr(bufnum);
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase.debug("phase");
	sig = BufRd.ar(2, bufnum, phase);
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sig");
	//sig = AllpassC.ar(sig, 1/2, LFSaw.ar([0.0001,0]+( 40*~t )).unipolar*1/2* XLine.kr(1.01,1,4), 0.00);
	sig = RLPF.ar(sig, \lpf.kr(15000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\scratch2, PmonoArtic(  \scratch2,
	\bufnum, BufDef('smp/beastie.flac'),
	\lfofreq, 2,
	\lfofreq, Pseq([
		1,2,4,5,8,8,
		 32, 32, 32,
		 32, 32, 32,
		 32, 32, 32,
		 32, 32, 32,
		 Pseq([
		 	32, 32, 32,
			32, 32, 32,
			32, 32, 32,
			32, 32, 32,
		 ]*2,1),
		 Pseq([
		 	32, 32, 32,
			32, 32, 32,
			32, 32, 32,
			32, 32, 32,
		 ]*4,1),
	],inf) * 1 * ~t / 1 * 8,
	\lfofreq, Pseq([8,4,4,1],inf)*1/~t,
	\freq, 55,
	\flag, 0.0,
	\legato, Pseq([
		1,1,0,1, 0,1,0,0,
		1,1,0,1, 0,1,0,1,
	],inf),
	\fspread, 10000,
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\range, 1/121,
	\pos, Pwhite(1,2.0).stutter(8)+3.0,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 1.0,
)).play;
);

(
Pdef(\scratch2, PmonoArtic(  \scratch2,
	\bufnum, BufDef('smp/beastie.flac'),
	\lfofreq, 2,
	\lfofreq, Pseq([
		1,2,4,5,8,8,
		 32, 32, 32,
		 32, 32, 32,
		 32, 32, 32,
		 32, 32, 32,
		 Pseq([
		 	32, 32, 32,
			32, 32, 32,
			32, 32, 32,
			32, 32, 32,
		 ]*2,1),
		 Pseq([
		 	32, 32, 32,
			32, 32, 32,
			32, 32, 32,
			32, 32, 32,
		 ]*4,1),
	],inf) * 1 * ~t / 1 * 8,
	\lfofreq, Pseq([8,4,4,1],inf)*1/~t,
	\lfofreq, 8,
	\freq, 55,
	\flag, 0.0,
	\legato, Pseq([
		1,1,0,1, 0,1,0,0,
		1,1,0,1, 0,1,0,1,
	],inf),
	\fspread, 10000,
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\range, 1/121,
	\pos, Pwhite(1,2.0).stutter(8)+3.0,
	\pos, 4.5,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 1.0,
)).play;
);

(
SynthDef(\scratch3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pos=0;
	var sig;
	var phase;
	var range = \range.kr(0.1);
	var speed;
	var imp = Impulse.ar(\afreq.kr(4*~t));
	speed = EnvGen.kr(\speedenv.kr(Env([1,1,-1,-1],[0.1,1/4,0.1])), imp, timeScale:\speedenvts.kr(1)).lag(\elag.kr(1)) * \speed.kr(1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, 1, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: 1);
	sig = sig * EnvGen.kr(Env([0,0,1,1,0],[0,0.01,0.8,0.01]), imp, timeScale: \atimescale.kr(1/8));
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sig");
	//sig = AllpassC.ar(sig, 1/2, LFSaw.ar([0.0001,0]+( 40*~t )).unipolar*1/2* XLine.kr(1.01,1,4), 0.00);
	//sig = RLPF.ar(sig, \lpf.kr(15000), \rq.kr(0.5));
	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\scratch3, 
	Pseq([
		Pbind(
			\bufnum, BufDef('loop/funky1_96bpm.flac'),
			\bufnum, BufDef('smp/beastie.flac'),
			\instrument, \scratch3,
			\atimescale, 1/8,
			\speedenv, Pseq([
				[ Env([-1,-1,1,1],[0.1,0.8,0.34]*4) ],
				[ Env([-1,-1,0.92,1],[0.1,0.8,0.34]/4) ],
			],inf),
			\pos, 0.21,
			\afreq, 8*~t,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,1,1,1,
				1,1,0,1, 1,1,1,0,
				1,0,1,1,
			],1).coin.not,
			\speed, Pseq([1],inf),
			\legato, 1,
			\dur, 4/1,
			\amp, 0.8
		),
		Pbind(
			\bufnum, BufDef('smp/beastie.flac'),
			\instrument, \scratch3,
			\speedenv, Pseq([
				[ Env([0,1,1,1],[0.1,0.8,0.34]/2) ]
			],inf),
			\isRest, Pseq([
				1,
			],1).coin.not,
			\freq, 200,
			\pos, 0.21,
			\speed, Pseq([1],inf),
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1
		),
	],inf),
).play;
);


(
Pdef(\main, 
	Pseq([
		Pdef(\testdrums)
		
	])
).play;
)

(
Pdef(\scratch3, 
	Pseq([
		Pbind(
			\bufnum, BufDef('loop/funky1_96bpm.flac'),
			\bufnum, BufDef('smp/beastie.flac'),
			\instrument, \scratch3,
			\atimescale, 1/8,
			\speedenvts, Pseq([1,2,8,1/8],inf),
			\afreq, Pseq([1,2,1/2,1/4],inf)* 8*~t,
			\speedenv, Pseq([
				//[ Env([-1,-1,1,1],[0.1,0.8,0.34]*4) ],
				//[ Env([-1,-1,0.92,1],[0.1,0.8,0.34]/4) ],
				//[ Env([-2,-1,0.92,1],[0.1,0.8,0.34]/4) ],
				[ Env([1,-1,0,-1],[0.01,0.8,0.04]/18) ],
			],inf),
			\pos, 0.31,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([1],inf),
			\legato, 1,
			\dur, 1/4,
			\amp, 0.8
		),
	],inf),
).play;
)
