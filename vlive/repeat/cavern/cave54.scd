{var a=LFNoise0,b=SinOscFB,c=Pulse;b.ar(a.ar([2,3])*(c.ar([5,7],b.kr([7,5]))*(a.ar([3,2]))*[800,1200]),(c.kr([100,80])*[2,3])) * 0.1}.play

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	50.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(1)*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	1.do {
		sig = CombL.ar(sig, 0.8, sig.wrap(0.01,0.8).lag(\comblag.kr(1)),\decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\zed).edit

(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	50.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(1)*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	1.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), sig.wrap(\comblo.kr(0.01),\combhi.kr(0.8)).lag(\comblag.kr(1)),\decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pmono(
		 \hurle,
		//\degree, Pseq([0,3],inf),
		\degree, [0,4,8],
		\lpfr, 4,
		\hpfr, 1,
		\octave, 4,
		\dur, 1,
		\comblag, 1,
		\combtrig, 0.1,
		\decay, 1.01,
		\amp, 1.8,
	)
).play;
);

(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// simple delay comb
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	50.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(1)*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	1.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), \combdelay.kr(0.8),\decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);

(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// sample and hold
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	50.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(1)*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	4.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), Gate.ar(sig, Impulse.kr(\combtrig.kr(1))).lag(\comblag.kr(0.01)).wrap(\comblo.kr(0.01),\combhi.kr(0.8)), \decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\zed).reset;
);
Pdef(\zed).play;


(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// sample and hold, dust trig
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	50.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(\selectfreq.kr(1))*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	4.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), Gate.ar(sig, Dust.kr(\combtrig.kr(1))).lag(\comblag.kr(0.01)).wrap(\comblo.kr(0.01),\combhi.kr(0.8)), \decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
Pdef(\zed).reset;

(
Pdef(\zed, 
	Pmono(
		 \hurle,
		//\degree, Pseq([0,3],inf),
		\degree, [0,4,18,28,48],
		\lpfr, 8,
		\hpfr, 1/3,
		\octave, 3,
		\dur, 1,
		\comblag, 1,
		\combtrig, 1.1,
		\decay, 1.01,
		\amp, 1.8,
	)
).play;
);

(
Pdef(\zed, 
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				//\degree, Pseq([0,3],inf),
				\degree, rrand(0,100),
				\freq, exprand(10,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\octave, 3,
				\dur, 1,
				\ienvfreq, rrand(0.01,5),
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 0.08,
			));
			0.4.wait;
		};
		"done".postln;
	})
).play;
);

(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// pulse
	// sample and hold, dust trig
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	50.do {
		sig = LFPulse.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(\selectfreq.kr(1))*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	4.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), Gate.ar(sig, Dust.kr(\combtrig.kr(1))).lag(\comblag.kr(0.01)).wrap(\comblo.kr(0.01),\combhi.kr(0.8)), \decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// internal env, dust gate
	// sample and hold, dust trig
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	20.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(\selectfreq.kr(1))*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.8]), timeScale:1/ \ienvfreq.kr(0.1), gate:Dust.kr(\ienvfreq.kr));
	4.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), Gate.ar(sig, Dust.kr(\combtrig.kr(1))).lag(\comblag.kr(0.01)).wrap(\comblo.kr(0.01),\combhi.kr(0.8)), \decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
Pdef(\zed).reset;

(
Pdef(\zed, 
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				//\degree, Pseq([0,3],inf),
				\degree, rrand(0,100),
				\freq, exprand(10,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\octave, 3,
				\dur, 1,
				\ienvfreq, exprand(0.1,25),
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
			));
			4.wait;
		};
		"done".postln;
	})
).play;
);


(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// internal env, impulse gate
	// sample and hold, dust trig
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	20.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(\selectfreq.kr(1))*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.8]), timeScale:1/ \ienvfreq.kr(0.1), gate:Impulse.kr(\ienvfreq.kr));
	4.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), Gate.ar(sig, Dust.kr(\combtrig.kr(1))).lag(\comblag.kr(0.01)).wrap(\comblo.kr(0.01),\combhi.kr(0.8)), \decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\hurle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// internal env, impulse gate, max timescale
	// sample and hold, dust trig
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sel;
	sig = freq;
	sig1 = DC.ar(1);
	sel = DC.ar(1);
	20.do {
		sig = SinOsc.ar(freq * ( sig * sel + 1 )) ;
		sig1 = sig;
		sel = SelectX.ar(LFNoise1.kr(\selectfreq.kr(1))*3, [sig1, sig1.abs, sig1.neg, sig1.clip(0,inf)]);
	};
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.1]), timeScale:( 1/ \ienvfreq.kr(0.1) ).min(\maxTimeScale.kr(1)) * \timeScale.kr(1), gate:Impulse.kr(\ienvfreq.kr));
	4.do {
		sig = CombL.ar(sig, \combmax.kr(0.8), Gate.ar(sig, Dust.kr(\combtrig.kr(1))).lag(\comblag.kr(0.01)).wrap(\comblo.kr(0.01),\combhi.kr(0.8)), \decay.kr(1)) + sig / 3;
	};
	sig = LPF.ar(sig, ( freq * \lpfr.kr(8) ).clip(10,19900));
	sig = HPF.ar(sig, ( freq * \hpfr.kr(1/8) ).clip(10,19900));
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				//\degree, Pseq([0,3],inf),
				\degree, rrand(0,100),
				\freq, exprand(10,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\octave, 3,
				\dur, 1,
				\ienvfreq, exprand(0.1,25),
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
			));
			4.wait;
		};
		"done".postln;
	})
		
	])
)).play;
);

