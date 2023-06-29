
// start again file naming at sun20 because some files were lost

~t = 150/4/60; TempoClock.default.tempo = ~t;

////////////////////////////////////////////////////

(
SynthDef(\kopchord_simple, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,2,1],[0.1,0.8]/4), 1);
	env2 = EnvGen.kr(Env([0,0.1,1],[0.1,1.8]), 1);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq + freq.log10) * 30.9 * env2 + 1 ));
	sig = sig.fold2(( ( 200/freq.sqrt ) * LFNoise1.kr((1..10)/10).range(0.5,2.0) / (1..10) / 4 * env1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + Rand(-1,1!10), amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\kopchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,2,1],[0.1,0.8]/4), 1);
	env2 = EnvGen.kr(Env([0,0.1,1],[0.1,1.8]), 1);
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq + freq.log10) * \fma.kr(30.9) * env2 + 1 ));
	sig2 = SinOsc.ar(freq * ( SinOsc.ar(freq + freq.log10) * \fma.kr * env2 + 1 ));
	sig = SelectX.ar(\wavemix.kr(0.5), [sig, sig2]);
	sig = sig.fold2(( ( 200/freq.sqrt ) * LFNoise1.kr((1..10)/10).range(0.5,2.0) / (1..10) / 4 * env1 ));
	sig1 = RLPF.ar(sig, ( \lpfr.kr(7.1) * freq ).clip(1,19000), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig3 = AllpassL.ar(sig, 0.1,0.001 * LFNoise1.kr(1/2).range(0.0,1.0),0.1) + sig / 2;
	sig = SelectX.ar(\passmix.kr(0.8), [sig, sig3]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + Rand(-1,1!10), amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffac=8;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		//var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 5;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\chordc, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffac=8, xfac=1;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		//var ffac = 8;
		x = xfac * x;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, ( freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) ).clip(20,20000) , \rq.kr(0.5));
	}!5;
	//sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(\scramblefreq.kr(0)),\scramblelag.kr(0));
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 5;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bilin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!100) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
);

(
SynthDef(\tredrone, { arg lagf=0, freq=200, pan=0, amp=0.1, out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(lagf);
	freq = freq * [1, 5/3];
	sig = LFPulse.ar(freq * ( 1 + ( CuspL.ar(\cusfreq.kr(10) + [1,2,3],\cus2.kr(1.1),\cus3.kr(1)).lag(0.1) * ( CuspL.ar(0.1)/3 + 0.1+[ [0,0.01] ] ) * \fma.kr(1) ))).mean;
	sig.debug("kjkj");
	sig = sig /13;
	sig1 = sig;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq.lag(1) * SinOsc.kr(1*~t * [1,3/5]).range(0,1), \rq.kr(0.5));
	sig = sig + BPF.ar(sig1, freq.lag(1) * 8);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\sinchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * [1/2,1,2];
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\chordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = RLPF.ar(sig, env2 * \lpf.kr(1000), 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fmgbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq/2), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig * 3;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

////////////////////////////////////////////////////

0.2.log
( (1..10000) ).log.clip(0.1,10000).log.plot
( (1..10000)/100 ).log.clip(0.1,10000).log.plot

( (1..10000) ).pow(1/2).plot
( (1..10000)/100 ).log.abs.log
(-1).log
0.log

(
Pdef(\zed, 
	Pbind(
		\instrument, \kopchord,
		\note, Pseq([
			5, 9, 14, 9, 
			5, 10, 14, 5,
			4, 8, 14, 8,
			4, 9, 13, 4,
		],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, 
	Pbind(
		\instrument, \kopchord,
		\note, Pseq([
			5, 9, 14,
			5, 10, 14,
			4, 8, 14,
			4, 9, 13,
		].clump(3),inf),
		\dur, 2,
		\octave, Ptuple(Pbrown(3,7,1,inf)!3),
		//\octave, 7,
		\fma, 30.91,
		\legato, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				5, 9, 14,
				5, 10, 14,
				4, 8, 14,
				4, 9, 13,
			].clump(3),inf),
			\dur, 2,
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			//\octave, 7,
			\fma, 30.91,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pser([
					14, 17, 21, 
				],8*3),
				Pser([
					13, 17, 21, 
				],8),
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				5, 9, 14,
				5, 10, 14,
				4, 8, 14,
				4, 9, 13,
			].clump(3),inf),
			\dur, 1,
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			//\octave, 7,
			\fma, 30.91,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pser([
					14, 17, 21, 
				],8*3),
				Pser([
					13, 17, 21, 
				],8),
			],inf),
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pstep(Pseq([
					Pser([
						14, 17, 21, 
					],8*3),
					Pser([
						13, 17, 21, 
					],8),
				],1),1/8),
			],inf),
			//\octave, Ptuple(Pbrown(3,7,1,inf)!1),
			\fma, 1,
			\octave, 2,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[915].value,
			\speed, 1.1,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, Pseq([1,1.2,1.3,1.2],inf).stutter(2)*1.3 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				Pseq([
					0, 2,
				],2),
			],1),2).loop / Pkey(\st),
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,5,
				1,1,1,1, 5,1,1,1,
				1,6,1,4, 5,1,1,1,
			],inf),
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,0,-1,0],inf))),
			\gain, 0.11,
			\gain, Pkey(\gain) * Pseq([
				Pseq([
					0.2,1,
				],16+8),
				Pseq([
					0.8,1,
				],4),
				Pseq([
					0.9,0.31,
				],4),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2323].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0, 1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			Pbind(
				\instrument, Prand([\bilin,\chordb,\sinchord,\chordo,\tredrone],inf),
				\note, Pseq([
					5, 9, 14,
					5, 10, 14,
					4, 8, 14,
					4, 9, 13,
				].clump(3),inf).collect({ arg x; x.choose }),
				\dur, 2,
				\octave, Pbrown(3,6,1,inf).trace,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.9) ],
				],inf),
				\legato, 1,
				\amp, 0.1,
			)!8,
		),
		//Pbind(
			//\instrument, \default,
			//\note, Pindex([9,10,14],Pbrown(0,2,1,inf)),
			//\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			//\dur, Prand(1/(1..10),inf),
			//\octave, 6,
			//\amp, 0.1,
		//),
		Pmono(
			\tredrone,
			\cus3, { rrand(0.01,10) }.dup(3),
			\fma, 0.01,
			\cus2, [1,2,3]*10,
			\cusfreq, [1,2,3]/3,
			\lpfr, 2,
			\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\note, Pindex([9,10,14],Pbrown(0,2,1,inf)),
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\dur, Prand(1/(1..10),inf),
			\octave, 6,
			\amp, 0.1 * Pwhite(1,2),
		),
		Pmono(
			\tredrone,
			\cus3, { rrand(0.01,10) }.dup(3),
			\fma, 0.01,
			\cus2, [1,2,3]*10,
			\cusfreq, [1,2,3]/3,
			\lpfr, 2,
			\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
			\note, Pindex([9,10,14],Pbrown(0,2,1,inf)),
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
			\dur, Prand(1/(1..10),inf),
			\octave, 6,
			\amp, 0.1,
			\amp, 0.1 * Pwhite(1,2),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
			Pbind(
				\instrument, Prand([\bilin,\chordb,\sinchord,\chordo,\tredrone],inf),
				\note, Pseq([
					5, 9, 14,
					5, 10, 14,
					4, 8, 14,
					4, 9, 13,
				].clump(3),inf).collect({ arg x; x.choose }),
				\dur, 2,
				\octave, Pbrown(3,6,1,inf).trace,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.9) ],
				],inf),
				\legato, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \fmgbass,
				\note, Pstep(Pseq([
					5,9, 5,10, 8,4, 9,4,
				],inf),1),
				\dur, Prand([1/4,1,1/8],inf),
				\octave, 3,
				\amp, 0.1/8,
			),
		
	])
)).play;
);

