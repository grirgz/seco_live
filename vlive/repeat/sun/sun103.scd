
// remix draft5 mr brown
(
~t = 93/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
)

// 8 beats: one chord, total 32

(
SynthDef(\brownbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(16) * freq ).clip(20,20000), \rq.kr(0.6)) + ( sig / 5 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\brownkick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fenv;
	fenv = EnvGen.kr(Env([210,freq,freq],[0.045,4.0]), 1);
	sig = LFPulse.ar(fenv);
	sig = RLPF.ar(sig, ( \lpfr.kr(16) * freq ).clip(20,20000), \rq.kr(0.6)) + ( sig / 5 );
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=1, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \brownkick,
			\dur, 1/8,
			\note, Pseq([
				3,3,3,3, 0,0,0,0,
				0,7,0,7, 0,0,0,0,
			],inf),
			\octave, 3,
			\sustain, 0.1/6,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \brownbass,
			\note, Pseq([
				3,3,3,3, 0,0,0,0,
				0,7,0,7, 0,0,0,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,0,1, 0,0,1,0,
				1,0,1,0.51, 0,0,1,0.5,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


//////////////////////////////////////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			\brownbass,
			\degree, Pseq([1b,-3b,-2b, -3b],inf),
			\legato, Pseq([
				1,1,1,1, 0.2,0,0,0,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1,
			\amp, 0.1
		),
		Pbind(
			// chords
			\instrument, \organ_tonewheel0,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				1-12,
				[1-12,1,5,8],
				[1,5-12,8-12],
				1-12,
				[1,6,10],
				[1,6-12,10-12],
				3-12,
				[3,8,12, 0],
				[3,8-12,12-12, 0-12],
				1-12,
				[1,6,10, -2],
				[1,6-12,10-12, -2-12],
			],inf).stutter(Pseq([4,3,1],inf)),
			\isRest, Pseq([
				0,1,0,0,
				0,0,1,0,
				1,0,1,0,
				0,0,1,1,
			],inf).coin.not,
			\legato, Pseq([
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

			],inf)*0.8,
			\octave, 6,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2169].value,
			\bufnum, ~buflib.snare[1716].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,5,7,5,
			],inf)+1,
			\legato, Pseq([
				1,1,1,1, 0.2,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(4.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,4,
			],inf)+1,
			\legato, Pseq([
				1,0.5,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 6,
			\dur, 1/2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[372].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);

(
// no hat in original, add anyway
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			\brownbass,
			\degree, Pseq([1b,-3b,-2b, -3b],inf),
			\legato, Pseq([
				1,1,1,1, 0.2,0,0,0,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1,
			\amp, 0.1
		),
		Pbind(
			// chords
			\instrument, \organ_tonewheel0,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				1-12,
				[1-12,1,5,8],
				[1,5-12,8-12],
				1-12,
				[1,6,10],
				[1,6-12,10-12],
				3-12,
				[3,8,12, 0],
				[3,8-12,12-12, 0-12],
				1-12,
				[1,6,10, -2],
				[1,6-12,10-12, -2-12],
			],inf).stutter(Pseq([4,3,1],inf)),
			\legato, Pseq([
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

			],inf)*0.8,
			\octave, 6,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2169].value,
			\bufnum, ~buflib.snare[1716].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,5,7,5,
			],inf)+1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0.2,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(4.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,4,
			],inf)+1,
			\legato, Pseq([
				1,0.5,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 6,
			\dur, 1/2,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[372].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,
				0,1,1,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[925].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0, 1,0,1, 0,0,0, 1,0,0,
				0,0,0, 1,0,1, 0,0,0, 1,0,1,
				1,1,0, 1,0,1, 0,0,0, 1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/12,
			\gain, 0.2 * Pseq([
				1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.9,
				1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.8, 1,0.7,0.2,
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[925].value,
			\bufnum, ~buflib.hat[1735].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//1,0,1, 1,0,0, 0,0,0, 1,0,1,
				//0,0,1, 1,0,1, 0,0,0, 1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					//0.4,0,1,0, 0.4,0,1,0.1,
					//0.4,0,1,0.1, 0,0,1,0,
					0,0,1,0.1, 0,0,1,0,
				   	0,0,1,0, 0.4,0,1,0.1,
				   	0,0,1,0, 0.4,1,0.1,1,
					0.4,0,1,0.1, 0,0,1,0,

				],inf),
				0,0,1,0, 0,0,1,0.3,
				0,0.4,1,0, 0,0,1,0,
				0.4,0,1,0, 0,0.8,1,0.3,

				//0,0,1,0, 0,0,0.5,0.3,
				//0,1,1,0, 0,0,0.5,0.3,

				//0,0,1,0, 0,0,0.5,0.3,
				//0,0,1,0, 0,0,0.5,0.3,
				//0,0,1,0, 0,0,0.5,0.3,
				//0,1,1,0, 0,0,0.5,0.3,

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.2 * Pseq([
				Pkey(\legato)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[925].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0, 1,0,0, 0,0,0, 1,0,0,
				//1,0,1, 1,0,0, 0,0,0, 1,0,1,
				//0,0,1, 1,0,1, 0,0,0, 1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/12,
			\gain, 0.2 * Pseq([
				1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.9,
				1,0.7,0.2, 1,0.7,0.2, 1,0.7,0.8, 1,0.7,0.2,
			],inf),
			\isRest, true,
		),
	])
)).play;
);

