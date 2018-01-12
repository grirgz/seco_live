
(
SynthDef(\snaretuned, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq

	// tonal component
	sig2 = SinOsc.ar([180, 330]*1.2).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]*1.3).sum;
	sig4 = sig2 + sig3 / 48;

	sig = sig + sig4 / 1.2;
	sig = HPF.ar(sig, env2);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\snapkickx, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
SynthDef(\iron, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	// freq clipped
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(( freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1) ).clip(20,19000)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/8 * \foldfreq.kr(1), (1..8) ) * \foldlevel.kr(1) + \foldbias.kr(1) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.7) * env1 * freq ).clip(20,19000), \rq.kr(0.5));
	pan = pan + (sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ) * \panfreq.kr(1));
	}) * \panwidth.kr(1));
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig * \gain.kr(18);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(),
))).add;
)


(
SynthDef(\fmcymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1)) * \fmamp.kr(1) + 1 ));
	sig = sig.fold(\fold.kr(0.23));
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1/70,0.1,0.8,0.2)),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\plop, Pbind(
	\instrument, \fmcymbal,
	\freq, 7200,
	\fmr, 1/2,
	\diff, 1.2,
	\fold, 0.7,
	\sustain, 0.1,
	\dur, 1,
	\amp, 0.1,
)).play;
)

(
SynthDef(\snaretuked, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	var freqx;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([140,210,231],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	//sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	//sig = ( pop/2 ) + ( sig );
	//sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq

	// tonal component
	sig2 = SinOsc.ar([180, 330]*1.2).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]*1.3).sum;
	sig4 = sig2 + sig3 / 48;

	//sig = sig + sig4 / 1.2;
	//sig = HPF.ar(sig, env2);

	freqx = 200;
	sig = SinOsc.ar(freqx * ( LFSaw.ar(freqx * \fmr.kr(1) * ((0..7)/7 - 0.5 * \diff.kr(4) + 1)) * \fmamp.kr(4) + 1 ));

	sig2 = sig * 0.02;
	sig3 = sig2 + sig3 / 48;
	sig2 = pop;
	//sig2 = BPF.ar(pop, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 1130);
	sig2 = sig2 * 1;
	sig2 = HPF.ar(sig2, 1000);
	
	sig = WhiteNoise.ar!2;
	sig = LPF.ar(sig, 6700);
	sig = Ringz.ar(sig, 700,0.001)*0.1 + sig;
	sig = Ringz.ar(sig, 1700,0.001)*0.1 + sig;
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.2], [1,-1]), 1);
	//sig = BPF.ar(sig, MouseX.kr(100,3000).poll);

	sig1 = SinOsc.ar( EnvGen.kr(Env([5001,240,201],[0.01,8.1]), 1)) ;
	sig1 = sig1 * EnvGen.kr(Env([0,1,0],[0.01,0.01]), 1);
	sig = sig + sig1;
	sig = sig * 1;
	sig = sig2 + sig;
	sig = sig3 + sig;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\snaretuked, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	var freqx;
	
	sig1 = WhiteNoise.ar!2;
	sig1 = LPF.ar(sig1, \noiselpf.kr(6500));
	sig1 = Ringz.ar(sig1, 700,0.001)*0.1 + sig1;
	sig1 = Ringz.ar(sig1, 1700,0.001)*0.1 + sig1;
	sig1 = sig1 * EnvGen.kr(\noiseenv.kr(Env([0,1,0],[0.01,0.2], [1,-1])), 1);

	sig2 = SinOsc.ar( EnvGen.kr(Env([5001,240,201],[0.01,8.1]), 1)) ;
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[0.01,0.01]), 1);

	sig = sig1 + sig2;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\snaretuked, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	var freqx;
	
	sig1 = WhiteNoise.ar!2;
	sig1 = LPF.ar(sig1, \noiselpf.kr(6500));
	sig1 = Ringz.ar(sig1, 700,0.001)*0.1 + sig1;
	sig1 = Ringz.ar(sig1, 1700,0.001)*0.1 + sig1;
	sig1 = sig1 * EnvGen.kr(\noiseenv.kr(Env([0,1,0],[0.01,0.2], [1,-1])), 1);

	sig2 = SinOsc.ar( EnvGen.kr(Env([5001,240,201],[0.01,8.1]), 1)) ;
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[0.01,0.01]), 1);

	sig3 = WhiteNoise.ar!2;
	sig3 = BPF.ar(sig3, MouseX.kr(40,8000).poll,MouseY.kr(0.1,0.9))*2.5;
	sig3 = FreqShift.ar(sig3, 200);
	sig3 = sig3 * EnvGen.kr(Env([0,1,0],[0.01,0.2],[1,-1]), 1);

	sig = sig1 + sig2;
	sig = sig3;
	sig = sig1 + sig2 + sig3;
	sig = sig /1;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