(
Pdef(\melo, Pbind(
	\instrument, \kopchord,
));
)
ProtoDef(\piano).startControl(Pdef(\melo))

(
MIDIdef.noteOn(\vim_writer, { arg velocity, noteNum, channel, deviceId;
	var note;
	[ velocity, noteNum, channel, deviceId ].debug;
	note = noteNum - 60;
	note.debug("note");
	"%, ".format(note).editorInsert(false);
	
});
)









/////////////////////////////////////



(
	// part full
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				5, 9, 14,
				5, 10, 14,
				4, 8, 14,
				4, 9, 13,
			].clump(3),inf),
			\dur, 1,
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			//\octave, 7,
			\fma, 30.91,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pser([
					14, 17, 21, 
				],8*3),
				Pser([
					13, 17, 21, 
				],8),
			],inf),
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pstep(Pseq([
					Pser([
						14, 17, 21, 
					],8*3),
					Pser([
						13, 17, 21, 
					],8),
				],1),1/8),
			],inf),
			//\octave, Ptuple(Pbrown(3,7,1,inf)!1),
			\fma, 1,
			\octave, 2,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[915].value,
			\speed, 1.1,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, Pseq([1,1.2,1.3,1.2],inf).stutter(2)*1.3 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				Pseq([
					0, 2,
				],2),
			],1),2).loop / Pkey(\st),
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,5,
				1,1,1,1, 5,1,1,1,
				1,6,1,4, 5,1,1,1,
			],inf),
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,0,-1,0],inf))),
			\gain, 0.11,
			\gain, Pkey(\gain) * Pseq([
				Pseq([
					0.2,1,
				],16+8),
				Pseq([
					0.8,1,
				],4),
				Pseq([
					0.9,0.31,
				],4),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2323].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0, 1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				5, 9, 14,
				5, 10, 14,
				4, 8, 14,
				4, 9, 13,
			].clump(3),inf),
			\dur, 1,
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			//\octave, 7,
			\fma, 30.91,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pser([
					14, 17, 21, 
				],8*3),
				Pser([
					13, 17, 21, 
				],8),
			],inf),
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pstep(Pseq([
					Pser([
						14, 17, 21, 
					],8*3),
					Pser([
						13, 17, 21, 
					],8),
				],1),1/8),
			],inf),
			//\octave, Ptuple(Pbrown(3,7,1,inf)!1),
			\fma, 1,
			\octave, 2,
			\isRest, Pseq([
				0,1,1,1, 0,0,1,0,
				0,1,1,1, 0,0,1,0,
				0,1,1,1, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

				0,1,1,1, 0,0,1,0,
				0,1,1,0, 0,1,1,0,
				0,0,1,0, 1,0,1,0,
				0,1,1,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[915].value,
			\speed, 1.1,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, Pseq([1,1.2,1.3,1.2],inf).stutter(2)*1.3 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				Pseq([
					0, 2,
				],2),
			],1),2).loop / Pkey(\st),
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,5,
				1,1,1,1, 5,1,1,1,
				1,6,1,4, 5,1,1,1,
			],inf),
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,0,-1,0],inf))),
			\gain, 0.11,
			\gain, Pkey(\gain) * Pseq([
				Pseq([
					0.2,1,
				],16+8),
				Pseq([
					0.8,1,
				],4),
				Pseq([
					0.9,0.31,
				],4),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2323].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0, 1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				5, 9, 14,
				5, 10, 14,
				4, 8, 14,
				4, 9, 13,
			].clump(3),inf),
			\dur, 1,
			\octave, Ptuple(Pbrown(3,7,1,inf)!3),
			\octave, 7,
			\fma, 30.91,
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pser([
					14, 17, 21, 
				],8*3),
				Pser([
					13, 17, 21, 
				],8),
			],inf),
			\octave, Ptuple(Pbrown(3,7,1,inf)!1),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				Pstep(Pseq([
					Pser([
						14, 17, 21, 14
					],8*1),
					Pser([
						14, 17, 22, 14
					],8*1),
					Pser([
						14, 16, 20, 14
					],8*1),
					Pser([
						13, 16, 21, 13
					],8),
				],1),1/8),
			],inf),
			\note, Pseq([
				Pstep(Pseq([
					Pser([
						21, 14
					],8*1),
					Pser([
						22, 14
					],8*1),
					Pser([
						20, 14
					],8*1),
					Pser([
						21, 13
					],8),
				],1),1/8),
			],inf)-12,
			//\octave, Ptuple(Pbrown(3,7,1,inf)!1),
			\fma, 0.8,
			\octave, 2,
			\legato, 2,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[915].value,
			\speed, 1.1,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.3,
		),
		
	])
)).play;
);



//////////////////////////////////////////



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([

-2, 1, 4, 7, 
-2, 1, 4, 7, 
-2, 1, 4, 7, 
			].clump(4),inf),
			\dur, 2,
			\dur, Pseq([3,1,4]/2,inf),
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
-6, 
-9, 
-12, 
			],inf),
			\legato, 1,
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\wavemix, 1,
			\octave, 3,
			\amp, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1535].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,2,1,
			],inf) * Pwhite(1,2.5,inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([

-2, 1, 4, 7, 
-2, 1, 4, 7, 
-2, 1, 4, 7, 
			].clump(4),inf).collect({ arg x; x.choose }),
			\dur, 2,
			\dur, Pseq([3,1,4]/2,inf),
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pstep(Pseq([

-2, 1, 4, 7, 
-2, 1, 4, 7, 
-2, 1, 4, 7, 
			].clump(4),inf),Pseq([3/8,1/8,4/8]*2,inf)).collect({ arg x; x.choose }),
			\dur, Pseq([3,1,4]/2,inf),
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\octave, 6,
			\dur, 1/8,
			\legato, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pstep(
				Pseq([
					-6, 
					-9, 
					-12, 
				],inf),
				Pseed(100,Pseq([
					Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
					4
				]/2,inf))
			),
			\isRest, Pseq([
				1,0.5
			],inf).coin.not,
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)).stutter(4)/4,
			\legato, 1/2,
			\wavemix, 1,
			\octave, 3,
			\amp, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1535].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,2,1,
			],inf) * Pwhite(1,2.5,inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

////////////////////////////////////////////////////////////

(
Pdef(\part, Pdef(\intro1, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([

-2, 1, 4, 7, 
-2, 1, 4, 7, 
-2, 1, 4, 7, 
			].clump(4),inf),
			\dur, 2,
			\dur, Pseq([3,1,4]/2,inf),
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\lpfr, 
			Pseq([
				~pmodenv.(Pseq([0.1,0.2,1,4],1), 2),
				Pseq([7],inf)
			],inf),
			\legato, 1,
			\amp, 0.1,
		),
		Ptpar([
			8, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1535].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				1
			],inf).coin.not,
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,2,1,
			],inf) * Pwhite(1,2.5,inf) * Pseg(Pseq([0.1,1],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Ppatlace([
				Pseg(Pseq([0,1],inf),8),
				Pseg(Pseq([0,1,0],inf),4),
			],inf),
		),
		])
		
	])
)).play;
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([

-2, 1, 4, 7, 
-2, 1, 4, 7, 
-2, 1, 4, 7, 
			].clump(4),inf).collect({ arg x; x.choose }),
			\dur, 2,
			\dur, Pseq([3,1,4]/2,inf),
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pstep(Pseq([

-2, 1, 4, 7, 
-2, 1, 4, 7, 
-2, 1, 4, 7, 
			].clump(4),inf),Pseq([3/8,1/8,4/8]*2,inf)).collect({ arg x; x.choose }),
			\dur, Pseq([3,1,4]/2,inf),
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\octave, 6,
			\dur, 1/8,
			\legato, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pstep(
				Pseq([
					-6, 
					-9, 
					-12, 
				],inf),
				Pseed(100,Pseq([
					Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
					4
				]/2,inf))
			),
			\isRest, Pseq([
				1,0.5
			],inf).coin.not,
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)).stutter(4)/4,
			\legato, 1/2,
			\wavemix, 1,
			\octave, 3,
			\amp, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1535].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,2,1,
			],inf) * Pwhite(1,2.5,inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
	])
)).play;
);

