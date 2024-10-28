
// sea pimp taiko bass
~t = 140/4/60; TempoClock.default.tempo = ~t;
~swing = 0.3;
// load project

FileSystemProject.load("holis/synthdef.scd");
(
SynthDef(\bass_fmek, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\bass_fmekoct_ampcomp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig5 = SinOsc.ar(freq*2 * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4 + (sig5 * 0.5);
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * AmpCompA.kr(freq);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\bass_fmek_ampcomp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * AmpCompA.kr(freq);
	sig = HPF.ar(sig, 50);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\bass_fmek_lpf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = LPF.ar(sig, \lpf.kr(1000));
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\bass_fmek2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	lfo2 = SinOsc.ar(1/~t) * XLine.kr(1/2,0.1,2) + 0.51; 
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\distreb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),Trig.kr(\itrig.tr(1), \tsustain.kr(0.1)),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\violin, {
	| out=0, freq=200, gate=1, amp=0.1, pan=0 |
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.1), gate, doneAction:2);
	var sig = VarSaw.ar(
		freq,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8)
	)*0.25;
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
);
(
SynthDef(\playersec_fx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * SinOsc.ar(\amplfo.kr(8*~t)).range(env1,1);
	sig = sig + FreqShift.ar(sig, SinOsc.kr(\shiftlfo.kr(4*~t)).range(env2,1));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
);

////////////////
(
	~swing = 0.3;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	~swing = 0.3;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bass_fmek,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				//7,0,0,0, 0,0,0,0,
				//0,0.8,0,0, 0.8,0,0.5,0.7,
				7,0,0,0, 0,0,0,0,
				0.8,0,0, 0.8,0,0.5,0.7,0
			],inf),
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,4,1,1,1]/2,1), 1/8).loop,
			\freqfac3, 
			Pseq([
				~pmodenv.(Pseq([1,1,1,8,1,1,8,1,1],1), 1/8, 1, \step),
				~pmodenv.(Pseq([1,1,1,8,1,2,8,1,2],1), 1/8, 1, \step),
				//~pmodenv.(Pseq([1,8,1,1,8,1,1,1],1), 1/8, 1, \step),
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~swing = 0.3;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bass_fmek,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				Pstep(Pseq([
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([1,0.7,4],[0.1,2.8]) ],
				],inf),2),
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
			],inf),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma1, 0.1,
			\fma2, 0.1,
			\fma3, 0.2,
			\fma4, ~pmodenv.(Pseq([2,2,8,2,1,4,1],1), 1/4).loop,
			//\fma4, 1.4,
			\freqfac3, ~pmodenv.(Pseq([1,2,8,1,2,8,1,2],inf), 1/4, 1, \step).loop,
			\freqfac2, 1,
			\freqfac1, 1,
			\legato, 0.4,
			\octave, 3,
			\note, Pseq([
				Pstep(Pseq([0,-2,-4,1],inf),1),
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\melo, 
	Pbind(
		\instrument, \bass_fmek,
		\amp, 0.1/8,
	)
)
);



