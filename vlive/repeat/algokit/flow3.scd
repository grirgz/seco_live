kick	

(
SynthDef(\kickbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fenv;
	var rng = Pseed(19, Pwhite(0.0,1)).asStream;
	var fm;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	fenv = EnvGen.kr(Env([300,58,51],[0.01,0.8]), 1);
	fm = ( 1 + ( SinOsc.ar(fenv*12) * 1 ));
	fm = 1;

	sig = 0;
	//sig = sig + LFSaw.ar(fenv * fm);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, fenv*2.5) ;
	sig = sig + SinOsc.ar(fenv * fm);

	sig = sig * EnvGen.ar( Env([0,1,0],[0.001,0.2]),gate,doneAction:0);
	sig1 = sig;

	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) * XLine.kr(1.0,1/17,4) ) + sig;
		isig = isig.tanh + ( isig/2 );
		isig = FreqShift.ar(isig, 0.001);
		2.do {
			rng.nextN(4).do { arg fac;
				fac.debug("fac");
				isig = DelayC.ar(isig, 0.001, 0.00001 * fac) + isig;
			};
			isig = rng.nextN(4).collect( { arg fac;
				fac.debug("facpar");
				DelayC.ar(isig, 0.001, 0.00001 * fac) + isig;
			}).mean;
		};

		isig = Limiter.ar(isig);
		isig;
	};
	//sig = sig1;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\simplekick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fenv;
	var rng = Pseed(19, Pwhite(0.0,1)).asStream;
	var fm;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	fenv = EnvGen.kr(Env([300,58,51],[0.01,0.8]), 1);
	fm = ( 1 + ( SinOsc.ar(fenv*12) * 1 ));
	fm = 1;

	sig = 0;
	sig = sig + LFSaw.ar(fenv * fm);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, fenv*2.5) ;
	sig = sig + SinOsc.ar(fenv * fm);

	sig = sig * EnvGen.ar( Env([0,1,0],[0.001,0.2]),gate,doneAction:2);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\riser, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,0.0001]).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\riser2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,0.0001]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(2) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\fbfx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fenv;
	var rng = Pseed(32, Pwhite(0.0,1)).asStream;
	var fm;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	var lagdelay = \lagdelay.kr(1);
	var delay = \delay.kr(0.001).lag(lagdelay);
	var delay2 = \delay2.kr(0.001).lag(lagdelay);
	var distmix = \distmix.kr(0.8).lag(0.051);
	var in;

	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

	sig = in;
	sig1 = sig;
	sig = sig * \preamp.kr(10);

	sig = sig + Fb { arg fb;
		var isig;
		var startisig;
		isig = ( fb * \fb.kr(1).lag(\fblag.kr(1/8)) ) + sig;
		isig = isig * \startamp.kr(4);
		isig = isig * ( Amplitude.kr(in).lagud(0,0.5)*\fomul.kr(1)+\foadd.kr(0.1) );
		isig = SelectX.ar(distmix, [isig, isig.tanh * 0.8]);
		//isig = FreqShift.ar(isig, 0.001);
		startisig = isig;
		2.do {
			rng.nextN(4).do { arg fac;
				fac.debug("fac");
				isig = DelayC.ar(isig, 0.1, delay * fac) + isig;
				isig = FreqShift.ar(isig, 0.01) + isig;
				isig = SelectX.ar(distmix, [isig, isig.tanh]);
			};
			isig = rng.nextN(4).collect( { arg fac;
				var jsig;
				fac.debug("facpar");
				jsig = DelayC.ar(isig, 0.1, delay2 * fac) + isig;
				jsig = SelectX.ar(distmix, [jsig, jsig.tanh]);
				//jsig = FreqShift.ar(jsig, 0.01) + jsig;
				jsig;
			}).mean;
		};
		isig = HPF.ar(isig, \hpf.kr(1180));
		isig = isig + HPF.ar(startisig, 2180);

		isig = Limiter.ar(isig);
		isig;
	};
	//sig = sig1;
	sig = MidEQ.ar(sig, 9000, 1, 4);
	sig = MidEQ.ar(sig, 14000, 1, 4);
	sig = MidEQ.ar(sig, 6000, 1, 8);
	sig = HPF.ar(sig, 70);
	sig = sig * \postamp.kr(1/4);
	sig = SelectX.ar(\mix.kr(1), [DelayL.ar(in, 0.1, \indelay.kr(0.04)), sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)



(
Pdef(\drums1, Pbind(
	\instrument, \kickbass,
	\degree, Pseq([0],inf),
	\isRest, Pseq({[
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 1,0,1,0,
		1,1,1,1, 0,0,0,0,
		1,0,0,1, 0,0,1,0,
	].clump(8).choose}.dup(4).flat,inf).coin.not,
	\legato, 2,
	\dur, 1/8,
	\amp, 0.1
)).stop;
);

(
Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \simplekick,
			\freq, 200,
			\isRest, Pseq({[
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				Pn(8,8*8),
				1,1,1,1, 1,1,1,0.99,
			],inf),
			\fb, 0.10,
			\dur, 1/4,
		
		)
		
	])
).play;
)
(
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 1,1,1,1,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\speed, 1/2,
					\dur, 1/8,
					\sustain, 0.031,
					\out, BusDef(\fbfx, \audio),
				),
			]),
		),
		Pbind(
			\instrument, \criz,
			\freq, 50 * Pseg(Pseq([1.8,1],inf),2),
			\dur, 1/8,
			\legato, 0.1,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		Pbind(
			\instrument, \criz,
			\freq, 50 * 12 * ([0,3,7]-4).midiratio,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/1,
			\legato, 0.5,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		Pbind(
			\instrument, \scagrain2,
			\freq, 50*8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 2/1,
			\legato, Pseq([
				0.9,0.01,
			],inf),
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		//Pbind(
		//	\instrument, \riser2,
		//	\freq, 50 * 6 * Pseq([
		//		Pfin(16*4,Pseq([
		//			Pser([0,3,7]-4,1/4*16),
		//			Pser([0,3,7]-1,1/4*16),
		//		],inf)),
		//		Pfin(16*4,Pseq([
		//			Pser([0,3,7]-4,1*16),
		//			Pser([0,3,7]-1,1*16),
		//		],inf)),
		//	],inf).midiratio,
		//	\isRest, Pseq([
		//		Pser([
		//			0.5,1,
		//		],3*8),
		//		Pser([
		//			0,0,0,
		//		],1*8),
		//		Pser([
		//			0.5,0.5,1,
		//		],3*8),
		//		Pser([
		//			0,0,0,
		//		],1*8),
		//	],inf).coin.not,
		//	\dur, 1/8,
		//	\legato, 0.5,
		//	\amp, 0.1,
		//	\out, BusDef(\fbfx, \audio),
		//),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				Pn(8,8*3),
				1,1,1,1, 1,1,1,0.11,
				Pn(8,8*3),
				1,0.3,1,0.31, 0.31,1,1,0.31,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.000001,0.0001,0.001,
			],inf),1),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.001,
			],inf),1),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\hpf, 40,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)

