
(
TempoClock.default.tempo = 130/60;
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;
~t = TempoClock.default.tempo;
SynthDef(\hat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(11100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(3100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\hat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\snare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([4000,4400,1700],[0.04,0.7],-4), 1) * \env1scale.kr(1);
	sig1 = RLPF.ar(sig, env1 , \rq.kr(0.5) * [1,0.5]) * [1,0.7];
	env2 = EnvGen.kr(Env([1000,4400,1700],[0.01,0.7],-4), 1) * \env2scale.kr(1);
	sig2 = RLPF.ar(sig, env2 , \rq.kr(0.5) * [1,0.5]) * [1,0.7];
	sig = [sig1, sig2];
	//sig = [FreqShift.ar(sig, -220) , sig];
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ]) + sig;
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ] * 4.11) + sig;
	sig = 4.collect { arg x;
		var isig = DelayL.ar(sig, 0.1,0.01 * ( x/40 )) + sig;
		isig = DelayL.ar(isig, 0.1, [ 1/8000, 1/7000 ] * 0.98 * ( x/10 )) + sig;
	};
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\env.kr(Env.perc(0.01,0.2,1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\snare2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmf;
	sig1 = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([freq,freq*2,4541],[0.01,0.08]), 1);
	sig1 = BPF.ar(sig1, env1);
	sig2 = WhiteNoise.ar;
	env2 = EnvGen.kr(Env([freq,freq*2,8541],[0.04,0.08]), 1);
	sig2 = BPF.ar(sig2, env2);

	fmf = freq * [1,1/4];
	env3 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig3 = SinOsc.ar(fmf * ( 1 + ( SinOsc.ar(fmf * 8/10) * env3 )));
	sig = [sig1, sig2];
	sig = sig * EnvGen.kr(Env.perc(0.0001,0.02), gate);
	sig = sig + sig3;
	//sig = [sig1, sig2] * 2;
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ] * 1744.11) + sig;
	sig = sig * EnvGen.kr(Env.perc(0.0001,0.2), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\kick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	//son = son * 1.2;
	//son = son.clip2(1);

	son = son * amp;
	son = son * env0;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	env0: XEnvSpec( ControlSpec(0,9,\lin)!4, ControlSpec(0,2,\lin)!4 ),
	env1: XEnvSpec( ControlSpec(0,127,\lin)!3, ControlSpec(0,2,\lin)!3 ),
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;
)

(
	8.collect({ arg x;
		Ndef(\yaplfo1_+++x, { SinOsc.kr(1/(x*3+8), 3pi/2).range(0,1)  });
		Ndef(\yaplfo2_+++x, { SinOsc.kr(1/(x*4+11)).range(0.01,1)  });
	});
Pdef(\dru, 

	Ppar(
		8.collect({ arg x;
			var tdur = 4.0;
			Plazy({
				Pbind(
					\instrument, \aride,
					\mix, Ndef(\yaplfo1_+++x),
					\rel, Ndef(\yaplfo2_+++x),
					\degree, 28.rand,
					\octave, 3,
					\legato, 0.1,
					\scale, Scale.minor,
					\legato, 0.05 + Pseg(Pseq([0,1,0.5]/8,inf),8+( x*2 )),
					\dur, Pn(tdur,rrand(5,14)),
					\amp, 0.1/10,
					\lag, tdur.rand / ~t,
				);
			}).loop
		})
	)

).play;
)