////////////////
(
Ndef(\hinoise, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Gate.kr(LFNoise0.kr(12).range(0.5,1.0), Dust.kr(1)) * Line.kr(0,1/2,1) +1;
	//sig = LFPulse.ar(17750 * LFNoise0.kr(12 * LFNoise0.kr(1/2).range(0.01,1.0)).range(0.5,1.0));
	sig = LFPulse.ar(17750 * Gate.kr(LFNoise0.kr(12).range(0.5,1.0), Dust.kr(1)));
	sig = BPF.ar(sig, 10700 * lfo1);
	sig = sig.fold2( LFNoise1.kr(1/2).range(0.0,1.0) );
	sig = CombL.ar(sig, 4/~t, 1/8/~t,4/~t) + sig;
	sig = Pan2.ar(sig, pan, amp) * 0.1;
}).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bass_fmek2,
			\note, Pseq([
				0,1,-6,-6,
			],inf),
			\legato, Pseq([
				1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(
			 \bass_fmek,
			\note, Pstep(Pseq([
				//[0,-6]+12,
				[-12,0,6,-6,12],
			],inf),8),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \distreb,
			\note, Pseq([
				[4,10,-2],
				[6,11],
				[6,1],
				[6,1,2],
				//[0,6],
			],inf),
			\tsustain, 1,
			\octave, 6,
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \distreb,
			\note, Pseq([
				0,3,
			],inf),
			\tsustain, 1,
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \bass_fmek2,
			\note, Pseq([
				0,1,-6,-6,
			],inf),
			\legato, Pseq([
				1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(
			 \bass_fmek,
			\note, Pstep(Pseq([
				//[0,-6]+12,
				[-12,0,6,-6,12],
			],inf),8),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \distreb,
			\note, Pseq([
				[4,10,-2],
				[6,11],
				[6,1],
				[6,1,2],
				//[0,6],
			],inf),
			\tsustain, 1,
			\octave, 6,
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/2,
		),
		

		//

		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,1,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
		
				0,0,0, 0,0,1,  0,0,0, 0,0,1,
				0,0,0, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1812].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8,
			\gain, 0.08,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			\gain, 0.11,
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 1,0,0,  0,0,1, 0,0,1,
				0,1,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1 * Pseq([
				1,1,1/8, 1/2,1,1,  1,1,1/4, 1,1,1,
			],inf),
			\speed, 0.9,
			\velamp, 1,
			\dur, 1/12,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			\gain, 0.11,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1,
			\speed, 0.9,
			\velamp, 1/1,
			\dur, 1/12,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
	])
)).play;
);

//////////////////////////
// with arper
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \bass_fmek2,
			\note, Pseq([
				0,1,-6,-6,
			],inf),
			\legato, Pseq([
				1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(
			 \bass_fmek,
			\note, Pstep(Pseq([
				//[0,-6]+12,
				[-12,0,6,-6,12],
			],inf),8),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \distreb,
			\note, Pseq([
				[4,10,-2],
				[6,11],
				[6,1],
				[6,1,2],
				//[0,6],
			],inf),
			\tsustain, 1,
			\octave, 6,
			\iadsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/2,
			\isRest, true,
		),
		

		//

		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 1,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,1,  0,0,0, 0,0,1,
				0,0,1, 1,0,0,  0,0,0, 0,0,0,
		
				0,0,0, 0,0,1,  0,0,0, 0,0,1,
				0,0,0, 1,0,0,  0,0,0, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,0,
			],inf).coin.not,
			\amp, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1812].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8,
			\gain, 0.08,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,1,
			],inf).coin.not,
			\speed, 1.01,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			\gain, 0.11,
			\dur, 1/12,
			\isRest, Pseq([
				1,0,0, 1,0,0,  0,0,1, 0,0,1,
				0,1,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1 * Pseq([
				1,1,1/8, 1/2,1,1,  1,1,1/4, 1,1,1,
			],inf),
			\speed, 0.9,
			\velamp, 1,
			\dur, 1/12,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			\gain, 0.11,
			\dur, 1/12,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1,
			\speed, 0.9,
			\velamp, 1/1,
			\dur, 1/12,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,1, 0,0,1,  0,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\speed, 0.9,
			\velamp, 1/1,
			\dur, 1/12,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/12,
			\amp, 0.01 * Pseq([1,0.6,0.2],inf),
		),
	])
)).play;
);

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[4,10,-2],
			[6,11],
			[6,1],
			[6,1,2],
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			//it.debug("it");
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part2, Pdef(\patarper, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/12, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\lpf, 400,
			\amp, 0.1/2,
			\dur, PdurStutter(Pseq([6,6,6,12],inf), 1),
			\arp, Pseq([0,0,1,4,4,4,4,0,0],inf),
			\legato, Pseq([
				1,0,1, 0,1,1,  0,1,0, 1,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\isRest, true,
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 7, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\legato, 1,
			\amp, 0.1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\amp, 0.1,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 4, \prepeat,4,
			\instrument, \bass_fmek_ampcomp,
			\arp, 
			Pseq([
				Pseq([0,0,1,1, 0,1,2,3],6),
				Pseq([0,0,1,1, 0,1,4,3],2),
			],inf)+ Pstep(Pseq([0,0,0,1,0,0,0,2],inf),2),
			
			\legato, Pseq([
				//7,0,0,0, 0,0,0,0,
				//0,0.8,0,0, 0.8,0,0.5,0.7,
				7,0,0,0, 0,0,0,0,
				0.8,0,0,0.8, 0,0.5,0.7,0,
				4,0,0,0, 0,0,1.2,0,
				0.8,0,0,0,  1.8,0,0.7,0,
			],inf),
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,4,1,1,1]/2,1), 1/8).loop,
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,1,1,1,1]/2,1), 1/8).loop,
			\freqfac3, 
			Pseq([
				~pmodenv.(Pseq([1,1,1,8,1,1,8,1,1],1), 1/8, 1, \step),
				~pmodenv.(Pseq([1,1,1,8,1,2,8,1,2],1), 1/8, 1, \step),
				//~pmodenv.(Pseq([1,8,1,1,8,1,1,1],1), 1/8, 1, \step),
			],inf),
			\octave, 3,
			//\lag, [0.0,0.1001],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/2,
		),
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-Q6BI-BDE9", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.53781512605042,
	'fb', 0.00099281392423591,
	'delay', 0.0001,
	'delay2', 0.85659021536855,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 10.394574653723,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 90.467414895442,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
