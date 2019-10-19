(
	~t = 147/4/60; TempoClock.default.tempo = ~t;
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

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Pbind(
		\out, BusDef(\sendbus2, \audio),
			\dur, 1/4,
	) <>
	Ppar([
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/4,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		
	])
)).play;
);

SampleTimeline(\satsnare).edit
ClipTimeline(\satworld).edit
Pdef(\part).stop

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Pbind(
		\out, BusDef(\sendbus2, \audio),
	) <>
	Ppar([
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
	~master.();
Pdef(\part, Pdef(\zed, 
	Pbind(
		\out, BusDef(\sendbus2, \audio),
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
				1,0,0,0, 1,0,0,0,
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

{ SinOsc.ar(200 * ( SinOsc.kr(1/2) * 1 + 1 )) ! 2 * 0.1}.play;



(instrument:\bla).keys
().instrument
Event.default.instrument
Event.default.keys
