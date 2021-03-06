BufDef(\march, "vipere/march.flac");
BufDef(\table, "field/table.flac");
(
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,0.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,1.9)).range(0,0.02) + 0.15  });
~buf = BufDef(\moeten);
~buf = BufDef(\table);
//Ndef(~name+++\lfo1, { Phasor.kr(0, (1/SampleRate.ir).poll *1, 0, 0.81) + 0.1 + LFPulse.kr(8).range(0,0.0001).lag(0.1)});
//Ndef(~name+++\lfo1, { 0.1 + LFPulse.kr(1).range(0,0.0008).lag(0.4)});
//Ndef(~name+++\lfo1, { LFSaw.kr(SinOsc.kr(1.1).range(0.01,8.9)).range(0,1.02) + 0.45  });
//Ndef(~name+++\lfo1, { LFSaw.kr(1.18).range(0,1.02) + 10.45  });
//Ndef(~name+++\lfo2, { LFSaw.kr(SinOsc.kr(1.12).range(0.01,4.9)).range(0.0001,0.0012)  });
Pdef(~name+++\base, Pbind(
			\dur, (1/8),
			\isRest, Pseq([
				Prand([
					Pseq([
						0,0,0,0,
						1,0,0,0,
						0,0,0,0,
						0,0,0,0,
					],1),
					Pseq([
						0,0,0.1,0,
						1,0,0,0,
						0,0,0,0,
						0,0,0,0,
					],1),
				],1),
			],inf).coin.not,
			\isRest, Pseed(100, Pseq([
				0.1,
			],inf).coin.not),
			//\isRest, Pstep(Pseq([0,1],inf),4).coin.not,
			\isRest, false,
			\dur, Pseg(Pseq([1/16,1/8],inf),4,\exp)*2,
			//\dur, Pgeom(1/2,1/1.2,16).loop.trace(prefix:"dur:"),

			\dur, Pseq( Array.geom(16,1/4,1/1.1), inf ),
			\dur, Pseq( 1/(1..16),inf ),

			\dur, Pseq(
				exp(Array.series(32,1/16,1/16)+0.21).reverse/16/2, inf
			),
			\isRest, Pseq([
				1,1,0,
			],inf).coin.not,
			\dur, Pkey(\dur).round(1/16).trace(prefix:"dur:"),

));

~pat = Ppar([
		Pdef(~name+++\base) <> Pbind(
			\instrument, ~name+++\kick,
			\env0, [ Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.41], [-4, -2, -4]) ],
			\env1, [ Env.new([110, 73, 29], [0.005, 0.09], [-4, -5]) ],
			\fratio, 1,
			\amp, 0.0,
			\isRest, true,
			\pan, Pseq([
				Pser([0],17),
				Pwhite(-1.0,1.0,16-1)
			],inf).stutter(1) * 0.5,
			\spread, 0.1,

		), 

		Pdef(~name+++\base) <> Pbind(
			\instrument, \oscsampler3,
			\pos, 0.014 + Pseq([0,1,0,2],inf).stutter(8)/100,
			\pos, 0.14474474475369,
			\freq, 418,
			\range, 0.000001,
			\ffreqtab, Pseq([[Array.geom(8,1.8,1.2).postln]],inf),
			\posenv, Prand([
				//[ Env([0.42,0.3903,0.3513],[0.3,0.4]) ],
				//[ Env([0.00,0.0189,0.401].integrate.postln,[0.01,0.1]) ],
				Prand([
					[ Env([0.00,0.000101,0.00181].integrate.postln,[0.07,1.4]) ],
					//[ Env([0.00,0.000401,0.00181].integrate.postln,[0.07,2.4]) ],
				],8),
			],inf).stutter(1),
			\legato, 0.2,
			\dur, 1/3,
			\isRest, false,
			\adsr, Pseq([
				Pfuncn({
					[ Env.adsr(0.01,0.3,0.5,0.2+0.05.rand) ];
				},1),
			],inf),
			\bufnum, ~buf,
			\rq, 0.1,
			//\fshift, Pwrand([0,-400,-300,200],[1.90, 0.1,0.1,0.1].normalizeSum,inf),
			\lpmix, 1,
			\ffreq, 200 + Pwhite(0.0,100),
			\ffreq, 988.43493629781,
			\amp, 49.0 * Pkey(\amp),

		) 	
	]);

Pdef(~name +++ \pre, 
	Pseq([
		Event.silent(4),
		Pfindur(4, ~pat),
	],inf)
);
)

// END

MIDIBoard.map(\s9, s.volume, \volume)

s.getQueryTree({ arg data; data.asCompileString.postln; })


