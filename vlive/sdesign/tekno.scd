
~t = 150/2/60; TempoClock.default.tempo = ~t;

FileSystemProject.load("capsule/draftsynth.scd");
FileSystemProject.load("capsule/fxsimple.scd");

(
SynthDef(\sh101, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq * ( \vcomod.kr(0) + 1 );
	sig = LFPulse.ar(freq,0,\pwidth.kr(0.5)) * \pulse.kr(0.5);
	sig = sig + (LFSaw.ar(freq) * \saw.kr(0.5));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(130) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	vcfmod = \vcfmod.kr(0) + 1;
	sig = MoogFF.ar(sig, ( \lpf.kr(930) * lpenv * lpfreq * vcfmod ).clip(20,20000), 1/\rq.kr(0.8)) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
// galope
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[688].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\pifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\decay, 2,
			\mix, 0.2,
			\delay, 3/8/~t,
			\dur, 1,
		),
		
	])
)).play;
);

(
// galope
// sidechain
// bouncy bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[688].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mix1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mix1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\pifx1, \audio, 2),
			//\send1, 1,
			//\sendbus1, BusDef(\pifx1, \audio, 2),
			\dur, 1,
			\postgain, 1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\lpf, PmodEnv(Pseq([100,1000,200,1400],1), 8).loop,
			\hpf, PmodEnv(Pseq([30,5,900,42],1), 8).loop,
			\pfmix, 1,
			\decay, 4,
			\mix, 1,
			\delay, 3/8/~t,
			\dur, 1,
			\out, BusDef(\pifx2, \audio),
			//\isRest, true,
		),
		Pmono(\fx_ring,
			\inbus, BusDef(\sendbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\note, Pseq([
				Pstep(Pseq([-2,-5,1,0],inf),8),
			],inf),
			\lpf, 178,
			\legato, 2,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.2,0.1,0.1) ],
			],inf),
			\rq, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.1/~t,0.1,0.1,0.01) ],
			],inf),
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\pifx2, \audio),
		),
		Pmono(\fx_sidechain,
			\sideinbus, BusDef(\pifx1, \audio),
			\inbus, BusDef(\pifx2, \audio),
			\sidegain, 0,
			\addAction, \addToTail,
			\cpt, 0.01,
			\mix, 1,
			\cpabove, 0.00001,
			//\cpbelow, 0.8,
			\cprelax, 0.13,
			\lag, 0.0009,
			\dur, 1,
			//\gain, 0,
			//\isRest, true,
		),
		
	])
)).play;
);

///////////////////////
(
SynthDef(\fxcorpus, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = Ringz.ar(sig,\freq.kr(1), \decay.kr(0.1)) * \ringzgain.kr(0.1);
	sig = Resonz.ar(sig,\freq.kr(1).poll, \bwr.kr(0.1).poll) * \rgain.kr(0.1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// galope
// corpus
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[688].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, 0.2,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mix1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mix1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\pifx1, \audio, 2),
			//\send1, 1,
			//\sendbus1, BusDef(\pifx1, \audio, 2),
			\dur, 1,
			\postgain, 1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\lpf, 640,
			\pfmix, 1,
			\hpf, 300,
			\decay, 4,
			\mix, 1,
			\delay, 3/8/~t,
			\dur, 1,
			\out, BusDef(\pifx2, \audio),
			//\isRest, true,
		),
		//Pdef(\corpus, Pbind()) <>
		Pmono(\fxcorpus,
			\inbus, BusDef(\pifx2, \audio),
			\out, BusDef(\pifx3, \audio),
			\addAction, \addToTail,
			\freq, PmodEnv(Pseq([10,100,800],1), 8).loop,
			\bwr, PmodEnv(Pseq([0.1,4,0.5],1), 8).loop,
			\rgain, 15,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\sideinbus, BusDef(\pifx1, \audio),
			\inbus, BusDef(\pifx3, \audio),
			\sidegain, 1,
			\addAction, \addToTail,
			\cpt, 0.01,
			\mix, 1,
			\cpabove, 0.00001,
			//\cpbelow, 0.8,
			\cprelax, 0.13,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
Pdef(\corpus).edit

SampleTimeline(\bla)
~t = 185/4/60; TempoClock.default.tempo = ~t;
