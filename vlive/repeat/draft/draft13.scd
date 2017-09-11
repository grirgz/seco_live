

~t = 140/2/60; TempoClock.default.tempo = ~t;


(
// death channel
BufDef(\amen, "vipere/amenbreak.wav");
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
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
			\sustain, 0.12,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('loop/funky8_96bpm.flac'),
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\pos, 1,
			\speed, 1,
			\hpmix, 1,
			\lpmix, 0,
			\hpf, 1000,
			\pos, Prand([0,2],inf)*( 137/60 ),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Prand([
					
					Pseq([ 1,0,1,0, 1,0,0,1, ],1),
					Pseq([ 1,0,0,1, 1,1,0,1, ],1),
					Pseq([ 1,0,1,1, 0,1,1,1, ],1),
					Pseq([ 1,1,1,1, 1,1,1,1, ]/2,1),
				],1),
			],inf).coin.not,
			\sustain, Prand([
				2,1,3,4
			],inf)/14,
			\legato, 1,
			\gain, 1/4,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \o3bass,
			\degree, Pseq([
				0, 1s, 1, 0, 
			],inf),
			\osc1voices, [[2,1,1.01]],
			\osc2voices, [[2,1,1.01]],
			\osc3voices, [[2,1,1.01]],
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\lpenv, Pseq([
				[ Env([4,1/4,1,1],[0.04,0.14,0.8]) ],
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1
		),
		//Pbind(
		//	\instrument, \o3bass2,
		//	\degree, Pseq([
		//		0, 1s, 1, 0, 
		//	],inf),
		//	\osc1voices, [[2,1,1.01]],
		//	\osc2voices, [[2,1,1.01]],
		//	\osc3voices, [[2,1/2,1.01]],
		//	\adsr, Pseq([
		//		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		//	],inf),
		//	\lpenv, Pseq([
		//		[ Env([1,4,1,1],[0.1,0.14,0.8]) ],
		//		Pfuncn({ arg ev;
		//			[ Env([1,4.0.rand,1,1],[0.8.rand,0.84.rand,0.8]) ];
		//		}),
		//	],inf),
		//	\lpfr, ~pmodenv.( Pseq([
		//		1/2,1,1.4,2
		//	],inf), 8),
		//	\octave, 5,
		//	\dur, 1,
		//	\amp, 0.1/2,
		//);
	])
).play;
)


(
SynthDef(\o3bass2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var osc1detune=\osc1detune.kr(0), osc1voices=\osc1voices.kr([1,1,1]), osc1gain=1, osc1amps = \osc1amps.kr([1,1,1]);
	var osc2detune=\osc2detune.kr(0), osc2voices=\osc2voices.kr([1,1,1]), osc2gain=1, osc2amps = \osc2amps.kr([1,1,1]);
	var osc3detune=\osc3detune.kr(0), osc3voices=\osc3voices.kr([1,1,1]), osc3gain=1, osc3amps = \osc3amps.kr([1,1,1]);
	env1 = EnvGen.kr(\lpenv.kr(Env([2,1.2,1,1/2],[0.011,0.1,1.7])), 1);
	sig = Saw.ar(freq * osc1voices + osc1detune) * osc1amps * osc1gain;
	sig = sig + SinOsc.ar(freq * osc2voices + osc2detune) * osc2amps * osc2gain;
	sig = sig + Pulse.ar(freq * osc3voices + osc3detune) * osc3amps * osc3gain;
	sig = sig /3;
	sig = LPF.ar(sig, \lpfr.kr(2.1) * env1.poll * freq);
	sig = ( sig*2 ).tanh * 2;
	sig = HPF.ar(sig, 30);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.4,0.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	lpenv: XEnvSpec( ControlSpec(0,8,\lin) ),
	lpfr: ControlSpec(0,8,\lin),
	osc1amps: XArraySpec(\unipolar),
	osc2amps: XArraySpec(\unipolar),
	osc3amps: XArraySpec(\unipolar),
	osc1detune: ControlSpec(-10,10,\lin),
	osc2detune: ControlSpec(-10,10,\lin),
	osc3detune: ControlSpec(-10,10,\lin),
))).add;
);



Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 4*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Prand([0,2],inf)*( 137/60 ),
			\legato, 1,
			\gain, 1/4,
			\dur, 1/4,
			\amp, 0.1
		),
	])
).play;



