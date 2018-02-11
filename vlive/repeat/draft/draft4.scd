

(
	Pdef(\main, 
		Pseq([
			
			Ppar([
				Pfindur(6,PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\speed, 0.7,
					\pos, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],8),
						Pseq([0.1],8),
					],inf),
					\sustain, 0.3,
					\dur, 1/8,
					\amp, 0.1,
				))),
				Pfindur(6,PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 9,
					\isRest, Pseq({[
						0,0,1,0, 0,0,1,0,
						1,0,1,0, 0,0,1,0,
						1,0,1,0, 1,1,1,0,
						1,0,1,1, 0,1,1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\speed, 0.7,
					\speed, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],8),
						Pseq([0.1],8),
					],inf) * 18,
					\sustain, 0.1,
					\dur, 1/16,
					\amp, 0.1,
				))),
			]),
			Ppar([
				Pfindur(2,PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq({[
						1,1,1,1, 1,1,1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\speed, 0.7,
					\pos, Pseq([
						Pseq([0.05],1),
						Pseq([0.07],1),
						Pseq([0.03],1),
						Pseq([0.1],1),
					],inf),
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				))),
				Pfindur(2,PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 9,
					\isRest, Pseq({[
						1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\speed, 0.7,
					\speed, Pseq([
						Pseq([0.05],1),
						Pseq([0.07],1),
						Pseq([0.03],1),
						Pseq([0.1],1),
					],inf) * 40,
					\sustain, 0.1,
					\dur, 1/16,
					\amp, 0.1,
				))),
			]),
			Pfindur(6,PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					1,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\pos, Pseq([
					Pseq([0.05],8),
					Pseq([0.07],8),
					Pseq([0.03],8),
					Pseq([0.1],8),
				],inf),
				\sustain, 0.3,
				\dur, 1/8,
				\amp, 0.1,
			))),
			Pfindur(2,PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq({[
					1,1,1,1,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\pos, Pseq([
					Pseq([0.05],8),
					Pseq([0.07],8),
					Pseq([0.03],8),
					Pseq([0.1],8),
				],inf),
				\sustain, 0.1,
				\dur, 1/16,
				\amp, 0.1,
			))),
		],inf),
	).play;

)


(
	Pdef(\main, 
		Pseq([
			
			Pfindur(6,Ppar([
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],8),
						Pseq([0.1],8),
					],inf),
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0, 0,0,0,1, 1,1,1,1,
						0,0,1,0, 1,1,0,1, 0,0,0,1, 1,1,1,1,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],8),
						Pseq([0.1],8),
					],inf),
					\sustain, 0.1,
					\dur, 1/16,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq({[
						1,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,0, 1,0,1,1,
						1,1,1,1, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],2),
						Pseq([0.1],2),
					],inf)+0.1,
					\speed, 1.2,
					\legato, 1,
					\dur, 1/16,
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
						1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([0.24,0.08],inf),
					\speed, 1.4,
					\sustain, 0.1/2,
					\dur, 1/8,
					\amp, 0.1,
				)),
			])),
			Pfindur(2-(1/4),Ppar([
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0, 1,0,0,0,
						1,0,0,1, 0,1,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],8),
						Pseq([0.1],8),
					],inf),
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,1,1,0,
					].clump(32).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],8),
						Pseq([0.1],8),
					],inf),
					\sustain, 0.1,
					\dur, 1/16,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq({[
						1,0,0,0, 1,0,0,1,
						0,0,0,0, 0,0,0,1,
						0,0,1,0, 0,0,1,0,
						0,0,1,1, 0,1,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([
						Pseq([0.05],8),
						Pseq([0.07],8),
						Pseq([0.03],2),
						Pseq([0.1],2),
					],inf)+0.1,
					\speed, 1.2,
					\legato, 1,
					\dur, 1/16,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq({[
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 8,
					\isRest, Pseq({[
						1,1, 1,1, 1,1, 1,1,
						0,0, 1,0, 1,1, 1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\pos, Pseq([0.24,0.08],inf),
					\speed, 1.4,
					\sustain, 0.1/2,
					\dur, 1/8,
					\amp, 0.1,
				)),
			])),
			Rest(1/4),
		],inf),
	).play;
ProtoDef(\rdn).play;
)

Pdef(\main).set(\out, BusDef(\sendbus0, \audio))
ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn).edit

