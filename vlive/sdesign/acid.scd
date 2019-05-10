
(
SynthDef(\based, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\bpfenv.kr(Env([1,1.2,1],[0.1,1.8])), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \lpf.kr(100)* SinOsc.ar(2).range(0.7,1.3), \rq.kr(0.5));
	sig.debug("basicbas");
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \based,
			\note, Pseq([
				0,1,4,0, 7,1,4,8,
			],inf),
			\octave, Pseq([
				Pwrand([4,5,6],[0.1,0.8,0.1])
			],inf),
			\lpf, ~pmodenv.(Pseq([200,2000,150,9001,400],inf), 1.18),
			\rq, ~pmodenv.(Pseq([0.1,0.2,0.5,0.9001,0.4],inf), 1.48),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\attack, Pseq([
				Pseg(Pseq([0.01,1/2],inf),6.18)*
				Pseg(Pseq([0.01,1/2],inf),3.18),
			],inf),
			\bpfenv, Pseq([
				[ Env([1,0.2,1],[0.1,0.8]) ]
			],inf),
			\release, Pseq([
				Pseg(Pseq([0.01,1/2],inf),8),
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(ev[\attack],0.1,0.8,ev[\release]) ]
				}),
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \based,
			\note, Pseq([
				0,1,4,0, 7,1,4,8,
			],inf),
			\octave, Pseq([
				Pwrand([4,5,6],[0.1,0.8,0.1])
			],inf),
			\lpf, ~pmodenv.(Pseq([200,2000,150,9001,400],inf), 1.18),
			\rq, ~pmodenv.(Pseq([0.1,0.2,0.5,0.9001,0.4],inf), 1.48),
			\lpf, Pseq([
				//2000,1100,789,5441, 3211,1200,4200,4000,
				Pswitch1(
					{ Pseg(Pseq([exprand(100.1,12000.0),exprand(100.1,12000.0)],inf),rrand(4,18.5)) }.dup(8),
					Pseq((0..7),inf)
				)
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\attack, Pseq([
				Pseg(Pseq([0.01,1/2],inf),6.18)*
				Pseg(Pseq([0.01,1/2],inf),3.18),
			],inf),
			\bpfenv, Pseq([
				[ Env([1,0.2,1],[0.1,0.8]) ],
				[ Env([1,0.9,0.1],[0.1,0.8]) ],
				[ Env([0.1,1.9,0.1],[0.1,0.8]) ],
			],inf),
			\release, Pseq([
				Pseg(Pseq([0.01,1/2],inf),8),
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(ev[\attack],0.1,0.8,ev[\release]) ]
				}),
			],inf),
			\dur, 1/12,
			\amp, 0.1,
			\amp, 0.1 * Pswitch1(
				8.collect({ arg x; Pseq(Array.series(x*2+15,0,1).normalize.linlin(0,1,0.4,1),inf)}),
				Pseq((0..7),inf)
			),
		),
		
	])
)).play;
)

[0.5,0.6].normalize


//////////////////