Pdef(\part, Pdef(\sampled)).play;
Pdef(\part, Pdef(\synthed)).play;


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,
			],inf),1/2),
			\octave, Pseq([9,8,7],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			//\fmr, 1/2 * Pseq([1.12,1.12,1,1.12],inf).stutter(1),
			\fmr, 1/2,
			\lpfr, 4,
			\lpfr,1 * Pseq([
				3,3,4,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,4,0, 1,0,1,0, 0,0,1,0, 1,0,2,0,
				0,0,1,1, 1,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\gain, 0.92,
			\amp,0.1,
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.2) ],
			],inf),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snaretuned,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.0581) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
				0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 9,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
			\lpfr,2,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,0,1,0, 
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\panwidth, 0.2,
			\gain, 2,
			\amp,0.05,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\sampled, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,
			],inf),1/2),
			\octave, Pseq([9,8,7],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			//\fmr, 1/2 * Pseq([1.12,1.12,1,1.12],inf).stutter(1),
			\fmr, 1/2,
			\lpfr, 4,
			\lpfr,1 * Pseq([
				3,3,4,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,4,0, 1,0,1,0, 0,0,1,0, 1,0,2,0,
				0,0,1,1, 1,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\gain, 0.92,
			\amp,0.1,
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
				0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.052,
			\dur, 1/16,
		)),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 9,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
			\lpfr,2,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,0,1,0, 
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\panwidth, 0.2,
			\gain, 2,
			\amp,0.05,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,
			],inf),1/2),
			\octave, Pseq([9,8,7],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			//\fmr, 1/2 * Pseq([1.12,1.12,1,1.12],inf).stutter(1),
			\fmr, 1/2,
			\lpfr, 4,
			\lpfr,1 * Pseq([
				3,3,4,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,4,0, 1,0,1,0, 0,0,1,0, 1,0,2,0,
				0,0,1,1, 1,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\gain, 0.92,
			\amp,0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(\pos, Pkey(\pos)+0.05)<>
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.15,
			\sustain, 0.09,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \snaretuked,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
				0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.052,
			\dur, 1/16,
			\isRest, true,
		)),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 9,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
			\lpfr,2,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,0,1,0, 
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\panwidth, 0.2,
			\gain, 2,
			\amp,0.05,
			\isRest, true,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\synthed, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,
			],inf),1/2),
			\octave, Pseq([9,8,7],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			//\fmr, 1/2 * Pseq([1.12,1.12,1,1.12],inf).stutter(1),
			\fmr, 1/2,
			\lpfr, 4,
			\lpfr,1 * Pseq([
				3,3,4,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.2) ],
				[ Env.adsr(0.01,0.01,0.8,0.1) ],
				[ Env.adsr(0.01,0.01,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,4,0, 1,0,1,0, 0,0,1,0, 1,0,2,0,
				0,0,1,1, 1,0,1,0, 0,0,1,0, 0,0,2,0,
				0,0,1,0, 0,0,1,0, 0,0,1,0, 1,0,0,0,
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\gain, 0.92,
			\amp,0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(\pos, Pkey(\pos)+0.02)<>
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.15,
			\sustain, 0.05,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		)),
		Pbind(
			\instrument, \snaretuked,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.5,0.4,1,-1) ],
			],inf),
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \snaretuked,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\amp, 0.071 * 0.4,
			\noiselpf, 5500,
			\noiseenv, Pseq([
				[ Env([0,1,0],[0.01,0.1]) ]
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.5,0.1,1,-1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
				0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
				0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/16,
		),
		Pbind(
			\instrument, \iron,
			\note, Pstep(Pseq([
				0,0,0,-1,
			],inf),1/2) + [0,3,7],
			\octave, 9,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, 1.1,
			\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
			\lpfr,2,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,0,1,0, 
			],inf)/10,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\panwidth, 0.2,
			\gain, 2,
			\amp,0.05,
		),
	])
)).play;
)