(
	~t = 185/1/60; TempoClock.default.tempo = ~t;
Pdef(\amen, 
	Pbind(
			\instrument, \playersec_looper,
			\bufnum, BufDef(\amen),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\degree, Pseq([0],inf),
			\speed, 2*~t/(137/60),
			\speed, 1*~t/(185/60),
			\speed, 1,
			\legato, 1,
			\gain, 1/4,
			\amp, 0.1
	) <>
	Pseq([
		Pbind(
			\pos, Pseq([0],2)/( 137/60 ),
			\dur, 2,
		),
		Pfindur(4,Pbind(
			\pos, Pseq([2],inf)*( 137/60 )+0.04,
			\trigfreq, Prand([
				1,2,4,8,16,32,64,
				1/16, 1/16, 1/16, 1/16, 1/16,
			],inf)/8*~t,
			\dur, PdurStutter(Prand([1,2,4],inf), 1),
		)),
	],inf),
).play;
);



(
SynthDef(\playersec_looper, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var trigger = Impulse.kr(\trigfreq.kr(0));
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
)

////////////////////////////////



(
// death channel
BufDef(\amen, "vipere/amenbreak.wav");
r = \r;
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.171,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (0.60 * Pseq([-1,1],inf))),
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
			\sustain, 0.12,
			\dur, 1/8,
			\gain, 1/2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
	])
).play;
)

