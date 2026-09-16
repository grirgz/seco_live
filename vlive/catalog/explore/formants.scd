
(
SynthDef(\form1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0), bwfreq: \bwfreq.kr(880.0));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form1,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\formfreq, Pseg(Pseq([100,13000],1),16,\exp).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\form2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0), bwfreq: \bwfreq.kr(880.0));
	sig = sig - Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form2,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\formfreq, Pseg(Pseq([100,13000],1),16,\exp).loop,
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
			\instrument, \form2,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\formdiff, Pseg(Pseq([800,1300],1),16,\exp).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\form2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0), bwfreq: \bwfreq.kr(880.0));
	sig = sig - Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr + \bwdiff.kr(0));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form2,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\bwdiff, Pseg(Pseq([80,4300],1),16,\exp).loop,
			\bwfreq, 10,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\form2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0), bwfreq: \bwfreq.kr(880.0));
	sig = sig * Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr + \bwdiff.kr(0));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

////////
(
SynthDef(\form3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.7,0.1]), 1);
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0) * env1, bwfreq: \bwfreq.kr(880.0));
	sig = sig * Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr + \bwdiff.kr(0));
	sig = RLPF.ar(sig, \lpf.kr(1700), \rq.kr(0.3));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form3,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\bwdiff, Pseg(Pseq([80,4300],1),16,\exp).loop,
			\bwfreq, Pseg(Pseq([100,1000],1),28,\exp).loop,
			\formfreq, Pseq([100,4000,200,7055],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\lpf, Pseg(Pseq([1000,7000],1),8,\exp).loop,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

///////
(
SynthDef(\form4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([3,2,1],[1.7,3.1]), 1);
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0) * env1, bwfreq: \bwfreq.kr(880.0));
	sig = sig + Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr + \bwdiff.kr(0));
	sig = RLPF.ar(sig, \lpf.kr(1700), \rq.kr(0.3));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form4,
			\note, Pseq([
				[-12,0,4,7,12],
				[-12,0,4,8,12],
			],inf),
			\bwdiff, PmodEnv(Pseq([80,1300],1),16,\exp).loop,
			\bwfreq, PmodEnv(Pseq([100,1000],1),28,\exp).loop,
			\formfreq, PmodEnv(Pseq([100,4000,200,7055,2230],1),8,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(2.71,0.1,0.8,2.6) ],
			],inf),
			\lpf, 8000,
			\legato, 0.95,
			\rq, 0.6,
			\dur, 4,
			\amp, 0.1/5,
		),
		
	])
)).play;
);

(
SynthDef(\form5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([3,2,1],[1.7,3.1]), 1);
	env2 = EnvGen.kr(Env([1,2,3],[1.7,3.1]), 1);
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0) * env1, bwfreq: \bwfreq.kr(880.0));
	sig = sig + Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr + \bwdiff.kr(0));
	mod1 = SinOsc.ar(freq/2) * 1000 * env2;
	sig = sig * SinOsc.ar(freq + mod1, add: 0.0);
	sig = RLPF.ar(sig, \lpf.kr(1700), \rq.kr(0.3));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form5,
			\note, Pseq([
				[-12,0,4,7,12],
				[-12,0,4,8,12],
			],inf),
			\bwdiff, PmodEnv(Pseq([180,700],1),16,\exp).loop,
			\bwfreq, 800,
			\formfreq, PmodEnv(Pseq([100,4000,200,1055,2230],1),8,\exp).loop,
			\formdiff, PmodEnv(Pseq([100,-4000,200,-2055,2230]/2,1),10,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(2.71,0.1,0.8,2.6) ],
			],inf),
			\lpf, 8000,
			\legato, 0.95,
			\rq, 0.6,
			\dur, 4,
			\amp, 0.1/5,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form5,
			\note, Pseq([
				[-12,0,4,7,12],
				[-12,0,4,8,12],
			],inf),
			\bwdiff, PmodEnv(Pseq([180,700],1),16,\exp).loop,
			\bwfreq, 800,
			//\formfreq, PmodEnv(Pseq([100,4000,200,1055,2230],1),8,\exp).loop,
			\formdiff, PmodEnv(Pseq([100,-400],1),16,\exp).loop,
			\formfreq, 300,
			\adsr, Pseq([
				[ Env.adsr(2.71,0.1,0.8,2.6) ],
			],inf),
			\lpf, 18000,
			\legato, 0.95,
			\rq, 0.6,
			\dur, 4,
			\amp, 0.1/5,
			\out, BusDef(\pass, \audio),
		),
		Pmono(\fx_echopass,
			\inbus, BusDef(\pass, \audio),
			\maxdelay, 1.0,
			\delay, 0.2,
			\decay, 2.0,
			\lpf, 19000.0,
			\hpf, 50.0,
			\pfmix, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\form5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([3,2,1],[1.7,3.1]), 1);
	env2 = EnvGen.kr(Env([0.1,2,13],[1.7,3.1]), 1);
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0) * env1, bwfreq: \bwfreq.kr(880.0));
	sig = sig + Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr + \bwdiff.kr(0));
	mod1 = SinOsc.ar(freq / 2.00051) * 1300 * env2;
	sig = sig * SinOsc.ar(freq + mod1, add: 0.0);
	sig = RLPF.ar(sig, \lpf.kr(1700), \rq.kr(0.3));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\form5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([3,2,1],[1.7,3.1]), 1);
	env2 = EnvGen.kr(Env([0.1,2,13],[3.7,3.1]), 1);
	sig = Formant.ar(fundfreq: freq, formfreq: \formfreq.kr(1760.0) * env1, bwfreq: \bwfreq.kr(880.0));
	sig = sig + Formant.ar(fundfreq: freq, formfreq: \formfreq.kr + \formdiff.kr(100), bwfreq: \bwfreq.kr + \bwdiff.kr(0));
	mod1 = SinOsc.ar(freq * 1.001) * 500 * env2;
	sig = sig * SinOsc.ar(freq + mod1, add: 0.0);
	sig = RLPF.ar(sig, \lpf.kr(1700), \rq.kr(0.3));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form5,
			\note, Pseq([
				[-12,0,4,7,12],
				[-12,0,4,8,12],
			],inf),
			\bwdiff, PmodEnv(Pseq([180,700],1),16,\exp).loop,
			\bwfreq, 800,
			\formfreq, PmodEnv(Pseq([100,400,200,1055,2230],1),8,\exp).loop,
			\formdiff, PmodEnv(Pseq([100,-4000,200,-2055,2230]/2,1),10,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(2.71,0.1,0.8,2.6) ],
			],inf),
			\lpf, 18000,
			\legato, 0.95,
			\rq, 0.6,
			\dur, 4,
			\amp, 0.1/5,
		),
		
	])
)).play;
);


