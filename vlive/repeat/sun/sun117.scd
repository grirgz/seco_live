
// continue fmgen
~t = 120/2/60; TempoClock.default.tempo = ~t;

(
// filter env and absolute cutoff

~fmgen_ambientchordsabs = { arg seed=10000, num=20;

	SynthDef(\fmgen_ambientchordsabs_v+++seed+++\n+++num, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
		var sig;
		//var num=20;
		thisThread.randSeed = seed;
		sig = num.collect { arg idx;
			var isig;
			var oscgen = {
				[SinOsc,LFSaw,LFPulse].wchoose([1,0.2,0.2].normalizeSum)
			};
			var harms = [1,1,1,2,4,1/2,1/4];
			var fenv;
			isig = oscgen.value.ar(( oscgen.value.ar(freq * harms.choose) * \fmamt.kr(0.9) + 1 ) * freq * harms.choose + LFNoise1.kr(\dfreq.kr(0.1),mul:\freqdiff.kr(0.001)));
			isig = isig * EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2) * \relfac.kr(1)),gate,doneAction:0, timeScale:\timeScale.kr(1));
			fenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2) * \relfac.kr(1)),gate,doneAction:0, timeScale:\timeScale.kr(1));
			fenv = fenv * rrand(0.1,8) + rrand(0.1,2);
			isig = RLPF.ar(isig, ( \lpf.kr(800) * ( fenv*\envamt.kr(1)+1 ) ).clip(20,20000), \rq.kr(0.5));
			isig;
		};
		sig = sig.clump(2).flop.mean;
		sig.debug("sig");
		sig = HPF.ar(sig, \hpf.kr(40));
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
		//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
		sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
		Out.ar(out, sig);
	}).add;
};
~fmgen_ambientchordsabs.();

);

