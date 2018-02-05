~t = 165/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\ndrums, 
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
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
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
		)),
		PmonoArtic( \ribass,
			\out, BusDef(\sendbus0, \audio),
			\note, Pseq([
				0,0,0,-4,
			],inf),
			\legato, Pseq([
				1,1,1,0.9,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \silead,
			\degree, Pseq([
				\r,\r,0,\r,
				\r,\r,\r,3,
				\r,\r,\r,\r,
				0,0,\r,3,

				0,\r,3,3,
				0,0,\r,3,
				0,0,3,3,
				0,0,\r,3,
			],inf).stutter(1),
			\octave, 4,
			\sustain, 0.09,
			\dur, 1/4,
			\amp, 0.1/9,
		),
	])
).play;
)

ProtoDef(\rdn, ProtoTemplateDef(\rdn)).edit
ProtoDef(\rdn).edit
ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn).play;
Pdef(\sender0, Pdef(\ndrums)).set(\out, BusDef(\sendbus0)).play;
Pdef(\sender0).clear
Pdef(\ndrums).clear


(
SynthDef(\ribass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,20,1],[0.1,2.8]), 1) ;
	sig = LFSaw.ar(freq + [0,0.01*env1]).mean* 2.12;
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * SinOsc.kr(1/2*~t).range(0.1,2) * freq, \rq.kr(0.5));
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
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\ndrums, 
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
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
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
		)),
		PmonoArtic( \ribass,
			\out, BusDef(\sendbus0, \audio),
			\note, Pseq([
				0,0,0,-4,
			],inf),
			\legato, Pseq([
				1,1,1,0.9,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \silead,
			\degree, Pseq([
				\r,\r,0,\r,
				\r,\r,\r,3,
				\r,\r,\r,\r,
				0,0,\r,3,

				0,\r,3,3,
				0,0,\r,3,
				0,0,3,3,
				0,0,\r,3,
			],inf).stutter(1),
			\octave, 4,
			\sustain, 0.09,
			\dur, 1/4,
			\amp, 0.1/9,
		),
	])
).play;
)

	~rdn_to_fbstring.(RandDelayNetwork(\del3)).editorInsert;
(

	SynthDef(\fxdel3, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 402212;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay.kr) + si;
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay.kr) + si;
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay.kr) + si;
			si = SelectX.ar(\distmix.kr,[si, (si * 10.rand * \distamp.kr).tanh / 2]);
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
			]);
			si = [
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
					si = SelectX.ar(\shiftmix.kr, [
						si,
						FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
					]);
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay.kr) + si;
					si = BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
					si = SelectX.ar(\distmix2.kr,[si, (si * 10.rand * \distamp2.kr).tanh / 2]);
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
					si = SelectX.ar(\shiftmix.kr, [
						si,
						FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift3.kr) + si / 1.2,
					]);
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
					si = SelectX.ar(\distmix3.kr,[si, (si * 10.rand * \distamp3.kr).tanh / 2]);
					si = SelectX.ar(\shiftmix.kr, [
						si,
						FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2,
					]);
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				}.value(si, env);

			].mean;
		}.value(si, env);

		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = sig * \wetamp.kr(0.1);
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;

		

		
);

