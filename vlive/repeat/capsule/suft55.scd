
(
SynthDef(\bassmol, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) * env1 + 1 ));
	sig = [sig1].sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\delmol, { arg out=0, freq=200, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.04001) ) + sig;

		isig = 8.collect({ arg xx;
			DelayL.ar(sig, 1, 0.17 * (xx+2) );
		}).sum+isig;

		4.do  { arg xx;
			isig = DelayL.ar(sig, 1, 0.2010000013 * SinOsc.ar(xx/10+0.01).range(2.01,0.99) )+isig;
		};
		isig = isig * 20;
		isig = isig.tanh;
		isig = isig / 4;
		isig = 8.collect({ arg xx;
			DelayL.ar(sig, 1, 0.00027 * (xx+1/20) );
		}).sum+isig;
		//8.do  { arg xx;
			//isig = DelayL.ar(sig, 0.01, 0.00000003 * SinOsc.ar(xx/100+0.01).range(1.01,0.99) )+isig;
		//};
		//8.do  { arg xx;
			//isig = DelayL.ar(sig, 2, 0.00000013 * SinOsc.ar(xx/100+0.01, add:1,mul:0.01) )+isig;
		//};
	
		isig = Limiter.ar(isig);
		isig;
	};


	sig = sig * 1/2;
	in = DelayC.ar(in, 0.04);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \bassmol,
			\note, Pseq([
				0,1,2,3,
			],inf),
			\octave, Pseq([
				4,5,6,
			].reverse,inf).stutter(3),
			\mtranspose, Pseq([
				1,2,3,
			]* -1,inf).stutter(2),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\delmol,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\delmol,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
		),
		
	])
)).play;
)


//////////:

(
SynthDef(\veru, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,3,1],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([1,3.03,1],[0.01,1.8]), 1);
	env3 = EnvGen.kr(Env([1,0.3,1],[0.71,0.8]), 1);
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) * env1 + 1 ));
	sig2 = LFSaw.ar(freq * [2,1/2,1/4] * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) * env2 + 1 )).mean;
	sig3 = LFSaw.ar(freq * [1,1.00001,1.0001] * ( LFSaw.ar(freq * \fmr.kr(1)) * \fmamp.kr(0.5) * env3 + 1 )).mean;
	sig = [sig1,sig2, sig3].sum;
	sig = sig * LFSaw.ar(freq,add:1);
	sig = LPF.ar(sig, freq*1.2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, 
	Pbind(
		\instrument, \veru,
		\degree, Pseq([0],inf),
		\fmr,1/4,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Ppar(
			8.collect({ arg x;
				Pbind(
					\instrument, \veru,
					\freq, 3500 / Pseq([1,2,3],inf).stutter(x+1*Pseq((1..4),inf).stutter(16)) / (x+Pseq([1,1,1,2],inf)),
					\legato, 1/2,
					\fmr,1/4 * ( x+1 ),
					\fmamp, 0.01 * ( x+1 ),
					\dur, 1/8 * (x+1),
					\amp, 0.1 * Pseq([1,1,0.7],inf)
				);
			})
		),
		Ppar(
			[5,1,2,8,6,0].collect { arg pos, x;
				PatKitDef(\rim).asPattern(Pbind(
					\kitIndex, pos,
					\sustain, 0.1,
					\dur, 1/8 * (x+2),
				));
			}
		)
	]),
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Ppar(
			8.collect({ arg x;
				Pbind(
					\instrument, \veru,
					\freq, 3500 / Pseq([1,2,3],inf).stutter(x+1*Pseq((1..4),inf).stutter(16)) / (x+Pseq([1,1,1,2],inf)),
					\legato, 1/2,
					\fmr,1/4 * ( x+1 ),
					\fmamp, 0.01 * ( x+1 ),
					\dur, 1/8 * (x+1),
					\amp, 0.1 * Pseq([1,1,0.7],inf)/2,
				);
			})
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
			)),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pmono(\delmol,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
		),
		
	])
)).play;
)



////////////



