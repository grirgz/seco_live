(
SynthDef(\simplebass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);

	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\snapkickx, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

		SynthDef(\rdnroom, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 587079;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = SelectX.ar(\shiftmix.kr, [
					si,
					FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
				]);
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;
		SynthDef(\rdnroomff, { arg out=0, gate=1;
			var sig;
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 587079;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = (si * 10.rand * \distamp3.kr).tanh / 2;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				si = SelectX.ar(\shiftmix.kr, [
					si,
					FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
				]);
				si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			sig1 = sig;
			sig1 = HPF.ar(sig1, \ehpf.kr(140), \ehprq.kr(1));
			sig1 = LPF.ar(sig1, \elpf.kr(10000), \elprq.kr(1));
			sig = SelectX.ar(\ffmix.kr(0.0), [sig, sig1]);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;


		Pbind(
			'wet10', 1.0,
			'mix', 0.5,
			'gain', 1,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.0001,
			'delay3', 0.00010394574653723,
			'distamp', 0.60466190090704,
			'distamp2', 0.23886430789846,
			'distamp3', 2.8985772146511,
			'shift', -5.0,
			'shift2', -1.1344537815126,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'stereo', 0.0,
			'fbdistamp', 3.9234346672443,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
		)


);

(
	~master_simple.();
	Pdef(\part, Pdef(\ronoswing0,
		Ppar([

			Pbind(\out, BusDef(\mixer3))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.011,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.07,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0,
						1,1,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,0,1,
						1,0,1,0,
						1,0,1,0,
						0,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,1,0,0,
						1,0,1,0,
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.05,Pser([
							0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,
						],15),
						0.05,Pser([
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
						],15),

					],inf),
					\dur, 1/16,
					\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
			]),
				Pbind(
					\instrument, \simplebass,
					\out, BusDef(\mixer4, \audio),
					\degree, Pseq([0,2b,4,-4],inf),
					\legato, Pseq([
						Pseq([ 1,1,1,1, ],3),
						Pseq([ 1,1,1,1, ]/4,1),

					],inf),
					\lpf, Pseq([400,200],inf),
					\rq, 0.5,
					\octave, 3,
					\dur, 1,
					\amp, 0.1,
				),
			Pmono(\rdnroom,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\sendbus1),
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/4,
				'fb', 0.0000111,
				'delay3', Pseq([
					0.0001,0.000041,0.000001,0.00001,
					0.0001,0.000041,0.000081,0.00001,
					0.0001,0.000041,0.000001,0.40001,
					0.0001,1.400041,0.000001,0.00001,
				],inf),
				'delay2', 0.000072394574653723,
				'distamp', Pseq([
					Pseq([ 0.73886430789846, ],8*4),
					Pseq([ 1.73886430789846, ],4*4),
					Pseq([ 0.93886430789846, ],4*4),
				],inf),
				'distamp3', 0.6985772146511,
				'shift', -70.0001,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'stereo', 100.0,
				'fbdistamp', 3.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
			),
		])
	)).play;
);

(
	~master_simple.();
	Pdef(\part, Pdef(\ronoswing,
		Ppar([

			Pbind(\out, BusDef(\mixer3))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.011,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.07,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0,
						1,1,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,0,1,
						1,0,1,0,
						1,0,1,0,
						0,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,1,0,0,
						1,0,1,0,
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.05,Pser([
							0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,
						],15),
						0.05,Pser([
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
						],15),

					],inf),
					\dur, 1/16,
					\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
			]),
				Pbind(
					\instrument, \simplebass,
					\out, BusDef(\mixer4, \audio),
					\degree, Pseq([0,2b,4,-4],inf),
					\legato, Pseq([
						Pseq([ 1,1,1,1, ],3),
						Pseq([ 1,1,1,1, ]/4,1),

					],inf),
					\lpf, Pseq([400,200,1000,4000],inf),
					\rq, 0.1,
					\octave, 3,
					\dur, 1,
					\amp, 0.1,
				),
			Pmono(\rdnroom,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\sendbus1),
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/4,
				'fb', 0.0000111,
				'delay3', Pseq([
					0.0001,0.000041,0.000001,0.00001,
					0.0001,0.000041,0.000081,0.00001,
					0.0001,0.000041,0.000001,0.40001,
					0.0001,1.400041,0.000001,0.00001,
				],inf),
				'delay2', 0.000072394574653723,
				'distamp', Pseq([
					Pseq([ 0.73886430789846, ],8*4),
					Pseq([ 1.73886430789846, ],4*4),
					Pseq([ 0.93886430789846, ],4*4),
				],inf),
				'distamp3', 0.6985772146511,
				'shift', -70.0001,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'stereo', 100.0,
				'fbdistamp', 3.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
			),
		])
	)).play;
);

