~t = 140/4/60; TempoClock.default.tempo = ~t;

(
	SynthDef(\skank, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var osig;
		sig = SinOsc.ar(freq * [1,1.001,1/2,2,3/4]).mean;
		sig = Pluck.ar(sig, Impulse.kr(1),0.1,1/freq,1.4) + sig;
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:0);
		osig = sig;

		sig1 = sig;
		sig1 = DelayC.ar(sig1, 1/~t,1/4/~t);
		sig1 = RHPF.ar(sig1, freq* Rand(0.2,2),0.1)*0.01;
		sig4 = sig1;

		sig1 = osig;
		sig1 = DelayC.ar(sig1, 1/2/~t,1/2/~t);
		sig1 = RLPF.ar(sig1, freq*0.72 * Rand(0.2,2),0.1)*0.1;
		sig5 = sig1;

		sig1 = osig;
		sig1 = DelayC.ar(sig1, 6/8/~t,3/8/~t);
		sig1 = RLPF.ar(sig1, freq*0.72 * Rand(0.2,2),0.1)*0.1;
		sig6 = sig1;

		sig = [osig*Rand(0.5,1.0), sig4*Rand(0,1.0), sig5*Rand(0,1.0), sig6*Rand(0,1.0)].sum * 1;
		//sig = osig;

		sig = Pan2.ar(sig, pan, amp);
		DetectSilence.ar(sig, time:2,doneAction:2);
		Out.ar(out, sig);
	}).add;

SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = SinOsc.ar(freq * [1,1.0001]);
	sig = sig.tanh;
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\stick, { |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0.9, 0.9, 0.9, 0.7, 0, 0.7, 0],
            [0.001, 0.001, 0, 0.008, 0, 0.01, 0, 0.01],
            [0, 0, 0, 00, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 7000, 0.03)/2);
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;
);

ProtoDef(\piano).startControl(Pbind(\instrument, \noisybass, \amp, 0.05))

(
	r = \r;
	Pdef(\gadrums, 
		Pseq([
			Pbind(
				\instrument, \noisybass,
				\degree, Pseq([
					-3,r,-3,r,-5,r,-3,r,
					0,r,r,r, r,r,-3,0,
					r,r,-3,0, r,r,r,r,
					r,r,r,r, r,r,r,r,
					
				],inf),

				\legato, 1.5,
				\ctranspose, 7,
				\octave, 3,
				\dur, 1/16,
				\amp, 0.1
			);
		])
	).play;
)

ProtoDef(\rdn).edit
ProtoDef(\simpleMixer).play
ProtoDef(\simpleMixer).sidePlayers = [ProtoDef(\rdn)];

