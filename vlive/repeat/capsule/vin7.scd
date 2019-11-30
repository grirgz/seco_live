(
	~t = 147/4/60; TempoClock.default.tempo = ~t;
ProtoDef(\rdn, ProtoTemplateDef(\rdn));
ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
ProtoDef(\rdn4, ProtoTemplateDef(\rdn));
~master = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
	//ProtoDef(\rdn3).play;
};
~master.();
)

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * \midi.kr([0,4,7]).midiratio * [1/2,1,2];
	sig1 = SinOsc.kr((1..9)/10).range(0,1);
	sig2 = SinOsc.kr((1..9)/20).range(0,1);
	sig = SinOsc.ar(freq) * SinOsc.ar(freq+sig2, SinOsc.ar(freq+2+sig1), 1, SinOsc.ar(freq+2+sig2) );
	pan = LFNoise1.kr((1..9)/75).range(-1,1);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
SynthDef(\serenity, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * \ratio.kr([0,4,7]) * [1/2,1,2];
	sig1 = SinOsc.kr((1..9)/10).range(0,1);
	sig2 = SinOsc.kr((1..9)/20).range(0,1);
	sig = SinOsc.ar(freq) * SinOsc.ar(freq+sig2, SinOsc.ar(freq+2+sig1), 1, SinOsc.ar(freq+2+sig2) );
	pan = LFNoise1.kr((1..9)/75).range(-1,1);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

Pdef(\zed).clear;
(
Pdef(\zed, 
	Pbind(
		\instrument, \serenity,
		\degree, Pseq([0,3,2,1],inf),
		\ratio, Pseq([
			[[0,4,7]],
			[[0,3,7]],
		].midiratio,inf),
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,1.8) ],
		],inf),
		\dur, 1,
		\amp, 0.1,
	).trace
).play;
);

(
~master.();
Pdef(\part, Pdef(\zed, 
	Pbind(
		\out, BusDef(\sendbus1, \audio),
	)<>
	Ppar([
		Pmono(\serenity,
			\degree, Pseq([0,3,2,1],inf),
			\ratio, Pseq([
				[[0,4,7]],
				[[0,3,7]],
			],inf).midiratio,
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\serenity,
			\degree, Pstep(Pseq([0,3,2,1],inf),1),
			\ratio, Pseq([
				[[0,0,0]],
				[[0,1,0]],
				[[4,0,7-12]],
			],inf).midiratio,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono(\serenity,
			\degree, Pstep(Pseq([0,3,2,1],inf),1),
			\ratio, Pseq([
				[[3,2,1]],
				[[7,0,3]],
				[[7,7,12]],
				[[0,7,0]],
				[[4,4,-12]],
			],inf).midiratio,
			\octave, 6,
			\dur, 1/6,
			\amp, 0.1/2,
		),
	])
)).play;
);


(
Pdef(\part2, Pdef(\perc, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,1,0,0, 0,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.15,
			\fac1,0.1,
			\dur, 1/8,
			\lag, 0.04,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\lag, 0.04,
			\gain, 0.3 * Pseq([
				Pseq([
					1,0.7,
				],7),
				1,1,
				0.7,0.5,
				Pseq([
					1,0.7,
				],7),
				0.7, 1,

			],inf),
			\dur, 1/16,
		))
		
	])
)).play;
);


