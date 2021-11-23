
/////////////////
/// bass5

//

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var pow = MouseX.kr(1,100);
	sig = LFTri.ar(freq + [3.29,-3.29])**pow * [1,1];
	sig = sig.mean;
	sig = Pan2.ar(sig, [-0.4,0.4], amp)*0.4;
}).play;
);

(
SynthDef(\yoshbass5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var pow = 14;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([\fatt.kr(100),0,0],[\frel.kr(0.25),0.8]), 1);
	sig = LFSaw.ar(freq * ( [3.29,-3.29]*0.01 ).midiratio).pow(pow) * [1,1];
	sig = sig.mean;
	sig = RLPF.ar(sig, env1 + \lpf.kr(90), \rq.kr(0.3));
	//sig = RLPF.ar(sig, env1 + \lpf.kr, \rq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [-0.4,0.4], amp)*2;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\yoshbass5b, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var pow = \pow.kr(15);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpfenv1.kr(Env([100,0,0],[0.25,0.8])), 1);
	env2 = EnvGen.kr(\lpfenv2.kr(Env([100,0,0],[0.25,0.8])), 1);
	sig = LFSaw.ar(freq * ( ( [3.29,-3.29]*0.01*\detfac.kr(1) ).midiratio  )).pow(pow) * [1,1];
	sig = sig.mean;
	sig = RLPF.ar(sig, env1 + \lpf.kr(90) + freq, \rq.kr(0.3));
	sig = LPF.ar(sig, \lpf2.kr(1000) + env2);
	//sig = RLPF.ar(sig, env1 + \lpf.kr, \rq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [-0.4,0.4], amp)*2;
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	fenv: ParamEnvSpec(\freq),
	gain: ControlSpec(0,4,\lin),
))).add;
);

(
SynthDef(\yoshbass5bb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var pow = \pow.kr(15);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fenv.kr(Env([100,0,0],[0.25,0.8])), 1);
	sig = LFSaw.ar(freq * ( ( [3.29,-3.29]*0.01*\detfac.kr(1) ).midiratio  )).pow(pow) * [1,1];
	sig = sig.mean;
	sig = RLPF.ar(sig, env1 + \lpf.kr(90) + freq, \rq.kr(0.3));
	//sig = RLPF.ar(sig, env1 + \lpf.kr, \rq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [-0.4,0.4], amp)*2;
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	fenv: ParamEnvSpec(\freq),
	gain: ControlSpec(0,4,\lin),
))).add;
);
(
SynthDef(\yoshbass5c, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var pow = \pow.kr(15);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fenv.kr(Env([100,0,0],[0.25,0.8])), 1);
	sig = LFSaw.ar(freq * ( ( [3.29,-3.29,1200.01]*0.01 ).midiratio  )).pow(pow) * [1,1,0.2];
	sig = sig.mean;
	sig = RLPF.ar(sig, env1 + \lpf.kr(90) + freq, \rq.kr(0.3));
	//sig = RLPF.ar(sig, env1 + \lpf.kr, \rq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [-0.4,0.4,0], amp)*2;
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	fenv: ParamEnvSpec(\freq),
	gain: ControlSpec(0,4,\lin),
))).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\yoshbass5,Pbind(
			\instrument, \yoshbass5,
			\note, Pseq([
				Pseq(
					(0..13)
				,1),
			],inf),
			\legato, 0.9,
			\dur, 2,
			\octave,2,
			\amp, 0.1,
		)),
	])
)).play;
);

Pdef(\yoshbass5).edit
Pdef(\yoshbass5b).edit
~a = Pdef(\yoshbass5b).getSpec
Pdef(\yoshbass5b).getSpec.keys.includes(\fenv)
PdefParam.instrument(Pdef(\yoshbass5b))
PdefParam.instrument(Pdef(\yoshbass5b))
Param.getSynthDefSpec(\yoshbass5b, \fenv)
~a[\gain]
~a.keys
Halo.at(Pdef(\yoshbass5b),\spec,\mix)
Pdef(\yoshbass5b).addSpec(\bla, \unipolar)
Param(Pdef(\yoshbass5b),\fenv, ParamEnvSpec(\freq)).edit
Param(Pdef(\yoshbass5b),\fenv).spec
Param(Pdef(\yoshbass5b),\gain).spec

Spec.specs[\fenv] = nil

		Pdef(\yoshbass5b,Pbind(
			\instrument, \yoshbass5b,
			\note, Pseq([
				Pseq(
					(0..13)
				,1),
			],inf),
			\legato, 0.9,
			\dur, 2,
			\octave,2,
			\amp, 0.1,
		))



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \yoshbass5b,
			\note, Pseq([
				0,0,0,-1,
				0,0,0,-13,
				-12,0,0,-1,
			],inf),
			\legato, Pseq([
				3,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\pow,5,
			\lpfenv1, Pseq([
				[ Env([100,1,0],[0.1,0.8]) ],
			],inf),
			\lpfenv2, Pseq([
				[ Env([10,1000,0],[0.1,0.8]) ],
			],inf),
			\detfac, ~pmodenv.(Pseq([0.01,2,4],1), 2).loop,
			\lpf, 300,
			\lpf2, 300,
			\rq, 0.9,
			\octave,3,
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
			\bufnum, ~buflib.kick[1165].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[159].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \yoshbass5b,
			\note, Pseq([
				-6,-6,-7,-6
			],inf).stutter(8),
			\legato, Pseq([
				6,0,0,0, 0,0,6,0,
				0,0,0,0, 0,0,0,1,
				3,0,0,3, 0,0,6,0,
				0,0,0,0, 0,0,0,1,
			],inf)*0.9,
			\lag,0.051,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\pow,5,
			\lpfenv1, Pseq([
				[ Env([100,1,0],[0.4,0.8],[2]) ],
			],inf),
			\lpfenv2, Pseq([
				[ Env([10,3400,300],[0.2,0.8],[2]) ],
			],inf),
			\detfac, ~pmodenv.(Pseq([0.01,2,4],1), 2).loop,
			\lpf, 800,
			\lpf2, 30,
			\rq, 0.9,
			\octave,3,
			\amp, 0.1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 1/2,
			\fb, 0.9,
			\delay, 0.01,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 00.1,
			\gain,1,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