(
SynthDef(\chordar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([2.00,0.7,1,1.02],[0.01,0.08,3.4])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([0.10,1.4,0.1,0.01],[0.01,0.48,3.4])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1.10,1.4,0.9,0.01],[0.01,0.48,3.4])), 1);
	sig = LFSaw.ar(freq * (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum;
	sig = SinOsc.ar(freq* (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum + sig ;
	sig.debug("sig");
	sig1 = RHPF.ar(sig, \hpfr.kr(3.4) * freq * env1, \hrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixhpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = RLPF.ar(sig, \lpfr.kr(3.4) * freq * env1, \lrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixlpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = sig.tanh;
	sig = SelectX.ar(\mixdist.kr(0.5) * env3, [sig, sig1]);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.9)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * 0.5;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\chords, Pbind(
	\instrument, \chordar,
	\note, Plazy({
		Pseq([ 
			{Scale.major.degrees.choose}.dup(3) 
			++ {Scale.major.degrees.choose + [1,0,0,0,-1].choose}.dup(1) 
	
	],4)
		//Pseq([ {Scale.major.degrees.choose}.dup(3) ],4)
	}).loop,
	\legato, 0.9,
	\dur, 1,
	\amp, 0.1/10,
)).play;
);

(
Pdef(\chords, 
	Ppar([
		
		Pbind(
			// chords
			\instrument, \chordar,
			\note, Plazy({
				Pseq([ 
					{Scale.major.degrees.choose}.dup(3) 
					++ {Scale.major.degrees.choose + [1,0,0,0,-1].choose}.dup(1) 

				],4)
				//Pseq([ {Scale.major.degrees.choose}.dup(3) ],4)
			}).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				[0,4,7],
				[0,5,9],
				[3,5,10,12],
				[3,5,9,12],
			],inf).stutter(2),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2),
			\legato, 0.7,
			\dur, 1/2,
			\mixhpf, 0,
			\mixlpf, 1,
			\amp, 0.1/6,
		),
		Pbind(
			// skank
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.1/1.7,
			\legato, 0.5,
			\octave, 4,
			\lpfr, 2.1,
			\hpfr, 2.445,
			\note, Pseq([
				[4,7],
				[0,5,12],
				[3,5,10],
				[3,9,12],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\mixhpf, 1,
			\mixlpf, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \chordar,
			\note, Plazy({
				Pseq([ 
					{Scale.major.degrees.choose}.dup(3) 
					++ {Scale.major.degrees.choose + [1,0,0,0,-1].choose}.dup(1) 

				],4)
				//Pseq([ {Scale.major.degrees.choose}.dup(3) ],4)
			}).loop,
			\note, Pseq([
				[0,4,7],
				[0,5,9],
				[3,5,10,12],
				[3,5,9,12],
			],inf).stutter(8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.1,
			\octave, 2,
			\legato, 0.5,
			\env2, Pseq([
				Env([1.10,1.4,1.4,4.01],[0.01,0.48,3.4])
			],inf),
			\env3, Pseq([
				Env([1.10,1.4,1.4,4.01],[0.01,0.48,3.4])
			],inf),
			\env1, Pseq([
				Env([1.10,1.4,1.4,4.01],[0.01,0.48,3.4])
			],inf),
			\fr, 1/1.2,
			\lpfr, 4.1 * Pkey(\fr),
			\hpfr, 4.445* Pkey(\fr),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\mixhpf, 1,
			\mixlpf, 1,
			\amp, Pfunc({ arg ev; 1/ev[\note].value.size }) * 0.1,
			\amp, 1/2 * 0.1,
		),
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
			\sustain, 0.1/1.2,
			\dur, 1/8,
			\amp, 0.1,
		))
	])
).play;
)

(
Pdef(\chords, 
	Ppar([
		
		Pbind(
			// chords
			\instrument, \chordar,
			\note, Plazy({
				Pseq([ 
					{Scale.major.degrees.choose}.dup(3) 
					++ {Scale.major.degrees.choose + [1,0,0,0,-1].choose}.dup(1) 

				],4)
				//Pseq([ {Scale.major.degrees.choose}.dup(3) ],4)
			}).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				[0,4,7],
				[0,5,9],
				[3,5,10,12],
				[3,5,9,12],
			],inf).stutter(2),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2),
			\legato, 1.0,
			\dur, 1/2,
			\mixhpf, 0,
			\mixlpf, 1,
			\amp, 0.1/6,
		),
		Pbind(
			// skank
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\note, Pseq([
				[0,4,7],
				[0,5,9],
				[3,5,10,12],
				[3,5,9,12],
			],inf).stutter(8),
			\env2, Pseq([
				Env([1.10,1,1.4,4.01],[0.01,0.48,3.4])
			],inf),
			\env3, Pseq([
				Env([1.10,1,1.4,4.01],[0.01,0.48,3.4])
			],inf),
			\env1, Pseq([
				Env([1.10,1,1.4,4.01],[0.01,0.48,3.4])
			],inf),

			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,1,1,0, 1,0,1,0,
				0,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2),
			\legato, Pseq([0.21,0.4,0.2,0.4],inf)*0.8,
			\hpfr, 3.123,
			\lpfr, 2.123,
			\octave, 5,
			\dur, 1/8,
			\mixhpf, 1,
			\mixlpf, 1,
			\amp, 0.1,
		),
		Pbind(
			// synthkick
			\instrument, \chordar,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.1/1.7,
			\legato, 0.5,
			\octave, 4,
			\lpfr, 1.1,
			\hpfr, 0.445,
			\note, Pseq([
				[4,7],
				[0,5,12],
				[3,5,10],
				[3,9,12],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\mixhpf, 1,
			\mixlpf, 1,
			\amp, 0.1/2,
		),
		Pbind(
			// synthsnare
			\instrument, \chordar,
			\note, Pseq([
				[0,4,7],
				[0,5,9],
				[3,5,10,12],
				[3,5,9,12],
			],inf).stutter(8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.1,
			\octave, 5,
			\legato, 0.5,
			\env1, Pseq([
				Env([5.10,0.4,0.4,4.01],[0.01,0.08,3.4])
			],inf),
			\env3, Pseq([
				Env([1.10,1.4,1.4,4.01],[0.01,0.48,3.4])
			],inf),
			\env1, Pseq([
				Env([1.10,1.4,1.4,4.01],[0.01,0.48,3.4])
			],inf),
			\fr, 1/1.2,
			\lpfr, 9.1 * Pkey(\fr),
			\hpfr, 4.445* Pkey(\fr),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\mixhpf, 1,
			\mixlpf, 1,
			\amp, Pfunc({ arg ev; 1/ev[\note].value.size }) * 0.1,
			\amp, 1/2 * 0.1,
		),
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
			\sustain, 0.1/1.2,
			\dur, 1/8,
			\amp, 0.1,
		))
	])
).play;
)