(
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([

-2, 1, 4, 7, 
-2, 1, 4, 7, 
-2, 1, 4, 7, 
			].clump(4),inf),
			\dur, 2,
			\dur, Pseq([3,1,4]/2,inf),
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\legato, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
-6, 
-9, 
-12, 
			],inf),
			\legato, 1,
			\dur, Pseed(100,Pseq([
				Plazy({Pseq(8.partition(2)+[8,0],1)/4}),
				4
			]/2,inf)),
			\wavemix, 1,
			\octave, 3,
			\amp, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1535].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,2,1,
			],inf) * Pwhite(1,2.5,inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16,Pdef(\intro1)),
		Pfindur(16,Pdef(\part2)),
		Pfindur(16,Pdef(\part1)),
		
	])
)).play;

/////////////////////////////

(
SynthDef(\snapclapmut, { |out = 0, amp = 0.5, pan = 0, dur = 1|
	var env1, env2, snd, noise1, noise2;

	// noise 1 - 4 short repeats
	env1 = EnvGen.ar(
		Env.new(
			[0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
			[0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
			[0, -3, 0, -3, 0, -3, 0, -4]
		)
	);

	noise1 = WhiteNoise.ar(env1);
	noise1 = HPF.ar(noise1, 600 * \fac1.kr(1));
	noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
	noise1 = BPF.ar(noise1, 1620, 3);

	// noise 2 - 1 longer single
	env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18 * \relfac.kr(1)], [0, -4]), doneAction:2);

	noise2 = WhiteNoise.ar(env2);
	noise2 = HPF.ar(noise2, 1000);
	noise2 = LPF.ar(noise2, 7600 * \fac2.kr(1));
	noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

	snd = noise1 + noise2;
	snd = snd * 2;
	snd = snd.softclip;

	Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;
);


(
SynthDef(\kickmut, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1, gate=1|
	var env0, env1, env1m;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 2, 60.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));

	sig1 = sig.fold2(\sigfold.kr(1/2));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);

	sig = sig * env0 * 8;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.7) ) + sig;
		isig = DelayL.ar(isig, 0.1,0.1 * LFNoise1.kr(4).range(0.9,1.0)) + isig;
		isig = DelayL.ar(isig, 0.01,0.01 * LFNoise1.kr(4).range(0.9,1.0)) + isig;
		isig = isig.distort;
	
		isig;
	});
	sig = Limiter.ar(sig)*4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:2);
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1535].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,2,1,
			],inf) * Pwhite(1,2.5,inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \snapclapmut,
			\fac1, ~pmodenv.(Pseq([0.1,2,1,40],1), 2).loop,
			\fac2, ~pmodenv.(Pseq([1,0.1,2,1,2],1), 2).loop,
			\relfac, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\dur, 1/8/2,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snapclapmut,
			\fac1, ~pmodenv.(Pseq([2,0.1,2,1,40],1), 2).loop,
			\fac2, ~pmodenv.(Pseq([0.1,2,1,2],1), 2).loop,
			\relfac, ~pmodenv.(Pseq([0.1,1,2,1,4],1), 8).loop,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kickmut,
			\dur, 1,
			\amp, 0.1,
			\env0,[ Env.new([0, 1, 0.5, 0], [0.005, 0.16, 3.2], [-4, -2, -4]) ],
			\env1,[ Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]) ],
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[854].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/8,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1535].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1/2,1, 1,1,2,1,
			],inf) * Pwhite(1,2.5,inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \snapclapmut,
			\fac1, ~pmodenv.(Pseq([0.1,2,1,40],1), 2).loop,
			\fac2, ~pmodenv.(Pseq([1,0.1,2,1,2],1), 2).loop,
			\relfac, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\dur, 1/8/2,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snapclapmut,
			\fac1, ~pmodenv.(Pseq([2,0.1,2,1,40],1), 2).loop,
			\fac2, ~pmodenv.(Pseq([0.1,2,1,2],1), 2).loop,
			\relfac, ~pmodenv.(Pseq([0.1,1,2,1,4],1), 8).loop,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \kickmut,
			\dur, 1,
			\amp, 0.1,
			\freqpan, 1,
			\env0,[ Env.new([0, 1, 5.5, 0], [0.005, 0.36, 3.2], [-4, -2, -4]) ],
			\env1,[ Env.new([410, 62, 59], [0.025, 1.29], [-4, -5]) ],
		),
	])
)).play;
);


///////////////
// more wet


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \kickmut,
			\dur, 1,
			\amp, 0.1,
			\freqpan, 1,
			\env0,[ Env.new([0, 1, 5.5, 0], [0.005, 0.36, 3.2], [-4, -2, -4]) ],
			\env1,[ Env.new([410, 62, 59], [0.025, 1.29], [-4, -5]) ],
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\rdnsunbass,
			\dur, 1,
		)<>
		Pbind(
			\inbus, BusDef(\ifx1, \audio),
			'wet10', 1.0,
			'mix', 0.77791010151461,
			'gain', 0.51260504201681/2,
			'fb', ~pmodenv.(Pseq([0,0.1,0.51],1), 8).loop,
			'delay', 0.6996996996997,
			'delay2', 0.0001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 4.2492192141522,
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
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\rdnsunsnare,
			\dur, 1,
		)<>
		Pbind(
			\inbus, BusDef(\ifx2, \audio),
			'wet10', 1.0,
			'mix', 0.77791010151461* Pseq([1,0],inf),
			\mix, ~pmodenv.(Pseq([
				0,1,0,1,
				1,2,0,0,
				1,1,1,2,
				1,1,1,1,
			] * 0.7,1), 1/8).loop,
			'gain', 0.51260504201681,
			'fb', 0.0001,
			'delay', 0.8001 * Pseq([
				0,0,0,0,
				1,1,0,0,
				0.8,0.8,1,1,
				1,1/2,1,1,
			],inf),
			'delay2', 0.0001,
			'shift', 0.01,
			'shift2', 0.0,
			'distamp', 10.700689556932,
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
			'wetamp', 0.16579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 3,
		),
		Pbind(\lag, 0.04)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1535].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\legato, 1/8 * Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1/2,1, 1,1,2,1,
				],inf) * Pwhite(1,2.5,inf),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
				],inf),
				\dur, 1/8,
				\gain, 0.03,
			),
		]),
	])
)).play;
)

