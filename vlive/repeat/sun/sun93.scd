//////////////:
// started by trying to destroy drum loop with evolve1
// nice structuring
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
);

//////// sdesign
(
SynthDef(\chordlarbare, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var cfreq;
	env1 = EnvGen.kr(Env([0,1,4],[4,10.1]), 1);
	env2 = EnvGen.kr(Env([20000,15000,200],[4,10.1]), 1);
	cfreq = freq * \chord.kr([0,4,7]).midiratio;
	sig = LFPulse.ar(cfreq * ( SinOsc.ar(freq*2 + [ [0,0.01] ]) * \fma.kr(0) + 1 ));
	sig1 = ( cfreq *.x [3,2,1/2] ).collect { arg fr, idx;
		var isig;
		isig = LFPulse.ar(fr * ( SinOsc.ar(freq*2 + [0,0.01]) * \fma.kr(0) + 1 ));
		isig = isig * ( SinOsc.kr(1/( idx+1 )).clip(0,1) * 1 );
	};
	sig1.debug("sig1");
	sig1.shape.debug("sig1s");
	sig = sig + sig1;
	sig = sig.mean;
	sig.postln;
	sig = sig * \oscamp.kr(1);
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\evolve1, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 4;
	env1 = EnvGen.kr(Env([0,1,0],[1.4,0.41]*len), 1) * 10 + 1; // freq
	env2 = EnvGen.kr(Env([0,1,0],[2,0.1]*len), 1) * 0.4 + 1; // ffreq
	env3 = { LFNoise1.kr(1) * 0.5 + 1 }; // ffreq
	env4 = EnvGen.kr(Env([0.1,0.2,0.9],[1,1]*len), 1); // rq
	env5 = EnvGen.kr(Env([1,2,9],[1,1]*len), 1); // am
	sig = LFSaw.ar(freq * [1.01,1,0.99] * env1 *.x (0..4).midiratio *.x [1/2,2] * ( SinOsc.ar(freq/4) * 1 + 1 ));
	sig = sig.collect { arg isig, idx;
		//isig * SinOsc.ar(Rand(0.1,0.040)).clip(0,1);
		isig = isig * EnvGen.kr(Env([0,1,0],[0.01,0.1]), Impulse.kr(Rand(0.1,4) * env5));
		isig;
	};
	//sig = CombL.ar(sig, 4, LFNoise1.kr(1!sig.size).range(0.01,0.1),1) + sig;
	sig = CombL.ar(sig, 4, Rand(0.01,0.1!sig.size),1) + sig;
	sig = BPF.ar(sig, \lpfr.kr(1.1) * freq * env1 * env3.dup(sig.size), env4);
	//sig = ( sig*\distamp.kr(150) ).tanh * \distpostamp.kr(1/8);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig * 5;
	//sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evolve1,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\evolve2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 4;
	env1 = EnvGen.kr(Env([2,1,0],[1,1]*len), 1) * 6 + 1; // freq
	env2 = EnvGen.kr(Env([0,1,0],[2,0.1]*len), 1) * 0.4 + 1; // ffreq
	env3 = { LFNoise1.kr(1) * 0.5 + 1 }; // ffreq
	env4 = EnvGen.kr(Env([0.1,0.2,0.9],[1,1]*len), 1); // rq
	env5 = EnvGen.kr(Env([1,2,9],[1,1]*len), 1); // am
	sig = SinOsc.ar(freq * [1.01,1,0.99] * env1 *.x (0..4).midiratio *.x [1/2,2] * ( SinOsc.ar(freq) * 0.1 + 1 ));
	sig = sig.collect { arg isig, idx;
		//isig * SinOsc.ar(Rand(0.1,0.040)).clip(0,1);
		isig = isig * EnvGen.kr(Env([0,1,0],[0.01,0.1]), Impulse.kr(Rand(0.1,4) * env5));
		isig;
	};
	//sig = CombL.ar(sig, 4, LFNoise1.kr(1!sig.size).range(0.01,0.1),1) + sig;
	sig = CombL.ar(sig, 4, Rand(0.01,0.1!sig.size),0.1) + sig;
	sig = BPF.ar(sig, \lpfr.kr(1.1) * freq * env1 * env3.dup(sig.size), env4);
	//sig = ( sig*\distamp.kr(150) ).tanh * \distpostamp.kr(1/8);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig * 5;
	//sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evolve2,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\evolve3, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 4;
	env1 = EnvGen.kr(Env([0,0.1,2],[1,1]*len), 1) * 2 + 1; // freq
	env2 = EnvGen.kr(Env([1,0,0],[2,0.1]*len), 1) * 0.4 + 1; // ffreq
	env3 = { LFNoise1.kr(1) * 0.5 + 1 }; // ffreq
	env4 = EnvGen.kr(Env([0.1,0.2,0.9],[1,1]*len), 1); // rq
	env5 = EnvGen.kr(Env([1,2,9],[1,1]*len), 1); // am
	sig = SinOsc.ar(freq * [1.01,1,0.99] * env1 *.x (0..4).midiratio *.x [1/2,2] * ( SinOsc.ar(freq) * 0.1 + 1 ));
	sig = sig.collect { arg isig, idx;
		//isig * SinOsc.ar(Rand(0.1,0.040)).clip(0,1);
		isig = isig * EnvGen.kr(Env([0,1,0],[0.01,0.1]), Impulse.kr(Rand(0.1,4) * env5));
		isig;
	};
	//sig = CombL.ar(sig, 4, LFNoise1.kr(1!sig.size).range(0.01,0.1),1) + sig;
	sig = CombL.ar(sig, 4, Rand(0.01,0.1!sig.size)*3,0.3) + sig;
	sig = BPF.ar(sig, \lpfr.kr(1.1) * freq * env1 * env3.dup(sig.size), env4);
	//sig = ( sig*\distamp.kr(150) ).tanh * \distpostamp.kr(1/8);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig * 5;
	sig = HPF.ar(sig, EnvGen.kr(Env([10,10,15000],[4,8]), 1));
	//sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evolve3,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\fx1, \audio)) <> Pdef(\drums1),
		Pmono(\fxevolve1,
			\inbus, BusDef(\fx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\fxevolve1, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 10;
	env1 = EnvGen.kr(Env([1,20,1],[1,1]*len), 1);
	sig = in;
	sig = ( sig*\distamp.kr(140) ).tanh * \distpostamp.kr(1/4);
	sig = CombL.ar(sig, 4, 1/8 * env1/10,1) + sig;
	sig = sig * 0.4;
	sig = BPF.ar(sig, EnvGen.kr(Env([100,10000,300],[1,1]*len), 1));
	sig = SelectX.ar(\mix.kr(0.51), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fxevolve2, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 10;
	env1 = EnvGen.kr(Env([1,20,1],[1,1]*len), 1); // dist comb
	env2 = EnvGen.kr(Env([0,0,2000],[1,1]*len), 1); // fshift
	env3 = EnvGen.kr(Env([0.1,1,0.5,1],[0.9,len,10]), 1); // mix
	sig = in;
	sig = ( sig*\distamp.kr(14)*env1 ).tanh * \distpostamp.kr(1/4);
	sig = CombL.ar(sig, 4, 1/8 * env1/10,1) + sig;
	sig = FreqShift.ar(sig, env2);
	sig = sig * 0.4;
	sig = BPF.ar(sig, EnvGen.kr(Env([100,10000,300],[1,1]*len), 1));
	//sig = sig * SinOsc.ar(30 * env1 * EnvGen.kr(Env([1,2,1],[0.1,0.8]), Impulse.kr(1)));
	sig = SelectX.ar(env3, [in, sig]);
	//sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fxevolve3, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 10;
	env1 = EnvGen.kr(Env([1,1.2,20],[1,1]*len), 1); // dist comb
	env2 = EnvGen.kr(Env([0,0,2000],[1,1]*len), 1); // fshift
	env3 = EnvGen.kr(Env([0,0.1,0.5,1],[0.9,len,10]), 1); // mix
	sig = in;
	sig = ( sig*\distamp.kr(14)*env1 ).tanh * \distpostamp.kr(1/4);
	sig = CombL.ar(sig, 4, 1/8 * env1/10,1) + sig;
	sig = FreqShift.ar(sig, env2);
	sig = sig * 0.4;
	sig = BPF.ar(sig, EnvGen.kr(Env([100,10000,300],[1,1]*len), 1));
	//sig = sig * SinOsc.ar(30 * env1 * EnvGen.kr(Env([1,2,1],[0.1,0.8]), Impulse.kr(1)));
	sig = SelectX.ar(env3, [in, sig]);
	//sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

//////// compo

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1089].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,0.4,0.4,
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[804].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,1,0,
				1,1,0,1, 0,0,1,0,
				1,0,1,1, 0,0,1,1,
				1,0,1,0, 1,1,0,1,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\legato, 1 * Pseq([
				0.8,0.4,1,0.4,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				0.8,0.4,1,0.4,
			],inf)/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\introchord, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0,4,7],
				[0,5,8],
			],inf).stutter(4*4),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\fxevolve1,
			\inbus, BusDef(\fx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\secintro, 
	Ppar([
		Pseq([
			Pfindur(4,Pbind(
				\instrument, \default,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			)),
			Pfindur(16, Ppar([
				Pbind(
					\instrument, \default,
					\note, Pseq([
						[0,4,7],
						[0,5,8],
					],inf).stutter(4*4),
					\octave, 5,
					\dur, 1/8,
					\amp, 0.1/2,
					\out, BusDef(\fx1, \audio),
				),
				Pmono(\fxevolve3,
					\inbus, BusDef(\fx1, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			])),
			Pfindur(16, Ppar([
				Pbind(\out, BusDef(\fx1, \audio)) <> Pdef(\drums1),
				Pmono(\fxevolve2,
					\inbus, BusDef(\fx1, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
				Pbind(
					\instrument, \sh101,
					\note, Pseq([
						[0,4,7],
						[0,5,8],
					],inf).stutter(4*4),
					\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
					\lpf, 200,
					\octave, 5,
					\dur, 1/8,
					\amp, 0.1/2,
				),
			])),
		],1),
	])
)).play;
);



(
Pdef(\part, Pdef(\secpart1, 
	Ppar([

		Pfindur(16, Ppar([
			Pdef(\drums1),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([100,2004],1), 8).loop,
				\octave, Pseq([
					3,3,4,3,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve2,
					\dur, 1,
					\amp, 0.1/3/2,
				),
			]),
		])),
	])
)).play;
);

(
Pdef(\part, Pdef(\secpart2, 
	Ppar([

		Pfindur(16, Ppar([
			Pdef(\drums1),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([100,204],1), 8).loop,
				\legato, 0.4,
				\octave, Pseq([
					3,3,4,3,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \mellowpad,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(1),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 2,
				\amp, 0.1/5/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					Pser([
						0,4,7,4
					],16),
					Pser([
						0,5,8,5,
					],16),
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, Pseg(Pseq([0.1,1],inf),16),
				\lpf, 200,
				\octave, Pseq([
					5,5,6,5,
					5,5,6,5,
					5,5,6,5,
					5,7,5,7,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fx2, \audio),
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,4,0,5,4
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, 0.8,
				\lpf, 1200,
				\adsr, Pseq([
					[ Env.adsr(3.1,0.1,0.8,3.1) ],
				],inf),
				\octave, Pseq([
					4,4,4,5,
				],inf),
				\dur, Pseq([3,1],inf),
				\amp, 0.1/2,
				\out, BusDef(\fx2, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\fx2, \audio),
				\delay, 1/6/~t,
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, 0.4,
				\dur, 1,
			),

			Ptpar([
				8, Pmono(\evolve3,
					\dur, 1,
					\amp, 0.1/3/2,
				),
			]),
		])),
	])
)).play;
);

(
Pdef(\part, Pdef(\secair1, 
	Ppar([

		Pfindur(16, Ppar([
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					Pser([
						0,4,7,4
					],16),
					Pser([
						0,5,8,5,
					],16),
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, Pseg(Pseq([0.1,1],inf),16),
				\lpf, 200,
				\octave, Pseq([
					5,5,6,5,
					5,5,6,5,
					5,5,6,5,
					5,7,5,7,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fx2, \audio),
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,4,0,5,4
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, 0.8,
				\lpf, 1200,
				\adsr, Pseq([
					[ Env.adsr(3.1,0.1,0.8,3.1) ],
				],inf),
				\octave, Pseq([
					4,4,4,5,
				],inf)+1,
				\dur, Pseq([3,1],inf),
				\amp, 0.1/2,
				\out, BusDef(\fx1, \audio),
			),
			Pmono(\fxevolve1,
				\inbus, BusDef(\fx1, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\dur, 1,
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\fx2, \audio),
				\delay, 1/6/~t,
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, 0.4,
				\dur, 1,
			),

			Ptpar([
				8, Pmono(\evolve1,
					\dur, 1,
					\amp, 0.1/3/2,
				),
			]),
		])),
	])
)).play;
);




(
Pdef(\part, Pdef(\secpart1bis, 
	Ppar([

		Pfindur(16, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1089].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					Pseq([
						0
					],16),
					1,1,0,0, 1,0,0,1,
					0,0,1,0, 0,0,0,0,
					Pseq([
						0
					],16),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1662].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pser([
						0
					],16),
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,0,
					Pser([
						0
					],16),
					0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,1,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					1,0.4,0.4,0.4,
				],inf)/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[804].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 0,0,1,0,
					1,1,1,1, 1,0,1,1,
					Pseq([
						1
					],inf),
				],inf).coin.not,
				\legato, 1 * Pseq([
					0.8,0.4,1,0.4,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pseq([
					0.8,0.4,1,0.4,
				],inf)/2,
			),

			Pseq([
				
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
					\legato, 1,
					\st, 119/2/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseg(Pseq([
						0, 1,
					]+0,1),4) / Pkey(\st),
					\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,0,0, 0,0,0,0,
						Pseq([
							1
						],inf),
					],inf).coin.not,
					\dur, 1/8,
					\gain, 1/8/2,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
					\legato, 1,
					\st, 119/2/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseg(Pseq([
						0, 2,
					]+0,4),2) / Pkey(\st),
					\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,0,0, 0,0,0,0,
						Pseq([
							1
						],inf),
					],inf).coin.not,
					\dur, 1/8,
					\gain, 1/8/2,
				),
			],inf),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([100,2004],1), 8).loop,
				\octave, Pseq([
					3,3,4,3,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve2,
					\dur, 1,
					\amp, 0.1/3/2,
				),
			]),
		])),
	])
)).play;
);

