// this file came with the JoshUGens... Leonard Bernstein talking about Beethoven.
// Place it in your SC3/sounds directory.
a = LPCFile.new(Platform.resourceDir +/+ "sounds/fate.lpc", server: s).loadToBuffer;

(
z = {
var cps, rmso, err, voc, noise, timepoint, dur;
timepoint = LFSaw.ar(0.4/a.sndDur, 1, 0.5, 0.5);

# cps, rmso, err = LPCVals.ar(a.buffer, timepoint);
// a periodic Blip to filter, amplitude is 1 - error
noise = WhiteNoise.ar(err); // a noise source

voc = Blip.ar(cps, 100);
// the rms values tend to be high... scale them back quite a bit!
Out.ar(0, LPCSynth.ar(a.buffer, voc + noise, timepoint, rmso));
}.play(s)
)
z.free;
// clean up
s.sendBundle(0.1, [\b_free, a.buffer]);


// Table size of 1 reflects the input.
x = { MarkovSynth.ar(SinOsc.ar(), 1, 2, 1) * 0.1 }.play;
x.free;

// Table size of 2, keep it running for a while.
x = { MarkovSynth.ar(SinOsc.ar(), 1, 2, 2) * 0.1 ! 2; }.play;
x.free;

// Table size of 2, Modulating the amplitude a wee bit...
x = { MarkovSynth.ar(SinOsc.ar() * LFNoise1.ar(0.1).range(0.9, 1), 1, 2, 2) * 0.1 ! 2; }.play;
x.free;

// Table size of 3, on a periodic signal. A probabilistic explosion...
x = { MarkovSynth.ar(SinOsc.ar(), 1, 2, 3) * 0.1 ! 2; }.play;
x.free;

// Table size of 10, on a periodic signal. Another probabilistic explosion...
// When the transitions of the sine curve is broken, it becomes much noisier
// than tableSize = 3, because there are more samples in the table to try out.
// if you wait enough, output may stabilize at some point again.
x = { MarkovSynth.ar(SinOsc.ar(), 1, 2, 10) * 0.1 ! 2; }.play;
x.free;

// Modulating the frequency and amplitude by hand.
(
x = { Out.ar([0,1], MarkovSynth.ar(SinOsc.ar(MouseY.kr(10, 1000)) * MouseX.kr(0, 1),
                                   1, 1, 50)) * 0.1 ! 2; }.play;
)
x.free;

// Feedbacks and modulation!
(
SynthDef("markov", { arg recEnable = 1, waitTime = 1;
                     var fedIn = LocalIn.ar(1) * 0.9;
                     var mark = MarkovSynth.ar(fedIn + (Saw.ar(MouseY.kr(10, 5000)) * MouseX.kr(0, 0.5)), recEnable, waitTime, 3);
                     LocalOut.ar(mark);
                     Out.ar(0, mark.dup); } ).send(s);
)

x = Synth("markov")
x.free;


(
Pdef(\gdrums, 
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
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		))
		
	])
).play;
)

(
Ndef(\kov, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var mark = MarkovSynth.ar(in, 1, 1, 12);
	sig = SelectX.ar(\mix.kr(0.5), [mark, in]);
}).play;
);


//////////////////////// FMGrain
// en fait on peut faire blindé de trucs avec FMGrain