(
// try adding more chord
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			\brownbass,
			\degree, Pseq([1b,-3b,-2b, -3b],inf),
			\legato, Pseq([
				1,1,1,1, 0.2,0,0,0,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1,
			\amp, 0.1
		),
		Pbind(
			// chords
			\instrument, \organ_tonewheel0,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				1-12,
				[1-12,1,5,8],
				[1,5-12,8-12],
				1-12,
				[1,6,10],
				[1,6-12,10-12],
				3-12,
				[3,8,12, 0],
				[3,8-12,12-12, 0-12],
				1-12,
				[1,6,10, -2],
				[1,6-12,10-12, -2-12],
			],inf).stutter(Pseq([4,3,1],inf)),
			\legato, Pseq([
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

			],inf)*0.8,
			\octave, 6,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			// more chords
			\instrument, \organ_tonewheel2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				1-12,
				[1-12,1,5,8],
				[1,5-12,8-12],
				1-12,
				[1,6,10],
				[1,6-12,10-12],
				3-12,
				[3,8,12, 0],
				[3,8-12,12-12, 0-12],
				1-12,
				[1,6,10, -2],
				[1,6-12,10-12, -2-12],
			],inf).stutter(Pseq([0,8,0],inf)),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

			],inf)*0.4,
			\sus, Pkey(\sustain),
			\octave, [7,6,5,7],
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind( // subtle piano
			\instrument, \sh101,
			\note, Pseq([
				3, 1,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2169].value,
			\bufnum, ~buflib.snare[1716].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,5,7,5,
			],inf)+1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0.2,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(4.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,4,
			],inf)+1,
			\legato, Pseq([
				Pser([
					0
				],8*2),
				Pser([
					1,0.5,
				],8*2),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 6,
			\dur, 1/2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[372].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,
				0,1,1,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[925].value,
			\bufnum, ~buflib.hat[1735].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//1,0,1, 1,0,0, 0,0,0, 1,0,1,
				//0,0,1, 1,0,1, 0,0,0, 1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					//0.4,0,1,0, 0.4,0,1,0.1,
					//0.4,0,1,0.1, 0,0,1,0,
					0,0,1,0.1, 0,0,1,0,
				   	0,0,1,0, 0.4,0,1,0.1,
				   	0,0,1,0, 0.4,1,0.1,1,
					0.4,0,1,0.1, 0,0,1,0,

				],inf),
				0,0,1,0, 0,0,1,0.3,
				0,0.4,1,0, 0,0,1,0,
				0.4,0,1,0, 0,0.8,1,0.3,

				//0,0,1,0, 0,0,0.5,0.3,
				//0,1,1,0, 0,0,0.5,0.3,

				//0,0,1,0, 0,0,0.5,0.3,
				//0,0,1,0, 0,0,0.5,0.3,
				//0,0,1,0, 0,0,0.5,0.3,
				//0,1,1,0, 0,0,0.5,0.3,

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				Pkey(\legato)
			],inf),
		),
	])
)).play;
);

