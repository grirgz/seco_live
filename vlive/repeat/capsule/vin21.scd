~t = 138/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\acidbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env.perc(0.01,0.7)), \lpenvtrig.tr(1), doneAction:2);
	sig1 = Pulse.ar(freq * [1/2,1,2,3/2], LFNoise1.kr([0.1,0.11]/100)/10) * [0.7,1,0.7,0.2];
	sig2 = LFSaw.ar(freq * [1/2,1,2,3/2]) * [1.0,0.4,0.2,0.1];
	sig = [sig1, sig2].sum;

	sig3 = Latch.ar(sig, Impulse.ar(\latchfreq.kr(300) * ( env1 * 2 + 1 )));
	sig = SelectX.ar(\latchmix.kr(0.51), [sig, sig3]);

	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \lpenvamt.kr(4.4) + 1), \rq.kr(0.1));
	sig = sig + ( MoogFF.ar(sig, \lpfr.kr * freq * (env1 * \lpenvamt.kr + 1), \q.kr(2.5)) * 2 );
	//sig = MoogVCF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \lpenvamt.kr(4.4) + 1), \q.kr(3.1)) * 4;

	sig4 = sig * \distpreamp.kr(10);
	sig = SelectX.ar(\distmix.kr(0.1), [sig, sig4]);

	sig = HPF.ar(sig, 170);

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
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
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffy.flac'),
			\pos, Pseq([
				43,44,
			],inf).stutter(8),
			\legato, 1,
			\legato, Pseq([
				0,0,1,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\speed, 1.1,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffy.flac'),
			\pos, Pseq([15,25,20,30],inf),
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\dur, 1,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\fx_compander,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\track1, \audio),
			\cpt, 0.01,
			\mix, 1,
			\pregain, 1,
			\cpabove, 0.5,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.05,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1101].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[774].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffy.flac'),
			\pos, Pseq([
				43,44,
			],inf).stutter(8),
			\legato, 1,
			\legato, Pseq([
				0,0,1,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\speed, 1.1,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pbind(
			\instrument, \playersec_looper,
			\bufnum, BufDef('smp/buffy.flac'),
			\trigfreq, 64*~t,
			\pos, Pseq([15,25,20,30],inf).stutter(8),
			\legato, Pseq([
				4,0,0,0, 0,0,0,1,
				0,3,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\comp, \audio),
		),
		Pmono(\fx_compander,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\track1, \audio),
			\cpt, 0.01,
			\mix, 1,
			\pregain, 1,
			\cpabove, 0.5,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.05,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[938].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1870].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1101].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[774].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\pos, 2.3,
			\dur, 2,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[938].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1870].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1101].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[774].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Pseq([
				1/2,1,1,16,
				24,1,1,16,
			],inf)*~t,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				3,0,0,1, 1,2,0,0,


				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2,0,0, 0,0,0,1,
				7,0,0,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\pos, 2.3,
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[938].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1870].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1101].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[774].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Pseq([
				1/2,1,1,16,
				24,1,1,16,
			],inf)*~t,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\pos, 2.3,
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		),
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
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,

				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[938].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1870].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1101].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[774].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec_looper,
			\trigfreq, Pseq([
				1/2,1,1,16,
				24,1,1,16,
			],inf)*~t,
			\bufnum, BufDef('smp/buffyvoice.flac'),
			\speed, ~pmodenv.(Pseq([1,0,0,0],inf), 1/2),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\pos, 2.3,
			\dur, 1/8,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		),
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
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,

				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[938].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1870].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1101].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[774].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sendbus2, \audio, 2),
			\dur, 1,
		),
		PmonoArtic(\acidbass,
			\note, Pseq([
				0,
			],inf),
			\lpenvtrig, 1,
			\lpfr, ~pmodenv.(Pseq([1/4,4,2],inf), 8),
			\lpenvamt, ~pmodenv.(Pseq([8,1/4,2,1,4],inf), 1),
			\octave, Pseq([
				4,5,5,5, 
			],inf)-1,
			\legato, Pseq([
				0.5,0.1,1,1,
			],inf),
			\accent, Pseq([
				1,1,0,1, 
			],inf),
			\dur, 1/16,
			\amp, 0.1 * ( Pkey(\accent) + 1 ) / 2,
		),
		
	])
)).play;
);

(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	sig = sig * \gain.kr(1);
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
);
Ndef(\soundin).play(0,2)
Ndef(\soundin).edit;
Ndef(\soundin).stop
