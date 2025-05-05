
(
FileSystemProject.loadOnce("gluon/main.scd");
~t = 210/4/60; TempoClock.default.tempo = ~t;
)

FileSystemProject('gluon/glu2').open.edit;

//// lib

(
SynthDef(\sh101am, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq * ( \vcomod.kr(0) + 1 );
	sig = LFPulse.ar(freq,0,\pwidth.kr(0.5)) * \pulse.kr(0.5);
	sig = sig + (LFSaw.ar(freq) * \saw.kr(0.5));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(130) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	vcfmod = \vcfmod.kr(0) + 1;
	sig = MoogFF.ar(sig, ( \lpf.kr(930) * lpenv * lpfreq * vcfmod ).clip(20,20000), 1/\rq.kr(0.8)) * 3;
	sig = sig * EnvGen.kr(Env([0,1,1,0],[0.01,0.1,0.01]/2), Impulse.kr(\amfreq.kr(8*~t)));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpadsr: ParamEnvSpec.adsr,
))).add;
);

(
// whitenoise in a closing filter is the essence
// phasering delay is the secret
SynthDef(\pschiou, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpfr.kr(1) * XLine.kr(10000,100,\time.kr(4/~t)), \rq.kr(0.5) * XLine.kr(1,0.3,4/~t));
	sig = sig + DelayL.ar(sig, 0.9, 0.01 * XLine.kr(0.01,0.81,\time.kr));
	//sig = sig + DelayL.ar(sig, 0.9, 0.01 * XLine.kr(0.001,0.81,4/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\trans1, 
	Pbind(
		\instrument, \pschiou,
		\dur, 2,
		\time, 2,
		\amp, 0.1,
	),
);
);


(
SynthDef(\fx_nimp, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(\amf.kr(300));
	sig = DelayL.ar(sig, 0.1, 0.1 * SinOsc.ar(1/\amf.kr, mul:0.05,add:1) ) + sig;
	sig = RHPF.ar(sig, \amf.kr, 0.2);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\fx_nimp1, 
	Pmono(\fx_nimp,
		\dur, 1,
	),
);
);
