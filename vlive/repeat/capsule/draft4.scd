

(
SynthDef(\playersec_var, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=1, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var curv = 0;
	var lag = 0.31;
	env1 = EnvGen.kr(Env([0,1],[1]/8/~t,curv), \trig.tr(1)).lag(lag);
	env2 = EnvGen.kr(Env([1,0],[1]/8/~t, 0-curv), \trig.tr).lag(lag);
	env3 = SelectX.kr(\dir.kr(1), [env1, env2]);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed * env3, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;

Pdef(\drems, 
	Ppar([
		Pbind(\instrument, \playersec_var,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/clean3_135bpm.flac'),
			\pos, Pseq([
				0,0.4,
			],inf)+Pseq([
				1,2,2,4, 1.4,1.24,4,4,
			],inf).stutter(2),
			\pos, 12/8/~t+0.04 + Pseq([0,0,0,0.2],inf),
			\speed, Pseq([
				1,1, 1,-1,
				1,-1, 1,1,
				1,-1, 1,-1,
				1,-1, -1,-1,
			],inf)*1.2,
			\dir, Pseq([1,0],inf),
			\legato, Pseq([
				Pser([
					1.8,1.8, 0.8,0.8,
					0,0,0,0, 0,0,0,0,
				],inf),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
			\gain, 1/3,
		),
		PmonoArtic( \playersec,
			\bufnum, BufDef('loop/clean3_135bpm.flac'),
			\pos, Pseq([
				Pseq([0]),	
			],inf)/8/~t + 0.04,
			\speed, 1,
			\legato, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic( \playersec,
			\bufnum, BufDef('loop/clean3_135bpm.flac'),
			\pos, Pseq([
				Pseq([12]),	
			],inf)/8/~t + 0.04,
			\legato, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic( \playersec,
			\bufnum, BufDef('loop/clean6_135bpm.flac'),
			\pos, Pseq([
				Pseq([2,4.0]),	
			],inf)/8/~t + 0.04,
			\legato, Pseq([
				0.1, 0.0, 1.1, 0.0,
				0.1, 0.0, 1.1, 0.0,
				0.1, 0.0, 1.1, 0.0,
				0.1, 1.1, 0.1, 1.1,

				0.1, 0.1, 1.1, 1.1,
				0.1, 0.8, 1.1, 1.1,
				0.1, 0.1, 1.1, 1.1,
				0.1, 1.1, 0.1, 1.1,

				0.1, 0.0, 1.1, 0.0,
				0.4, 0.0, 0.4, 0.2,
				0.1, 0.0, 1.1, 0.0,
				0.1, 1.1, 0.1, 1.1,

				0.1, 0.1, 1.1, 1.1,
				0.1, 0.8, 1.1, 1.1,
				0.1, 0.1, 1.1, 1.1,
				0.1, 1.1, 0.1, 1.1,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
		PmonoArtic( \playersec,
			\bufnum, BufDef('loop/clean3_135bpm.flac'),
			\pos, Pseq([
				Pseq((0..15))	
			],inf)/8/~t + 0.04,
			\speed, 0.8,
			\legato, Pseq([
				Pser([
					1
				],1),
				0.1,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),

		
	])
).play;
);