(
	// var
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1441].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \kickmut,
			\dur, 1,
			\amp, 0.1,
			\freqpan, 1,
			\env0,[ Env.new([0, 1, 5.5, 0], [0.005, 0.36, 3.2], [-4, -2, -4]) ],
			\env1,[ Env.new([410, 62, 59], [0.025, 1.29], [-4, -5]) ],
			\out, BusDef(\sendbus1, \audio),
		),
		//Pmono(\rdnsunbass,
			//\dur, 1,
		//)<>
		//Pbind(
			//\inbus, BusDef(\ifx1, \audio),
			//'wet10', 1.0,
			//'mix', 0.77791010151461,
			//'gain', 0.51260504201681/2,
			//'fb', ~pmodenv.(Pseq([0,0.1,0.51],1), 8).loop,
			//'delay', 0.6996996996997,
			//'delay2', 0.0001,
			//'shift', 0.0,
			//'shift2', 0.0,
			//'distamp', 4.2492192141522,
			//'pitchlag', 1.0,
			//'pitchmix', 0.0,
			//'prelpf', 17000,
			//'prehpf', 17,
			//'lpf', 17000,
			//'hpf', 17,
			//'fbdistamp', 0.47619047619048,
			//'fbdistmix', 0.91176470588235,
			//'postlpf', 17000,
			//'posthpf', 17,
			//'wetamp', 0.46579739809918,
			//'indelay', 0.04,
			//'wet20', 1.0,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[567].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\rdnsunsnare,
			\dur, 1,
		)<>
		Pbind(
			\inbus, BusDef(\ifx2, \audio),
			'wet10', 1.0,
			'mix', 0.77791010151461* Pseq([1,0],inf),
			\mix, ~pmodenv.(Pseq([
				0,1,0,1,
				1,2,0,0,
				1,1,1,2,
				1,1,1,1,
			] * 0.7,1), 1/8).loop,
			'gain', 0.51260504201681,
			'fb', 0.0001,
			'delay', 0.8001 * Pseq([
				0,0,0,0,
				1,1,0,0,
				0.8,0.8,1,1,
				1,1/2,1,1,
			],inf),
			'delay2', 0.0001,
			'shift', 0.01,
			'shift2', 0.0,
			'distamp', 10.700689556932,
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
			'wetamp', 0.16579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 3,
		),
		Pbind(\lag, 0.04)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1535].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\legato, 1/8 * Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1/2,1, 1,1,2,1,
				],inf) * Pwhite(1,2.5,inf),
				\adsr, Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.1,1,2) ],
				],inf),
				\dur, 1/8,
				\gain, 0.03,
			),
		]),
	])
)).play;
)

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

		SynthDef(\rdnfx, { arg out=0, gate=1;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
			var code, rdnkey;
			
		var sig;
		var sigin;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag;
		var pitchmix;
		var fb, fb1, fb2;
		var gain;
		var mix;
		var indelay;
		//"default_make_graph".debug("!!!");
		rdnkey = rdnkey ? \default;
		code = code ? "4--";
		sig = in;
		mix = \mix.kr(0.5);
		gain = \gain.kr(1);
		fb = \fb.kr(0.001);
		del = \delay.kr(0.001,0.1);
		del2 = \delay2.kr(0.001,0.1);
		shi = \shift.kr(0);
		shi2 = \shift2.kr(0);
		distamp = \distamp.kr(1);
		pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
		pitchmix = \pitchmix.kr(0);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		thisThread.randSeed = 907900.0;
si = sig;
sig = { arg si, env;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);


		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		sig = LPF.ar(sig, \postlpf.kr(17000));
		sig = HPF.ar(sig, \posthpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \wetamp.kr(1);

		indelay = \indelay.kr(0);
		sigin = DelayL.ar(in, 0.2, indelay);
		sig = SelectX.ar(mix, [sigin, sig]);
		sig = sig * gain;
		//sig.debug("end sig");
		sig;
	

			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
			Out.ar(out, sig);
		}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.52521008403361,
	'fb', 0.0001,
	'delay', 0.00011674193588235,
	'delay2', 0.00040275599798503,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.76269858590234,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 632.45553203368,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

		
);


~protordn_to_fbstring.(ProtoDef(\rdn2)).editorInsert
(

		SynthDef(\rdnsunsnare, { arg out=0, gate=1;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
			var code, rdnkey;
			
		var sig;
		var sigin;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag;
		var pitchmix;
		var fb, fb1, fb2;
		var gain;
		var mix;
		var indelay;
		//"default_make_graph".debug("!!!");
		rdnkey = rdnkey ? \default;
		code = code ? "4--";
		sig = in;
		mix = \mix.kr(0.5);
		gain = \gain.kr(1);
		fb = \fb.kr(0.001);
		del = \delay.kr(0.001,0.1);
		del2 = \delay2.kr(0.001,0.1);
		shi = \shift.kr(0);
		shi2 = \shift2.kr(0);
		distamp = \distamp.kr(1);
		pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
		pitchmix = \pitchmix.kr(0);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		thisThread.randSeed = 960290.0;
si = sig;
sig = { arg si, env;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = [
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
}.value(si, env);

].mean;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
}.value(si, env);

].mean;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = [
			{ arg si, env;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
}.value(si, env);
,
			{ arg si, env;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
}.value(si, env);

].mean;
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
}.value(si, env);

].mean;
}.value(si, env);


		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		sig = LPF.ar(sig, \postlpf.kr(17000));
		sig = HPF.ar(sig, \posthpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \wetamp.kr(1);

		indelay = \indelay.kr(0);
		sigin = DelayL.ar(in, 0.2, indelay);
		sig = SelectX.ar(mix, [sigin, sig]);
		sig = sig * gain;
		//sig.debug("end sig");
		sig;
	

			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
			Out.ar(out, sig);
		}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.51260504201681,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 10.700689556932,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

		
);

(

		SynthDef(\rdnsunbass, { arg out=0, gate=1;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
			var code, rdnkey;
			
		var sig;
		var sigin;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag;
		var pitchmix;
		var fb, fb1, fb2;
		var gain;
		var mix;
		var indelay;
		//"default_make_graph".debug("!!!");
		rdnkey = rdnkey ? \default;
		code = code ? "4--";
		sig = in;
		mix = \mix.kr(0.5);
		gain = \gain.kr(1);
		fb = \fb.kr(0.001);
		del = \delay.kr(0.001,0.1);
		del2 = \delay2.kr(0.001,0.1);
		shi = \shift.kr(0);
		shi2 = \shift2.kr(0);
		distamp = \distamp.kr(1);
		pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
		pitchmix = \pitchmix.kr(0);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		thisThread.randSeed = 867763.0;
si = sig;
sig = { arg si, env;
si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = [
							{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);
,
							{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);

].mean;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
}.value(si, env);

].mean;
}.value(si, env);


		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		sig = LPF.ar(sig, \postlpf.kr(17000));
		sig = HPF.ar(sig, \posthpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \wetamp.kr(1);

		indelay = \indelay.kr(0);
		sigin = DelayL.ar(in, 0.2, indelay);
		sig = SelectX.ar(mix, [sigin, sig]);
		sig = sig * gain;
		//sig.debug("end sig");
		sig;
	

			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
			Out.ar(out, sig);
		}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.51260504201681,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

		
);



(
SynthDef(\fxampgate, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = ( Amplitude.kr(sig) > \ampgate.kr(1) ).lag(\amplag.kr(0.01)) * sig;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
	Out.ar(\dryout.kr(0), in * \drygain.kr(0));
}, metadata:(specs:(
	dryout: ParamBusSpec(),
	drygain: \unipolar,
))).add;
);
TagSpecDef(\SynthDef_fx).addUnique(\fxampgate)