(
Pdef(\part, Pdef(\secpart1bis2, 
	Ppar([

		Pfindur(16, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1089].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					Pseq([
						0
					],16),
					1,1,0,0, 1,0,0,1,
					0,0,1,0, 0,0,0,0,
					Pseq([
						0
					],16),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1662].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pser([
						0
					],8),
					Pseq([
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,1,0,
						0,1,0,0, 1,1,0,1,
					],inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					1,0.4,0.4,0.4,
				],inf)/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[804].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 0,0,1,0,
					1,1,1,1, 1,0,1,1,
					Pseq([
						1
					],8),
				],inf).coin.not,
				\legato, 1 * Pseq([
					0.8,0.4,1,0.4,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pseq([
					0.8,0.4,1,0.4,
				],inf)/2,
			),

			Pseq([
				
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
					\legato, 1,
					\st, 119/2/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseg(Pseq([
						0, 2,
					]+0,4),2) / Pkey(\st),
					\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,0,0, 0,0,0,0,
						Pseq([
							1
						],inf),
					],inf).coin.not,
					\dur, 1/8,
					\gain, 1/8/1.5,
				),
			],inf),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([100,2004],1), 8).loop,
				\octave, Pseq([
					3,3,4,3,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve2,
					\dur, 1,
					\amp, 0.1/6,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					(0..7),
					(0..1),
					(0..1),
					(0..1),
					0,0,0,
				].flat,inf)+Pstep(Pseq([0,1,3],4),4) * 1/4 * Pstep(Pseq([1,1/2]),8),
				\speed, Pseg(Pseq([1,1,2],inf),Pseq([15,1])),
				\legato, 1,
				\dur, 1/8,
				\gain, 0.2,
			)
		])),
	])
)).play;
);