(
Pdef(\kick1, Pbind(
	\instrument, \kick,
	\env1, Pseq([
		[ Env.new([60, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.4
)).play;
);

(
Pdef(\kick2, Pbind(
	\instrument, \kick,
	\env1, Pseq([
		[ Env.new([60, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,1,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,

		Plazy({ Pseq([0,0,0,0, 0,0,0,1].scramble) }),
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,1,0, 0,0,0,0,

		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.2
)).play;
);

(
Pdef(\snare, 

	Pbind(
		\instrument, \snare,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\amp, 0.1/10
	)
	<>
	Pbind(
		\env, Pseq([
			[ Env.perc(0.01,0.2) ],
			[ Env.perc(0.01,0.2) ],
				//[ Env.perc(0.02,0.4) ]
		],inf),
		\env1scale, Pseq([1],inf),
		//\env2scale, Pseq([1,[0.4,0.8]],inf),
		//\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf),
	).stutter(8)

).play;
);

(
Pdef(\snare2, 

	Pbind(
		\instrument, \snare,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,1,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,1,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			Plazy({ Pseq([0,0,0,0, 0,0,0,1].scramble) }),
			0,0,0,0, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,1,0,0, 0,0,0,0,

			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\amp, 0.1/20
	)
	<>
	Pbind(
		\env, Pseq([
			[ Env.perc(0.01,0.1) ],
		],inf),
		\env1scale, Pseq([1],inf),
		//\env2scale, Pseq([1,[0.4,0.8]],inf),
		//\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf),
	).stutter(8)

).play;
);


(
Pdef(\hat2, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\sustain, 0.05,
	\isRest, Pseq([
		Pser([
			1,0,0,0,
		],12),
		Pser([
			Prand([
				Pseq([
					0,1,
				],1),
				Pseq([
					1,1,
				],1),
				Pseq([
					1,0,
				],1),
			],1),
		],4),
	],inf).coin.not,
	\rel, Pseq([ 
		Pser([
			0.051,
		],12),
		Pser([
			Prand([
				Pseq([
					0.1,
				],1),
				Pseq([
					0.2,0.1,
				],1),
			],1),
		],4)*1,
	],inf),
	\amp, 0.01/10,
	\amp, Pkey(\amp) * Pseq([
		1,0.7,0.9,0.6,
	],inf),
)).play;
);


(
SynthDef(\bass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,2] * ( (1..8)/Rand(10,10000) + 1 ));
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(70) * SinOsc.kr(1).range(0,1) )));
	sig = CombL.ar(sig, 1/freq, 1) + sig;
	sig = sig / 4;
	sig = RLPF.ar(sig, \lpf.kr(700) * [0.5,\lfo1.kr(1.2),\lfo2.kr(1)], \rq.kr(0.4));
	sig = LPF.ar(sig, 1700);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var xfreq;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = SinOsc.ar(freq * [1,2] * ( (1..8)/Rand(10,10000) + 1 ));
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(70) * SinOsc.kr(1).range(0,1) )));
	xfreq = freq * [1,2] * ( (1..8)/Rand(10,10000) + 1 );
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	lfo1 = SinOsc.kr(\lfo1.kr(2)*~t,2pi/2).range(0,1);
	lfo2 = SinOsc.kr(\lfo2.kr(2)*~t,2pi/2).range(1,2);
	sig = SelectX.ar(lfo1*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpf.kr(700) * [0.5,1,1.2] * lfo2, \rq.kr(0.7));
	sig = sig / 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bass3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var xfreq;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = SinOsc.ar(freq * [1,2] * ( (1..8)/Rand(10,10000) + 1 ));
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(70) * SinOsc.kr(1).range(0,1) )));
	xfreq = freq * [1,2] * ( (1..8)/Rand(10,10000) + 1 );
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	lfo1 = SinOsc.kr(\lfo1.kr(2)*~t,2pi/2).range(0,1);
	lfo2 = SinOsc.kr(\lfo2.kr(2)*~t,2pi/2).range(1,2);
	sig = SelectX.ar(lfo1*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpf.kr(700) * [0.5,1,1.2] * lfo2, \rq.kr(0.7));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1/2] ), 1) + sig;
	sig = sig / 12;
	sig = LPF.ar(sig, 1700);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size) * 4 / \lfo1.kr), amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\degree, Pseq([0],inf),
	\octave, 3,
	\lpf, Ndef(\basslfo1, { SinOsc.kr(1/14).range(170,1100)  }),
	\lfo1, Prand([2,4,8,6,1,3,1/2],inf),
	\lfo2, Prand([2,4,6,1,3,1/2]/2,inf),
	\legato, Pseq([
		Pser([
			2,0,0,0, 0,0,0,0,
			2,0,0,0, 0,0,0,0,
			2,0,0,0, 0,0,0,0,
			1/4,Pwhite(1/4,7/4,1),0,0, 0,0,1/2,0,
			2,0,0,0, 0,0,0,0,
			2,0,0,0, 0,0,0,0,
			2,0,0,0, 0,0,0,0,
			1/4,Pwhite(1/4,7/4,1),0,0, 0,0,1/2,0,
		],inf),
		//Pser([
		//	1,1,1,1, 1,1,1,1,
		//],8),
	],inf)*2,
	\mtranspose, Pseq([0,0,0,0, 0,0,0,-1],inf).stutter(8),
	\scale, Scale.minor,
	\isRest, Pseq([
		Pser([
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,1,0,0, 0,0,0,0,

			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			1,1,0,0, 0,0,1,0,
		],inf),
		//Pser([
		//	0,1,1,1, 1,0,1,0,
		//],8),
	],inf).coin.not,
	\dur, 1/2,
	\amp, 0.1
)).play;
);

