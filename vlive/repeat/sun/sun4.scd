////// xp with guitar layout

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
);
);


ProtoDef(\piano).startControl(Pdef(\melo))



(
Pdef(\zed, Pbind(
	\instrument, \default,
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pstep(Pseq([
			[1,3,3,2,1,1], // fa maj
			[1,1,3,3,2,1], // la# min
			[1,3,3,2,1,1]+1, // fa# maj
			[1,1,3,3,2,1], // la# min
		],1),1),
	],inf),
	\octave, 4,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/4,
	\amp, 0.1 * Pseq([
		//[\rest,\rest,\rest,\rest,\rest],
		//[0,1,0,0,1,0],
		//[0,1,0,0,1,0].rotate(rrand(0,6)),
		Plazy({ arg ev;
			Pseq([
				[0,1,0,0,1,0].rotate(rrand(0,6)),
				[0,1,0,0,1,0].rotate(rrand(0,6)),
				[0,1,0,0,1,0].rotate(rrand(0,6)),
				[0,1,0,0,1,0].rotate(rrand(0,6)),
			],4)
		}).loop,
		//[0,1,0,0,1,0],
	],inf),
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar(
		6.collect { arg idx;
			
			Pbind(
				\instrument, \default,
				\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
					Pstep(Pseq([
						[1,3,3,2,1,1], // fa maj
						[1,1,3,3,2,1], // la# min
						[1,3,3,2,1,1]+1, // fa# maj
						[1,1,3,3,2,1], // la# min
					],1),1),
				],inf),
				\octave, 4,
				\dur, 1/8 * ( idx+1 ),
				\amp, 0.1 * Pseq([
					Pseq([
						\rest
					],4 * 4  * ( idx+1 )),
					Pseq([
						Pseq([
							[1,0,0,0,0,0].rotate(idx),
						],1)
					],( ( 6-idx )+1 )*4 * 4),
				],inf),
			)
		};
	)
)).play;
);
{ SinOsc.ar(500) ! 2 * 0.1}.play;


(
Pdef(\part,
	Ppar(
		6.collect { arg idx;
			Pbind(
				\instrument, \default,
				\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
					Pstep(Pseq([
						[1,3,3,2,1,1], // fa maj
						[1,1,3,3,2,1], // la# min
						[1,3,3,2,1,1]+1, // fa# maj
						[1,1,3,3,2,1], // la# min
					],1),1),
				],inf),
				\octave, 4,
				\dur, 1/8 * ( idx+1 ),
				\amp, 0.1 * Pseq([
					Pseq([
						\rest
					],4 * 4  * ( idx+1 )),
					Pseq([
						Pseq([
							[1,0,0,0,0,0].rotate(idx),
						],1)
					],( ( 6-idx )+1 )*4 * 4),
				],inf),
			)
		};
	)
).play;
);



(
Pdef(\part,
	Ppar(
		6.collect { arg idx;
			Pbind(
				\instrument, \default,
	\instrument, \guitar0,
	\adsr, Pseq([
		{
			Env.adsr(exprand(0.001,0.3),0.1,0.8,exprand(0.01,1.5)) 
		}.dup(6)
	],inf),
				\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
					Pstep(Pseq([
						[1,1,3,3,2,1]+4, 
						[1,3,3,2,1,1]+4,
						[1,3,3,2,1,1]+5,
						[1,3,3,2,1,1],
					],1),1),
				],inf),
				\octave, Pseq([
					Pseq([
						4,4,4,4, 4,4,4,4,
					],4),
					4,4,4,4, 4,4,4,4,
					4,4,4,4, 5,5,5,5,
					4,4,4,4, 4,4,4,4,
					4,4,4,4, 3,3,3,3,
					Pseq([
						4,4,4,4, 4,4,4,4,
					],4),
					Pseq([
						4,4,4,4, 4,4,4,4,
					],2)+1,
					Pseq([
						4,4,4,4, 4,4,4,4,
					],4),
					Pseq([
						4,4,4,4, 4,4,4,4,
					],2)-1,
				],inf),
				\dur, 1/8 * ( idx+1 ),
				\amp, 0.1 * Pseq([
					Pseq([
						\rest
					],4 * 4  * ( idx+1 )),
					Pseq([
						Pseq([
							[1,0,0,0,0,0].rotate(idx),
						],1)
					],( ( 6-idx )+1 )*4 * 4),
				],inf),
			)
		};
	)
).play;
);