//////////////////////////////////////////////////////////::


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,1.5,1],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.08,
		)!4,
		
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.08,
		)!4,
		
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0600001231 * Pseq([
				1,1/10,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.00600001231 * Pseq([
				Prand([1,2,3,4,5])
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000600001231 * Pseq([
				Prand([1,2,3,4,5])
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)


(
////// this is a track!
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				0,5,4,3,
			],inf),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, 500,
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, 0.1,
			\fmr, 1/8,
			\lpfr,2,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				4,0,0,0,
				1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,1,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2,
			\amp,0.08,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000600001231 * Pseq([
				Prand([1,2,3,4,5])
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
			\addAction, \addToTail,
		)
		
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				1,0,
			],inf),
			\octave, 7,
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, 0.4 * Pseg(Pseq([0,3],inf),8),
			\fmr, 1/2,
			\lpfr,1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, 1/4,
			\panwidth, Pwhite(0.01,1),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.00600001231 * Pseq([
				1,1/10,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2 * Pseq([
				~pmodenv.(Pseq([1,1,1,1,0.01,0.1,0.1,0.04],inf), 1/8),
			],inf),
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.00600001231 * Pseq([
				Prand([1,2,3,4,5])
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2 * Pseq([
				~pmodenv.(Pseq([
					1,1,1.04,0.04,
					1,0.04, 1,0.04,
					1,1,0.04,0.04,
				],inf).stutter(4), 1/8),
			],inf),
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.00000001231 * Pseq([
				Prand([1,2,3,4,5,1000,2000])
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
			\isRest, true,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2 * Pseq([
				~pmodenv.(Pseq([
					1,1,1.04,0.04,
					1,0.04, 1,0.04,
					1,1,0.04,0.04,
				],inf).stutter(4), 1/8),
			],inf),
			\amp,0.18,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				[0,3,7],
				[0,5,9],
				[0,4,7,11],
				[0,3,9,12],
			],inf),
			\octave, Ptuple(Prand([5,6,6,6,7],inf)!3),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, 0.03,
			\fmr, 1/2,
			\lpfr,1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.9,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur,4,
			\panwidth, 0.1,
			//\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.00000001231 * Pseq([
				Prand([1,2,3,4,5,1000,2000])
			],inf).stutter(2),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf),
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
			\isRest, true,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2 * Pseq([
				~pmodenv.(Pseq([
					1,1,1.04,0.04,
					1,0.04, 1,0.04,
					1,1,0.04,0.04,
				],inf).stutter(4), 1/8),
			],inf),
			\amp,0.18,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				[0,1,6,7],
				[0,1,6,7]+3,
				[0,1,6,7]+2,
			],inf),
			\octave, Ptuple(Prand([5,6,6,6,7],inf)!3),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, 0.03,
			\fmr, 1/2,
			\lpfr,1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.05) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.9,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, PdurStutter(Pseq([1,4,1,2],inf), 4),
			\panwidth, 0.1,
			//\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(
			\instrument, \iron,
			\dur, 1/8,
			\note, Pseq([
				0,12,1,
			],inf).stutter(Pseq([17,27],inf)),
			\diff, Pseq([0.01,1],inf).stutter(Pseq([15,25],inf)),
			\fmr, Pseq([1.8,1],inf).stutter(Pseq([15,25],inf)),
			\hpf, 160,
			\isRest, Pseq([
				1,1,1,1,1,0,0,1,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00101099467303085,
			'delay', 0.00000001231 * Pseq([
				Prand([1,2,3,4,5,1000,2000])
			],inf).stutter(2),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Pseq([
				[ Env([1,0.1,4],[0.1,0.8]) ]
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.2) ],
				[ Env.adsr(0.051,0.01,0.8,0.1) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2],inf)*8,
			\panwidth, Pwhite(0.01,1),
			\lag, Pwhite(0,0.2),
			\gain, 2,
			\out, BusDef(\sendbus1, \audio),
			\amp,0.18,
			\isRest, true,
		)!2,
		Pbind(
			\instrument, \iron,
			\freq, Pexprand(40.0,17000),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8],[1,-1]) ],
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pwhite(0.01,2),
			\fmr, Pwhite(2,1/8),
			\lpfr,Pwhite(0.2,2),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.5) ],
			],inf).stutter(2),
			\legato, Pseq([
				1.1,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, Pwhite(0.1,2),
			\dur, Prand([1/4,1/8,1/2]*4,inf),
			\dur,4,
			\panwidth, Pwhite(0.01,1),
			//\lag, Pwhite(0,0.2),
			\out, BusDef(\sendbus1, \audio),
			\gain, 2 * Pseq([
				~pmodenv.(Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1.04,0.04,
					1,0.04, 1,0.04,
					1,1,0.04,0.04,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).stutter(4), 1/8),
			],inf),
			\amp,0.18,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				[0,1,6,7],
				[0,1,6,7]+3,
				[0,1,6,7]+2,
			],inf),
			\octave, Ptuple(Prand([5,6,6,6,7],inf)!3),
			\hpf, 30,
			\env1, Prand([
				[ Env([1,0.1,4],[0.1,4.8]) ],
			],inf),
			\diff, 0.03,
			\fmr, 1/2,
			\lpfr,1,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.01,0.8,0.05) ],
			],inf).stutter(2),
			\legato, Pseq([
				0.9,0,0,0,
			],inf)/1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, PdurStutter(Pseq([1,4,1,2],inf), 4),
			\panwidth, 0.1,
			//\lag, Pwhite(0,0.2),
			\gain, 2,
			\amp,0.18,
		),
		Pbind(
			\instrument, \iron,
			\dur, 1/8,
			\freq, Pswitch1(
				[
					Pseg(Pseq([100,7100],inf),8),
					Pseg(Pseq([7000,100],inf),8),
				],
				Pseq([0,1],inf)
			),
			\env1, Prand([
				[ Env([0.1,1,4],[0.1,4.8]) ],
			],inf),
			\diff, Pseq([0.01,1],inf).stutter(Pseq([15,25],inf)),
			\fmr, Pseq([1.8,1],inf).stutter(Pseq([15,25],inf)),
			\hpf, 160,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1,1,0,0,1,0,
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\sustain, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,1,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,1,
					0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,1, 0,1,1,0, 0,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.052,
				\dur, 1/16,
			)),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.00001001231 * Pseq([
				Prand([1,2,3,4,5,1000,2000,1/100])
			],inf).stutter(2),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	].flat)
)).play;
)

