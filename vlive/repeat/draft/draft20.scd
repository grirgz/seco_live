
	~rdn_to_fbstring.(RandDelayNetwork(\deldefault)).editorInsert;

////////////////
p
RandDelayNetwork(\deldefault).make(\fx1, "4--", BusDef(\fx1)).edit

ProtoDef(\rdn).edit


	~rdn_to_fbstring.(RandDelayNetwork(\deldefault)).editorInsert
	(

		SynthDef(\rdnfx2, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 1345150;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = [
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);
							si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
							si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							si = [
								{ arg si, env;
									si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
									si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
								}.value(si, env);
								,
								{ arg si, env;
									si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
									si = (si * 10.rand * \distamp.kr).tanh / 2;
								}.value(si, env);

							].mean;

						].mean;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
								si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
							}.value(si, env);

						].mean;
					}.value(si, env)
					

				].mean;
				si = { arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
				}.value(si, env);
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

	);

	(

		SynthDef(\rdnfx, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
			var fb = \fb.kr(0.1);

			thisThread.randSeed = 1345451;

			fb = fb * LagUD.kr( ( ( Amplitude.kr(in)*\fbingain.kr(8) )**2 ), 0,\fblag.kr(0.4) ) + \fbbias.kr(0.004);
			sig = LocalIn.ar(2) * fb + in;
			si = sig;
			sig = { arg si, env;
				si = [
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
								si = (si * 10.rand * \distamp.kr).tanh / 2;
							}.value(si, env);

						].mean;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = (si * 10.rand * \distamp.kr).tanh / 2;
							}.value(si, env);

						].mean;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
								si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
							}.value(si, env);

						].mean;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
						si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
					}.value(si, env);

				].mean;
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
			Out.ar(out, sig);

		}).add;

	);



	(
		// test ndef RDN
	Pdef(\drumz, 
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx1),
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
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			
		])
	).play;
	)


	Pdef(\kit_workspace, Pdef(\drumz));
	(
	Pdef(\drumz, 
		Ppar([
			PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.110017,
				\delay, 0.20001,
				\delay2, 0.000001 * Pseg(Pseq([20000,1],inf),8),
				\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
				\delay, ~pmodenv.(Pseq([0.000001,0.7],inf), 8),
				\legato, Pseq([
					//1,1,1,0.9,
					1
				],inf),
				\shift, 0.0000,
				\shift2, 0.0000,
				\shift, ~pmodenv.(Pseq([
					0,0,0,0,
					0,0,0,0,
					0,0,0,0,
					0.0000,2,0.01,40,
				].rotate(0),inf), 1),
				\mix, 0.51,
				\mix, 0.5,
				\gain, 1/2,
				\distamp, 1.1,
			),
			PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx2, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.010017,
				\delay, 0.00001,
				\delay2, 0.001001,
				\legato, Pseq([
					//1,1,1,0.9,
					1
				],inf),
				\shift, 0.0001,
				\shift2, 0.0001,
				\mix, 0.51,
				\mix, 1,
				\gain, 1/8,
				\distamp, 40.1,
			),
			Pbind(
				\instrument, \sibass,
				\out, BusDef(\fx2),
				\degree, Pseq([0,0,0,2],inf),
				\octave, 3,
				\dur, 1,
				\amp, 0.1
			),
			Pbind(
				\instrument, \sibass,
				\out, BusDef(\fx2),
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],4),
					0,1,0,0, 1,1,1,1,
					1,0,1,0, 1,1,1,1,
					1,1,1,0, 0,1,1,1,
					1,0,1,1, 0,0,1,1,
				],inf).coin.not,
				\legato, Pseq([0.1,1.6,0.2,0.2, 0.2,0.4,1,0.2, 0.2],inf),
				\note, Pseq((1..8).reverse.mirror*3,inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx2),
				\isRest, Pseq({[
					1,0,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.4,
				\speed, 1.1,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx1),
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
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\out, BusDef(\fx1),
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
SynthDef(\sibass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq, \rq.kr(0.5));
	sig = HPF.ar(sig, 70);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\silead, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.01,0.8])), 1);
	sig = LFSaw.ar(freq + [ [0,0.0001] ] * [1,1/2,2]).sum;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


	(
	Pdef(\drumz, 
		Ppar([
			PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.010017,
				\delay, 0.00011,
				\delay2, 0.4000001,
				//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
				//\delay, ~pmodenv.(Pseq([0.000001,0.7],inf), 8),
				\legato, Pseq([
					//1,1,1,0.9,
					1
				],inf),
				\shift, 0.0000,
				\shift2, 0.0000,
				\shift, ~pmodenv.(Pseq([
					0,0,0,0,
					0,0,0,0,
					0,0,0,0,
					0.0000,2,0.01,40,
				].rotate(0),inf), 1),
				\mix, 0.51,
				\mix, 0.5,
				\gain, 1/3,
				\distamp, 10.1,
			),
			PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx2, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.010017,
				\delay, 0.00001,
				\delay2, 0.001001,
				\legato, Pseq([
					//1,1,1,0.9,
					1
				],inf),
				\shift, 0.0001,
				\shift2, 0.0001,
				\mix, 0.51,
				\mix, 1,
				\gain, 1/8,
				\distamp, 40.1,
			),
			Pbind(
				\instrument, \sibass,
				\out, BusDef(\fx2),
				\degree, Pseq([0,0,0,2],inf),
				\octave, 3,
				\dur, 1,
				\amp, 0.1
			),
			Pbind(
				\instrument, \sibass,
				\out, BusDef(\fx2),
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],4),
					0,1,0,0, 1,1,1,1,
					1,0,1,0, 1,1,1,1,
					1,1,1,0, 0,1,1,1,
					1,0,1,1, 0,0,1,1,
				],inf).coin.not,
				\legato, Pseq([0.1,1.6,0.2,0.2, 0.2,0.4,1,0.2, 0.2],inf),
				\note, Pseq((1..5).reverse.mirror*3,inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx2),
				\isRest, Pseq({[
					1,0,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.4,
				\speed, 1.1,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx1),
				\isRest, Pseq([
					1,0,0,0, 0,1,0,1,
					0,1,0,0, 0,1,0,1,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.1,0.2],inf).stutter(8),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\out, BusDef(\fx1),
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
			PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.010017,
				\delay, 0.00011,
				\delay2, 0.4000001,
				\distamp, 10.1,
				//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
				\delay, ~pmodenv.(Pseq([0.000001,0.000001,0.00017],inf), Pseq([2,2,0],inf)),
				\delay2, ~pmodenv.(Pseq([0.000001,0.000001,0.017],inf), Pseq([2,2,0],inf)),
				\fb, ~pmodenv.(Pseq([0.000001,0.000001,0.02],inf), Pseq([2,2,0],inf)),
				\distamp, ~pmodenv.(Pseq([1.000001,1.000001,100.02],inf), Pseq([2,2,0],inf)),
				\legato, Pseq([
					1,1,1,0.9,
				],inf),
				\shift, 0.0000,
				\shift2, 0.0000,
				\shift, ~pmodenv.(Pseq([
					0,0,0,0,
					0.0000,0.002,-0.001,0.001,
					0,0,0,0,
					0.0000,-0.2,0.01,40,
				].rotate(0),inf), 1),
				\mix, 0.51,
				\mix, 0.5,
				\gain, 1/3,
			),
			PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx2, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.000017,
				\delay, 0.10001,
				\delay2, 0.001001,
				\legato, Pseq([
					1,1,1,0.9,
				],inf),
				\shift, 0.0001,
				\shift2, 0.0001,
				\mix, 0.51,
				\mix, 1,
				\gain, 1/4/1,
				\distamp, 140.1,
			),
			Pbind(
				\instrument, \sibass,
				\out, BusDef(\fx1),
				\degree, Pseq([0,0,0,2],inf),
				\octave, 3,
				\dur, 1,
				\amp, 0.1
			),
			Pbind(
				\instrument, \silead,
				\out, BusDef(\fx2),
				\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), 8),
				\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,inf), 7),
				\note, Pseq([
					Pseq([
						\r,\r,\r,\r, 7,6,2,3,
					],2),
					Pseq([
						\r,\r,7,\r, 7,\r,2,3,
						\r,3,\r,\r, 7,6,2,3,
					],1),
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.071
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx2),
				\isRest, Pseq({[
					1,0,0,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.4,
				\speed, 1.1,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx1),
				\isRest, Pseq([
					1,0,0,0, 0,1,0,1,
					0,1,0,0, 0,1,0,1,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, Pseq([0.1,0.2],inf).stutter(8),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\out, BusDef(\fx1),
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
			PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.000017,
				\delay, 0.00011,
				\delay2, 0.0000001,
				\distamp, 10.1,
				//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
				\delay, ~pmodenv.(Pseq([0.000001,0.000001,0.00017],inf), Pseq([6,2,0],inf)),
				\delay2, ~pmodenv.(Pseq([0.000001,0.000001,0.017],inf), Pseq([6,2,0],inf)),
				\fb, ~pmodenv.(Pseq([0.000001,0.000001,0.02],inf), Pseq([6,2,0],inf)),
				\distamp, ~pmodenv.(Pseq([1.000001,10.000001,100.02],inf), Pseq([6,2,0],inf)),
				\distamp, Pseq([10,1,30,80],inf),
				\legato, Pseq([
					1,1,1,0.9,
				],inf),
				\shift, 0.0000,
				\shift2, 0.0000,
				\shift, ~pmodenv.(Pseq([
					0,0,0,0,
					0.0000,0.002,-0.001,0.001,
					0,0,0,0,
					0.0000,-0.2,0.01,40,
				].rotate(0),inf), 1),
				\mix, 0.51,
				\mix, 0.5,
				\eqmid1b, 600,
				\eqdb1b, 4,
				\gain, 1/3,
			),
			PmonoArtic( \rdnfx2,
				\inbus, BusDef(\fx2, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.000017,
				\delay, 0.00001,
				\delay2, 0.001001,
				\legato, Pseq([
					1,1,1,0.9,
				],inf),
				\shift, 0.0001,
				\shift2, 0.0001,
				\mix, 0.51,
				\mix, 1,
				\gain, 1/4/1,
				\distamp, 140.1,
			),
			Pbind(
				\instrument, \silead,
				\out, BusDef(\fx2),
				\env1, Pseq([
					Pseq([
						[ Env([1,2,1],[0.01,0.8]) ],
						[ Env([1,2,1],[0.1,0.8]) ],
					],8),
					Pseq([
						[ Env([1,2,1],[0.01,0.8]) ],
						[ Env([1,2,1],[0.01,0.2]) ],
					],4),
					Pseq([
						[ Env([1,2,1],[0.01,0.6]) ],
						[ Env([1,2,1],[0.1,0.8]) ],
						[ Env([1,2,1],[0.01,0.8]) ],
					],8),
				],inf),
				\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), 8),
				\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,inf), 7),
				\note, Pseq([
					Pseq([
						[2-12, 5, 10],
						[5, 10, 2-12],
						\r,
						[10-12, 5, 10],

						\r,
						[5, 10, 2-12],
						Prand([ \r, [5, 10], ],1),
						[5-12, 5, 10],

						Prand([ \r, [5, 10, 2-12], ],1),
						[5, 10],
						\r,
						\r
					],1),
					[1+12, 7], \r,\r,\r,
				],inf),
				\octave, 6,
				\legato, Pseq([
					Pser([
						0.2,0.7,
					],12),
					Pser([
						2,1,1,1,
					],4),
				],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
				\dur, 1/8,
				\amp, 0.011,
			),
			Pbind(
				\instrument, \sibass,
				\out, BusDef(\fx1),
				\lpfr, 3,
				//\lag, 0.04,
				\rq, 0.3,
				\note, Pseq([
					Pseq([
						[5],
						[10],
						\r,
						[10],

						Prand([\r, \r, [2], [5]],1),
						[10],
						Prand([ \r, [2], ],1),
						[10],

						Prand([ \r, [2], ],1),
						[5],
						\r,
						Prand([ \r, [2], ],1),
					],1),
					\r, \r,\r,1,
				],inf),
				\octave, 2,
				\legato, Pseq([
					Pser([
						0.2,0.7,
					],12)*2,
					Pser([
						2,1,1/2,1/2,
					],4),
				],inf),
				\dur, 1/8,
				\amp, 0.271
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\out, BusDef(\fx1),
				\isRest, Pseq({[
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq([
					0,0,0,0, 0,0.51,0,0.81,
					0,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\gain, 1/2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx1),
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
				\kitIndex, 4,
				\out, BusDef(\fx1),
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			
		])
	).play;
	)

////////////////////////////////////


Smoove - I'm A Man
- intro
	- strange sound in the mid with reverb
	- par
		- pitcher fall
		- start bass
	- start hats
	- intro voice
- main intro
	- par
		- pitcher fall
		- start beat
		- start chords
	- piano solo
	- beat + chords
	- piano solo, cut bass
	- beat + chords
	- piano solo, cut bass
	- par
		- only beat
		- pitcher rise
- part 1
	- break
		- descending heavy chords
		- simple descending bass
	- beats + chords
	- break
		- descending heavy chords
		- simple descending bass
	- start voice + main chorus
	- break
		- descending heavy chords
		- simple descending bass
	- beats + chords
	- break
		- descending heavy chords
		- simple descending bass

- break
	- bare beat
	- strange sound with echo (shout)
- break 2
	- bare beat
	- strange chords with reverb
- breaking break
	par
		- single chord at start
		- cut all
		- voice
	- strange chords with reverb
- part 2
	- only beats
	- some voice
- return
	- bass + hats
- break
	- descending heavy chords
	- simple descending bass


ProtoDef(\piano).startControl(Pdef(\piano,Pbind()))

(

	Pdef(\message_part1,
		Pfindur(16,
			Ppar([
				PmonoArtic( \rdnfx,
					\inbus, BusDef(\fx1, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00011,
					\delay2, 0.0000001,
					\distamp, 10.1,
					//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
					\delay, ~pmodenv.(Pseq([0.000001,0.000001,0.00017],inf), Pseq([6,2,0],3)),
					\delay2, ~pmodenv.(Pseq([0.000001,0.000001,0.017],inf), Pseq([6,2,0],3)),
					\fb, ~pmodenv.(Pseq([0.000001,0.000001,0.02],inf), Pseq([6,2,0],3)),
					\distamp, ~pmodenv.(Pseq([1.000001,10.000001,100.02],inf), Pseq([6,2,0],3)),
					\distamp, Pseq([10,1,30,80],inf),
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0000,
					\shift2, 0.0000,
					\shift, ~pmodenv.(Pseq([
						0,0,0,0,
						0.0000,0.002,-0.001,0.001,
						0,0,0,0,
						0.0000,-0.2,0.01,4,
					].rotate(0),2), 1),
					\mix, 0.51,
					\mix, 0.5,
					\eqmid1b, 600,
					\eqdb1b, 4,
					\gain, 1/3,
				),
				PmonoArtic( \rdnfx2,
					\inbus, BusDef(\fx2, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00001,
					\delay2, 0.001001,
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0001,
					\shift2, 0.0001,
					\mix, 0.51,
					\mix, 1,
					\gain, 1/4/1,
					\distamp, 140.1,
				),
				Pseq([
					Rest(8),
					Pbind(
						\instrument, \silead,
						\out, BusDef(\fx2),
						\env1, Pseq([
							Pseq([
								[ Env([1,2,1],[0.01,0.8]) ],
								[ Env([1,2,1],[0.1,0.8]) ],
							],8),
							Pseq([
								[ Env([1,2,1],[0.01,0.8]) ],
								[ Env([1,2,1],[0.01,0.2]) ],
							],4),
							Pseq([
								[ Env([1,2,1],[0.01,0.6]) ],
								[ Env([1,2,1],[0.1,0.8]) ],
								[ Env([1,2,1],[0.01,0.8]) ],
							],8),
						],inf),
						\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,1), 8),
						\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,1), 7),
						\note, Pseq([
							Pseq([
								[2-12, 5, 10],
								[5, 10, 2-12],
								\r,
								[10-12, 5, 10],

								\r,
								[5, 10, 2-12],
								Prand([ \r, [5, 10], ],1),
								[5-12, 5, 10],

								Prand([ \r, [5, 10, 2-12], ],1),
								[5, 10],
								\r,
								\r
							],1),
							[1+12, 7], \r,\r,\r,
						],inf),
						\octave, 6,
						\legato, Pseq([
							Pser([
								0.2,0.7,
							],12),
							Pser([
								2,1,1,1,
							],4),
						],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
						\dur, 1/8,
						\amp, 0.011,
					),
				],1),
				Pbind(
					\instrument, \sibass,
					\out, BusDef(\fx1),
					\lpfr, 3,
					//\lag, 0.04,
					\rq, 0.3,
					\note, Pseq([
						Pseq([
							[5],
							[10],
							\r,
							[10],

							Prand([\r, \r, [2], [5]],1),
							[10],
							Prand([ \r, [2], ],1),
							[10],

							Prand([ \r, [2], ],1),
							[5],
							\r,
							Prand([ \r, [2], ],1),
						],1),
						\r, \r,\r,1,
					],inf),
					\octave, 2,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12)*2,
						Pser([
							2,1,1/2,1/2,
						],4),
					],inf),
					\dur, 1/8,
					\amp, 0.271
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						1,1,1,1, 1,1,1,1,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq([
						0,0,0,0, 0,0.51,0,0.81,
						0,1,0,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1/2,
					\gain, 1/2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\out, BusDef(\fx1),
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
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),

			]),
		),
	);
	Pdef(\message_part2,
		Pfindur(16,
			Ppar([
				PmonoArtic( \rdnfx,
					\inbus, BusDef(\fx1, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00011,
					\delay2, 0.0000001,
					\distamp, 10.1,
					//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
					\delay, ~pmodenv.(Pseq([0.000001,0.000001,0.00017],inf), Pseq([6,2,0],3)),
					\delay2, ~pmodenv.(Pseq([0.000001,0.000001,0.017],inf), Pseq([6,2,0],3)),
					\fb, ~pmodenv.(Pseq([0.000001,0.000001,0.02],inf), Pseq([6,2,0],3)),
					\distamp, ~pmodenv.(Pseq([1.000001,10.000001,100.02],inf), Pseq([6,2,0],3)),
					\distamp, Pseq([10,1,30,80],inf),
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0000,
					\shift2, 0.0000,
					\shift, ~pmodenv.(Pseq([
						0,0,0,0,
						0.0000,0.002,-0.001,0.001,
						0,0,0,0,
						0.0000,-0.2,0.01,4,
					].rotate(0),3), 1),
					\mix, 0.51,
					\mix, 0.5,
					\eqmid1b, 600,
					\eqdb1b, 4,
					\gain, 1/3,
				),
				PmonoArtic( \rdnfx2,
					\inbus, BusDef(\fx2, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00001,
					\delay2, 0.001001,
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0001,
					\shift2, 0.0001,
					\mix, 0.51,
					\mix, 1,
					\gain, 1/4/1,
					\distamp, 140.1,
				),
				Pbind(
					\instrument, \silead,
					\out, BusDef(\fx2),
					\env1, Pseq([
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
						],8),
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.01,0.2]) ],
						],4),
						Pseq([
							[ Env([1,2,1],[0.01,0.6]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
							[ Env([1,2,1],[0.01,0.8]) ],
						],8),
					],inf),
					\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,1), 8),
					\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,1), 7),
					\note, Pseq([
						Pseq([
							[2-12, 5, 10],
							[5, 10, 2-12],
							\r,
							[10-12, 5, 10],

							\r,
							[5, 10, 2-12],
							Prand([ \r, [5, 10], ],1),
							[5-12, 5, 10],

							Prand([ \r, [5, 10, 2-12], ],1),
							[5, 10],
							\r,
							\r
						],1),
						[1+12, 7], \r,\r,\r,
					],inf),
					\octave, 6,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12),
						Pser([
							2,1,1,1,
						],4),
					],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
					\dur, 1/8,
					\amp, 0.011,
				),
				Pbind(
					\instrument, \sibass,
					\out, BusDef(\fx1),
					\lpfr, 3,
					//\lag, 0.04,
					\rq, 0.3,
					\note, Pseq([
						Pseq([
							[5],
							[10],
							\r,
							[10],

							Prand([\r, \r, [2], [5]],1),
							[10],
							Prand([ \r, [2], ],1),
							[10],

							Prand([ \r, [2], ],1),
							[5],
							\r,
							Prand([ \r, [2], ],1),
						],1),
						\r, \r,\r,1,
					],inf),
					\octave, 2,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12)*2,
						Pser([
							2,1,1/2,1/2,
						],4),
					],inf),
					\dur, 1/8,
					\amp, 0.271
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						1,1,1,1, 1,1,1,1,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq([
						0,0,0,0, 0,0.51,0,0.81,
						0,1,0,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1/2,
					\gain, 1/2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\out, BusDef(\fx1),
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
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),

			]),
		),
	);
)