(
SynthDef(\guitar0, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.001,[1,1.2,1.8]]), 1);
	env2 = EnvGen.kr(Env([1,Rand(0.5,3),1]/3,[0.1,1.8]), 1);
	sig = LFSaw.ar(freq *  [1,2,1/2] *.t [1,1.0001] * ( 1 + ( SinOsc.kr(Rand(0.0,20)) * Rand(0.0,0.01) )));
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(1.2) * [1,1.001,1.1] * env1 * freq, \rq.kr(0.5) * env2);
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.31,0.1,0.8,0.4)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\guitar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var afreq = freq *  [1,2,1/2];
	env1 = EnvGen.kr(Env([1,2,1],[0.001,[1,1.2,1.8]]), 1);
	env2 = EnvGen.kr(Env([1,Rand(0.5,3),1]/3,[0.1,1.8]), 1);
	sig = LFSaw.ar(afreq *.t [1,1.0001] * ( 1 + ( SinOsc.kr(ExpRand(0.00001,20) * [1,1.01]) * ExpRand(0.000001,0.051) )));
	sig = CombL.ar(sig, 1/20, 1/afreq,0.0) + sig / 1;
	sig = sig.tanh / 2;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(1.2) * [1,1.001,1.1] * env1 * freq, \rq.kr(0.5) * env2);
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

///// sampling a rdn bass sound



TrackDef(\smp, \CustomTrackList).edit
//TrackDef(\smp, \CustomTrackList).elAt(0).presetCompileString.editorInsert
TrackDef('smp').childAt(0).trackTemplate = TrackTemplateDef('SampleTimelineTrack');
TrackDef('smp').childAt(0).label = 'SampleTimelineTrack';
TrackDef('smp').childAt(0).recBus = 0;



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\octave, 3,
			\dur, 4,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono(TrackDef(\smp).elAt(0,0).source.buffer.path),
			\pos, ~pmodenv.(Pseq([0,5,10]/1,1) + Pwhite(0.01,0.02,inf).stutter(8) + 0, 8*8).loop,
			//\pos, 0.2,
			\gdur, 0.1,
			\freq, 80,
			\pitch_stretch, Pseq([
				0,4,7,4
			],inf).midiratio,
			\octave, 3,
			\legato, 1,
			\dur, 1/2,
			\amp, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_pan,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono(TrackDef(\smp).elAt(0,0).source.buffer.path),
			\pos, ~pmodenv.(Pseq([0,5,10]/1,1) + Pwhite(0.01,0.02,inf).stutter(8) + 0, 8*8).loop,
			//\pos, 0.2,
			\gdur, 0.23723723723724,
			\freq, 66.612006872492,
			\pitch_stretch, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,-1,-1,
			],inf).midiratio,
			\octave, 3,
			\legato, 1,
			\dur, 1/8,
			\amp, 1,
		)
		
	])
)).play;
)

