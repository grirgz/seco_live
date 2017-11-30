

(
SynthDef(\stutter, { arg out = 0, time= 0.1, mix=0, rate=1;
	var stutter = { arg sig, reset, time, rate = 1.0, maxdelay = 10;
		var phase, fragment, del;
		phase = Sweep.ar(reset);
		fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / time % 1);
		del = Latch.ar(phase, fragment) + ((time - Sweep.ar(fragment)) * (rate - 1));
		DelayC.ar(sig, maxdelay, del);
	};
    var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var reset;
	reset = Changed.kr(mix);
	sig = in;
    sig = stutter.(sig, reset, time, rate, \maxdelay.ir(10));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * \gain.kr(1);
    Out.ar(out, sig);
}).add;
SynthDef(\stuttermud, {
    |out = 0, buf, t_reset = 0, fragmentlength = 0.1, amp = 0.1, mix=0|
	var stutter = { |snd, reset, fragmentlength, rate = 1.0, maxdelay = 10|
		var phase, fragment, del;
		phase = Sweep.ar(reset);
		fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentlength % 1);
		del = Latch.ar(phase, fragment) + ((fragmentlength - Sweep.ar(fragment)) * (rate - 1));

		snd.debug("skj");
		DelayC.ar([ snd ], maxdelay, del * rrand(1.0!4,1.002)).debug("y").mean.debug("x")* 1.5;
	};
    var snd;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	t_reset = Changed.kr(mix);
	snd = in;
    snd = stutter.(snd, t_reset, fragmentlength);
	snd = SelectX.ar(mix, [in, snd]);
    Out.ar(out, snd);
}).add;
)

(
	SynthDef(\reverb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		var fbsig;
		sig = LocalIn.ar(2) * \fb.kr(0.1);
		sig = sig + in;
		15.do {
			sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06), 3);
		};
		fbsig = sig;
		fbsig = LPF.ar(sig, \damp.kr(1000));
		LocalOut.ar(fbsig);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
		Out.ar(out, sig);
	}).add;

	SynthDef(\reverbf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		var fbsig;
		sig = LocalIn.ar(2) * \fb.kr(0.1);
		sig = sig + in;
		15.do {
			sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06), 3);
		};
		fbsig = sig;
		fbsig = LPF.ar(sig, \lpf.kr(1000));
		fbsig = HPF.ar(sig, \hpf.kr(100));
		sig = fbsig;
		LocalOut.ar(fbsig);
		sig = sig * EnvGen.ar(Env.adsr(0.4,0.1,0.8,0.1),gate,doneAction:2);
		sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
		Out.ar(out, sig);
	}).add;
	SynthDef(\reverbif, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		var fbsig;
		sig = 
		sig = LocalIn.ar(2) * \fb.kr(0.1);
		sig = sig + SelectX.ar(\mix.kr(0.5), [DC.ar(0), in]);
		15.do {
			sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06), 3);
		};
		fbsig = sig;
		fbsig = LPF.ar(sig, \lpf.kr(1000));
		fbsig = HPF.ar(sig, \hpf.kr(100));
		sig = fbsig;
		LocalOut.ar(fbsig);
		sig = sig * EnvGen.ar(Env.adsr(0.4,0.1,0.8,0.1),gate,doneAction:2);
		sig = sig + in;
		Out.ar(out, sig);
	}).add;
);

Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
);

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5, \audio))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\speed, 0.95,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.4* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pseq([
			Pmono(\reverbif,
				\inbus, BusDef(\sendbus2, \audio),
				\dur, 1/8,
				\fb, 0.11,
				\mix, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
				\lpf, 18000,
				\hpf, 50,
				\amp, 0.1,
			),
		],inf),
	]),
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer5, \audio))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\speed, 0.95,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\gain, 0.4* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pseq([
			Pmono(\stutter,
				\freq, 200,
				\inbus, BusDef(\sendbus2, \audio),
				\mix, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 0,1,1,1,
					0,1,1,1, 1,1,1,1, 0,1,1,1, 0,1,1,1,
					0,0,0,0, 0,0,0,0, 0,1,1,1, 0,0,0,0,
				],1),
				\fragmentlength, 1/Pseq([
					8,1,1,1, 8,8,4,4, 8,1,1,1, 8,8,4,4,
					1,1,1,1, 1,1,1,1, 16,8,1,1, 16,16,32,32,
			
				],inf)/~t,
				\dur, 1/16,
				\amp, 0.1,
			),
			Pmono(\stuttermud,
				\freq, 200,
				\inbus, BusDef(\sendbus2, \audio),
				\mix, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 1,1,1,1, 0,1,1,1,
					0,1,1,1, 1,1,1,1, 0,1,1,1, 0,1,1,1,
					0,0,0,0, 0,0,0,0, 0,1,1,1, 0,0,0,0,
				],1),
				\fragmentlength, 1/Pseq([
					8,1,1,1, 8,8,4,4, 8,1,1,1, 8,8,4,4,
					1,1,1,1, 1,1,1,1, 16,8,1,1, 16,16,32,32,
			
				],inf)/~t,
				\dur, 1/16,
				\amp, 0.1,
			),
		],inf),
	]),
)).play;
)

