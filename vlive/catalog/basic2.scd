
~t = 185/4/60; TempoClock.default.tempo = ~t;

// try to make some basic synth
// - oscmix (saw, sin, pulse)
// - fm
// - spread
// - env: lpenv, oscmixenv, fmaenv, fspreadenv

// glossary:
// lpadsr = RLPF + adsr in cutoff
// sawm = saw + spread
// sinfm = fm with SinOsc
// sinfmenv = fm with SinOsc and env in fmamp

(
// sawm lpadsr
SynthDef(\sawm_lpadsr, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate) * \lpadsramt.kr(1) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * env1 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
// saw spread lpadsr sinfmenv
SynthDef(\sawm_lpadsr_sinfmadsr, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fm, fmenv;
	fmenv = EnvGen.kr(\fmadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate) * \fma.kr(1) + 1;
	fm = SinOsc.ar(freq * \fmf.kr(1/2)) * fmenv; 
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1) * fm);
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate) * \lpadsramt.kr(1) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * env1 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sawm_lpadsr_sinfmadsr,
			\note, Pseq([
				[0,4,7,4+12],
				[-1,4,7,4+12],
			],inf),
			\octave, 5,
			\fma, 1,
			\fmadsr, Pseq([
				[ Env.adsr(1.41,0.1,0.8,0.4) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(2.41,0.1,0.8,2.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
// saw spread lpadsr sinfmenv
SynthDef(\oscm_lpadsr_oscfmadsr, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fm, fmenv;
	var fspread = ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1);
	var xfreq, fmfreq;

	fmenv = EnvGen.kr(\fmadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate) * \fmadsramt.kr(1) + 1;
	fmfreq = freq * \fmf.kr(1/2);
	sig1 = LFSaw.ar(fmfreq);
	sig2 = Pulse.ar(fmfreq);
	sig3 = SinOsc.ar(fmfreq);
	fm = SelectX.ar(\fmoscmix.kr(0.5)*2, [sig1, sig2, sig3]) * fmenv * \fma.kr(1) + 1;

	xfreq = freq * fspread * fm;
	sig1 = LFSaw.ar(xfreq);
	sig2 = LFPulse.ar(xfreq);
	sig3 = SinOsc.ar(xfreq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig.debug("sig");

	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate) * \lpadsramt.kr(1) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * env1 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscm_lpadsr_oscfmadsr,
			\note, Pseq([
				[0,4,7,4+12],
				[-1,4,7,4+12],
			],inf),
			\octave, 5,
			\oscmix, 0,
			\fmoscmix, 0,
			\lpadsramt, 1,
			\fspread, 0.001,
			\fma, 1,
			\fmadsr, Pseq([
				[ Env.adsr(0.41,2.1,0.1,1.4) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(2.41,0.1,0.8,2.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscm_lpadsr_oscfmadsr,
			\note, Pseq([
				[0,4,7,4+12],
				[-1,4,7,4+12],
				[0,3,7,3+12],
				[-1,2,7,2+12],
			],inf),
			\octave, 5,
			\oscmix, PmodEnv(Pseq([0,1,0.4],1), 9).loop,
			\fmoscmix, PmodEnv(Pseq([0,1,0.4],1), 7).loop,
			\lpadsramt, PmodEnv(Pseq([8,0,1,0.4],1), 11).loop,
			\fmadsramt, PmodEnv(Pseq([0,1,0.4],1), 12).loop,
			\fspread, PmodEnv(Pseq([0.001,0.0002,0.01],1), 15).loop,
			\lpf, PmodEnv(Pseq([2000,101,14000],1), 16).loop,
			\spread, PmodEnv(Pseq([0,0.2,1],1), 8).loop,
			\pan, PmodEnv(Pseq([-0.1,0.2,0.8,0,-0.8,1,-1],1), 4).loop,
			\rq, PmodEnv(Pseq([0.1,1,0.4],1), 8.3).loop,
			\fma, 1,
			\fma, PmodEnv(Pseq([0,2,1,4],1), 8).loop,
			\fmadsr, Pseq([
				[ Env.adsr(0.41,0.1,1.1,1.4) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.41,4.1,2.8,2.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1/4,
		),
	])
)).play;
);


(
SynthDef(\simplefm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( LFPulse.ar(freq/2) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

{ SinOsc.ar(200 * ( LFPulse.ar(100) * Line.kr(0,4,4) + 1 )) ! 2 * 0.1}.play;
{ SinOsc.ar(200 * ( LFPulse.ar(100).bipolar * Line.kr(0,4,4) + 1 )) ! 2 * 0.1}.play;
{ SinOsc.ar(200 * ( Pulse.ar(100) * Line.kr(0,4,4) + 1 )) ! 2 * 0.1}.play;
{ SinOsc.ar(200 * ( LFSaw.ar(100).unipolar * Line.kr(0,4,4) + 1 )) ! 2 * 0.1}.play;
{ LFSaw.ar(200 * ( LFPulse.ar(100) * Line.kr(0,4,4) + 1 )) ! 2 * 0.1}.play;
{ LFSaw.ar(200 * ( LFSaw.ar(100) * Line.kr(0,4,4) + 1 )) ! 2 * 0.1}.play;
{ LFPulse.ar(500).bipolar ! 2 * 0.1}.plot(0.1);
(
Pdef(\zed, 
	Pbind(
		\instrument, \simplefm,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				[0,4,7,4+12],
				[-1,4,7,4+12],
			],inf),
			\octave, 5,
			\oscmix, PmodEnv(Pseq([0,1,0.4],1), 9).loop,
			//\fmoscmix, PmodEnv(Pseq([0,1,0.4],1), 10).loop,
			//\lpadsramt, PmodEnv(Pseq([0,1,0.4],1), 10).loop,
			//\fspread, PmodEnv(Pseq([0.001,0.0002,0.01],1), 15).loop,
			\lpadsramt, 0,
			\fmadsramt, 0,
			\fma, 1,
			\fma, PmodEnv(Pseq([0,2,1,4],1), 8).loop,
			\fspread, 0.0001,
			\fmadsr, Pseq([
				[ Env.adsr(0.41,2.1,0.1,1.4) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(2.41,0.1,0.8,2.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1/4,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscm_lpadsr_oscfmadsr,
			\note, Pseq([
				[0,4,7,4+12],
				[-1,4,7,4+12],
				[0,3,7,3+12],
				[-1,2,7,2+12],
			],inf),
			\octave, 5,
			\oscmix, PmodEnv(Pseq([0,1,0.4],1), 9).loop,
			\fmoscmix, PmodEnv(Pseq([0,1,0.4],1), 7).loop,
			\lpadsramt, PmodEnv(Pseq([8,0,1,0.4],1), 11).loop,
			\fmadsramt, PmodEnv(Pseq([0,1,0.4],1), 12).loop,
			\fspread, PmodEnv(Pseq([0.001,0.0002,0.01],1), 15).loop,
			\lpf, PmodEnv(Pseq([2000,101,14000],1), 16).loop,
			\spread, PmodEnv(Pseq([0,0.2,1],1), 8).loop,
			\pan, PmodEnv(Pseq([-0.1,0.2,0.8,0,-0.8,1,-1],1), 4).loop,
			\rq, PmodEnv(Pseq([0.1,1,0.4],1), 8.3).loop,
			\fma, 1,
			\fma, PmodEnv(Pseq([0,2,1,4],1), 8).loop,
			\fmadsr, Pseq([
				[ Env.adsr(0.41,0.1,1.1,1.4) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.41,4.1,2.8,2.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 2,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);