(
Pdef(\part, Pdef(\secpart1bis3, 
	Ppar([

		Pfindur(16, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1089].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					Pseq([
						0
					],16),
					1,1,0,0, 1,0,0,1,
					0,0,1,0, 0,0,0,0,
					Pseq([
						0
					],16),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1662].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pser([
						0
					],8),
					Pseq([
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,1,0,
						0,1,0,0, 1,1,0,1,
					],inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					1,0.4,0.4,0.4,
				],inf)/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[804].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 0,0,1,0,
					1,1,1,1, 1,0,1,1,
					Pseq([
						1
					],8),
				],inf).coin.not,
				\legato, 1 * Pseq([
					0.8,0.4,1,0.4,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pseq([
					0.8,0.4,1,0.4,
				],inf)/2,
			),
			Pbind(
				\instrument, \reese,
				\fspread, 0.024000000208616,
				\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.1099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\lpadsramt, PmodEnv(Pseq([1,4,8],1), 8).loop,
				\kbamt, 0.0,
				\distamp, 10.0,
				\distpostamp, 0.5,
				\lpf, 330.0,
				\rq, 0.3,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.40000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\spread, 0.80000001192093,
				\note, Pseq([
					0,4,5,2,0,-3,-5
				],inf),
				\octave, 6,
				\dur, Pseq([1/8,1/8,1/8,1/4],inf),
				\amp, 0.1/4,
			),

			Pseq([
				
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
					\legato, 1,
					\st, 119/2/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseq([
						0,0,0,7, 7,8,8,9,
						(0..7),
						(0..7)+10,
						(0..7)+20,
					].flat,inf)/8 / Pkey(\st),
					\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,0,0, 0,0,0,0,
						Pseq([
							1
						],inf),
					],inf).coin.not,
					\dur, 1/8,
					\gain, 1/8/1.5,
				),
			],inf),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([500,2004],1), 8).loop,
				\legato, 0.4,
				\octave, Pseq([
					3,3,4,3,
					5,2,3,3,
				],inf),
				\legato, Pseq([
					3,0,0,1, 1,0,0,0,
					1,0,1,1, 1,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve3,
					\dur, 1,
					\amp, 0.1/6,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					Pseq([
						3,2,1,0,
					],1),
				].flat,inf) + Pseg(Pseq([0,1/8],inf),16),
				\speed, Pseq([-1],inf),
				\legato, 1,
				\dur, 1/8,
				\gain, 0.2,
			)
		])),
	])
)).play;
);

(
Pdef(\part, Pdef(\secpart1bis4, 
	Ppar([

		Pfindur(16, Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1089].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1662].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,1,0,
						0,1,0,0, 1,1,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					1,0.4,0.4,0.4,
				],inf)/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[804].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\legato, 1 * Pseq([
					0.8,0.4,1,0.4,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11/2 * Pseq([
					0.8,0.4,1,0.4,
				],inf)/2,
			),
			Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, ~buflib.hat[242].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8),
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\hpf, PmodEnv(Pseq([100,100,5000],1), 8).loop,
				\legato, 2,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0,0,2]/2,inf),8),
			),

			Pseq([
				
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
					\legato, 1,
					\st, 119/2/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseq([
						Pseq([ 0,\r,2,\r,4,\r,2,\r, ],1),
						Pseq([ 8,9,2,\r,4,\r,2,\r, ],1),
						Pseq([ 12,13,2,\r,4,\r,2,\r, ],1),
						Pseq([ 12,13,2,\r,4,\r,2,\r, ],1)+8,
					].flat,inf)/8 / Pkey(\st),
					\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,0,0, 0,0,0,0,
						Pseq([
							1
						],inf),
					],inf).coin.not,
					\dur, 1/8,
					\gain, 1/8/1.5,
				),
			],inf),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([500,2004],1), 8).loop,
				\legato, 0.4,
				\octave, Pseq([
					3,3,4,3,
					5,2,3,3,
				],inf),
				\legato, Pseq([
					3,0,0,1, 1,0,0,0,
					1,0,1,1, 1,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve3,
					\dur, 1,
					\amp, 0.1/6,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					Pseq([
						1,4,4,1,
					],1),
				].flat,inf) * Pseg(Pseq([0,1/8],inf),16),
				\speed, Pseq([1,1/2],inf),
				\legato, 1,
				\dur, 1/8,
				\gain, 0.2,
			)
		])),
	])
)).play;
);

