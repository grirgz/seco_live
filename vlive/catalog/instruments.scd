
/////// electric guitar
(
SynthDef(\iron, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	// freq clipped
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(( freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1) ).clip(20,19000)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/8 * \foldfreq.kr(1), (1..8) ) * \foldlevel.kr(1) + \foldbias.kr(1) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.7) * env1 * freq ).clip(20,19000), \rq.kr(0.5));
	pan = pan + (sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ) * \panfreq.kr(1));
	}) * \panwidth.kr(1));
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig * \gain.kr(18);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(),
))).add;
SynthDef(\rdncleandist_fulllight, { arg out=0, gate=1;
	// no Pitch UGen, less cpu heavy
	// mix bpf instead of cutting everything
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var si2;
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var hasFreq, afreq;
	var pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	var pitchmix = \pitchmix.kr(0.5);

	thisThread.randSeed = 16266;
	thisThread.randSeed = 16262;

	in = LPF.ar(in, \prelpf.kr(17000));
	in = HPF.ar(in, \prehpf.kr(17));
	sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);

		].mean;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si2 = BPF.ar(si, exprand(100,10000) * \bpffac1.kr(1), 0.5.rand* \bprqfac1.kr(1) + 0.01);
		si = SelectX.ar(\bpmix.kr(0.5), [si, si2]);
	}.value(si, env);

	sig1 = sig.tanh * \fbdistamp.kr(1/2.1);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig, 1, \limdelay.kr(0.01));
	//sig = Limiter.ar(sig);
	LocalOut.ar(sig);

	//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
	//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
	//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
	//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig,1, \endlimdelay.kr(0.01));
	sig = sig * \wetamp.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
	//	sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
	sig = sig * \gain.kr(1);
	sig = sig * \modgain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);

}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,4,8,-1,
			],inf),1/2),
			\octave, 6,
			\env1, Pseq([
				[ Env([1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([0.1,0.9,1],[0.1,0.8],[1,-1]) ],
				[ Env([1,1.2,1],[0.1,0.8],[1,-1]) ],
			],inf),
			\hpf, 400,
			\gain,8,
			\fmr, Pseq([
				1/8,
			],inf),
			\lpfr, 1,
			\rq, 0.7,
			\foldbias, 1.5,
			\foldlevel, 0.0,
			\diff, 0.02 * Pseq([1],inf),
			\trigenv, 1,
			\fmamp, 1.5,
			\legato, Pseq([
					0.1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.3344889782792,
			'fb', 0.00401099467303085,
			'delay', 0.0011001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 141.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1700,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000 * Pseq([
				1/4
			],inf),
			'posthpf', 17 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
	])
)).play;
)


(
SynthDef(\clavecin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = LFSaw.ar(freq * [0,3,7].midiratio).mean + sig;
	sig = sig * EnvGen.ar(Env.perc(0.01,0.401),gate);
	//sig = sig + ( BPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), freq,0.4)  );
	sig = Ringz.ar(sig, \freqtab.kr({ exprand(0.99,1) }.dup(tabsize)), \res.kr(3.dup(tabsize))).mean;
	sig = sig + Ringz.ar(sig, \freqtab2.kr({exprand(0.99,1.02)  }.dup(tabsize)) * freq, \res2.kr(0.1.dup(tabsize))).mean;
	//sig = SelectX.ar(Line.kr(0.61,0.5,1/2), [sig1 , sig2]);
	//sig = HPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.5,1,-1)), gate, doneAction:2) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Plazy({ arg ev;
			Pbind(
				\degree, Pseq([
					1,2,3,4,5,
				],inf),
				\octave, 4,
				\instrument, \clavecin,
				\freqtab, Pseq([
					[
						( (0..29)+rrand(40,70) ).midicps 
					]
				],inf),
				\freqtab2, Pseq([
					[{exprand(140,10000) }.dup(30)  ]
				],inf),
				\res, Pseq([
					[{rrand(0.01,1.3) }.dup(30)  ]
				],inf),
				\res2, Pseq([
					[{rrand(0.01,0.04) }.dup(30)  ]
				],inf),
				\sustain, 0.1,
				\dur, Pseq(
					(1-2.pow((0..10).neg/4).reverse/4)
					* rrand(0.5,2)),
				\freqr, 1,
				\amp, 0.1,
			);
		}).loop,
		
	])
)).play;
);
