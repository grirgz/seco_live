
- perc
	- kick
	- snare
	- hat
	- tom
	- cymbal
	- clap
- drone
- bass
	- big bass
	- sub
	- guitar bass



(
SynthDef(\bowed, { arg out=0, pan=0, amp=1.0, gate=1, freq=420, bowOffset = 0.0, bowSlope = 0.5, bowPosition = 0.75, vibFreq=6.127, vibGain=0.0;
	var betaRatio = 0.027236 + (0.2*bowPosition);
	var baseDelay = freq.reciprocal;
	var lastOut = LocalIn.ar(2);
	var vibrato = SinOsc.ar(vibFreq, 0, vibGain);
	var neckDelay = baseDelay*(1.0-betaRatio) + (baseDelay*vibrato);
	var neck = DelayL.ar(lastOut[0], 0.05, neckDelay);
	var bridge = DelayL.ar(lastOut[1], 0.025, baseDelay*betaRatio);
	var stringFilter = OnePole.ar(bridge*0.95, 0.55);
	var adsr = amp*EnvGen.ar(Env.adsr(0.02, 0.005, 1.0, 0.01), gate, doneAction: 2);
	var bridgeRefl = stringFilter.neg;
	var nutRefl = neck.neg;
	var stringVel = bridgeRefl + nutRefl;
	var velDiff = adsr - stringVel;
	var slope = 5.0 - (4.0*bowSlope);
	var bowtable = (( ((velDiff+bowOffset)*slope) + 0.75 ).abs ).pow(-4).clip(0, 1);
	var newVel = velDiff*bowtable;
	var sig = Resonz.ar( bridge*0.5, 500, 0.85 ) *adsr;
	sig = Pan2.ar(sig, pan, 1) * 8;
	LocalOut.ar([bridgeRefl, nutRefl] + newVel);
	Out.ar(out,sig );
}, [\ir, 0,0, 0, 0, 0, 0, 0, 0]).store;
)

Synth(\bowed);

(
Pdef(\zed, 
	Pbind(
		\instrument, \bowed,
		\degree, Pseq([0,7,1,3],inf),
		\octave, Prand([4,5,6,3],inf),
		//\adsr, Pseq([
			//[ Env.adsr(0.1,0.1,0.8,2.1) ],
		//],inf),
		\bowOffset, ~pmodenv.(Pseq([0,0.051],1), 7).loop,
		\bowSlope, ~pmodenv.(Pseq([0.1,1],1), 3).loop,
		\bowPosition, ~pmodenv.(Pseq([0.1,1.7],1), 8).loop,
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);


///////////////////////



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
	sig = WhiteNoise.ar(1);
	sig = sig * EnvGen.ar(Env.perc(0.0071,0.21),gate);
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


/////////////////////// ///////////////////////
// jmc piano


(
SynthDef(\jmcpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	env = Decay2.ar(strike, \hamat.kr(0.008), \hamrel.kr(0.04));
	detune = \detunetab.kr([-0.05, 0, 0.04].midiratio);
	delayTime = 1 / ( freq * detune );
	sig = LFNoise2.ar(\hamfreq.kr(3000)!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime, \decay.kr(6));
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\hamat, ~pmodenv.(Pseq([0.008,0.0008,0.1],1), 7).loop,
				\hamfreq, ~pmodenv.(Pseq([1,2,40,1,4,70]*100,1), 8).loop,
				\dur, 1/(0.1+0.4.rand),
				\amp, 0.1/2,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);


///// variants

(
SynthDef(\jmcpiano_drowned, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	env = Decay2.ar(strike, \hamat.kr(0.008), \hamrel.kr(0.04));
	detune = \detunetab.kr([-0.05, 0, 0.04].midiratio);
	delayTime = 1 / ( freq * detune ).poll;
	sig = LFNoise2.ar(\hamfreq.kr(3000)!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime, \decay.kr(6));
	sig1 = AllpassL.ar(sig, delayTime, delayTime, \apdecay.kr(6));
	sig = SelectX.ar(\apmix.kr(0.5), [sig, sig1]);
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano_drowned,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\decay, ~pmodenv.(Pseq([1,6],1), 5).loop,
				\apdecay, ~pmodenv.(Pseq([6,1],1), 7).loop,
				\apmix, ~pmodenv.(Pseq([0,1,0.5],1), 3).loop,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Plazy({ arg ev;
			Pfindur(8,
				Ppar(6.collect { arg idx;
					Pmono(
						\jmcpiano_drowned,
						\pitch, [0,12,24].choose+36 + [0,3,7,9,11].choose + Pkey(\rootpitch),
						\freq, Pkey(\pitch).midicps,
						\decay, ~pmodenv.(Pseq([1,6],1), 5).loop,
						\apdecay, ~pmodenv.(Pseq([6,1],1), 7).loop,
						\apmix, ~pmodenv.(Pseq([0,1,0.5],1), 3).loop,
						\strike, 1,
						\dur, 1/(0.1+0.4.rand),
						\lag, 0.3.rand,
						\isRest, Pseq([
							Prand([0,1],1),Pseq([1],inf),
						],inf).coin.not,
						\amp, 0.1,
						\pan, (Pkey(\pitch) - 36)/27 - 1
					)
				})
			)
		}).loop
	   	<>
		Pbind(\rootpitch, Pstep(Pwhite(0,12,inf),8))
	])
)).play;
);

