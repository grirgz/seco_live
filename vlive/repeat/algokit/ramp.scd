
(
Pdef(\drums1, 
	PatKitDef(\algokit).asPattern(Ppar([
		Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 2,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 9,
			\instrument, \playerpansec,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([0.01,0.02]*3,inf),
			\pan, 0.1,
			\pos, 0.5,
			\speed, 1.2,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 9,
			\instrument, \playerpansec,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\pos, 0.5,
			\speed, 1.2,
			\pan, -0.1,
			\dur, 1/16,
		),
	]))
).play;
)

PatKitDef(\scapkit).edit
(
	~pparamMod = { arg param, ... pairs;
		param.setRaw()
		Pbind(
			*[
				\out, param.getRawkk


			] ++ pairs
		)

	}
)
(
Pdef(\drums1, 
	PatKitDef(\scapkit).asPattern(Ppar([
		Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 1.1,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 1/8*4/~t,
			\speed, Pseg(Pseq([0.1,2],inf),Pseq([16,0],inf)),
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 1.5,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 2.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.051,
			\pos, 0.2,
			\dur, 1/16,
		),
	]))
).play;
)

(
Pdef(\drums1, 
	PatKitDef(\scapkit).asPattern(Ppar([
		Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 1.1,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 2,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([3,1,2]/8/~t,inf),
			\speed, 2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.5,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				Pser([
					1,0,
				],32-8),
				Pser([
					1,1,
					0,1,
					1,1,
				],8),
			],inf).coin.not,
			\sustain, 0.051,
			\pos, 0.1,
			\speed, 1.52,
			\dur, 1/16,
		),
	]))
).play;
)

(
Pdef(\drums1, 
	PatKitDef(\scapkit).asPattern(Ppar([
		Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 1.1,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.5,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\pos, 0.1,
			\sustain, 0.12,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				Pser([
					1,0,
				],32-8),
				Pser([
					1,1,
					0,1,
					1,1,
				],8),
			],inf).coin.not,
			\sustain, 0.051,
			\pos, 0.1,
			\speed, 1.52,
			\dur, 1/16,
		),
	]))
).play;
)

(
Pdef(\drums1, 
	PatKitDef(\scapkit).asPattern(Ppar([
		Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 1.1,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.5,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\pos, 0.1,
			\sustain, 0.12,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				Pser([
					1,0,
				],32-8),
				Pser([
					1,1,
					0,1,
					1,1,
				],8),
			],inf).coin.not,
			\sustain, 0.051,
			\pos, 0.1,
			\speed, 1.52,
			\dur, 1/16,
		),
	]))
).play;
)

(
	SynthDef(\filterline, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var in = In.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		sig = in;
		sig1 = RLPF.ar(sig, XLine.kr(\lpf.kr(100), \lpfend.kr(1000), \lpft.kr(1) * ( (1..2)/10+1 )), \lrq.kr(0.5));
		sig1 = sig1.mean;
		sig1.debug("sig1");
		sig1 = SelectX.ar(\lpfmix.kr(1), [sig, sig1]);
		sig2 = sig1;
		sig2.debug("sig2");
		sig2 = RHPF.ar(sig2, XLine.kr(\hpf.kr(100), \hpfend.kr(1000), \hpft.kr(1) * ( (1..2)/10+1 )), \hrq.kr(0.5));
		sig2 = sig2.mean;
		sig2.debug("sig2e");
		sig = SelectX.ar(\hpfmix.kr(1), [sig1, sig2]);
		sig.debug("sig");
		sig = sig.tanh;
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001,1)), gate, doneAction:2);
		ReplaceOut.ar(out, sig);
	}).add;
	SynthDef(\filterlinechan, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var in = In.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		sig = in;
		sig1 = RLPF.ar(sig, XLine.kr(\lpf.kr(100), \lpfend.kr(1000), \lpft.kr(1) * ( (1..2)/10+1 )), \lrq.kr(0.5));
		sig1 = sig1.mean;
		sig1.debug("sig1");
		sig1 = SelectX.ar(\lpfmix.kr(1), [sig, sig1]);
		sig2 = sig1;
		sig2.debug("sig2");
		sig2 = RHPF.ar(sig2, XLine.kr(\hpf.kr(100), \hpfend.kr(1000), \hpft.kr(1) * ( (1..2)/10+1 )), \hrq.kr(0.5));
		sig2 = sig2.mean;
		sig2.debug("sig2e");
		sig = SelectX.ar(\hpfmix.kr(1), [sig1, sig2]);
		sig.debug("sig");
		sig = sig.tanh;
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001,1)), gate, doneAction:2);
		Out.ar(out, sig);
	}).add;
);

(

Pdef(\main, 
	Pseq([
		Ppar([
			Pseq([
				Pbind(
					\instrument, \filterline,
					\lpf, 40,
					\inbus, BusDef(\mixer0, \audio),
					\out, Pkey(\inbus),
					\lpfend, 18000,
					\lpfmix, 1,
					\hpfmix, 0,
					\lrq, 0.1,
					\dur, Pseq([7],1),
					\legato, 1,
					\lpft, Pkey(\dur)/~t,
					\amp, 0.1
				),
				Pbind(
					\instrument, \filterline,
					\inbus, BusDef(\mixer0, \audio),
					\out, Pkey(\inbus),
					\lpf, 18000,
					\lpfend, 40,
					\lpfmix, 1,
					\hpfmix, 0,
					\lrq, 0.1,
					\dur, Pseq([1],1),
					\legato, 1,
					\lpft, Pkey(\dur)/~t,
					\amp, 0.1
				),
				Pbind(
					\instrument, \filterline,
					\inbus, BusDef(\mixer0, \audio),
					//\inbus, BusDef(\mixer1, \audio),
					\out, Pkey(\inbus),
					\lpf, 1118,
					\lpfend, 18040,
					\lpfmix, 1,
					\hpf, 18000,
					\hpfend, 40,
					\hpfmix, 1,
					\lrq, 0.1,
					\dur, Pseq([8],1),
					\legato, 1,
					\lpft, Pkey(\dur)/~t,
					\hpft, Pkey(\dur)/~t,
					\amp, 0.1
				),
			],1),
			Pbind(\out, BusDef(\mixer0, \audio)) <> Pdef(\drums1),
			 //Pdef(\drums1) <> Pbind(\out, 0),
			//Pdef(\drums1),
		]),
		
	])
).play;
Ndef(\mixer).play;
)
Pdef(\main).clear