////////////////////
// record violin

BufDef(\violinloop8, 8/~t*s.sampleRate, 2)
(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[4,10,-2],
			[6,11],
			[6,1],
			[6,1,2],
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			//it.debug("it");
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part2, Pdef(\patarper, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\legato, 1,
			\amp, 0.1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\amp, 0.1,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\recorder,
			\inbus, 0,
			\bufnum, BufDef(\violinloop8),
			\addAction, \addToTail,
			\lag, 0.0001,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\violinsample, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('violinloop8'),
			\pos, Pseq([0,1],inf)/~t,
			\legato, 1,
			\dur, 1/1,
			\gain, 1,
		)
		
	])
)).play;
);
(
Pdef(\part2, Pdef(\violinsample, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('violinloop8'),
			\pos, Pseq([0,1],inf) / ~t,
			\legato, 1,
			\dur, Pstep(1/Pseq(2**(0..5),inf),1/2),
			\gain, 1,
		)
		
	])
)).play;
);

/////////////
// record kalimba

BufDef(\kalimbaloop8, 8/~t*s.sampleRate, 2)
(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[4,10,-2],
			[6,11],
			[6,1],
			[6,1,2],
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			//it.debug("it");
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part2, Pdef(\patarper, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 7, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\recorder,
			\inbus, 0,
			\bufnum, BufDef(\kalimbaloop8),
			\addAction, \addToTail,
			\lag, 0.0001,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part3, Pdef(\kalimbasample, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('kalimbaloop8'),
			\pos, Pseq([0,0,1,\r,\r,1,3,6]/2,inf)/~t,
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		)
		
	])
)).play;
);
BufDef('kalimbaloop8').play

/////////////
// record bass

