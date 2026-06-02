

~t = 174/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1192].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			\bufnum, ~buflib.snare[732].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.09,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,3,3,3,
				-1,-1,-1,-1,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
			],inf) * 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.7) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \scratcher,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				1,0,0,1, 0,0,1,0,
				4,4,4,0, 0,0,1,0,
			],inf)*4,
			\legato, 1,
			\samp, 0.3,
			\pos, 3,

			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1192].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			\bufnum, ~buflib.snare[732].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.09,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,3,3,3,
				-1,-1,-1,-1,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
			],inf) * 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.7) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono( \scratcher,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				Pseq([
					8,8,8,4, 6,3,3,3,
					3,3,3,4, 3,3,3,3,

				],1),
			],1),
			\legato, 1,
			\samp, 0.15,
			\pos, 1.7,

			\dur, 1/8,
			\amp, 0.09 * Pseq([
				1,1,0,1, 1,1,1,1,
			],inf),
		).loop,
		
	])
)).play;
);


(
SynthDef(\scratcher, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = LFTri.ar(\sfreq.kr(1)).lag(0.1) * \samp.kr(1) + \pos.kr(1) * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \scratcher,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				1,2,4,1,
			],inf),
			\legato, 1,
			\samp, 0.2,

			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
// constant pitch
SynthDef(\scratcherc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = LFTri.ar(\sfreq.kr(1)).lag(0.1) * \samp.kr(1)/\sfreq.kr + \pos.kr(1) * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
{ SinOsc.kr(1)  }.plot(2)
(
// constant pitch, unipolar
SynthDef(\scratchercp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = LFTri.ar(\sfreq.kr(1)).unipolar.lag(0.1) * \samp.kr(1)/\sfreq.kr + \pos.kr(1) * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
// constant pitch sqrt
SynthDef(\scratchercq, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = LFTri.ar(\sfreq.kr(1)).lag(0.1) * \samp.kr(1)/\sfreq.kr.sqrt + \pos.kr(1) * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1192].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			\bufnum, ~buflib.snare[732].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.09,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,3,3,3,
				-1,-1,-1,-1,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
			],inf) * 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.7) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \scratcherc,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				4,8,6,2,
			],inf).stutter(4),
			\legato, Pseq([
				4,0,0,0, 2,0,0,1,
				1,1,0,1, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.4,
			\pos, 3.7,

			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

//////////:


(
Pdef(\part, Pdef(\beat1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1192].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
				],3),
				Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
				],3),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			\bufnum, ~buflib.snare[732].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.09,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,3,3,3,
				-1,-1,-1,-1,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				Pseq([
					1,0,0,1, 0,0,1,0,
					0,1,1,0, 0,0,1,0,
				],3),
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 1,0,1,1,
			],inf) * 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.7) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.081,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,1,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				4,8,6,2,
			],inf).stutter(4),
			\legato, Pseq([
				4,0,0,0, 2,0,0,1,
				1,1,0,1, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.4,
			\pos, 3.7,

			\dur, 1/8,
			\amp, 0.08,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				1,1,1,1,
				2,1,6,2,
			],inf).stutter(4),
			\legato, Pseq([
				3,0,0,1, 1,2,0,1,
				2,0,2,0, 1,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.4,
			\pos, 1.6,

			\dur, 1/8,
			\amp, 0.1/2,
			\amp, 0.08,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratcherc,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				1,1,4,4, 1,1,3,3,
				1,1,1,1, 2,1,6,2,
				3,2,1,4, 2,1,6,2,
			],inf).stutter(2),
			\legato, Pseq([
				1,1/2,1,1, 4,0,0,0,
				2,0,2,0, 1,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.3 * Pseq([
				0,0,0,4, 0,0,0,0,
				0,0,0,0, 0,4,4,4,
			],inf).midiratio,
			\pos, 1.55,

			\dur, 1/8,
			\amp, 0.1/2,
			\amp, 0.08,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratcherc,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				2,1,1,8,
				2,4,3,2, 
			],inf).stutter(2),
			\legato, Pseq([
				4,0,0,0, 3,0,0,1,
				1,1,1,0, 1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.3 * Pseq([
				0,0,0,4, 0,0,0,0,
				0,0,0,0, 0,4,4,4,
			],inf).midiratio,
			\pos, 1.08 + Pseg(Pseq([0,0.8],1),2).loop,

			\dur, 1/8,
			\amp, 0.132,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratcherc,
			\bufnum, BufDef('voices/feynman.flac'),
			\sfreq, 1*~t * Pseq([
				1,2,2,4, 2,4,3,2, 
				2,1,1,8, 2,4,3,2, 
			],inf).stutter(2),
			\legato, Pseq([
				4,0,0,0, 3,0,0,1,
				1,1,1,0, 1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.3 * Pseq([
				0,0,0,4, 0,0,0,0,
				0,0,0,0, 0,4,4,4,
			],inf).midiratio,
			\pos, 1.08 + Pseg(Pseq([0,0.8],1),4).loop,

			\dur, 1/8,
			\amp, 0.152,
		),
	])
)).play;
);

BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\bufnum, BufDef(\metal, "vipere/metal.flac"),
			\bufnum, BufDef(\bomb, "vipere/bomb.flac"),
			\sfreq, 1*~t * Pseq([
				2,2,2,2,
				2, 2, 2,4,

			],inf).stutter(3),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				Pseg(Pseq([1,0.1],1),1),
				1,3,0,0, 1/2,1,0,1,
				2,0,0,1, 2,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.43 * Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).midiratio,
			\pos, 2.57 + Pseq([
				Pseg(Pseq([0,0.4],1),2),
				Pseg(Pseq([0,0.04],1),2),
			],inf),
			\pos, 2.77 + Pseq([0,0.1,0.01,0.05],inf),
			\pos, 0.01,
			\pos, 0.01 + Pseg(Pseq([0,0.4],1),1).loop,

			\dur, 1/8,
			\amp, 0.081,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\sfreq, 1*~t * Pseq([
				8,8,8,8,
				4,4,4,4,
				4,2,2,2,
				2,2,2,2,
				8,2,2,2,
				2,2,2,2,
				8,2,2,2,
				2,2,2,2,
				4,2,2,2,
				2,2,2,2,
				2, 2, 2,4,

			],inf).stutter(3),
			\legato, Pseq([
				0.5,0.5,0.5,0.5, 2,0,0.5,0.5,
				1,1,1,1, 1,1,1,1,
				Pseg(Pseq([1,0.1],1),1),
				1,3,0,0, 1/2,1,0,1,
				2,0,0,1, 2,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.17 * Pseq([
				0,0,0,0, 8,0,0,0,
				0,0,10,0, 0,0,0,10,
			],inf).midiratio,
			\pos, 2.57 + Pseq([
				Pseg(Pseq([0,0.4],1),2),
				Pseg(Pseq([0,0.04],1),2),
			],inf),
			\pos, 2.77 + Pseq([0,0.1,0.01,0.05],inf),
			\pos, 0.01,
			\pos, 0.71 + Pseg(Pseq([0,0.4],1),1).loop,

			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef(\scream, "vipere/scream.flac"),
			\sfreq, 1*~t * Pseq([
				8,8,8,8,
				4,4,4,4,
				4,2,2,2,
				2,2,2,2,
				8,2,2,2,
				2,2,2,2,
				8,2,2,2,
				2,2,2,2,
				4,2,2,2,
				2,2,2,2,
				2, 2, 2,4,

			],inf).stutter(3),
			\legato, Pseq([
				0.5,0.5,0.5,0.5, 2,0,0.5,0.5,
				1,1,1,1, 1,1,1,1,
				Pseg(Pseq([1,0.1],1),1),
				1,3,0,0, 1/2,1,0,1,
				2,0,0,1, 2,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.17 * Pseq([
				0,0,0,0, 8,0,0,0,
				0,0,10,0, 0,0,0,10,
			],inf).midiratio,
			\pos, 2.57 + Pseq([
				Pseg(Pseq([0,0.4],1),2),
				Pseg(Pseq([0,0.04],1),2),
			],inf),
			\pos, 2.77 + Pseq([0,0.1,0.01,0.05],inf),
			\pos, 0.01,
			\pos, 0.71 + Pseg(Pseq([0,0.4],1),1).loop,

			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\beat1),
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef(\metal, "vipere/metal.flac"),
			\bufnum, BufDef(\bomb, "vipere/bomb.flac"),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\bufnum, BufDef(\scream, "vipere/scream.flac"),
			\bufnum, BufDef(\metal, "vipere/metal.flac"),
			\sfreq, 1*~t * Pseq([
				1,1,1,2,
				1,1,2,1,
				1,1,1,1,
				2,1,2,1,
			],inf).stutter(1),
			\legato, Pseq([
				1,1,1,1, 1/2,1/2,1,1,
				1,1,2,0, 3,0,0,1,
				2,0,1,2, 0,1,2,0,
				1,1,2,0, 2,0,1,1,
			],inf) * 0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.37 * Pseq([
				0,0,0,0, 8,0,0,0,
				0,0,10,0, 0,0,0,10,
			],inf).midiratio,
			\pos, 2.57 + Pseq([
				Pseg(Pseq([0,0.4],1),2),
				Pseg(Pseq([0,0.04],1),2),
			],inf),
			\pos, 2.77 + Pseq([0,0.1,0.01,0.05],inf),
			\pos, 0.71 + Pseg(Pseq([0,0.4],1),1).loop,
			\pos, 0.11,

			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1121].value,
			\bufnum, ~buflib.hat[230].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				0,0,1,0, 0,0,1,0,
				0,1,1,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[230].value,
			\bufnum, ~buflib.hat[1121].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,0,0,
				0,1,1,1, 0,1,1,1,
				0,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
	])
)).play;
);
