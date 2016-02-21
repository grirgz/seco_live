
	
(


SynthDef(\dr_kick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = [1,0,-1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	//env0: XEnvSpec( ControlSpec(0,9,\lin)!4, ControlSpec(0,2,\lin)!4 ),
	//env1: XEnvSpec( ControlSpec(0,127,\lin)!3, ControlSpec(0,2,\lin)!3 ),
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;


Pdef(\piano, Pbind(
	\instrument, \default,
	\degree, Prand((1..8),inf),
	\octave, Prand((3..6),inf),
	\isRest, Pseq([
		1,0.4
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));

Pdef(\drkik1,Pbind(
	\instrument, \dr_kick,
	\freq, 200,
	\amp, 0.5,
	\dur, 1,
));

Pdef(\drkik2,Pbind(
	\instrument, \dr_kick,
	\freq, 200,
	\amp, 0.5,
	\dur, 1/2,
));


//////// fx

Spec.add(\lpf, \freq.asSpec);
Spec.add(\hpf, \freq.asSpec);
Spec.add(\plpf, \freq.asSpec);
Spec.add(\phpf, \freq.asSpec);
Spec.add(\delay2, \delay.asSpec);
Spec.add(\shift, ControlSpec(-5,5,\lin));
Spec.add(\shift2, \shift.asSpec);
Spec.add(\pitchmix, \unipolar.asSpec);
Spec.add(\pitchlag, ControlSpec(0.001,1,\exp));

Spec.add(\wet10, \unipolar.asSpec);
Spec.add(\wet20, \unipolar.asSpec);

Ndef(\echo2).put(0, { DC.ar(0!2) });
Ndef(\echo2).put(20, \filter -> { arg in;
	// master volume
	in * \mamp.kr(1)
});

////////////// ugen generation

	~transform = { 
		var block, algo;
		block = [
			\delay, \delay, \delay, \bpf, \shift
		].choose;
		algo = [
			\par, \seq
		].choose;
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> (block ! [1,4].choose) ++ [\end ]
		}
	};

	~seqcollect = { arg in, fun;
		if(in.isKindOf(Association)) {
			in.key -> in.value.collect(fun)
		} {
			in;
		}
	};

	~transcollect = { arg in;

		~seqcollect.(in, { arg el;
			if(el == \end) {
				~transform.()
			} {
				~transcollect.(el)
			}
		})
	};

	~interpret = { arg sig, in, dict, envir;
		if(in.isKindOf(Association)) {
			switch(in.key, 
				\par, {
					in.value.collect({ arg el;
						~interpret.(sig, el, dict)
					}).mean
				},
				\seq, {
					in.value.do({ arg el;
						sig = ~interpret.(sig, el, dict)
					});
					sig;
				}
			)
		} {
			dict[in].value(sig, envir)
		}
	};

	~gentree = { arg count, trans;
		var acc, ini;
		ini = \seq -> [\end];
		acc = ini;
		count.do {
			acc = ~transcollect.(acc, trans);
		};
		acc;
	};

	/////// to customize

	~dict = IdentityDictionary.newFrom([
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		},
		\delay2, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		},
		\flanger, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		},
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\shift2, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
		},
		\bpf, { arg si;
			BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\brf, { arg si;
			BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\dist, { arg si;
			(si * 10.rand * \distamp.kr).tanh / 2;
		},
		\end, { arg si;
			si;
		}
	]);

	~transform = { 
		var block, algo;
		block = [
			\flanger!4,
			\delay!8,
			\delay2!8,
			\bpf!2, 
			\brf!2,
			\shift!4,
			\shift2!4,
			\dist!2,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.1,0.9].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	};

	////////

	Ndef(\echo2).quant = 2;
	Ndef(\lfo1).quant = 2;
	Ndef(\echo2).fadeTime = 0.2;
)



(
	// kick fx
Ndef(\echo2)[0] = Pdef(\drkik1);
Ndef(\echo2)[1] = nil;
Ndef(\echo2).set(\delay, 0.01, \shift, 0.82, \hpf, 20, \lpf, 17000, \wet10, 0.8);
Ndef(\echo2).play;
)

2**8
2**16
2**64
32*32
Ndef(\echo2)[0] = { InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2);  }


(
	// generate new random delay network each time
	
	~tree = ~gentree.(4, ~transform);
	~tree.debug("TREE");
	Ndef(\echo2).put(10, \filter -> { arg in;
		var sig;
		var del, shi;
		var del2, shi2;
		var distamp;
		sig = in;
		del = \delay.kr(1,0.1);
		del2 = \delay2.kr(1,0.1);
		shi = \shift.kr(1);
		shi2 = \shift2.kr(1);
		distamp = \distamp.kr(1);

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		sig = ~interpret.(sig, ~tree, ~dict);
		sig = Limiter.ar(sig) * 2;
		sig = sig.softclip / 4.1;
		sig = LPF.ar(sig, \plpf.kr(17000));
		sig = HPF.ar(sig, \phpf.kr(17));
		sig = sig * \poamp.kr(1);
		sig.debug("end sig");
		sig;
	});
)

