
~t = 121/2/60; TempoClock.default.tempo = ~t;

FileSystemProject.load("holis/synthdef.scd")
FileSystemProject.load("sun/fmgen.scd")
(
SynthDef(\expdelay, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.03,3pi/2).unipolar; 
	sig = in;
	sig = sig + ( LocalIn.ar(2) * \fb.kr(0.99) );
	sig = DelayL.ar(sig, 1, 0.004 * XLine.kr(1000,10.1,1/2));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = DelayL.ar(sig, 1/2/~t, 1/8/~t * lfo1) + sig;
	sig = DelayL.ar(sig, 1/2/~t, 1/3/~t * lfo1) + sig;
	sig = FreqShift.ar(sig, -120 * lfo1) + sig;
	sig = DelayL.ar(sig, 1/2/~t, 1/4/~t) + sig;
	sig = sig /3;
	sig = Limiter.ar(sig, 0.2);
	LocalOut.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;

SynthDef(\kick808, {arg out = 0, freq1 = 240, freq2 = 60, amp = 0.1, ringTime = 100, rel = 10000, dist = 1.5, pan = 0, tott=0.1, durr=0.001, gate=1;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, \glisdur.kr(0.1)),
		decaytime: ringTime);
	//env = EnvGen.ar(Env.perc(0.001, rel, amp), doneAction: 2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env * \gain.kr(0.2);
	snd = Limiter.ar(snd, tott, durr) * 1.5 *(1/tott);
	snd = snd * EnvGen.kr(\adsr2.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:0);
	//snd = Clip.ar(snd, -1 * tott, tott);
	//	snd = Fold.ar(snd, -1 * tott, tott);
	//	snd = Wrap.ar(snd, -1 * tott, tott);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)
(
~buflib[\foley1] ={
		"/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/*".pathMatch.collect({ arg path;
			{ BufDef.stereo(path); }
		})
	}.value;
)


(
	// base
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 0.67,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[908].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);
(
	// base
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[908].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\lag, -0.04,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\inbus, BusDef(\ifx1, \audio),
			\instrument, \expdelay,
			\legato, 1,
			\dur, 2,
			\gain, 1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-L0TJ-1C61", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.67226890756303,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.67909850299557,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.76269858590234,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



//////////////////:
// xp transi



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pseq([ 0, ],6),
				Pseq([ -1, ],1),
				Pseq([ 0, ],1),
				Pseq([ 0, ],4),
				Pseq([ 0, ],1),
				Pseq([ -2, ],1),
				Pseq([ -2, ],1),
				Pseq([ 0, ],1),
			],inf),
			\octave, 3,
			\legato, 0.67,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[908].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[198].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,  1,0,0,0, 1,0,0,0, 1,1,1,1, 1,0,0,0,
			],inf).coin.not,
			\lag, 0.03, // bounce
			\dur, 1/16,
			\gain, 0.11,
			\isRest, true,
		),
				thisThread.randSeed = 42;
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[70].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.1,
			\dur, 1/8,
			\gain, 0.11/4 * Pseq([
				Pwhite(1,0.1,1),
				Pwhite(1/5,0.01,1),
				Pwhite(1,0.5,1),
				Pwhite(1/4,0.01,1),
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[86].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,0,0, 0,0,1,0,
			]*0.8,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/6,
		),

		// transi

		Pbind(
			\instrument, Pseq([
				~gen_transi.(12340),
				~gen_transi.(12343),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\timeScale, 1,
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\legato, 2,
			\amp, 0.1/2,
		),
		Pbind(
			// start small
			\instrument, Pseq([
				~gen_transi.(42364,10),
				//~gen_transi.(42345),
			],inf).stutter(4),
			\freqfac, Pseg(Pseq([1,-7.midiratio],1),4).loop,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\timeScale, 1/4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 1/8,
			\legato, 1,
			\amp, 0.1/4,
		),
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(32340),
				~gen_transi.(32343),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0, 
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 4,
			\legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, ~gen_transi.(12333),
			\isRest, Pseq([
				0,0,0,0,
				0,1,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\legato, 1,
			\amp, 0.1*2,
		),
		Pbind(
			// start bottle
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[418].value,
			\speed, 0.2,
			\pos,0.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/1,
		),
		Pbind(
			// start bottle small
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[418].value,
			\speed, 0.2,
			\pos,0.12,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\legato, 1/2,
			\dur, 1/8,
			\gain, 4/1,
		),
		Pbind(
			// middle 
			\instrument, \playersec_hlpf,
			\lpf, 4000,
			\lpmix, 1,
			//\bla, Prout({ arg ev;
				//thisThread.randSeed = 12300;
				//1000.do { arg item, idx;
					//1000.rand.postln;
					//1.yield;
					
				//};
			//}),
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[22].value,
			\speed, 1,
			\pos,0.1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
				[ Env.adsr(2.1,0.1,0.8,0.1) ],
			],inf).stutter(8*8),
			\legato, 2,
			\dur, 1/8,
			\gain, 1/2,
		),
		Pbind(
			// bottle end
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[255].value,
			\speed, 0.5,
			\pos,0.1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\legato, 2,
			\dur, 1/8,
			\gain, 1/1,
		),
		
	])
)).play;
);