/////////////////////////////////////////////////////

(
SynthDef(\allreverbdel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delay.kr(1), 3);
	};
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/4);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5).lag(0.1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\twik, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\cavern, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\freq, Pwhite(200.0,1000)* Pseg(Pseq([0,2],inf),8),
			\dur, 1/8,
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pmono(\allreverbdel,
			\freq, 200,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\fb, 0.1,
			\inbus, BusDef(\fx1, \audio),
			\dur, 1,
			\amp, 0.1,
		);
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				Pseq((1..8)),
				Pseq((1..8).reverse),
			],inf),
			\dur, 1/8,
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \twik,
			\note, 0-Pseq([
				Pseq((1..8)),
				Pseq((1..8).reverse),
				1,
			],inf),
			\dur, 1/8,
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pmono(\allreverbdel,
			\freq, 200,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\fb, 0.1,
			\mix, Pseq([
				1,1,1,1,
				0,0,0,0,
				1,1,0,1,
				1,0,1,1,
			],inf),
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\dur, 1/16,
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				0,0, 0,0, 0,0, 1,1,
				0,0, 0,0, 1,1, 1,1,
				0,0, 0,0, 1,1, 0,0,
				0,0, 1,1, 0,0, 0,0,
			],inf),
			\time, 1/8/~t/2,
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				[1,3,5,9],
				[0,3,7,9],
			],inf).stutter(16),
			\dur, 1/8,
			\octave, Pseq([3,4,5,6],inf).stutter(2),
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				Plazy({ arg ev;
					Pseq([
						[1,3,5,9][3.rand],
						[0,3,7,9][3.rand],
					],1);
				}).loop,
			],inf),2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
			],inf),
			\legato, 0.1,
			\octave, Pseq([3,4,5,6],inf).stutter(1),
			\dur, Pseq([
				Pser([
					1.5
				],5),
				Pser([
					1/8,
				],2),
			],inf),
			\amp, 0.1,
		),
		Pmono(\allreverbdel,
			\freq, 200,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\fb, 0.1,
			\mix, Pseq([
				1,1,1,1,
				0,0,0,0,
				1,1,0,1,
				1,0,1,1,
			],inf),
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\dur, 1/16,
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf)*0.8,
			\time, 1/8/~t/ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
			],inf),
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\note, Pstep(Pseq([
				[1,3,5,9],
				[0,3,7,9],
			],inf),2),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\octave, Pseq([3,4,5,6],inf).stutter(2),
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				Plazy({ arg ev;
					Pseq([
						[1,3,5,9][3.rand],
						[0,3,7,9][3.rand],
					],1);
				}).loop,
			],inf),2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
			],inf),
			\legato, 0.1,
			\octave, Pseq([3,4,5,6],inf).stutter(1),
			\out, BusDef(\fx1,\audio),
			\dur, Pseq([
				Pser([
					1.5
				],5),
				Pser([
					1/8,
				],2),
			],inf),
			\amp, 0.1,
		),
		Pmono(\allreverbdel,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\delay, 0.00001,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, 0.31,
			\mix, Pseq([
				1,1,1,1,
				0,0,0,0,
				1,1,0,1,
				1,0,1,1,
			],inf),
			\mix, 0.7,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\gain, 1/2,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				1,1,1,1, 0,0,0,0,
			],inf)*0.8,
			\time, 1/8/~t/ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
			],inf),
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				[1,3,5,9],
				[0,3,7,9],
			],inf).stutter(16),
			\legato, Pseq([
					3,0,0,0, 3,0,0,0,
					1,0,0,1, 3,0,0,0,
					3,0,0,0, 1,0,1,0,
					1,0,0,1, 2,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\octave, Pseq([3,4,5,6],inf).stutter(Pseq([8,4,2,1],inf)),
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				Plazy({ arg ev;
					Pseq([
						[1,3,5,9][3.rand],
						[0,3,7,9][3.rand],
					],1);
				}).loop,
			],inf),2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
			],inf),
			\legato, 0.1,
			\octave, Pseq([3,4,5,6],inf).stutter(1),
			\out, BusDef(\fx1,\audio),
			\dur, Pseq([
				Pser([
					1.5
				],5),
				Pser([
					1/8,
				],2),
			],inf),
			\amp, 0.1,
		),
		Pmono(\allreverbdel,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\delay, 0.00001,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, 0.31,
			\mix, Pseq([
				1,1,1,1,
				0,0,0,0,
				1,1,0,1,
				1,0,1,1,
			],inf),
			\mix, 0.7,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\gain, 1/2,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				1,1,1,1, 0,0,0,0,
			],inf)*0.8,
			\time, 1/8/~t/ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
			],inf),
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				[1,3,5,9],
				[0,3,7,9],
			],inf).stutter(16),
			\legato, Pseq([
					3,0,0,0, 3,0,0,0,
					1,0,0,1, 3,0,0,0,
					3,0,0,0, 1,0,1,0,
					1,0,0,1, 2,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\octave, Pseq([3,4,5,6],inf).stutter(Pseq([8,4,2,1],inf)),
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				Plazy({ arg ev;
					Pseq([
						[1,3,5,9][3.rand],
						[0,3,7,9][3.rand],
					],1);
				}).loop,
			],inf),2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
			],inf),
			\legato, 0.1,
			\octave, Pseq([3,4,5,6],inf).stutter(1),
			\out, BusDef(\fx1,\audio),
			\dur, Pseq([
				Pser([
					1.5
				],5),
				Pser([
					1/8,
				],2),
			],inf),
			\amp, 0.1,
		),
		Pmono(\allreverbdel,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\delay, 0.00001,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, 0.31,
			\mix, Pseq([
				1,1,1,1,
				0,0,0,0,
				1,1,0,1,
				1,0,1,1,
			],inf),
			\mix, 0.9,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\gain, 1/2,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				1,1,1,1, 0,0,0,0,
			],inf)*0.8,
			\time, 1/8/~t/ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
			],inf),
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)