(
SynthDef(\stepchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(1/4/~t, 0, Dseq([
		1,2,4,3/2,
	],inf));
	lfo2 = Duty.kr(1/3/~t, 0, Dseq([
		1,2,4,3/2,
	],inf));
	freq = freq * [1/2,1,lfo2, lfo1];
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig2 = BPF.ar(sig2, freq * SinOsc.kr(1/2).range(0.5,2), 0.5 * SinOsc.kr(1/13).range(1.4,1/4));
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig3 = BPF.ar(sig3, freq * SinOsc.kr(1/3).range(0.5,2), 0.5 * SinOsc.kr(1/7).range(1.4,1/4));

	sig = [sig1,sig2, sig3].mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part1, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \sinchord,
			\legato, 0.91,
			\note, Pseq([
				[0,1,3,7],
				[4,7,9,12],
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
)


(
SynthDef(\stepchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.ar(1 / \lfofreq1.kr(1/4/~t), 0, Dseq([
		1,2,4,3/2,
	],inf));
	lfo2 = Duty.ar(1 / \lfofreq2.kr(1/4/~t), 0, Dseq([
		1/2,1,2,4,3/2,
	],inf));
	freq = freq * [2,1,lfo2, lfo1];
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig2 = BPF.ar(sig2, freq * SinOsc.kr(1/2).range(0.5,2), 0.5 * SinOsc.kr(1/13).range(1.4,1/4));
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig3 = BPF.ar(sig3, freq * SinOsc.kr(1/3).range(0.5,2), 0.5 * SinOsc.kr(1/7).range(1.4,1/4));
	sig4 = SinOsc.ar(freq).fold2( EnvGen.kr(Env([0,0.1,1,0.01],[Rand(0.01,0.4), Rand(0.01,0.4), Rand(0.21,2)]), 1) )*0.7;

	sig = ( [sig1,sig2, sig3, sig4] * LFNoise1.kr([1/17,1/13,1/16, 1/20]).range(0.0,1) ).mean * 3;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part1, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \stepchord,
			\legato, 0.91,
			\note, Pseq([
				[7,-1,2,5],
				[0,1,3,7],
				[4,7,9,12],
			],inf),
			\lfofreq1, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			\lfofreq2, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			//\lfofreq1, ~pmodenv.(Pseq([1/2,2,1/23,1,40],inf), 8),
			//\lfofreq2, ~pmodenv.(Pseq([1,1/100,20,1/4,4,1/122],inf), 5),
			\strum, Pwhite(0.001,0.1),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part1, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \stepchord,
			\legato, 0.91,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\octave, 4,
			\lfofreq1, Pseg(Pwhite(0.001,2),Pwhite(1.0,17)),
			\lfofreq2, Pseg(Pwhite(0.001,2),Pwhite(1.0,17)),
			//\lfofreq1, ~pmodenv.(Pseq([1/2,2,1/23,1,40],inf), 8),
			//\lfofreq2, ~pmodenv.(Pseq([1,1/100,20,1/4,4,1/122],inf), 5),
			\dur, 2,
			\amp, 0.1*2,
		),
		Pbind(
			\instrument, \stepchord,
			\legato, 0.91,
			\note, Pseq([
				7,3,0,3,
			],inf),
			\octave, 6,
			\lfofreq1, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			\lfofreq2, Pseg(Pwhite(0.001,20),Pwhite(1.0,17)),
			//\lfofreq1, ~pmodenv.(Pseq([1/2,2,1/23,1,40],inf), 8),
			//\lfofreq2, ~pmodenv.(Pseq([1,1/100,20,1/4,4,1/122],inf), 5),
			\dur, 1/2,
			\amp, 0.1/2,
		),
	])
)).play;
)



(
SynthDef(\wavechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = SinOsc.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/8!3).range(0,1);
	sig2 = sig2.mean;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/9!3).range(0,1);
	sig3 = sig3.mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * env2 * freq, \rq.kr(0.5));
	sig = SelectX.ar( lfo1, [sig1, sig2, sig3] ) * 1;
	sig = [sig, SelectX.ar( lfo2, [sig1, sig2, sig3] ) * 1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.7,0.1,0.8,1.4)), gate, doneAction:2);
	sig = sig * amp * 2;

	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \wavechord,
			\note, Pseq([
				[0,4,7,12],
				[0,4,7,11]+3,
			],inf),
			\dur, 4,
			\strum, 0.2,
			\amp, 0.1,
		),
	])
)).play;
)
