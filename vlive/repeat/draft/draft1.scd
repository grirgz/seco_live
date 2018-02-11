(


SynthDef(\rukick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.015, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([4510, 92, 59], [0.005, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0 * 8;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
	env0: XEnvSpec(\amp),
	env1: XEnvSpec(\freq),
))).add;
)

(

	SynthDef(\rufx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, gain=1;
		var sig;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var in;
		var fbsig;
		in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		sig = in;
		fbsig = LocalIn.ar(2);
		sig = sig + ( fbsig * \fb.kr(0.0) );

		sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
		sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);

		sig1 = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
		sig = SelectX.ar(\compmix.kr(0.5), [sig, sig1]);


		sig1 = sig;
		8.do { arg xx;
			sig1 = DelayC.ar(sig1, 1,\delay.kr(0.1)+ (xx*\delayscale.kr(0.01))) + ( sig1 / 2 );
		};
		sig = SelectX.ar(\delmix.kr(0), [sig, sig1]);

		sig = SelectX.ar(\endmix.kr(1), [in, sig]);
		sig = Limiter.ar(sig);
		sig = sig * gain;
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);

		LocalOut.ar(sig);
		//Out.ar(\inbus.kr, sig1);

		Out.ar(out, sig);
	}).add;
	Ndef(\rufx).source = \rufx;
	//Ndef(\rufx).play(BusDef(\sendbus0,\audio).index, 2);
	Ndef(\rufx).play(0, 2);
	Ndef(\rufx).set(\inbus, BusDef(\sendbus1, \audio));

);
	Ndef(\rufx).edit
	Ndef(\rufx).stop

(
Pdef(\rukick, Pbind(
	\instrument, \rukick,
	\out, BusDef(\sendbus0, \audio),
	\degree, Pseq([0],inf),
	\fratio, Pseq([1,1.2,1.5,3],inf),
	\timeScale, Pseq([1,1/2,2,0.1],inf),
	\timeScale, 5/~t,
	\legato, 1,
	\dur, 2,
	\amp, 0.1
)).play;
);
Ndef(\rufx).set(\delay, 1/4/~t)
(
Ndef(\rufx).put(20, \pset -> Pbind(
	\delay, Prand([1/4,1/8,1/2,1/16],inf) / ~t,
	\dur, 1,
));
)
WindowDef(\PdefEditor).front(Pdef(\rukick))
~kitlib.lcd.trap.snare.value.asStream.nextN(4,())
PatKitDef(\sample1).edit
(
Pdef(\drumsx, Ptpar([
	0, Pbind(

			\out, BusDef(\sendbus1,\audio),
	) <> ~kitlib.lcd.trap.kick2.value,
	0, Pbind(

			\out, BusDef(\sendbus1,\audio),
	) <> ~kitlib.lcd.trap.snare.value,
	0, Pbind(

			\out, BusDef(\sendbus1,\audio),
	) <> ~kitlib.lcd.trap.hat.value,
])).play;
)
(
Pdef(\drums, Ptpar([
		0, Pbind(
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			//\out, BusDef(\sendbus0,\audio),
			\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.hiphop.kick.value,
		0, Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\out, BusDef(\sendbus0,\audio),
			//\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.hiphop.snare.value,
		0, Pbind(
			\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.trap.hat.value,
])).play;
)

algokick	

ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn).edit
ProtoDef(\rdn).play
BusDef(\sendbus1, \audio)

Ndef(\rufx).put(20, nil)
(
ProtoDef(\rdn).play;
Ndef(\rufx).play;
Pdef(\main, 
	Ppar([
		Pdef(\drumsx),
		Pbind(\out, BusDef(\sendbus0,\audio)) <> Pdef(\guitar),
		Pbind(\out, BusDef(\sendbus0,\audio)) <> Pdef(\guitar2),
		Pbind(\out, BusDef(\sendbus0,\audio)) <> Pdef(\guitar3),
	])
).play;
)


(
ProtoDef(\rdn).play;
Ndef(\rufx).play;
Pdef(\main, 
	Ppar([
		Pbind(
			\instrument, \rukick,
			\out, BusDef(\sendbus0, \audio),
			\degree, Pseq([0],inf),
			\fratio, Pseq([1,1.2,1.5,3],inf),
			\timeScale, Pseq([1,1/2,2,0.1],inf),
			\timeScale, 1/2,
			\dur, 1/2,
			\amp, 0.1
		),
		Pbind(
			\out, BusDef(\sendbus1,\audio),
		) <> ~kitlib.lcd.trap.kick2.value,
		Pbind(
			\gain, 1/2,
			\sustain, 0.1,
			\out, BusDef(\sendbus1,\audio),
		) <> ~kitlib.lcd.trap.snare.value,
		Pbind(

			\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.trap.hat.value,
		Pbind(\out, BusDef(\sendbus0,\audio)) <> Pdef(\guitar),
		Pbind(\out, BusDef(\sendbus0,\audio)) <> Pdef(\guitar2),
		Pbind(\out, BusDef(\sendbus0,\audio)) <> Pdef(\guitar3),
	])
).play;
)






Pdef.defaultQuant = 4

////////////////////////////////////
// see algokit/synthdef.scd for guitar synthdef
(
	// lead
	Pdef(\guitar3, 
				PmonoArtic( \guitar,
					\note, 
					Plazy({

						var idxstr = Pwhite(0,5).stutter(Pwhite(1,8)).asStream;
					
					( [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
						Pseq([
							[1,3,3,2,1,1] + 7, // Do
							[1,3,3,2,1,1].rotate(1) + 6, // Mi
							[1,3,3,1,1,1].rotate(0) + 4, // La
							[1,3,3,2,1,1].rotate(0) + 2, // Sol
						],1),
					],inf).stutter(8) ).collect({ arg pp; pp[ idxstr.next.debug("idx") ] });
					}),
					\octave, 5,
					\dur, 1/8,
					\legato, Pwhite(0.1,2).stutter(Pwhite(1,8)),
					\amp, 0.1,
				)
	).play;
)

(
	// bass
Pdef(\guitar2, Pbind(
	\instrument, \guitar,
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pseq([
			[1,3,3,2,1,1] + 7, // Do
			[1,3,3,2,1,1].rotate(1) + 6, // Mi
			[1,3,3,1,1,1].rotate(0) + 4, // La
			[1,3,3,2,1,1].rotate(0) + 2, // Sol
		],1),
	],inf).stutter(4),
	\octave, 3,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/4,
	\legato, 1 - Ptuple(Pexprand(0.01,0.9)!6),
	\amp, 0.1 * Pseq([
		//[\rest,\rest,\rest,\rest,\rest],
		Pfunc({ [ 1,0,0,0, 0,0, ].scramble }),
		//[ 1,1,1,1, 1,1, ].collect({ arg x; x - exprand(0.01,0.5) })
	],inf),
)).play;
)