(
ProtoDef(\simpleMixer).play;
	r = \r;
	Pdef(\gadrums, 
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					1,0,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1/3,
				\speed, 0.7,
				\pos, 0.05,
				\dur, 1/8,
				\gain, 1/3,
				\amp, 0.1,
				\out, BusDef(\mixer0),
			)),
		Pbind(
			\instrument, \stick,
				\out, BusDef(\mixer0),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \skank,
				\degree, Pseq([
					Pseq([
						//Pseq([
						//	r,r,0,r,
						//],inf),
						Pser([
							r,
							Prand([
								[0],
								r,
							],1),
							[0,2,4],
							Prand([
								[0],
								r,
							],1),
						],16*2),
						Pser([
							r,
							r,
							[1,3,5],
							r,
						],16*1),
						Pser([
							r,
							r,
							[0,2,4],
							r,
						],16*1),
					],inf),
					Pseq([
						-2,-4,-2,r, 1,r,r,-2,
						1,-2,1,r, r,r,r,-3,
					],1),
					Pseq([
						-3,-5,-3,r, 0,r,r,-3,
						0,-3,0,r, r,r,r,-3,
					],1),
				],inf),
				\legato, Pseq([
					Pseq([ 2,4,2,1, ]/4,1), 3,1,1,1,
					1/2,1/2,1.52,1, 3,1,1,1,
				],inf)* 0.9,
				\legato, Pseq([
					0.1,0.2,
				],inf),
			\amp, 0.1,
				\ctranspose, 7,
				\octave, 5,
				\dur, 1/8,
				\out, BusDef(\mixer3),
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\out, BusDef(\mixer2),
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.mono('heavy/kick1.flac'),
			\bufnum, BufDef('heavy/kick1.flac'),
			\bufnum, BufDef(\amen),
			\isRest, Pseq([
				0,1, 1,1,
			],inf).coin.not,
			\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
			\pos, 0.43,
			\grate, 100,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\lpmix, 1,
			\hpmix, 1,
			\lpf, 11300,
			\hpf, 9900,
			\isRest, Pseq([
				1,0.41,1,0.41,
				1,0.41,1,0.41,
				1,0.41,1,0.41,
				1,0.61,1,0.61,

				1,0.41,1,0.41,
				1,0.81,1,0.81,
				1,0.41,1,0.81,
				1,0.41,1,0.41,
				//1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\isRest, Pseq([
				0.3,0.3,1,0.3, 1,0.3,1,0.3,
			],inf).coin.not,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,1,1,
				0,0,0,0, 1,0,1,0,
					0,0,1,1, 0,1,1,0,
					1,1,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				],1),
				0,0,1,0, 1,0,1,0,
				0,1,0,0.51, 1,0,1,0.51,
				0,0,0,0, 1,0,1,0,
				0.51,0,0.51,1, 0,0,1,1,
				0,0,0,0, 1,0,1,0,
				0,0.51,1,00.2, 1,0,1,0.51,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			//\grate, ~pmodenv.(Pseq([0,0.2,0.3,0.6],inf)*1317, 1/4),
			\sustain, 0.11/1 * Pseq([0.5,1],inf).stutter(1) * Prand([1,1/2,0.7,1.5],inf),
			\sustain, 0.1/3 * Pseq([1,0.7],inf),
			\speed, 1.4 + Pwhite(0.0,0.03),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.00 * Pseq([-1,1],inf))),
			\gain, 0.1,
			\adsr, Prand([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.05,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.05,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],1),
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\gain, Pkey(\gain) * Pseq([
				0.8,
				0.4,
			],inf).stutter(1),
			\amp, 0.1,
		)),
			//PatKitDef(\sample1).asPattern(Pbind(
			//	\kitIndex, 8,
			//	\isRest, Pseq([
			//		1,1,1,1, 1,1,1,1,
			//	],inf).coin.not,
			//	\sustain, 0.1/5,
			//	\dur, 1/8,
			//	\amp, 0.1,
			//)),
			Pbind(
				\instrument, \noisybass,
				\degree, Pseq([
					Pseq([
						-3,-5,-3,r, 0,r,r,-3,
						0,-3,0,r, r,r,r,-3,
					],2),
					Pseq([
						-2,-4,-2,r, 1,r,r,-2,
						1,-2,1,r, r,r,r,-3,
					],1),
					Pseq([
						-3,-5,-3,r, 0,r,r,-3,
						0,-3,0,r, r,r,r,-3,
					],1),
				],inf),
				\legato, Pseq([
					Pseq([ 2,4,2,1, ]/4,1), 3,1,1,1,
					1/2,1/2,1.52,1, 3,1,1,1,
				],inf)* 0.9,
				\ctranspose, 7,
				\octave, 3,
				\dur, 1/8,
				\out, BusDef(\mixer1),
				\amp, 0.1/1,
			);
		])
	).play;
)

///////////////////////