///////// snapkick
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			//\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bodyAmpEnv, [ Env.linen(0.005, 0.1, 0.03) ],
			\sustain, 0.01,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				//\degree, Pseq([0,3],inf),
				\degree, rrand(0,100),
				\freq, exprand(10,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\octave, 3,
				\dur, 1,
				\ienvfreq, exprand(0.1,25),
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
			));
			4.wait;
		};
		"done".postln;
	})
		
	])
)).play;
);

(
SynthDef(\snapkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([261, 120, 51], [0.035, 0.08], curve: \exp));
	bodyAmp = EnvGen.ar(\bodyAmpEnv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

//////// kick snare

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				//\degree, Pseq([0,3],inf),
				\degree, rrand(0,100),
				\freq, exprand(10,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\octave, 3,
				\dur, 1,
				\ienvfreq, exprand(0.1,25),
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
			));
			4.wait;
		};
		"done".postln;
	})
		
	])
)).play;
);


/////// kick snare, harm freq env,
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				//\degree, Pseq([0,3],inf),
				\degree, rrand(0,100),
				\freq, exprand(10,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\octave, 3,
				\dur, 1,
				\ienvfreq, (1..32).choose/16,
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
			));
			4.wait;
		};
		"done".postln;
	})
		
	])
)).play;
);

/////// kick snare, harm freq env, rdn
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1107].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2313].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				//\degree, Pseq([0,3],inf),
				\degree, rrand(0,100),
				\freq, exprand(10,2000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\octave, 3,
				\dur, 1,
				\ienvfreq, (1..32).choose/16,
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
				\out, BusDef(\sendbus2, \audio),
			));
			4.wait;
		};
		"done".postln;
	})
		
	])
)).play;
);

/////// kick snare, harm freq env, rdn, complex drums
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1107].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2313].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0.1,
				0.2,
				0.1,
				0.2,
				0.1,
				0.2,
				0.1,
				0.6,
			],inf).stutter(8)*5,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2413].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0.6,
			],inf).stutter(8*4)*5,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\lag, 0.04)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,1,1, 1,0,0,1,
					].scramble,inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/3 * Pseg(Pwhite(0.001,1),Pwhite(0.1,8)),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0,
					Pseq([
						1,0,1,1, 1,0,0,1,
					].scramble,inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/3 * Pseg(Pwhite(0.001,1),Pwhite(0.1,8)),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,
					Pseq([
						1,0,1,1, 1,0,0,1,
					].scramble,inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/3 * Pseg(Pwhite(0.001,1),Pwhite(0.1,8)),
			),
		]),
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				\freq, exprand(1,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\dur, 1,
				\ienvfreq, (1..32).choose/16,
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
				\out, BusDef(\sendbus2, \audio),
			));
			4.wait;
		};
		"done".postln;
	})
		
	])
)).play;
);

/////// kick snare, harm freq env, rdn, complex drums 2
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1107].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2313].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0.1,
				0.2,
				0.6,
				0.1,
			],inf).stutter(8)*5,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2413].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				0.6,
			],inf).stutter(8*4)*5,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\lag, 0.04)<>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,1,1, 1,0,0,1,
					].scramble,inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/3 * Pseg(Pwhite(0.001,1),Pwhite(0.1,8)),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0,
					Pseq([
						1,0,1,1, 1,0,0,1,
					].scramble,inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/3 * Pseg(Pwhite(0.001,1),Pwhite(0.1,8)),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,
					Pseq([
						1,0,1,1, 1,0,0,1,
					].scramble,inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1/3 * Pseg(Pwhite(0.001,1),Pwhite(0.1,8)),
			),
		]),
	Pspawner({ arg sp;
		20.do {
			sp.par(Pmono(
				\hurle,
				\freq, exprand(1,8000.0),
				\lpfr, rrand(1,8.0),
				\hpfr, rrand(1/19,1),
				\dur, 1,
				\ienvfreq, (1..32).choose/16,
				\comblag, rrand(0.01,1),
				\selectfreq, rrand(0.01,1),
				\combtrig, rrand(0.01,1.1),
				\decay, rrand(0.01,1.01),
				\amp, 1.8,
				\out, BusDef(\sendbus2, \audio),
			));
			4.wait;
		};
		"done".postln;
	})
		
	])
)).play;
);