c=
c=BufDef.mono(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
c=BufDef.stereo(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
Ndef(\bee10, {10.collect{TGrains2.ar(2, Dust.kr(LFNoise1.kr(1000)), c, 1, rrand(0, 44108), 1, LFNoise1.kr(100), 0.1)}.mean}).play(out: 0)
Ndef(\bee10, {10.collect{TGrains2.ar(2, Dust.kr(LFNoise1.kr(1000)), c, 1, rrand(0, 44108), 1, LFNoise1.kr(100), 0.1)}}).play(out: 0)
Ndef(\bee6, {TGrains2.ar(2, Impulse.ar(100), c, 1, rrand(0.0, 1), 1, LFNoise1.kr(100), 0.1)}).play


Ndef(\bee).clear

c.play

{TGrains2.ar(2, Impulse.ar(100), c, 1, 0.1, 1, 0, 10.1)}.play
{ SinOsc.ar(500) ! 2 * 0.1}.play;
(
	{
		var b = 10, trate, dur, clk, pos, pan;
		trate = MouseY.kr(8,120,1);
		dur = 12 / trate;
		clk = Impulse.kr(trate);
		pos = MouseX.kr(0,BufDur.kr(c)) + TRand.kr(0, 0.01, clk);
		pan = WhiteNoise.kr(0.6);
		TGrains.ar(2, clk, c, 1, pos, dur, pan, 0.1, dur * 0.3, dur * 0.5);

	}.play;

)
s.sendMsg(\b_allocRead, 20, "sounds/a11wlk01.wav");

(
	{
		    var b = c, trate, dur, clk;
			    trate = MouseY.kr(2,200,1);
				    dur = 4 / trate;
					    clk = Dust.kr(trate);
						    TGrains.ar(2, clk, 10, 1.0, LFNoise2.kr(0.5).range(0, BufDur.kr(b)), dur, 0, TRand.kr(0.1, 0.2, clk), MouseX.kr(0.003, 0.01), 0.007, 4);

	}.play;

)

SynthDef(\graine, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(1));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFPulse.ar(freq * XLine.kr(1,100,10));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * XLine.kr(1,100,10), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFPulse.ar(freq * MouseY.kr(1/100,100));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * MouseX.kr(1/100,100), \rq.kr(0.5));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * MouseX.kr(1/100,100), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// nice bass
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	].midiratio,inf)) * 1/2;
	env2 = Duty.kr(1/8/~t, 0, Dseq([
		1,4,20,0,
	].midiratio,inf));
	env3 = Duty.kr(1/4/~t, 0, Dseq([
		1,4,20,0,
	].midiratio,inf)) * 1/4;
	env4 = Duty.kr(2/~t, 0, Dseq([
		1,4,20,0,
		10,14,2,10,
	].midiratio,inf)).lag(2/~t) * 2;
	sig = LFPulse.ar(freq * env1);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * env2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * ( LFSaw.ar(freq * env3) * 1 + 1 );
	sig = RLPF.ar(sig, ( \lpfr2.kr(1.1) * freq * env4 ).clip(20,20000), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// nice bass var
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	].midiratio,inf)) * 1/2;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		10,0,10,0,
		0,0,50,0,
		1,4,20,0,
		3,10,2,30,
	].midiratio,inf));
	env3 = Duty.kr(1/4/~t, 0, Dseq([
		1,4,20,0,
	].midiratio,inf)) * 1/4;
	env4 = Duty.kr(2/~t, 0, Dseq([
		1,4,20,0,
		10,14,2,10,
	].midiratio,inf)).lag(2/~t) * 2;
	env5 = Duty.kr(1/2/~t, 0, Dseq([
		0,1,10,0,
		2,4,2,9,
		10,1,10,9,
		2,4,2,9,
	]/10,inf));
	env6 = Duty.kr(1/4/~t, 0, Dseq([
		6,4,2,10,
		0,4,2,9,
	]/10,inf)).lag(1/2/~t);
	env7 = Duty.kr(1/4/~t, 0, Dseq([
		1,4,20,0,
	].midiratio,inf)) * Duty.kr(4/~t, 0, Dseq([
		2,1,6,9,
		2,5,1,2,
	].midiratio,inf));
	sig2 = ( SinOsc.ar(freq * env4) * env6 + 1 );
	sig = LFPulse.ar(freq * env1);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * env2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * ( LFSaw.ar(freq * env3) * env5 + 1 );
	sig = RLPF.ar(sig, ( \lpfr2.kr(1.1) * freq * env4 * sig2 ).clip(20,20000), \rq.kr(0.5));
	sig = RLPF.ar(sig, ( \lpfr3.kr(8.1) * freq * env7 ).clip(20,20000), \rq3.kr(0.1));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\zed).quant = 4


(
Ndef(\zed2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var ifreq = freq;
	freq = freq * [0,3,7,9,11,15].midiratio * 2;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	].midiratio,inf));
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq.reverse) * LFNoise1.kr(1/2!freq.size).exprange(0.0001,100.0) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * LFNoise1.kr(1/8!freq.size).range(0.4,3.0) ).clip(20,20000), \rq.kr(0.1));
	sig = sig * LFNoise1.kr(1/8!freq.size).range(0.1,1.0);
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp).mean;
	sig.debug("sig");
}).play;
);

(
WindowDef(\ctrl, { arg def;
	VLayout (
		PlayerWrapper(Ndef(\zed1)),
		PlayerWrapper(Ndef(\zed2)),
		PlayerWrapper(Ndef(\zed3)),
		nil,
	)
	
}).front;
)

(
Ndef(\zed3, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 10;
	sig = Dust.ar(1);
	sig = Klank.ar(Ref([exprand(50*3,16000.0!num)], nil, 0.001!num), sig);
	sig2 = Dust.ar(1);
	sig2 = Klank.ar(Ref([exprand(50*3,16000.0!num)], nil, 0.001!num), sig2);
	sig = sig + sig2;
	sig = sig * 1;
	sig = Pan2.ar(sig, pan, amp);
}).play(out:BusDef(\sendbus1).index);
);

(
Ndef(\zed3, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 10;
	sig = Dust.ar(1);
	sig = Klank.ar(Ref([exprand(50*3,16000.0!num)], nil, 0.001!num), sig);
	sig2 = Dust.ar(1);
	sig2 = Klank.ar(Ref([exprand(50*3,16000.0!num)], nil, 0.001!num), sig2);
	sig = sig + sig2;
	sig = sig * 1;
	sig = Pan2.ar(sig, pan, amp);
}).play(out:BusDef(\ifx1,\audio,2).index);
);

