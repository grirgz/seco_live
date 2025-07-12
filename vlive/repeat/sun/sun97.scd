
// mindustry
(
~t = 130/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1080].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[701].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,1, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,1,0,1,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2126].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.5,0.6,0.5,
			],inf),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\lpf, PmodEnv(Pseq([100,400],1), 8).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ \r,0,3,7, ],16),
				Pser([ \r,0,3,8, ],16),
				Pser([ \r,0,3,0, ],16),
				Pser([ \r,0,3,0, ],16),
			],inf),
			\envamt, PmodEnv(Pseq([1,2,1,4],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 0.71 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/FBI - FBI.wav'),
			\legato, 1,
			\st, 104/1/60,
			\speed, 2.52 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				(0..7),
				(0..3),
				(0..7)+8,
				(0..3)+4,
				(0..31),
			].flat,inf).loop / 4 / Pkey(\st),
			\dur, 1/16,
			\gain, 1/4,
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
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ -4,0,3,\r, ],8),
				Pseq([ -3,0,3,\r ],8),
			],inf),
			\octave, 5,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1080].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[701].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,1, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.02,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1004].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 1,1,0,1,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2126].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.5,0.6,0.5,
			],inf),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\lpf, PmodEnv(Pseq([100,400],1), 8).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ \r,0,3,7, ],16),
				Pser([ \r,0,3,8, ],16),
				Pser([ \r,0,3,0, ],16),
				Pser([ \r,0,3,0, ],16),
			],inf),
			\envamt, PmodEnv(Pseq([1,2,1,4],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 0.71 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\choipad1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\choipad2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,6,0],[0.4,1.8]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\choipad3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.2,0.1,0.8,3.1)), gate);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\choipad4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 10;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.2,0.1,0.8,3.1)), gate);
	sig = LFPulse.ar(freq * LFNoise1.kr(0.1!num, mul:0.01,add:1) * ( SinOsc.ar(freq/2) * 4 + 1 )).mean;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\choipad5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 10;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.2,0.1,0.8,3.1)), gate);
	sig = SinOsc.ar(freq  * ( LFSaw.ar(freq/2* LFNoise1.kr(0.1!num, mul:0.05 * XLine.kr(0.04,1,4),add:1)) * 4 + 1 )).mean;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\choipad6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 20;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.2,0.1,0.8,3.1)), gate);
	env2 = EnvGen.kr(\fmnoiseadsr.kr(Env.adsr(0.1,0.7,0.2,1.1)), gate) * \fmnoiseadsramt.kr(0.03) + 0.01;
	env3 = EnvGen.kr(\fmampadsr.kr(Env.adsr(2.4,0.1,0.8,4.1)), gate) * \fmampadsramt.kr(3);
	sig = SinOsc.ar(freq  * ( LFSaw.ar(freq/2* LFNoise1.kr(\fmnfreq.kr(0.1)!num, mul:env2,add:1)) * env3 + 1 )).mean;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\choipad7, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 20;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.2,0.1,0.8,3.1)), gate);
	env2 = EnvGen.kr(\fmnoiseadsr.kr(Env.adsr(0.1,0.7,0.2,1.1)), gate) * \fmnoiseadsramt.kr(0.03) + 0.01;
	env3 = EnvGen.kr(\fmampadsr.kr(Env.adsr(2.4,0.1,0.8,4.1)), gate) * \fmampadsramt.kr(3);
	sig1 = SinOsc.ar(freq  * ( LFSaw.ar(freq/2* LFNoise1.kr(\fmnfreq.kr(0.1)!num, mul:env2,add:1)) * env3 + 1 )).mean;
	sig2 = LFSaw.ar(freq  * ( SinOsc.ar(freq/2* LFNoise1.kr(\fmnfreq.kr(0.1)!num, mul:env2,add:1)) * env3 + 1 )).mean;
	sig = SelectX.ar(\oscmix.kr(0.5), [sig1, sig2]);
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\choipad8, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 5;
	env1 = EnvGen.kr(\lpspreadadsr.kr(Env.adsr(1.2,0.1,0.8,3.1)), gate);
	env4 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.2,0.1,0.8,3.1)), gate) * \lpadsramt.kr(2) + 1;
	env2 = EnvGen.kr(\fmnoiseadsr.kr(Env.adsr(0.1,0.7,0.2,1.1)), gate) * \fmnoiseadsramt.kr(0.13) + 0.01;
	env3 = EnvGen.kr(\fmampadsr.kr(Env.adsr(2.4,0.1,0.8,4.1)), gate) * \fmampadsramt.kr(3);
	sig1 = SinOsc.ar(freq  * ( LFSaw.ar(freq/2* LFNoise1.kr(\fmnfreq.kr(0.1)!num, mul:env2,add:1)) * env3 + 1 )).mean;
	sig2 = LFSaw.ar(freq/2  * ( SinOsc.ar(freq*2* LFNoise1.kr(\fmnfreq.kr(0.1)!num, mul:env2,add:1)) * env3 + 1 )).mean;
	sig = SelectX.ar(\oscmix.kr(0.2), [sig1, sig2]);
	sig = RLPF.ar(sig, ( \lpf.kr(700) * env4 * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \choipad8,
			\note, Pseq([
				0,5,10,
			],inf),
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
			\instrument, \choipad8,
			\note, Pseq([
				[0,4,7,12],
				[-1,4,7,11],
			],inf),
			\dur, 4,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*3).loop,
			//\lpf, 400,
			\lpspread, PmodEnv(Pseq([3,0.8],1), 8*2).loop,
			\lpadsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,1.1,1,2) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/3,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \choipad8,
			\note, Pseq([
				[0,4,7,12],
				[-1,4,7,11],
			],inf),
			\dur, 4,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*3).loop,
			//\lpf, 400,
			\lpspread, PmodEnv(Pseq([0.03,0.08],1), 8*2).loop,
			\oscmix, PmodEnv(Pseq([0,1],10), 7).loop,
			\lpadsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,1.1,1,2) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/3,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq([
				[0,4,7,4+12],
				[0,5,9,9+12],
			],inf),
			\oscmix, PmodEnv(Pseq([0,1],10), 16).loop,
			\fmoscmix, PmodEnv(Pseq([1,0,1],1), 16).loop,
			\lpadsramt, 6,
			\fspread, Pseg(Pseq([0.07,0.001,0.0001],inf),16),
			\lpf, 270,
			\rq, 0.3,
			\octave, 6,
			\dur, 2,
			\amp, 0.1/3,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, Pfunc({ \choipad+++rrand(1,8) }),
			\note, Pseq([
				0,5,10,
			],inf),
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
			\instrument, Pfunc({ \choipad+++rrand(1,8) }),
			\note, Pseq([
				[0,4,7,12],
				[-1,4,7,11],
			],inf),
			\dur, 4,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*3).loop,
			//\lpf, 400,
			\lpspread, PmodEnv(Pseq([3,0.8],1), 8*2).loop,
			\lpadsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,1.1,1,2) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/3,
		),
	])
)).play;
);