/////////////

(
SynthDef(\form6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = Formant.ar(fundfreq: freq, formfreq: [300,2500,700], bwfreq: [100,10,300]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form6,
			\note, Pseq([
				[-12,0,4,7,12],
				[-12,0,4,8,12],
			],inf),
			\bwdiff, PmodEnv(Pseq([180,700],1),16,\exp).loop,
			\bwfreq, 800,
			\formfreq, PmodEnv(Pseq([100,400,200,1055,2230],1),8,\exp).loop,
			\formdiff, PmodEnv(Pseq([100,-4000,200,-2055,2230]/2,1),10,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(2.71,0.1,0.8,2.6) ],
			],inf),
			\lpf, 18000,
			\legato, 0.95,
			\rq, 0.6,
			\dur, 4,
			\amp, 0.1/5,
		),
		
	])
)).play;
);

(
SynthDef(\form6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,2.8]), 1);
	env2 = EnvGen.kr(Env([1,8,1],[2.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,2,1],[2.1,2.8]), 1);
	//env4 = EnvGen.kr(Env([1,1/2,1],[2.1,2.8]), 1);
	env4 = SinOsc.ar(2*~t) * 0.1 + 1;
	sig = Formant.ar(fundfreq: freq, formfreq: [300*env3,2500*env4,700 * env1], bwfreq: [100,10 * env2,300]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\form6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,2.8]), 1);
	env2 = EnvGen.kr(Env([1,148,1],[2.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,2,1],[2.1,2.8]), 1);
	//env4 = EnvGen.kr(Env([1,1/2,1],[2.1,2.8]), 1);
	env4 = SinOsc.ar(4*~t) * 0.2 + 1;
	sig = Formant.ar(fundfreq: freq, formfreq: [300*env3,2500*env4,\formfreq3.kr(700) * env1], bwfreq: [100,10 * env2,300]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form6,
			\note, Pseq([
				[-12,0,4,7,12],
				[-12,0,4,8,12],
			],inf),
			\bwdiff, PmodEnv(Pseq([180,700],1),16,\exp).loop,
			\bwfreq, 800,
			\formfreq, PmodEnv(Pseq([100,400,200,1055,2230],1),8,\exp).loop,
			\formdiff, PmodEnv(Pseq([100,-4000,200,-2055,2230]/2,1),10,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(2.71,0.1,0.8,2.6) ],
			],inf),
			\lpf, 18000,
			\legato, 0.95,
			\rq, 0.6,
			\dur, 4,
			\amp, 0.1/5,
			\out, BusDef(\pass, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pass, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\form6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,2.8]), 1);
	env2 = EnvGen.kr(Env([1,148,1],[2.1,2.8]), 1);
	env3 = EnvGen.kr(Env([1,2,1],[2.1,2.8]), 1);
	//env4 = EnvGen.kr(Env([1,1/2,1],[2.1,2.8]), 1);
	env4 = SinOsc.ar(4*~t) * 0.2 + 1;
	sig = Formant.ar(fundfreq: freq, formfreq: [300*env3,2500*env4,\formfreq3.kr(700) * env1], bwfreq: [100,10 * env2,300]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \form6,
			\note, Pseq([
				[-12,0,4,7,12],
				[-12,0,4,8,12],
			],inf),
			\bwfreq, 800,
			\formfreq3, PmodEnv(Pseq([700,100],1),16,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(2.71,0.1,0.8,2.6) ],
			],inf),
			\lpf, 18000,
			\legato, 0.95,
			\rq, 0.6,
			\dur, 4,
			\amp, 0.1/5,
			\out, BusDef(\pass, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pass, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