(
	~master_simple.();
	Pdef(\part, Pdef(\ronoswing2,
		Ppar([

			Pbind(\out, BusDef(\mixer3))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.011,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.07,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0,
						1,1,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,0,1,
						1,0,1,0,
						1,0,1,0,
						0,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,1,0,0,
						1,0,1,0,
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.05,Pser([
							0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,
						],15),
						0.05,Pser([
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
						],15),

					],inf),
					\dur, 1/16,
					\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
			]),
				Pbind(
					\instrument, \simplebass,
					\out, BusDef(\mixer4, \audio),
					\degree, Pseq([0,2b,4,-4],inf),
					\legato, Pseq([
						Pseq([ 1,1,1,1, ],3),
						Pseq([ 1,1,1,1, ]/4,1),

					],inf),
					\lpf, Pseq([400,200,1000,4000],inf),
					\rq, 0.1,
					\octave, 3,
					\dur, 1,
					\amp, 0.1,
				),
			Pmono(\rdnroom,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\sendbus1),
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/4,
				'fb', 0.0000111,
				'delay3', Pseq([
					0.0001,0.000041,0.000001,0.00001,
					0.0001,0.000041,0.000081,0.00001,
					0.0001,0.000041,0.000001,0.40001,
					0.0001,1.400041,0.000001,0.00001,
				],inf),
				'delay2', 0.000072394574653723,
				'distamp', Pseq([
					Pseq([ 0.73886430789846, ],8*4),
					Pseq([ 1.73886430789846, ],4*4),
					Pseq([ 0.93886430789846, ],4*4),
				],inf),
				'distamp3', 0.6985772146511,
				'shift', -70.0001,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'stereo', 100.0,
				'fbdistamp', 3.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
			),
		])
	)).play;
);

(
	~master_simple.();
	Pdef(\part, Pdef(\ronoswing3,
		Ppar([

			Pbind(\out, BusDef(\mixer3))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,1,0,0, 0,0,0,0,

						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.011,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.07,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0, 1,1,1,0, 1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,0,1, 1,0,1,0, 1,0,1,0,
						0,0,1,0, 1,0,1,0, 1,0,1,0, 1,1,0,0,
						1,0,1,0, 1,0,1,0, 1,1,1,0, 1,0,1,0,
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.05,Pser([
							0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,
						],15),
						0.05,Pser([
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
						],15),

					],inf),
					\dur, 1/16,
					\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
			]),
				Pbind(
					\instrument, \simplebass,
					\out, BusDef(\mixer4, \audio),
					\degree, Pstep(Pseq([0,2b,4,-4],inf),1),
					\legato, Pseq([
						Pseq([ 7,0,0,0, 0,0,0,0, ],4),
						Pseq([ 7,0,0,0, 0,0,0,0, ],2),
						2,0,0,0, 4,0,0,0,
						Pseq([ 7,0,0,0, 0,0,0,0, ],3),
						1,0,6,0, 0,0,0,0,

						Pseq([ 7,0,0,0, 0,0,0,0, ],3),
						5,0,0,0, 0,0,1,0,
						Pseq([ 7,0,0,0, 0,0,0,0, ],3),
						6,0,0,0, 0,0,0,1,
						6,0,0,0, 0,0,0,1,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpf, Pseq([400,200,1000,4000],inf).stutter(8),
					\rq, 0.1,
					\octave, 3,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
		Pbind( // violin
					\out, BusDef(\mixer5, \audio),
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
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,4,0, 0,0,0,0,
				0,0,0,0, 1,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/8,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
		),
			Pmono(\rdnroom,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\sendbus1),
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/5,
				\fb, Pseq([
					Pseq([
						0.00001,
					],4*8*3),
					Pseq([
						0.00501,
					],4*8*1),
					
				],inf),
				'delay3', Pseq([
					0.00001,0.000041,0.000001,0.00001,
					0.00001,0.000041,0.000001,0.00001,
					0.00001,0.000041,0.000001,0.00001,
					0.00001,0.000041,0.000001,0.00001,

					0.0001,0.000041,0.000001,0.00001,
					0.0001,0.000041,0.000081,0.00001,
					0.0001,0.000041,0.000001,0.40001,
					0.0001,1.400041,0.000001,0.00001,
				],inf),
				'delay2', 0.000072394574653723,
				'distamp', Pseq([
					Pseq([ 0.73886430789846, ],8*4),
					Pseq([ 1.73886430789846, ],4*4),
					Pseq([ 0.93886430789846, ],4*4),
				],inf),
				'distamp3', 0.6985772146511,
				'shift', -70.0001,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'stereo', 00.0,
				'fbdistamp', 3.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
			),
		])
	)).play;
);

