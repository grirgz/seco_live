
(
~t = 124/4/60; TempoClock.default.tempo = ~t;// ride natty ride
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
)

(
SynthDef(\simpleorgan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * [1,4]) * [0.1,1];
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\lporgan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFPulse.ar(freq * [1,4]) * [0.1,1];
	sig = sig.mean;
	//sig = Resonz.ar(sig, 1890) + sig;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pluckx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=1;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, DelayC.ar(gate, 0.1, [0.01,0.032,0.0123].scramble * \dstrum.kr(1)), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354].scramble, decay, coef:coef).sum;
	sig = sig * 2;
	sig.debug("sig");
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,[0.2,0.1],0.8,0.4,1,4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	//sig = sig * amp * 0.7;
	sig = sig * 1/3;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\fxklank, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Klank.ar(Ref([[405,869,870,900,1233,1231,4321],1,0.2]),sig);
	sig = sig * 0.3;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
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
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				1,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				[0,4,7]+12,
				[0,4,7],
			],inf).stutter(1),
			\legato, 0.3,
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
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
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				1,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				[0,4,7]+12,
				[0,4,7],
				[0,4,7]+12,
				[0,4,7],
			],inf).stutter(1),
			\legato, Pseq([
				Pwhite(0.2,0.3,7),
				Pwhite(0.2,0.9,1),
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0, 4,
				0, 7,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\lpf, 300,
			\envamt, 2,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pluckx,
			\note, Pseq([
				[ 0,4,7 ]
			],inf),
			\octave, 6,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\decay, 0.1,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


(
// try swing
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.hat[848].value,
			//\isRest, Pseq([
				//0,0,1,1,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.hat[287].value,
			////\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			//\isRest, Pseq([
				////1,1,0,1, 1,1,0,1,
				//1,0,0,0, 1,1,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[287].value,
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
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				[0,4,7]+12,
				[0,4,7],
				[0,4,7]+12,
				[0,4,7],
			],inf).stutter(1),
			\legato, Pseq([
				Pwhite(0.2,0.3,7),
				Pwhite(0.2,0.9,1),
			],inf),
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8 * (1 + (1/3 * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0, 4,
				0, 7,
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\lpf, 300,
			\envamt, 2,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8* (1 + (1/3 * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, \pluckx,
			//\note, Pseq([
				//[ 0,4,7 ]
			//],inf),
			//\octave, 6,
			//\legato, 0.1,
			//\adsr, Pseq([
				//[ Env.adsr(0.01,0.1,0.8,0.1) ],
			//],inf),
			//\decay, 0.1,
			//\isRest, Pseq([
				//0,0,1,0, 0,0,1,0,
				//0,1,1,0, 0,0,1,1,
			//],inf).coin.not,
			//\dur, 1/8,
			//\amp, 0.1/2,
		//),
		
	])
)).play;
);


(
// hi pitched snare
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2430].value,
			\speed, 1.1,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\fx_resonz,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\freq, 7100,
			\lag, 0.0009,
			\dur, 1,
			\isRest, true,
		),
		Pmono(\fxklank,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\freq, 7100,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);


////////////:
// test fast tempo
~t = 284/4/60; TempoClock.default.tempo = ~t;// ride natty ride
~t = 244/4/60; TempoClock.default.tempo = ~t;// ride natty ride

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				[0,4,7]+12,
				[0,4,7],
			],inf).stutter(1),
			\legato, 0.3,
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		
	])
)).play;
);

