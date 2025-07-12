FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");
(
SynthDef(\sibass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\leadz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.02);
	sig = LFSaw.ar(freq * [1,1.001,2,1/2] * ( 1 + ( SinOsc.ar(freq * [1,2,3]) * 1 ))).mean*2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 400);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\leadz2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.02) * 4;
	sig = LFPulse.ar(freq * [1,1.001,2,1/2] * ( 1 + ( SinOsc.ar(freq * 1/[1,2,3]) * 1 ))).mean*2;
	sig = BPF.ar(sig, freq*1,0.1) + sig;
	sig = HPF.ar(sig, freq*1/4);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\stick, { |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0.9, 0.9, 0.9, 0.7, 0, 0.7, 0],
            [0.001, 0.001, 0, 0.008, 0, 0.01, 0, 0.01],
            [0, 0, 0, 00, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 7000, 0.03)/2);
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = SinOsc.ar(freq * [1,1.0001]);
	sig = sig.tanh;
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
	SynthDef(\rdnfx, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 


		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;

		sig = { arg si, env;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr * LFSaw.kr(0.4).range(1,2)) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr * Amplitude.kr(si)/10) + si;
			//si = AllpassC.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr, 0.01) + si;

			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay.kr) + si;
			//si = BRF.ar(si, 7000 * SinOsc.kr(2*~t).range(2,1), 0.4) + ( si / 4 );
			//si = BPF.ar(si, exprand(100,16000), 0.5.rand + 0.01) + ( si / 4 );
			//si = FreqShift.ar(si, 0.001) + sig;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = (si * 10.rand * \distamp.kr).tanh / 2;
			//si = [
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
					//si = (si * 10.rand * \distamp.kr).tanh / 2;
				//}.value(si, env);
				//,
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
				//}.value(si, env);

			//].mean;
			si = DelayL.ar(si, 0.8,  \delay1.kr) + si;
			si = DelayL.ar(si, 0.8,  \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8,  \delay3.kr) + si;
					si = DelayL.ar(si, 0.8, \delay4.kr) + si;
					si = (si * 1 * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8,   \delay5.kr) + si;
					si = DelayL.ar(si, 0.8,   \delay6.kr) + si;
					si = FreqShift.ar(si, 1) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8,  \delay7.kr) + si;
			si = DelayL.ar(si, 0.8,  \delay8.kr) + si;
			si = LeakDC.ar(si);
			si = MidEQ.ar(si, \eqmid1.kr(12000), \eqrq1.kr(1), \eqdb1.kr(1));
			si = MidEQ.ar(si, \eqmid2.kr(7000), \eqrq2.kr(1), \eqdb2.kr(1));
		}.value(si, env);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(1));
		sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(1));
		sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		sig;
		Out.ar(out, sig);

	}).add;

);

~t = 185/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\chord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1/2,1,1/2,1.0001]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\rdndrums, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
				[ 0.00086844078036751, 0.00027572244550975, 0.00060387408080565, 0.00064495210183222 ]
			],inf).stutter(8),
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//				exprand(0.00001,0.008!4).asCompileString.editorInsert(false)
				[ 0.0033127010079837, 0.0018962804466777, 0.0014975064715848, 8.7199981151866e-05 ],
				[ 0.0033127010079837, 0.0038962804466777, 0.0054975064715848, 8.7199981151866e-05 ],
				//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)*1 * Pseq([1,1,1,1/8],inf),
			\mideq1b, 100,
			\middb1b, -94,
			\mideq2b, 110,
			\middb2b, -94,
			\midrq2b, 0.4,
			\ehpf, 150,
			\gain, 0.4,
			\distamp, Pseq([
				1,10,10,10,
				100,100,1,1,
			],inf),
			\fb, Pseq([
				0.01, 0.01,0.02,0.04,
				0.01, 0.01,0.1,0.1,
			],inf),
			\dur, 1/4,
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\fx2, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
				[ 0.0010934792433603, 3.6772602228283e-05, 0.00059252833428699, 0.007612796284198 ]
			],inf).stutter(8),
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//				exprand(0.00001,0.008!4).asCompileString.editorInsert(false)
				[ 0.0004953161768388, 3.2359682764214e-05, 1.4364910591105e-05, 3.2158973656053e-05 ],
				[ 0.00049008475438402, 9.6585073207509e-05, 0.0011638308203766, 0.00039246305281146 ],
			],inf).stutter(1)*1 ,
			\mideq1b, 100,
			\middb1b, -94,
			\mideq2b, 110,
			\middb2b, -94,
			\midrq2b, 0.4,
			\ehpf, 200,
			\gain, 0.4,
			\distamp, Pseq([
				0,0,0,0,
				1,1,1,10,
			],inf),
			\fb, Pseq([
				0.01, 0.01,0.02,0.01,
			],inf),
			\dur, 1/2,
		),
		Pbind(
			\instrument, \chord,
			\out, BusDef(\fx2, \audio),
			\octave, 6,
			\degree, Pseq([
				\r,\r,\r,\r,
				[0,2,4],
				[0,2,4],
				[0,2,4],
				[-1,2,4],
			],inf),
			\legato, Pseq([
				0.3,0.3,0.3,0.9,
			],inf),
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
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
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
).play;
)