BufDef(\bassloop8, 8/~t*s.sampleRate, 2)
(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[4,10,-2],
			[6,11],
			[6,1],
			[6,1,2],
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			//it.debug("it");
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part2, Pdef(\patarper, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 4, \prepeat,4,
			\instrument, \bass_fmek_ampcomp,
			\arp, 
			Pseq([
				Pseq([0,0,1,1, 0,1,2,3],6),
				Pseq([0,0,1,1, 0,1,4,3],2),
			],inf)+ Pstep(Pseq([0,0,0,1,0,0,0,2],inf),2),
			
			\legato, Pseq([
				//7,0,0,0, 0,0,0,0,
				//0,0.8,0,0, 0.8,0,0.5,0.7,
				7,0,0,0, 0,0,0,0,
				0.8,0,0,0.8, 0,0.5,0.7,0,
				4,0,0,0, 0,0,1.2,0,
				0.8,0,0,0,  1.8,0,0.7,0,
			],inf),
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,4,1,1,1]/2,1), 1/8).loop,
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,1,1,1,1]/2,1), 1/8).loop,
			\freqfac3, 
			Pseq([
				~pmodenv.(Pseq([1,1,1,8,1,1,8,1,1],1), 1/8, 1, \step),
				~pmodenv.(Pseq([1,1,1,8,1,2,8,1,2],1), 1/8, 1, \step),
				//~pmodenv.(Pseq([1,8,1,1,8,1,1,1],1), 1/8, 1, \step),
			],inf),
			\octave, 3,
			//\lag, [0.0,0.1001],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/1.5,
			\out, BusDef(\ifx1,\audio),
		),
		Pmono(\recorder,
			\inbus, BusDef(\ifx1,\audio),
			\bufnum, BufDef(\bassloop8),
			\addAction, \addToTail,
			\lag, 0.0001,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part3, Pdef(\basssample, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('bassloop8'),
			\pos, Pseq([0,0,1,\r,\r,1,3,6]/2,inf)/~t,
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		)
		
	])
)).play;
);
BufDef('bassloop8').play

//////////
// record all
(
BufDef(\violinloop8, 8/~t*s.sampleRate, 2);
BufDef(\kalimbaloop8, 8/~t*s.sampleRate, 2);
BufDef(\bassloop8, 8/~t*s.sampleRate, 2);

ProtoDef(\rdn2).outBus = BusDef(\rec2, \audio);
ProtoDef(\rdn).outBus = BusDef(\rec3, \audio);

ProtoDef('rdn').make('deldefault', 'rdn', "5-QBGD-FN8U", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.60504201680672,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.92552159097914,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.9875557887935,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 90.467414895442,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn2').make('deldefault', 'rdn2', "4-7Q01-SRF1", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.21428571428571,
	'fb', 0.0001,
	'delay', 0.85659021536855,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
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



(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[4,10,-2],
			[6,11],
			[6,1],
			[6,1,2],
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			//it.debug("it");
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part2, Pdef(\patarper, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 4, \prepeat,4,
			\instrument, \bass_fmek_ampcomp,
			\arp, 
			Pseq([
				Pseq([0,0,1,1, 0,1,2,3],6),
				Pseq([0,0,1,1, 0,1,4,3],2),
			],inf)+ Pstep(Pseq([0,0,0,1,0,0,0,2],inf),2),
			
			\legato, Pseq([
				//7,0,0,0, 0,0,0,0,
				//0,0.8,0,0, 0.8,0,0.5,0.7,
				7,0,0,0, 0,0,0,0,
				0.8,0,0,0.8, 0,0.5,0.7,0,
				4,0,0,0, 0,0,1.2,0,
				0.8,0,0,0,  1.8,0,0.7,0,
			],inf),
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,4,1,1,1]/2,1), 1/8).loop,
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,1,1,1,1]/2,1), 1/8).loop,
			\freqfac3, 
			Pseq([
				~pmodenv.(Pseq([1,1,1,8,1,1,8,1,1],1), 1/8, 1, \step),
				~pmodenv.(Pseq([1,1,1,8,1,2,8,1,2],1), 1/8, 1, \step),
				//~pmodenv.(Pseq([1,8,1,1,8,1,1,1],1), 1/8, 1, \step),
			],inf),
			\octave, 3,
			//\lag, [0.0,0.1001],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/1.5,
			\out, BusDef(\rec1,\audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/16, \octave, 7, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([1,0,2,2,2,2,0,0,0,0],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\legato, 1,
			\amp, 0.1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 4, \prepeat,4,
			\instrument, \violin,
			\dur, Prand([1,1/2,2],inf) * 1/8,
			\amp, 0.1,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\recorder,
			\inbus, BusDef(\rec1, \audio),
			\bufnum, BufDef(\bassloop8),
			\addAction, \addToTail,
			\lag, 0.0001,
			\dur, 1,
		),
		Pmono(\recorder,
			\inbus, BusDef(\rec2, \audio),
			\bufnum, BufDef(\kalimbaloop8),
			\addAction, \addToTail,
			\lag, 0.0001,
			\dur, 1,
		),
		Pmono(\recorder,
			\inbus, BusDef(\rec3, \audio),
			\bufnum, BufDef(\violinloop8),
			\addAction, \addToTail,
			\lag, 0.0001,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\test, Pdef(\testme, 
	Ppar([
		Pmono( \playersec,
			\bufnum, [
				BufDef('bassloop8'),
				BufDef('kalimbaloop8'),
				BufDef('violinloop8'),
			],
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		)
		
	])
)).play;
);