Ndef(\rdndoom).source = \rdndoom;
Ndef(\rdndoom).set(\inbus, BusDef(\ifx1, \audio,2));
Ndef(\rdndoom).play;
Ndef(\rdndoom).edit
Ndef(\rdndoom).set(\fb, Ndef(\lfo1, { XLine.kr(0.01,1,10) }));
(
Ndef(\rdndoom).put(1000, \pset ->
	Pbind(
		'wet10', 1.0,
		'mix', 1.0,
		'gain', 0.49159663865546,
		'fb', 0.0001,
		'delay', 0.67909850299557,
		'delay2', 0.47937156455582,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 0.76269858590234,
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
		'wetamp', 0.46579739809918,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	).keep(1)
);
)

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

	SynthDef(\rdndoom, { arg out=0, gate=1;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
		var code, rdnkey;

		var sig;
		var sigin;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag;
		var pitchmix;
		var fb, fb1, fb2;
		var gain;
		var mix;
		var indelay;
		//"default_make_graph".debug("!!!");
		rdnkey = rdnkey ? \default;
		code = code ? "4--";
		sig = in;
		mix = \mix.kr(0.5);
		gain = \gain.kr(1);
		fb = \fb.kr(0.001);
		del = \delay.kr(0.001,0.1);
		del2 = \delay2.kr(0.001,0.1);
		shi = \shift.kr(0);
		shi2 = \shift2.kr(0);
		distamp = \distamp.kr(1);
		pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
		pitchmix = \pitchmix.kr(0);

		sig = LPF.ar(sig, \prelpf.kr(17000));
		sig = HPF.ar(sig, \prehpf.kr(17));

		sig = sig + (LocalIn.ar(2) * fb);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		thisThread.randSeed = 801549.0;
		si = sig;
		sig = { arg si, env;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = [
						{ arg si, env;
							si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
						}.value(si, env);
						,
						{ arg si, env;
							si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
						}.value(si, env);

					].mean;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				}.value(si, env);

			].mean;
		}.value(si, env);


		sig1 = sig.tanh * \fbdistamp.kr(1/2);
		sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

		sig = Limiter.ar(sig);

		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig1).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(pitchmix, [sig, sig1]);

		LocalOut.ar(sig);
		sig = LPF.ar(sig, \postlpf.kr(17000));
		sig = HPF.ar(sig, \posthpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \wetamp.kr(1);

		indelay = \indelay.kr(0);
		sigin = DelayL.ar(in, 0.2, indelay);
		sig = SelectX.ar(mix, [sigin, sig]);
		sig = sig * gain;
		//sig.debug("end sig");
		sig;


		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
		Out.ar(out, sig);
	}).add;


	Pbind(
		'wet10', 1.0,
		'mix', 1.0,
		'gain', 0.49159663865546,
		'fb', 0.0001,
		'delay', 0.67909850299557,
		'delay2', 0.47937156455582,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 0.76269858590234,
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
		'wetamp', 0.46579739809918,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	)


);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1833].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1/2,1,1/2,
				1/2,1,1,1,
			],inf).coin.not,
			\mixhpf, 1,
			\hpf, 800,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
			\lag, 0.04,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1833].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/8/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
			\lag, 0.04,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 0.7,
			\st, 272/8/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				0,1,2,3,
				4,5,6,7,
				8,9,10,11,
				12,13,14,15,
				//0,1,2,3,

				2,2,2,2,
				2,2,2,2,
				6,6,6,6,
				6,6,6,6,
				11,11,11,11,
				11,11,11,11,
				10,10,10,10,
				10,10,10,10,
			].scramble/4,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1833].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/8/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
			\lag, 0.04,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 0.7,
			\st, 272/8/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				0,1,2,3,
				4,5,6,7,
				8,9,10,11,
				12,13,14,15,
				//0,1,2,3,

				2,2,2,2,
				2,2,2,2,
				6,6,6,6,
				6,6,6,6,
				11,11,11,11,
				11,11,11,11,
				10,10,10,10,
				10,10,10,10,
			].scramble/4,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4,
			//\lag, 0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Head West - Attention.wav'),
			\legato, 0.7,
			\st, 162/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+4,1),2).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			//\pos, Pseq([
				//0,1,2,3,
				//4,5,6,7,
				//8,9,10,11,
				//12,13,14,15,
				////0,1,2,3,

				//2,2,2,2,
				//2,2,2,2,
				//6,6,6,6,
				//6,6,6,6,
				//11,11,11,11,
				//11,11,11,11,
				//10,10,10,10,
				//10,10,10,10,
			//].scramble/4,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/2,
			//\lag, 0.04,
			//\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
	SynthDef(\help_beattrack, { |out, vol=1.0, beepvol=1.0, lock=0, bufnum|
		var in, fft, resample;
		var trackb, trackh, trackq, tempo;
		var bsound, hsound, qsound, beep;

		in = PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum),1,0,1);
		//in = SoundIn.ar(0);

		fft = FFT(LocalBuf(1024), in); // for sampling rates 44100 and 48000

		#trackb, trackh, trackq, tempo = BeatTrack.kr(fft, lock);

		beep = SinOsc.ar(1000, 0.0, Decay.kr(trackb, 0.1));
		( tempo*60 ).poll;

		Out.ar(out, Pan2.ar((vol * in) + (beepvol * beep), 0.0))

	}).add;

)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\help_beattrack,
			\bufnum, BufDef.mono('vbreaks/Head West - Attention.wav'),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1357].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/8/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2, 3, 4,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2, 3, 4,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/2/60,
			\speed, 1.5 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/4,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \chordc,
			\note, Pseq([
				[ 0,3,7 ],
				[ 0,3,7,9,11 ],
				[ 0,4,8,11,13 ],
				[ 0,4,7,11,12 ],
			],inf),
			\hpf, 300,
			\lpffac, 7,
			\octave, 4,
			\legato, 0.7,
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
			],inf),
			\xfac, Pseq([1,2],inf),
			\ffac, 8,
			\dur, Pseq([1/2,1/2,1,2],inf),
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1357].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1/2,1/2,
				1/2,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1/2,1/2,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/8/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 1+(Pseq(6+[
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				1,1,2,0, 0,2,1,2,

				2,0,1,0, 2,1,0,1,
				0,0,1,0, 1,0,0,1,
				2,0,1,0, 2,1,0,1,
				1,1,2,0, 2,0,1,2,
			],inf)/16).stutter(1) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/8/60,
			\isRest, Pseq([
				1,0,1/2,1/2,
				1/2,1,1,1/2,
			],inf).coin.not,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2, 3, 4,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2, 3, 4,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/2/60,
			\speed, 1.5 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/4,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \chordc,
			\note, Pseq([
				[ 0,3,7 ],
				[ 0,3,7,9,11 ],
				[ 0,4,8,11,13 ],
				[ 0,4,7,11,12 ],
			],inf),
			\hpf, 300,
			\lpffac, 7,
			\octave, 4,
			\legato, 0.7,
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
			],inf),
			\xfac, Pseq([1,2],inf),
			\ffac, 8,
			\dur, Pseq([1/2,1/2,1,2],inf),
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

//ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-BL6D-T6LK", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.3781512605042,
	'fb', 0.0010315310943986,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.17357844695489,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

//ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-519C-9MT8", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.67647058823529,
	'fb', 0.0028978297094592,
	'delay', 0.89038909412967,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.5080218046913,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
//ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-QE7U-ML01", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.11344537815126,
	'fb', 0.0001,
	'delay', 1.0,
	'delay2', 1.0,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.46565816979706,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



(
Pdef(\part, Pdef(\part1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				//Pseg(Pseq([
					//0, 2
				//]*16,1),4).repeat(1),
				Pseg(Pseq([
					0, 1
				]*16,1),2).repeat(1),
				0,1,5,6, 0,1,5,6,
				8,10,11,10, 10,9,11,9,
				Pseg(Pseq([
					0, 1
				]*16,1),2).repeat(1),
				0,1,5,0, 14,1,5,15,
				8,9,10,11, 10,9,11,9,
				//4,4,4,4,
				//8,8,8,8,
				//16,16,16,16,
				
			]/16,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				[0,4,7,11],
				[-1,3,7,11],
			],inf),
			\ctranspose, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \kopchord_simple,
			\ctranspose, 5,
			\note, Pseq([
				7,
				3,
				4,
				12,
			],inf).stutter(3),
			\dur, Pseq([1/2,1,1/4,1,1,1/4],inf),
			\octave, Pseq([5,6],inf),
			//\lag, 0.04,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \bilin,
			\ctranspose, 5,
			\note, Pseq([
				9,
				11,
				9,
				12,
			],inf).stutter(3),
			\dur, Pseq([1,1/2,1/4,1,1,1/4],inf),
			\octave, Pseq([5,6],inf),
			\lag, 0.04,
			\amp, 0.1,
		),
		Prout({ arg ev;
			//ProtoDef(\rdn2).proxy.set(\gain, Ndef(\rdn2lfo1, { XLine.kr(0.001,1/2,8/~t) }));
			ProtoDef(\rdn2).proxy.set(\delay, Ndef(\rdn2lfodelay, { XLine.kr(0.001,0.93,8/~t) }));
			//ProtoDef(\rdn2).proxy.set(\delay2, Ndef(\rdn2lfodelay2, { XLine.kr(0.001,1,8/~t) }));
			nil;
		}),
	])
)).play;
);

(
Pdef(\part, Pdef(\break1, 
	Ppar([
		
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			//\legato, 1,
			//\st, 176/4/60,
			//\speed, 1 * ~t / Pkey(\st),
			//\pos, Pseg(Pseq([
				//0, 2
			//]+0,1),4).loop / Pkey(\st),
			//\dur, 1/8,
			//\gain, 1/8,
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		//),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			//\legato, 1,
			//\st, 176/4/60,
			//\speed, 1 * ~t / Pkey(\st),
			//\pos, Pseg(Pseq([
				//0, 2
			//]+0,1),4).loop / Pkey(\st),
			//\pos, Pseq([
				////Pseg(Pseq([
					////0, 2
				////]*16,1),4).repeat(1),
				//Pseg(Pseq([
					//0, 1
				//]*16,1),2).repeat(1),
				//0,1,5,6, 0,1,5,6,
				//8,10,11,10, 10,9,11,9,
				//Pseg(Pseq([
					//0, 1
				//]*16,1),2).repeat(1),
				//0,1,5,0, 14,1,5,15,
				//8,9,10,11, 10,9,11,9,
				////4,4,4,4,
				////8,8,8,8,
				////16,16,16,16,
				
			//]/16,inf) / Pkey(\st),
			//\dur, 1/8,
			//\gain, 1/8,
			//\out, BusDef(\sendbus1, \audio),
		//),
		Pfindur(8,Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				0,9,7,
				0,9,7,
			],inf),
			\ctranspose, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\octave, 6,
			\dur, Plazy({ var x = 0.2.rand; Pseq([x, 1-x,1],1) }).loop,
			\amp, 0.1,
			\lag, 0.04,
		),
		Pbind(
			\instrument, \kopchord,
			\note, Pseq([
				0,4,7,11,
				-1,3,7,11,
			],inf),
			\ctranspose, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 2/4,
			\amp, 0.1,
			\lag, 0.04,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\intro1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \kopchord_simple,
			\ctranspose, 5,
			\note, Pseq([
				7,
				3,
				4,
				12,
			],inf).stutter(3),
			\dur, Pseq([1/2,1,1/4,1,1,1/4],inf),
			\octave, Pseq([5,6],inf),
			//\lag, 0.04,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Prout({ arg ev;
			ProtoDef(\rdn2).proxy.set(\gain, Ndef(\rdn2lfo1, { XLine.kr(0.001,1/2,8/~t) }));
			ProtoDef(\rdn2).proxy.set(\delay, 0);
			ProtoDef(\rdn3).proxy.set(\delay, Ndef(\lfo1, { XLine.kr(0.001,1,8/~t) }));
			ProtoDef(\rdn3).proxy.set(\delay2, Ndef(\lfo2, { XLine.kr(0.001,1,8/~t) }));
			nil;
		}),
	])
)).play;
);

