FileSystemProject.load("capsule/track1.scd");
FileSystemProject.load("capsule/draftsynth.scd");
(
	ProtoDef(\simpleMixer).play;

	~master.();
	Pdef(\drems1, 
		Pbind(\out, BusDef(\mixer0))<>
		Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.88,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					0,0,0,0, 1,0,1,0, 1,0,1,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
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
				\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),

			///////

		])
	).play;

);


(
SynthDef(\desa1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env3 = Duty.kr(2/~t, 0, Dseq([
		3000,2400,
	],inf));
	freq = EnvGen.kr(Env([1000,200,500,100]+env3,[0.1,0.8,0.1]*1), Impulse.kr(1/1*~t));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.23,1.001,1*( env1/100 )]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq+40 * [1,1.2,1.34,1*( env1/110 )]).sum * 1 ));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,0,1,0, 1,1,1,0,
		1,0,1,1, 1,0,1,0,
		1,1,1,0, 1,0,1,0,
		1,1,1,1, 1,1,0,0,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\desa2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = EnvGen.kr(Env([1000,200,500,100]+800,[0.1,0.8,0.1]*2), Impulse.kr(1/1*~t));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.23,1.001,1*( env1/100 )]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq+40 * [1,1.2,1.34,1*( env1/110 )]).sum * 1 ));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,0,0,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 1,1,0,0,
		0,0,1,0, 1,0,1,0,
		1,0,0,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 1,0,0,1,
		0,0,1,0, 1,0,1,0,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\desabass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = Duty.kr(1/~t, 0, Dseq([
		70,70,70,68,
	],inf));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.001]).sum;
	sig = sig * ( 1 + ( SinOsc.ar(freq * [1,1.002]).sum * 0.1 ));
	//sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,1,1,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,0,0,
		0,0,1,0, 1,1,1,0,
	],inf));
	sig = LPF.ar(sig, 400);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\melo1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq + [1,2,1/2]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq + [-1*\mod1.kr,\mod1.kr]) * env1 ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.05),gate,doneAction:2);
	sig = DelayC.ar(sig, 0.01,0.01) + sig /2;
	sig = sig * amp;
	sig = sig * 1/4;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\grip, 
	Ppar([
		Pmono(\desa1,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\desa2,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\desabass,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		//Pbind(
		//	\instrument, \melo1,
		//	\note, Pseq([
		//		0,0,0,0, 0,0,0,2,
		//	],inf),
		//	\detune, 170,
		//	\isRest, Pseq([
		//		0,0,0,0, 0,0,0,0,
		//		0,0,0,0, 0,0,0,0,
		//		1,1,1,1, 1,1,1,1,
		//		0,0,0,0, 0,0,0,0,
		//		0,0,0,0, 0,0,0,0,
		//		1,0,1,0, 1,0,0,1,
		//		0,0,0,0, 0,0,0,0,
		//		0,0,0,0, 0,0,0,0,
		//	],inf).coin.not,
		//	\mod1, Pseg(Pseq([0,1.10,-2],inf),8*2),
		//	\legato, 0.5 * Pseq([0.1,0.1,0.1,1],inf),
		//	\dur, 1/8,
		//	\amp, 0.1,
		//),
		
	])
).play;
)



//////////////////////////////


(
Ndef(\ddd, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env3 = Duty.kr(2/~t, 0, Dseq([
		3000,2400,
	],inf));
	freq = EnvGen.kr(Env([1000,200,500,100]+env3,[0.1,0.8,0.1]*1), Impulse.kr(1/1*~t));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.23,1.001,1*( env1/100 )]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq+40 * [1,1.2,1.34,1*( env1/110 )]).sum * 1 ));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,0,1,0, 1,1,1,0,
		1,0,1,1, 1,0,1,0,
		1,1,1,0, 1,0,1,0,
		1,1,1,1, 1,1,0,0,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Pdef.defaultQuant = 4;
Ndef.defaultQuant = 2;

(
Ndef(\ddd2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = EnvGen.kr(Env([1000,200,500,100]+800,[0.1,0.8,0.1]*2), Impulse.kr(1/1*~t));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.23,1.001,1*( env1/100 )]).sum;
	sig = sig * ( 1 + ( LFSaw.ar(freq+40 * [1,1.2,1.34,1*( env1/110 )]).sum * 1 ));
	sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,0,0,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 1,1,0,0,
		0,0,1,0, 1,0,1,0,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\dddbass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = Duty.kr(1/~t, 0, Dseq([
		70,70,70,68,
	],inf));
	env1 = EnvGen.kr(Env([1,2,1.5],[0.1,0.8]*1), Impulse.kr(1/1*~t));
	sig = LFSaw.ar(freq * [1,1.001]).sum;
	sig = sig * ( 1 + ( SinOsc.ar(freq * [1,1.002]).sum * 0.1 ));
	//sig = CombL.ar(sig, 0.1, 1/( freq * [1,1.2] ), sig).sum + sig/10;
	env2 = Duty.kr(1/16/~t, 0, Dseq([
		1,1,1,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,0,0,
		0,0,1,0, 1,1,1,0,
	],inf));
	sig = LPF.ar(sig, 400);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), env2, doneAction:0);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\melo, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,0,0, 0,0,0,8,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		);
		
	])
).play;
);