Pdef(\bass2, Pbind(\instrument, \bass2) <>Pdef(\bass));
Pdef(\bass3, Pbind(\instrument, \bass3) <>Pdef(\bass));


(
	Pdef(\main, 
		Pseq([
			Pfindur(8,
				Ppar([
					Pdef(\kick1),
					Pdef(\kick2),
					Pdef(\snare),
					Pdef(\snare2),
					Pdef(\hat2),
				])
			),
			Ppar([
				Pdef(\kick1),
				Pdef(\kick2),
				Pdef(\snare),
				Pdef(\snare2),
				Pdef(\hat2),
				Pdef(\dru),
				Pseq([Rest(16),Pdef(\bass)]),
			])
		],1),
	).play
)

(
Tdef(\main, {
	var p1;
	// intro

	Pdef(\perc, Ppar([
		Pdef(\kick1),
		Pdef(\kick2),
		Pdef(\snare),
		Pdef(\snare2),
		Pdef(\hat2),
	])).play;

	8.wait;
	Pdef(\dru).play;
	16.wait;
	Pdef(\bass).play;
	32.wait;

	// break

	Pdef(\perc).stop;
	16.wait;

	// no bass

	Pdef(\bass).stop;
	Pdef(\perc).play;
	16.wait;

	// part 2

	Pdef(\bass3).play;
	(32).wait;

	// only modified piano

	Pdef(\perc).stop;
	Pdef(\bass3).stop;
	Pdef(\hat2).play;
	Pdef(\dru).set(\out, BusDef(\null, \audio));

	Pdef(\dru2).play;
	8.wait;

	// part 1

	Pdef(\dru2).stop;
	Pdef(\hat2).stop;

	Pdef(\dru).set(\out, 0);
	Pdef(\perc).play;
	Pdef(\bass).play;
	32.wait;

	// only bass

	Pdef(\perc).stop;
	Pdef(\dru).set(\out, BusDef(\null, \audio));
	Pdef(\bass).stop;

	Pdef(\bass3).play;
	16.wait;

	// return of piano

	Pdef(\bass3).stop;

	Pdef(\bass2).play;
	Pdef(\perc).play;
	Pdef(\dru).set(\out, 0);
	64.wait;

	// break 2
	Pdef(\bass2).stop;
	Pdef(\perc).stop;
	32.wait;

	// part 3
	Pdef(\perc).play;
	Pdef(\bass3).play;
	64.wait;

	// end
	Pdef(\bass3).stop;
	Pdef(\perc).stop;
	32.wait;
}).play
)

(
Tdef(\bla, {
	Pdef(\bass3).play;
	Pdef(\perc).play;
	Pdef(\dru).play;
	(32-4).wait;

	// only modified piano

	Pdef(\perc).stop;
	Pdef(\bass3).stop;
	Pdef(\dru).set(\out, BusDef(\null, \audio));

	Pdef(\dru2).play;
	4.wait;

	Pdef(\bass).play;
	Pdef(\perc).play;
	Pdef(\dru).set(\out, 0);
	Pdef(\dru).play;

}).play
)

Pdef.defaultQuant = 0

Pdef(\)

				Pdef(\perc).stop(Pdef.defaultQuant);
				Pdef(\perc).xstop
				Pdef(\perc).play
				Pdef(\perc).end
				Pdef(\dru). = true

(
	8.collect({ arg x;
		Ndef(\yaplfo1_+++x, { SinOsc.kr(1/(x*3+8), 3pi/2).range(0,1)  });
		Ndef(\yaplfo2_+++x, { SinOsc.kr(1/(x*4+11)).range(0.01,1)  });
	});
Pdef(\dru2, 

	Ppar(
		8.collect({ arg x;
			var tdur = 4.0;
			Plazy({
				Pbind(
					\instrument, \aride,
					\mix, Ndef(\yaplfo1_+++x),
					\rel, Ndef(\yaplfo2_+++x),
					\degree, 28.rand,
					\octave, 3,
					\legato, 0.1,
					\scale, Scale.minor,
					\legato, 0.05 + Pseg(Pseq([0,1,0.5]/8,inf),8+( x*2 )),
					\dur, Pn(tdur,rrand(1,4)),
					\amp, 0.1/10,
					\lag, tdur.rand / ~t,
				);
			}).loop
		})
	)

).play;
)



