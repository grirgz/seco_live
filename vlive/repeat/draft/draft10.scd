



(
Pdef(\ixo,
	Pbind(\octave, Pseq([5,4,5,5,5],inf)) <>
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				[0,2],
				[-1,2],
				[1,4],
				[2,4],
			],inf).stutter(4),
			//\scale, Scale.minor,
			\out, BusDef(\mixer0),
			\legato, Pseq([
				2,2,2,2,
				Pseq([
					1,1,1,1,
				],1)/2,
				2,2,2,2,
				Pseq([
					1,1,1,1,
				],1),
			],inf),
			\legato, 0.91,
			\isRest, Pseq([
				Pshuf([1,0,1,1,1],inf),
			],inf).coin.not,
			\dur, 1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				\r,\r,\r,\r,
				\r,\r,12,6,
			],inf) + [0,2],
			\scale, Scale.minor,
			\out, BusDef(\mixer0),
			\dur, 1/4,
			\amp, 0.1
		)
	]),

).play;
);


(
	// orig
Pdef(\ixo,
	Pbind(\octave, Pseq([5,4,5,5,5],inf)) <>
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				0,\r,\r,\r,
				0,2,4,\r,
			],inf) + [0,2],
			\scale, Scale.minor,
			\out, BusDef(\mixer0),
			\legato, Pseq([
				2,2,2,2,
				Pseq([
					1,1,1,1,
				],1)/2,
				2,2,2,2,
				Pseq([
					1,1,1,1,
				],1),
			],inf),
			\dur, 1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				\r,\r,\r,\r,
				\r,\r,12,6,
			],inf) + [0,2],
			\scale, Scale.minor,
			\out, BusDef(\mixer0),
			\dur, 1/4,
			\amp, 0.1
		)
	]),

).play;
);

(
Pdef(\main, 
	Ppar([
		Pdef(\drums),
		Pdef(\ixo),
		
	])
).play;
)

(
Pdef(\drums).play;
Pdef(\ixo).play;
ProtoDef(\rdn2).play;
ProtoDef(\rdn).play;
)

(
Pdef(\main).stop;
Pdef(\drums).stop;
Pdef(\ixo).stop;
)

Pdef(\main).stop
Pdef(\drums).stop
Pdef(\drums).play
Pdef(\ixo).stop
Pdef(\ixo).play
ProtoDef(\piano).startControl(Pdef(\ixo))

ProtoDef(\simpleMixer).play
ProtoDef(\rdn).edit
ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn).genfx

Pdef(\drums).set(\out, BusDef(\mixer1))
ProtoDef(\rdn2, ProtoTemplateDef(\rdn))
ProtoDef(\rdn2).edit
ProtoDef(\rdn2).play;
ProtoDef(\rdn).play;
ProtoDef(\rdn).edit
ProtoDef(\rdn2).loadDefaultPreset
WindowDef(\doublerdn).front([ProtoDef(\rdn), ProtoDef(\rdn2)]);

(
Pdef(\drums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/4,
			\gain, 0.4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,1,0,0, 0,1,0,0,
				0,1,0,0, 1,0,0,0,
				0,1,0,1, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/4,
			\gain, 0.4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,1,0,
				0,0,0,1,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,1,0,
				0,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\dur, 1/8,
			\gain, 0.2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0,1, 1,1,0,0,
			],inf).coin.not,
			\gain, Pseq([
				1,0.2,1,0.2,
			],inf),
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)).drop(2),
		
	])
).play;
)

(
	// orig
Pdef(\drums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0,1, 1,1,0,0,
			],inf).coin.not,
			\gain, Pseq([
				1,0.2,1,0.2,
			],inf),
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)).drop(2),
		
	])
).play;
)

(
SynthDef(\emergency, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq.lag(1);
	lfo1 = LFPulse.kr(4, 0, 0.84).range(-1,1) * 0.9;
	lfo1 = LPF.kr(lfo1, 10);
	env1 = EnvGen.kr(\adsr.kr(Env.dadsr(0.2,0.4,0.0,1,0.1,1,4)), gate, doneAction:0);
	sig = LFPulse.ar(freq * ( 1 + ( LFSaw.ar(freq/2) * 1.4 )) * ( 1 + ( SinOsc.ar(freq*2 * [1,1.0001]) * 0.4 )));
	sig1 = sig;
	sig1 = BPF.ar(sig1, ( freq/4  + ( env1 * freq ) * ( lfo1.lag(0.1) + 1 )), 0.8);
	sig1 = ( sig1 * 1000 ).clip2(1)/2;
	sig = sig1 + sig;
	sig = LPF.ar(sig, ( freq*2+100  + ( env1 * freq ) * ( lfo1 + 1 )).clip(80,20000));
	sig = LPF.ar(sig, 10000);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.5),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\emergency, Pbind(
	\instrument, \emergency,
	\degree, Pseq([0,2,4,2],inf),
	\octave, 3,
	\dur, 2,
	\amp, 0.1
)).play;
);


p = ProxySpace(s)
p.push
p.pop
~paa = { SinOsc.ar(400)  };
~paa.play
~paa.stop
p[\paa].play
p[\paa] == ~paa

(note:1, sustain:inf, instrument:\plop, \latency:\).play

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, sustain;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(Env([1,2,1],[0.1,sustain]), 1);
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
