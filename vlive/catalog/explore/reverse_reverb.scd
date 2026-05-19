// record a sound then immediatly play it in reverse to avoid having to store audio file
~t = 120/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[385].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\verb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\reverse, \audio),
		),
		Pmono(\fxreverse,
			\inbus, BusDef(\reverse, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\bufnum, BufDef(\rev),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

BufDef(\rev, 2/~t * s.sampleRate, 2)
BufDef(\rev).edit
WindowDef(\BufferEditor).front(BufDef(\rev))
(
SynthDef(\fxreverse, { arg out=0, gate=1, bufnum, speed=(-1);
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var rec;
	var trig = Impulse.kr(0);
	var playtrig;
	sig = in;
	playtrig = DelayN.ar(trig, \duration.kr(1/~t), \duration.kr);
	rec = RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:0, run:1, loop:0, trigger:trig);
	//Done.kr(rec).poll;
	Trig.kr(playtrig).poll;
	//sig = sig + PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, playtrig, startPos: BufFrames.kr(bufnum), doneAction:0, loop: 0);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, playtrig, startPos: \duration.kr * BufSampleRate.kr(bufnum), doneAction:0, loop: 0);
	sig = sig * EnvGen.kr(Env([0,1,1,0],[\at.kr(0.01),\duration.kr-0.01-\at.kr,0.01]), playtrig, doneAction:2);
	//sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig + (in * \drygain.kr(0));
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[385].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, Pn(2,1),
			\gain, 0.11,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 3,
			\lag, 0.0009,
			\dur, Pn(4,1),
			\out, BusDef(\reverse, \audio),
		),
		Pbind(
			\instrument, \fxreverse,
			\inbus, BusDef(\reverse, \audio),
			\duration, 1/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\drygain, 0,
			\bufnum, BufDef(\rev),
			\dur, Pn(8,1),
			\amp, 0.1,
		),
		Pbind(
			\time, Ptime().trace,
			\type, \rest,
			\dur, Pstep(Pn(1/4,1),4),
			\amp, 0.1,
		),
	])
)).play;
);


//////////// final

(
SynthDef(\fxreverse, { arg out=0, gate=1, bufnum, speed=(-1);
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var rec;
	var trig = Impulse.kr(0);
	var playtrig;
	sig = in;
	playtrig = DelayN.ar(trig, \duration.kr(1/~t), \duration.kr);
	rec = RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:0, run:1, loop:0, trigger:trig);
	Trig.kr(playtrig);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, playtrig, startPos: \duration.kr * BufSampleRate.kr(bufnum), doneAction:0, loop: 0);
	sig = sig * EnvGen.kr(Env([0,1,1,0],[\at.kr(0.01),\duration.kr-0.01-\at.kr,0.01]), playtrig, doneAction:2);
	sig = sig + (in * \drygain.kr(0));
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


////// test: OK

BufDef(\rev4, 4/~t * s.sampleRate, 2)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, 0.5,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[385].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, Pn(2,1),
			\gain, 0.11,
			\out, BusDef(\verb, \audio),
		),
		Pbind(
			\instrument, \fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 3,
			\lag, 0.0009,
			\dur, Pn(4,1),
			\out, BusDef(\reverse, \audio),
		),
		Pbind(
			\instrument, \fxreverse,
			\inbus, BusDef(\reverse, \audio),
			\duration, 4/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\drygain, 0,
			\legato, 1,
			\bufnum, BufDef(\rev4),
			\dur, Pn(8,1),
			\amp, 0.1,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1097].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[577].value,
				\sustain, 0.1/2,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);


///////////////// demo
// you want a riser lasting 3 beats and ending at beat 8
// you need:
// - a 3 beat buffer
// - a snare+reverb starting at beat 8-(3*2) = 2 and lasting 3 beats
// - a fxreverse lasting (2*3) = 6 beats, with \duration = 3/~t

BufDef(\rev3, 3/~t * s.sampleRate, 2)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, 0.5,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
		),
		Ptpar([
			2, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[385].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\dur, Pn(2,1),
					\gain, 0.11,
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \fx_freeverb2,
					\inbus, BusDef(\verb, \audio),
					\addAction, \addToTail,
					\room, 3,
					\lag, 0.0009,
					\dur, Pn(3,1),
					\out, BusDef(\reverse, \audio),
				),
				Pbind(
					\instrument, \fxreverse,
					\inbus, BusDef(\reverse, \audio),
					\duration, 3/~t,
					\addAction, \addToTail,
					\lag, 0.0009,
					\drygain, 0,
					\legato, 1,
					\bufnum, BufDef(\rev3),
					\dur, Pn(6,1),
					\amp, 0.1,
				),
			]),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1097].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[577].value,
				\sustain, 0.1/2,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);

/////////// try other sounds

WindowDef(\BufferEditor).front(BufDef(\rev4))
(
BufDef(\rev4, 4/~t * s.sampleRate, 2);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, 0.5,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
			\isRest, true,
		),
		Ptpar([
			0, Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
					\bufnum, ~buflib.foley1[49].value,
					\pos, 0.15,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1).coin.not,
					\dur, 1/4,
					\legato, 4,
					\gain, 0.2,
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \fx_freeverb2,
					\inbus, BusDef(\verb, \audio),
					\addAction, \addToTail,
					\room, 3,
					\lag, 0.0009,
					\dur, Pn(4,1),
					\out, BusDef(\reverse, \audio),
				),
				Pbind(
					\instrument, \fxreverse,
					\inbus, BusDef(\reverse, \audio),
					\duration, 4/~t,
					\addAction, \addToTail,
					\lag, 0.0009,
					\legato, 1,
					\drygain, 0,
					\bufnum, BufDef(\rev4),
					\dur, Pn(8,1),
					\amp, 0.1,
				),
			]),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1097].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[577].value,
				\sustain, 0.1/2,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);