///////////////////////
(
// bam beu tchik
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				[0,4,7]+12,
				[0,4,7],
			],inf).stutter(1),
			\legato, 0.3,
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // orig
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1814].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
			],inf)/2,
			\speed, Pseq([
				1,1 * -2.midiratio,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1089].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7]+12,
					[0,4,7],
				],2),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
				1,1,1/4,1/2, 1,1,1/2,1/2,
			],inf)/2,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind( // orig
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1814].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
			],inf)/2,
			\speed, Pseq([
				1,1 * -2.midiratio,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, 0.5,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
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
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			\bufnum, ~buflib.kick[235].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7]+12,
					[0,4,7],
				],2),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
				1,1,1/4,1/2, 1,1,1/2,1/2,
			],inf)/2,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind( // orig
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1814].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
			],inf)/2,
			\speed, Pseq([
				1,1 * -2.midiratio,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
				1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
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
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7]+12,
					[0,4,7],
				],2),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
				1,1,1/4,1/2, 1,1,1/2,1/2,
			],inf)/2,
			\dur, 1/8,
			\amp, 0.1/1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4,7],
				],6),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4,
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1,
				1/4,1/4,1/4,1/4, 1/4,1,1/4,1/4,
			],inf)/2,
			\dur, 1/8/2,
			\amp, 0.1/2 * Pseq([
				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
				1,3,1,3,

				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
			   	1,1,1,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind( // orig
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1814].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
			],inf)/2,
			\speed, Pseq([
				1,1 * -2.midiratio,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
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
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[83].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.09,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4+12,7+12],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				0,1,1,1, 0,1,1,1,
				0,0,0,1, 0,0,0,0,
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,2,1/4,1/4,
				1/4,1,1/4,1/4,
				1/4,1,1/4,1/4,
				1/4,1/4,1/4,1,
				1/4,1/4,1/4,2,
			],inf)/2,
			\sus, Pkey(\sustain)/~t,
			\dur, 1/8,
			\amp, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1150].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,0,0,
				1,1,1,1, 1,1,1,1,
				//0,0,0,1, 0,1,1,0,
				//1,1,0,1, 0,1,1,0,
				//1,0,1,1, 0,1,1,0,
				//1,1,0,1, 0,1,1,0,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ]/4,1),
				Pseq([ 1,1,2,2, 1,2,1,2, ]/4,1),
				1,1/2,1/4,1/4, 1,1,1/2,2,
			],inf),
			\speed, Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ]*0.7,1),
				1,1,1.1,1, 1,1.1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4,7],
				],6),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,0,

					1,1,1,1,
					0,1,0,0,
					1,1,1,1,
					1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4,
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1,
				1/4,1/4,1/4,1/4, 1/4,1,1/4,1/4,
			],inf)/2,
			\dur, 1/8/2,
			\amp, 0.1/2 * Pseq([
				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
				1,3,1,3,

				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
			   	1,1,1,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind( // orig
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1814].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
			],inf)/2,
			\speed, Pseq([
				1,1 * -2.midiratio,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
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
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[83].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.09,
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4+12,7+12],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				0,1,1,1, 0,1,1,1,
				0,0,0,1, 0,0,0,0,
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,2,1/4,1/4,
				1/4,1,1/4,1/4,
				1/4,1,1/4,1/4,
				1/4,1/4,1/4,1,
				1/4,1/4,1/4,2,
			],inf)/2,
			\sus, Pkey(\sustain)/~t,
			\dur, 1/8,
			\amp, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1150].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,0,0,
				1,1,1,1, 1,1,1,1,
				//0,0,0,1, 0,1,1,0,
				//1,1,0,1, 0,1,1,0,
				//1,0,1,1, 0,1,1,0,
				//1,1,0,1, 0,1,1,0,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ]/4,1),
				Pseq([ 1,1,2,2, 1,2,1,2, ]/4,1),
				1,1/2,1/4,1/4, 1,1,1/2,2,
			],inf),
			\speed, Pseq([
				Pseq([ 1,1,1,1, 1,1,1,1, ]*0.7,1),
				1,1,1.1,1, 1,1.1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4,7],
				],6),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,0,

					1,1,1,1,
					0,1,0,0,
					1,1,1,1,
					1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4,
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1,
				1/4,1/4,1/4,1/4, 1/4,1,1/4,1/4,
			],inf)/2,
			\dur, 1/8/2,
			\amp, 0.1/2 * Pseq([
				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
				1,3,1,3,

				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
			   	1,1,1,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind( // orig
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1814].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
			],inf)/2,
			\speed, Pseq([
				1,1 * -2.midiratio,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
		),
		Pmono(
			 \sh101,
			\note, Pseq([
				Pseq([
					-5,0,
				],4),
				Pseq([
					-7,0,
				],4),
			],inf),
			\octave, 6,
			\lpf, PmodEnv(Pseq([100,4000],1), 8,\exp).loop,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					7,8,7,0
				],4),
				Pseq([
					7,
				],4*3),
				Pseq([
					5,
				],4*4),
			],inf),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.4,
			\envamt, 6,
			\rq, 0.4,
			\dur, 1/8/2,
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
			\bufnum, ~buflib.kick[446].value,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.15,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Odetta - Hit Or Miss (cd).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/2 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),1/2).loop * Pkey(\bufdur) * 1/8,

			\pos, Pseq([
				Pseq([
					5,6,6,7,
					[ 5,6,6,7 ]+7,
					5,3,6,7,
					[ 5,4,6,7 ]+7,

					[ 5,6,6,7 ]+3,
					[ 5,6,6,7 ]+8,
					5,3,6,7,
					[ 5,4,6,7 ]+6,
					
				].flat,1),
				//Pseq([
					//(0..7)+8,
					//(0..7)+8,

					//(0..7),
					//3,5,6,7, 11,1,11,11,
					
				//].flat,1),
				
			],inf)* Pkey(\bufdur) * 1/8/2,
			\dur, 1/8/2,
			\gain, 1/8 * Pseq([
				2,1,2,0,
				0,0,2,1,
				1,1,2,0,
				0,0,2,0,
				1,1,2,1,
				1,1,2,1,
				1,1,2,1,
				1,1,2,1,
				1,1,2,1,
				1,1,2,1,
				   //1,1,2,1, 1,1,2,1,
				   //1,1,2,1, 2,1,2,2,
			]/3,inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef.stereo('vbreaks/Paul Simon - Fifty Ways To Leave Your Lover.wav'),
			\bufnum, BufDef.stereo('vbreaks/Orange Krush - Action (part3).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/2 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),2).loop * Pkey(\bufdur) * 1/8,
			\pos, Pseq([
				Pseq([
					\r!32,
					\r!16,
					0,1,0,2,
					\r!4,
					[ 11,\r,\r,11 ]-2,
					[ 5,5,1,5 ]+4,

					\r!32,
					\r!16,
					\r!4,
					0,1,0,2,
					3,5,6,7,
					11,1,11,11,
					
				].flat,1),
				
			],inf)* Pkey(\bufdur) * 1/8/2,
			\dur, 1/8/2,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				1,1,1,0, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, Pseq([1,1 * 4.midiratio],inf),
			\gain, 0.08 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \organ_tonewheel1,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4+12,7+12],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				0,1,1,1, 0,1,1,1,
				0,0,0,1, 0,0,0,0,
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,2,1/4,1/4,
				1/4,1,1/4,1/4,
				1/4,1,1/4,1/4,
				1/4,1/4,1/4,1,
				1/4,1/4,1/4,2,
			],inf)/2,
			\sus, Pkey(\sustain)/~t,
			\dur, 1/8,
			\amp, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4,7],
				],6),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,1,1,0,

					1,1,1,1,
					0,1,0,0,
					1,1,1,1,
					1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4,
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1,
				1/4,1/4,1/4,1/4, 1/4,1,1/4,1/4,
			],inf)/2,
			\dur, 1/8/2,
			\amp, 0.1/2 * Pseq([
				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
				1,3,1,3,

				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
			   	1,1,1,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
		),
		Pmono(
			 \sh101,
			\note, Pseq([
				Pseq([
					-5,0,
				],4),
				Pseq([
					-7,0,
				],4),
			],inf),
			\octave, 6,
			\lpf, PmodEnv(Pseq([100,4000],1), 8,\exp).loop,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					7,8,7,0
				],4),
				Pseq([
					7,
				],4*3),
				Pseq([
					5,
				],4*4),
			],inf),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.4,
			\envamt, 6,
			\rq, 0.4,
			\dur, 1/8/2,
			\amp, 0.1/2,
		),
	])
)).play;
);