SampleTimeline(\vin7).edit
ClipTimeline(\vin7).edit
ClipTimeline(\vin7).presetCompileString
 SampleTimeline('rec_vin7_t0_191014_235036').presetCompileString
 SampleTimeline('rec_vin7_t0_191014_235036').bufferInfo
 SampleTimeline('rec_vin7_t0_191014_235036').buffer
 SampleTimeline('rec_vin7_t0_191014_235036').buffer = BufDef("/tmp/rec_vin7_t0_191014_235036.wav")
 SampleTimeline('rec_vin7_t0_191014_235036')[\buffer = BufDef("/tmp/rec_vin7_t0_191014_235036.wav")
 BufDef("/tmp/rec_vin7_t0_191014_235036.wav")

~chord = SampleTimeline('rec_vin7_t0_191015_000922').buffer;
~kick = SampleTimeline('rec_vin7_t1_191015_000922').buffer;
~snare = SampleTimeline('rec_vin7_t2_191015_000922').buffer;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~chord,
			\legato, 1,
			\pos, Pseq([
				Pseq([
					0,1,4
				],1).stutter(4),
				1/2,1,2,3.12,
			],inf),
			\dur, 1/4,
			\gain, 1,
		),
		Psched(2,Pbind(
			\instrument, \playersec,
			\bufnum, ~kick,
			\legato, 1,
			\pos, Pseq([
				0,
			],inf),
			\dur, 1/4,
			\gain, 1,
		)),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~snare,
			\legato, 1,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\pos, Pseq([
				1/4,
			],inf)/~t,
			\dur, 1/4,
			\gain, 1,
		)),
		Psched(3,Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.15,
			\fac1,0.1,
			\dur, 1/16,
			\lag, 0.04,
			\amp, 0.01 * Pseq([1,0.7],inf),
		)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Pseq([
		Psched([0,2],Pbind(
			\instrument, \playersec_looper,
			\trigfreq, ~pmodenv.(Pseq([1,44],inf), 8),
			\bufnum, ~kick,
			\legato, 1,
			\pos, Pseq([
				0,
			],inf),
			\dur, 1/4,
			\gain, 1,
		)),
		Psched([0,2],Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Pseq([1,100,30,20],inf),
			\bufnum, ~kick,
			\legato, 1,
			\pos, Pseq([
				0,
			],inf),
			\dur, 1/4,
			\gain, 1,
		)),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Psched([0,inf],Pbind(
			\instrument, \playersec_looper,
			\trigfreq, ~pmodenv.(Pseq([1,44],inf), 8),
			\bufnum, ~kick,
			\legato, 1,
			\pos, Pseq([
				0,
			],inf),
			\dur, 1/4,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		)),
		Psched([0,inf],Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Pseq([1,100,30,20],inf) + Pseg(Pseq([0,0,100],1),8).loop,
			\bufnum, ~snare,
			\speed, Pseq([
				1,1,1.2,
			],inf),
			\legato, 1,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\pos, Pseq([
				1/4,
			],inf)/~t,
			\dur, 1/4,
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		)),
		Psched([4,inf],Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Pseq([1],inf) + Pseg(Pseq([0,0,10],1),2).loop,
			\bufnum, ~snare,
			\speed, Pseq([
				1,1,1.2,
			],inf),
			\legato, 1,
			\isRest, Pseq([
				0,0,1,0
			],inf).coin.not,
			\pos, Pseq([
				1/4,
			],inf)/~t,
			\dur, 1/4,
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~chord,
			\legato, 1,
			\pos, Pseq([
				Pseq([
					0,1,4
				],1).stutter(4),
				1/2,1,2,3.12,
			],inf),
			\dur, 1/4,
			\gain, 1,
			\out, BusDef(\sendbus3, \audio),
		),
		Psched(2,Pbind(
			\instrument, \playersec,
			\bufnum, ~kick,
			\legato, 1,
			\pos, Pseq([
				0,
			],inf),
			\dur, 1/4,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		)),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~snare,
			\legato, 1,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\pos, Pseq([
				1/4,
			],inf)/~t,
			\dur, 1/4,
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		)),
		Psched(3,Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.15,
			\fac1,0.1,
			\dur, 1/16,
			\lag, 0.04,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus2, \audio),
		)),
		
	])
)).play;
);





///////////////



(
	~master.();
	~swing = 0.16;
Pdef(\part, Pdef(\perck1, 
		
	Pbind( 
		\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
	) <>
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,1,0,0, 0,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.15,
			\fac1,0.1,
			\dur, 1/16,
			\lag, 0.04,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\amp, 0.01 * Ppatlace([Pseg(Pseq([1,0.01,0.71],inf),Pseq([4,3,5,2],inf)), Pseg(Pseq([0.01,0.71],inf),Pseq([3,5,2],inf))],inf),
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\lag, 0.04,
			\gain, 0.3 * Pseq([
				Pseq([
					1,0.7,
				],7),
				1,1,
				0.7,0.5,
				Pseq([
					1,0.7,
				],7),
				0.7, 1,

			],inf),
			\dur, 1/16,
		))
		
	])
)).play;
);

