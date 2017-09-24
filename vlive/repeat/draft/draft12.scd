
~t = 160/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\sinbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1.2,1/2],[0.011,1.7]), 1);
	sig = LFSaw.ar(freq * env1 * [1,1/2,1.005]) * [1,1,1];
	//sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	//sig = BPF.ar(sig, freq/2, 0.1) * 3 + sig;
	sig = sig + SinOsc.ar(freq); 
	sig = LPF.ar(sig, \lpfr.kr(2.1) * env1 * freq);
	sig = ( sig*2 ).tanh * 3;
	sig = HPF.ar(sig, 30);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.4,1.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pico, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1.2,1.001,1],[0.01,0.01,1]), 1);
	sig = SinOsc.ar(freq * [1,1/2,2]) ;
	sig = LFSaw.ar(freq * [1,2 * env2, 1/2]) + sig /4;
	sig1 = sig;
	sig1 = LPF.ar(sig1, freq * 4 * env1);
	sig1 = HPF.ar(sig1, freq * env1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = sig + sig1 /1;
	sig = BRF.ar(sig, freq, 1/2);
	sig = HPF.ar(sig, 400);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.04,0.1,0.8,0.4)),gate,doneAction:2);
	sig = sig.sum;
	sig = DelayC.ar(sig, 0.01, [ 0.0001,0 ], 1);
	sig = sig /8;
	//sig = Pan2.ar(sig, pan, amp).sum;
	//sig = Splay.ar(sig, 1, amp, pan);
	Out.ar(out, sig);
}).add;
);
		(
		Pbind(
			\instrument, \sinbass,
			\degree, Pseq([0],inf),
			\octave, 3,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 4,
			\dur, 1/4,
			\amp, 0.1
		).play
		)

(
// tyler yonker
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,1, 1,0,0,1,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([1,4],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\amen),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
			\pos, 0.50,
			\speed, 1.2,
			\sustain, 0.1,
			\lpmix, 1,
			\hpmix, 1,
			\lpf, 9300,
			\hpf, 4300,
			\gain, 0.15,
			\adsr, Prand([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\sustain, 0.1,
			\gain, Pkey(\gain) * Pseq([
				0.8, 0.2,
			],inf).stutter(1),
			\lag, 1/8,
			\dur, 1/4,
			\amp, 0.1,
		)),
		Pseq([
			Pfindur(8,Pdef(\firsthat, PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.mono('heavy/kick1.flac'),
				\bufnum, BufDef('heavy/kick1.flac'),
				\bufnum, BufDef(\amen),
				\isRest, Pseq([
					0,1, 1,1,
				],inf).coin.not,
				\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				//\pos, 0.49,
				\grate, 100,
				\isRest, Pseq([
					0,1,0,1,
				],inf).coin.not,
				\lpmix, 1,
				\hpmix, 1,
				\lpf, 9300,
				\hpf, 4300,
				\isRest, Pseq([
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.61,1,0.61,

					1,0.41,1,0.41,
					1,0.81,1,0.81,
					1,0.41,1,0.81,
					1,0.41,1,0.41,
					//1,1,1,1,
				],inf).coin.not,
				//\grate, ~pmodenv.(Pseq([0,0.2,0.3,0.6],inf)*1317, 1/4),
				\sustain, 0.11/1 * Pseq([0.5,1],inf).stutter(1) * Prand([1,1/2,0.7,1.5],inf),
				\speed, 1.2,
				\dur, 1/4,
				\dur, Pkey(\dur) * (1 + (-0.15 * Pseq([-1,1],inf))),
				\gain, 0.15,
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.1,0.1,0.8,0.01) ],
				],inf),
				\sustain, 0.1,
				\gain, Pkey(\gain) * Pseq([
					0.8, 0.2,
				],inf).stutter(1),
				\amp, 0.1,
			)))),
			Pfindur(4,PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\instrument, \playersec_hlpf,
				\bufnum, BufDef.mono('heavy/kick1.flac'),
				\bufnum, BufDef('heavy/kick1.flac'),
				\bufnum, BufDef(\amen),
				\isRest, Pseq([
					0,1, 1,1,
				],inf).coin.not,
				//\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				\pos, 0.49,
				\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
				\grate, 100,
				\isRest, Pseq([
					0,1,0,1,
				],inf).coin.not,
				\lpmix, 1,
				\hpmix, 1,
				\lpf, 9300,
				\hpf, 4300,
				\isRest, Pseq([
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.41,1,0.41,
					1,0.61,1,0.61,

					1,0.41,1,0.41,
					1,0.81,1,0.81,
					1,0.41,1,0.81,
					1,0.41,1,0.41,
					//1,1,1,1,
				],inf).coin.not,
				//\grate, ~pmodenv.(Pseq([0,0.2,0.3,0.6],inf)*1317, 1/4),
				\sustain, 0.11/1 * Pseq([0.5,1],inf).stutter(1) * Prand([1,1/2,0.7,1.5],inf),
				\speed, 1.2,
				\dur, 1/4,
				\dur, Pkey(\dur) * (1 + (-0.15 * Pseq([-1,1],inf))),
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
					[ Env.adsr(0.01,0.1,0.8,0.051) ],
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
					[ Env.adsr(0.1,0.1,0.8,0.01) ],
				],inf),
				\adsr, Prand([
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],inf),
				\sustain, 0.1,
				\gain, 0.20,
				\gain, Pkey(\gain) * Pseq([
					0.8, 0.2, 0.8, 0.2, 0.8, 0.8, 0.2, 0.2,
					0.8, 0.8, 0.2, 0.2, 0.8, 0.8, 0.7, 0.2,
				],inf).stutter(1),
				\isRest, Pseq([
					1,0,1,1, 0,1,1,0,
					0,1,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			))),
			Pfindur(4, Pbind(
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
			) <> Pdef(\firsthat)),
		],inf),
		Pbind(
			\instrument, \sinbass,
			\degree, Pseq([
				1s,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4s,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,4s,1s,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,

				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,0,0,
					
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
				],inf),
			],inf).coin.not,
			\legato, Pseq([
				10,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1/2,1,1,1, 1/2,1,1,1,
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.001,0.1,0.8,1.1) ],
				[ Env.adsr(0.001,0.1,0.8,0.6) ],
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf).stutter(8),
			\dur, 1/4,
			\amp, 0.1
		),
		Pbind(
			\instrument, \pico,
			\degree, Pseq([
				r,r,r,r, r,r,r,r,
				r,r,r,r, 1,1,1,1,
				1s,r,r,r, r,r,r,r,
				r,r,r,r, 1,1,1,1,
			],inf) + [0,-3],
			\dur, 1/2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \pico,
			\degree, Pseq([
				r,r,r,r, r,r,r,r,
				r,r,r,r, 1s,r,r,1s,
				r,r,r,r, r,r,r,r,
				r,r,r,r, 1s,1s,r,1s,
			].rotate(-1),inf),
			\lag, 1/4 + (1/40),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, 0.1,
			\dur, 1/2,
			\amp, 0.1/2,
		),
	])
).play;
)

		Pbind(
			\instrument, \pico,
			\degree, Pseq([
				r,r,r,r, r,r,r,r,
				r,r,r,r, 1,1,1,1,
				1s,r,r,r, r,r,r,r,
				r,r,r,r, 1,1,1,1,
			],inf),
			\dur, 1/2,
			\amp, 0.1
		),
