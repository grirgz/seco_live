
(
SynthDef(\chime, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,1.1],[0.1,0.18,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1]/1.2,[0.1,0.8]), 1);
	env2 = SinOsc.kr(\env2lfofreq.kr(2/~t) * env2).range(2,1);
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * \fmamp.kr(2)* env1 + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1 );
	sig3 = LFSaw.ar(freq * 2.6629 * (sig2 * env2 + 1) + 2.04);
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.8) * env2 * freq, \rq.kr(0.1));
	sig4 = LFCub.ar(freq * 1 * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	sig7 = LFPulse.ar(freq * 6/4 * sig1 + 0);
	sig7 = RLPF.ar(sig7, \lpfr.kr(1.8) * env2 * freq, \rq.kr(0.1));
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6, sig7] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5,0.3]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;
)

Pdef(\part).clear;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \chime,
			\freq, 200,
			\freq, Pseq([
				Pseq(
					Array.geom(20, 1000, 0.6)
				),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/16 * Prand([1,0.7,0.8,1.2],inf),
			\amp, 0.1/2,
		),
	])
)).play;
)

(
SynthDef(\bellchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1, 8/3, 0.99, 8/3+0.01]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.3,1,-1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmbell,
			\instrument, \bellchord,
			\legato, 0.1,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
SynthDef(\bellnote, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([1,2,1]*0.8,[0.01,1.8]), 1);
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.3,1,-1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bellnote, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fm;
	env1 = EnvGen.kr(Env([1,2,1]*0.8,[0.01,1.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1]*1.8,[0.01,1.8]), 1);
	fm = ( SinOsc.ar(freq) * env2 + 1 );
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq * fm);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.3,1,-1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmbell,
			\instrument, \bellnote,
			\note, Pstep(Pseq([
				0,7,-5,2,
			],inf),1),
			\octave, 3,
			\distamp, 0.4, \distpostamp, 1,
			\oscmix, Pfunc({ arg ev;
				[1,1.0.rand,0.81,1];
			}),
			\lpfr, ~pmodenv.(Pseq([1,8],inf), 16),
			\freq, Pkey(\freq) * [1,4/3+0.00021,4/3+0.0001, 0.999],
			\pan, [-0.5,-0.5,0.5,0.5],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, Pseq([
				1,1,1,1,
				1,4,1,1,
				1,1,2,2,
				1,1/2,1,1,
				4,1,1,1,
			],inf)/4 * Pseg(Pseq([2,1],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\instrument, \bellnote,
			\note, Pseq([
				0,7,-5,2,
			],inf),
			\octave, 4,
			\distamp, 0.4, \distpostamp, 1,
			\oscmix, Pfunc({ arg ev;
				[1,1.0.rand,0.81,1];
			}),
			\freq, Pkey(\freq) * [1,8/3+0.00021,8/3+0.0001, 0.999],
			\pan, [-0.5,-0.5,0.5,0.5],
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \fmbell,
			\instrument, \bellnote,
			\note,  Pstep(Pseq([
				0,7,-5,2,
			],inf),1) + Pseq([
				5,0,12,-12,
				2,0,12,-12,
			],inf),
			\octave, 6,
			\distamp, 0.4, \distpostamp, 1,
			\oscmix, Pfunc({ arg ev;
				[1,1.0.rand,0.81,1];
			}),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,1.3,1,-1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,1, 1,1,0,1,1,
				1,1,1,1,
			],inf).coin.not,
			\freq, Pkey(\freq) * [1,8/3+0.00021,8/3+0.0001, 0.999],
			\pan, [-0.5,-0.5,0.5,0.5],
			\legato, 0.1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \fmbell,
			\instrument, \bellnote,
			\note,  Pstep(Pseq([
				0,7,-5,2,
			],inf),1) + Pseq([
				5,0,12,-12,
				2,0,12,-12,
			],inf),
			\octave, Prand([5,7],inf),
			\distamp, 0.4, \distpostamp, 1,
			\oscmix, Pfunc({ arg ev;
				[1,1.0.rand,1.0.rand,1];
			}),
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,1,0,
				1,1,0,0, 1,0,1,1,
			],inf).coin.not,
			\lag, 1/16/~t,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
				[ Env.adsr(0.01,0.1,0.8,1.3,1,-1) ],
			],inf),
			\freq, Pkey(\freq) * [1,8/3+0.00021,8/3+0.0001, 0.999],
			\pan, [-0.5,-0.5,0.5,0.5],
			\legato, 0.1,
			\dur, 1/8 * (1 + (0.06 * Pseq([1,-1],inf))),
			\amp, 0.1/4,
		),
	])
)).play;
)