(
SynthDef(\transi1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,0.1,2);
	lfo2 = Line.kr(0.01,0,1);
	lfo3 = XLine.kr(1,2.1,2);
	sig = LFCub.ar(freq * [1,1 + lfo2 ] * ( LFSaw.ar(freq) * lfo1 + 1 ) * XLine.kr(1,-1.midiratio,2));
	sig = sig.mean;
	sig = BPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo3 ).clip(20,20000), \rq.kr(0.5));
	//sig = sig * LFSaw.ar(freq * lfo1);
	sig = sig.fold2(lfo1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(3.1,0.1,0.8,0.1,1,4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
	~gen_transi = { arg seed=1234, num=12;

		SynthDef(\transi_v+++seed+++\_n+++num, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1, freqfac=1;
			var sig;
			var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
			//var num = 17;
			var xfreq;
			thisThread.randSeed = seed;
			freq = exprand(100,18000!num) * freqfac;
			lfo1 = XLine.kr(0.1,0.01,2/~t * timeScale);
			lfo2 = XLine.kr(2,0.001,2/~t * timeScale);
			lfo3 = XLine.kr(0.2,0.9,1/~t * timeScale);
			//lfo1 = LFNoise1.ar(0.1);
			sig = SinOsc.ar(freq * ( LFSaw.ar(freq * lfo1) * lfo1 * 3 + 1 ));
			sig = sig.mean;
			//sig = BPF.ar(sig, freq * lfo2,0.05)*2 + sig;
			sig = RHPF.ar(sig, freq * lfo2,0.5);
			sig = FreeVerb.ar(sig, mix:1 * lfo3, room:1.5, damp:0.5);
			//sig = sig * LFSaw.ar(freq * lfo1);
			//sig = sig.fold2(lfo1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1,1,[4,4,-4])), gate, doneAction:2);
			sig = Pan2.ar(sig, pan, amp);
			Out.ar(out, sig);
		}).add;
	}
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, -3,
			],inf).stutter(2),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					3,0,0,0, 3,0,0,0,
				],7),
				3,0,0,0, 2,0,1,0,

				3,0,0,0, 3,0,0,0,
				1,0,1,1, 1,0,0,0,
				3,0,0,0, 3,0,0,0,
				1,0,0,0, 1,0,0,1,

				3,0,0,0, 3,0,0,0,
				1,0,0,1, 1,0,0,1,
				3,0,0,0, 3,0,0,0,
				1,0,0,0, 1,0,0,1,

			]*0.8,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pbind(
			\amp, Pkey(\amp) * Pseg(Pseq([0,0,1],1),8),
			\gain, Pkeyd(\gain,1) * Pseg(Pseq([0,0,1],1),8),
		)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1131].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\lag, 0.0051,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,

					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,

					1,0,1,0, 1,0,1,0,
					1,1,1,1, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.051,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2 * Pseq([
					Pwhite(1,0.8,1),
					Pwhite(1,0.4,1),
				],inf),
			),
			Pbind(
				\instrument, ~gen_transi.(14343),
				\isRest, Pseq([
					0,0,0,0,
					1,1, 0,0,
				],inf).coin.not,
				\dur, 1/2,
				\adsr, Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.1) ],
				],inf),
				\legato, 1,
				\amp, 0.1/3,
			),
			Pbind(
				\instrument, 
				Pseq([
					~gen_transi.(14338),
					~gen_transi.(14339),
				],inf).stutter(2),
				\isRest, Pseq([
					0,1,
				],inf).coin.not,
				\dur, 1,
				\legato, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, ~gen_transi.(12336),
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\dur, 1,
				\legato, 1,
				\amp, 0.1,
			),
		]),
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(34348),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0, 
				0,0,0,0, 
				0,0,0,0, 
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 4,
			\legato, 1,
			\amp, 0.1/4,
		),
	])
)).play;
);