///////////////////////////////////////////////


(
SynthDef(\rdnfx, { arg out=0, gate=1;
	var sig;
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 


	sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
	si = sig;

	sig = { arg si, env;
		si = DelayL.ar(si, 0.8,  \delay1.kr) + si;
		si = DelayL.ar(si, 0.8,  \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8,  \delay3.kr) + si;
				si = DelayL.ar(si, 0.8, \delay4.kr) + si;
				si = (si * 1 * \distamp.kr).tanh / 2;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8,   \delay5.kr) + si;
				si = DelayL.ar(si, 0.8,   \delay6.kr) + si;
				si = FreqShift.ar(si, \shift1.kr(1)) + si;
			}.value(si, env);

		].mean;
		si = DelayL.ar(si, 0.8,  \delay7.kr) + si;
		si = DelayL.ar(si, 0.8,  \delay8.kr) + si;
		si = LeakDC.ar(si);
		si = MidEQ.ar(si, \eqmid1.kr(12000), \eqrq1.kr(1), \eqdb1.kr(1));
		si = MidEQ.ar(si, \eqmid2.kr(7000), \eqrq2.kr(1), \eqdb2.kr(1));
	}.value(si, env);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);

	sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(1));
	sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(1));
	sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
	sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
	sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
	sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
	sig;
	Out.ar(out, sig);

}).add;

);

(
SynthDef(\chord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1/2,1,1/2,1.0001]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\rdndrums, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
				[ 0.00086844078036751, 0.00027572244550975, 0.00060387408080565, 0.00064495210183222 ]
			],inf).stutter(8)*0.001,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.00001,0.008!4).asCompileString.editorInsert(false)
				[ 3.238652694767e-05, 0.00080209852492222, 0.0041152555585199, 0.00093911567881822 ],
				[ 1.238652694767e-05, 0.00080209852492222, 0.0041152555585199, 0.00093911567881822 ]
				//[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)*0.001,
			//\mideq1b, 100,
			//\middb1b, -4,
			//\mideq2b, 110,
			//\middb2b, -4,
			//\midrq2b, 0.4,
			\shift1, 0,
			\ehpf, 150,
			\gain, 0.4,
			\distamp, Pseq([
				1, 1, 1, 1,
			],inf),
			\fb, Pseq([
				0.001,
				0.001,
				0.001,
				0.1,
			],inf),
			\dur, 1/4,
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\fx2, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
				[ 0.00086844078036751, 0.00027572244550975, 0.00060387408080565, 0.00064495210183222 ]
			],inf).stutter(8)*0.001,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.00001,0.008!4).asCompileString.editorInsert(false)
				[ 3.238652694767e-05, 0.00080209852492222, 0.0041152555585199, 0.00093911567881822 ],
				[ 1.238652694767e-05, 0.00080209852492222, 0.0041152555585199, 0.00093911567881822 ]
				//[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)*0.001,
			//\mideq1b, 100,
			//\middb1b, -4,
			//\mideq2b, 110,
			//\middb2b, -4,
			//\midrq2b, 0.4,
			\shift1, 0,
			\ehpf, 150,
			\gain, 0.4,
			\distamp, Pseq([
				10,
			],inf),
			\fb, Pseq([
				0.001,
				0.001,
				0.001,
				0.1,
			],inf),
			\dur, 1/4,
		),
		//Pbind(
		//\instrument, \chord,
		//\out, BusDef(\fx2, \audio),
		//\octave, 6,
		//\degree, Pseq([
		//\r,\r,\r,\r,
		//[0,2,4],
		//[0,2,4],
		//[0,2,4],
		//[-1,2,4],
		//],inf),
		//\legato, Pseq([
		//0.3,0.3,0.3,0.9,
		//],inf),
		//\dur, 1/8,
		//\amp, 0.1
		//),
		Pbind(
			\instrument, \noisybass,
			\degree, Pseq([
				Pseq([
					-3,-5,-3,r, 0,r,r,-3,
					0,-3,0,r, r,r,r,-3,
				],2),
				Pseq([
					-2,-4,-2,r, 1,r,r,-2,
					1,-2,1,r, r,r,r,-3,
				],1),
				Pseq([
					-3,-5,-3,r, 0,r,r,-3,
					0,-3,0,r, r,r,r,-3,
				],1),
			],inf),
			\legato, Pseq([
				Pseq([ 2,4,2,1, ]/4,1), 3,1,1,1,
				1/2,1/2,1.52,1, 3,1,1,1,
			],inf)* 0.9,
			\ctranspose, 7,
			\octave, 3,
			\out, BusDef(\fx2, \audio),
			\dur, 1/8,
			\amp, 0.1/1,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
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
			//\out, BusDef(\fx1, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
).play;
)