PatKitDef(\sample1).edit
		(
			Pdef(\note,
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				r,r,r,r, r,r,r,r,
				r,r,r,r, -1,-1,-1,-1,
				0,r,r,r, r,r,r,r,
				r,r,r,r, -1,-1,-1,-1,
			],inf),
			\dur, 1/2,
			\amp, 0.1
		)).play;
		)
	
ProtoDef(\piano).startControl(Pdef(\note))

//////////////////////////////////////////
(
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,1, 1,0,0,0,
				0,0,0,1, 1,0,0,1,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, Pseq([1,4],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,0,0,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\amen),
			\pos, 0.51 + Pseq([0,0,0.05,0],inf),
			\pos, 0.51,
			\speed, 1.2,
			\sustain, 0.1,
			\lpmix, 1,
			\hpmix, 1,
			\lpf, 9300,
			\hpf, 4300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf).stutter(2),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\gain, 0.15,
			\gain, Pkey(\gain) * Pseq([
				0.8,
			],inf).stutter(1),
			\dur, 1/8,
			\dur, PdurStutter(Prand([1,1,2,4,8],inf), 1),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\instrument, \playersec_hlpf,
			\bufnum, BufDef(\amen),
			\pos, 0.51 + Pseq([0,0,0.05,0],inf),
			\pos, 0.81,
			\speed, 1.2,
			\sustain, 0.1,
			\lpmix, 1,
			\hpmix, 1,
			\lpf, 7300,
			\hpf, 5300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf).stutter(2),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\gain, 0.15,
			\gain, Pkey(\gain) * Pseq([
				0.8,
			],inf).stutter(1),
			\dur, 1/8,
			\dur, PdurStutter(Prand([1,1,2,4,8],inf), 1),
			\amp, 0.1,
		)),
	])
).play;
)

(
	// bizar ritm
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0, 0,0, 1,0, 0,0,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,
			],inf).coin.not,
			\sustain, Pseq([1,4],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.101,
			\dur, 1/8,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\gain, 1/3,
			\amp, 0.1,
		)),
	])
).play;
)

(
	// poly ritm
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\dur, 1/(1..9).choose*4,
			\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,1
			],inf).coin.not,
			\sustain, Pseq([1,1.1],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\dur, 1/(1..9).choose*2,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\sustain, 0.101,
			\dur, 1/8,
			\dur, 1/(1..9).choose * 2,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/(1..9).choose,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/(1..9).choose * 2,
			\gain, 1/3,
			\amp, 0.1,
		)),
	])
).play;
)

(
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.101,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,1
			],inf).coin.not,
			\sustain, Pseq([1,1.1],inf).stutter(16) * 0.111,
			\dur, 1/1,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/(1..9).choose,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\sustain, 0.101,
			\speed, 1.21,
			\dur, 1/(1..9).choose /2,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\sustain, 0.101,
			\speed, 1.26,
			\dur, 1/(1..9).choose,
			\gain, 1/3,
			\amp, 0.1,
		)),
	])
).play;
)

(
	// poly ritm repeated
r = \r;
Pdef(\fadrum, 
	Pfindur(2,
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			\dur, 1/(1..9).choose*4,
			\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
			\gain, 0.6,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,1
			],inf).coin.not,
			\sustain, Pseq([1,1.1],inf).stutter(16) * 0.111,
			\dur, 1/8,
			\dur, 1/(1..9).choose*2,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\sustain, 0.101,
			\dur, 1/8,
			\dur, 1/(1..9).choose * 2,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/(1..9).choose,
			\gain, 1/3,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/(1..9).choose * 2,
			\gain, 1/3,
			\amp, 0.1,
		)),
	])
	).loop
).play;
)