Ndef(\echo2).edit; // change delaytime, etc

(
	// piano fx
Ndef(\echo2)[0] = Pdef(\piano);
Ndef(\echo2).set(\delay, 1, \shift, 2, \hpf, 20, \lpf, 17000, \wet10, 0.8);
Ndef(\echo2).play;
)

(
Ndef(\echo2)[0] = Pdef(\drkik1);
Ndef(\echo2)[1] = Pdef(\drkik2);
Ndef(\echo2).set(\delay, Ndef(\lfo1, { 
	var x;
	x = 1.0.rand;
	Duty.kr(1/2, 0, Dseq([
		Dseq([
			0,0,0,x
		],4),
		Dseq([
			Dwhite(0.0001,0.05,1),x,
			Dwhite(0.0001,0.15,1),Dwhite(0.1,0.95,1),
		],4),
	],inf)).lag(0.1);
}));
Ndef(\echo2).play;
	
)

Ndef(\echo2).put(10, nil); // stop fx

Ndef(\echo2).objects[10].synthDef.draw; // draw ugen network on screen (need quark)


Ndef(\echo2)[1] = Pdef(\drkik1);
Ndef(\echo2)[0] = Pdef(\drkik2);
Ndef(\echo2)[0] = Pdef(\kik);
Ndef(\echo2)[0] = nil;
Ndef(\echo2)[1] = nil;
Pdef(\drkik2).stop;

(
Pdef(\kik, Pbind(
	\instrument, \dr_oscsampler,
	\degree, Pseq([0],inf),
	\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
	\timeScale, Pwhite(5,25),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
	],inf),
	\posenv, Plazy({
		Pseq([
			[ Env([0.7,0.2,0.1].rand,[0.1,0.8]) ]
		],inf);
	}),
	\pos, Pwhite(0,0.3),
	\sustain, 0.051,
	\dur, 1/2,
	\amp, 0.1
).stutter(32));
);



(
	// feedback!!!!
	// generate new random delay network each time
	
	~tree = ~gentree.(4, ~transform);
	~tree.debug("TREE");
	Ndef(\echo2).put(10, \filter -> { arg in;
		var sig;
		var del, shi;
		var del2, shi2;
		var distamp;
		sig = in;
		del = \delay.kr(1,0.1);
		del2 = \delay2.kr(1,0.1);
		shi = \shift.kr(1);
		shi2 = \shift2.kr(1);
		distamp = \distamp.kr(1);

		sig = sig + (LocalIn.ar(2) * \fb.kr(0.01));
		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		sig = ~interpret.(sig, ~tree, ~dict);
		sig = Limiter.ar(sig) * 2;
		LocalOut.ar(sig);
		sig = sig.softclip / 4.1;
		sig = LPF.ar(sig, \plpf.kr(17000));
		sig = HPF.ar(sig, \phpf.kr(17));
		sig = sig * \poamp.kr(1);
		sig.debug("end sig");
		sig;
	});
)

Ndef(\echo2).edit
Spec.add(\fb, ControlSpec(0.0001,1,\exp))
Ndef(\echo2).clear