(
ProtoDef(\simpleMixer).play;
	r = \r;
	Pdef(\gadrums, 
		Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\speed, Pseg(Prand((1..8)/19 + 1.3,inf),8),
			\dur, 1/8,
			\gain, 1/2 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
				\out, BusDef(\mixer4),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
				\out, BusDef(\mixer4),
			\kitIndex, 4,
			\lag, 1/2+(1/4)/~t,
			\isRest, Pseq({[
				1,0.5,1,0.5,
				0,0,0,0, 0,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1)*2,
			\dur, 1/2,
			\gain, 1/2,
			\gain, 1/4 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					1,0,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1/3,
				\speed, 0.7,
				\pos, 0.05,
				\dur, 1/8,
				\gain, 1/3,
				\amp, 0.1,
				\out, BusDef(\mixer0),
			)),
		Pbind(
			\instrument, \stick,
				\out, BusDef(\mixer0),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \skank,
				\degree, Pseq([
					Pseq([
						//Pseq([
						//	r,r,0,r,
						//],inf),
						Pser([
							r,
							Prand([
								[0],
								r,
							],1),
							[0,2,4],
							Prand([
								[0],
								r,
							],1),
						],16*2),
						Pser([
							r,
							r,
							[1,3,5],
							r,
						],16*1),
						Pser([
							r,
							r,
							[0,2,4],
							r,
						],16*1),
					],inf),
					Pseq([
						-2,-4,-2,r, 1,r,r,-2,
						1,-2,1,r, r,r,r,-3,
					],1),
					Pseq([
						-3,-5,-3,r, 0,r,r,-3,
						0,-3,0,r, r,r,r,-3,
					],1),
				],inf),
				\legato, Pseq([
					Pseq([ 2,4,2,1, ]/4,1), 3,1,1,1,
					1/2,1/2,1.52,1, 3,1,1,1,
				],inf)* 0.9,
				\legato, Pseq([
					0.1,0.2,
				],inf),
			\amp, 0.1,
				\ctranspose, 7,
				\octave, 5,
				\dur, 1/8,
				\out, BusDef(\mixer3),
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\out, BusDef(\mixer2),
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.mono('heavy/kick1.flac'),
			\bufnum, BufDef('heavy/kick1.flac'),
			\bufnum, BufDef(\amen),
			\isRest, Pseq([
				0,1, 1,1,
			],inf).coin.not,
			\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
			\pos, 0.43,
			\grate, 100,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\lpmix, 1,
			\hpmix, 1,
			\lpf, 11300,
			\hpf, 9900,
			\isRest, Pseq([
				1,0.41,1,0.41,
				1,0.41,1,0.41,
				1,0.41,1,0.41,
				1,0.61,1,0.61,

				1,0.41,1,0.41,
				1,0.81,1,0.81,
				1,0.41,1,0.81,
				1,0.41,1,0.41,
				//1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\isRest, Pseq([
				0.3,0.3,1,0.3, 1,0.3,1,0.3,
			],inf).coin.not,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,0,1,0,
					1,0,1,0, 1,1,1,1,
				0,0,0,0, 1,0,1,0,
					0,0,1,1, 0,1,1,0,
					1,1,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				],1),
				0,0,1,0, 1,0,1,0,
				0,1,0,0.51, 1,0,1,0.51,
				0,0,0,0, 1,0,1,0,
				0.51,0,0.51,1, 0,0,1,1,
				0,0,0,0, 1,0,1,0,
				0,0.51,1,00.2, 1,0,1,0.51,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			//\grate, ~pmodenv.(Pseq([0,0.2,0.3,0.6],inf)*1317, 1/4),
			\sustain, 0.11/1 * Pseq([0.5,1],inf).stutter(1) * Prand([1,1/2,0.7,1.5],inf),
			\sustain, 0.1/3 * Pseq([1,0.7],inf),
			\speed, 1.4 + Pwhite(0.0,0.03),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.00 * Pseq([-1,1],inf))),
			\gain, 0.1,
			\adsr, Prand([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.05,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.05,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],1),
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\gain, Pkey(\gain) * Pseq([
				0.8,
				0.4,
			],inf).stutter(1),
			\amp, 0.1,
		)),
			//PatKitDef(\sample1).asPattern(Pbind(
			//	\kitIndex, 8,
			//	\isRest, Pseq([
			//		1,1,1,1, 1,1,1,1,
			//	],inf).coin.not,
			//	\sustain, 0.1/5,
			//	\dur, 1/8,
			//	\amp, 0.1,
			//)),
			Pbind(
				\instrument, \noisybass,
				\degree, Pseq([
					Pseq([
						-3,-5,-3,r, 0,r,r,-3,
						0,-3,0,r, r,r,r,-3,
					],2),
					Pseq([
						-2,-4,-2,r, 1,r,r,-2,
						1,-2,1,r, r,r,r,-3,
					],1),
					Pseq([
						-3,-5,-3,r, 0,r,r,-3,
						0,-3,0,r, r,r,r,-3,
					],1),
				],inf),
				\legato, Pseq([
					Pseq([ 2,4,2,1, ]/4,1), 3,1,1,1,
					1/2,1/2,1.52,1, 3,1,1,1,
				],inf)* 0.9,
				\ctranspose, 7,
				\octave, 3,
				\dur, 1/8,
				\out, BusDef(\mixer1),
				\amp, 0.1/1,
			);
		])
	).play;
)