(
SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var sig = FMGrain.ar(
		Impulse.ar(240 * ( 1 + ( SinOsc.ar(2*~t) * 1 ))), 0.14, freq, freq*fratio * ( 1 + ( SinOsc.ar(freq*8) * 0.01 )),
		LFSaw.ar(200!2).range(0.1, 11),
	);
	sig = sig * 1/4;
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 180);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(0, sig);
}).add;
)
(
Pdef(\plop, Pbind(
	\instrument, \fm_grain_test,
	\fratio, 1/2,
	\fratio, Pseq([1,2,3/2,1.21314],inf),
	\degree, Pseq([0,2],inf),
	\octave, Pseq([3,4],inf).stutter(2),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, freq=200, fratio=2, pan=0;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig;
	
	env1 = EnvGen.kr(Env([1,8,31],[0.3,1.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(40 * ( 1 + ( SinOsc.ar(20*~t) * 0.1 ))), 0.14, freq * [1,2,1/2], freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar([ 200!2 ]).range(0.1, 1 * env1),
	).sum;
	sig = sig * 1/4;
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 180);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.4,0.1,0.8,1.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
    Out.ar(0, sig);
}).add;
)

(
Pdef(\plop, Pbind(
	\instrument, \fm_grain_test,
	\fratio, 1/2,
	\fratio, Pseq([1],inf),
	\degree, Pseq([
		[0,2,4],
		[0,2-12,4],
		[0,2,4],
		[3,5-12,7],
	],inf),
	\octave, Pseq([4,5],inf).stutter(2),
	\legato, 1,
	\dur, 2,
	\amp, 0.1/8
)).play;
);


/////////////////////////////

(
SynthDef(\dubecho,{|length = 1, fb = 0.8, sep = 0.012|
	var input;
	var output;
	var dry, wet;
	var sig;
	
	input = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	dry = input;
	input = SelectX.ar(\inmix.kr(0.0).lag(0.1), [DC.ar(0), input]);
	wet = Fb({

		arg feedback; // this will contain the delayed output from the Fb unit

		var left,right;
		var magic = LeakDC.ar(feedback*fb + input);
		magic = HPF.ar(magic, 400); // filter's on the feedback path
		magic = LPF.ar(magic, 5000);
		magic = magic.tanh; // and some more non-linearity in the form of distortion
		#left, right = magic; // let's have named variables for the left and right channels
		magic = [DelayC.ar(left, 1, LFNoise2.ar(12).range(0,sep)), DelayC.ar(right, 1, LFNoise2.ar(12).range(sep,0))]; // In addition to the main delay handled by the feedback quark, this adds separately modulated delays to the left and right channels, which with a small "sep" value creates a bit of spatialization

	},length);
	sig = ( dry*\drygain.kr(1) ) + ( wet*\wetgain.kr(1) );
	Out.ar(0, sig);
}).add;
)

~t = 145/4/60; TempoClock.default.tempo = ~t;

	(

		SynthDef(\drumfx, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 815027;

			thisThread.randSeed = 701027;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
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
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = (si * 10.rand * \distamp.kr).tanh / 2;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);

						].mean;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = [
							{ arg si, env;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);
							,
							{ arg si, env;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);

						].mean;
					}.value(si, env);

				].mean;
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
			sig = sig * \wetamp.kr(1);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

	);

(
	r = \r;
Pdef(\gdrums, 
	Ppar([
		Pmono(\drumfx,
			\inbus, BusDef(\fx1, \audio),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.4,
			\eqdb2b, 8,
			\eqdb2a, 8,
			'gain', 0.21015160133764,
			'fb', Pseq([
				0,0,0,0.0001,
				0,0,0,0.00001,
				0,0.08,0,0.00001,
				0,0,0,0.00001,
			],inf),
			'delay2', 0.00013111339374216,
			'delay', Pseq([
				Pser([
					0,0,0,0.008,
					0,0,0.00001,0.00008,
					0,0,0,0.008,
					0,0,0,0.8,
				],8*4),

				Pser([
					0,0,0,0.6,
					0.001,0,0,0.008,
					0,0.009,0.40001,0.00008,
					0,0,0,0.08,
				],8*4),
			],inf) + 0.000001,
			'delay2', Pseq([
				Pseq([
					0.00010306431405564,
					0.00000306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00010306431405564,
					0.00100306431405564,
					0.0001010306431405564,
				],2),
				Pseq([
					0.00000306431405564,
					0.00110306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00100306431405564,
					0.00010306431405564,
					0.0001010306431405564,
				],2),
			],inf),
			'distamp', Pseq([
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,10.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,

				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				100,0.1,1,1,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 92.923391195936,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.41176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		PmonoArtic(\dubecho,
			\legato, 1,
			\dur, 1/4,
			\fb, 0.7,
			\sep, 0.0012,
			\length, 1/4 /~t,
			\inmix, Pseq([
				0,0,1,0,
				0,1,0,0,
			],inf),
		),
		PmonoArtic(\dubecho,
			\inbus, BusDef(\fx2, \audio),
			\legato, 1,
			\dur, 1/4,
			\fb, 0.7,
			\sep, 0.0012,
			\length, 2/3 /~t,
			\inmix, Pseq([
				0,0,1,0,
				0,1,0,0,
				0,0,0,1,
				1,0,0,0,
			],inf),
		),

		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				0,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx2, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				3,\r,2,\r,
			],inf),
			\ctranspose, 0,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
				
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1
		),
		//Pbind(
		//	\out, BusDef(\fx2, \audio),
		//	\instrument, \fmgbass,
		//	\degree, Pseq([
		//		\r,\r, [2,5], \r,
		//	],inf)-2,
		//	\legato, Pseq([
		//		Pser([
		//			0.1,
		//		],3*4),
		//	],inf),
		//	\octave, 5,
		//	\dur, 1/8,
		//	\amp, 0.1/8
		//),
		//Pbind(
		//	\out, BusDef(\fx2, \audio),
		//	\instrument, \fmgbass2,
		//	\degree, Pseq([
		//		0,r,r,r,
		//		r,r,-1,r,
		//	],inf),
		//	\mtranspose, Pseq([
		//		1,-2,
		//	],inf).stutter(8),
		//	\legato, Pseq([
		//		Pser([
		//			4.1,
		//		],4),
		//		1,1,1,1,
		//	],inf),
		//	\fratio, 2,
		//	\octave, 4,
		//	\dur, 1/8,
		//	\amp, 0.1/8
		//),

		
	])
).play;
)