(
Pdef(\rdndrums, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0005401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*0.001,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.0441197696501e-05 ],
[ 3.5570711069596e-05, 3.6235910654473e-06, 0.00019782771588895, 8.3991937311564e-05 ]
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.001,
			\eqmid1, 1400,
			\eqdb1, -2,
			//\eqmid2, 1200,
			//\eqdb2, -1,
			//\mideq2b, 110,
			//\middb2b, -4,
			//\midrq2b, 0.4,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.4,
			\distamp, Pseq([
				100, 1, 1, 1,
				4,4,4,4,
				1, 11, 1, 1,
				1,8,1,8,
			],inf),
			\fb, Pseq([
				0.01, 0.01, 0.01, 0.1,
				0.01, 0.01, 0.01, 0.1,
				0.01, 0.01, 0.01, 0.1,
				0.01, 0.08, 0.01, 0.1,
			],inf),
			//\fb, 0.00002,
			//\distamp, 2320,
			\dur, 1/4,
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\fx2, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.0441197696501e-05 ],
			],inf).stutter(8)*1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.2054940775634e-05, 0.0005401416398709, 0.00017010472041281, 0.00017933153253039 ],
[ 3.5570711069596e-05, 3.6235910654473e-06, 0.00019782771588895, 8.3991937311564e-05 ]
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*1,
			\eqmid1, 1400,
			\eqdb1, -2,
			//\eqmid2, 1200,
			//\eqdb2, -1,
			//\mideq2b, 110,
			//\middb2b, -4,
			//\midrq2b, 0.4,
			\shift, 0,
			\ehpf, 150,
			\gain, 0.4,
			\distamp, Pseq([
				100, 1, 1, 1,
				4,4,4,4,
			],inf),
			\fb, 0.001,
			\distamp, 10,
			\gain, 0.1,
			\dur, 1/4,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
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
		Pbind(
			\instrument, \stick,
				\out, BusDef(\fx2),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 0,0,0,0,
			].rotate(1),inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			//\out, BusDef(\fx1, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
).play;
)

///////////////////////////////////////////////////////////////


(
	SynthDef(\rdnfx, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 


		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;

		sig = { arg si, env;
			si = DelayL.ar(si, 0.8,  \delay1.kr) + si;
			si = DelayL.ar(si, 0.8,  \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8,  \delay3.kr) + si;
					si = DelayL.ar(si, 0.8, \delay4.kr) + si;
					si = (si * 1 * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8,   \delay5.kr) + si;
					si = DelayL.ar(si, 0.8,   \delay6.kr) + si;
					si = FreqShift.ar(si, \shift1.kr(1)) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8,  \delay7.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8,  \delay9.kr) + si;
					si = DelayL.ar(si, 0.8, \delay10.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = (si * 10 * \distamp2.kr(1)).distort / 2;
					si = DelayL.ar(si, 0.8,   \delay11.kr) + si;
					si = DelayL.ar(si, 0.8,   \delay12.kr) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8,  \delay8.kr(1).lag(\delay8lag.kr(0))) + si;
			si = LeakDC.ar(si);
			si = MidEQ.ar(si, \eqmid1.kr(12000), \eqrq1.kr(1), \eqdb1.kr(1));
			si = MidEQ.ar(si, \eqmid2.kr(7000), \eqrq2.kr(1), \eqdb2.kr(1));
		}.value(si, env);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(1));
		sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(1));
		sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		sig;
		Out.ar(out, sig);

	}).add;

);