(
SynthDef(\riserhpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var duration = 4/~t;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 4400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[duration,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;
	sig = HPF.ar(sig, XLine.kr(10,15000,duration));
	sig = sig * 20.dbamp;
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0,1,0.01,1,3)), gate, doneAction:2);
	sig = sig *   EnvGen.kr( Env.perc(duration, 0.01,1,3), doneAction:2 );
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(18595,5),
			\note, Pseq([
				[0,4,7]
			],inf),
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,9]+2,
			],inf),
			\lpf, PmodEnv(Pseq([100,14002],1), 4, \exp).loop,
			\envamt, 2,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(13025,5),
			\note, Pseq([
				[0,4,7],
				[0,4,7]+5,
			],inf),
			\note, Pseq([
				[0,4,7,10-12],
				[0,4,7,9]+2,
			],inf),
			\fmamt, 0.9,
			\freqdiff, 1.4,
			\dfreq, 8.23,
			\hpf, 100,
			\lpf, PmodEnv(Pseq([50,14002],1), 8, \exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\relfac, 15,
			\envamt, 1,
			\octave, 6,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(234221,5),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,4.1) ],
			],inf),
			\note, Pseq([
				[5,8],
				[4,7],
			],inf),
			\hpf, 130,
			\legato, 0.4,
			\relfac, 40,
			\lpf, 100,
			\envamt, 2,
			\timeScale, 1,
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534218,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\note, Pseq([
					12,5,7,5,
				Prand([
					12,5,7,5,
				],4),
					0,2,4,2,
				Prand([
					0,2,4,2,
				],4),
			],inf),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(234215,5),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,4.1) ],
			],inf),
			\note, Pseq([
				[5,8],
				[4,7],
			],inf),
			\hpf, 130,
			\legato, 0.4,
			\dfreq, 8,
			\freqdiff, 5,
			\relfac, 40,
			\lpf, 400,
			\hpf, 160,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\timeScale, 1,
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534217,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,0.1) ],
			],inf),
			\note, Pseq([
					12,5,7,5,
				Prand([
					0,2,4,2,
					12,5,7,5,
				],4),
				Prand([
					0,2,4,2,
					12,5,7,5,
				],4),
					12,5,0,7,
			],inf),
			\octave, 6,
			\lpf, PmodEnv(Pseq([300,1800,12004],1), 8,\exp).loop,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,1,0,
				1,1,1,0, 0,1,1,0,
				1,0,1,1, 0,1,0,1,
				1,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534218,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
					0,2,4,2,
				Prand([
					0,2,4,2,
				],4),
					0,2,4,2,
				Prand([
					0,2,4,2,
				],3),\r,
					0,2,4,2,
				Prand([
					0,2,4,2,
				],4),
					0,2,8,2,
					\r,\r,\r,
				Prand([
					0,2,4,2,
				],1),
			],inf),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534210,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
				Prand([
					8,7,5,0,12
				],4),
			],inf),
			\octave, 6,
			\dur, 1/8,
			\legato, 0.1,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				1,0,1,1, 0,1,0,0,
				1,1,0,1, 0,1,1,0,
				1,0,1,1, 0,1,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(234210,5),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,4.1) ],
			],inf),
			\note, Pseq([
				[5,8],
				[4,7],
			],inf),
			\hpf, 130,
			\legato, 0.4,
			\dfreq, 8,
			\freqdiff, 5,
			\relfac, 40,
			\lpf, 400,
			\hpf, 160,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\timeScale, 1,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			//\rr, thisThread.randSeed = TempoClock.seconds,
			\instrument, \playersec,
			\bufnum, ~buflib.kick[731].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[640].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534210,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
					8,7,5,0,
					7,0,2,0,
			],inf),
			\octave, 4,
			\dur, 1/8,
			\legato, 0.1,
			\lpf, PmodEnv(Pseq([100,2000],1), 8,\exp).loop,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534204,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
					8,7,
			],inf).stutter(2),
			\octave, 5,
			\rq, 0.3,
			\hpf, 400,
			\freqdiff, 10,
			\fmamt, 1.3,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([1000,9000],1), 8,\exp).loop,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			//\instrument, ~fmgen_ambientchordsabs.(534181,5),
			\instrument, \sh101,
			//\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,0.1) ],
			],inf),
			\note, Pseq([
					4,5,
			],inf).stutter(1),
			\octave, 3,
			\rq, 0.7,
			\hpf, 40,
			\freqdiff, 10,
			\fmamt, 1.3,
			\envamt, 10,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([50,400],1), 8,\exp).loop,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\amp, 0.2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(234210,5),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,4.1) ],
			],inf),
			\note, Pseq([
				[5,8],
				[4,7],
			],inf),
			\hpf, 130,
			\legato, 0.4,
			\dfreq, 8,
			\freqdiff, 5,
			\relfac, 40,
			\lpf, 400,
			\hpf, 160,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\timeScale, 1,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\fmb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[731].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[640].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
					0,0,0,0, 1,1,0,0,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\rr, thisThread.randSeed = TempoClock.seconds,
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1575].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				1,0,0,0, 0,1,1,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\rr, thisThread.randSeed = TempoClock.seconds,
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1575].value,
			\bufnum, ~buflib.hat[835].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.4,1,0.7,
				0.1,0.4,0,0.7,
			],inf),
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534210,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
					8,7,5,0,
					7,0,2,0,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\legato, 0.1,
			\lpf, PmodEnv(Pseq([100,2000],1), 8,\exp).loop,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534204,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
				8,7,
			],inf).stutter(2),
			\octave, 5,
			\rq, 0.3,
			\hpf, 400,
			\freqdiff, 10,
			\fmamt, 1.3,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([1000,9000],1), 8,\exp).loop,
			\isRest, Pseq([
				Pser([
					1,0,1,0,
				],8*15),
				Pser([
					1,0,0,0, 0,0,0,1,
				],8*1),
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fma, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\fma, \audio),
			\delay, 1/4/~t,
			\diffmul, 1.5,
			\mix, 0.1,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			//\instrument, ~fmgen_ambientchordsabs.(534181,5),
			\instrument, \sh101,
			//\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,0.1) ],
			],inf),
			\note, Pseq([
					4,5,
			],inf).stutter(1),
			\octave, 3,
			\rq, 0.7,
			\hpf, 40,
			\freqdiff, 10,
			\fmamt, 1.3,
			\envamt, 10,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([50,400],1), 8,\exp).loop,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,1,
					0,0,1,1, 0,1,1,1,
					0,0,1,0, 0,0,1,0,
					0,1,1,0, 0,1,1,1,
				].clump(8).stutter(8).flat,1),
			],inf).coin.not,
			\amp, 0.2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(234209,5),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,4.1) ],
			],inf),
			\note, Pseq([
				[5,8],
				[4,7],
			],inf),
			\hpf, 130,
			\legato, 0.4,
			\dfreq, 8,
			\freqdiff, 5,
			\relfac, 40,
			\lpf, 400,
			\hpf, 160,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\timeScale, 1,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\fmb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[731].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[640].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
					0,0,0,0, 1,1,0,0,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\rr, thisThread.randSeed = TempoClock.seconds,
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1575].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				1,0,0,0, 0,1,1,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\rr, thisThread.randSeed = TempoClock.seconds,
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1575].value,
			\bufnum, ~buflib.hat[835].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.4,1,0.7,
				0.1,0.4,0,0.7,
			],inf),
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(524195,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
					8,7,5,0,
					7,0,2,0,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\legato, 0.1,
			\lpf, PmodEnv(Pseq([4000,100,2000],1), 8,\exp).loop,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\amp, 0.14,
		),
		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534190,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
				8,7,
			],inf).stutter(2),
			\octave, 5,
			\rq, 0.3,
			\hpf, 400,
			\freqdiff, 10,
			\fmamt, 1.3,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([1000,9000],1), 8,\exp).loop,
			\isRest, Pseq([
				Pser([
					1,0,1,0,
				],8*15),
				Pser([
					1,0,0,0, 0,0,0,1,
				],8*1),
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fma, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\fma, \audio),
			\delay, 1/4/~t,
			\diffmul, 1.5,
			\mix, 0.1,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			//\instrument, ~fmgen_ambientchordsabs.(534181,5),
			\instrument, \sh101,
			//\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,0.1) ],
			],inf),
			\note, Pseq([
					4,5,
			],inf).stutter(1),
			\octave, 3,
			\rq, 0.7,
			\hpf, 40,
			\freqdiff, 10,
			\fmamt, 1.3,
			\envamt, 10,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([50,400],1), 8,\exp).loop,
			\isRest, Pseq([
				1,1,0,1, 0,0,1,0,
				0,1,0,0, 1,1,0,1,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.2,
		),
		
	])
)).play;
);

