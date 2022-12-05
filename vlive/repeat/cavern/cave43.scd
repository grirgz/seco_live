
// test new rdn with filtered bands



(
	// basic
	RandDelayNetwork(\fband, {
		var block, algo;
		block = [
			\flanger!4,
			\delay!8,
			\delay2!8,
			\delay3!8,
			\shift!4,
			\shift2!4,
			\dist!2,
			\dist2!2,
		].flatten.choose;
		algo = [
			\par, \seq, \split, \split2,
		].wchoose([0.1,0.9,0.1,0.1].normalizeSum);
		switch(algo,
			\par, { 
				\par -> [2,3,4].choose.collect({
					\seq -> [ block, \end ]
				})
			},
			\seq, { 
				\seq -> ([block] ++ (\end ! [1,2].choose))
			},
			\split, { 
				\par -> [
					\seq -> [ \lpf, \end ],
					\seq -> [ \hpf, \end ],
				]
			},
			\split2, { 
				\par -> [
					\seq -> [ \lpf2, \end ],
					\seq -> [ \hpf2, \end ],
				]
			},
		);
	},
	IdentityDictionary.newFrom([
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		},
		\delay2, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		},
		\delay3, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay3.kr) + si;
		},
		\flanger, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.ar(\flangerfreq.kr(1)*0.5.rand).range(1,1 * \flangermax.kr(1)) * \flangerdelay.kr) + si;
		},
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\shift2, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
		},
		\lpf2, { arg si;
			LPF.ar(si, ( \splitband2.kr(100) * exprand(0.9,1.1) ).clip(20,19900))
		},
		\hpf2, { arg si;
			HPF.ar(si, ( \splitband2.kr(100) * exprand(0.9,1.1) ).clip(20,19900))
		},
		\lpf, { arg si;
			LPF.ar(si, ( \splitband.kr(100) * exprand(0.9,1.1) ).clip(20,19900))
		},
		\hpf, { arg si;
			HPF.ar(si, ( \splitband.kr(100) * exprand(0.9,1.1) ).clip(20,19900))
		},
		\dist, { arg si;
			(si * 10.0.rand * \distamp.kr).tanh / 2;
		},
		\dist2, { arg si;
			(si * 10.0.rand * \distamp2.kr).tanh / 2;
		},
		\end, { arg si;
			si;
		}
	]));

)


//////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[811].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1580].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[265].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[811].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1580].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[265].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);


(
Ndef(\fx1, { arg gain=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;

		3.do { arg idx;
			isig = 3.collect({
				DelayL.ar(isig, 1, rrand(0.01,0.1) * ( \delay +++ idx ).kr(1)) + isig;
			}).sum
		};
	
		isig = Limiter.ar(isig);
		isig;
	});
	sig = sig * \wetgain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * gain;
}).play;
);

(
Ndef(\fx1, { arg gain=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sig1 = LPF.ar(sig, \lowbandfreq.kr(100));
	sig1 = sig1 + Fb({ arg fb;
		var isig;
		isig = ( fb * \lowfb.kr(0.01) ) + sig1;

		3.do { arg idx;
			isig = 3.collect({
				DelayL.ar(isig, 1, rrand(0.01,0.1) * ( \lowdelay +++ idx ).kr(1)) + isig;
			}).sum
		};
	
		isig = Limiter.ar(isig);
		isig;
	});

	sig2 = HPF.ar(sig, \lowbandfreq.kr(100));
	sig2 = LPF.ar(sig, \hibandfreq.kr(100));
	sig2 = sig2 + Fb({ arg fb;
		var isig;
		isig = ( fb * \midfb.kr(0.01) ) + sig2;

		3.do { arg idx;
			isig = 3.collect({
				DelayL.ar(isig, 1, rrand(0.01,0.1) * ( \middelay +++ idx ).kr(1)) + isig;
			}).sum
		};
	
		isig = Limiter.ar(isig);
		isig;
	});

	sig3 = HPF.ar(sig, \hibandfreq.kr(100));
	sig3 = sig2 + Fb({ arg fb;
		var isig;
		isig = ( fb * \hifb.kr(0.01) ) + sig3;

		3.do { arg idx;
			isig = 3.collect({
				DelayL.ar(isig, 1, rrand(0.01,0.1) * ( \hidelay +++ idx ).kr(1)) + isig;
			}).sum
		};
	
		isig = Limiter.ar(isig);
		isig;
	});

	sig = [sig1 * \lowgain.kr(1), sig2 * \midgain.kr(1), sig3 * \higain.kr(1)].sum;
	sig = sig * \wetgain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * gain;
}).play;
);
Ndef(\fx1).clear