(
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 1,1,1,1,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\speed, 1/2,
					\dur, 1/8,
					\sustain, 0.031,
					\out, BusDef(\fbfx, \audio),
				),
			]),
		),
		Pbind(
			\instrument, \riser,
			\freq, 50 * Pseg(Pseq([1.8,1],inf),2),
			\dur, 1/8,
			\legato, 0.1,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		Pbind(
			\instrument, \criz,
			\freq, 50 * 12 * ([0,3,7]-4).midiratio,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/1,
			\legato, 0.5,
			\amp, 0.1/3,
			\out, BusDef(\fbfx, \audio),
		),
		//Pbind(
		//	\instrument, \riser2,
		//	\freq, 50 * 6 * Pseq([
		//		Pfin(16*4,Pseq([
		//			Pser([0,3,7]-4,1/4*16),
		//			Pser([0,3,7]-1,1/4*16),
		//		],inf)),
		//		Pfin(16*4,Pseq([
		//			Pser([0,3,7]-4,1*16),
		//			Pser([0,3,7]-1,1*16),
		//		],inf)),
		//	],inf).midiratio,
		//	\isRest, Pseq([
		//		Pser([
		//			0.5,1,
		//		],3*8),
		//		Pser([
		//			0,0,0,
		//		],1*8),
		//		Pser([
		//			0.5,0.5,1,
		//		],3*8),
		//		Pser([
		//			0,0,0,
		//		],1*8),
		//	],inf).coin.not,
		//	\dur, 1/8,
		//	\legato, 0.5,
		//	\amp, 0.1,
		//	\out, BusDef(\fbfx, \audio),
		//),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.11,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.001,
				0.00001,0.00001,0.00001,0.00001,
			],inf),1),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.0071,0.0071,0.0071,0.001,
			],inf),1),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\distmix, 0.2,
			\hpf, 40,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)