//////////////////////// base
////////// drums
(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11/1.5,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11/1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[835].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0, 0,1,0,  0,1,1, 0,0,1,
				1,1,1, 0,1,1,  1,0,1, 0,1,0,
				1,0,1, 1,1,1,  1,0,0, 1,0,1,
				0,0,0, 0,1,1,  1,1,0, 0,0,1,
				1,0,1, 1,0,0,  1,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.11/4,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\drums3, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11/1.5 * Pseq([
				//Pwhite(0.5,0.9,2)
				Pwhite(0.9,1,2),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, 1.10,
			\isRest, Pseq([
			   	0,0,0,0, 1,1,1,1, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[305].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/16,
			\dur, 1/16 * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\gain, 0.11/2 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.5,0.9,1)
			],inf),
		),
	])
)).play;
);
Pdef(\part).clear;

////////// loops

(
Pdef(\part, Pdef(\loops, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('violinloop8'),
			\pos, Pseq([0,1,0,1,1,2,3,4],inf)/~t,
			\legato, 1,
			\dur, 1/1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('kalimbaloop8'),
			\pos, Pseq([
				0,0,1,\r, \r,1,3,6,
				0,0,1,\r, 1,\r,3,6,
				0,0,1,\r, \r,1,3,6,
				4,4,5,6, 7,\r,\r,\r,
			]/2,inf)/~t,
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		),
	])
)).play;
);

////////// scratches

(
Pdef(\part, Pdef(\scratches, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				1.8,0.1, 0.8,0.1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\gain, 0.5/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec_fx,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, 1.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2),
			],inf),
			\gain, 0.6/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf) +0.3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				0,1,1,1, 1,0,1,1, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, 4.0,
			\gain, 0.2/3,
			\dur, 1/16,
		),
	])
)).play;
);


Pdef(\part2).clear;

(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[4,10,-2],
			[6,11],
			[6,1],
			[6,1,2],
		],inf),1),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			//it.debug("it");
			it.wrapAt(ev[\arp]);
		}),
	)
);
Pdef(\part2, Pdef(\patarper, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/12, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\lpf, 400,
			\amp, 0.1/2,
			\dur, PdurStutter(Pseq([6,6,6,12],inf), 1),
			\arp, Pseq([0,0,1,4,4,4,4,0,0],inf),
			\legato, Pseq([
				1,0,1, 0,1,1,  0,1,0, 1,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		),
		
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 4, \plen, 2, \prepeat,8*16,
			\instrument, \Piano_rhodeySC,
			\amp, 0.1/2,
			\legato, 0.2,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				1,0,1,1, 1,1,1,1,
			],inf).coin.not,
		),
		Pdef(\arper) <> Pbind(\dur, 1/6, \octave, 6, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([4,3,0,1,0,1],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,0,1, 1,1,1,  0,0,0, 0,0,0,
				1,0,1, 1,1,1,  0,0,0, 0,1,0,
				1,1,1, 1,1,1,  0,0,0, 0,0,0,
				1,0,1, 1,1,1,  0,1,0, 1,1,0,
			],inf).coin.not,
		),
		Pmono(
			 \bass_fmek,
			\note, Pstep(Pseq([
				//[0,-6]+12,
				[-12,0,6,-6,12],
			],inf),8),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\amp, 0.1/8,
		),
	])
)).play;
);