(
Pdef(\realmain, 
	Pseq([
		// strange sound
		// start bass
		Pfindur(17,Ptpar([
			0, Ppar([
				PmonoArtic( \rdnfx,
					\inbus, BusDef(\fx3, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.100017,
					\delay, 0.40011,
					\delay2, 0.4000001,
					\distamp, 10.1,
					//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
					\distamp, Pseq([80],inf),
					\legato, Pseq([
						1,1,1,0.9,
					],1),
					\shift, 0.0000,
					\shift2, 0.0000,
					\shift, ~pmodenv.(Pseq([
						0,0,0,0,
						0.0000,0.002,-0.001,0.001,
						0,0,0,0,
						0.0000,-0.2,0.01,40,
					].rotate(0),1), 1),
					\mix, 0.51,
					\mix, 0.5,
					\eqmid1b, 600,
					\eqdb1b, 4,
					\gain, 1/3,
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],1).coin.not,
					\out, BusDef(\fx3),
					\sustain, 0.08/1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			]),
			1, PmonoArtic( \rdnfx,
				\inbus, BusDef(\fx1, \audio),
				\dur, 1,
				\amp, 0.1,
				\fb, 0.000017,
				\delay, 0.00011,
				\delay2, 0.0000001,
				\distamp, 10.1,
				//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
				\distamp, Pseq([2],inf),
				\legato, Pseq([
					1,1,1,0.9,
				],inf),
				\shift, 0.0000,
				\shift2, 0.0000,
				\shift, ~pmodenv.(Pseq([
					0,0,0,0,
					0.0000,0.002,-0.001,0.001,
					0,0,0,0,
					0.0000,-0.2,0.01,40,
				].rotate(0),2), 1),
				\mix, 0.51,
				\mix, 0.5,
				\eqmid1b, 600,
				\eqdb1b, 4,
				\gain, 1/3,
			),
			1, Pbind(
				\instrument, \sibass,
				\out, BusDef(\fx1),
				\lpfr, 3,
				//\lag, 0.04,
				\rq, 0.3,
				\note, Pseq([
					Pseq([
						[5],
						[10],
						\r,
						[10],

						Prand([\r, \r, [2], [5]],1),
						[10],
						Prand([ \r, [2], ],1),
						[10],

						Prand([ \r, [2], ],1),
						[5],
						\r,
						Prand([ \r, [2], ],1),
					],1),
					\r, \r,\r,1,
				],inf),
				\octave, 2,
				\legato, Pseq([
					Pser([
						0.2,0.7,
					],12)*2,
					Pser([
						2,1,1/2,1/2,
					],4),
				],inf),
				\dur, 1/8,
				\amp, 0.271
			),
			9, PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 8,
				\out, BusDef(\fx1),
				\isRest, Pseq({[
					1,0,1,0, 1,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		])),


		// part 1, start chords at 8

		Pdef(\message_part1),

		// break no kick no bass

		Pfindur(8,
			Ppar([
				PmonoArtic( \rdnfx,
					\inbus, BusDef(\fx1, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00011,
					\delay2, 0.0000001,
					\distamp, 10.1,
					//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
					\delay, ~pmodenv.(Pseq([0.000001,0.000001,0.00017],3), Pseq([6,2,0],inf)),
					\delay2, ~pmodenv.(Pseq([0.000001,0.000001,0.017],3), Pseq([6,2,0],inf)),
					\fb, ~pmodenv.(Pseq([0.000001,0.000001,0.02],3), Pseq([6,2,0],inf)),
					\distamp, ~pmodenv.(Pseq([1.000001,10.000001,100.02],3), Pseq([6,2,0],inf)),
					\distamp, Pseq([10,1,30,80],inf),
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0000,
					\shift2, 0.0000,
					\shift, ~pmodenv.(Pseq([
						0,0,0,0,
						0.0000,0.002,-0.001,0.001,
						0,0,0,0,
						0.0000,-0.2,0.01,40,
					].rotate(0),3), 1),
					\mix, 0.51,
					\mix, 0.5,
					\eqmid1b, 600,
					\eqdb1b, 4,
					\gain, 1/3,
				),
				PmonoArtic( \rdnfx2,
					\inbus, BusDef(\fx2, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00001,
					\delay2, 0.001001,
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0001,
					\shift2, 0.0001,
					\mix, 0.51,
					\mix, 1,
					\gain, 1/4/1,
					\distamp, 140.1,
				),
				Pbind(
					\instrument, \silead,
					\out, BusDef(\fx2),
					\env1, Pseq([
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
						],8),
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.01,0.2]) ],
						],4),
						Pseq([
							[ Env([1,2,1],[0.01,0.6]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
							[ Env([1,2,1],[0.01,0.8]) ],
						],8),
					],inf),
					\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,1), 8),
					\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,1), 7),
					\note, Pseq([
						Pseq([
							[2-12, 5, 10],
							[5, 10, 2-12],
							\r,
							[10-12, 5, 10],

							\r,
							[5, 10, 2-12],
							Prand([ \r, [5, 10], ],1),
							[5-12, 5, 10],

							Prand([ \r, [5, 10, 2-12], ],1),
							[5, 10],
							\r,
							\r
						],1),
						[1+12, 7], \r,\r,\r,
					],inf),
					\octave, 6,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12),
						Pser([
							2,1,1,1,
						],4),
					],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
					\dur, 1/8,
					\amp, 0.011,
				),
				Pbind(
					\instrument, \sibass,
					\out, BusDef(\fx1),
					\lpfr, 3,
					//\lag, 0.04,
					\rq, 0.3,
					\note, Pseq([
						Pseq([
							[5],
							[10],
							\r,
							[10],

							Prand([\r, \r, [2], [5]],1),
							[10],
							Prand([ \r, [2], ],1),
							[10],

							Prand([ \r, [2], ],1),
							[5],
							\r,
							Prand([ \r, [2], ],1),
						],1),
						\r, \r,\r,1,
					],inf),
					\octave, 2,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12)*2,
						Pser([
							2,1,1/2,1/2,
						],4),
					],inf),
					\dur, 1/8,
					\amp, 0.271,
					\isRest, true,
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						1,1,1,1, 1,1,1,1,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq([
						0,0,0,0, 0,0.51,0,0.81,
						0,1,0,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1/2,
					\gain, 1/2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\isRest, true,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),

			]),
		),

		// part 2

		Pdef(\message_part2),


		// break no piano

		Pfindur(8,
			Ppar([
				PmonoArtic( \rdnfx,
					\inbus, BusDef(\fx1, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00011,
					\delay2, 0.0000001,
					\distamp, 10.1,
					//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
					\delay, ~pmodenv.(Pseq([0.000001,0.000001,0.00017],3), Pseq([6,2,0],inf)),
					\delay2, ~pmodenv.(Pseq([0.000001,0.000001,0.017],3), Pseq([6,2,0],inf)),
					\fb, ~pmodenv.(Pseq([0.000001,0.000001,0.02],3), Pseq([6,2,0],inf)),
					\distamp, ~pmodenv.(Pseq([1.000001,10.000001,100.02],3), Pseq([6,2,0],inf)),
					\distamp, Pseq([10,1,30,80],inf),
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0000,
					\shift2, 0.0000,
					\shift, ~pmodenv.(Pseq([
						0,0,0,0,
						0.0000,0.002,-0.001,0.001,
						0,0,0,0,
						0.0000,-0.2,0.01,40,
					].rotate(0),3), 1),
					\mix, 0.51,
					\mix, 0.5,
					\eqmid1b, 600,
					\eqdb1b, 4,
					\gain, 1/3,
				),
				PmonoArtic( \rdnfx2,
					\inbus, BusDef(\fx2, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.000017,
					\delay, 0.00001,
					\delay2, 0.001001,
					\legato, Pseq([
						1,1,1,0.9,
					],inf),
					\shift, 0.0001,
					\shift2, 0.0001,
					\mix, 0.51,
					\mix, 1,
					\gain, 1/4/1,
					\distamp, 140.1,
				),
				Pbind(
					\instrument, \silead,
					\out, BusDef(\fx2),
					\env1, Pseq([
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
						],8),
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.01,0.2]) ],
						],4),
						Pseq([
							[ Env([1,2,1],[0.01,0.6]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
							[ Env([1,2,1],[0.01,0.8]) ],
						],8),
					],inf),
					\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,1), 8),
					\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,1), 7),
					\note, Pseq([
						Pseq([
							[2-12, 5, 10],
							[5, 10, 2-12],
							\r,
							[10-12, 5, 10],

							\r,
							[5, 10, 2-12],
							Prand([ \r, [5, 10], ],1),
							[5-12, 5, 10],

							Prand([ \r, [5, 10, 2-12], ],1),
							[5, 10],
							\r,
							\r
						],1),
						[1+12, 7], \r,\r,\r,
					],inf),
					\octave, 6,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12),
						Pser([
							2,1,1,1,
						],4),
					],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
					\dur, 1/8,
					\amp, 0.011,
					\isRest, true,
				),
				Pbind(
					\instrument, \sibass,
					\out, BusDef(\fx1),
					\lpfr, 3,
					//\lag, 0.04,
					\rq, 0.3,
					\note, Pseq([
						Pseq([
							[5],
							[10],
							\r,
							[10],

							Prand([\r, \r, [2], [5]],1),
							[10],
							Prand([ \r, [2], ],1),
							[10],

							Prand([ \r, [2], ],1),
							[5],
							\r,
							Prand([ \r, [2], ],1),
						],1),
						\r, \r,\r,1,
					],inf),
					\octave, 2,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12)*2,
						Pser([
							2,1,1/2,1/2,
						],4),
					],inf),
					\dur, 1/8,
					\amp, 0.271,
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						1,1,1,1, 1,1,1,1,
						1,0,1,0, 1,0,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq([
						0,0,0,0, 0,0.51,0,0.81,
						0,1,0,0, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.1/2,
					\gain, 1/2,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\out, BusDef(\fx1),
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
					\kitIndex, 4,
					\out, BusDef(\fx1),
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),

			]),
		),

		// part 3

		Pdef(\message_part2),

		// end
		Pfindur(4,Ptpar([
			0, Ppar([
				PmonoArtic( \rdnfx,
					\inbus, BusDef(\fx3, \audio),
					\dur, 1,
					\amp, 0.1,
					\fb, 0.100017,
					\delay, 0.40011,
					\delay2, 0.4000001,
					\distamp, 10.1,
					//\delay2, ~pmodenv.(Pseq([0.000001,0.7],inf), Pseq([8,2],inf)),
					\distamp, Pseq([80],inf),
					\legato, Pseq([
						1,1,1,0.9,
					],1),
					\shift, 0.0000,
					\shift2, 0.0000,
					\shift, ~pmodenv.(Pseq([
						0,0,0,0,
						0.0000,0.002,-0.001,0.001,
						0,0,0,0,
						0.0000,-0.2,0.01,40,
					].rotate(0),3), 1),
					\mix, 0.51,
					\mix, 0.5,
					\eqmid1b, 600,
					\eqdb1b, 4,
					\gain, 1/3,
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],1).coin.not,
					\out, BusDef(\fx3),
					\sustain, 0.08/1,
					\dur, 1/8,
					\amp, 0.1,
				)),
			]),
		])),

	])
).play;
)

