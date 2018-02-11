SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, DelayC.ar(gate, 0.1, [0.01,0.032,0.0123] * \dstrum.kr(1)), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354], 1, coef:coef).sum;
	sig = sig * 2;
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,[0.2,0.1],0.8,0.4,1,4)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\rdnamp, { arg out=0, gate=1;
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
	var ampfol;

	thisThread.randSeed = 16266;
	thisThread.randSeed = 16262;

	in = LPF.ar(in, \prelpf.kr(17000));
	in = HPF.ar(in, \prehpf.kr(17));
	ampfol = LagUD.ar( ( Amplitude.ar(in)+\ampbias.kr(0.01)*\ampfac.kr(1) )**( 2*\ampexp.kr(1) ),\amplagu.kr(0),\amplagd.kr(0) ).poll;
	sig = LocalIn.ar(2) * \fb.kr(0.1) * ampfol + in;
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

	sig = Limiter.ar(sig);
	LocalOut.ar(sig);

	//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
	//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
	//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
	//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
	//	sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);

}).add;
SynthDef(\rdnampdel, { arg out=0, gate=1;
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
	var ampfol;

	thisThread.randSeed = 16266;
	thisThread.randSeed = 16262;

	in = LPF.ar(in, \prelpf.kr(17000));
	in = HPF.ar(in, \prehpf.kr(17));
	ampfol = LagUD.ar( ( Amplitude.ar(in)+\ampbias.kr(0.01)*\ampfac.kr(1) )**( 2*\ampexp.kr(1) ),\amplagu.kr(0),\amplagd.kr(0) ).poll;
	sig = LocalIn.ar(2) * \fb.kr(0.1)  + in;
	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr * ampfol) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr * ampfol) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr * ampfol) + si;
			}.value(si, env);

		].mean;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr * ampfol) + si;
		si2 = BPF.ar(si, exprand(100,10000) * \bpffac1.kr(1), 0.5.rand* \bprqfac1.kr(1) + 0.01);
		si = SelectX.ar(\bpmix.kr(0.5), [si, si2]);
	}.value(si, env);

	sig1 = sig.tanh * \fbdistamp.kr(1/2.1);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);
	LocalOut.ar(sig);

	//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
	//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
	//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
	//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
	//	sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);

}).add;

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
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
		Pmono( \rdnamp,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			\ampfac, 2,
			\ampexp, 1/2,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.7344889782792,
			'fb', 1.2099467303085,
			\amplagd, 0.2,
			'delay', 0.7000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
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
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,0,
					1,1,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.15,
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
		//Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \fmbass,
				\note, Pseq([
					0,0,12,-1,
				],inf).stutter(2),
				\legato, Pseq([
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,2,0,
					6,0,0,0, 0,0,2,0,
					2,0,2,0, 2,0,0,0,
					0,0,4,0, 0,0,2,0,
					3,0,0,3, 0,0,2,0,
					2,0,0,0, 2,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \pluck,
				\note, Pstep(Pseq([
					0,-4,-12,-1,
					0,1,-12,-1,
				],inf),1/2),
				\octave, 7,
				\dstrum, Pseg(Pseq([0.1,10.7010],inf),8*2),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\decay, 0.04,
				\coef, Pseg(Pseq((1..10)/10,inf),1),
				\coef, 0.405,
				\coef, Pseq([
					0.5
				],inf),
				\dur, 1/16,
				\dur, Pwhite(0.05,0.2),
				\dur, PdurStutter(Pseq([1,4,2,8,2,1,4,8,2,8],inf), 1/2),
				\amp, 0.1/2,
				\out, BusDef(\sendbus4, \audio),
			),
		]),

		// Fx

		Pmono( \rdnamp,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			\ampfac, 1,
			\ampexp, 0.6,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.7344889782792,
			'fb', 1.2099467303085,
			\amplagd, 0.2,
			'delay', 0.0000000001231 * Pseq([
				1,1000000,
			],inf).stutter(1),
			'delay2', 0.200000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
			\out, BusDef(\sendbus2),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus2),
			\mix, Pseq([
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
			],inf),
			\time, 1/8/~t * Pseq([
				1,1/2,
				1,1/3,
				2,
			],inf),
			\dur, 1/8,
		),


		Pmono( \rdnamp,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			\ampfac, 1,
			\ampexp, 0.6,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.2344889782792,
			'fb', 1.2099467303085,
			\amplagd, 1.2,
			'delay', 0.00010001231 * Pseq([
				1
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 31.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
		),

		Pmono( \rdnamp,
			\inbus, BusDef(\sendbus4, \audio, 2),
			\addAction, \addToTail,
			\ampfac, 1/2,
			\ampexp, 0.6,
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.4344889782792,
			'fb', 0.4099467303085,
			\amplagd, 0.2,
			'delay', 0.20000010001231 * Pseq([
				1
			],inf).stutter(1),
			'delay2', 0.0000001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 77.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
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
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 0,1,0,0,
					1,1,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.15,
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
		//Pbind(\out, BusDef(\sendbus3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \fmbass,
				\note, Pseq([
					0,0,12,-1,
				],inf).stutter(2),
				\legato, Pseq([
					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,2,0,
					6,0,0,0, 0,0,2,0,
					2,0,2,0, 2,0,0,0,
					0,0,4,0, 0,0,2,0,
					3,0,0,3, 0,0,2,0,
					2,0,0,0, 2,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\sendbus3, \audio),
			),
			Pbind(
				\instrument, \pluck,
				\note, Pstep(Pseq([
					0,-4,-12,-1,
					0,1,-12,-1,
				],inf),1/2),
				\octave, 7,
				\dstrum, Pseg(Pseq([0.1,10.7010],inf),8*2),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\decay, 0.04,
				\coef, Pseg(Pseq((1..10)/10,inf),1),
				\coef, 0.405,
				\coef, Pseq([
					0.5
				],inf),
				\dur, 1/16,
				\dur, Pwhite(0.05,0.2),
				\dur, PdurStutter(Pseq([1,4,2,8,2,1,4,8,2,8],inf), 1/2),
				\amp, 0.1/2,
				\out, BusDef(\sendbus4, \audio),
			),
		]),

		// Fx

		Pmono( \rdnampdel,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			\ampfac, 4,
			\ampbias, 0.1,
			\ampexp, 1.92,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.5344889782792,
			'fb', 0.00199467303085,
			\amplagd, 1.2,
			\amplagu, 1.2,
			'delay', 0.01001231 * Pseq([
				1, 2,1/10,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 117,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\bpmix, 0,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
			\out, BusDef(\sendbus2),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\sendbus2),
			\mix, Pseq([
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
			],inf),
			\time, 1/8/~t * Pseq([
				1,1/2,
				1,1/3,
				2,
			],inf),
			\dur, 1/8,
		),


		Pmono( \rdnampdel,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			\ampfac, 1,
			\ampexp, 0.9,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 1.2344889782792,
			'fb', 0.0002099467303085,
			\amplagd, 1.2,
			'delay', 0.00010001231 * Pseq([
				1
			],inf).stutter(1),
			'delay2', 0.201000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 21.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			\bpmix, 0,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
		),

		Pmono( \rdnampdel,
			\inbus, BusDef(\sendbus4, \audio, 2),
			\addAction, \addToTail,
			\ampfac, 2,
			\ampexp, 0.6,
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.7344889782792,
			'fb', 0.001099467303085,
			\amplagd, 1.2,
			'delay', 0.0100010001231 * Pseq([
				1
			],inf).stutter(1),
			'delay2', 0.02000001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 77.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 2017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\bpmix, 0,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
		),
	])
)).play;
)