//////////// canon freestyle

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		3.collect { arg x;
			
			Pbind(
				\instrument, [\default,\iron].wrapAt(x),
				\degree, Pseq([
					Pwalk((0..11), Pseq([
						Pseq([
							1,2,1,-3,2,
							1,-1,1,-3,2,
						],4),
						3,
						Pseq([
							2,-1,-2,1,-1,
						],2),
					],inf)),
				],inf),
				\isRest, Pseq([
					Pwalk([1,0,1], Pseq([
						Pwalk([
							0,1,1,0,-1,0,0,
						],Pseq([0,1,1,0,-1,0,0],inf)),
					],inf)),
				],inf).coin.not,
				\legato, Pwalk((1..10)/5, Pseq([
					Pwalk([
						1,4,-5,1,
					],Pseq([1,4,-5,1],inf)),
				],inf)),
				\octave, 4+(x*1),
				\scale, Scale.minor,
				\dur, 1/8,
				\lag, x*1/~t,
				\amp, 0.1,
			);
		}
		
	].flat)
)).play;
)


Pdef(\part).clear
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		4.collect { arg x;
			
			[
				Pbind(
					\instrument, \iron,
					\diff, 0.01,
					\rq, 1,
					\adsr, Pseq([
						[ Env.adsr(0.051,0.01,0.8,0.2) ],
					],inf).stutter(2),
					\fmr, 1/4,
					\amp, 0.05,
				),
				Pbind(
					\instrument, \iron,
					\diff, 0.01,
					//\octave, Pkey(\octave)+1,
					\fmr, 1/4,
					\lpfr, 1/2,
					\hpf, 30,
					\env1, Pseq([
						[ Env([1,0.1,4],[0.1,0.8]) ]
					],inf),
					\diff, 0.1 * Pseg(Pseq([0,3],inf),8),
					\rq, 1,
					\fmr, 1/2,
					\lpfr,1,
					\adsr, Pseq([
						[ Env.adsr(0.051,0.01,0.8,0.2) ],
						[ Env.adsr(0.051,0.01,0.8,0.1) ],
					],inf).stutter(2),
				),
				Pbind(
					\instrument, \iron,
					\diff, 0.01,
					\hpf, 400,
					\fmr, 1/4,
					\lpfr, 1/2,
				),
				Pbind(
					\instrument, \iron,
					\diff, 0.01,
					//\octave, Pkey(\octave)+1,
					\fmr, 1/4,
					\lpfr, 1/2,
					\hpf, 30,
					\env1, Pseq([
						[ Env([1,0.1,4],[0.1,0.8]) ]
					],inf),
					\diff, 0.01,
					\rq, 1,
					\fmr, 1/2,
					\lpfr,1,
					\legato, 1,
					\sustain, Pkey(\legato)/~t,
					\adsr, Pseq([
						[ Env.adsr(0.051,0.01,0.8,0.2) ],
						[ Env.adsr(0.051,0.01,0.8,0.1) ],
					],inf).stutter(2),
					\dur, 1/2,
					\amp, 0.03,
				),
			//].wrapAt(x) <>
			].wrapAt(x) <>
			Pbind(
				\degree, Pseq([
					Pwalk((0..11), Pseq([
						Pseq([
							1,2,1,-3,2,
							1,-1,1,-3,2,
						],4),
						3,
						Pseq([
							2,-1,-2,1,-1,
						],2),
					],inf)),
				],inf),
				\isRest, Pseq([
					Pwalk([1,0,1], Pseq([
						Pwalk([
							0,1,1,0,-1,0,0,
						],Pseq([0,1,1,0,-1,0,0],inf)),
					],inf)),
				],inf).coin.not,
				\legato, Pwalk((1..10)/5, Pseq([
					Pwalk([
						1,4,-5,1,
					],Pseq([1,4,-5,1],inf)),
				],inf)),
				\octave, 4+(x*1),
				\scale, Scale.minor,
				\dur, 1/8,
				\lag, x*1/~t,
				\amp, 0.1,
			);
		}
		
	].flat)
)).play;
)