//////


(
// fix hat level
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[848].value,
			\isRest, Pseq([
				0,0,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,1,
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[287].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,0,1, 1,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7]+12,
					[0,4,7],
				],2),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 3,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
				1,1,1/4,1/2, 1,1,1/2,1/2,
			],inf)/2,
			\dur, 1/8,
			\amp, 0.1/1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4,7],
				],6),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4,
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1,
				1/4,1/4,1/4,1/4, 1/4,1,1/4,1/4,
			],inf)/2,
			\dur, 1/8/2,
			\amp, 0.1/2 * Pseq([
				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
				1,3,1,3,

				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
			   	1,1,1,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
		),
		Pbind( // orig
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1814].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1/4,1/2, 1,1,1/2,2,
			],inf)/2,
			\speed, Pseq([
				1,1 * -2.midiratio,1,1,
			],inf),
			\dur, 1/8,
			\gain, 0.0711,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
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
			\bufnum, ~buflib.kick[905].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[446].value,
			\bufnum, ~buflib.kick[235].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo("samplekit/com/Snare/Rimshot Eliot 3 V5.wav"),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \simpleorgan,
			\note, Pseq([
				Pseq([
					[0,4,7],
					[0+12,4,7],
				],6),
				Pseq([
					[0,4-12,7],
					[0,4,7],
				],2),
			],inf).stutter(1),
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf)),
			\legato, 0.3,
			\octave, 4,
			\isRest, Pseq([
				Pseq([
					1,1,0,1, 1,1,0,1,
				],8),
				Pseq([
					1,0,1,1, 1,0,1,1,
				],8),
				Pseq([
					0,1,0,1, 0,1,0,1,
				],8),
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1/4,
				1/4,1/4,1/4,1/4, 1/4,1/4,1/4,1,
				1/4,1/4,1/4,1/4, 1/4,1,1/4,1/4,
			],inf)/2,
			\dur, 1/8/2,
			\amp, 0.1/2 * Pseq([
				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
				1,3,1,3,

				1,1,3,1,
				1,1,3,1,
				1,1,3,1,
			   	1,1,1,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.4,0.1) ],
			],inf),
			\out, BusDef(\organ, \audio),
		),
		Pmono(\trackcrossmixer,
			\inbus, BusDef(\organ),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\mix, PmodEnv(Pseq([0,1],1), 16).loop,
			\mix, 0,
			\send0, 1,
			\sendbus0, BusDef(\organ0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\organ0, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
			//\out, BusDef(\organ2, \audio),
		),
		//Pmono(\fx_echopass,
			//\inbus, BusDef(\organ0, \audio),
			//\addAction, \addToTail,
			//\delay, 3/8/2/~t,
			//\mix, 0.5,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		Pmono(\fx_tanh,
			\inbus, BusDef(\organ2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\organ3, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\organ3, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,-7,-7,-7,
				0,0,0,\r, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,-5,-3,
				0,0,0,0, 0,0,0,0,
				-7,-7,-7,-7,-7,\r,5,-7,
				0,0,0,0, 0,0,0,\r,
				-7,-7,-7,-7,-7,-7,0,-7,
			],inf).stutter(2),
			\octave, 3,
			\dur, 1/8/2,
			\legato, 0.9,
			\isRest, Pseq([
				0,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\rq, PmodEnv(Pseq([0.7,0.3],2), 8).loop,
			\envamt, PmodEnv(Pseq([0.1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([200,100],1), 8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

SynthDef(\zedfx, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * SinOsc.ar(300);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;

(
SynthDef(\trackcrossmixer, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mix=0;
	var sig;
	var msig, sendsig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)),gate,doneAction:2);
	sig = sig * \pregain.kr(1);
	msig = DelayL.ar(sig, 0.1, \delay.kr(0)) * \postgain.kr(1) * (1-mix);
	sendsig = sig * mix;
	Out.ar(out, sig);
	Out.ar(\sendbus0.kr(BusDef(\sendbus0, \audio)), sendsig * \send0.kr(0));
	Out.ar(\sendbus1.kr(BusDef(\sendbus1, \audio)), sendsig * \send1.kr(0));
	Out.ar(\sendbus2.kr(BusDef(\sendbus2, \audio)), sendsig * \send2.kr(0));
	Out.ar(\sendbus3.kr(BusDef(\sendbus3, \audio)), sendsig * \send3.kr(0));
}).add;
Pdef(\part).reset;
)