(
Pdef(\part4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				1.8,0.1, 0.8,0.1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\gain, 0.5/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec_fx,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, 1.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2),
			],inf),
			\gain, 0.6/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf) +0.3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				0,1,1,1, 1,0,1,1, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, 4.0,
			\gain, 0.2/3,
			\dur, 1/16,
		),
	])
).play;
)



(
	/// cool hip hop loop !!!
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		// samples
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('violinloop8'),
			\pos, Pseq([0,1],inf)/~t,
			\legato, 1,
			\dur, 1/1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('kalimbaloop8'),
			\pos, Pseq([0,0,1,\r,\r,1,3,6]/2,inf)/~t,
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		),
		// scratches
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				1.8,0.1, 0.8,0.1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\gain, 0.5/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec_fx,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, 1.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2),
			],inf),
			\gain, 0.6/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf) +0.3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				0,1,1,1, 1,0,1,1, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, 4.0,
			\gain, 0.2/3,
			\dur, 1/16,
		),
		// drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11/1.5 * Pseq([
				//Pwhite(0.5,0.9,2)
				Pwhite(0.9,1,2),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, 1.10,
			\isRest, Pseq([
			   	0,0,0,0, 1,1,1,1, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[305].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/16,
			\dur, 1/16 * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\gain, 0.11/2 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.5,0.9,1)
			],inf),
		),
	])
)).play;
);

(
	/// chhloop var
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		// bass
		Pbind(\dur, 1/8, \octave, 3, \plen, 4, \prepeat,4,
			\instrument, \bass_fmekoct_ampcomp,
			\arp, Pseq([
				Pseq([0,0,1,1, 0,1,2,3],6),
				Pseq([0,0,1,1, 0,1,4,3],2),
			],inf)+ Pstep(Pseq([0,0,0,1,0,0,0,2],inf),2),
			
			\cnote, Pstep(Pseq([
				[4,10,-2],
				[6,11],
				[4,10,-2],
				[6,11],
				[4,10,-2],
				[6,11],
				//[6,1],
				[6,1,2],
				[6,1,2],
			],inf),1),
			\note, Pfunc({ arg ev;
				var it;
				it = ev[\cnote] % 12;
				it = [-12,0,12] +.x it;
				//it.debug("it");
				it.wrapAt(ev[\arp]);
			}),

			\legato, Pseq([
				//7,0,0,0, 0,0,0,0,
				//0,0.8,0,0, 0.8,0,0.5,0.7,
				7,0,0,0, 0,0,0,0,
				0.8,0,0,0.8, 0,0.5,0.7,0,
				4,0,0,0, 0,0,1.2,0,
				0.8,0,0,0,  1.8,0,0.7,0,
			],inf),
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,4,1,1,1]/2,1), 1/8).loop,
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,1,1,1,1]/2,1), 1/8).loop,
			\freqfac3, 
			Pseq([
				~pmodenv.(Pseq([1,1,1,8,1,1,8,1,1],1), 1/8, 1, \step),
				~pmodenv.(Pseq([1,1,1,8,1,2,8,1,2],1), 1/8, 1, \step),
				//~pmodenv.(Pseq([1,8,1,1,8,1,1,1],1), 1/8, 1, \step),
			],inf),
			\octave, 3,
			//\lag, [0.0,0.1001],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/2,
		),
		// samples
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef('bassloop8'),
			//\pos, Pstep(Pseq([1,2,1,2,0,1,3,4],inf),1)+0,
			////\lag, 1/2/~t,
			//\speed, 1,
			//\isRest, Pseq([
				//1,0,
			//],inf).coin.not,
			//\legato, 1,
			//\dur, PdurStutter(Pseq([1,1,1,1, 1,1,1,4, 1,1,1,1, 1,1,1,1],inf), 1/4),
			//\gain, 2,
			//\out, BusDef(\sendbus3, \audio),
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('violinloop8'),
			\pos, Pseq([0,1,0,1,1,2,3,4],inf)/~t,
			\legato, 1,
			\dur, 1/1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('kalimbaloop8'),
			\pos, Pseq([
				0,0,1,\r, \r,1,3,6,
				0,0,1,\r, 1,\r,3,6,
				0,0,1,\r, \r,1,3,6,
				4,4,5,6, 7,\r,\r,\r,
			]/2,inf)/~t,
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		),
		// scratches
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf),
			\legato, Pseq([
				1.8,0.1, 0.8,0.1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\gain, 0.5/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec_fx,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				4,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\speed, 1.2,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2),
			],inf),
			\gain, 0.6/3,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				1.9,0.5,2,0.6,
				1.9,0.5,2.1,0.6,
				1.9,0.5,2,0.6,
				1.5,0.5,2.1,0.6,
			],inf) +0.3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				0,1,1,1, 1,0,1,1, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, 4.0,
			\gain, 0.2/3,
			\dur, 1/16,
		),
		// drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11/1.5 * Pseq([
				//Pwhite(0.5,0.9,2)
				Pwhite(0.9,1,2),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\speed, 1.10,
			\isRest, Pseq([
			   	0,0,0,0, 1,1,1,1, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[310].value,
			\speed, 1.0,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/16,
			\dur, 1/16 * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\gain, 0.11/3 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.5,0.9,1)
			],inf),
		),
	])
)).play;
);