(
Pdef(\rdndrums, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0005401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*0.001,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.0441197696501e-05 ],
[ 3.5570711069596e-05, 3.6235910654473e-06, 0.00019782771588895, 8.3991937311564e-05 ]
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.001,
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.001,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 50,
			\gain, 0.4,
			\distamp, Pseq([
				10, 1, 1, 1,
				10, 1, 1, 1,
				1, 11, 1, 1,
				4,4,4,4,
			],inf)/2,
			\fb, Pseq([
				0.01, 0.01, 0.01, 0.1,
				0.01, 0.01, 0.01, 0.1,
				0.01, 0.01, 0.01, 0.1,
				0.01, 0.08, 0.01, 0.1,
			],inf)/10,
			//\fb, 0.00002,
			//\distamp, 2320,
			\dur, 1/4,
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\fx2, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.0441197696501e-05 ],
			],inf).stutter(8)*1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.2054940775634e-05, 0.0005401416398709, 0.00017010472041281, 0.00017933153253039 ],
[ 3.5570711069596e-05, 3.6235910654473e-06, 0.00019782771588895, 8.3991937311564e-05 ]
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.01,
			\eqmid1, 1400,
			\eqdb1, -2,
			//\eqmid2, 1200,
			//\eqdb2, -1,
			//\mideq2b, 110,
			//\middb2b, -4,
			//\midrq2b, 0.4,
			\shift, 0,
			\ehpf, 150,
			\gain, 0.4,
			\distamp, Pseq([
				100, 1, 1, 1,
				4,4,4,4,
			],inf),
			\fb, 0.001,
			\distamp, 1,
			\gain, 0.1,
			\dur, 1/4,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
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
		Pbind(
			\instrument, \stick,
				\out, BusDef(\fx2),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,0,1,
				1,0,1,0, 1,0,1,1,
				1,1,1,1, 0,0,0,0,
			].rotate(1),inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			//\out, BusDef(\fx1, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
).play;
)

(
Pdef(\rdndrums, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)*1,
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\shift, 0,
			\ehpf, 50,
			\gain, 0.4,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.0001,
			\distamp, Pseq([
				0.01, 0.01,
				100, 100,
			],inf),
			\distamp2, 2/100,
			\dur, 1/4,
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\fx2, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.0441197696501e-05 ],
			],inf).stutter(8)*1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.2054940775634e-05, 0.0005401416398709, 0.00017010472041281, 0.00017933153253039 ],
[ 3.5570711069596e-05, 3.6235910654473e-06, 0.00019782771588895, 8.3991937311564e-05 ]
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.01,
			\eqmid1, 1400,
			\eqdb1, -2,
			//\eqmid2, 1200,
			//\eqdb2, -1,
			//\mideq2b, 110,
			//\middb2b, -4,
			//\midrq2b, 0.4,
			\shift, 0,
			\ehpf, 150,
			\gain, 0.4,
			\distamp, Pseq([
				100, 1, 1, 1,
				4,4,4,4,
			],inf),
			\fb, 0.001,
			\distamp, 1,
			\gain, 0.1,
			\dur, 1/4,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \stick,
				\out, BusDef(\fx2),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			].rotate(1),inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			//\out, BusDef(\fx1, \audio),
			\kitIndex, 8,
			\isRest, Pseq({[
				0
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
	])
).play;
)


///////////////////////////////////////