(
SynthDef(\tr303, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\bpfenv.kr(Env([1,1.2,1],[0.1,1.8])), 1);
	sig = LFSaw.ar(freq.lag(\freqlag.kr(1/4)) );
	sig = RLPF.ar(sig, \lpf.kr(100) * env1, \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
SynthDef(\tr303_stereo, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\bpfenv.kr(Env([1,1.2,1],[0.1,1.8])), 1);
	sig = LFSaw.ar(freq.lag(\freqlag.kr(1/4)) * [1,1+\det.kr(0.001)] );
	sig = RLPF.ar(sig, \lpf.kr(100) * env1, \rq.kr(0.5));
	sig = sig * amp;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \tr303,
			\octave, 3,
			\lpf, ~pmodenv.(Pseq([1000,200,11000,40].stutter(2),inf), 1/8),
			\lpf, Pseq([
				1000,3100,300,900,
			],inf) * Pseg(Pseq([1,1/4,2],inf),8),
			\rq, ~pmodenv.(Pseq([0.1,0.02,0.51],inf), 8),
			\note, Pseq([
				0,3,2,1,
			],inf),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 21], [0.135, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.015, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\sustain, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0,0.8,0.3) ],
				[ Env.adsr(0.01,0,0.8,0.3) ],
				[ Env.adsr(0.01,0,0.8,0.1) ],
			],inf),
			\amp, 0.08,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\isRest, true,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PmonoArtic(\tr303,
			\octave, 3,
			\lpf, Pseq([
				1000,3100,300,900,
			],inf) * Pseg(Pseq([1,1/4,2],inf),8),
			\lpf, ~pmodenv.(Pseq([1000,200,11000,40].stutter(2),inf), 1/8),
			\rq, ~pmodenv.(Pseq([0.1,0.02,0.51],inf), 8),
			\freqlag, Pseq([
				0,0,0,0,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,0,
				0.81,1,0.3,1, 1,1,1,0,
			],inf),
			\note, Pseq([
				0,0,-1,0,
				0,4,-1,0,
			],inf) + Pseq([
				0,0,12,0,0,-12,
			],inf),
			\dur, 1/16,
			\iadsr, Pseq([
				[ Env.adsr(0.01,1,0.8,0.2) ],
			],inf),
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 44, 21], [0.135, 0.18], curve: \exp) ],
			\bodyenv, [ Env.linen(0.015, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,1,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0.5,
				0,0,0,0, 0.5,0.2,0.51,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0.51,1,
			],inf).coin.not,
			\dur, 1/16,
			\sustain, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0,0.8,0.3) ],
				[ Env.adsr(0.01,0,0.8,0.3) ],
				[ Env.adsr(0.01,0,0.8,0.1) ],
			],inf),
			\amp, 0.08,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\velamp, 1/3,
			\dur, 1/8,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.05,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1,
			\dur, 1/16,
			\isRest, true,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PmonoArtic(\tr303,
			\octave, 3,
			\lpf, Pseq([
				1000,3100,300,900,
			],inf) * Pseg(Pseq([1,1/4,2],inf),8),
			\lpf, ~pmodenv.(Pseq([1000,200,11000,40].stutter(2),inf), 1/8),
			\rq, ~pmodenv.(Pseq([0.1,0.02,0.51],inf), 8),
			\freqlag, Pseq([
				0,0,0,0,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,0,
				0.81,1,0.3,1, 1,1,1,0,
			],inf),
			\note, Pseq([
				0,0,-1,0,
				0,4,-1,0,
			],inf) + Pseq([
				0,0,12,0,0,-12,
			],inf),
			\dur, 1/16,
			\iadsr, Pseq([
				[ Env.adsr(0.01,1,0.8,0.2) ],
			],inf),
			\amp, 0.1,
		),
		PmonoArtic(\tr303_stereo,
			\octave, 4,
			\lpf, Pseq([
				1000,3100,300,900,
			],inf) * Pseg(Pseq([1,1/4,2],inf),8),
			\lpf, ~pmodenv.(Pseq([7000,1000,200,11000,40].stutter(2),inf), 1/8),
			\rq, ~pmodenv.(Pseq([0.2,0.1,0.02,0.51],inf), 8),
			\freqlag, Pseq([
				0,0,0,0,
			],inf),
			\legato, Pseq([
				1,0.1,0,1, 1,1,1,0,
				0,1,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\note, Pseq([
				0,0,-1,0,
				0,4,-1,0,
			],inf) + Pseq([
				0,0,12,0,-12,0,24
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		),
		
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-1+12,0,0,0,
				-1,0,
				-1,0,
				-1,0,
				-1-12,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-1+12,0,0,0,
			],inf),
			\legato, Pseq([
				4,0,0,0, 1,0,0,1/2,
				4,0,0,0, 1,0,0,1/2,
				3,0,0,1/4, 1,0,0,1/2,
				4,0,0,0, 1,0,0,1/2,
				4,0,0,0, 1,0,1/4,1/2,
				4,0,0,0, 1,0,0,1/2,
				4,0,0,0, 1,1/2,0,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\lpfr, 3,
			\diff, 0.07,
			\fmr, 1/2,
			\env1, [Env([1.2,0.82,1.2],[1.1,1.8])],
			\rq, 0.01,
			\dur, 1/16,
			\amp, 0.1/8,
		),
	])
)).play;
);