(
Pdef(\part, Pdef(\secpart1bis5, 
	Ppar([

		Pfindur(16, Ppar([
			Pbind(
				\instrument, \reese,
				\fspread, 0.024000000208616,
				\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.1099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\lpadsramt, PmodEnv(Pseq([1,4,8],1), 8).loop,
				\kbamt, 0.0,
				\distamp, 10.0,
				\distpostamp, 0.5,
				\lpf, 330.0,
				\rq, 0.3,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.40000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\spread, 0.80000001192093,
				\note, Pseq([
					0,4,5,2,0,-3,-5
				],inf),
				\octave, 6,
				\dur, Pseq([1/8,1/8,1/8,1/4],inf),
				\amp, 0.1/4,
			),

			Pseq([
				
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
					\legato, 1,
					\st, 119/2/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseq([
						2,\r,2,\r,
					].flat,inf)/8 / Pkey(\st) + Pseg(Pseq([0,0.1],inf),16),
					\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,0,0, 0,0,0,0,
						Pseq([
							1
						],inf),
					],inf).coin.not,
					\dur, 1/8,
					\gain, 1/8/1.5,
				),
			],inf),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([500,2004],1), 8).loop,
				\legato, 0.4,
				\octave, Pseq([
					3,3,4,3,
					5,2,3,3,
				],inf),
				\legato, Pseq([
					3,0,0,1, 1,0,0,0,
					1,0,1,1, 1,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve3,
					\dur, 1,
					\amp, 0.1/6,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					Pseq([
						3,2,1,0,
					],1),
				].flat,inf) + Pseg(Pseq([0,1/8],inf),16),
				\speed, Pseq([-1],inf),
				\isRest, Pseq([
					0,0,1,0, 1,0,0,1,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.2,
			)
		])),
	])
)).play;
);
(
Pdef(\part, Pdef(\secpart1bis6, 
	Ppar([

		Pfindur(16, Ppar([
			Pbind(
				\instrument, \reese,
				\fspread, 0.024000000208616,
				\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.1099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\lpadsramt, PmodEnv(Pseq([1,4,8],1), 8).loop,
				\kbamt, 0.0,
				\distamp, 10.0,
				\distpostamp, 0.5,
				\lpf, 330.0,
				\rq, 0.3,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.40000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\spread, 0.80000001192093,
				\note, Pseq([
					0,4,5,2,0,-3,-5
				],inf),
				\octave, 6,
				\dur, Pseq([1/8,1/8,1/8,1/4],inf),
				\amp, 0.1/4,
			),

			Pseq([
				
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
					\legato, 1,
					\st, 119/2/60,
					\speed, 1 * ~t / Pkey(\st),
					\pos, Pseq([
						2,\r,2,\r,
					].flat,inf)/8 / Pkey(\st) + Pseg(Pseq([0,0.1],inf),16),
					\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,0,0, 0,0,0,0,
						Pseq([
							1
						],inf),
					],inf).coin.not,
					\dur, 1/8,
					\gain, 1/8/1.5,
				),
			],inf),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([8500,2004],1), 8).loop,
				\legato, 0.4,
				\octave, Pseq([
					3,3,4,3,
					5,2,3,3,
				],inf),
				\legato, Pseq([
					3,0,0,1, 1,0,0,0,
					1,0,1,1, 1,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve3,
					\dur, 1,
					\amp, 0.1/6,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					Pseq([
						3,2,1,0,
					],1),
				].flat,inf) + Pseg(Pseq([0,1/8],inf),16),
				\speed, Pseq([-1],inf),
				\isRest, Pseq([
					0,0,1,0, 1,0,0,1,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.2,
			)
		])),
	])
)).play;
);
(
///////////////// main ////////////
Pdef(\part, Pdef(\main, 
	Pseq([
		Pdef(\secintro),
		Pdef(\secpart1),
		Pdef(\secpart2),
		Pdef(\secair1),
		Pfindur(16,Pdef(\secbare)),
		Pdef(\secpart1bis),
		Pdef(\secpart1bis2),
		Pdef(\secpart1bis4),
		Pdef(\secpart1bis6),
		Pdef(\secother1),
		Pdef(\secpart1),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Pfindur(16,Ppar([
		
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					4,4,0,0,
					8,8,5,5,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\envamt, 5,
				\lpadsr, Pseq([
					PpatEnv.adsr(
						Pseg(Pseq([0,0.1,1],inf),8)
						,0.1,0.8,0.1),
				],inf),
				\lpf, PmodEnv(Pseq([150,300,1204],1), 8).loop,
				\legato, 0.4,
				\octave, Pseq([
					3,5,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fxgr3, \audio),
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,0.2,0.5) ],
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, Pseq([
					2000,200,500
				],inf) * Pseq([1,0.5,0.8],inf).stutter(9*2),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.2,0.5,0.3) ],
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fxgr3, \audio),
			),

			Ptpar([
				8, Pmono(\evolve3,
					\dur, 1,
					\amp, 0.1/6,
				),
			]),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					Pseq([
						3,2,1,0,
					],1),
				].flat,inf) + Pseg(Pseq([0,1/8],inf),16) + 3.1,
				\speed, Pseq([-1*1],inf),
				\isRest, Pseq([
					0,0,1,0, 1,0,0,1,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.2,
				\out, BusDef(\fxgr3, \audio),
			),
			Pbind(
				\instrument, \mellowpad,
				\note, Pseq([
					[0,4,7,12,7+12],
					[0,5,8,12,8+12],
				],inf).stutter(1),
				\envamt, 3,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,1.5) ],
				],inf),
				\lpf, PmodEnv(Pseq([400,2000],1), 16).loop,
				\octave, 5,
				\dur, 2,
				\amp, 0.1/5/2,
				\out, BusDef(\fxgr3, \audio),
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					Pser([
						0,4,7,4
					],16),
					Pser([
						0,5,8,5,
					],16),
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, Pseg(Pseq([0.1,1],inf),16),
				\lpf, 900,
				\octave, Pseq([
					5,5,6,5,
					5,5,6,5,
					5,5,6,5,
					5,7,5,7,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fx2, \audio),
			),
			Pbind(
				\instrument, \stringpad,
				\note, Pseq([
					0,4,0,5,4
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, 0.8,
				\lpf, 1200,
				\adsr, Pseq([
					[ Env.adsr(3.1,0.1,0.8,3.1) ],
				],inf),
				\octave, Pseq([
					4,4,4,5,
				],inf)+2,
				\dur, Pseq([3,1],inf),
				\amp, 0.1/2,
				\pan, Pseg(Pseq([-1,0,1],inf),8),
				\out, BusDef(\fx2, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\fx2, \audio),
				\delay, 1/6/~t,
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, 0.4,
				\dur, 1,
				\out, BusDef(\fxgr3, \audio),
			),
			Pbind(
				\instrument, \reese,
				\fspread, 0.024000000208616,
				\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.1099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\lpadsramt, PmodEnv(Pseq([1,4,8],1), 8).loop,
				\kbamt, 0.0,
				\distamp, 10.0,
				\distpostamp, 0.5,
				\lpf, 330.0,
				\rq, 0.3,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.40000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\spread, 0.80000001192093,
				\note, Pseq([
					0,4,5,2,0,-3,-5
				],inf),
				\octave, 6,
				\dur, Pseq([1/8,1/8,1/8,1/4],inf),
				\amp, 0.1/4,
				\out, BusDef(\fxgr3, \audio),
				\pan, Pseq([
					-1,0.5,-1,1,0.6,
				],inf),
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1089].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\fxgr1, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10,400,2000],1), 8).loop,
			\lag, 0.0008,
			\dur, 1,
			\mix, 1,
			\gain, 2,
			\out, BusDef(\fxgr2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\fxgr2, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([20000,11400,7800],1), 8).loop,
			\lag, 0.0009,
			\mix, 1,
			\gain, 2,
			\dur, 1,
			\out, BusDef(\fxgr4, \audio),
		),
		Pmono(\fxtouch,
			\inbus, BusDef(\fxgr3, \audio),
			\addAction, \addToTail,
			\lag, 0.0007,
			\mix, 0,
			\dur, 1,
			\out, BusDef(\fxgr1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fxgr4, \audio),
			\addAction, \addToTail,
			\room, 4,
			\mix, PmodEnv(Pseq([0,0.1,1],1), 8).loop,
			\lag, 0.0010,
			\dur, 1,
		),
		Ptpar([
			8, Pdef(\drums2)
		]),
	]))
)).play;
);