(
Pdef(\drumz, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* Pseq([0.001,100],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.001,
			\shift, 100,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 2/1,
			\dur, 1/8,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.4,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4 * Pseq([1,2],inf),
			\gain, 0.8,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.99,
			\gain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.9,
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
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
Pdef(\drumz, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* Pseq([0.001,100],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.001,
			\shift, 100,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 2/1,
			\dur, 1/8,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.99,
			\gain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.9,
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1
		),
		PmonoArtic(\leadz2,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PatKitDef(\sample1).asPattern(Pbind(
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
Pdef(\drumz, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*10000.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* 10000,
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*10001.00001,
			\distamp, 0.1,
			\eqmid1, 100,
			\eqdb1, 1,
			\eqmid2, 14000,
			\eqdb2, -1,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.00001,
			\shift1, 0,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				0.01, 0.01, 0.01, 0.01,
			],inf) * 100,
			\distamp, 1/1,
			\dur, 1/8,
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\fx2, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* Pseq([0.001,100],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.1,
			\shift1, 0,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 2/1,
			\dur, 1/8,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\out, BusDef(\fx2, \audio),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.99,
			\gain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.9,
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1
		),
		PmonoArtic(\leadz2,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PatKitDef(\sample1).asPattern(Pbind(
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


////////////////////////////////////////


(
Pdef(\drumz, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1/10000.00001,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)*300,
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*00000.00001,
			\distamp, 0.1,
			\eqmid1, Pseq([1400,3000],inf),
			\eqdb1, 2,
			\eqmid2, 5400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.4,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.00011,
			\shift1, Pseg(Pseq([100,1,0],inf),8) * -1,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 200/1,
			\distamp2, 200/1,
			\mix, 1,
			\dur, 1/8,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 0,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,0,
				],4),
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],2),
				Pseq([
					0,1,0,0, 1,0,0,0,
					0,0,1,0, 1,0,0,1,
				],2),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
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
			\lag, 0.04,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\lag, 0.04,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1 * Pseq([1,10],inf).stutter(8),
			\dur, 1/8,
			\amp, 0.1,
		)),

		
	])
).play;
)

(
Pdef(\drumz, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1/1.00001,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)*1 * Pseq([100000,10000,2,10003],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*00000.01,
			\distamp, 0.1,
			\eqmid1, Pseq([1400,3000],inf),
			\eqdb1, 2,
			\eqmid2, 5400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.4,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.00011,
			\shift1, Pseg(Pseq([100,1,0],inf),8) * -1,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 20/1,
			\distamp2, 2/1,
			\mix, 1,
			\dur, 1/8,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 0,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,1,0, 0,1,0,0,
				],4),
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\out, BusDef(\fx1, \audio),
			\kitIndex, 4,
			\isRest, Pseq({[
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],2),
				Pseq([
					0,1,0,0, 1,0,0,0,
					0,0,1,0, 1,0,0,1,
				],2),
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
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
			\lag, 0.04,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\lag, 0.04,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1 * Pseq([1,10],inf).stutter(8),
			\dur, 1/8,
			\amp, 0.1,
		)),

		
	])
).play;
)

///////////////
///////////////
///////////////
///////////////

(
Pdef(\calmdrumz, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* Pseq([0.001,100],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.001,
			\shift, 100,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 2/1,
			\dur, 1/8,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.4,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4 * Pseq([1,2],inf),
			\gain, 0.8,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.99,
			\gain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
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
);
)

(
Pdef(\drumz, Ppar([
	Pdef(\calmdrumz),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.9,
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1
		),
		PmonoArtic(\leadz2,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
])).play
)

(
Pdef(\drumz, Ppar([
	Pdef(\calmdrumz),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.4,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\legato, Pseq([
				Pseq([
					0,0,0,0,
				],4),
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1
		),
		PmonoArtic(\leadz2,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
]))
)

(
Pdef(\drumz, Ppar([
	Pdef(\calmdrumz),
		PmonoArtic(\leadz,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\legato, Pseq([
				Pseq([
					0,0,0,0,
				],4),
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		PmonoArtic(\leadz2,
			\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/8,
		),
])).play;
)

(
Pdef(\drumz, Ppar([
	Pdef(\calmdrumz),
		Pmono( \rdnfx,
			\inbus, BusDef(\fx3, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*10000.0001,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1) * 100000.0001,
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.00001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\ehpf, 150,
			\gain, 0.3,
			\fb, 0.00005,
			\shift1, 0,
			\distamp, 20/1,
			\distamp, 20/1,
			\dur, 1/8,
		),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, 0.9,
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.1/8,
		),
])).play;
)

(
SynthDef(\drony, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(100.0,10000) }!20 * ( 1 + ( SinOsc.kr((1..4).rand(0.0)/18) * 1/41 )));
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = BRF.ar(sig, { ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,1);
	sig = LPF.ar(sig, \lpf.kr(10000).lag(1));
	sig = HPF.ar(sig, \hpf.kr(10000).lag(1));
	sig = LeakDC.ar(sig) * 5;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)