(
	Ndef(\mixer, { arg freq=200, pan=0, amp=0.1, inbusses, sendbus0, send0=0;
		var sig;
		var ins;
		var outsig;
		inbusses = 8.collect { arg idx; BusDef(\mixer+++idx, \audio, 2) };
		sendbus0 = BusDef(\sendbus0, \audio, 2);
		outsig = inbusses.collect({ arg inbus, idx;
			var in = InFeedback.ar(inbus, 2); 
			in = in * ( \preamp+++idx ).kr(1);
			Out.ar(sendbus0, in * send0);
			in = in * ( \postamp+++idx ).kr(1);
			//Out.ar(0, in);
			in.debug("ll");
		}).debug("kkk");
		outsig
	}).play;
);
Ndef(\mixer).clear
Ndef(\mixer).edit


/////////////////////////////// fx for each perc


(
Pdef(\drumsfx1, 
	PatKitDef(\scapkit).asPattern(Ppar([
		Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 1.1,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.5,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\pos, 0.1,
			\sustain, 0.12,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				Pser([
					1,0,
				],32-8),
				Pser([
					1,1,
					0,1,
					1,1,
				],8),
			],inf).coin.not,
			\sustain, 0.051,
			\pos, 0.1,
			\speed, 1.52,
			\dur, 1/16,
		),
	].collect({ arg pat, idx;
		idx.debug;
		Pbind(\out, BusDef(\mixer+++idx, \audio, 2)) <> pat
	})))
).play;
)

(
Pdef(\main, 
	Pseq([
		Ppar([
			Ppar([
				6.collect({ arg idx;
					Pbind(
						\instrument, \filterlinechan,
						\inbus, BusDef(\mixer+++idx, \audio),
						//\inbus, BusDef(\mixer1, \audio),
						\out, Pkey(\inbus),
						\out, 0,
						\lpf, Pwhite(100,18000),
						\lpfend, Pwhite(100,18000),
						\lpfmix, 0.81,
						\hpf, Pwhite(100,18000),
						\hpfend, Pwhite(100,18000),
						\hpfmix, 0.81,
						\lrq, 0.1,
						\dur, Pseq([4],inf),
						\legato, 1,
						\lpft, Pkey(\dur)/~t,
						\hpft, Pkey(\dur)/~t,
						\amp, 0.1
					);

				})
			].flat,1),
			Pdef(\drumsfx1),
			 //Pdef(\drums1) <> Pbind(\out, 0),
			//Pdef(\drums1),
		]),
		
	])
).play;
//Ndef(\mixer).play;
)

(
Pdef(\main, 
	Pseq([
		Ppar([
			Pdef(\drumsfx1),
			 //Pdef(\drums1) <> Pbind(\out, 0),
			//Pdef(\drums1),
		]),
		
	])
).play;
	Ndef(\filterbank, { arg freq=200, pan=0, amp=0.1, inbusses, sendbus0, send0=0;
		var ins;
		var outsig;
		inbusses = 8.collect { arg idx; BusDef(\mixer+++idx, \audio, 2) };
		sendbus0 = BusDef(\sendbus0, \audio, 2);
		outsig = inbusses.collect({ arg inbus, idx;
			var in = InFeedback.ar(inbus, 2); 
			var sig = in;
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			sig = sig * ( \preamp+++idx ).kr(1);

			// send
			Out.ar(sendbus0, sig * send0);

			// postfx
			sig1 = sig;
			sig2 = RLPF.ar(sig, LFNoise1.kr(1/8).range(81,18000), LFNoise1.kr(1/14).range(0.1,0.9));
			sig2 = SelectX.ar(LFNoise1.kr(1/7).range(0,1), [sig1, sig2]);
			sig3 = sig2;
			sig3 = RHPF.ar(sig3, LFNoise1.kr(1/10).range(10,18000), LFNoise1.kr(1/13).range(0.1,0.9));
			sig = SelectX.ar( LFNoise1.kr(1/12).range(0,1) , [sig2, sig3]);

			sig = sig * ( \postamp+++idx ).kr(1);
			sig.debug("ll");
		}).debug("kkk");
		outsig.sum
	}).play;
//Ndef(\mixer).play;
)

(
Pdef(\drumsfx1, 
	PatKitDef(\scapkit).asPattern(Ppar([
		Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 1.1,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\speed, 2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.5,
			\dur, 1/16,
		),
		Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\pos, 0.1,
			\sustain, 0.12,
			\dur, 1/8,
		),
		Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				Pser([
					1,0,
				],32-8),
				Pser([
					1,1,
					0,1,
					1,1,
				],8),
			],inf).coin.not,
			\sustain, 0.051,
			\pos, 0.1,
			\speed, 1.52,
			\dur, 1/16,
		),
	].collect({ arg pat, idx;
		idx.debug;
		Pbind(\out, BusDef(\mixer+++idx, \audio, 2)) <> pat
	})))
);
)