(
SynthDef(\fxtouch, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lvl;
	sig = in;
	lvl = SinOsc.ar(1.1300 * ( SinOsc.kr(1 * ( SinOsc.kr(0.1) * 1 + 1 )) * 1 + 1 ) * ( SinOsc.ar(400 * ( SinOsc.kr(0.4) * 1 + 1 )) * 1 + 1 ));
	sig = 7.collect { arg idx;
		BPF.ar(sig, ( idx+1/2 )* 2300 * ( lvl * 0.7 + 1 ) );
	}.mean;
	sig = sig * 2;
	sig = Splay.ar(sig, \spread.kr(1), 1, SinOsc.ar(4 * ( SinOsc.kr(0.2) * 1 + 1 )) * ( SinOsc.kr(0.1) * 1 + 1 ) );
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\fx3,\audio)) <> Pdef(\drums1),
		Pmono(\fx_stutter,
			\inbus, BusDef(\fx3, \audio),
			\addAction, \addToTail,
			\time, 1/8/~t * Prand([1,2,1/2,3],inf),
			\rate, Prand([1,1/2],inf),
			\mix, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,1,1,
					].scramble,1)
				}).loop,
				0,0,0,0, 1,1,0,0,
				1,1,0,0, 0,0,1,1,
			],inf),
			\lag, 0.0009,
			\dur, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(\out, BusDef(\fx3,\audio)) <> Pdef(\drums1),
		Pmono(\fx_stutter,
			\inbus, BusDef(\fx3, \audio),
			\addAction, \addToTail,
			\time, 1/8/~t * Pseq([1,1/2],inf).stutter(4),
			\rate, Pseg(Pseq([1,1,1,1,0.4],1),1).loop,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.2,0.2,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
			],inf),
			\lag, 0.0008,
			\dur, 1/8,
			\out, BusDef(\fx3b, \audio),
		),
		Pmono(\fx_decimator,
			\inbus, BusDef(\fx3b, \audio),
			\addAction, \addToTail,
			\bits, 8,
			\rate, Pseq([
				10000,
				1000,
				41000,
			],inf),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,1,
				0,0,0,1, 0,0,0,0,
				0,1,1,1, 1,0,1,1,
				0,0,0,0, 0,1,0,0,
			],inf),
			\lag, 0.0009,
			\dur, 1/8,
		),
		
	])
)).play;
);

(
// algo chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7],
				[0,5,8],
				[0,4,7],
				[-1,5,8],
			],inf).collect { arg item, idx;
				item = item +.x [-12,0,12];
				~mem = ~mem ?? { (0..(3*3-1)) };
				~mem = ~mem.keep(4);
				~mem.removeAt(~mem.size.rand);
				~mem = ~mem.add( (0..(3*3-1)).choose );
				item[~mem];
			}.stutter(16).trace,
			\octave, 5,
			\legato, 0.4,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
// algo chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7],
				[0,5,8],
				[0,4,7],
				[-1,5,8],
			],inf).collect { arg item, idx;
				item = item +.x [-12,0,12];
				~mem = ~mem ?? { (0..(3*3-1)) };
				~mem = ~mem.keep(4);
				~mem.removeAt(~mem.size.rand);
				~mem = ~mem.add( (0..(3*3-1)).choose );
				item[~mem];
			}.stutter(16).trace,
			\octave, 5,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2.5,
		),
			Pbind(
				\instrument, \reese,
				\fspread, 0.024000000208616,
				\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.1099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\lpadsramt, PmodEnv(Pseq([1,4,8],1), 8).loop,
				\kbamt, 0.0,
				\distamp, 10.0,
				\distpostamp, 0.5,
				\lpf, 330.0,
				\rq, 0.3,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.40000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\spread, 0.80000001192093,
				\note, Pseq([
					0,4,5,2,0,-3,-5
				],inf),
				\octave, 6,
				\dur, Pseq([1/8,1/8,1/8,1/4],inf),
				\amp, 0.1/4,
				//\out, BusDef(\fxgr3, \audio),
				\pan, Pseq([
					-1,0.5,-1,1,0.6,
				],inf),
			),
			Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.50000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.20000000298023,
				\modIndex, PmodEnv(Pseq([0,1],1), 16).loop,
				\mix, PmodEnv(Pseq([0,1],1), 16).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\asr, [ [ 0.0, 2.0, 1.0, -99.0, 1.0, 0.0, 5.0, -4.0, 0.0, 0.10000000149012, 5.0, -4.0 ] ],
				\note, Pseq([
					Pser([
						0,4,7,4
					],16),
					Pser([
						0,5,8,5,
					],16),
				],inf),
				\octave, Pseq([
					5,5,6,5,
					5,5,6,5,
					5,5,6,5,
					5,7,5,7,
				],inf)-1,
				\dur, 1/8,
				\amp, 0.1/2,
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\secother1, 
	Pfindur(16,Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[0,4,7],
				[0,5,8],
				[0,4,7],
				[-1,5,8],
			],inf).stutter(16),
			\octave, 5,
			\legato, 0.4,
			\dur, 1/8,
			\lpf, PmodEnv(Pseq([600,202],8), 1).loop,
			\adsr, Pseq([
				PpatEnv.adsr(0.01,0.1,0.8, Pseg(Pseq([0.01,0.4],inf),8)),
			],inf),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					8,7,5
				],8),
				8,7,8,4,4,10,0,7,8,10,0,
			],inf).stutter(1),
			\octave, 6,
			\lpf, PmodEnv(Pseq([100,500],1), 8).loop,
			\envamt, 3,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.5) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.31) ],
			],inf),
			\legato, 0.4,
			\dur, 1/8,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\note, Pseq([
				Pser([
					8,7,5,
				],16),
				Pser([
					8,7,5,
				],16),
			],inf).stutter(1),
			\octave, Pseq([5,5,6],inf),
			\vel, Pseq([1,1.3,0.7],inf),
			\lpf, PmodEnv(Pseq([100,500],1), 8).loop,
			\envamt, 3,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.2,0.1,0.5) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.81) ],
			],inf),
			\legato, 0.4,
			\dur, Pseq([Pn(1/8,6),1/4 ],inf),
			\amp, 0.1/2,
			\out, BusDef(\fx5, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\fx5),
			\pregain, 1/2,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\addAction, \addToTail,
			\lag, 0.0007,
			\sendbus0, BusDef(\fx5pp, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_pingpong,
			\inbus, BusDef(\fx5pp, \audio),
			\addAction, \addToTail,
			\lag, 0.0008,
			\dur, 1,
			\out, BusDef(\fx5fs, \audio),
		),
		Pmono(\fx_freqshift,
			\inbus, BusDef(\fx5fs, \audio),
			\shift, Pseq([
				13,
			],inf),
			\mix, 0.2,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			4, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([100,2004],1), 8).loop,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\octave, Pseq([
					3,3,4,3,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			12, Pdef(\drums2)
		]),
	]))
)).play;
);