(
Pdef(\part, Pdef(\intro1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \kopchord_simple,
			\ctranspose, 5,
			\note, Pseq([
				7,
				3,
				4,
				12,
			],inf).stutter(3),
			\dur, Pseq([1/2,1,1/4,1,1,1/4],inf),
			\octave, Pseq([5,6],inf),
			//\lag, 0.04,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Prout({ arg ev;
			ProtoDef(\rdn2).proxy.set(\gain, Ndef(\rdn2lfo1, { XLine.kr(0.001,1/2,8/~t) }));
			ProtoDef(\rdn2).proxy.set(\delay, 0);
			ProtoDef(\rdn3).proxy.set(\delay, Ndef(\lfo1, { XLine.kr(0.001,1,8/~t) }));
			ProtoDef(\rdn3).proxy.set(\delay2, Ndef(\lfo2, { XLine.kr(0.001,1,8/~t) }));
			nil;
		}),
	])
)).play;
);

(
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
	ProtoDef(\rdn3).play;
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8, Pdef(\intro1)),
		Pfindur(16, Pdef(\part1)),
		Pfindur(16, Pdef(\break1)),
		Pfindur(16, Pdef(\part1)),
		
	])
)).play;
)
Ndef(\zed).stop

NoteTimeline(\sun20melo1).edit


(
SynthDef(\paongrain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, mbufnum=0;
	var sig;
	var clk = Impulse.ar(\gfreq.kr(1));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch * LFNoise1.kr(1/20).range(0.5,2), pos + LFNoise1.kr(1/20).range(0.0,14.0) % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			5.collect{ arg x; Pmono(
				 \paongrain,
				\mbufnum, BufDef.mono('vipere/paon.flac'),
				\pos, 0.51,
				\gfreq, 14,
				\pitch_stretch, 1/8 * (x+1 ),
				\gdur, 1.7,
				\dur, 1/4,
				\gain, 1,
				\out, BusDef(\sendbus1, \audio),
			) }
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/world.flac'),
			\pos, Pwhite(0,10.0),
			\dur, 1,
			\gain, 1,
			\out, BusDef(\sendbus2, \audio),
		)
		
	])
)).play;
);
BufDef.reload('voices/world.flac')
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			15.collect{ arg x; Pmono(
				 \paongrain,
				\mbufnum, BufDef.mono('vipere/paon.flac'),
				\pos, 0.51,
				\gfreq, 164,
				\pitch_stretch, 1/8 * (x+1 /4),
				\gdur, 0.02,
				\dur, 1/4,
				\gain, 1,
				\out, BusDef(\sendbus1, \audio),
			) }
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			5.collect{ arg x; Pmono(
				 \paongrain,
				\mbufnum, BufDef.mono('voices/world.flac'),
				\pos, 0.51,
				\gfreq, 164,
				\pitch_stretch, 1/8 * (x+1 ),
				\gdur, 0.02,
				\dur, 1/4,
				\gain, 1,
				//\out, BusDef(\sendbus1, \audio),
			) }
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			5.collect{ arg x; Pmono(
				 \paongrain,
				\mbufnum, BufDef.mono('voices/world.flac'),
				\pos, 0.51,
				\gfreq, 14 * Pseq([1,10],inf),
				\pitch_stretch, 1/8 * (x+1 ),
				\gdur, 0.7,
				\dur, 1/4,
				\gain, 1,
				//\out, BusDef(\sendbus1, \audio),
			) }
		),
		
	])
)).play;
);

(
SynthDef(\basicpad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);
	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(32,Pbind(
				\instrument, \basicpad,
				\note, Pseq([
					5, 9, 14,
					5, 10, 14,
					4, 8, 14,
					4, 9, 13,
				].clump(3),inf).collect({ arg x; x.choose  }),
				\note, Pseq([
					\r,\r,\r,\r,
					10,9,8,7,
				],inf) + [0,-12,-5],
				\dur, 4,
				\octave, Ptuple(Pbrown(3,7,1,inf)!3),
				\octave, 6,
				\det, 0.01,
				\lpf, 4000,
				\legato, 1,
				\amp, 0.1 * 0.7,
			)),
			Pfindur(8,Pbind(
				\instrument, \basicpad,
				\note, Pseq([
					5, 9, 14,
					5, 10, 14,
					4, 8, 14,
					4, 9, 13,
				].clump(3),inf).collect({ arg x; x.choose  }),
				\note, Pseq([
					6,5,4,3,2,1,0,-1,-2,-3,-4,-5
				],inf) + [0],
				//\dur, Pseq([
					//1,0.7,0.6,0.5,0.2,0.1,0.1,0.1
				//],inf),
				\dur, Pseg(Pseq([2,1/8],inf),8),
				\octave, 5,
				\det, 0.01,
				\lpf, 4000,
				\legato, 1,
				\amp, 0.1 * 0.7,
			)),
		],1),

		Pseq([
			Pfindur(32,Pbind()),
			Pfindur(8,Pbind(
				\pitch_stretch, Pseg(Pseq([1/8,0.01],inf),8),
			)),
		],1) <>
		Ppar(
			5.collect{ arg x; Pmono(
				 \paongrain,
				\mbufnum, BufDef.mono('voices/world.flac'),
				\pos, 0.51,
				\gfreq, 14 * Pseq([1,10],inf),
				\pitch_stretch, 1/8 * (x+1 ),
				\gdur, 0.7,
				\dur, 1/4,
				\gain, 1,
				\amp, Env([0,1,1]*0.1,[2.1*(x+1),0.8]),
				\out, BusDef(\ifx1, \audio),
			) }
		),
		Pmono(\fx_simplecompander,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,

			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pfindur(8,Pbind(
				\instrument, \basicpad,
				\note, Pseq([
					5, 9, 14,
					5, 10, 14,
					4, 8, 14,
					4, 9, 13,
				].clump(3),inf).collect({ arg x; x.choose  }),
				\note, Pseq([
					6,5,4,3,2,1,0,-1,-2,-3,-4,-5
				],inf) + [0,-12,-5],
				//\dur, Pseq([
					//1,0.7,0.6,0.5,0.2,0.1,0.1,0.1
				//],inf),
				\dur, Pseg(Pseq([2,1/8],inf),8),
				\det, 0.01,
				\lpf, 4000,
				\octave, 5,
				//\fma, 30.91,
				\legato, 1,
				\amp, 0.1 * 0.7,
			)),
	])
)).play;
);


////////// voice