(
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,1,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				//Pbind(
				//	\kitIndex, 5,
				//	\isRest, Pseq({[
				//		0,0,0,0, 1,0,0,0,
				//		1,0,1,0, 1,0,1,0,
				//		1,1,1,1, 1,1,1,1,
				//	].clump(8).choose}.dup(4).flat,inf).coin.not,
				//	\speed, 1/2,
				//	\dur, 1/8,
				//	\sustain, 0.031,
				//	\out, BusDef(\fbfx, \audio),
				//),
			]),
		),
		Pbind(
			\instrument, \riser,
			\freq, 50 * Pseg(Pseq([1.8,1],inf),2),
			\dur, 1/8,
			\legato, 0.1,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		Pbind(
			\instrument, \criz,
			\freq, 50 * 12 * ([0,3,7,10]-4).midiratio,
			\isRest, Pseq([
				Pseq({[
					0,1,0,1,
					0,0,0,1,
				].clump(4).choose}.dup(8).flat,inf)
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
					[ Env.adsr(0.001,0.1,0.8,0.11) ],
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
				],inf).stutter(2),
			],1),
			\sustain, Pseq([0.03,0.06, 0.03, 0.06, 0.03, Prand([0.06,0.2],1)],inf).stutter(2) * Pseq([1/2,1/2,1/2,1],inf).stutter(8),
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		Pbind(
			\instrument, \riser2,
			\freq, 50 * 6 * Pseq([
				Pfin(16*4,Pseq([
					Pser([0,3,7]-4,1/4*16),
					Pser([0,3,7]-1,1/4*16),
				],inf)),
				Pfin(16*4,Pseq([
					Pser([0,3,7]-4,1*16),
					Pser([0,3,7]-1,1*16),
				],inf)),
			],inf).midiratio,
			\isRest, Pseq([
				Pser([
					0.5,1,
				],3*8),
				Pser([
					0,0,0,
				],1*8),
				Pser([
					0.5,0.5,1,
				],3*8),
				Pser([
					0,0,0,
				],1*8),
			],inf).coin.not,
			\lpfr, 1,
			\dur, 1/4,
			\legato, 0.5,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.11,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.001,
				0.00001,0.00001,0.00001,0.00001,
			],inf),1/2),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.0071,0.0071,0.0071,0.001,
			],inf),1/2),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\distmix, 0.2,
			\hpf, 40,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)

(
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 1,1,1,1,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\speed, 2,
					\dur, 1/8,
					\sustain, Pseq([
						Pseq({[
							0.5,0.1,0.03,0.1,
							0.03,0.03,0.03,0.03,
							0.13,0.03,0.03,0.03,
							0.03,0.03,0.03,0.33,
							0.03,0.33,0.03,0.03,
						].clump(4).choose}.dup(4).flat,inf)
					],inf),
					\out, BusDef(\fbfx, \audio),
				),
			]),
		),
		Pbind(
			\instrument, \riser,
			\freq, 50 * Pseg(Pseq([1.8,1],inf),2),
			\dur, 1/2,
			\legato, 0.1,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.11,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.001,
				0.00001,0.00001,0.00001,0.00001,
			],inf),1/4),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.1071,0.1071,0.1071,0.101,
			],inf),1/4),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\distmix, 0.2,
			\hpf, 40,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)

(
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,1,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				//Pbind(
				//	\kitIndex, 5,
				//	\isRest, Pseq({[
				//		0,0,0,0, 1,0,0,0,
				//		1,0,1,0, 1,0,1,0,
				//		1,1,1,1, 1,1,1,1,
				//	].clump(8).choose}.dup(4).flat,inf).coin.not,
				//	\speed, 1/2,
				//	\dur, 1/8,
				//	\sustain, 0.031,
				//	\out, BusDef(\fbfx, \audio),
				//),
			]),
		),
		Pbind(
			\instrument, \riser2,
			\freq, 50 * 12 * ([1/4]) * (Pseq([
				0-4,
				-2 -4,
			],inf).stutter(16)).midiratio ,
			\isRest, Pseq([
				Pseq({[
					1,0,0,0,
					1,1,0,0,
					1,0,1,0,
				].clump(4).choose}.dup(8).flat,inf)
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
					[ Env.adsr(0.001,0.1,0.8,0.11) ],
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
				],inf).stutter(2),
			],1),
			\legato, Pseq([0.3,0.5, 0.3, 0.5, 0.3, Prand([0.06,0.2],1)],inf).stutter(2) * Pseq([1/2,1/2,1/2,1],inf).stutter(8),
			\amp, 0.4,
			\out, BusDef(\fbfx, \audio),
		),
		Pbind(
			\instrument, \criz,
			\freq, 50 * 12 * (Pseq([
				[0,3,7]-4,
				[-2,2,7]-4,
			],inf).stutter(16)).midiratio ,
			\isRest, Pseq([
				Pseq({[
					0,1,0,1,
					0,0,0,1,
					0,1,0,0,
					1,1,1,1,
					0,0,0,0,
					0,0,0,0,
				].clump(4).choose}.dup(8).flat,inf)
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
					[ Env.adsr(0.001,0.1,0.8,0.11) ],
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
					[ Env.adsr(0.001,0.1,0.8,0.001) ],
				],inf).stutter(2),
			],1),
			\sustain, Pseq([0.03,0.06, 0.03, 0.06, 0.03, Prand([0.06,0.2],1)],inf).stutter(2) * Pseq([1/2,1/2,1/2,1],inf).stutter(8),
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.91,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.001,
				0.00001,0.00001,0.00001,0.00001,
			],inf),2),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.0071,0.0071,0.0071,0.001,
			],inf),2),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\delay, 0.0002,
			\delay2, 0.00001,
			\distmix, 0.5,
			\hpf, 4,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.0000010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)