(
ProtoDef(\piano).startControl(Pdef(\piano,
	Pbind(
			\instrument, \fmgbass,
			\instrument, \default,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				3,\r,2,\r,
			],inf)+2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
				
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1
	)
))
)


(
SynthDef(\fmgbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq/2), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig/1.6;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * AmpComp.kr(freq, exp:0.9)/4;
	Out.ar(out, sig);
}).add;
SynthDef(\fmgbassm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq.lag(\freqlag.kr(0.1));
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.1,0.8])), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq/2), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.001 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig/1.6;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * AmpComp.kr(freq, exp:0.9)/4;
	Out.ar(out, sig);
}).add;
SynthDef(\fmgbass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,80,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(70), 0.1, freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*1) * 0.01 )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = HPF.ar(sig, 1800);
	sig = sig * 3;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * AmpComp.kr(freq, exp:0.9)/4;
	Out.ar(out, sig);
}).add;
);

(
	r = \r;
Pdef(\gdrums, 
	Ppar([
		Pmono(\drumfx,
			\inbus, BusDef(\fx1, \audio),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.4,
			\eqdb2b, 8,
			\eqdb2a, 8,
			'gain', 0.41015160133764,
			'fb', Pseq([
				0,0,0,0.0001,
				0,0,0,0.00001,
				0,0.08,0,0.00001,
				0,0,0,0.00001,
			],inf),
			'delay2', 0.00013111339374216,
			'delay', Pseq([
				Pser([
					0,0,0,0.008,
					0,0,0.00001,0.00008,
					0,0,0,0.008,
					0,0,0,0.8,
				],8*4),

				Pser([
					0,0,0,0.6,
					0.001,0,0,0.008,
					0,0.009,0.40001,0.00008,
					0,0,0,0.08,
				],8*4),
			],inf) + 0.000001,
			'delay2', Pseq([
				Pseq([
					0.00010306431405564,
					0.00000306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00010306431405564,
					0.00100306431405564,
					0.0001010306431405564,
				],2),
				Pseq([
					0.00000306431405564,
					0.00110306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00100306431405564,
					0.00010306431405564,
					0.0001010306431405564,
				],2),
			],inf),
			'distamp', Pseq([
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,10.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,

				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				100,0.1,1,1,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 92.923391195936,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.41176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		PmonoArtic(\dubecho,
			\legato, 1,
			\dur, 1/4,
			\fb, 0.7,
			\sep, 0.0012,
			\length, 1/4 /~t,
			\drygain, 0.4,
			\inmix, Pseq([
				0,0,1,0,
				0,1,0,0,
			],inf),
		),
		PmonoArtic(\dubecho,
			\inbus, BusDef(\fx2, \audio),
			\legato, 1,
			\dur, 1/4,
			\fb, 0.7,
			\sep, 0.0012,
			\length, 2/3 /~t,
			\inmix, Pseq([
				0,0,1,0,
				0,1,0,0,
				0,0,0,1,
				1,0,0,0,
			],inf),
		),

		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				0,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx2, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,1,1,0, 0,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PmonoArtic( \fmgbassm,
			\out, BusDef(\fx2, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-3,
			],inf),1/2),
			\fratio, Pseq([1/4,1/2,1,2],inf),
			\fratio, Pseq([1],inf),
			\ctranspose, 0,
			\env1, Pseq([
				[ Env([1,20,41],[0.1,0.8]) ]
			],inf),
			\legato, Pseq([
				1.9,
				1.9,
				1.9,
				0.9,
			],inf)*0.3,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1
		),
		//Pbind(
		//	\out, BusDef(\fx2, \audio),
		//	\instrument, \fmgbass,
		//	\degree, Pseq([
		//		\r,\r, [2,5], \r,
		//	],inf)-2,
		//	\legato, Pseq([
		//		Pser([
		//			0.1,
		//		],3*4),
		//	],inf),
		//	\octave, 5,
		//	\dur, 1/8,
		//	\amp, 0.1/8
		//),
		//Pbind(
		//	\out, BusDef(\fx2, \audio),
		//	\instrument, \fmgbass2,
		//	\degree, Pseq([
		//		0,r,r,r,
		//		r,r,-1,r,
		//	],inf),
		//	\mtranspose, Pseq([
		//		1,-2,
		//	],inf).stutter(8),
		//	\legato, Pseq([
		//		Pser([
		//			4.1,
		//		],4),
		//		1,1,1,1,
		//	],inf),
		//	\fratio, 2,
		//	\octave, 4,
		//	\dur, 1/8,
		//	\amp, 0.1/8
		//),

		
	])
).play;
)