(
	// end work
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(34356),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0, 
				0,0,0,0, 
				0,0,0,0, 
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 4,
			\legato, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, -3,
			],inf).stutter(2),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				Pseq([
					3,0,0,0, 3,0,0,0,
				],7),
				1,1,1,1, 1,1,1,1,

			]*0.9,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1, 0,0,0,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	// end work
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(34461),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1,1,-3) ],
			],inf),
			\dur, 4,
			\legato, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(34367),
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,1,0,0,
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.1,1,3) ],
			],inf),
			\dur, 1,
			\legato, 1,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, -3,
			],inf).stutter(2),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, ~pmodenv.(Pseq([10,500],1), 16).loop,
			\legato, Pseq([
				Pseq([
					3,0,0,0, 3,0,0,0,
				],6+8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			]*0.9,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pseq([
			Event.silent(8),
			Pmono(
				{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
					var sig;
					var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
					lfo1 = XLine.kr(0.001,2,8/~t);
					lfo2 = Duty.kr(1/16/~t, 0, Dseq([
						1,1,0.7,0.7,
						1,0,1,0,
						1,0.2,0.4,0.1,
						1,0,1,0.3,
					],inf))+0.3;
					lfo3 = SinOsc.ar(0.1*~t) * 0.4 + 1; 
					lfo3 = lfo3 * Line.kr(0.2,4,8/~t);
					sig = LFSaw.ar(freq * [1,1.0001] * ( SinOsc.ar(freq * \fmr.kr(2)) * \fmamp.kr(0.5) * lfo1 * SinOsc.ar(0.1*~t)  + 1 ));
					sig = sig.mean;
					sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo3 ).clip(20,20000), \rq.kr(0.5));
					sig = sig.fold2(lfo2);
					sig = sig* EnvGen.kr(Env([0,1,1,0],[0.1,6/~t,0.1]), 1);
					sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\note, Pstep(Pseq([
					0,0,0,0,
					0,0,0,-3,
				],1),1)-5,
				\octave, 4,
				\dur, 1,
				\amp, 0.1/2,
			)
		],inf),
		
		Pseq([
			Pmono(
				{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
					var sig;
					var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
					lfo1 = Duty.kr(1/4/~t, 0, Drand([
						1,2,1/2,1/4,4,
					],inf));
					lfo2 = Line.kr(1,0.1,8/~t);
					sig = SinOsc.ar(freq * LFNoise1.kr(0.1,mul:0.1,add:1) * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
					sig = sig + SinOsc.ar(freq*lfo1 * LFNoise1.kr(0.1,mul:0.1,add:1) * ((0..7)/7 - 0.5 * \fspread.kr + 1));
					sig = sig * LFNoise1.kr(1).unipolar;
					sig = sig * LFNoise1.kr(1).unipolar;
					sig = sig.clip2(lfo2);
					sig = DelayL.ar(sig, 1/2/~t, 0.001 * LFNoise1.kr(1.1)) + sig;
					sig = sig/2;
					sig = sig * Line.kr(0,1,8/~t);
					sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
					sig = FreeVerb2.ar(sig[0],sig[1], mix:0.9, room:1.5, damp:0.5);
					sig = RHPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
					sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
					//sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\note, Pstep(Pseq([
					11,12+12,
				],inf),4),
				\octave, 4,
				\dur, Pn(2,7),
				\amp, 0.1,
			),
			Event.silent(2)
		],inf),
		thisThread.randSeed = 120;
		Pbind(
			// start bottle
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			//\bufnum, ~buflib.foley1[418].value,
			\speed, 1,
			\pos,0.1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 1,1,1,1,
					1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 2,
		),
		Pbind(
			// start bottle
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[190].value,
			\speed, 1/2,
			\pos,0,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
					0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\dur, 1/8,
			\gain, 1/1,
		),
	])
)).play;
);