////////////:

(
SynthDef(\jmcpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	env1 = EnvGen.kr(Env([1,0.1,0],[0.1,0.8]), strike);
	env2 = EnvGen.kr(Env([1,0.5,0].reverse,[0.1,0.8]), strike);
	env = Decay2.ar(strike, \hamat.kr(0.008), \hamrel.kr(0.04));
	detune = \detunetab.kr([-0.05, 0, 0.04].midiratio);
	delayTime = 1 / ( freq * detune ).poll;
	sig = LFNoise2.ar(\hamfreq.kr(3000)!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime * ( SinOsc.kr(17 * env2) * env1 * 0.31 + 1 ), \decay.kr(6));
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

////////////:

(
SynthDef(\jmcpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	env1 = EnvGen.kr(Env([1,0.1,0],[0.1,0.8]), strike);
	env2 = EnvGen.kr(Env([0,0.5,1]*0.5,[0.4,0.8]), strike);
	env3 = EnvGen.kr(Env([1,0.98,1],[0.1,2.1]), strike);
	env = Decay2.ar(strike, \hamat.kr(0.008), \hamrel.kr(0.04));
	detune = \detunetab.kr([-0.05, 0, 0.04, -12].midiratio);
	delayTime = 1 / ( freq * detune );
	sig = LFNoise2.ar(\hamfreq.kr(3000)!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime, \decay.kr(6));
	sig = sig * ( SinOsc.ar(freq/2 * detune + 0.1 * env3).unipolar * env2 + 1 );
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

///////:::

(
SynthDef(\jmcpiano2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//strike = K2A.ar(strike);
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	//strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key
	env1 = EnvGen.kr(Env([1,0.3,0],[0.1,0.8]), strike);
	env = Decay2.ar(strike, 0.008, 0.04);
	detune = [-0.05, 0, 0.04].midiratio;
	delayTime = 1 / ( freq * detune );
	sig = LFNoise2.ar(\hamfreq.kr(3000)!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime * ( SinOsc.ar(17 * env1) * 0.1 * env1 + 1 ), \decay.kr(6));
	sig = AllpassL.ar(sig, delayTime,  delayTime, \decay.kr(6)) + sig;
	sig = AllpassL.ar(sig, delayTime,  delayTime*3, \decay.kr(6));
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano2,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				//\hamfreq, ~pmodenv.(Pseq([9,1,2,1,4]*500,1), 8).loop,
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(1.collect { arg idx;
			Pmono(
				\jmcpiano2,
				\pitch, (36 + 54.rand) + Pseq([0,3,2],inf) + [0,3,7],
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 4,
				\out, BusDef(\sendbus1, \audio),
				//\hamfreq, ~pmodenv.(Pseq([9,1,2,1,4]*500,1), 8).loop,
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

//////////


(
Ndef(\combchain, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	var oin = in;
	in = in + CombC.ar(in, 2, SinOsc.ar(0.15* [0.13, 0.17]).range(0.5, 1) * [0.13, 0.17], 7);
	in = in + CombC.ar(in, 2, SinOsc.ar(0.1* [0.1, 0.15]).range(0.5, 1) * [0.1, 0.15], 7);
	in = in + CombC.ar(in, 2, [1.5, 1.0], 7);
	//in = in + GVerb.ar(in, 1);
	in = in + FreeVerb2.ar(in[0], in[1], 0.5, 1);
	in = in / 3 / 3;
	in = Compander.ar(in, in, \cpt.kr(0.2), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	in = SelectX.ar(\mix.kr(0.5), [oin, in]);
	in = in * \gain.kr(1);
	in;
}).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \jmcpiano,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\octave, Pseq([3,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,1.2,3.1) ],
			],inf),
			\legato, 0.1,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		
	])
)).play;
);