//////////////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,7,0, 8,8,7,8,
			],inf),
			\envamt, Pseg(Pseq([1,8],1),8).loop,
			\lpf, 200,
			\octave, Pseq([3,3,4],inf),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,4,4,4,
				5,5,5,5,

				4,4,4,4,
				5,5,5,5,

				12,7,4,7,
				5,5,5,5,

				4,4,4,4,
				8,5,8,12,
			],inf),
			\envamt, Pseg(Pseq([1,8],1),8).loop,
			\lpf, 400,
			\octave, Pseq([5,5,6,5],inf),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1089].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.4,0.4,0.4,
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[264].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,1,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[804].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				0.8
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[294].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\legato, 2,
			\isRest, Pseq([
				0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,
				0,0,0,0, 1,0,0,
				1,0,1,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[418].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,
				0,0,0,0, 1,0,0,
				0,0,0,0, 1,0,0,
				0,0,0,0, 1,0,0,
				1,0,1,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
		),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 700,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/4,
			),
	])
)).play;
);

(
// adapted to sun93
Pdef(\part, Pdef(\secbare, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//Prand([2,0]), 0, Prand([-3,2]),
				//Prand([4,0]), 0, Prand([-4,4]),
				Prand([4,0]),Prand([5,2,7]),0,-1,
			],inf),
			\octave, 6,
			\envamt, PmodEnv(Pseq([1,2,8],1), 8).loop,
			\lpf, Pseq([300,300,Prand([300,100]),300],inf),
			\dur, 1/8,
			\amp, 0.1/2 * Ppatlace([
				Pseg(Pseq([0,1,Pn(1,inf)],inf),4), Pseg(Pseq([0,0.1,1],inf),8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\out, BusDef(\fx1, \audio),
			\pan, Ppatlace([
				Pbrown(-1,1,0.1,inf).trace/2,
				Pbrown(-1,1,0.1,inf).trace/2,
				//Pbrown(-1,1,0.1,inf).trace/2,
				//Pbrown(-1,1,0.1,inf).trace/2,
			],inf).stutter(2)
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			\mix, 0.1,
			\lag, 0.0008,
			\dur, 1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.4,
			\dur, 1,
		),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
				\isRest, true,
			),
		Pmono(\chordlarbare,
			\note, Pseq([
				0,
			],inf),
			\octave, 6,
			\chord, Pseq([
					[ [0,4,7] ],
					[ [0,5,8] ],
			],inf),
			\dur, 2,
			\amp, 0.07,
		)
		<>
		Pseq([
			Pbind(
				\oscamp, PmodEnv(Pseq([0,4,3],1), 8),
				\fma, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000,600],1), 4).loop,
			),
			Pbind(
				\oscamp, PmodEnv(Pseq([1,1,1.5],1), 8),
				\fma, PmodEnv(Pseq([4,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000],1), 1).loop,
			),
		],inf),
		Ptpar([
			8, Pmono(\evolve3,
				\dur, 1,
				\amp, 0.1/3/2,
			),
		]),
	])
)).play;
);

(
// orig
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//0,Prand([5,4]),Prand([7,9,10]),2,
				Prand([2,0]), 0, Prand([-3,2]),
			],inf),
			\octave, 6,
			\envamt, PmodEnv(Pseq([1,2,8],1), 8).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1/2 * Ppatlace([
				Pseg(Pseq([0,1,Pn(1,inf)],inf),4), Pseg(Pseq([0,0.1,1],inf),8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\out, BusDef(\fx1, \audio),
			\pan, Pbrown(-1,1,inf)/2,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			\mix, 0.1,
			\lag, 0.0008,
			\dur, 1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.4,
			\dur, 1,
		),
		Pmono(\chordlarbare,
			\note, Pseq([
				7,2+12,9,5
			],inf),
			\chord, Pseq([
				[ [ 0,4,7 ] ],
				[ [ 0,-5,-9 ] ],
				[ [ 0,4,7-12 ] ],
				[ [ 0,4,7 ] ],
			],inf),
			\dur, 2,
			\amp, 0.07,
		)
		<>
		Pseq([
			Pbind(
				\oscamp, PmodEnv(Pseq([0,4,3],1), 8),
				\fma, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000,600],1), 4).loop,
			),
			Pbind(
				\oscamp, PmodEnv(Pseq([1,1,1.5],1), 8),
				\fma, PmodEnv(Pseq([4,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000],1), 1).loop,
			),
		],inf),
	])
)).play;
);


////////////////////// start arrange from scratch


(
Pdef(\part, Pdef(\secbase1, 
	Ppar([

		Pfindur(32, Ppar([
			Pdef(\drums1),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([100,2004],1), 16).loop,
				\octave, Pseq([
					3,3,4,3,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, [
					~buflib.hat[1071].value,
					~buflib.hat[1361].value,
				],
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\legato, 8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					Pseq([ 0,0,0,0, 0,0,0,0, ],15),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\fxverb, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('field/clap.flac'),
				\pos, 0,
				\legato, 1,
				\dur, 1,
				\gain, 1/4,
			),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\fxverb, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\room, 3,
				\dur, 1,
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),

			Ptpar([
				8, Pmono(\evolve2,
					\dur, 1,
					\amp, 0.1/3/2,
				),
			]),
		])),
	])
)).play;
);

////////////////// arrange with ClipTimeline

