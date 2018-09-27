
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