(
	~master.();
	~swing = 0.16;
Pdef(\part, Pdef(\perck2, 
		
	Pbind( 
		//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
	) <>
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.3,
			\pos, 1.5 + Pseq([0,0.2,0,0.5],inf),
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.3,
			\pos, 1.5 + Pseq([0,0.2,0,0.5],inf),
			\gain, 0.2,
			\dur, 1/4,
			\out, BusDef(\sendbus3, \audio),
		)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Pseq([
		Pfindur(6, Pdef(\perck1)),
		Pfindur(2, Pdef(\perck2)),
	],inf),
)).play;
);


SampleTimeline(\satsnare).edit
ClipTimeline(\satworld).edit
ClipTimeline(\satworld).startRecording
ClipTimeline(\satworld).stopRecording
Pdef(\part).stop


(
	~master.();
Pdef(\part, Pdef(\zed, 
	Pbind(
		\out, BusDef(\sendbus2, \audio),
	) <>
	Ppar([
		Pmono(\serenity,
			\degree, Pstep(Pseq([0,6,11],inf),1/8),
			\ratio, Pseq([
				[[3,2,1]],
				[[0,7,9]],
			],inf).midiratio,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Pbind(
		\out, BusDef(\sendbus2, \audio),
	) <>
	Ppar([
		Pmono(\serenity,
			\degree, Pstep(Pseq([0,6,11],inf),1),
			\ratio, Pseq([
				//[[3,2,1]],
				[[0,7,9]],
			],inf).midiratio,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\reckick, 
	Pbind(
		\out, BusDef(\sendbus1, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\recsnare, 
	Pbind(
		\out, BusDef(\sendbus2, \audio),
			\dur, 1/4,
	) <>
	Ppar([
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\rechat, 
	Pbind(
		\out, BusDef(\sendbus3, \audio),
			\dur, 1/4,
	) <>
	Ppar([
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			].clump(8).choose}.dup(64).flat,inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/16,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			].clump(8).choose}.dup(64).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 1/2 * Pseq([1,0.7],inf),
			\dur, 1/16,
		))
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\reckick2, 
	Pbind(
		\out, BusDef(\sendbus1, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\reckick),
		Pdef(\recsnare),
		
	])
)).play;
);
1+1
SampleTimeline('rec_satworld_t2_191019_185702').clear
ClipTimeline(\satworld).samplesPresetCompileString.editorInsert
(
SampleTimeline('rec_satworld_t1_191019_185110').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 86.0, \label: 'start', \playDur: 86.0, \relDur: 86.0, \sustain: 0, \type: 'start', ),
	(\absTime: 86.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_satworld_t1_191019_185110').buffer = BufDef('./rec_satworld_t1_191019_185110.wav');

SampleTimeline('rec_satworld_t2_191019_185702').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 66.0, \label: 'start', \playDur: 66.0, \relDur: 66.0, \sustain: 0, \type: 'start', ),
	(\absTime: 66.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_satworld_t2_191019_185702').buffer = BufDef('./rec_satworld_t2_191019_185702.wav');

SampleTimeline('rec_satworld_t3_191019_194553').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 66.0, \label: 'start', \playDur: 66.0, \relDur: 66.0, \sustain: 0, \type: 'start', ),
	(\absTime: 66.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_satworld_t3_191019_194553').buffer = BufDef('./rec_satworld_t3_191019_194553.wav');
)

ClipTimeline(\satworld).presetCompileString.editorInsert
(
ClipTimeline('satworld').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 36, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 42, 'muted': true ), ( 'index': 2, 'recordArmed': false, 'recordBus': 42, 'muted': false ), ( 'index': 3, 'recordArmed': true, 'recordBus': 48, 'muted': false ) ];
ClipTimeline('satworld').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 64.0, \timeline: { SampleTimeline('rec_satworld_t1_191019_185110') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \midinote: 2, \playDur: 0.0, \relDur: 0.0, \sustain: 64.0, \timeline: { SampleTimeline('rec_satworld_t2_191019_185702') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 64.0, \midinote: 3, \playDur: 64.0, \relDur: 64.0, \sustain: 64.0, \timeline: { SampleTimeline('rec_satworld_t3_191019_194553') }, \type: 'pattern', )),
	(\absTime: 64.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);





(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pbind(
		\out, BusDef(\sendbus2, \audio),
	) <>
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0,0, 
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/2,
		)),
		
	])
)).play;
);