(
// rdn bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			\brownbass,
			\degree, Pseq([1b,-3b,-2b, -3b],inf),
			\legato, Pseq([
				1,1,1,1, 0.2,1,1,1,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			// chords
			\instrument, \organ_tonewheel0,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				1-12,
				[1-12,1,5,8],
				[1,5-12,8-12],
				1-12,
				[1,6,10],
				[1,6-12,10-12],
				3-12,
				[3,8,12, 0],
				[3,8-12,12-12, 0-12],
				1-12,
				[1,6,10, -2],
				[1,6-12,10-12, -2-12],
			],inf).stutter(Pseq([4,3,1],inf)),
			\legato, Pseq([
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0.3,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,0,1,0, 2,0,0.5,0.3,
				0,1,1,0, 2,0,0.5,0.3,

			],inf)*0.8,
			\octave, 6,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			// more chords
			\instrument, \organ_tonewheel2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				1-12,
				[1-12,1,5,8],
				[1,5-12,8-12],
				1-12,
				[1,6,10],
				[1,6-12,10-12],
				3-12,
				[3,8,12, 0],
				[3,8-12,12-12, 0-12],
				1-12,
				[1,6,10, -2],
				[1,6-12,10-12, -2-12],
			],inf).stutter(Pseq([0,8,0],inf)),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,

			],inf)*0.4,
			\sus, Pkey(\sustain),
			\octave, [7,6,5,7],
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind( // subtle piano
			\instrument, \sh101,
			\note, Pseq([
				3, 1,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2169].value,
			\bufnum, ~buflib.snare[1716].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,5,7,5,
			],inf)+1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0.2,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(4.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,4,
			],inf)+1,
			\legato, Pseq([
				Pser([
					0
				],8*2),
				Pser([
					1,0.5,
				],8*2),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\envamt, 3,
			\lpf, 200,
			\lpadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 6,
			\dur, 1/2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[372].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,1,
				0,1,1,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[925].value,
			\bufnum, ~buflib.hat[1735].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				//1,0,1, 1,0,0, 0,0,0, 1,0,1,
				//0,0,1, 1,0,1, 0,0,0, 1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					//0.4,0,1,0, 0.4,0,1,0.1,
					//0.4,0,1,0.1, 0,0,1,0,
					0,0,1,0.1, 0,0,1,0,
				   	0,0,1,0, 0.4,0,1,0.1,
				   	0,0,1,0, 0.4,1,0.1,1,
					0.4,0,1,0.1, 0,0,1,0,

				],inf),
				0,0,1,0, 0,0,1,0.3,
				0,0.4,1,0, 0,0,1,0,
				0.4,0,1,0, 0,0.8,1,0.3,

				//0,0,1,0, 0,0,0.5,0.3,
				//0,1,1,0, 0,0,0.5,0.3,

				//0,0,1,0, 0,0,0.5,0.3,
				//0,0,1,0, 0,0,0.5,0.3,
				//0,0,1,0, 0,0,0.5,0.3,
				//0,1,1,0, 0,0,0.5,0.3,

			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				Pkey(\legato)
			],inf),
		),
	])
)).play;
);