(
	// tek
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,1,

						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,1,
						1,0,1,0, 1,0,1,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					].clump(32).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.5,
					\out, BusDef(\fbfx, \audio),
				),
			]),
		),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.91,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,

				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.00001,0.00001,0.00001,0.00001,
			],inf),1/4),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,

				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.1071,0.1071,0.1071,0.101,
			],inf),1/4),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\distmix, 0.2,
			\hpf, 40,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)

(
	// kick + snare
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					].clump(32).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\speed, 0.9,
					\sustain, Pseq([0.2,0.5,0.2,0.7],inf).stutter(16),
					\out, BusDef(\fbfx, \audio),
				),
			]),
		),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.91,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,

				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.00001,0.00001,0.00001,0.00001,
			],inf),1/4),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,

				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.0001,0.001,
				0.1071,0.1071,0.1071,0.101,
			],inf),1/4),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\distmix, 0.2,
			\hpf, 40,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)


(
Pdef(\drums2, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\sustain, 0.1,
					\out, BusDef(\fbfx, \audio),
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 1,1,1,1,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\speed, 1/2,
					\dur, 1/8,
					\sustain, 0.031,
					\out, BusDef(\fbfx, \audio),
				),
			]),
		),
		Pbind(
			\instrument, \riser,
			\freq, 50 * Pseg(Pseq([1.8,1],inf),2),
			\dur, 1/8,
			\legato, 0.1,
			\amp, 0.1,
			\out, BusDef(\fbfx, \audio),
		),
		Pbind(
			\instrument, \criz,
			\freq, 50 * 12 * ([0,3,7]-4).midiratio,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/1,
			\legato, 0.5,
			\amp, 0.1/3,
			\out, BusDef(\fbfx, \audio),
		),
		//Pbind(
		//	\instrument, \riser2,
		//	\freq, 50 * 6 * Pseq([
		//		Pfin(16*4,Pseq([
		//			Pser([0,3,7]-4,1/4*16),
		//			Pser([0,3,7]-1,1/4*16),
		//		],inf)),
		//		Pfin(16*4,Pseq([
		//			Pser([0,3,7]-4,1*16),
		//			Pser([0,3,7]-1,1*16),
		//		],inf)),
		//	],inf).midiratio,
		//	\isRest, Pseq([
		//		Pser([
		//			0.5,1,
		//		],3*8),
		//		Pser([
		//			0,0,0,
		//		],1*8),
		//		Pser([
		//			0.5,0.5,1,
		//		],3*8),
		//		Pser([
		//			0,0,0,
		//		],1*8),
		//	],inf).coin.not,
		//	\dur, 1/8,
		//	\legato, 0.5,
		//	\amp, 0.1,
		//	\out, BusDef(\fbfx, \audio),
		//),
		PmonoArtic(\fbfx,
			\inbus, BusDef(\fbfx, \audio),
			//\fb, Pseq([1,1.2,0.4,2.1],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.11,
			],inf),
			\preamp, 1,
			\startamp, 1,
			\foadd, 1.0,
			\fomul, 3,
			\delay, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.00001,0.00001,0.001,0.00001,
				0.0001,0.0001,0.0001,0.0001,
				0.00001,0.00001,0.0051,0.00001,
			],inf),1/2),
			\delay2, 0.000001,
			\delay2, Pseg(Pseq([
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.001,0.0001,
				0.0001,0.0001,0.0001,0.0001,
				0.0001,0.0001,0.001,0.0001,
				0.005, 0.005, 0.005, 0.005,
				0.005, 0.005, 0.005, 0.005,
				0.005, 0.005, 0.005, 0.005,
				0.005, 0.005, 0.005, 0.005,
			],inf),1/2),
			\distmix, Pseq([
				{
					Pseq([
						0,0.7,0.1,0.8
					],1).stutter(rrand(1,8))
				}.dup(8)
			].flat,inf).stutter(1),
			\distmix, 0.2,
			\hpf, 40,
			\mix, 1,
			\postamp, 1/2,
			\lagdelay, 1/8/~t,
			\fb, 0.00010,
			\dur, 1/4,
			//\dur, 1/4,
		
		)
		
	])
).play;
)