/////////// rdn drums
(
Pdef(\part, Pdef(\drumsrdn1, 
	Ppar([
		
		Pbind(\out, BusDef(\mixer1)) <> Pdef(\scratches),
		Pdef(\rdkick,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1123].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pdef(\rdsnare,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1824].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pdef(\rdhat,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[16].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 0.11/1.5,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pdef(\rdclap,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[305].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/16,
			\dur, 1/16 * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\gain, 0.11/2 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.5,0.9,1)
			],inf),
			\out, BusDef(\sendbus3, \audio),
		)),
	])
)).play;
);

ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-E6CL-MN04", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.16806722689076,
	'gain', 0.60504201680672,
	'fb', 0.0042483227568983,
	'delay', 0.00090778539919376,
	'delay2', 0.0067909850299557,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.6221239391292,
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

(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-E75B-7BEH", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.21008403361345,
	'gain', 0.76050420168067,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 21.474980250767,
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


SampleTimeline(\rec_sun55_mainTimeline_t0_240423_042626).play

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline(\rec_sun55_mainTimeline_t0_240423_042626).buffer,
			\pos, Pseq([
				8,\r,12,0, 7,\r,0,\r,
				\r,8,10,0, 7,\r,10,\r,
				0,\r,10,0, 7,\r,0,\r,
				\r,0,10,0, 7,\r,10,\r,
			],inf)/8 + 0.04,
			\legato, 1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline(\rec_sun55_mainTimeline_t0_240423_042626).buffer,
			\pos, Pseq([
				//Pseq((0..7),inf),
				\r,\r,\r,\r, 2,2,2,2,
				\r,6,6,6, \r,\r,\r,\r,
				2,2,2,2, \r,\r,\r,\r,
				4,\r,\r,\r, 2,2,2,2,

				\r,\r,\r,\r, 0,2,2,2,
				\r,6,6,6, \r,\r,\r,\r,
				2,2,2,2, \r,\r,\r,\r,
				4,\r,\r,\r, 2,2,2,2,

				2,2,2,2, \r,\r,\r,\r,
				\r,\r,\r,\r, 2,2,2,2,
				6,6,6,6, 5,7,1,9,
				12,15,11,\r, \r,\r,\r,8,
				2,2,2,2, 8,\r,\r,\r,
				\r,\r,\r,\r, 2,2,2,2,
				6,6,20,6, \r,2,0,9,
				4,5,11,\r, \r,\r,\r,8,

			],inf)/8 / ~t + 0.04,
			//\pos, Pseg(Pseq([0,1]*2,inf),2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 1,
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\gain, 1/1.4,
		)
		
	])
)).play;
);


//////////////////////
// techno


