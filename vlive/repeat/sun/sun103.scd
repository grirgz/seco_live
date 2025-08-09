
// remix draft5 mr brown
(
~t = 93/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
)


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
			\amp, 0.1,
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
			\amp, 0.1,
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
