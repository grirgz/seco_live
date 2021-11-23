
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
SynthDef(\fmtab, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,0],[0.1,1.8]), 1);
	sig1 = LFNoise1.ar(\noisefreq.kr(1)* ( 1!8 ));
	sig = SinOsc.ar(freq * ( SinOsc.ar(sig1 * \fmf.kr(1)) * \fma.kr(0.91) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1!8, mul: env1);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pulsor, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = Pulse.ar(freq, SinOsc.ar(\pwfreq.kr(1)) );
	sig1 = Pulse.ar(freq/2 * [1,1.01] ).mean;
	sig1 = RHPF.ar(sig1, \hpf.kr(100) );
	sig = sig *0.5 + sig1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \fmtab,
			\note, Pseq([
				[-7, -3, 2],
				[-7, -2, 1],
				[-7, -1, 2],
				[-7, -2, 1],
			],inf),
			\dur, 2,
			\legato, 1,
			\fma, 1.7,
			\noisefreq, 0.10,
			\fmf, ~pmodenv.(Pseq([1000,10000,],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.8) ],
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \pulsor,
			\note, Pseq([
				9,8,8,
			],inf),
			\pwfreq, ~pmodenv.(Pseq([1,2,100,4000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([100,4000],1), 8).loop,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

ProtoDef(\piano).startControl()

(
SynthDef(\grainzin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = GrainSin.ar(1, Impulse.ar(\grainfreq.kr(1,20) * [1,1 + \gfdelta.kr(0.01)]), \overlap.kr(0.1), freq * [ [1,1.01] ] * [1/4,1/2,1]) * [0.8,0.9,1];
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\zinflanger, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = AllpassL.ar(sig, LFNoise1.kr(0.1).range(0.4,0.05), 1.0) * \apamp.kr(0.4) + sig;
	//sig = AllpassL.ar(sig, LFNoise1.kr(0.1).range(0.4,0.05), 1.0).reverse * 0.4 + sig;
	//sig = AllpassL.ar(sig, LFNoise1.kr(0.1).range(0.4,0.05), 1.0) * 0.4 + sig;
	sig = sig * 1.9;
	//sig = Limiter.ar(sig, 0.1, 0.001);
	sig = Compander.ar(sig, in, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.001), \cprelax.kr(0.1));
	Out.ar(\inbus.kr, sig.reverse * \fb.kr(0.1).poll);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \grainzin,
			\note, Pseq([
				[-7, -3, 2],
				[-7, -2, 1],
				[-7, -1, 2],
				[-7, -2, 1],
			],inf),
			\dur, 2,
			\legato, 1,
			\fma, 1.7,
			\octave, 6,
			\overlap, ~pmodenv.(Pseq([0.01,0.4],1), 7).loop,
			\grainfreq, ~pmodenv.(Pseq([1,90,3,10],1), 5).loop,
			\gfdelta, 0.1,
			\noisefreq, 0.10,
			\fmf, ~pmodenv.(Pseq([1000,10000,],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.8) ],
			],inf),
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\zinflanger,
			\inbus, BusDef(\fx1, \audio),
			\addAction, \addToTail,
			\fb, Ndef(\lfo1, { MouseX.kr(0,12) }).asMap,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \grainzin,
			\note, Pseq([
				9,8,8,
			],inf),
			\pwfreq, ~pmodenv.(Pseq([1,2,100,4000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([100,4000],1), 8).loop,
			\overlap, ~pmodenv.(Pseq([0.01,0.4],1), 3).loop,
			\grainfreq, ~pmodenv.(Pseq([1,20],1), 2).loop,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \grainzin,
			\note, Pseq([
				[-7, -3, 2],
				[-7, -2, 1],
				[-7, -1, 2],
				[-7, -2, 1],
			],inf),
			\dur, 2,
			\legato, 1,
			\fma, 1.7,
			\octave, 6,
			\overlap, ~pmodenv.(Pseq([0.01,0.4],1), 7).loop,
			\grainfreq, ~pmodenv.(Pseq([1,90,3,10],1), 5).loop,
			\gfdelta, 0.1,
			\noisefreq, 0.10,
			\fmf, ~pmodenv.(Pseq([1000,10000,],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.8) ],
			],inf),
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\zinflanger,
			\inbus, BusDef(\fx1, \audio),
			\addAction, \addToTail,
			\fb, Ndef(\lfo1, { MouseX.kr(0,12) }).asMap,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \grainzin,
			\note, Pseq([
				9,8,8,
			],inf),
			\pwfreq, ~pmodenv.(Pseq([1,2,100,4000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([100,4000],1), 8).loop,
			\overlap, ~pmodenv.(Pseq([0.01,0.4],1), 3).loop,
			\grainfreq, ~pmodenv.(Pseq([1,20],1), 2).loop,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \pulsor,
			\note, Pseq([
				9,8,8,
			],inf),
			\pwfreq, ~pmodenv.(Pseq([1,2,100,4000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([100,4000],1), 8).loop,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		
	])
)).play;
);