(
Pdef(\test, Pdef(\testme, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\legato, 0.1,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, [
				BufDef('bassloop8'),
				BufDef('kalimbaloop8'),
				BufDef('violinloop8'),
			],
			\pos, 1/~t,
			\legato, 1,
			\dur, 1/1,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\test, Pdef(\testme, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\legato, 0.1,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2197].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1081].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pser([
					1,0.5,
				],8*6),
				1,0,1,0, 1,0,1,1,
				1,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,0,-1,0],inf))),
			\gain, 0.11/2.4 * Pseq([
				Pwhite(0.8,1,1),
				Pwhite(0.01,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('bassloop8'),
			\pos, Pseq([
				1,1,1,3,
			],inf)/~t,
			\legato, 1,
			\dur, 1/1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('kalimbaloop8'),
			\speed, 1/2,
			\pos, Pseq([

				5,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				5,\r,\r,\r, 5,6,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,

				5,\r,\r,\r, \r,5,\r,\r,
				\r,1,1,\r, \r,5,6,7,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,1,1,\r, 0,0,3,3,
			],inf)/~t,
			\legato, 1,
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('violinloop8'),
			\pos, Pseq([
				0,1,
				0,1,
				0,1,
				4,5,
			],inf)/~t,
			\legato, 1,
			\dur, 1/1,
			\gain, 1,
		),
		
	])
)).play;
);


//////////////// tests

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 4, \prepeat,4,
			\instrument, \bass_fmek_ampcomp,
			\arp, 
			Pseq([
				Pseq([0,0,1,1, 0,1,2,3],6),
				Pseq([0,0,1,1, 0,1,4,3],2),
			],inf)+ Pstep(Pseq([0,0,0,1,0,0,0,2],inf),2),
		
			\legato, Pseq([
				//7,0,0,0, 0,0,0,0,
				//0,0.8,0,0, 0.8,0,0.5,0.7,
				7,0,0,0, 0,0,0,0,
				0.8,0,0,0.8, 0,0.5,0.7,0,
				4,0,0,0, 0,0,1.2,0,
				0.8,0,0,0,  1.8,0,0.7,0,
			],inf),
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,4,1,1,1]/2,1), 1/8).loop,
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,1,1,1,1]/2,1), 1/8).loop,
			\freqfac3, 
			Pseq([
				~pmodenv.(Pseq([1,1,1,8,1,1,8,1,1],1), 1/8, 1, \step),
				~pmodenv.(Pseq([1,1,1,8,1,2,8,1,2],1), 1/8, 1, \step),
				//~pmodenv.(Pseq([1,8,1,1,8,1,1,1],1), 1/8, 1, \step),
			],inf),
			\octave, 3,
			//\lag, [0.0,0.1001],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/2,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 3, \plen, 4, \prepeat,4,
			\instrument, \bass_fmek_ampcomp,
			\arp, 
			Pseq([
				Pseq([0,0,1,1, 0,1,2,3],6),
				Pseq([0,0,1,1, 0,1,4,3],2),
			],inf)+ Pstep(Pseq([0,0,0,1,0,0,0,2],inf),2),
			
			\legato, Pseq([
				//7,0,0,0, 0,0,0,0,
				//0,0.8,0,0, 0.8,0,0.5,0.7,
				7,0,0,0, 0,0,0,0,
				0.8,0,0,0.8, 0,0.5,0.7,0,
				4,0,0,0, 0,0,1.2,0,
				0.8,0,0,0,  1.8,0,0.7,0,
			],inf),
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,4,1,1,1]/2,1), 1/8).loop,
			\fma2, ~pmodenv.(Pseq([2,2,8,2,1,1,1,1,1]/2,1), 1/8).loop,
			\freqfac3, 
			Pseq([
				~pmodenv.(Pseq([1,1,1,8,1,1,8,1,1],1), 1/8, 1, \step),
				~pmodenv.(Pseq([1,1,1,8,1,2,8,1,2],1), 1/8, 1, \step),
				//~pmodenv.(Pseq([1,8,1,1,8,1,1,1],1), 1/8, 1, \step),
			],inf),
			\octave, 3,
			//\lag, [0.0,0.1001],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/2,
			\isRest, true,
		),
	])
)).play;
);
