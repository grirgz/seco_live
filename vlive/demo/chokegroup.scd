
	snd = snd * ( 1-EnvGen.ar( Env([0,1], [0.1]),In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Duty.kr(0.01, 0, Dseq([ 0,Dseq([1],inf), ],inf)), doneAction:2) ); 
	Out.kr(\chokebus.kr, Impulse.kr(0));


(
SynthDef(\bigkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(\popfstart.kr(750), \popfend.kr(261), \popfdur.kr(0.02));
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * \popamp.kr(0.15);
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * \clickamp.kr(0.15);
	click = LPF.ar(Formant.ar(\formfund.kr(910), \formfreq.kr(4760), \formbw.kr(2110)), \lpf.kr(3140)) * clickAmp;

	snd = body + pop + click;
	snd = snd * \distpreamp.kr(1) * EnvGen.ar( \distenv.kr(Env([1,2,1],[0.1,0.8])));
	snd = snd.tanh;
	snd = snd * \distpostamp.kr(1);

	snd = snd * ( 1-EnvGen.ar( Env([0,1], [0.1]),In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Duty.kr(0.01, 0, Dseq([ 0,Dseq([1],inf), ],inf)), doneAction:2) ); 
	Out.kr(\chokebus.kr, Impulse.kr(0));

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)


(
SynthDef(\bigkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(\popfstart.kr(750), \popfend.kr(261), \popfdur.kr(0.02));
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * \popamp.kr(0.15);
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * \clickamp.kr(0.15);
	click = LPF.ar(Formant.ar(\formfund.kr(910), \formfreq.kr(4760), \formbw.kr(2110)), \lpf.kr(3140)) * clickAmp;

	snd = body + pop + click;
	snd = snd * \distpreamp.kr(1) * EnvGen.ar( \distenv.kr(Env([1,2,1],[0.1,0.8])));
	snd = snd.tanh;
	snd = snd * \distpostamp.kr(1);

	snd = snd * ( EnvGen.kr( Env([1,0], [0.1]), In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Env.step([0,1],[0.01,1]).kr.poll, doneAction:2) ); 
	Out.kr(\chokebus.kr, Impulse.kr(0));

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

(
	SynthDef(\chokecymbal, { | out = 0, pan = 0.0, amp=0.1 |
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 2, curve: -4), doneAction: 2);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(1000, 20000)}.dup(100)).mean, 4000);
		sig = sig * amp;

		sig = sig * ( EnvGen.kr( Env([1,0], [0.1]), In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Env.step([0,1],[0.01,1]).kr.poll, doneAction:2) ); 
		Out.kr(\chokebus.kr, Impulse.kr(0));

		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;

	SynthDef(\chokehat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var env1, env2, env3, env4, env5, env6, env7, env8;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		sig = SinOsc.ar(freq);
		sig = WhiteNoise.ar;
		env1 = EnvGen.kr(Env([8210,1100,2051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
		env2 = EnvGen.kr(Env([18210,200,7451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
		sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
		sig = HPF.ar(sig, 20000-env2);
		sig1 = sig;
		//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
		sig = WhiteNoise.ar;
		env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
		sig = sig + Ringz.ar(sig, [9400,17030,1410,8000.14,5000] * env3, 0.001).mean/10;
		env1 = EnvGen.kr(Env([8821,7810,251],[0.01,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
		env2 = EnvGen.kr(Env([13820,15800,151],[0.01,0.8*\fac1.kr(1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
		sig = HPF.ar(sig, env1);
		sig = LPF.ar(sig, env2);
		sig2 = sig*1.3;

		sig = sig1+sig2;

		sig = sig * ( EnvGen.kr( Env([1,0], [0.1]), In.kr(\chokebus.kr(BusDef(\zero, \control)), 1) * Env.step([0,1],[0.01,1]).kr.poll, doneAction:2) ); 
		Out.kr(\chokebus.kr, Impulse.kr(0));

		sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.4,1,-4) ),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp).sum;
		Out.ar(out, sig);
	}).add;
)

(
Pdef(\choke, 
	Pbind(
		\instrument, \bigkick,
		\degree, Pseq([0],inf),
		\chokebus, BusDef(\chokebus, \control),
		\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),
		\amp, 0.1,
	),
).play;
);

(
Pdef(\choke, 
	Ppar([
		Pbind(
			\instrument, \bigkick,
			\degree, Pseq([0],inf),
			\chokebus, BusDef(\chokebus, \control),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \cymbalsimple,
			\chokebus, BusDef(\chokebus, \control),
			\freq, 200,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	]),
).play;
);

(
Pdef(\choke, 
	Ppar([
		Pbind(
			\instrument, \chokehat,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\chokebus, BusDef(\chokebus, \control),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \chokecymbal,
			\chokebus, BusDef(\chokebus, \control),
			\freq, 200,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	]),
).play;
);

(
Pdef(\choke, 
	Ppar([
		Pbind(
			\instrument, \chokehat,
			\isRest, Pseq([
				1,0, 0,0,
			   	1,1, 1,1,
				1,0, 0,0,
			   	1,1, 0,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1 * Pseq([
				95,1,1,1,
			],inf),
			\legato, 2,
			\dur, 1/8,
			\chokebus, BusDef(\chokebus, \control),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		
	]),
).play;
);