(
	~master_simple.();
	Pdef(\part, Pdef(\ronoswing4,
		Ppar([

			Pbind(\out, BusDef(\mixer3))<>Ppar([
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
					\out, BusDef(\mixer5, \audio),
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
				\inbus, BusDef(\sendbus1),
				'wet10', 1.0,
				'mix', 1,
				'gain', 1/8,
				\fb, ~pmodenv.(Pseq([0.0001,0.0002,0.001,0.004],inf), 8),
				\fb, 0.00001,
				'delay3', Pseq([
					0.00001,0.700041,0.000001,0.00001,
				],inf),
				\delay3, 0.0009,
				'delay2', 0.0000072394574653723,
				'distamp', ~pmodenv.(Pseq([0.1,0.52,1,4],inf), 8),
				'distamp3', ~pmodenv.(Pseq([0.1,0.52,1,4],inf), 8),
				\distamp, 8.771,
				\distamp3, 8.77,
				'shift', -00.1,
				'shiftmix', 0.0,
				'stereo', 00.0,
				//'ehpf', ~pmodenv.(Pseq([10000,2000,40,40],inf), 8),
				//'elpf', ~pmodenv.(Pseq([7000,10000,12040,17040],inf), 8),
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
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
				'gain', 1/2,
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

WindowDef(\main).front


	(
	)



//////////////// //////////////// //////////////// ////////////////
//////////////// //////////////// //////////////// ////////////////
// change bass


(
	~master_simple.();
	Pdef(\part, Pdef(\ronover,
		Ppar([

			Pbind(\out, BusDef(\mixer3))<>Ppar([
				Pbind(
					\instrument, \snapkickx,
					\bodyenv, [ Env.linen(0.001,0.01,0.1) ],
					\bodyfreqenv, [ Env([261, 54, 41], [0.035, 0.08], curve: \exp) ],
					\isRest, Pseq([
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.051,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\sustain ,0.011,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,1,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,1,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1,0,0,
						0,1,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8 * Pseq([4/3,2/3],inf),
					\amp, 0.07,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0,
						1,1,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,0,0,1,
						1,0,1,0,
						1,0,1,0,
						0,0,1,0,
						1,0,1,0,
						1,0,1,0,
						1,1,0,0,
						1,0,1,0,
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.05,Pser([
							0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,
						],15),
						0.05,Pser([
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
						],15),

					],inf),
					\dur, 1/16,
					\dur, 1/16 * Pseq([4/3,2/3],inf).stutter(2),
					\pan, 0,
					\amp, 0.02,
				),
			]),
				Pbind(
					\instrument, \simplebass,
					\out, BusDef(\mixer4, \audio),
					\note, Pstep(Pseq([0,1,-3,-3],inf),1),
					\legato, Pseq([
						1,0,0,1,
						3,0,0,0,
						0,1,1,0,
						1,0,1,0,

						3,0,0,0,
						1,0,0,1,
						1,0,0,0,

					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\lpf, Pseg(Pseq([200,1400,2000,1000],inf),8),
					\rq, 0.5,
					\octave, 3,
					\dur, 1/4,
					\amp, 0.1,
				),
			Pmono(\rdnroom,
				\freq, 200,
				\dur, 1/4,
				\amp, 0.1,
				\inbus, BusDef(\sendbus1),
				'wet10', 1.0,
				'mix', 0.5,
				'gain', 1/4,
				'fb', 0.0000111,
				'delay3', Pseq([
					0.0001,0.000041,0.000001,0.00001,
					0.0001,0.000041,0.000081,0.00001,
					0.0001,0.000041,0.000001,0.40001,
					0.0001,1.400041,0.000001,0.00001,
				],inf),
				'delay2', 0.000072394574653723,
				'distamp', Pseq([
					Pseq([ 0.73886430789846, ],8*4),
					Pseq([ 1.73886430789846, ],4*4),
					Pseq([ 0.93886430789846, ],4*4),
				],inf),
				'distamp3', 0.6985772146511,
				'shift', -70.0001,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'stereo', 100.0,
				'fbdistamp', 3.9234346672443,
				'fbdistmix', 0.91176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'brfrqfac', 0.37940593233798,
				'brffac', 0.60195390291997,
			),
		])
	)).play;
);

(
Pdef(\treb, Pbind(
	\instrument,\star,
	//\freq, 100,
	\degree, Pseq([
		0,
	],inf),
	//\root, Pstep(Pseq([0,5,7,5],inf),4),
	//\root, Pstep(Pseq([0,4,2,5],inf),4),
	\mtranspose, Pstep(Pseq([0,4,2,5],inf),4),
	\scale, Scale.major,
	\octave, 6,
	\dur, 1,
	\amp, 0.2,
	\out, BusDef(\mixer5, \audio),
	\lag, Pseq([0,1/4 + Pwhite(0,0.01,1)],inf) / ~t,
	\adsr, Pseq([
		[ Env.adsr(0.5,0.1,1.8,0.8) ],
	],inf),
	\legato, 0.5,
	\isRest, false,
)).play;
)

(
Pdef(\treb, PmonoArtic( \star,
	\degree, Pseq([
		0,2,-3,5, 0,0,2,0,
		0,2,-3,5, 0,0,2,0,
		2,0,-3,5, 0,0,2,0,
		2,0,-3,5, 0,0,2,0,
	],inf),
	\legato, Pseq([
		0,0,0,0, 1,1,1,1,
		1,1,1,0.5, 0,0,0,0,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\scale, Scale.gong,
	\octave, 6,
	\amp, 0.4,
	\dur, 1/8,
)).play;
)
