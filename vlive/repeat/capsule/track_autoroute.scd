(
SynthDef(\autobass2, { arg out=0, gate=1, freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmfreq;
	env1 = Duty.kr(\dutytime.kr(1/8/~t), 0, Dseq([
		1,0,0,0,
		1,0,1,1,
		1,0,0,1,
		1,0,0,0,
	],inf)).lag(0.01);
	fmfreq = freq * ( 1 + ( SinOsc.ar(freq * 1 * env1) * 2.2 ));
	sig = LFSaw.ar(fmfreq * [1,1.0001]);
	sig = RLPF.ar(sig, freq*2 * [1,2 * SinOsc.kr(1/8).range(2,1),1], 0.2 * SinOsc.kr(1/4).range(2,1));
	sig = Pan2.ar(sig, 0, amp).flop;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\autotreb, { arg out=0, gate=1, freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmfreq;
	env1 = Duty.kr(\dutytime.kr(1/8/~t), 0, Dseq([
		1,0,0,0,
		1,0,1,0,
		1,0,0,1,
		1,0,0,0,
	],inf)).lag(0.01);
	fmfreq = freq * ( 1 + ( SinOsc.ar(freq * 1 * env1) * 2.2 ));
	sig = LFSaw.ar(fmfreq * [1,1.0001]);
	sig = RLPF.ar(sig, freq*2 * [1,2 * SinOsc.kr(1/8).range(2,1),1], 0.2 * SinOsc.kr(1/4).range(2,1));
	sig = Pan2.ar(sig, 0, amp).flop;
	sig = sig / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\tototreb, { arg out=0, gate=1, freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmfreq;
	env1 = \fmfreq.kr(0);
	fmfreq = freq * ( 1 + ( SinOsc.ar(freq * 1 * env1) * 2.2 ));
	sig = LFSaw.ar(fmfreq * [1,1.0001]);
	sig = RLPF.ar(sig, freq*2 * [1,2 * SinOsc.kr(1/8).range(2,1),1], 0.2 * SinOsc.kr(1/4).range(2,1));
	sig = Pan2.ar(sig, 0, amp).flop;
	sig = sig / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\autobass, { arg out=0, gate=1, freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(\dutytime.kr(1/8/~t), 0, Dseq([
		1,0,0,0,
		0,0,0,0,
	],inf)).lag(0.1);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*0.6 * 1.0 * env1) * 5.14 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 400, 800 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(1.1,1)] * 1.1 * Amplitude.kr(sig)**7.8 ) ).clip(5,18000));
	sig.debug("sig");
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1), amp);
	sig.debug("sig");
	sig = sig.mean;
	sig = sig /1;
	sig.debug("sig");
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);



ProtoDef(\rdn).edit;

(
	~master.();
Pdef(\part, Pdef(\main,
	Pseq([
			Pmono(\autobass,
				\dur, Pseq([ 1 ],4),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \autobass,
				\freq, 85,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],4).coin.not,
				\legato, 4,
				\dur, Pseq([ 1/8 ],inf),
				\amp, 0.1,
			),
			Pfindur(16,Pdef(\autoroute1)),
			Pfindur(8,Pdef(\autoroute2)),
			Pfindur(8,Pdef(\autoroute3)),
			Pfindur(8,Pdef(\autoroute4)),
			Pfindur(8,Pdef(\autoroute5)),
	])
)).play;
);

(
	~master.();
Pdef(\part,  Pdef(\autoroute1,
	Ppar([
		Pseq([
			Pmono(\autobass,
				\dur, Pseq([ 1 ],12),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \autobass,
				\freq, 85,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],4).coin.not,
				\legato, 4,
				\dur, Pseq([ 1/8 ],inf),
				\amp, 0.1,
			),
		],inf),
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
		
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
		
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,1,1, 1,1,1, 1,0,1, 1,1,1,
		
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,0,1, 1,1,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.2,0.01,0.12,
					0.01,0.01,0.01,
				],inf),
				\dur, 1/12,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,0, 1,0,0,  0,0,0, 0,0,0,
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/12,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/12,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\isRest, Pseq([
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				//\lag, 0.120/~t,
				\sustain, 0.1/4,
				\dur, 1/12,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
				\isRest, true,
			),
		])
	]),
)).play;
);

(
	~master.();
Pdef(\part,  Pdef(\autoroute2,
	Ppar([
			Pbind(
				\instrument, \autobass,
				\freq, 90,
				\dur, 1/1,
				\amp, 0.1,
			),
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,1, 1,1,1, 1,0,0, 1,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.2,0.01,0.12,
					0.01,0.01,0.01,
				],inf),
				\dur, 1/12,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,0, 0,0,0,  0,0,1, 0,0,1,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/12,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/12,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\isRest, Pseq([
					0,0,0, 0,0,1,  1,0,1, 1,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				//\lag, 0.120/~t,
				\sustain, 0.1/4,
				\dur, 1/12,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
				\isRest, true,
			),
		])
	]),
)).play;
);

