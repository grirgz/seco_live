
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

SynthDef(\autobasst2, { arg out=0, gate=1, freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(\dutytime.kr(1/8/~t), 0, Dseq([
		1,0,0,0,
		0,0,0,0,
	],inf)).lag(0.1);
	env2 = EnvGen.kr(Env([1,0.2,1,2,0.12],[1.1,1.8,1.1,4],0), 1-env1);
	env2 = EnvGen.kr(Env([0,1,4,1,2,0.12],[0,10.1,1.8,1.1,4],0,1,1,1), ( 1-(env1 > 0.9)));
	env3 = Duty.kr(\dutytime3.kr(1/2/~t), 0, Dseq([
		1,0,1/2,0,
	],inf)).lag(0.01);
	sig = LFSaw.ar(freq * [1,1.001] * ( SinOsc.ar(freq * env2) * 1 + 1 ));
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*0.6 * 1.0 * env1) * 5.14  )) * (env3 * 0.5 + 1));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 400, 800 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(1.1,1)] * env2 * \lpfr.kr(1.1) * Amplitude.kr(sig)**7.8 ) ).clip(5,18000));
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
SynthDef(\autobasst3, { arg out=0, gate=1, freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(\dutytime.kr(1/8/~t), 0, Dseq([
		1,0,0,0,
		0,0,0,0,
	],inf)).lag(0.1);
	env2 = EnvGen.kr(Env([1,0.2,1,2,0.12],[1.1,1.8,1.1,4],0), 1-env1);
	env2 = EnvGen.kr(Env([0,1,4,1,2,0.12],[0,10.1,1.8,1.1,4],0,1,1,1), ( 1-(env1 > 0.9)));
	env3 = Duty.kr(\dutytime3.kr(1/2/~t), 0, Drand([
		1,3/4,1/2,1/4,0,0,1,
	],inf)).lag(0.01);
	env4 = Duty.kr(\dutytime4.kr(1/2/~t), 0, Drand([
		1,0,0,1/4,1/2,
	],inf)).lag(0.01);

	sig = LFSaw.ar(freq * [1,1.001] * ( SinOsc.ar(freq * env2) * 1 + 1 ));
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*0.6 * 1.0 * env1) * 5.14  )) * (env3 * 0.5 + 1));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 400, 800 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(1.1,1)] * env2 * \lpfr.kr(1.1) * Amplitude.kr(sig)**7.8 ) ).clip(5,18000));
	sig.debug("sig");
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1), amp);
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * env4;
	sig = sig /1;
	sig.debug("sig");
	sig = Limiter.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
//Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\autobassintro, 
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
	])
));
);

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
));
);

(
	~master.();
Pdef(\part,  Pdef(\autoroute1,
	Ppar([
		Pseq([
			Pmono(\autobass,
				\dur, Pseq([ 1 ],12),
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \autobass,
				\freq, 85,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],4).coin.not,
				\legato, 4,
				\dur, Pseq([ 1/8 ],inf),
				\amp, 0.1/2,
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
				\instrument, \playersec,
				\bufnum, ~buflib.snare[417].value,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\dur, 1/12,
				\gain, 1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1880].value,
				\isRest, Pseq([
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				\dur, 1/12,
				\gain, 0.1,
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
));
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
));
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
));
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
));
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
));
);