(
SynthDef(\echhhi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,19420,182],[3.4,5.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,10100,152],[3.4,4.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	//sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	//sig = sig * ( SinOsc.ar(7700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	//sig = LPF.ar(sig,  env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part, 
	Pbind(
		\out, BusDef(\sendbus2, \audio),
		\instrument, \echhhi,
		\freq, 200,
		\legato, 1,
		\dur, Pn(2,inf),
		\isRest, Pseq([
			1,0,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\amp, 0.1/2,
	),
).play;
)

////////////////////////j

(
SynthDef(\ploux, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var dust;
	dust = Dust.ar(\dustfreq.kr(2));
	dust = Decay.ar(dust, \dustdecay.kr(0.7));
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmfreq.kr(100) * dust) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pspawner({ arg sp;
			20.do {
				sp.par(
					Pbind(
						\out, BusDef(\sendbus1, \audio),
						\instrument, \ploux,
						\dustfreq, Pseg(Pseq([0,Pn(0,5),11,11],inf),4),
						\dustdecay, Pseg(Pseq([0,Pn(0,5),11,11],inf),5),
						\fmdecay, Pseg(Pseq({ rrand(40,400) }.dup(5),inf),5),
						\freq, exprand(60,13000),
						\legato, rrand(0.1,0.9),
						\dur, rrand(1/16,4),
						\amp, 0.1,
					),
				);
				sp.wait(10.0.rand);
			}
		})
	])
)).play;
);


