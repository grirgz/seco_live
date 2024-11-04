
ParamProto.init(true);
TrackGroupDef(\tg).clear
(
( ParamProto.base_path +/+ "track.scd" ).load;
SynthDef(\kick, { arg out=0, amp=0.1, gate=1, pan=0, freq=70;
	var sig;
	var env1, env2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.ar(\env1.kr(Env([600,65,60],[0.01,0.8], -4)), 1);
	env2 = EnvGen.ar(\env2.kr(Env([1,4,1],[0.001,0.1])), 1);
	
	sig = SinOsc.ar(env1);
	//sig = sig + Pulse.ar(env1/2);
	sig = sig + SinOsc.ar(env1);
	sig = sig + SinOsc.ar(env1, 0.3);
	sig = sig + SinOsc.ar(env1, 0.8);
	sig = 1.collect({ SinOsc.ar(env1, Rand(0, 2*pi )) }).mean;

	sig1 = sig;
	sig1 = sig1 + WhiteNoise.ar(1);
	sig2 = sig1;
	sig1 = LPF.ar(( sig1 * 10 ).tanh, \lpf.kr(300));
	sig1 = HPF.ar(( sig1 * 10 ).tanh, \hpf.kr(20));
	sig1 = sig1 + BPF.ar(sig2, 4500,0.4);
	sig = sig + sig1;
	sig = LPF.ar(sig, env2 * 42);
	sig = sig * EnvGen.ar( \ampenv.kr(Env([0,1,0],[0.001,0.7], -4)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(\freq!3),
	env2: XEnvSpec(ControlSpec(0.01,10, \exp)!3),
	ampenv: XEnvSpec(ControlSpec(0.01,2, \exp)!3),
	duration: ControlSpec(0.001,4,\lin, 0, 1)
))).add;

SynthDef(\snare, { arg out=0, amp=0.1, gate=1, pan=0, freq=4700, doneAction=2;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1000,4400,441],[0.01,0.3])), 1);
	env2 = EnvGen.kr(\env2.kr( Env([4310,440,1641],[0.01,0.1], -4) ), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1,1.02,1],[0.4,0.13])), 1);
	env4 = EnvGen.kr(\env4.kr( Env([4310,440,1641],[0.01,0.1], -4) ), 1);
	sig = WhiteNoise.ar;
	sig = sig + LFNoise1.ar( 200 * env3 );
	//sig = sig + SinOsc.ar(freq);
	sig = Ringz.ar(sig, 
		\ringfreq.kr(
			Array.geom(8,80,1.022) +
			Array.series(8,70,3)
		),
		\ring.kr({ rrand(0.01,0.4) } ! 8)

	).mean * \ringamp.kr(0.4)/10 + sig;
	sig = FreqShift.ar(sig, \shift.kr(-400));
	sig = LPF.ar(sig, [ env1, env4 ]).mean;
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, \lpf.ar(10000));
	sig = BRF.ar(sig, 4500,0.1);
	sig = BRF.ar(sig, 7500,0.1);
	//sig = sig + WhiteNoise.ar;
	//sig = LPF.ar(sig, env1 * 2);
	//sig = HPF.ar(sig, env2);

	sig = Pan2.ar(sig, pan, amp);
	sig = [sig[0], DelayC.ar(sig[1],0.1,\delayr.ar(0.0001)) + sig[1]];
	//sig = sig * EnvGen.ar(Env.adsr(0.0001,0.1,0.8,0.3, 1, -5),gate,doneAction:2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:doneAction);
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(\freq!3),
	env2: XEnvSpec(\freq!3),
	env3: XEnvSpec( ControlSpec(0.01,8,\exp)!3),
	env4: XEnvSpec(\freq!3),
	ringfreq: XArraySpec(\freq!8),
	ring: XArraySpec( \unipolar!8),
	adsr: XEnvSpec.adsr,
))).add;

Pdef(\kick, Pbind(
	\instrument, \kick,
	\dur, Pkeyd(\dur,1/2),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,0.581,0, 0,0,0,0,
		1,0,0,0, 0,0,0.2,0,
		1,0,0.581,0, 0,0,0,0,
		1,0,0,0, 0,0,0.05,0,
		1,0.581,0,0, 0,0,0.15,0,
	],inf).coin.not,
)).addHalo(\instrument, \kick);

Pdef(\snare, Pbind(
	\instrument, \snare,
	\legato, Pkeyd(\legato, 0.2),
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
)).addHalo(\instrument, \snare);

Pdef(\hat, Pbind(
	\instrument, \snare,
	\dur, Pkeyd(\dur, 1/4),
	//\dur, 1/8,
	//\legato, 0.1,
	\legato, Pkeyd(\legato, 0.1),
)).addHalo(\instrument, \snare);

TrackGroupDef(\tg, [Pdef(\kick), Pdef(\snare), Pdef(\hat)]);
);

Pdef(\hat).play

TrackGroupDef(\tg).edit
TrackGroupDef(\tg).clear
TrackGroupDef(\tg)[0].play
TrackGroupDef(\tg)[1].play
TrackGroupDef(\tg)[2].edit
TrackGroupDef(\tg)[3].source  =Ndef(\bla)

(
Ndef(\bla, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar( \fmfreq.kr(100)*  ( 1 + ( SinOsc.ar(100) * 1 )) ) * 1 )));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\bla), { arg freq; SinOsc.ar(freq * ( 1 + ( SinOsc.kr( LFNoise1.kr([1/3,1/2]).range(0.0,1.0) ) * LFNoise1.kr(1/2).range(0.0,1.0) )))  })
Ndef(\bla).clear


(
Pdef(\beat1, Pbind(
	\instrument, \dr_oscsampler,
)).play;
)

(
Pdef(\beat2, Pbind(
	\instrument, \dr_oscsampler,
)).play;
)

Pdef(\beat1).asParamGroup

(
Pdef(\beat3, Pbind(
	\instrument, \dr_oscsampler,
	\pos, Pseq([0.1,0.3],inf),
	\lag, 0.3,
)).play;
)

(
Pdef(\beat4, Pbind(
	\instrument, \dr_oscsampler,
)).play;
)

(
Pdef(\beat5, Pbind(
	\instrument, \dr_oscsampler,
	\pos, Pkey(\pos) + Pseq([0.1,0.3,0.12,0.4]/10,inf).stutter(Pseq([2,8,4,4],inf)),
)).play;
)

(
Pdef(\beat6, Pbind(
	\instrument, \dr_oscsampler,
)).play;
)

(
Pdef(\hat2, Pbind(
	\instrument, \dr_oscsampler,
)).play;
)

Pdef(\kick, Pbind(
	\instrument, \kick,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
	],inf).coin.not,
));

WindowDef(\bla, { Button.new }).front