//////////////// livecode

(
Pdef(\kick, 
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[731].value,
		//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\isRest, Pseq([
			Pseq([
				1,0,0,0, 1,0,0,0,
			],7),
			1,0,0,0, 1,0,1,0,
			Pseq([
				1,0,0,0, 1,0,0,0,
			],7),
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
).play;
);

Pbindef(\kick, \gain, Pseg(Pseq([0,0.1,Pn(0.1,inf)],1),8))

(
Pbindef(\kick, \out, BusDef(\hpf, \audio));
Pdef(\hpf, Pmono(\fx_hpf,
	\addAction, \addToTail,
	\inbus, BusDef(\hpf, \audio),
	\lag, 0.0005,
	\hpf, Pseq([
		PmodEnv(Pseq([40,1500,2000],1), 4,\exp),
		Pn(1,inf),
	],1),
	\dur, 1,
	\amp, 0.1,
)).play;
)

(
Pbindef(\kick, \out, BusDef(\verb, \audio));
Pdef(\verb, Pmono(\fx_freeverb2,
	\addAction, \addToTail,
	\inbus, BusDef(\verb, \audio),
	\lag, 0.0005,
	\mix, Pseq([
		PmodEnv(Pseq([0,1],1), 8),
		Pn(0,inf),
	],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
)

(
Pbindef(\kick, \out, BusDef(\verb, \audio));
Pdef(\verb, Pmono(\fx_freeverb2,
	\addAction, \addToTail,
	\inbus, BusDef(\verb, \audio),
	\lag, 0.0005,
	\room, 2,
	\mix, Pseq([
		PmodEnv(Pseq([1,1,0],1), 8),
		Pn(0,inf),
	],inf),
	\dur, 1,
	\amp, 0.1,
)).play;
)

PlayerWrapper(Pdef(\kick)).stop

(
Pbindef(\mel1, \out, BusDef(\verb, \audio));
Pbindef(\mel2, \out, BusDef(\verb, \audio));
Pbindef(\mel3, \out, BusDef(\verb, \audio));
Pdef(\verb, Pmono(\fx_freeverb2,
	\addAction, \addToTail,
	\inbus, BusDef(\verb, \audio),
	\lag, 0.0005,
	\room, 2,
	\mix, Pseq([
		PmodEnv(Pseq([1,1,0],1), 8),
		Pn(0,inf),
	],inf),
	\dur, 1,
	\amp, 0.1,
	\out, BusDef(\hpf, \audio),
)).play;
Pdef(\hpf, Pmono(\fx_hpf,
	\addAction, \addToTail,
	\inbus, BusDef(\hpf, \audio),
	\lag, 0.0005,
	\hpf, Pseq([
		PmodEnv(Pseq([40,1500,2000,10000,10000],1), 4,\exp),
		Pn(1,inf),
	],1),
	\dur, 1,
	\amp, 0.1,
)).play;
Pdef(\riser, Pbind(
	\instrument, \riserhpf,
	\legato, 1,
	\isRest, Pseq([
		0,1,
	],1).coin.not,
	\duration, 8/~t,
	\dur, 8,
	\amp, 0.3,
)).play;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, ~fmgen_ambientchordsabs.(234209,5),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,4.1) ],
			],inf),
			\note, Pseq([
				[5,8],
				[4,7],
			],inf),
			\hpf, 130,
			\legato, 0.4,
			\dfreq, 8,
			\freqdiff, 5,
			\relfac, 40,
			\lpf, 400,
			\hpf, 160,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\timeScale, 1,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\fmb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pdef(\kick,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[731].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[640].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
					0,0,0,0, 1,1,0,0,
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\rr, thisThread.randSeed = TempoClock.seconds,
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1575].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				1,0,0,0, 0,1,1,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\rr, thisThread.randSeed = TempoClock.seconds,
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1575].value,
			\bufnum, ~buflib.hat[835].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.4,1,0.7,
				0.1,0.4,0,0.7,
			],inf),
		),
		Pdef(\mel2,Pbind(
			\instrument, ~fmgen_ambientchordsabs.(524195,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 10,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
					8,7,5,0,
					7,0,2,0,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\legato, 0.1,
			\lpf, PmodEnv(Pseq([4000,100,2000],1), 8,\exp).loop,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\amp, 0.14,
		)),
		Pdef(\mel3,Pbind(
			\instrument, ~fmgen_ambientchordsabs.(534190,5),
			\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,1.1) ],
			],inf),
			\note, Pseq([
				8,7,
			],inf).stutter(2),
			\octave, 5,
			\rq, 0.3,
			\hpf, 400,
			\freqdiff, 10,
			\fmamt, 1.3,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([1000,9000],1), 8,\exp).loop,
			\isRest, Pseq([
				Pser([
					1,0,1,0,
				],8*15),
				Pser([
					1,0,0,0, 0,0,0,1,
				],8*1),
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fma, \audio),
		)),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\fma, \audio),
			\delay, 1/4/~t,
			\diffmul, 1.5,
			\mix, 0.1,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pdef(\mel1,Pbind(
			//\instrument, ~fmgen_ambientchordsabs.(534181,5),
			\instrument, \sh101,
			//\timeScale, 0.01,
			\fmamt, 0.4,
			\relfac, 70,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.7,0.1) ],
			],inf),
			\note, Pseq([
					4,5,
			],inf).stutter(1),
			\octave, 3,
			\rq, 0.7,
			\hpf, 40,
			\freqdiff, 10,
			\fmamt, 1.3,
			\envamt, 10,
			\dur, 1/8,
			\legato, 0.81 * Pseg(Pseq([0.2,1],1),8*2).loop,
			\lpf, PmodEnv(Pseq([50,400],1), 8,\exp).loop,
			\isRest, Pseq([
				1,1,0,1, 0,0,1,0,
				0,1,0,0, 1,1,0,1,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.2,
		)),
		
	])
)).play;
);