(
	~crossfade = { arg val, argname=\freq, crossarg=\cross;
		Pfunc({ arg ev; val * ev[crossarg] + ( ev[argname] * ( 1-ev[crossarg] ) ) })
	};
	ProtoDef(\rdn).play;
Pdef(\part, Pdef(\ploux, 
	Ppar([
		Pspawner({ arg sp;
			~startCrossfade = false;
			sp.par(
				Psched(16*2 +8,Pbind(
					\play, {
						"startCrossfade".debug;
						topEnvironment[\startCrossfade] = true;
					},
					\dur, Pn(1,1),
				)),
			);
			20.do {
				sp.par(
					Pseq([
						Pwhile({ "waiting".debug(~startCrossfade); ~startCrossfade.not }, Pfindur(1,Pbind() )),
						//Pfindur(4,Pbind()),
						Pbind(
							\cross, Pseg(Pseq([0,Pn(1,inf)],inf),4),
							\freq, ~crossfade.(100, \freq),
							\dur, ~crossfade.(4, \dur),
						),
					],inf) <>
					Pbind(
						\out, BusDef(\sendbus1, \audio),
						\instrument, \ploux,
						\dustfreq, Pseg(Pseq([0,Pn(0,5),11,11],inf),4),
						\dustdecay, Pseg(Pseq([0,Pn(0,5),11,11],inf),5),
						\fmdecay, Pseg(Pseq({ rrand(40,400) }.dup(5),inf),5),
						\freq, exprand(60,13000),
						\legato, rrand(0.1,0.9),
						\dur, exprand(1/16,4),
						\amp, 0.1,
					),
				);
				sp.wait(4.0.rand);
			}
		})
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\ploux),
		Pseq([
			//Pwhile({ "waiting".debug(~startCrossfade); ~startCrossfade.not }, Pfindur(8,Pbind() )),
			Psched([0,16*2+8], Pbind(
				\isRest, Pseq([
					0,0,0,1, 0,0,0,0,
					1,1,1,0, 1,0,1,1,
					Pseq([
						1
					],inf),
				],inf).coin.not,
			)),
			//Pfindur(4,Pbind()),
			//Psched([0,4], Pbind()),
			Pbind(
				\cross, Pseg(Pseq([0,Pn(1,inf)],inf),8),
				\lag, ~crossfade.(0, \lag),
				\dur, ~crossfade.(1/8, \dur),
				\legato, ~crossfade.(1, \legato),
				\pos, Pseq([4,14,2,14, 4,14,1,14, 4,8,6,14],inf)/~t + 0.04 + Pkey(\lag),
			),
		],inf) <>
		Pbind(
			\instrument, \playersec_hlpf,
			\out, BusDef(\sendbus2, \audio),
			\mixlpf, 1,
			\lpf, 3000,
			\speed, ~pmodenv.(Pseq([1,0.2,1,1.4],inf), Pwhite(1,8.0,inf)),
			\bufnum, SampleTimeline(\rec_satworld_t1_191019_185110).buffer,
			\lag, Pwhite(0,0.3),
			\lag, Pseg(Pseq([0,0,0,1/2],inf),4),
			\pos, Pseq([4,14,2,14, 4,14,1,14, 4,8,6,14],inf)/~t + 0.04 + Pkey(\lag),
			\legato, Pwhite(0.1,1),
			\legato, Pseg(Pseq([1,1,0.1],inf),5),
			\dur, 1,
			\gain, 1,
		),

		Pseq([
			//Pwhile({ "waiting".debug(~startCrossfade); ~startCrossfade.not }, Pfindur(8,Pbind() )),
			Psched([0,16*2+8], Pbind()),
			//Pfindur(4,Pbind()),
			//Psched([0,4], Pbind()),
			Pbind(
				\cross, Pseg(Pseq([0,Pn(1,inf)],inf),8),
				\lag, ~crossfade.(0, \lag),
				\dur, ~crossfade.(1/8, \dur),
				\legato, ~crossfade.(1, \legato),
				\pos, Pseq([4,14,2,14, 4,14,1,14, 4,8,6,14],inf)/~t + 0.04 + Pkey(\lag),
			),
		],inf) <>
		Pbind(
			\instrument, \playersec_hlpf,
			\out, BusDef(\sendbus3, \audio),
			\mixhpf, 0,
			//\hpf, 13000,
			\speed, ~pmodenv.(Pseq([1,0.2,1,1.4],inf), Pwhite(1,8.0,inf)),
			\bufnum, SampleTimeline(\rec_satworld_t1_191019_185110).buffer,
			\lag, Pwhite(0,0.3),
			\lag, Pseg(Pseq([0,0,0,1/2],inf),4),
			\pos, Pseq([4,14,2,14, 4,14,1,14, 4,8,6,14]+1.2,inf)/~t + 0.04 + Pkey(\lag),
			\legato, Pwhite(0.1,1),
			\legato, Pseg(Pseq([1,1,0.1],inf),5),
			\dur, 1.1,
			\gain, 1,
		),

	])
)).play;
);

(
[\rdn, \rdn2, \rdn3, \rdn4].collect({ arg key;
	ProtoDef(key).presetCompileString;
}).join("\n\n").editorInsert
)
(
ProtoDef('rdn').make('deldefault', 'rdn', "4-LCSL-PJQU", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.89038909412967,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 45.673455020088,
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


ProtoDef('rdn2').make('deldefault', 'rdn2', "4-GPS9-D75H", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.95504173856142,
	'gain', 0.69327731092437,
	'fb', 0.00099281392423591,
	'delay', 0.0010195378685327,
	'delay2', 0.0001,
	'shift', 0,
	'shift2', 0,
	'distamp', 0.96204032710648,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.065814647859375,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));


ProtoDef('rdn3').make('deldefault', 'rdn3', "4-CEVA-H0TA", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0052997797722,
	'gain', 1,
	'fb', 0.001,
	'delay', 0.035860954820118,
	'delay2', 0.76269858590234,
	'shift', 0,
	'shift2', 0.084033613445378,
	'distamp', 35.173735009694,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 579.71544293021,
	'lpf', 1197.6803383227,
	'hpf', 2699.4923215797,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 1555.2001812076,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));



);