(
	~master.();
Pdef(\part,  Pdef(\autoroute3,
	Ppar([
		Pmono(\autobass2,
			\freq, 70,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.2,0.01,0.12,
					0.01,0.01,0.01,
				],inf),
				\dur, 1/16,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				//\lag, 0.120/~t,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
				\isRest, true,
			),
		])
	]),
)).play;
);

(
	~master.();
Pdef(\part,  Pdef(\autoroute4,
	Ppar([
		Pmono(\autobass2,
			\dutytime, 1/~t,
			\freq, 70,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\autotreb,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.2,0.01,0.12,
					0.01,0.01,0.01,
				],inf),
				\dur, 1/16,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick2,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,1,0,
				],inf).coin.not,
				//\lag, 0.120/~t,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
				\isRest, true,
			),
		])
	]),
)).play;
);

(
	~master.();
Pdef(\part,  Pdef(\autoroute5,
	Ppar([
		Pseq([
			Pfindur(14,Pmono(\tototreb,
				\freq, 200,
				\fmfreq, Pseq([
					1,0,1, 0,1,1, 1,0,0, 1,0,0,
					1,0,1, 1,1,1, 1,0,0, 1,0,1,
					1,0,1, 0,1,1, 1,0,0, 1,0,0,
					1,1,1, 1,0,0, 1,0,1, 1,0,1,
				],inf),
				\dur, 1/12,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \autobass,
				\freq, 200,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],4).coin.not,
				\legato, 4,
				\dur, Pseq([ 1/8 ],inf),
				\amp, 0.1,
			),
		],inf),
		Pseq([
			Pmono(\autobass,
				\dur, Pseq([ 1 ],12),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \autobass,
				\freq, 85,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],4).coin.not,
				\legato, 4,
				\dur, Pseq([ 1/8 ],inf),
				\amp, 0.1,
			),
		],inf),
		Pbind(\out, BusDef(\sendbus1))<>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
		
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
		
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,0,1, 1,0,1,
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,1,1, 1,1,1, 1,0,1, 1,1,1,
		
					1,0,1, 1,1,1, 1,0,1, 1,1,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,0,1, 1,0,0, 1,0,1, 1,0,1,
					1,1,1, 1,1,1, 1,0,1, 1,1,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.02) ],
				],inf),
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.2,0.01,0.12,
					0.01,0.01,0.01,
				],inf),
				\dur, 1/12,
				//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.0132,
			),
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
					1,0,0, 1,0,0,  0,0,0, 0,0,0,
					1,0,0, 0,0,0,  0,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.01,
				\dur, 1/12,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/12,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.07) ],
				],inf),
				\isRest, Pseq([
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				//\lag, 0.120/~t,
				\sustain, 0.1/4,
				\dur, 1/12,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
				\isRest, true,
			),
		])
	]),
)).play;
);


// END

//////////////////////////// DRAFT

Pbind(
	\instrument, \a,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
);

(
Pdef(\test, 
	Ppar([
		Pmono(\autotreb,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
).play;
);

p = Pbind(\instrument, \test, \dur, 0.1,\freq,Pwhite(100,400),\amp, 0.1);
p.play

p.render("/tmp/bla.wav".standardizePath,2 )

(
SynthDef(\test, { | out, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1,dur |
    var audio = Blip.ar(freq, nharms, amp);
	var env = Linen.kr(Impulse.ar(0),0.1,1,0.1, doneAction: 2);
   Out.ar(out, Pan2.ar(audio, pan, 1) );
}).store;
)

(
Ndef(\fee).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,3,5].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(SinOsc.kr(0.7*(1..11)/12).unipolar*2, [sig1, sig2, sig3]);
	sig = SelectX.ar(SinOsc.kr(0.07*(1..11)/12).unipolar*6, sig.flop);

	sig = sig.fold2( SinOsc.kr(1/4/(1..11)).range(0.1,2));
	sig = sig.wrap2( SinOsc.kr(1/4/(1..11).reverse).range(0.1,2));
	lpspread = SinOsc.kr(1/5*(1..11)/9)*1.5;
	//lpspread = 0;
	sig = RLPF.ar(sig, \lpf.kr(400) * SinOsc.kr((0..11)+1/42.3).exprange(1/2,10) * ((0..11)/11 - 0.5 * lpspread + 1), \rq.kr(0.5));
	sig = HPF.ar(sig, 700);

	sig = sig / 2;
	
	amp = amp * \gain.kr(1);
	//sig = sig.flop;
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig;
}).play;

)


(
Ndef(\eyes, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		0,0,0,0,
	],inf)).lag(0.1);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*0.6 * 1.0 * env1) * 2.14 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 400, 800 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(1.1,1)] * 1.1 * Amplitude.kr(sig)**7.8 ) ).clip(5,18000));
	sig.debug("sig");
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1), amp);
	sig.debug("sig");
	sig = sig.mean;
	sig = sig /1;
	sig.debug("sig");
	sig;
}).play
);
Ndef(\eyes).clear
