
	
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
Spec.add(\wet10, \unipolar.asSpec);

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

	~interpret = { arg sig, in, dict;
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
			dict[in].value(sig)
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
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\bpf, { arg si;
			BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\end, { arg si;
			si;
		}
	]);

	~transform = { 
		var block, algo;
		block = [
			\delay, \delay, \delay,
			\delay, \delay, \delay,
			\delay, \delay, \delay, \bpf, \shift,
		].choose;
		algo = [
			\par, \seq
		].choose;
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


(
	// generate new random delay network each time
	
	~tree = ~gentree.(4, ~transform);
	~tree.debug("TREE");
	Ndef(\echo2).put(10, \filter -> { arg in;
		var sig;
		var del, shi;
		sig = in;
		del = \delay.kr;
		shi = \shift.kr;

		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		sig = ~interpret.(sig, ~tree, ~dict);
		sig = Limiter.ar(sig) * 2;
		sig = sig.softclip / 4.1;
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
	Duty.kr(1/2, 0, Dseq([
		Dseq([
			0,0,0,1
		],4),
		Dseq([
			Dwhite(0.0001,0.05,1),1,
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
Ndef(\echo2)[0] = nil;
Ndef(\echo2)[1] = nil;
Pdef(\drkik2).stop;