(
Pdef(\part, Pdef(\autobass1, 
	Ppar([
		Pmono(\autobass,
			\dur, Pseq([ 1 ],4),
			\amp, 0.1,
		),
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\autobass1long, 
	Ppar([
		Pmono(\autobass,
			\dur, Pseq([ 1 ],inf),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\autobasst2, 
	Ppar([
		Pmono(\autobasst2,
			\dur, Pseq([ 1 ],inf),
			\amp, 0.1,
			\dutytime, 1/1/~t,
			\dutytime3, Pwhite(0.01,0.1),
			\dutytime3, 1/16/~t,
			\lpfr, 1,
			\octave, 3,
			\note, Pseq([
				0,1,
			],inf),
			\out, BusDef(\sendbus1, \audio),
		),
	])
));
);

(
Pdef(\part, Pdef(\autobass2, 
	Ppar([
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
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\automelo1, 
	Ppar([
		Pmono(\autobasst2,
			\dur, Pseq([ 1 ],inf),
			\dutytime, 1/1/~t,
			\dutytime3, Pwhite(0.01,0.1),
			\dutytime3, 1/16/~t,
			\lpfr, 2.6,
			\note, Pseq([
				0,1,
			],inf),
			\amp, 0.1/16,
			\out, BusDef(\sendbus2, \audio),
		),
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\automelo2, 
	Ppar([
		Pmono(\autobasst2,
			\dur, Pseq([ 1 ],inf),
			\dutytime, 1/4/~t,
			\dutytime3, Pwhite(0.01,0.1),
			\dutytime3, 1/4/~t,
			\lpfr, 2.6,
			\note, Pseq([
				0,2,0,6,
			],inf),
			\amp, 0.1/16,
			\out, BusDef(\sendbus2, \audio),
		),
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\autorise, 
	Ppar([
		Pmono(\autobasst2,
			\dur, Pseq([ 1 ],inf),
			\dutytime, 1/8/~t,
			\dutytime3, Pwhite(0.01,0.1),
			\dutytime3, 1/1/~t,
			\lpfr, 2.6,
			\freq, ~pmodenv.(Pseq([50,4080],inf), 8),
			\amp, 0.1/16,
			\out, BusDef(\sendbus2, \audio),
		),
	])
));
);
(
	~master.();
Pdef(\part, Pdef(\autofall, 
	Ppar([
		Pmono(\autobasst2,
			\dur, Pseq([ 1 ],inf),
			\dutytime, 1/8/~t,
			\dutytime3, Pwhite(0.01,0.1),
			\dutytime3, 1/1/~t,
			\lpfr, 2.6,
			\freq, ~pmodenv.(Pseq([500,80],inf), 8),
			\amp, 0.1/16,
			\out, BusDef(\sendbus2, \audio),
		),
	])
));
);

(
Pdef(\part, Pdef(\autoperc1, 
	Ppar([
		
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1180].value,
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
				\gain, 0.2,
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
				\instrument, \playersec,
				\bufnum, ~buflib.snare[417].value,
				\isRest, Pseq([
					0,0,0, 0,0,0,  1,0,0, 0,0,0,
				],inf).coin.not,
				\dur, 1/12,
				\gain, 1/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1880].value,
				\isRest, Pseq([
					0,0,1, 0,0,0,  0,0,0, 0,0,0,
					0,0,0, 0,0,0,  0,0,0, 0,0,1,
				],inf).coin.not,
				\dur, 1/12,
				\gain, 0.1,
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
));
);

(
Pdef(\part, Pdef(\autoperc3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[141].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[137].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[113].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
		),
		
	])
));
);

(
Pdef(\part, Pdef(\autoperc2, 
	Pbind(
		\out, BusDef(\sendbus3, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[141].value,
			\isRest, Pseq([
				1,1,1,1, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[137].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[112].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/32,
			\gain, 0.2 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1266].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
		),
		
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\autoperc_one1, 
	Pbind(
		\out, BusDef(\sendbus3, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[141].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[137].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 
				],8),
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2 * Pseq([1,0.4],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1266].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],12),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],12),
				Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],12),
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
		),
		
	])
));
);
(
	~master.();
Pdef(\part, Pdef(\autoperc_one2, 
	Pbind(
		\out, BusDef(\sendbus3, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[141].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[411].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\out, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[137].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2 * Pseq([1,0.4],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[112].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/32,
			\gain, 0.2 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1266].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2,
		),
		
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\autoperc_one3, 
	Pbind(
		\out, BusDef(\sendbus3, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[141].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\out, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[411].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\out, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[137].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,0,0,0, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2 * Pseq([1,0.4],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[112].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/32,
			\gain, 0.2 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1210].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/16,
			\gain, 0.2,
		),
		
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\autoperc_one4, 
	Pbind(
		\out, BusDef(\sendbus3, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[141].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\out, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[411].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\out, (1 + (0.06 * Pseq([1,-1],inf))),
			\dur, 1/16,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[137].value,
			\isRest, Pseq([
				1,1,0,0, 1,1,0,0,
				1,0,0,1, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,0,0,0, 
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2 * Pseq([1,0.4],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[113].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/32,
			\gain, 0.2 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1236].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/16,
			\gain, 0.2,
		),
		
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\autoperc_onesi, 
	Pbind(
		\out, BusDef(\sendbus3, \audio),
	) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[137].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.2 * Pseq([1,0.4],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[544].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],12),
			],inf).coin.not,
			\dur, 1/16,
			\lag, 0.2,
			\gain, 0.1 * Pseq([1,0.4],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/16,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1588].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,1,
			],inf).coin.not,
			\sustain, 0.2,
			\dur, 1/16,
			\gain, 0.2,
		),
		
	])
));
);

(
	~master.();
Pdef(\part, Pdef(\automelo3, 
	Ppar([
		Pmono(\autobasst3,
			\dur, Pseq([ 1 ],inf),
			\octave, 5,
			\detune, 0.1,
			\dutytime, 1/1/~t,
			\dutytime3, Pwhite(0.01,0.1),
			\dutytime3, 1/12/~t,
			\lpfr, 2.6,
			\note, Pseq([
				0,1,
			],inf),
			\amp, 0.1/10,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
));
);