(
SynthDef(\fxrobot, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(30);
	sig = Klank.ar(Ref([exprand(30,10000!10),0.01]),sig) *0.2;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/world.flac'),
			\dur, 1,
			\gain, 1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxrobot,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);



(
SynthDef(\cloche, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	//sig = SinOsc.ar(freq) * EnvGen.kr(Env([0,1,0],[0.01,0.08]), 1);
	sig = PinkNoise.ar * EnvGen.kr(Env([0,1,0],[0.01,0.02]), 1);
	//sig = SinOsc.ar(( freq * rrand(1,12!num) / rrand(1,12!num) ).clip(20,20000)).mean;
	sig = Klank.ar(Ref([( freq * Rand(1,12!num) / Rand(1,12!num) ) ++ [ freq ],ExpRand(0.01,0.1!num) ++ [0.4]]),sig);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[420].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[173].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0.61, 0,0,0.61,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1770].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, Pseq([
				1,0.9,
			],inf),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Ppatlace([
				Pseg(Pseq([1,0.8,1],inf),8),
				Pseg(Pseq([0.6,0.1,0.71,0.3],inf),8),
				Pseg(Pseq([1,0.8,1],inf),9),
				Pseg(Pseq([0.6,0.1,0.71,0.3],inf),10),
			],inf).trace,
		),
		Pbind(
			\instrument, \cloche,
			\note, Pseq([
				//0,5,10,-4
				0,4,7,0,
			],inf),
			\legato, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pmono(\hinoise,
			\freq, 1200,
			\restab, Pseq([
				[ exprand(100,11000!10) ],
				[ exprand(100,11000!10) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\hinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	sig = PinkNoise.ar * ( SinOsc.kr([1,2,3,4]) * 1 + 1 );
	sig = sig.mean;
	sig = Klank.ar(Ref([( freq * Rand(1,12!num) / Rand(1,12!num) ) ++ [ freq ],ExpRand(0.01,0.1!num) ++ [0.4]]),sig) * 0.1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\hinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	sig = PinkNoise.ar * ( SinOsc.kr([1,2,3,4]) * 1 + 1 );
	sig = sig.mean;
	sig = DynKlank.ar(Ref([ \restab.kr((1..num)),ExpRand(0.01,0.1!num) ++ [0.4]]),sig) * 0.1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\hinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	var env
	sig = PinkNoise.ar * ( SinOsc.kr([1,2,3,4]*~t) * 1 + 1 );
	sig = sig.mean;
	sig = num.collect { arg item, idx;
		BPF.ar(sig, exprand(100,16000),0.1);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

/////////////////////
(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,2,1],[1.1,0.8]), 1);
	sig = PinkNoise.ar * ( SinOsc.kr([1,2,3,4]*~t) * 1 + 1 );
	sig = sig.mean;
	sig = num.collect { arg item, idx;
		BPF.ar(sig, exprand(100,16000) * env1,0.1);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1.9,2.1],[1.1,0.1],1,1), gate);
	sig = PinkNoise.ar;
	sig = num.collect { arg item, idx;
		BPF.ar(sig, exprand(100,16000) * env1,0.1);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,0.9,2.1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([0.6,2,0.1,1,0.1],[1.1,0.1,1,],1,3), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([0.6,2,0.1,1,0.1],[0.1,0.2,0.1,1,],1,3,0), gate, timeScale:timeScale);
	sig = PinkNoise.ar;
	sig = num.collect { arg item, idx;
		BPF.ar(sig, exprand(100,16000) * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 3,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,0.1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[0.1,0.8]), 1);
	sig = PinkNoise.ar;
	sig = num.collect { arg item, idx;
		BPF.ar(sig, exprand(100,16000) * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,0.01],[0.1,0.1],1), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[0.1,0.8]), 1);
	sig = PinkNoise.ar;
	sig = num.collect { arg item, idx;
		BPF.ar(sig, exprand(100,16000) * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10000,10010,100],[0.1,0.2],-1), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,1,1],[0.1,0.8]), 1);
	sig = WhiteNoise.ar;
	//sig = BPF.ar(sig, 8000, 0.1);
	sig = BPF.ar(sig, env1, 0.1);
	//sig = LPF.ar(sig, env1);

	//sig = num.collect { arg item, idx;
		//BPF.ar(sig, exprand(100,16000) * env1,0.1 * env2);
	//};
	//sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
//Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1, attack=0.4;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([8000,4010,1200],[attack,0.2],[-1,1]), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([0.1,0.5,0.01],[attack,1.8]), 1);
	sig = WhiteNoise.ar;
	//sig = BPF.ar(sig, 8000, 0.1);
	sig = BPF.ar(sig, env1, env2) * 2;
	//sig = LPF.ar(sig, env1);

	//sig = num.collect { arg item, idx;
		//BPF.ar(sig, exprand(100,16000) * env1,0.1 * env2);
	//};
	//sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
//Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\legato, 0.22,
			\timeScale, 1,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1, attack=0.4;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([200,8010,800,110],[attack,0.2,0.21],[-1,1]), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([0.1,0.5,0.01,1],[attack,1.8,1]), 1);
	sig = WhiteNoise.ar;
	//sig = BPF.ar(sig, 8000, 0.1);
	sig = BPF.ar(sig, env1, env2) * 2;
	//sig = LPF.ar(sig, env1);

	//sig = num.collect { arg item, idx;
		//BPF.ar(sig, exprand(100,16000) * env1,0.1 * env2);
	//};
	//sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
//Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\legato, 0.42,
			\timeScale, 1,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);


//////// abiance noise
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	sig = WhiteNoise.ar;
	sig = num.collect { arg idx;
		var isig;
		isig = Ringz.ar(sig, LFNoise2.kr(0.01).exprange(100.0,10000.0), 0.1);
		isig;
	};
	sig = sig.mean * 0.4;
	10.do { arg item, idx;
		sig = BRF.ar(sig, exprand(100,19000), 1)
	};
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	sig = WhiteNoise.ar;
	sig = num.collect { arg idx;
		var isig;
		isig = Ringz.ar(sig, LFNoise2.kr(0.01).exprange(100.0,10000.0), 0.1);
		isig = isig.fold2(6.1 * LFNoise1.kr(1/2).range(0.0,1.0));
		isig;
	};
	sig = sig.mean * 0.4;
	10.do { arg item, idx;
		sig = BRF.ar(sig, exprand(100,19000), 1)
	};
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	sig = WhiteNoise.ar;
	sig = num.collect { arg idx;
		var isig;
		isig = Ringz.ar(sig, LFNoise1.kr(0.01).exprange(100.0,10000.0), 0.1);
		isig;
	};
	sig = sig.mean * 0.4;
	10.do { arg item, idx;
		sig = BRF.ar(sig, exprand(100,19000), 1)
	};
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	sig = WhiteNoise.ar;
	sig = num.collect { arg idx;
		var isig;
		isig = sig;
		isig = Ringz.ar(isig, LFNoise2.kr(0.01).exprange(100.0,10000.0), 0.1);
		isig = FreqShift.ar(isig, LFNoise1.kr(1/32).range(0.0,10.0)) + sig / 2;
		isig;
	};
	sig = sig.mean * 0.5;
	10.do { arg item, idx;
		sig = BRF.ar(sig, exprand(100,19000), 1)
	};
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	sig = num.collect { arg idx;
		var isig;
		isig = sig;
		isig = Ringz.ar(isig, LFNoise2.kr(0.01).exprange(100.0,10000.0), 0.1);
		//isig = FreqShift.ar(isig, LFNoise1.kr(1/32).range(0.0,100.0)) + sig / 2;
		isig = DelayL.ar(isig, 0.2, 0.1 * LFNoise1.kr(rrand(0.01,0.1)).range(0.5,2.0)) + sig;
		isig;
	};
	sig = sig.mean * 0.5;
	env1 = LFNoise1.kr(1/2).range(0.1,1.0);
	4.do { arg item, idx;
		sig = BRF.ar(sig, exprand(100,19000), 1 * env1)
	};
	env1 = LFNoise1.kr(1/7).range(0.1,1.0);
	10.do { arg item, idx;
		sig = BRF.ar(sig, exprand(100,19000), 1 * env1)
	};
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