(
	// end work
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(34461),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1,1,-3) ],
			],inf),
			\dur, 4,
			\legato, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(34367),
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,1,0,0,
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.1,1,3) ],
			],inf),
			\dur, 1,
			\legato, 1,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, 0, 
				0, 0, 0, -3,
			],inf).stutter(2),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, ~pmodenv.(Pseq([10,200],1), 4).loop,
			\legato, Pseq([
				Pser([
					0,0,0,0, 3,0,0,0,
					3,0,0,0, 3,0,0,0,
					3,0,0,0, 3,0,0,0,
					3,0,0,0, 3,0,0,0,
				],6+8*8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			]*0.9,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pseq([
			Event.silent(8),
			Pmono(
				{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
					var sig;
					var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
					lfo1 = XLine.kr(0.001,2,8/~t);
					lfo2 = Duty.kr(1/16/~t, 0, Dseq([
						1,1,0.7,0.7,
						1,0,1,0,
						1,0.2,0.4,0.1,
						1,0,1,0.3,
					],inf))+0.3;
					lfo3 = SinOsc.ar(0.1*~t) * 0.4 + 1; 
					lfo3 = lfo3 * Line.kr(0.2,4,8/~t);
					sig = LFSaw.ar(freq * [1,1.0001] * ( SinOsc.ar(freq * \fmr.kr(2)) * \fmamp.kr(0.5) * lfo1 * SinOsc.ar(0.1*~t)  + 1 ));
					sig = sig.mean;
					sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo3 ).clip(20,20000), \rq.kr(0.5));
					sig = sig.fold2(lfo2);
					sig = sig* EnvGen.kr(Env([0,1,1,0],[0.1,6/~t,0.1]), 1);
					sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\note, Pstep(Pseq([
					0,0,0,0,
					0,0,0,-3,
				],1),1)-5,
				\octave, 4,
				\dur, 1,
				\amp, 0.1/2,
			)
		],inf),
		
		Pseq([
			Pmono(
				{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
					var sig;
					var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
					lfo1 = Duty.kr(1/4/~t, 0, Drand([
						1,2,1/2,1/4,4,
					],inf));
					lfo2 = Line.kr(1,0.1,8/~t);
					sig = SinOsc.ar(freq * LFNoise1.kr(0.1,mul:0.1,add:1) * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
					sig = sig + SinOsc.ar(freq*lfo1 * LFNoise1.kr(0.1,mul:0.1,add:1) * ((0..7)/7 - 0.5 * \fspread.kr + 1));
					sig = sig * LFNoise1.kr(1).unipolar;
					sig = sig * LFNoise1.kr(1).unipolar;
					sig = sig.clip2(lfo2);
					sig = DelayL.ar(sig, 1/2/~t, 0.001 * LFNoise1.kr(1.1)) + sig;
					sig = sig/2;
					sig = sig * Line.kr(0,1,8/~t);
					sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
					sig = FreeVerb2.ar(sig[0],sig[1], mix:0.9, room:1.5, damp:0.5);
					sig = RHPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
					sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
					//sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\note, Pstep(Pseq([
					11,12+12,
				],inf),4),
				\octave, 4,
				\dur, Pn(2,7),
				\amp, 0.1,
			),
			Event.silent(2)
		],inf),
		Pbind(
			// start bottle
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[2].value,
			\speed, 1,
			\pos,0.1,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],14),
				0,0,0,0, 1,1,1,1,
					1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 2,
		),
		Pbind(
			// start bottle
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[190].value,
			\speed, 1/2,
			\pos,0,
			\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\dur, 1/8,
			\gain, 1/1,
		),
		thisThread.randSeed = 320;
		Pbind(
			// start bottle
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			//\bufnum, ~buflib.foley1[190].value,
			\speed, 1/2,
			\pos, Pseq([
				Pseg(Pseq([0,1],1),1/1)/4/~t,
				Pseg(Pseq([0,1],1),1/2)/4/~t,
			],inf),
			\legato, Pseq([
				Pseq([
					0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
				],3),
				Pser([
					0
				],8*4),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\dur, 1/8,
			\gain, 1/1,
		),
		Pbind(
			\instrument, ~fmgen_short.(23928,15),
			\note, Pseq([
				9
			],inf),
			\detune, Pseg(Pseq([0,0,200],1),8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.11,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseg(Pseq([1,0.1],inf),8),
			\lpfr, ~pmodenv.(Pseq([1/2,1/2,2,4,5],1), 4).loop,
			\isRest, Pseq([
				Pser([ 0, ],8*4),
				Pser([ 1, ],8*10),
				Pser([ 0, ],8*2),
			],inf).coin.not,
			\octave, 7,
			\dur, 1/8,
			\amp, 0.1/4 * Pseg(Pseq([0,0,0.2,1,1],1),4).loop,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			// start bottle
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[190].value,
			\speed, 1/2,
			\pos, Pseq([
				Pseg(Pseq([0,1/2/~t],1),1/2),
			],inf),
			\pos, 1/4/~t + 0.02,
			\legato, Pseq([
				0,0,2,0, 0,2,0,0, 0,0,0,0, 2,0,0,0,
				0,0,0,0, 2,0,0,0, 0,0,0,0, 0,0,2,0,
				0,0,2,0, 0,2,0,0, 0,0,0,0, 2,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\dur, 1/8,
			\gain, 1/1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[83].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 1,0.3,1,0.5,
				0,0,1,0.4, 1,0,0.4,0,
			]*0.8,inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[192].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			// start bottle
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[107].value,
			\speed, 1,
			\pos, Pseq([
				Pseg(Pseq([0,1/2/~t],1),1/2),
			],inf),
			\pos, 1/4/~t + 0.02,
			\pos, 0,
			\legato, Pseq([
				0,0,2,0, 0,2,0,0, 0,0,0,0, 2,0,0,0,
				0,0,0,0, 2,0,0,0, 0,0,0,0, 0,0,2,0,
				0,0,2,0, 0,2,0,0, 0,0,0,0, 2,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf).stutter(4*8),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,1, 1,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0, 0,1,0,0, 0,0,0,1,
				],8*7),
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[83].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 1,0,0,0,
				0,0,0,0, 1,0.3,1,0.5,
				0,0,1,0.4, 1,0,0.4,0,
			]*0.8,inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[192].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 0.67,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[908].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pmono(
			{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
				lfo2 = Line.kr(0.01,1,16/~t);
				lfo1 = ( SinOsc.kr(6*~t * [1,1.001]) * lfo2 + 1 );
				lfo3 = XLine.kr(1,0.001,16/~t);
				sig = LFPulse.ar(freq * [1,1.001]* ( LFSaw.kr(8*~t) * 0.1 + 1 ));
				sig = sig + LFPulse.ar(freq*2 * [1,1.001]* ( LFSaw.kr(16*~t) * 0.1 + 1 ),mul:lfo2);
				sig = sig + LFPulse.ar(freq/2 * [1,1.001]* ( LFSaw.kr(4*~t) * 0.1 + 1 ),mul:lfo2);
				sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo1 ).clip(20,20000), \rq.kr(0.5));
				sig = DelayL.ar(sig, 1/2, 0.1 * lfo3 * LFNoise1.kr(0.1!2,mul:0.1,add:1).unipolar) + sig / 2;
				sig = DelayL.ar(sig, 1/2, 0.1 * LFNoise1.kr(0.1!2).unipolar) + sig / 2;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				//sig = Pan2.ar(sig, pan, amp);
				sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
				Out.ar(out, sig);
			}.asDefName,
			\note, Pstep(Pseq([
				0,3,7,3,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([10,5],5),6).loop,
			\hpmix, 0,
			\lpmix, 0,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[247].value,
			\speed, 1,
			\pos,Pseq([0.0,0],inf).stutter(2),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,0,1,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/7 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([1,50],1),16).loop,
			\hpmix, 1,
			\lpmix, 1,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[307].value,
			\speed, 1/2,
			\pos,Pseq([0.05,0],inf).stutter(2)+0.081,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/14 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
		Pbind(
			\instrument, ~fmgen_ambientchords.(23946,10),
			\note, Pseq([
				[0,12,12+7,11],
				[0,12,12+3,9]+4,
			],inf).stutter(16*2),
			\timeScale, 6,
			\adsr, Pseq([
				[ Env.adsr(0.11,0.1,0.8,0.1) ],
			],inf),
			\lpfr, ~pmodenv.(Pseq([2,4,1/2,5],1), 4).loop,
			\octave, 5,
			\legato, Pseq([
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,

				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				6,0,0,0, 0,2,0,0,

				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,

				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				2,0,2,0, 0,2,0,0,
				//8,0,0,0, 0,0,0,0,
				//7,0,0,0, 0,0,0,1,
				//8,0,0,0, 0,0,0,0,
				//4,0,0,0, 1,1,1,1,
				//16,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
			].rotate(3),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2 * Pseg(Pseq([0,0.2,1,Pn(1,inf)],1),4).loop,
			//\amp, 0.1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 0.67,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[908].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pmono(
			{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
				lfo2 = Line.kr(0.01,1,16/~t);
				lfo1 = ( SinOsc.kr(6*~t * [1,1.001]) * lfo2 + 1 );
				lfo3 = XLine.kr(1,0.001,16/~t);
				lfo4 = XLine.kr(0.001,1,16/~t);
				lfo5 = SinOsc.kr(0.12*~t).range(0.2,1.3);
				sig = LFPulse.ar(freq * [1,1.001]* ( LFSaw.kr(8*~t) * 0.1 + 1 ));
				sig = sig + LFPulse.ar(freq*2 * [1,1.001]* ( LFSaw.kr(16*~t) * lfo4 + 1 ),mul:lfo2);
				sig = sig + LFPulse.ar(freq/2 * [1,1.001]* ( LFSaw.kr(4*~t) * lfo3 + 1 ),mul:lfo2);
				sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo1 ).clip(20,20000), \rq.kr(0.5) * lfo5);
				sig = HPF.ar(sig,70);
				sig = DelayL.ar(sig, 1/2, 0.1 * lfo3 * LFNoise1.kr(0.1!2,mul:0.1,add:1).unipolar) + sig / 2;
				sig = DelayL.ar(sig, 1/2, 0.1 * LFNoise1.kr(0.1!2).unipolar) + sig / 2;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				//sig = Pan2.ar(sig, pan, amp);
				sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
				Out.ar(out, sig);
			}.asDefName,
			\note, Pstep(Pseq([
				0,3,7,3,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([10,5],5),6).loop,
			\hpmix, 0,
			\lpmix, 0,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[247].value,
			\speed, 1,
			\pos,Pseq([0.0,0],inf).stutter(2),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,0,1,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/7 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([1,50],1),16).loop,
			\hpmix, 1,
			\lpmix, 1,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[307].value,
			\speed, 1/2,
			\pos,Pseq([0.05,0],inf).stutter(2)+0.081,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/14 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
		Pbind(
			\instrument, ~fmgen_ambientchords.(23946,10),
			\note, Pseq([
				[0,12,12+7,11],
				[0,12,12+3,9]+4,
			],inf).stutter(16*2),
			\timeScale, 6,
			\adsr, Pseq([
				[ Env.adsr(0.11,0.1,0.8,0.1) ],
			],inf),
			\lpfr, ~pmodenv.(Pseq([2,4,1/2,5],1), 4).loop,
			\octave, 5,
			\legato, Pseq([
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,

				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				6,0,0,0, 0,2,0,0,

				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,

				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				2,0,2,0, 0,2,0,0,
				//8,0,0,0, 0,0,0,0,
				//7,0,0,0, 0,0,0,1,
				//8,0,0,0, 0,0,0,0,
				//4,0,0,0, 1,1,1,1,
				//16,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
			].rotate(3),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2 * Pseg(Pseq([0,0.2,1,Pn(1,inf)],1),4).loop,
			//\amp, 0.1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 0.67,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[908].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pmono(
			{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
				lfo2 = Line.kr(0.01,1,16/~t);
				lfo1 = ( SinOsc.kr(6*~t * [1,1.001]) * lfo2 + 1 );
				lfo3 = XLine.kr(1,0.001,16/~t);
				lfo4 = XLine.kr(0.001,1,16/~t);
				lfo5 = SinOsc.kr(0.12*~t).range(0.2,1.3);
				sig = LFPulse.ar(freq * [1,1.001]* ( LFSaw.kr(8*~t) * 0.1 + 1 ));
				sig = sig + LFPulse.ar(freq*2 * [1,1.001]* ( LFSaw.kr(2*~t) * lfo4 + 1 ),mul:lfo2);
				sig = sig + LFPulse.ar(freq/2 * [1,1.001]* ( LFSaw.kr(4*~t) * lfo3 + 1 ),mul:lfo2);
				sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo1 ).clip(20,20000), \rq.kr(0.5) * lfo5);
				sig = HPF.ar(sig,70);
				sig = DelayL.ar(sig, 1/2, 0.1 * lfo3 * LFNoise1.kr(0.1!2,mul:0.1,add:1).unipolar) + sig / 2;
				sig = DelayL.ar(sig, 1/2, 0.1 * LFNoise1.kr(0.1!2).unipolar) + sig / 2;
				sig = sig * EnvGen.kr(Env([0,1,0],[0.1,0.8]), Impulse.kr(1/2*~t));
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				//sig = Pan2.ar(sig, pan, amp);
				sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
				Out.ar(out, sig);
			}.asDefName,
			\note, Pstep(Pseq([
				0,3,7,3,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([10,5],5),6).loop,
			\hpmix, 0,
			\lpmix, 0,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[247].value,
			\speed, 1,
			\pos,Pseq([0.0,0],inf).stutter(2),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,0,1,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/7 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([1,50],1),16).loop,
			\hpmix, 1,
			\lpmix, 1,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[307].value,
			\speed, 1/2,
			\pos,Pseq([0.05,0],inf).stutter(2)+0.081,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/14 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
		Pbind(
			\instrument, ~fmgen_short.(23946,10),
			\note, Pseq([
				[0,12,12+7,11],
				[0,12,12+3,9]+4,
			],inf).stutter(16*2),
			\timeScale, 6,
			\adsr, Pseq([
				[ Env.adsr(0.21,0.1,0.8,0.4) ],
				[ Env.adsr(0.02,0.1,0.8,0.4) ],
			],inf).stutter(8),
			\lpfr, ~pmodenv.(Pseq([2,4,1/2,5],1), 4).loop,
			\octave, 5,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				8,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				8,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				8,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				8,0,0,0, 0,0,0,0,
				1,1,1,0, 4,0,0,0,
			].rotate(4),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/4 * Pseg(Pseq([0,0.2,1,Pn(1,inf)],1),4).loop,
			//\amp, 0.1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[908].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([10,5],5),6).loop,
			\hpmix, 0,
			\lpmix, 0,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[247].value,
			\speed, 1,
			\pos,Pseq([0.0,0],inf).stutter(2),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,0,1,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/7 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			\hpf, 100 * Pseg(Pseq([1,50],1),16).loop,
			\hpmix, 1,
			\lpmix, 1,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[307].value,
			\speed, 1/2,
			\pos,Pseq([0.05,0],inf).stutter(2)+0.081,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 1,
			\dur, 1/8,
			\gain, 1/14 * Pseq([
				Pwhite(0.81,0.02,2),
				Pwhite(1,0.5,2),
			],inf),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pdef(\drums1),
		
		Pbind(
			\instrument, \playersec_hlpf,
			//\lpf, 4000 * Pseg(Pseq([1/2,3],1),16).loop,
			//\hpf, 100 * Pseg(Pseq([1,50],1),16).loop,
			//\hpmix, 1,
			//\lpmix, 1,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[105].value,
			\speed, 1/2,
			\pos,0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf).stutter(4*8),
			\legato, 18,
			\dur, 1/8,
			\out, BusDef(\ifx1, \audio),
			\isRest, true,
		),
		Ppar(10.collect { arg item, idx;
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.foley1[105].value,
				\pos, rrand(0.0,3/~t),
				\sustain, 0.1/2,
				\dur, rrand(1.1,4),
				\lag, rrand(0.0,1),
				\gain, 1/5,
				\out, BusDef(\ifx1, \audio),
			)
		}),
		Pmono(\fx_reverb,
			\fb, 0.10000000149012,
			\lpf, 16000.0,
			\lpmix, 0.5,
			\delayfac, 1.0/3,
			\decay, 1.0/3,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 0.2,
			\mix, 0.5,
			\dur, 1,
			\gain, 4.0,
			\out, BusDef(\sendbus1, \audio),
		),
		
		Pbind(
			\instrument, ~fmgen_short.(4007,10),
			\note, Pseq([
				[0,12,12+7,11],
				[0,12,12+3,9]+4,
			],inf).stutter(16*2),
			\timeScale, 6,
			\adsr, Pseq([
				[ Env.adsr(0.21,0.1,0.8,0.4) ],
				[ Env.adsr(0.02,0.1,0.8,0.4) ],
			],inf).stutter(8),
			\lpfr, ~pmodenv.(Pseq([2,4,1/2,5],1), 4).loop,
			\octave, 5,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			].rotate(4),inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			//\amp, 0.1/4 * Pseg(Pseq([0,0.2,1,Pn(1,inf)],1),4).loop,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1/8,
		),
	])
)).play;
);