Scale.methods.collect(_.name)
Scale.dumpAllMethods


(
Ndef(\erik, { arg freqr=1;
    var r, snd;
	var env1 = EnvGen.kr(Env([1,2,0.1],[4.1,4.8]), 1);
    r = 10;

	snd = LocalIn.ar(2) * \fb.kr(0.3);
    snd = snd + (100..300).collect { |n|
		n = n * freqr;
       // SinOsc.ar(n)
		//* 
		LFSaw.ar(n**3/( n*200 * env1 )) 
        * SinOsc.ar(10 / n, 2pi * mod(10 * n / r, 1))
        //* (800 - n) / 600
    };
    snd = snd.clump(2).mean / 2;
	LocalOut.ar(snd);
	snd = Limiter.ar(snd);
	snd;
}).play;
)
Ndef(\erik).edit

Scale.methods.collect(_.name)


(
Ndef(\sum, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var gate;
	sig = SinOsc.ar(freq);
	gate = Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,0,
	],inf));
	sig = 300.collect({ arg x;
		//var xfreq = exprand(20,20000);
		var xfreq;
		var tsustain = rrand(0.01,10);
		xfreq = x * 2.123.rand + freq;
		SinOsc.ar(xfreq) * EnvGen.kr(Env([0,rrand(0.01,1),rrand(0.01,1),0],{rrand(0.01,1)}.dup(3).normalizeSum), gate, timeScale:tsustain); 
		
	}).mean;
	sig = FreqShift.ar(sig, \fshift.kr(0));
	sig = sig * 23;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Ndef(\sum).edit

(
SynthDef(\partial, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, tsustain=1, gliamp=1;
	var sig;
	var fmAmpEnv = EnvGen.kr(\fmAmpEnv.kr(Env([1,2,1,2],[0.1,0.8,0.1])), gate, timeScale:tsustain);
	var fmfEnv = EnvGen.kr(\fmfEnv.kr(Env([1,2,1,2],[0.1,0.8,0.1])), gate, timeScale:tsustain);
	var amfEnv = EnvGen.kr(\amfEnv.kr(Env([1,2,1,2],[0.1,0.8,0.1])), gate, timeScale:tsustain);
	freq = freq * ( 1 + EnvGen.kr(\glienv.kr(Env([1,1,1,1], [1,1,1])), gate, timeScale:tsustain, levelScale:gliamp));
	freq = freq * ( 1 + ( SinOsc.ar(\fmf.kr(1) * fmfEnv) * fmAmpEnv ));
	sig = SinOsc.ar(freq);
	sig = sig * ( 1 + SinOsc.ar(\amf.kr(1) * amfEnv) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	Pdef(\partials, Ppar( 40.collect({
		Pbind(
			\instrument, \partial,
			\degree, Pseq([0],inf),
			\freq, 400 + Pexprand(0.0007,125),
			\glienv, Pfunc({ arg ev;
				[ Env([0,rrand(0.01,1),rrand(0.01,1),0],{rrand(0.01,1)}.dup(3).normalizeSum) ]
			}),
			\fmfEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.01,1),rrand(0.01,1),0],{rrand(0.01,1)}.dup(3).normalizeSum) ]
			}),
			\fmfAmpEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.01,1),rrand(0.01,1),0],{rrand(0.01,1)}.dup(3).normalizeSum) ]
			}),
			\amfAmpEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.01,1),rrand(0.01,1),0],{rrand(0.01,1)}.dup(3).normalizeSum) ]
			}),

			\amf, Pexprand(0.01,10000),
			\fmf, Pexprand(0.01,14000),
			\gliamp, Pwhite(0.01,1),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(1.0.rand,1.0.rand,0.8.rand,1.0.rand) ];
				}),
			],inf),
			\dur, 8,
			\tsustain, Pkey(\sustain) / ~t,
			\amp, 0.1/10*2,
		)

	})) 
).play;
);