(
	Pdef(\xdrums, 
		Ppar([

			PmonoArtic(\fxdel3,
				\dur, 1/4,
				\inbus, BusDef(\fx1, \audio),
				\legato, 1,
				'wet10', 1.0,
				'mix', 0.50504201680672,
				'gain', 0.82126325966079,
				\distmix, 0.4,
				\distmix2, 0.6,
				\distmix3, 1.4,
				'wetamp', 0.08504562572587,
				\fb, Pseq([
					0.00001,
					0.00001,
					0.00001,
					0.00001,

					0.00101,
					0.00101,
					0.00001,
					0.00001,
				],inf),
				'fb', 0.0000001307571154094,
				'delay', 0.000010012613637220374,
				'delay2', 0.000000012613637220374,
				'delay3', 0.00010001123104501833,
				'distamp', 2.122911644584,
				'distamp2', Pseq([
					1,1,1,10,
					1,1,1,90,
				],inf),
				\distamp2, 10.1,
				'distamp3', 0.466190090704,
				'shift', 0.0,
				'shift2', 0.0,
				'shift3', 0.0,
				'shiftmix', 0.1,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 20.0,
				'stereo', 0.0,
				'brffac', 1,
				'brfrqfac', 1,
				'fbdistamp', 0.49218074535331,
				'fbdistmix', 0.96638655462185,
				'postlpf', 17000,
				'posthpf', 17,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'eqrq', 0.66697522959855,
				'bpffac', 1.0582025961843,
			),
			PmonoArtic(\fxdel3,
				\dur, 1/4,
				\inbus, BusDef(\fx2, \audio),
				\legato, 1,
				'wet10', 1.0,
				'mix', 0.60504201680672,
				'wetamp', 0.18504562572587,
				'gain', 0.42126325966079,
				//\gain, 0,
				\fb, Pseq([
					0.00001,
				],inf),
				\legato, Pseq([
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,0.2,
				],inf),
				\distmix, 0.4,
				\distmix2, 0.6,
				\distmix3, 0.4,
				'delay', 0.00112613637220374,
				'delay3', Pseq([
					0.0010001,
					0.0010001,
					0.0010001,
					0.0000001,
				],inf),
				'gain', Ndef(\lfosidecomp, { 
					//1/(0.1+Amplitude.kr(InFeedback.ar(BusDef(\fx1), 2))).clip(0.01,2).poll 
					var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
					var sig = Compander.ar( SinOsc.ar(100) , in, \cpt.kr(0.01), \cpbelow.kr(0.941), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
					sig = Amplitude.kr(sig.sum)/8;
					sig = sig.clip(0.1,0.5);
					sig.poll;
					//sig = 0.2;
					sig;
				}),
				\delay3, Ndef(\lfo1, { SinOsc.ar(1/8*~t).range(0.0001,0.01) + SinOsc.kr(4*~t).range(0.00001,0.001) }),
				\delay2, Ndef(\lfo1, { SinOsc.ar(2/6*~t).range(0.0001,0.001) + SinOsc.kr(1/4*~t).range(0.00001,0.001) }),
				'distamp', 50.122911644584,
				'distamp2', Pseq([
					40,
				],inf),
				\distamp2, Ndef(\lfo2, { SinOsc.ar(1/8*~t).exprange(0.0001,40.01) + SinOsc.kr(4/5*~t).range(0.00001,20.001) }),
				'distamp3', 40.466190090704,
				\distamp3, Ndef(\lfo3, { SinOsc.ar(1/3*~t).exprange(0.0001,40.01) + SinOsc.kr(3/5*~t).range(0.00001,20.001) }),
				'shift', 0.0,
				'shift2', 0.0,
				'shift3', 0.0,
				'shiftmix', 0.0,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 20.0,
				'stereo', 0.0,
				'brffac', 1,
				'brfrqfac', 1,
				'fbdistamp', 0.49218074535331,
				'fbdistmix', 0.96638655462185,
				'postlpf', 17000,
				'posthpf', 17,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				'eqrq', 0.66697522959855,
				'bpffac', 1.0582025961843,
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
		//PatKitDef(\sample1).asPattern(Pbind(
			//\out, BusDef(\fx1, \audio),
			//\kitIndex, 4,
			//\isRest, Pseq({[
				//1,1,1,1, 1,1,1,1,
				//1,0,1,0, 1,0,1,0,
				//1,0,0,0, 1,0,0,0,
				//0,0,1,0, 0,0,1,0,
			//].clump(8).choose}.dup(8).flat,inf).coin.not,
			//\sustain, 0.1/2,
			//\pos, 0.1,
			//\speed, Pseq([1,0.9]*2,inf),
			//\gain, 1/8,
			//\dur, 1/8,
			//\amp, 0.1/5,
		//)),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/138,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),
		PmonoArtic( \ribass,
			\out, BusDef(\fx2, \audio),
			\note, Pseq([
				0,0,0,-4,
			],inf),
			\legato, Pseq([
				1,1,1,0.9,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1/2,
			//\isRest, true,
		),
		//Pbind(
			//\out, BusDef(\fx2, \audio),
			//\instrument, \silead,
			//\degree, Pseq([
				//\r,\r,0,\r,
				//\r,\r,\r,3,
				//\r,\r,\r,\r,
				//0,0,\r,3,

				//0,\r,3,3,
				//0,0,\r,3,
				//0,0,3,3,
				//0,0,\r,3,
			//],inf).stutter(1),
			//\octave, 4,
			////\sustain, 0.09,
			//\dur, 1/4,
			//\amp, 0.1/9,
		//),
		Pbind(
			\out, BusDef(\fx2, \audio),
			\instrument, \silead,
			\note, Pseq([
				0,0,0,-4,
				0,0,0,-4+12,
				0,-4,0,\r,
				0,0,0,-4+12,
			],inf).stutter(1),
			\octave, 5 + Prand([0,1,-1,0,0],inf),
			//\sustain, 0.09,
			\legato, Pseq([
				Pser([
					0.75, 0.05, 0.15, 0.05,
					0.75, 0.85, 0.15, 0.75,
				],8),
				Pser([
					0.05, 0.05, 0.15, 0.05,
				],8),
			],inf),
			\dur, 1/2,
			\amp, 0.1/1,
		),
		Pbind(
			\out, BusDef(\fx2, \audio),
			\instrument, \silead,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\degree, Pseq([
				3-12,
			],inf).stutter(1),
			\isRest, Pseq([
				0,0,0,1,
				0,0,0,0,
				0,1,0,0,
				0,0,0,0,
				0,0,1,0,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\sustain, 0.09,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		])
	).play;
)


ProtoDef(\piano).startControl