(
	// remove larsen
	// generate new random delay network each time
	
	~tree = ~gentree.(4, ~transform);
	~tree.debug("TREE");
	Ndef(\echo2)[0] = { InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2);  };
	Ndef(\echo2).put(10, \filter -> { arg in;
		var sig;
		var del, shi;
		var del2, shi2;
		var distamp;
		var hasFreq, afreq;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var pitchlag = \pitchlag.kr(0.1) / ~t;
		sig = in;
		del = \delay.kr(1,0.1);
		del2 = \delay2.kr(1,0.1);
		shi = \shift.kr(1);
		shi2 = \shift2.kr(1);
		distamp = \distamp.kr(1);

		sig = sig + (LocalIn.ar(2) * \fb.kr(0.01));
		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		sig = ~interpret.(sig, ~tree, ~dict);
		sig = sig.tanh / 2.1;
		sig = Limiter.ar(sig);
		sig1 = sig;
		#afreq, hasFreq = Pitch.kr(sig1.debug("sig")).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		#afreq, hasFreq = Pitch.kr(sig.debug("sig")).flop;
		sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
		sig = SelectX.ar(\pitchmix.kr(0.5), [sig, sig1]);
		LocalOut.ar(sig);
		sig = LPF.ar(sig, \plpf.kr(17000));
		sig = HPF.ar(sig, \phpf.kr(17));
		sig = Limiter.ar(sig);
		sig = sig * \poamp.kr(1);
		sig.debug("end sig");
		sig;
	});
	Ndef(\echo2).put(20, \filter -> { arg in;
		// master volume
		in * \mamp.kr(1)
	});
)
Ndef(\echo2).put(50, nil);
	(
	Ndef(\echo2).play;
	Ndef(\echo2).put(50, \pset -> (
		Pseq([
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', 0.0001,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 07.643663592842,
				'fb', 0.009049661471447,
				'lpf', 12619.146889604,
				'hpf', 20.0,
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 12.139244620058,
			)
			<> Pbind( \dur, Pseq([6],1),),
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', 0.0001,
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 37.643663592842,
				'fb', 0.109049661471447,
				'lpf', 12619.146889604,
				'hpf', 20.0,
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 12.139244620058,
			)
			<> Pbind( \dur, Pseq([2],1),),
		],inf)
	));
	Pdef(\main, Ppar(
		[
			Pdef(\kick1),
			Pdef(\kick2),
			Pdef(\hat2),
			Pdef(\snare),
		]
	)).play;
	)

	(
	Ndef(\echo2).play;
	Pdef(\main, Ppar(
		[
			Pdef(\kick),
			//Pdef(\kick2),
			Pdef(\hat),
			Pdef(\snare),
		]
	)).play;
	)

	BusDef(\fx1, \audio, 2);
	Pdef(\kick).set(\out, BusDef(\fx1))
	Pdef(\kick1).set(\out, BusDef(\fx1))
	Pdef(\kick2).set(\out, BusDef(\fx1))
	Pdef(\hat2).set(\out, BusDef(\fx1))
	Pdef(\snare).set(\out, BusDef(\fx1))


//////////////////////////////////////////////////////
(
	Ndef(\echo2).put(50, \pset -> (
		//Pbind(
		//	\distamp, 1,
		//)<>
		Pseq([
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', Pseq([0.0001,0.00081,0.002,0.0003],inf).stutter(2),
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 00.643663592842 * Pseq([1,1,1,2, 1,2,1,4],inf),
				'fb', 0.019049661471447 * Pseq([1,1,1,4,],inf).stutter(4),
				'lpf', 12619.146889604,
				'hpf', 20.0,
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 2.139244620058,
			)
			<> Pbind( \dur, Pseq([1/2],inf),),
		],inf)
	));
)
(
	Ndef(\echo2).put(50, \pset -> (
		Pbind(
			//\distamp, 1,
			\fb, Pkey(\fb) * 1/4,
			\distamp, Pkey(\distamp) * 4,
		)<>
		Pseq([
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', Pseq((1..8)/20+1,inf).trace *.x Pseq([0.0001,0.00081,0.002,0.0003],4).stutter(2),
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 00.643663592842 * Pseq([1,1,1,2, 1,2,1,4],inf),
				'fb', 0.019049661471447 * Pseq([1,1,1,4,],inf).stutter(4),
				'lpf', 12619.146889604 * Pseg(Pseq([1,1,1,1/8],inf),8),
				'hpf', Pseg(Pseq([20,20,20,20, 20,500,10,100],inf),4),
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 2.139244620058,
			)
			<> Pbind(\dur, Pseq([1/2], 32 * 3 / 1/2)),
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', Pseq((1..8)/20+1,inf).trace *.x Pseq([0.0001,0.00081,0.002,0.0003],4).stutter(2),
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 00.643663592842 * Pseq([1,1,1,2, 1,2,1,4],inf),
				'fb', 0.019049661471447 * Pseq([1,1,1,4,]/8,inf).stutter(4),
				'lpf', 12619.146889604,
				'hpf', 20.0,
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 2.139244620058,
			)
			<> Pbind(\dur, Pseq([1/2], 32 * 1/ 1/2)),
		],inf)
	));
)
(
	Ndef(\echo2).put(50, \pset -> (
		//Pbind(
		//	\distamp, 1,
		//)<>
		Pseq([
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', Pseq([0.0001,0.00081,0.002,0.0003]*1.21,inf).stutter(2),
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 00.643663592842 * Pseq([4,3,2,1, 1,1,1,1]/2,inf),
				'fb', 0.019049661471447 * Pseq([1,4,4,4,],inf).stutter(4),
				'lpf', 12619.146889604,
				'hpf', 20.0,
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 2.139244620058,
			)
			<> Pbind( \dur, Pseq([1/2],inf),),
		],inf)
	));
)
(
	Ndef(\echo2).put(50, \pset -> (
		Pbind(
			//\distamp, 1,
			\fb, Pkey(\fb) * 4/1,
			\distamp, Pkey(\distamp) * 4,
		)<>
		Pseq([
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', Pseq((1..8)/20+1,inf).trace *.x Pseq([0.0001,0.00081,0.002,0.0003],4).stutter(2),
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 00.643663592842 * Pseq([1,1,1,2, 1,2,1,4],inf),
				'fb', 0.019049661471447 * Pseq([1,1,1,4,],inf).stutter(4),
				'lpf', 12619.146889604 * Pseg(Pseq([1,1,1,1/8],inf),8),
				'hpf', Pseg(Pseq([20,20,20,20],inf),1),
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 2.139244620058,
			)
			<> Pbind(\dur, Pseq([1/2], 32 * 3 / 1/2)),
			Pbind(
				'wet10', 0.51111111111111,
				'pitchlag', 0.1,
				'delay', Pseq((1..8)/20+1,inf).trace *.x Pseq([0.0001,0.00081,0.002,0.0003],4).stutter(2),
				'delay2', 0.00054116952654646,
				'shift', 0.0,
				'shift2', 0.055555555555555,
				'distamp', 00.643663592842 * Pseq([1,1,1,2, 1,2,1,4],inf),
				'fb', 0.019049661471447 * Pseq([1,1,1,4,]/8,inf).stutter(4),
				'lpf', 12619.146889604,
				'hpf', Pseg(Pseq([200,20],inf),2),
				'pitchmix', 0.5,
				'plpf', 20000.0,
				'phpf', 20.0,
				'poamp', 0.11115047846091,
				'wet20', 1.0,
				'mamp', 2.139244620058,
			)
			<> Pbind(\dur, Pseq([1/2], 32 * 1/ 1/2)),
		],inf)
	));
)
//////////////////////////////////////////////////////
Ndef(\echo2).put(50,nil)