(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			4.collect { arg x;
		
				[
					Pbind(
						\instrument, \iron,
						\diff, 0.01,
						\rq, 1,
						\adsr, Pseq([
							[ Env.adsr(0.051,0.01,0.8,0.2) ],
						],inf).stutter(2),
						\fmr, 1/4,
						\amp, 0.05,
					),
					Pbind(
						\instrument, \iron,
						\diff, 0.01,
						//\octave, Pkey(\octave)+1,
						\fmr, 1/4,
						\lpfr, 1/2,
						\hpf, 30,
						\env1, Pseq([
							[ Env([1,0.1,4],[0.1,0.8]) ]
						],inf),
						\diff, 0.1 * Pseg(Pseq([0,3],inf),8),
						\rq, 1,
						\fmr, 1/2,
						\lpfr,1,
						\adsr, Pseq([
							[ Env.adsr(0.051,0.01,0.8,0.2) ],
							[ Env.adsr(0.051,0.01,0.8,0.1) ],
						],inf).stutter(2),
					),
					Pbind(
						\instrument, \iron,
						\diff, 0.01,
						\hpf, 400,
						\fmr, 1/4,
						\lpfr, 1/2,
					),
					Pbind(
						\instrument, \iron,
						\diff, 0.01,
						//\octave, Pkey(\octave)+1,
						\fmr, 1/4,
						\lpfr, 1/2,
						\hpf, 30,
						\env1, Pseq([
							[ Env([1,0.1,4],[0.1,0.8]) ]
						],inf),
						\diff, 0.01,
						\rq, 1,
						\fmr, 1/2,
						\lpfr,1,
						\legato, 1,
						\sustain, Pkey(\legato)/~t,
						\adsr, Pseq([
							[ Env.adsr(0.051,0.01,0.8,0.2) ],
							[ Env.adsr(0.051,0.01,0.8,0.1) ],
						],inf).stutter(2),
						\dur, 1/2,
						\amp, 0.03,
					),
				//].wrapAt(x) <>
				].wrapAt(x) <>
				Pbind(
					\degree, Pseq([
						Pwalk((0..11), Pseq([
							Pseq([
								5,-4,
							],4),
							3,
							Pseq([
								(1..8)
							].flat,2),
						],inf)),
					],inf),
					\isRest, Pseq([
						Pwalk([1,0,1], Pseq([
							Pwalk([
								0,1,1,0,-1,0,0,
							],Pseq([0,1,1,0,-1,0,0],inf)),
						],inf)),
					],inf).coin.not,
					\legato, Pwalk((1..10)/5, Pseq([
						Pwalk([
							1,4,-5,1,
						],Pseq([1,4,-5,1],inf)),
					],inf)),
					\octave, 4+(x*1),
					\scale, Scale.minor,
					\dur, 1/8,
					\lag, x*1/~t,
					\amp, 0.1,
				);
			}
		
		].flat),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				'wet10', 1.0,
				'mix', 0.35714285714286,
				'gain', 1.0344889782792,
				'fb', 0.00101099467303085,
				'delay', 0.30600001231 * Pseq([
					1,1/10000,1,2,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'shift', 0.0,
				'shift2', 0.0,
				'distamp', 35.361836201538 * Pseq([1,1/40],inf).stutter(2),
				'pitchlag', 1.0,
				'pitchmix', 0.50924369747899,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1/8,
			)
	]),
)).play;
)