(
SynthDef(\swirl, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr( Env([1,2,1,1/2],[0.1,0.1,1.8]) ), 1);
	env2 = EnvGen.kr(\env2.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env3 = EnvGen.kr(\env3.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env4 = EnvGen.kr(\env4.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env5 = EnvGen.kr(\env5.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	freq = freq * env5;
	//sig = Pulse.ar(freq * ( 1 + ( SinOsc.ar((1..8) * env1) * (1..8) * env1 ))).mean;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar((1..8) * env4) * (1..8)*\fmamp.kr(1/2) * env1 ))).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(2.1) * freq * env3 ).clip(20,20000), \rq.kr(0.5));
	sig = sig + FreqShift.ar(sig, 0.1 * SinOsc.kr(1 * env2).range(0,100));
	sig = ( sig * env2 * 2).tanh /2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\swirl, 
	Pseq([
		Pfindur(4,
			Ppar([
				Pbind(
					\instrument, \swirl,
					\freq, 200,
					\env1, [ Env([1,2,1,1],[0.01,0.04,0.1]) ],
					\env2, [ Env([1,10,1,1],[0.1,0.1,0.1]) ],
					\dur, 4,
					\amp, 0.2
				),
				Pbind(
					\instrument, \swirl,
					\freq, 800,
					\env1, [ Env([1,2,1,3],[0.01,0.04,0.1]) ],
					\env2, [ Env([1,10,1,1],[0.1,0.1,0.1]) ],
					\isRest, Pseq([
						0,0,1,0,
					],inf).coin.not,
					\dur, 1/2,
					\amp, 0.1,
				),
			]),
		),
		Pfindur(4,
			Ppar([
				Pbind(
					\instrument, \swirl,
					\freq, 200,
					\env1, [ Env([1,2,1,2],[0.01,0.04,1.1]) ],
					\env2, [ Env([1,10,1,1],[0.1,0.1,0.1]) ],
					\dur, 4,
					\amp, 0.2
				),
				Pbind(
					\instrument, \swirl,
					\freq, 800,
					\env1, [ Env([1,2,1,3],[0.01,0.04,0.1]) ],
					\env2, [ Env([1,10,1,1],[0.1,0.1,0.1]) ],
					\isRest, Pseq([
						0,0,1,0,
					],inf).coin.not,
					\dur, 1/2,
					\amp, 0.1,
				),
			]),
		),
	],1),
).play;
)

(
Pdef(\swirl, 
	Pseq([
		Pfindur(
			4+8,
			Ppar([
				Pbind(
					\instrument, \swirl,
					\freq, 200,
					\env1, [ Env([1,1,1,1]/175,[0.01,0.44,0.1]) ],
					\env2, [ Env([1,1,1,1],[0.2,0.1,0.1]) ],
					\env3, [ Env([1,1,1,1],[0.2,0.1,0.1]) ],
					\env4, [ Env([1,1,1,1]*2,[0.2,0.1,0.1]) ],
					\env5, [ Env([1,1/2,2,1]/2,[0.2,0.1,0.1]) ],
					\dur, 1/4,
					\fmamp, 1,
					\lpfr, ~pmodenv.(Pseq([1.11,1.7,2.5,4],inf), 4),
					\legato, Pseq([
						3,0,0,0, 0,0,1,0,
						6,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\amp, 0.2
				),
			]),
		),
		Pfindur(4,
			Ppar([
				Pbind(
					\instrument, \swirl,
					\freq, 200,
					\env1, [ Env([1,1,8,4]/175,[0.01,0.44,0.1]) ],
					\env2, [ Env([1,4,1,1],[0.2,0.1,0.1]) ],
					\env3, [ Env([1,1,1,8],[0.2,0.1,0.1]) ],
					\env4, [ Env([1,1,4,1]*2,[0.2,0.1,0.1]) ],
					\env5, [ Env([1,1/2,2,1]/2,[0.2,0.1,0.1]) ],
					\dur, 1/8,
					\fmamp, 1,
					\legato, Pseq([
						12,0,0,0, 0,0,0,0, 0,0,0,0, 3,0,0,0,
						2,0,0,3, 0,0,1,0, 6,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\amp, 0.2
				),
			]),
		),
	],inf),
).play;
)

(
Pdef(\swirl, 
	Pseq([
		Pfindur(
			4+8,
			Ppar([
				Pbind(
					\instrument, \swirl,
					\freq, 200,
					\env1, [ Env([1,1,1,1]/175,[0.01,0.44,0.1]) ],
					\env2, [ Env([1,8,1,1],[0.2,0.1,0.1]) ],
					\env3, [ Env([1,1,1,1],[0.2,0.1,0.1]) ],
					\env4, [ Env([1,1,1,1]*2,[0.2,0.1,0.1]) ],
					\env5, [ Env([1,2,1,1.5]/2,[0.04,0.04,4.1]) ],
					\dur, 1/4,
					\fmamp, 1,
					\lpfr, ~pmodenv.(Pseq([1.11,1.7,2.5,4],inf), 4),
					\legato, Pseq([
						3,0,0,0, 0,0,1,0,
						6,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\amp, 0.2
				),
			]),
		),
		Pfindur(4,
			Ppar([
				Pbind(
					\instrument, \swirl,
					\freq, 200,
					\env1, [ Env([1,1,8,4]/175,[0.01,0.44,0.1]) ],
					\env2, [ Env([1,4,1,1],[0.2,0.1,0.1]) ],
					\env3, [ Env([1,1,1,8],[0.2,0.1,0.1]) ],
					\env4, [ Env([1,1,4,1]*2,[0.2,0.1,0.1]) ],
					\env5, [ Env([1,1/2,2,1]/2,[0.2,0.1,0.1]) ],
					\dur, 1/8,
					\fmamp, 1,
					\legato, Pseq([
						12,0,0,0, 0,0,0,0, 0,0,0,0, 3,0,0,0,
						2,0,0,3, 0,0,1,0, 6,0,0,0, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\amp, 0.2
				),
			]),
		),
	],inf),
).play;
)