/////////////////////////////////////////

(
Pdef(\part, Pdef(\stuv_intro, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					1,0,0,1, 1,0,0,1,
				],1),
				Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,
				],inf),
			],inf).coin.not,
			\sustain, 0.1,
			\out, BusDef(\fx1,\audio),
			\gain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \twik,
			\note, Pseq([
				[1,3,5,9],
				[0,3,7,9],
			],inf).stutter(16),
			\legato, Pseq([
					3,0,0,0, 3,0,0,0,
					1,0,0,1, 3,0,0,0,
					3,0,0,0, 1,0,1,0,
					1,0,0,1, 2,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\octave, Pseq([3,4,5,6],inf).stutter(Pseq([8,4,2,1],inf)),
			\out, BusDef(\fx1,\audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				Plazy({ arg ev;
					Pseq([
						[1,3,5,9][3.rand],
						[0,3,7,9][3.rand],
					],1);
				}).loop,
			],inf),2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
			],inf),
			\legato, 0.1,
			\octave, Pseq([3,4,5,6],inf).stutter(1),
			\out, BusDef(\fx1,\audio),
			\dur, Pseq([
				Pser([
					1.5
				],5),
				Pser([
					1/8,
				],2),
			],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Pmono(\allreverbdel,
			\delay, Pseg(Pseq([1,1,0],inf),8),
			\delay, 0.00001,
			\fb, Pseg(Pseq([0,1],inf),8),
			\fb, 0.31,
			\mix, Pseq([
				1,1,1,1,
				0,0,0,0,
				1,1,0,1,
				1,0,1,1,
			],inf),
			\mix, Pseg(Pseq([0,0,1,1,1],inf),4),
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\gain, 1,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx2, \audio),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				1,1,1,1, 0,0,0,0,
			],inf)*0.8,
			\time, 1/8/~t/ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,2,2, 1,1,1,1,
			],inf),
			\mix, 0,
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

///////////////////////////////////////////////



