BufDef(\march, "vipere/march.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\march);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name +++ \pre, 
	Pbind(
		\legato, Pseq([0.1,0.2,0.3,0.2],inf).stutter(8) * Pseg(Pseq([0.7,3],inf),32),
		\range, 0.000007 * Pseg(Pseq([0.7,3],inf),32),
		\amp, Pkey(\amp) * Pseg(Pseq([1,0.7],inf),32),
		\isRest, Pseq([
			1,0.8,0.5,0,
			1,0.8,0.5,0,

			0,0.6,0.9,0.5,
			0,0.6,0.9,0.5,

			1,0,0.2,0,
			1,0,0.4,0,

			0,0.6,0.0,0.5,
			0,0.6,0.0,0.5,

			1,0.8,0.8,0.8,
			1,0.8,0,0,

			0,0.0,0.2,0.1,
			1,0.8,0,0,
		],inf).coin.not,
		\isRest, Pseq([
			1,0.8,0.8,0.8,
			1,0.8,0.8,0.8,

			1,0.8,0,0,
			1,0.8,0,0,

			0,0.0,0.2,0.1,
			0.5,0.0,0.0,0.1,
			0,0.0,0.0,0.0,
			0.5,0.0,0.2,0.1,
		],inf).coin.not,
		//Pseq([])

	) <>
	
	Pbind(
	\legato, 0.1,
	\isRest, Pseq([1,0,0.51,0, 1,0.3,0.3,0.4],inf).coin.not,
	\legato, Pseq([0.1,0.3,0.4,1],inf),
	\isRest, false,
	\pos, 0.2,
	\posenv, Pseq([
		Plazy({[Env([0,0.101.rand,0.2],[0.51,0.1])]}),
		[Env([0,0.101,0.2],[0.051,0.1])]
	],inf).stutter(2),
	\posenv, Pseq([
		[Env([0,0.001,0.02],[0.151,0.41])],
		[Env([0,0.401,0.2],[0.451,0.01])],
		[Env([0,0.101,0.2],[0.151,0.41])],
		[Env([0,0.101,0.4],[0.451,0.01])],

		[Env([0,0.101,0.02],[0.151,0.41])],
		[Env([0,0.401,0.2],[0.451,0.01])],
		[Env([0,0.101,0.2],[0.151,0.41])],
		[Env([0,0.101,0.4],[0.451,0.01])],

		[Env([0,0.101,0.02],[0.151,0.41])],
		[Env([0,0.151,0.4],[0.151,0.21])],
		[Env([0,0.101,0.2],[0.151,0.41])],
		[Env([0,0.001,0.1],[0.451,0.41])],

		[Env([0,0.101,0.02],[0.151,0.41])],
		[Env([0,0.151,0.4],[0.151,0.21])],
		[Env([0,0.101,0.2],[0.151,0.41])],
		[Env([0,0.001,0.1],[0.451,0.41])],
	],inf).stutter(4),
	\posenv, Pseq([
		Plazy({
			Pseq([


		[Env([0,0.001+0.0001.rand,0.02],[0.151,0.41])],
		[Env([0,0.001+0.0001.rand,0.02],[0.151,0.41])],

		[Env([0,0.011+0.0001.rand,0.02],[0.151,0.41])],
		[Env([0,0.011+0.0001.rand,0.02],[0.151,0.41])],

		[Env([0,0.001+0.0001.rand,0.02],[0.151,0.41])],
		[Env([0,0.001+0.0001.rand,0.02],[0.151,0.41])],

		[Env([0,0.011+0.0041.rand,0.02],[0.151,0.41])],
		[Env([0,0.011+0.0041.rand,0.02],[0.151,0.41])],

			])
		})
	],inf).stutter(1),
	\freq, Pseq([1000,100],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],

		[ Env.adsr(0.01,0.1,0.8,0.12) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.12) ],
		[ Env.adsr(0.01,0.1,0.8,0.12) ],
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.12) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.12) ],
		[ Env.adsr(0.01,0.1,0.8,0.12) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
		[ Env.adsr(0.01,0.1,0.8,0.02) ],
	],inf),
	\range, 0.00001 / Pseq([100],inf),
	\legato, Pseq(~seqmod.(0.1 ! 16, 4, 0.3 ! 4),inf),
	\legato, Pseq(~seqmod.(0.1 ! 16, 4, 0.3 ! 4),inf),
	\legato, Prand(~seqmod.(0.1 ! 16, 4, 0.3 ! 4),inf),
	\legato, 0.1,
	\isRest, Pseq([
		1,0, 1,0.51,
		0.5,0, 0,0.51,
	],inf).coin.not,
	//\lag, Pseq([0, -0.1],inf),
	\dur, 1/8,
	\lag, Pseq([
		0,0,0,0,
		0,0,0,0,
		0.2,0.2,0.2,0.2,
		0.2,0.2,0.2,0.2,
	 ],inf),
	\isRest, Pseq([
		1,0,0.51,0, 1,1,1,0.3,
		0,0,0,0, 0,0,0,0,
		0,0,0,0.3, 0.43,0.3,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,1, 1,0.51,
	],inf).coin.not,
	\lag, 0,
	\amp, 8.0 * Pkey(\amp) * 1,
));
)

// END
Pdef(~name).clear
Pdef(~name+++\pre).clear
Ndef(~name+++\fx).clear

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })

~kill_nodes_by_name.(\oscsampler);