(
	// guitar
Pdef(\guitar, Pbind(
	\instrument, \default,
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pseq([
			[1,3,3,2,1,1] + 7, // Do
			[1,3,3,2,1,1].rotate(1) + 6, // Mi
			[1,3,3,1,1,1].rotate(0) + 4, // La
			[1,3,3,2,1,1].rotate(0) + 2, // Sol
		],1),
	],inf).stutter(4),
	\octave, 3,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/4,
	\legato, 1 - Ptuple(Pexprand(0.01,0.9)!6),
	\amp, 0.1 * Pseq([
		//[\rest,\rest,\rest,\rest,\rest],
		1 - Ptuple(Pexprand(0.01,0.9)!6)
		*
		Ptuple(Pfunc({0.5.coin.asInteger})!6)
		//[ 1,1,1,1, 1,1, ].collect({ arg x; x - exprand(0.01,0.5) })
	],inf),
)).play;
)

(
Pdef(\guitar, Pbind(
	\instrument, \default,
	\note, [4,9,2+12,7+12,11+12,4+12+12] + Pseq([
		Pseq([
			[1,3,3,2,1,1] + 2, // FA
			[1,3,3,2,1,1].rotate(1) + 2, // Dob
			[1,3,3,3,1,1].rotate(1) + 2, // Do
		],1),
	],inf),
	\octave, 4,
	\isRest, Pseq([
		false
	],inf),
	//\note, [4,0,3,6,1,4],
	\dur, 1/2,
	\legato, 1 - Ptuple(Pexprand(0.01,0.5)!6),
	\amp, 0.1 * Pseq([
		//[\rest,\rest,\rest,\rest,\rest],
		1 - Ptuple(Pexprand(0.01,0.5)!6)
		//[ 1,1,1,1, 1,1, ].collect({ arg x; x - exprand(0.01,0.5) })
	],inf),
)).play;
)