ClipTimeline(\sun93).edit
ClipTimeline(\sun93).presetCompileString.editorInsert
(
ClipTimeline('sun93').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'muted': false, 'recordBus': 0, 'index': 4, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 5, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 6, 'recordArmed': false, 
  'solo': false ) ];
{
ClipTimeline('sun93').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \pattern: Pdef('drums1'), \playDur: 0.0, \relDur: 0.0, \sustain: 15.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 1.0, \pattern: Pdef('chords1'), \playDur: 0.0, \relDur: 0.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 4.0, \legato: 1, \midinote: 2.0, \pattern: Pdef('bass1'), \playDur: 4.0, \relDur: 4.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 4.0, \dur: 4.0, \legato: 1, \midinote: 6.0, \pattern: Pdef('evolve1'), \playDur: 4.0, \relDur: 4.0, \sustain: 4.0, \type: 'pattern', )),
	PatternEvent((\absTime: 8.0, \dur: 8.0, \legato: 1, \midinote: 3.0, \pattern: Pdef('meloparty'), \playDur: 8.0, \relDur: 8.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 16.0, \dur: 0.0, \legato: 1, \midinote: 1.0, \pattern: Pdef('chords2'), \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 16.0, \dur: 0.0, \legato: 1, \midinote: 5.0, \pattern: Pdef('feyn1'), \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 16.0, \dur: 6.0, \legato: 1, \midinote: 0.0, \pattern: Pdef('drums2'), \playDur: 6.0, \relDur: 6.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 22.0, \dur: 2.0, \legato: 1, \midinote: 6.0, \pattern: Pdef('evolve2'), \playDur: 2.0, \relDur: 2.0, \sustain: 2.0, \type: 'pattern', )),
	PatternEvent((\absTime: 24.0, \dur: 0.0, \legato: 1, \midinote: 4.0, \pattern: Pdef('melopart1'), \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 24.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \pattern: Pdef('drums1'), \playDur: 0.0, \relDur: 0.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 24.0, \dur: 4.0, \legato: 1, \midinote: 1.0, \pattern: Pdef('chords1'), \playDur: 4.0, \relDur: 4.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 28.0, \dur: 4.0, \legato: 1, \midinote: 6.0, \pattern: Pdef('evolve3'), \playDur: 4.0, \relDur: 4.0, \sustain: 4.0, \type: 'pattern', )),
	(\absTime: 32.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

(
Pdef(\part, Pdef(\chords1, 
	Ppar([
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					[0,4,7],
					[0,5,8],
				],inf).stutter(4*4),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, 200,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/2,
			),
	])
)).play;
);

(
Pdef(\chords2, 
	Pbind(
		\instrument, \mellowpad,
		\note, Pseq([
			[0,4,7],
			[0,5,8],
		],inf).stutter(1),
		\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
		\lpf, 200,
		\octave, 5,
		\dur, 2,
		\amp, 0.1/5/2,
	),
).play;
);
(
Pdef(\part, Pdef(\bass1, 
	Ppar([
		
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,4,
					5,5,5,8,
				],inf).stutter(4),
				//\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\lpf, PmodEnv(Pseq([100,2004],1), 8).loop,
				\octave, Pseq([
					3,3,4,3,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\meloparty, 
	Ppar([
			Pbind(
				\instrument, \reese,
				\fspread, 0.024000000208616,
				\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.1099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\lpadsramt, PmodEnv(Pseq([1,4,8],1), 8).loop,
				\kbamt, 0.0,
				\distamp, 10.0,
				\distpostamp, 0.5,
				\lpf, 330.0,
				\rq, 0.3,
				\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.40000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\spread, 0.80000001192093,
				\note, Pseq([
					0,4,5,2,0,-3,-5
				],inf),
				\octave, 6,
				\dur, Pseq([1/8,1/8,1/8,1/4],inf),
				\amp, 0.1/4,
			),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\feyn1, 
	Ppar([
		
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\pos, Pseq([
					(0..7),
					(0..1),
					(0..1),
					(0..1),
					0,0,0,
				].flat,inf)+Pstep(Pseq([0,1,3],4),4) * 1/4 * Pstep(Pseq([1,1/2]),8),
				\speed, Pseg(Pseq([1,1,2],inf),Pseq([15,1])),
				\legato, 1,
				\dur, 1/8,
				\gain, 0.2,
			)
	])
)).play;
);

(
Pdef(\part, Pdef(\melopart1, 
	Ppar([
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					Pser([
						0,4,7,4
					],16),
					Pser([
						0,5,8,5,
					],16),
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, Pseg(Pseq([0.1,1],inf),16),
				\lpf, 200,
				\octave, Pseq([
					5,5,6,5,
					5,5,6,5,
					5,5,6,5,
					5,7,5,7,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\fx2, \audio),
			),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,4,0,5,4
				],inf),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				\legato, 0.8,
				\lpf, 1200,
				\adsr, Pseq([
					[ Env.adsr(3.1,0.1,0.8,3.1) ],
				],inf),
				\octave, Pseq([
					4,4,4,5,
				],inf),
				\dur, Pseq([3,1],inf),
				\amp, 0.1/2,
				\out, BusDef(\fx2, \audio),
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\fx2, \audio),
				\delay, 1/6/~t,
				\addAction, \addToTail,
				\lag, 0.0009,
				\mix, 0.4,
				\dur, 1,
			),
		
	])
)).play;
);
(
Pdef(\melo1, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\evolve1, 
	Pmono(\evolve1,
		\dur, 1,
		\amp, 0.1/3/2,
	)
).play;
);
(
Pdef(\evolve2, 
	Pmono(\evolve2,
		\dur, 1,
		\amp, 0.1/3/2,
	)
).play;
);
(
Pdef(\evolve3, 
	Pmono(\evolve3,
		\dur, 1,
		\amp, 0.1/3/2,
	)
).play;
);

////////////////////////////// sdesign

(
SynthDef(\convergeramp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.01,0],[4.1,4.8]), 1);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * env1 + 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\convergeramp,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\convergechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.05,0.001],[0.2,1.0]), 1);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * env1 + 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\convergechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 7;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,0.05,0.001]/4,[0.1,3.0])), 1, levelScale:\fspread.kr(1));
	env2 = EnvGen.kr(\lpadsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate);
	sig = SinOsc.ar(freq * ((0..num)/num - 0.5 * env1 + 1) * ( SinOsc.ar(freq*\fmfr.kr(1/2)) * \fma.kr(4) + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(200) * ( env2 * \envamt.kr(4) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			\envamt, PmodEnv(Pseq([0,4],1), 8).loop,
			\fspread, PmodEnv(Pseq([0,4],1), 32).loop,
			\fmfr, Pseq([1,2,1/2],inf),
			\fma, PmodEnv(Pseq([0,4],1), 16).loop,
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
			],inf),
			\dur, 2,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
SynthDef(\convergechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 7;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,0.05,0.001]/4,[0.1,3.0])), 1, levelScale:\fspread.kr(1), timeScale:\fspreadts.kr(1));
	env2 = EnvGen.kr(\lpadsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate);
	sig = SinOsc.ar(freq * ((0..num)/num - 0.5 * env1 + 1) * ( SinOsc.ar(freq*\fmfr.kr(1/2)) * \fma.kr(4) + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(200) * ( env2 * \envamt.kr(4) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			//\envamt, PmodEnv(Pseq([1,4],1), 4).loop,
			\envamt, 4,
			\fspread, PmodEnv(Pseq([0.01,0.1],1), 32).loop,
			\fspread, PmodEnv(Pseq([10.01,0.1],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.7,3.1,0.02,2.1) ],
			],inf),
			//\fmfr, Pseq([1,2,1/2],inf),
			//\fma, PmodEnv(Pseq([0,4],1), 16).loop,
			\fspreadts, 0.2,
			\octave, 4,
			\fma, 8,
			\fmfr, 4,
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
				[0,4,7]+5,
				[-1,4,7]+5,
			],inf),
			\dur, 4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