(
	Pdef(\partials, Ppar( 40.collect({
		Pbind(
			\instrument, \partial,
			\degree, Pseq([0],inf),
			\freq, 400 + Pexprand(0.0007,125),
			\glienv, Pfunc({ arg ev;
				[ Env([0,rrand(0.01,1),rrand(0.01,1),0],{rrand(0.1,1)}.dup(3).normalizeSum) ]
			}),
			\fmfEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.1,1),rrand(0.1,1),0],{rrand(0.1,1)}.dup(3).normalizeSum) ]
			}),
			\fmfAmpEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.1,1),rrand(0.1,1),0],{rrand(0.1,1)}.dup(3).normalizeSum) ]
			}),
			\amfAmpEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.1,1),rrand(0.1,1),0],{rrand(0.1,1)}.dup(3).normalizeSum) ]
			}),

			\amf, Pexprand(0.01,10000),
			\fmf, Pexprand(0.01,14000),
			\gliamp, Pwhite(0.01,1),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(1.0.rand,1.0.rand,0.8.rand,1.0.rand) ];
				}),
			],inf),
			\dur, 8,
			\tsustain, Pkey(\sustain) / ~t,
			\amp, 0.1/10*2,
		)

	})) 
).play;
);

(
	~ptime = {rrand(0.1,1)}.dup(3).normalizeSum;
	Pdef(\partials, Ppar( 40.collect({
		Pbind(
			\instrument, \partial,
			\degree, Pseq([0],inf),
			\freq, 400 + Pexprand(0.0007,125),
			\glienv, Pfunc({ arg ev;
				[ Env([0,rrand(0.01,1),rrand(0.01,1),0],~ptime) ]
			}),
			\fmfEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.1,1),rrand(0.1,1),0],~ptime) ]
			}),
			\fmfAmpEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.1,1),rrand(0.1,1),0],~ptime) ]
			}),
			\amfAmpEnv, Pfunc({ arg ev;
				[ Env([0,rrand(0.1,1),rrand(0.1,1),0],~ptime) ]
			}),

			\amf, Pexprand(0.01,10000),
			\fmf, Pexprand(0.01,14000),
			\gliamp, Pwhite(0.01,1),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(1.0.rand,1.0.rand,0.8.rand,1.0.rand) ];
				}),
			],inf),
			\dur, 8,
			\tsustain, Pkey(\sustain) / ~t,
			\amp, 0.1/10*2,
		)

	})) 
).play;
);

(
	~ptime = {rrand(0.1,1)}.dup(3).normalizeSum;
	~penv = [ Env([0,rrand(0.01,1),rrand(0.01,1),0],~ptime) ];
	Pdef(\partials, Ppar( 40.collect({
		Pbind(
			\instrument, \partial,
			\degree, Pseq([0],inf),
			\freq, 400 + Pexprand(0.0007,125),
			\glienv, Pfunc({ arg ev;
				~penv;
			}),
			\fmfEnv, Pfunc({ arg ev;
				~penv;
			}),
			\fmfAmpEnv, Pfunc({ arg ev;
				~penv;
			}),
			\amfAmpEnv, Pfunc({ arg ev;
				~penv;
			}),

			\amf, Pexprand(0.01,10000),
			\fmf, Pexprand(0.01,14000),
			\gliamp, Pwhite(0.01,1),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(1.0.rand,1.0.rand,0.8.rand,1.0.rand) ];
				}),
			],inf),
			\dur, 4,
			\tsustain, Pkey(\sustain) / ~t,
			\amp, 0.1/10*2,
		)

	})) 
).play;
);
