BufDef(\march, "vipere/march.flac");
BufDef(\oeuf, "field/oeuf.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\oeuf);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name+++\base, Pbind(
			\dur, (1/8),
			\isRest, Pseq([
				1,
			],inf).bcoin.not,
			\isRest, Pseed(1000.rand,Pseq([
				Pseq([
					Prand([
						Pseq([
							1,0,1,0, 1,0,1,0,
						]),
						Pseq([
							1,1,1,1, 1,0,1,0,
						]),
						Pseq([
							0,0,1,1, 0,0,0,0,
						]),
						Pseq([
							1,1,1,1, 1,1,1,1,
						]),

					])
				],inf),
			],inf)).bcoin.not,
			//\isRest, Pseq([
			//	Pseq([
			//		Pseq([0.0,1.0,0.0,0.0],1),
			//	],1).stutter(4),
			//],inf).trace,

));


Pdef(~name +++ \pre, 
	Ppar([
		Pdef(~name+++\base) <> Pbind(
			\instrument, ~name+++\snare,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.01], [-4, -2, -4]) ],
			\env1, [ Env.new([110, 73, 29], [0.005, 0.09], [-4, -5]) ],
			\fratio, 1,
			\amp, 0.4,
			//\pan, Pseq([
			//	Pser([0],17),
			//	Pwhite(-1.0,1.0,16-1)
			//],inf).stutter(1) * 0.5,
			\spread, 0.1,

		), 

		Pdef(~name+++\base) <> Pbind(
			\pos, 0.111,
			\freq, 1787,
			\range, 0.000001,
			\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
			\posenv, Pseq([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
				[ Env([0.00,0.007,0.004].integrate.postln,[0.01,0.8]) ],
			],inf),
			\legato, 0.15,
			\dur, 1/3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.5,0.04) ],
			],inf),
			\bufnum, ~buf,
			\rq, 0.1,
			\fshift, 0,
			\lpmix, 1,
			\ffreq, ~frozzer.(Pseq([100,5000,1200],inf), Pseq([0,0.5,0.5,0],inf).coin),
			\amp, 24.0 * Pkey(\amp),

		) 	
	])
);
)

// END

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })


~<>
		
		Pbind(
			\pos, Pseq([0.0,0.01,0.02,0.03],inf),
			\pos, Pseg(Pseq([0,0.1],inf),32)+0.8,
			\pos, 0.172,
			\posenv, Pseq([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				[ Env([0.001,0.002,0.004].integrate.postln,[0.01,0.1]) ],
				[ Env([0.001,0.003,0.004].integrate.postln,[0.01,0.1]) ],
				[ Env([0.101,0.0013,0.004].integrate.postln,[0.01,0.1]) ],
			],inf),
			\fshift, 0,
			\fshift, -48,
			\fshift, Pseq([0,48,-40],inf),
			\lpmix, 0.79,
			\rq, 0.1,
			\posenv, Pseq([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				[ Env([0.001,0.0089,-0.3481].integrate.postln,[0.01,0.1]) ],
			],inf),
			//\pos, Ndef(~name+++\lfo1),
			//\pos, Pseq([0,0.1,0.5],inf) + Pwhite(0,0.01),
			//\finepos, Ndef(~name+++\lfo1),
			//\range, Pseg(Pseq([0.001,0.21],inf),8),
			//\range, Ndef(~name+++\lfo2),
			\range, 0.0001,
			\ffreq, Pseq([100,300,200,200],inf),
			\ffreq, Pseq([60,1000,3000,200,2000],inf),
			\ffreq, Pseq([60,70,100,120],inf),
			\ffreq, Pseq([3000,120],inf),
			\ffreq, Pseq([6000,4000,120,300],inf),
			\ffreq, Pwhite(50,10000).stutter(16),
			//\ffreq, 2000,
			\bufnum, ~buf,
			\freq, Pseq([
				Pser([50,55],16),
				Pser([40,45],16-4),
				100,1040,120,300,
			],inf),
			\ffreqtab, Pseq([[Array.series(8,0.5,0.1).postln]],inf),
			\ffreqtab, Pn(Plazy({
				[{ 1.rand } ! 8]
			})),
			\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
			\ffreqtab, Pseq([
				[[2.3,3.2,0.1,0.1, 0.2,0.8,1.2,1.5]],
			],inf),
			\dur, 1/8,
			\pos, Pwhite(0.0,0.4).stutter(32),
			\pos, Pseq([0.1,0.1],inf).stutter(2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.5,0.01) ],
			],inf),
			\isRest, Pseq([1],inf).coin.not,
			\isRest, Pseq([
				Pser([1],1),
				Pser([0,0,0,0],4),
			],inf).coin.not,
			\legato, Pseq([1,0.4,1,0.3, Pn(1,4)],inf),
			\legato, Pseq([
				Pser([1,1,1,1],32-4),
				0.6,1.0,1.0,0.6
			],inf),
			\legato, Pseq([
				1,0.2,0.1,0.2,
				1,1,1,1,

				1,0.2,0.1,0.2,
				1,1,1,1,

				1,0.5,1,1,
				1,1,1,1,
			],inf),
			\legato, Pseq([
				Pser([
					1.0,1.3,0.9,0.8,
					1.0,0.3,0.9,0.3,
				], 64),
				Pser([1,1,1,1],32),
				Pser([1,0.31,1,1],32),
			],inf).collect({ arg x; if(x == 1) { 1 } { if(x.coin) { 1 } { x.rand + 0.1 } } }),
			\legato, Pseq([
				1,1,1,1,
				1,1,1,0.1,
			],inf).stutter(4),
			//\lag, Pseq([0.05, 0, 0.05, 0],inf) / t,
			\isRest, false,
		)
kill_nodes_by_name.(\oscsampler);