// light fm by noise
SynthDef(\convergechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 7;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,0.05,0.001]/4,[0.1,3.0])), 1, levelScale:\fspread.kr(1), timeScale:\fspreadts.kr(1));
	env2 = EnvGen.kr(\lpadsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate);
	sig = SinOsc.ar(freq * ((0..num)/num - 0.5 * env1 + 1) * ( LFNoise1.ar(0.1!num) * 0.01 + 1 ) * ( SinOsc.ar(freq*\fmfr.kr(1/2)) * \fma.kr(4) + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(200) * ( env2 * \envamt.kr(4) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			//\envamt, PmodEnv(Pseq([1,4],1), 4).loop,
			\envamt, 4,
			\fspread, PmodEnv(Pseq([0.01,0.1],1), 32).loop,
			\fspread, PmodEnv(Pseq([10.01,0.1],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.07,3.1,2.02,2.1) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,204],1), 8).loop,
			//\fmfr, Pseq([1,2,1/2],inf),
			//\fma, PmodEnv(Pseq([0,4],1), 16).loop,
			\fspreadts, 0.2,
			\octave, 4,
			\fma, 2,
			\fmfr, 2,
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
				[0,4,7]+5,
				[-1,4,7]+5,
			],inf),
			\dur, 4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
// light fm by noise inside fm
SynthDef(\convergechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 7;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,0.05,0.001]/4,[0.1,3.0])), 1, levelScale:\fspread.kr(1), timeScale:\fspreadts.kr(1));
	env2 = EnvGen.kr(\lpadsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate);
	sig = SinOsc.ar(freq * ((0..num)/num - 0.5 * env1 + 1)  * ( LFSaw.ar(freq*\fmfr.kr(1/2)* ( LFNoise1.ar(0.1!num) * 0.01 + 1 )) * \fma.kr(4) + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(200) * ( env2 * \envamt.kr(4) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			//\envamt, PmodEnv(Pseq([1,4],1), 4).loop,
			\envamt, 4,
			\fspread, PmodEnv(Pseq([0.01,0.1],1), 32).loop,
			\fspread, PmodEnv(Pseq([10.01,0.1],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.07,3.1,2.02,2.1) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,204],1), 8).loop,
			//\fmfr, Pseq([1,2,1/2],inf),
			//\fma, PmodEnv(Pseq([0,4],1), 16).loop,
			\fspreadts, 0.7,
			\octave, 6,
			\spread, 0,
			\fma, 0.8,
			\fmfr, 1/4,
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
				[0,4,7]+5,
				[-1,4,7]+5,
			],inf),
			\dur, 4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			//\envamt, PmodEnv(Pseq([1,4],1), 4).loop,
			\envamt, 8,
			//\fspread, PmodEnv(Pseq([1,0.2],1), 32).loop,
			\fspreadenv, Pseq([
				[ Env([0.1,0.02,0.0001],[0.1,3.8]) ]
			],inf),
			//\fspread, PmodEnv(Pseq([10.01,0.1],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.7,0.7,2.02,2.1) ],
			],inf),
			//\lpf, PmodEnv(Pseq([100,3504],1), 16).loop,
			\lpf, 100,
			//\fmfr, Pseq([1,2,1/2],inf),
			\fma, PmodEnv(Pseq([0.01,4],1), 4).loop,
			\fspreadts, 0.4,
			\octave, 6,
			\spread, 0,
			//\fma, 0.8,
			\fmfr, 1/4,
			\note, Pseq([
				[0,4,7],
				[0,4,8],
				[0,5,9],
				[0,5,8],
			],inf),
			\dur, 4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
// light fm by noise inside fm
// env for fma
SynthDef(\convergechord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 7;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,0.05,0.001]/4,[0.1,3.0])), 1, levelScale:\fspread.kr(1), timeScale:\fspreadts.kr(1));
	env2 = EnvGen.kr(\lpadsr.kr(Env.adsr(1.1,0.1,0.8,2.1)), gate);
	env3 = EnvGen.kr(\fmaenv.kr( Env([0.001,4,0],[3.1,8.8]) ), gate);
	sig = SinOsc.ar(freq * ((0..num)/num - 0.5 * env1 + 1)  * ( LFSaw.ar(freq*\fmfr.kr(1/2)* ( LFNoise1.ar(0.1!num) * 0.01 + 1 )) * \fma.kr(4) * ( env3 * \fmaenvamt.kr(1) + 1 )  + 1 ));
	sig = RLPF.ar(sig, \lpf.kr(200) * ( env2 * \envamt.kr(4) + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \convergechord,
			//\envamt, PmodEnv(Pseq([1,4],1), 4).loop,
			\envamt, 8,
			//\fspread, PmodEnv(Pseq([1,0.2],1), 32).loop,
			\fspreadenv, Pseq([
				[ Env([0.001,0.08,0.0401],[0.5,3.8]) ]
			],inf),
			//\fspread, PmodEnv(Pseq([10.01,0.1],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.7,0.7,2.02,2.1) ],
			],inf),
			//\lpf, PmodEnv(Pseq([100,3504],1), 16).loop,
			\lpf, 100,
			\fmfr, Pseq([1,2,1/2,1/4],inf),
			//\fma, PmodEnv(Pseq([0.01,4],1), 4).loop,
			\fma, 1,
			\fspreadts, 0.4,
			\octave, 6,
			//\fmfr, 1/4,
			\note, Pseq([
				[0,4,7],
				[0,4,8],
				[0,5,9],
				[0,5,8],
			],inf),
			\dur, 4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);


(
Pdef(\melo, 
	Pbind(
		\instrument, \convergechord,
			\envamt, 8,
			\fspreadenv, Pseq([
				[ Env([0.001,0.08,0.0401],[0.5,3.8]) ]
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.7,0.7,2.02,2.1) ],
			],inf),
			\lpf, 100,
			//\fmfr, Pseq([1,2,1/2,1/4],inf),
			\fmfr, 2,
			\fma, 1,
			\fspreadts, 0.4,
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))


(
SynthDef(\formchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar(freq);
	sig1 = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig2 = RLPF.ar(sig, \lpf2.kr(300), \rq.kr(0.5));
	sig = [sig1, sig2].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \formchord,
			\note, Pseq([
				[0,4,7],
				[0,4,8],
				[0,5,9],
				[0,5,8],
			],inf),
			\dur, 4,
			\amp, 0.1,
			\octave, 5,
		),
	])
)).play;
);