//////////// fun with time signatures


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[43].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0, 0,0,0, 0,0, 0,0,1,
				1,1, 0,0,1, 0,0, 0,0,0,
			],inf).coin.not,
			\dur, Pseq([1/2!2,1/3!3].flat,inf)/4,
			\gain, 0.1 * Pseq([
				1,0, 0,0,0, 0,0, 0,0,0,
			].linlin(0,1,0.7,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2240].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0, 0,0,0, 1,0, 0,0,0,
				0,0, 0,0,0, 1,1, 0,0,1,
				0,0, 0,0,0, 1,0, 1,0,1,
				0,0, 0,0,0, 1,0, 0,0,1,
			],inf).coin.not,
			\dur, Pseq([1/2!2,1/3!3].flat,inf)/4,
			\gain, 0.1 * Pseq([
				0,0, 0,0,0, 1,0, 0,0,0,
			].linlin(0,1,0.4,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[266].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0, 0,0,1, 1,1, 1,0,0,
					1,0, 1,0,1, 1,0, 1,0,1,
					1,0, 0,0,1, 1,1, 1,0,0,
					1,1, 1,0,1, 1,0, 1,1,1,
				],inf),

				1,0, 1,0,0, 1,0, 1,0,0,
				1,0, 1,0,1, 1,0, 1,0,1,
				1,1, 1,1,1, 1,0, 1,1,1,
				1,1, 1,1,1, 1,1, 1,1,1,
			],inf).coin.not,
			\dur, Pseq([1/2!2,1/3!3].flat,inf)/4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 0,0, 0,0,0, ],3),
				Pseq([ 0,0, 0,0,0, ])-1,
			],inf),
			\isRest, Pseq([
				1,1, 1,1,1, 1,0, 1,0,0,
				1,0, 1,0,0, 1,0, 1,0,1,
			],inf).coin.not,
			\dur, Pseq([1/2!2,1/3!3].flat,inf)/4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[43].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0, 1,0,0,  1,
				0,0,0, 1,0,0,  1,
			],inf).coin.not,
			\dur, Pseq([1/7].flat,inf),
			\gain, 0.1 * Pseq([
				1,0,0, 0,0,0,  0,
			].linlin(0,1,0.7,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2240].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0, 0,0,0, 0,
				1,0,0, 0,0,1, 0,
			],inf).coin.not,
			\dur, Pseq([1/7].flat,inf),
			\gain, 0.1 * Pseq([
				1,0,0, 0,0,0, 0,
			].linlin(0,1,0.4,1),inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[266].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0, 0,0,0, 1, 1,0,1, 1,1,1,1,
					0,0,0, 1,1,0, 0, 1,0,1, 1,0,1,0,
					0,0,0, 0,0,0, 0, 1,1,1, 1,1,1,1,
					0,0,0, 0,1,0, 1, 0,1,1, 1,0,0,0,
				],inf),
				1,1,1, 1,1,1, 0, 0,0,0, 0,0,0,0,
				1,0,1, 1,0,1, 0, 1,0,1, 0,1,0,0,
				0,0,0, 0,0,0, 0, 1,1,1, 1,1,1,1,
				0,0,0, 0,0,0, 0, 0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, Pseq([1/7].flat,inf)/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 0,0,0, 4,0,0, -3],3*2),
				Pseq([ 0,0,0, 0,0,0, 0],2)-1,
			],inf),
			\legato, Pseq([
				1,0,0, 0,0,0,0,
				0,0,1, 0,1,1,0,
				1,0,0, 0,0,0,0,
				0,0,0, 1,1,1,0,
				5,0,0, 0,0,0,0,
				0,0,1, 0,1,1,0,
				7,0,0, 0,0,0,0,
				0,0,0, 1,1,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pseq([1/7].flat,inf)/2,
			//\adsr, Pseq([
				//[ Env.adsr(0.8,0.8,0.5,0.1) ],
			//],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.8,0.8,0.5,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

{ SinOsc.ar(100) ! 2 * 0.1  }.scope