(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pstep(Pseq([
				-5,-5,-5,0, 2,2,2,3,
				-3,0,-3,-3, 3,0,2,3,
			],inf),1/4),
			\legato, Pseq([

					//7,0,0,0, 0,0,1,0,
					//4,0,0,0, 3,0,0,1,
					//7,0,0,0, 0,0,1,0,
					//1,0,4,0, 0,0,1,0,

					//7,0,0,0, 0,0,1,1,
					//3,0,0,1, 4,0,0,0,
					//7,0,0,0, 0,0,1,0,
					//1,0,1,1, 4,0,0,0,
					4,0,0,0, 0,0,0,0,
					1,1,6,0, 0,0,0,0,

					4,0,0,1, 0,0,1,0,
					2,0,0,0, 4,0,0,0,

					4,0,0,0, 3,0,0,0,
					0,0,6,0, 0,0,0,0,

					7,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,1,0,

					2,0,2,0, 3,0,0,0,
					4,0,0,0, 0,0,1,0,


			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\mixer3, \audio),
			\amp, 0.1 * Pseq([1,1],inf),
		),
			Pseq([
				Pfindur(24,Ppar([
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							1,0,0,1, 0,0,0,1,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
							0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
							0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
							0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\gain, 0.2,
						\dur, 1/16,
						\amp, 0.1,
					)),
					PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 8,
						\isRest, Pseq([
							1,0,1,0, 1,0,1,1,
							1,0,1,0, 1,0,1,0,
							1,0,1,0, 1,0,1,0,
							1,0,1,1, 1,0,1,0,
						],inf).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.2,
						],inf),
						\sustain, 0.05,
						\dur, 1/16,
						\amp, 0.1,
					)),
				])),
				Ptpar([
					4, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 1,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,1,
							1,0,0,0, 0,0,0,1,
							1,0,1,0, 0,0,0,1,
							1,0,0,1, 0,0,0,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1,
					)),
					6, PatKitDef(\ksh2b).asPattern(Pbind(
						\kitIndex, 8,
						\isRest, Pseq([
							1,0,1,0, 1,1,1,0,
							1,1,1,1, 1,1,1,1,
						],1).coin.not,
						\out, BusDef(\fx1, \audio),
						\gain, 0.4* Pseq([
							1,0.2,
						],inf),
						\sustain, 0.05,
						\dur, 1/8,
						\amp, 0.1,
					)),
				]),
			],inf),
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				2,9,5,-4,
			],inf),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 4,
			\sustain, 0.1,
			//\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,8.01) ],
				//[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
				//[ Env.adsr(0.1,0.1,0.8,4.01) ],
			//],inf),
			\dur, 1,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \fmbell,
			\note, Pstep(Pseq([
				2,9,5,-4,
			],inf),1),
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 5,
			\sustain, 0.1,
			\fmamp, ~pmodenv.(Pseq([1,2,1,4,1,5,2,10],inf), 2),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.41) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \fmbass,
			\note, Pstep(Pseq([
				5,9,
			],inf),1)+24,
			\isRest, Pseq([
				0,0, 1,0,
				1,0, 1,0,
				1,0, 0,0,
			],inf).coin.not,
			//\gain, ~pmodsynth.({ LFPulse.ar([2,3]*~t).sum.range(0,1) }),
			\octave, 6,
			\sustain, 0.1,
			\fmamp, ~pmodenv.(Pseq([1,2,1,4,1,5,2,10],inf), 2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\out, BusDef(\fx2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				10,9,10,9,
			],inf),1),
			\out, BusDef(\fx2, \audio),
			\legato, Pseq([
				3,0,0,0,
				0.1,0.1,0.1,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\distamp, 50,
			\delay, 0.0001,
			\gain, 0.3,
			\dur, 1,
			\out, BusDef(\fx3,\audio),
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx3, \audio),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0, 0,0, 0,0, 1,1,
				0,0, 0,0, 1,1, 0,1,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0, 0,0, 1,1, 0,0,
				0,0, 1,1, 0,0, 0,0,

				1,1, 1,0, 0,0, 1,1,
				0,0, 1,0, 1,1, 0,0,
				0,0, 1,1, 0,0, 0,0,
				0,0, 0,0, 1,1, 0,1,
			],inf),
			\mix, Pseq([
				0,1,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf),
			\time, 1/8/~t/2,
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\chorusdist,
			\inbus, BusDef(\fx2, \audio),
			\out, BusDef(\fx4),
			\freq, 200,
			\distamp, 20,
			\distpostamp, 1/1,
			\fb, 0.504,
			\distmix, 1,
			\delay, Pseq([
				0.01,
				0.01,
				0.00001,
			],inf),
			\modfreq, 4*~t,
			\modamp, 0.0101,
			\lpf, 9200,
			\hpf, ~pmodenv.(Pseq([100,100,100,100,18000],inf),8,1,1),
			\gain, 0.3,
			\gain, 0.13,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx4, \audio),
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 1,0,1,1,
			],inf),
			\time, 1/8/~t/2,
			\rate, 1/2,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