(
Pdef(\testom, 
	Ppar([
		Pfindur(4,
				Pbind(
					\instrument, \silead,
					//\out, BusDef(\fx2),
					\env1, Pseq([
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
						],8),
						Pseq([
							[ Env([1,2,1],[0.01,0.8]) ],
							[ Env([1,2,1],[0.01,0.2]) ],
						],4),
						Pseq([
							[ Env([1,2,1],[0.01,0.6]) ],
							[ Env([1,2,1],[0.1,0.8]) ],
							[ Env([1,2,1],[0.01,0.8]) ],
						],8),
					],inf),
					\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pseq([4],4)),
					\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,inf), Pseq([4],4)),
					\note, Pseq([
						Pseq([
							[2-12, 5, 10],
							[5, 10, 2-12],
							\r,
							[10-12, 5, 10],

							\r,
							[5, 10, 2-12],
							Prand([ \r, [5, 10], ],1),
							[5-12, 5, 10],

							Prand([ \r, [5, 10, 2-12], ],1),
							[5, 10],
							\r,
							\r
						],1),
						[1+12, 7], \r,\r,\r,
					],8),
					\octave, 6,
					\legato, Pseq([
						Pser([
							0.2,0.7,
						],12),
						Pser([
							2,1,1,1,
						],4),
					],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8),
					\dur, 1/8,
					\amp, 0.011,
				),
			)

		
	])
).play;
)
