
(
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = SinOscFB.ar(freq, \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sinfb,
			\note, Pseq([
				0,4,5,3,2,1,0,-1,
			],inf),
			\fb, Pseg(Pseq([1.5,0.6],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = SinOscFB.ar(freq * [1,1.001], \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = SinOscFB.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1), \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	sig = SinOscFB.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.004) + 1), \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// mod1 on fb
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.002) + 1)) * 8;
	sig = SinOscFB.ar(freq, \fb.kr(1.4) + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// mod1 on fb
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0002) + 1)) * 38;
	sig = SinOscFB.ar(freq, \fb.kr(1.4) + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// mod1 on fb
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0002) + 1)) * 338;
	sig = SinOscFB.ar(freq, \fb.kr(1.4) + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// fm spread
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)) * 44;
	sig = SinOscFB.ar(freq + mod1, \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// fm spread
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0002) + 1)) * 1443;
	sig = SinOscFB.ar(freq + mod1, \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// fm spread
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq/2 ) * 8;
	sig = SinOscFB.ar(freq* ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1) + mod1, \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// fm spread
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq/2 ) * freq;
	sig = SinOscFB.ar(freq* ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1) + mod1, \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// tremble
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -2), 1);
	mod3 = SinOsc.ar(freq) * 1000 * env1;
	mod2 = SinOsc.ar(freq + mod3 ) * 40;
	mod1 = SinOsc.ar(freq + mod2 )  * 45;
	sig = SinOscFB.ar(freq* ((0..7)/7 - 0.5 * \fspread.kr(0.02)* env1 + 1) + mod1, \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// tremble
SynthDef(\sinfb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -2), 1);
	mod3 = SinOsc.ar(freq) * 1000 * env1;
	mod2 = SinOsc.ar(freq*2 + mod3 ) * 140;
	mod1 = SinOsc.ar(freq + mod2 )  * 145;
	sig = SinOscFB.ar(freq* ((0..7)/7 - 0.5 * \fspread.kr(0.002)* env1 + 1) + mod1, \fb.kr(1.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// tremble
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sinfb,
			\note, Pseq([
				0,4,5,3,2,1,0,-1,
			],inf),
			\fb, Pseg(Pseq([1.0,0.6],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1,
		),
	])
)).play;
);

(
// tremble
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \sinfb,
			\note, Pseq([
				0,4,5,3,2,1,0,-1,
			],inf),
			\fb, Pseg(Pseq([1.0,0.6],1), 8).loop,
			\fb, 0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1,
		),
	])
)).play;
);
