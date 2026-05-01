// big crash with external verb

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(8000) * 10000; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.008,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bigcrash,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\crashverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\crashverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			\mix, 0.91,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

// big crash with internal verb
(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(8000) * 10000; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// big crash
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bigcrash,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(800) * 10000; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(800) * 100; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(800) * 100; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(700));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([5000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([5000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([15000,1000,1],[0.006,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([5000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([15000,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([1500,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([1500,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(1800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([1500,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(8800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,510,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([15000,470,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(8800, pi/2 * 0.4) * 8811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,510,1],[0.005,0.008]), 1);
	env2 = EnvGen.kr(Env([1500,14470,1],[0.006,0.008]), 1);
	mod1 = LFSaw.ar(8800, pi/2 * 0.4) * 8811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,510,1],[0.005,0.008]), 1);
	env2 = EnvGen.kr(Env([150,14470,1],[0.006,0.008]), 1);
	mod1 = LFSaw.ar(18800, pi/2 * 0.4) * 8811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,8510,1],[0.115,0.018]), 1);
	env2 = EnvGen.kr(Env([150,14470,4001],[0.006,0.008]), 1);
	mod1 = LFSaw.ar(80, pi/2 * 0.4) * 888; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,8510,750],[0.115,0.018]), 1);
	env2 = EnvGen.kr(Env([150,14470,4001],[0.006,0.008]), 1);
	mod1 = LFSaw.ar(350, pi/2 * 0.4) * 13888; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,8510,250],[0.115,0.018]), 1);
	env2 = EnvGen.kr(Env([150,14470,4001],[0.006,0.008]), 1);
	mod1 = SinOsc.ar(70, pi/2 * 0.4) * 188; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,85,50],[0.115,2.018]), 1);
	env2 = EnvGen.kr(Env([15150,870,301],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(70, pi/2 * 0.4) * 388; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