(
SynthDef(\formantbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,4.8]), 1);
	env2 = EnvGen.kr(Env([1,3,1],[0.4,4.8]), 1);
	env3 = EnvGen.kr(Env([0,1.0,0],[0.4,1.8]), 1);
	//sig = LFSaw.ar(freq);
	//sig = Formant.ar(freq, freq/4*env1, freq * ( SinOsc.ar(freq/2) * env3 + 1 ) );
	sig = Formant.ar(freq , \formfreq.kr(10) * env2* ((0..7)/7 - 0.5 * \fspread.kr(1.1102) + 1), \bwfreq.kr(100) * env1 );
	//sig = sig * ( Pulse.ar(freq/4) * 0.5 + 1 );
	//sig = RLPF.ar(sig, [ \lpf.kr(800), \lpf2.kr(1400) ], \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, 
	Pbind(
		\instrument, \formantbass,
		\degree, Pseq([0],inf),
		\note, Pseq([
			0,5,5,5, 4,3,1,0
		],inf),
		\bwfreq, PmodEnv(Pseq([10,100,800,5000],1), 8).loop,
		\formfreq, PmodEnv(Pseq([10,100,800],1), 8).loop,
		\octave, 3,
		\dur, 1/2,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
	Pbind(
		\instrument, \formantbass,
		\degree, Pseq([0],inf),
		\note, Pseq([
			0,5,5,5, 4,3,1,0
		],inf),
		\bwfreq, PmodEnv(Pseq([10,100,800,5000],1), 8).loop,
		\formfreq, PmodEnv(Pseq([10,100,800],1), 8).loop,
		\octave, 3,
		\lag, ( 1/4 ) * ( 3/4 )/~t,
		\dur, 1/2,
		\amp, 0.1,
	)
		
	])
)).play;
);

(
SynthDef(\choir, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,4.8]), 1);
	env2 = EnvGen.kr(Env([1,3,0],[0.01,4.8]), 1);
	env3 = EnvGen.kr(Env([0,1.0,0],[0.4,1.8]), 1);
	//sig = LFSaw.ar(freq);
	sig = Formant.ar(freq, freq/4*env1, freq * ( SinOsc.ar(freq/2) * env3 + 1 ) );
	sig = Formant.ar(freq, 180 * env2, 420 * env1 ) + sig;
	//sig = sig * ( Pulse.ar(freq/4) * 0.5 + 1 );
	//sig = RLPF.ar(sig, [ \lpf.kr(800), \lpf2.kr(1400) ], \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \choir,
			\note, Pseq([
				[0,4,7,12],
				[-1,4,7,11],
			],inf),
			\dur, 4,
			//\lpf, PmodEnv(Pseq([100,4000],1), 8*3).loop,
			//\lpf, 400,
			\lpspread, PmodEnv(Pseq([3,0.8],1), 8*2).loop,
			\lpadsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,1.1,1,2) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/3,
		),
	])
)).play;
);