//////////////

(
	~master_simple.();
	Pdef(\part, Pdef(\ronoswing4,
		Ppar([
		Pbind(
			\instrument, \fmbass,
			\note, Pstep(Pseq([
				1,1,1,0,
			],inf),1/4),
			\legato, Pseq([

					//7,0,0,0, 0,0,1,0,
					//4,0,0,0, 3,0,0,1,
					//7,0,0,0, 0,0,1,0,
					//1,0,4,0, 0,0,1,0,

					//7,0,0,0, 0,0,1,1,
					//3,0,0,1, 4,0,0,0,
					//7,0,0,0, 0,0,1,0,
					//1,0,1,1, 4,0,0,0,
					1,0,2,0, 1,0,0,0,


			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\ifx2, \audio),
			\amp, 0.1 * Pseq([1,1],inf),
		),

			Pbind(\out, BusDef(\mixer3))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,1,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,1,1, 0,0,1,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\mixer5, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 100 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),

			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),

			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
			],inf),

			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\legato, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\sendbus1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 1/4,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.000041,0.000001,0.10001,
				],inf),
				\delay3, 0.0009,
				'delay2', 0.0000072394574653723,
				'distamp', ~pmodenv.(Pseq([0.1,0.52,1,4],inf), 8),
				'distamp3', ~pmodenv.(Pseq([0.1,0.52,1,4],inf), 8),
				\distamp, 0.771,
				\distamp3, 1.77,
				'shift', -00.1,
				'shiftmix', 0.0,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				\out, BusDef(\ifx1, \audio),
				'mamp', 1,
			),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/8,
				\amp, 0.1,
				\inbus, BusDef(\ifx2),
				'wet10', 1.0,
				'mix', 1,
				'gain', 1/4,
				\fb, 0.00001,
				'delay3', Pseq([
0.000001,0.00001,
					0.70001,0.700041,0.000001,0.00001,
				],inf),
				'delay2', 0.0000072394574653723,
				\distamp, 0.771,
				\distamp3, 1.77,
				'shift', -00.1,
				'shiftmix', 0.0,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				\out, BusDef(\ifx1, \audio),
				'mamp', 1,
			),
		Pmono(\stutter,
			\inbus, BusDef(\ifx1, \audio),
			\mix, Pseq([
				1,1,0,1, 0,0,0,0,
				1,1,0,1, 0,1,0,0,
				1,0,1,0, 1,0,1,0,
			],inf),
			\time, 1/8/~t/2,
			\dur, 1/16,
			\amp, 0.1,
		),
		])
	)).play;
);

(
	// treb
	~master_simple.();
	Pdef(\part2, Pdef(\ronoswingtreb,
		Ppar([

			Pbind(\out, BusDef(\fx1, \audio))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
				Pbind(
					\instrument, \snapclap,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,
						0,0,0,1, 0,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					//\amp, 0.1 * Pseg(Pseq([0,1,1,1],inf),8),
				),
			]),
		Pbind( // violin
					\out, BusDef(\fx1, \audio),
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),

			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),

			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
			],inf),

			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0,
				1,0,0,0,
				0,0,1,0,
				0,1,0,0,

				4,0,0,0,
				0,0,0,0,
				1,1,1,1,
				Pseq([ 1,1,1,1, ]/5,1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroomff,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\fx1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 0.7,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.040009,
				'delay2', 0.04000072394574653723 * Pseq([1,2,4,1/2,1/100],inf),
				\distamp, 0.771,
				\distamp3, 0.77,
				'shift', -00.1,
				'shiftmix', 0.4,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				\ehpf, 4000,
				\elpf, 20000,
				\ffmix, 1,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
			),
		])
	)).play;
);
