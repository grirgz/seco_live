
~t = 82/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\pwbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fadsr.kr(Env.adsr(1.1,1.1,0.4,1.1, 1, -2)), gate, doneAction:0);
	env2 = SinOsc.ar(freq/2); 
	env3 = EnvGen.kr(\triadsr.kr(Env.adsr(3.1,2.1,1,1.1)), gate, doneAction:0);
	env4 = SinOsc.ar(freq * SinOsc.ar(freq*3/2, Rand(0,1.0),0.2,1), Rand(0,1.0)).range(1/2,2);
	env5 = EnvGen.ar(Env.triangle(0.1,1.1),gate,doneAction:0);
	env6 = SinOsc.ar(1/113, Rand(0,1.0))* env3;
	sig1 = Pulse.ar(freq * [0.003, -0.003].midiratio, SinOsc.ar(0.01)+[0.4,0.8* env6]  );
	sig2 = LFTri.ar(freq * ( env4 * env5 * 0.11 *Rand(0.9,1.1) + 1 )) * env3;
	sig2 = BPF.ar(sig2, freq, 0.7);
	sig2 = FreqShift.ar(sig2, 0.2) * 0.4 + sig2;
	sig3 = SinOsc.ar(freq);
	sig1 = RLPF.ar(sig1, \lpfr.kr(1.1/2) * freq * (env1 * 5 + 1) * (env2 * env1 * 0.4 + 1), \rq.kr(0.5));
	sig = [sig1*1,sig2 * 0.7, sig3 * 0.71].sum;
	sig = Latch.ar(sig, Impulse.ar(1440)) * 0.4 + sig;
	//sig = [sig2];
	//sig = Pulse.ar(freq, SinOsc.ar(0.01)+0.4 );
	//pan = pan + ( [-1,1]*0.3 );
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);
(
	~swing = 0.4;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \pwbass,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				0,
			],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\legato, 1,
			\lpfr,4,
			\envfamt,3,
			\octave,3,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[225].value,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[600].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.31,
				\out, BusDef(\sendbus3, \audio),
			),
		Pbind(
			\lag, 0.04,
			\amp, Pkey(\amp) * 0.5,
			\gain, Pkey(\gain) * 0.5,
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[225].value,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[600].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.snare[1785].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,1,1,
				],inf).coin.not,
				\sustain, 0.2,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[294].value, // click
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.31,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('vipere/milko.flac'),
				\pos, Pseq([1,2],inf).stutter(8),
				\legato, Pseq([
					4,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,3,0,0, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\gain, 1,
			)
		]),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
	])
)).play;
);

Help.gui

(
SynthDef(\warper, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = Warp1.ar(numChannels: 2, bufnum: \bufnum.kr(0), pointer: \pos.kr(0) * Line.kr(0,0.1,1), freqScale: \freqScale.kr(1), windowSize: 0.2, envbufnum: -1, overlaps: 8, windowRandRatio: 0.0, interp: 1, mul: 1, add: 0);
	sig = Warp1.ar(numChannels: 2, bufnum: \bufnum.kr(0), pointer: \pos.kr(0), freqScale: \freqScale.kr(1), windowSize: \windowSize.kr(0.2), envbufnum: -1, overlaps: \overlaps.kr(8), windowRandRatio: \windowRandRatio.kr(0.0), interp: \interp.kr(1), mul: 1, add: 0);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \warper,
			\bufnum, BufDef('vipere/milko.flac'),
			\freqScale, Pseq([1],inf),
			\pos, Pseg(Pseq([0],inf),8),
			\legato, 1,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, 
	Pdef(\warper, Pbind(\instrument, \warper)) <>
	Pbind(
		\instrument, \warper,
			\bufnum, BufDef('vipere/milko.flac'),
			\legato, 1,
		\degree, Pseq([0],inf),
		\dur, 1,
	)
).play;
);

WindowDef(\PdefEditor).front(Pdef(\warper))