(
SynthDef(\gregrain_pan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	Pbind(
		\bufnum, BufDef('voices/feynman.flac'),
		\bufnum, TrackDef(\smp).elAt(0,0).source.buffer,
		\instrument, \oscsampler3b,
		\ffreq, 1000,
		\lpmix, 0.01,
		\hpfreq, 40,
		\hpmix, 1.0,
		\rq, 0.1,
		\posenv, Pseq([
			[ Env([0.000,0.0000001,0.0001].integrate.postln,[0.82,8.4]) ],
		],inf),
		\harmtab, Pseq([
			[ [1,1.01,1.001] ],
			[ [1.0001,1,1.00001] ],
			[ [1.011,1,0.991] ],
			[ [1,2,3] ],
		],inf).stutter(8),
		\pos, 0.42,
		\levelScale, 8,
		\timeScale, 2,
		\range, 0.0001,
		\note, Pseq([
			0,3,5,
		],inf).stutter(8),
		\octave, 3,
		\ffreqtab, Pseq([[Array.geom(8,4.1,0.8).postln]],inf),
		\ffreqtab, Pseq([
			[ (1..8) ],
			[Array.geom(8,4.1,0.8).postln],
			[Array.geom(8,1.1,0.8).postln]+1,
		],inf).stutter(8),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.3,0.5,1.91) ],
		],inf),
		\legato, 5.0,
		\dur, 1/4,
		\isRest, Pseq([
			1,0,0,0,
			0,0,0,0,
		],inf).coin.not,
		\amp, 0.9
	)
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscsmp,
			\bufnum, TrackDef(\smp).elAt(0,0).source.buffer,
			\pos, 1/2,
			\pos, ~pmodenv.(Pseq([0,2,1,4]/10+1,1), 8).loop,
			\note, Pseq([
				0,4,7,
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\oscrange, 1000,
			\dur, 1,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscsmp,
			\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pwhite(0,20.0),
			\note, Pseq([
				0,4,7,4,
			],inf),
			\levelScale, 0.1,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,3.8]) ]
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\oscrange, 200,
			\legato, 1,
			\dur, 4,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.8,
		),
		
	])
)).play;
);

(
SynthDef(\oscsmp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var osc;
	var phase;
	var posenv;
	osc = SinOsc.ar(freq) *  \oscrange.kr(1);
	posenv = EnvGen.kr(\posenv.kr(Env([0,1,1.1,0],[0.1,1,2.8])), 1, levelScale:\levelScale.kr(1));
	phase = \pos.kr(0) + posenv * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase + osc % BufFrames.kr(bufnum), 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscsmp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\note, Pseq([
				0,4,7,4,
			],inf),
			\levelScale, ~pmodenv.(Pseq([0.01,0.1,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,1,5.8]) ],
				[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\oscrange, 160,
			\legato, 1,
			\dur, 4,
			\amp, 0.4,
		),
		
	])
)).play;
);

///////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1248].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[821].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 3,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \default,
			\instrument, \oscsmp,
			\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\pos, 1/2,
			\pos, Pseg(Pseq([0,1,2,3],inf),8),
			\posenv, Pseq([
				[ Env([0,0.1,0.1,0.1].integrate,[0.02,1,5.8]) ],
				[ Env([0,0.1,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\oscrange, 180,

			\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
				Pstep(Pseq([
					[1,3,3,1,1,1], 
					[1,1,3,3,2,1]+3,
					[1,3,3,1,1,1]+1,
					[1,1,3,3,2,1]+7,
				],1),1),
			],inf),
			\octave, 4,
			\isRest, Pseq([
				false
			],inf),
			//\note, [4,0,3,6,1,4],
			\dur, Pconst(1,Prand([1/2,1/2,1/4,1/8,1/6],inf).stutter(4)).loop.trace,
			\amp, 0.1 * Pseq([
				//[\rest,\rest,\rest,\rest,\rest],
				//[0,1,0,0,1,0],
				//[0,1,0,0,1,0].rotate(rrand(0,6)),
				Plazy({ arg ev;
					Pseg(Pseq([
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),
						[0,1,0,0,1,0].rotate(rrand(0,6)),

						[0,1,0,0,1,0].scramble,
						[0,1,0,0,1,0].scramble,
						[0,1,0,0,1,0].scramble,
						[0,1,0,0,1,0].scramble,
					],4), 1/4)
				}).loop.trace,
				//[0,1,0,0,1,0],
			],inf),
		)
	])
)).play;
);

(
var a, b;
a = Pfinval(5, Pseq(#[1, 2, 3],inf));
b = a.asStream;
9.do({ b.next.postln; });
)