(
Pdef(\kick1, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,

		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,1,0, 0,1,0,0,

		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,

		1,0,0,1, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,
	],inf).coin.not,
	\isRest, Pseq([
		Pseq([
			1,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,1,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],3),

		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,1,0, 0,1,0,0,

		Pseq([
			1,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,0,0,
			1,0,1,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],3),

		1,0,0,1, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.152
));
);

(
)

"zzzzzzzz"

(
	~code_to_seeds = { arg word;
		var res = 0; 
		var idx = 0;
		var depth, netseed, valseed;
		var letter_to_number;
		var word_to_number;
		var letters = word.as(Array);

		letter_to_number = { arg letter;
			letter.digit % 32;
		};
		word_to_number = { arg wo;
			var res = 0, idx = 0;
			wo.reverse.do({ arg letter;
				if(letter.isAlphaNum) {
					res = res + ( letter_to_number.( letter ) * (32**idx) );
					idx = idx + 1;
				}
			});
			res;
		};

		letters = letters.select(_.isAlphaNum);
		depth = letter_to_number.(letters.removeAt(0));
		netseed = word_to_number.(letters[0..7]);
		valseed = word_to_number.(letters[8..15]);
		[depth, netseed, valseed];
	};

	~code_to_seeds.("11111111-1212122");

	~number_to_letter = { arg num;
		var res = List.new;
		block { arg break;

			40.do { arg x;
				var div = ( num / 32 ).trunc.asInteger;
				var rest = num % 32;
				[x, num, div, rest].debug("etape x num div rest");
				if(div < 1) {
					debug("break");
					[rest, rest.asInteger.asDigit, div, div.asInteger.asDigit].debug("rest then div added:");
					res.add( ( rest ).asInteger.asDigit );
					//res.add( ( div ).asInteger.asDigit );
					break.value;
				};
				res.add( ( rest ).asInteger.asDigit );
				res.debug("res now");
				[rest, rest.asInteger.asDigit].debug("rest added:");
				num = div;
			};
		};
		res.reverse.join;
	};
	10.asDigit.asCompileString;
	//~number_to_letter.(2341234);
	//~number_to_letter.(14706).debug("dd");
	~number_to_letter.(119048075864).debug("dd");
	~code_to_seeds.("1 1111111-azertyuio");
	
		~word_to_number = { arg wo;
			var res = 0, idx = 0;
			wo = wo.as(Array);
			wo.reverse.do({ arg letter;
				if(letter.isAlphaNum) {
					res = res + ( ( letter.digit % 32 ) * (32**idx) );
					idx = idx + 1;
				}
			});
			res;
		};
		~word_to_number.("BI");
		~number_to_letter.( ~word_to_number.("vvvvvv".debug("start letter")).debug("number") ).debug("letter");
		~number_to_letter.(339177378);
339177378%32
)
( $B.digit * 32 ) + $I.digit
"0a1".digit
$A.digit
$A.digit
0.asDigit
11114164353624


RandDelayNetwork(\delta).codeGen("4 azer.azer/azer.azer");
RandDelayNetwork(\delta).seedGen(4, 1235, nil);
RandDelayNetwork(\delta).seedGen(4, "earteart", nil);
