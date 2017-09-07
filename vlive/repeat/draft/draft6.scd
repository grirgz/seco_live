

(
SynthDef(\noise1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = LFNoise1.kr((1..8)/8).exprange(20,19000);
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\phyhat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,2100,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = HPF.ar(sig, 20000-env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\stickfight, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([4410,100,451],[0.1,0.2]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	//env2 = EnvGen.kr(Env([18210,2100,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([110,12100,451],[0.1,0.2],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\snarebpf1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\snarebpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\noise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(10) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,1810,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.3) );
	env2 = EnvGen.kr(Env([171,170,845],[0.04,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/1 ) + ( sig );
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-8),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\phycymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([8261, 11410, 1460], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(10) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1180,6810,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.3) );
	env2 = EnvGen.kr(Env([3171,7470,13845],[0.04,\rel.kr(0.1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = pop/2 + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.71,0.9) * XLine.kr(1.3,1,1)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, 17000);
	sig = LPF.ar(sig, 11000) + ( sig/2 );
	//sig = BRF.ar(sig, MouseX.kr(20,20000).poll, MouseY.kr(0.1,1));
	sig = BRF.ar(sig, 12000);
	sig = sig * 0.6;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.1,0.1,0.8,0.4,1,-8) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\noise, Pbind(
	\instrument, \noise,
	\degree, Pseq([0],inf),
	\sustain, 1/8,
	\dur, 1,
	\amp, 0.1
)).play;
);
(
Pdef(\noise, Pbind(
	\instrument, \noise1,
	\degree, Pseq([0],inf),
	\dur, 8,
	\amp, 0.1
)).play;
);

~t = 96/2/60; TempoClock.default.tempo = ~t;
Pdef(\testdrums).set(\out, BusDef(\sendbus3))
Pdef(\testdrums).set(\out, nil)
Pdef(\kit_workspace, Pdef(\testdrums))
(
Pdef(\testdrums, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	])
).play;
)

Pdef(\testdrums).set(\out, BusDef(\sendbus2, \audio))

(
Ndef(\drumy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
}).play;
);

Ndef(\drumy).edit
ProtoDef(\rdn).edit
ProtoDef(\rdn).loadDefaultPreset;
ProtoDef(\rdn).play;
ProtoDef(\rdn).genfx;
ProtoDef(\rdn).outBus = BusDef(\sendbus1);
ProtoDef(\rdn).inBus = BusDef(\sendbus2);
ProtoDef(\rdn).outBus = 0;


(
Ndef(\echo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	var mix;
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	//sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	mix = Duty.kr(1/8/~t, 0, Dseq([
		0,1,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf));
	sig = SelectX.ar(mix, [DC.ar(0), in]);
	sig = CombL.ar(sig, 1/2/~t, 1/8/~t, 2/~t);
	sig = sig * \gain.kr(1);
	//sig = SelectX.ar(mix, [in, sig]);
	in + sig;
//}).play(BusDef(\sendbus1).index, 2);
}).play(0, 2);
);

(
Pdef(\main, 
	Pseq([
		Pfindur(6, Pdef(\testdrums)),
		Pfindur(2, Pdef(\testdrums2)),
		
	],inf)
).play;
)

Pdef(\azemain, Ppar([ Pdef(\testdrums), ])).play;
Pdef(\azemain, Ppar([ Pdef(\testdrums2), ])).play;
Pdef(\azemain, Ppar([ Pdef(\testdrums3), ])).play;
Pdef(\azemain).set(\out, BusDef(\sendbus2))
Pdef(\azemain).clear
ProtoDef(\rdn).play
ProtoDef(\rdn).outBus = BusDef(\sendbus3)

Pdef(\testdrums3).stop
Pdef(\testdrums).set(\out, nil)
Pdef(\testdrums2).set(\out, nil)
Pdef(\testdrums3).set(\out, nil)
Pdef(\testdrums3).set(\out, BusDef(\sendbus2))
(
	// var 2
Pdef(\testdrums2, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				0,1,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/1,
		),
		Pbind(
			\instrument, \snarebpf1,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\pan, 0.1/2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	])
).play;
)

(
Pdef(\testdrums3, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \noise,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,1.1,1,-2) ]
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 1,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1, 
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1,
			],inf)*0.1,
			\dur, 1/16,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	])
).play;
)


(
	// var 4
Pdef(\testdrums2, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/1,
		),
		Pbind(
			\instrument, \snarebpf1,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\pan, 0.1/2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	])
).play;
)



///////////////////////////////////////////////


(
Pdef(\resamp, 
	// rand part in order
	Pseq([
		Pbind(
			\instrument, \playersec,
			\bufnum, Pseq([
				Prand([
					BufDef('loop/funky2_96bpm.flac'),
					BufDef('loop/funky1_96bpm.flac'),
					BufDef('loop/funky3_96bpm.flac'),
					BufDef('loop/funky4_96bpm.flac'),
					BufDef('loop/funky5_96bpm.flac'),
					BufDef('loop/funky6_96bpm.flac'),
					BufDef('loop/funky7_96bpm.flac'),
				],1),
			],inf),
			\pos, Pseq([0,1/2,1,1+( 1/2 )]/~t,inf),
			\freq, 200,
			\legato, 0.9,
			\dur, 1/2,
			\amp, 0.1
		);

		
	])
).play;
)

(
	//Pdef(\testdrums).play;
Pdef(\resamp, 
	Pseq([
		Plazy({
			var stut = Pseq([
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,4,1, 1,1,4,1, 1,1,4,1, 1,1,4,1,
				1,1,4,1, 1,1,1,1, 1,1,1,1, 1,1,4,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,2,1,1, 2,1,1,1, 1,1,1,1,
			],inf);
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					Plazy({

						var bufs = [
							BufDef('loop/funky0_96bpm.flac'),
							BufDef('loop/funky1_96bpm.flac'),
							BufDef('loop/funky2_96bpm.flac'),
							BufDef('loop/funky3_96bpm.flac'),
							BufDef('loop/funky4_96bpm.flac'),
							BufDef('loop/funky5_96bpm.flac'),
							BufDef('loop/funky6_96bpm.flac'),
							BufDef('loop/funky7_96bpm.flac'),
							BufDef('loop/funky8_96bpm.flac'),
							BufDef('loop/funky9_96bpm.flac'),
							BufDef('loop/funky10_96bpm.flac'),
							BufDef('loop/funky11_96bpm.flac'),
						];

						Pindex(bufs, Pseq([
							Pseq([
								6,0,0,0, 5,0,0,0, 0,0,0,5, 5,5,5,5,
							],1),
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*10,1),
							Pseq([ 1,1,1,1, 1,1,1,1, ]*8,1),
							Pseq([ 1,1,1,1, 1,1,1,1, ]*6,1),
						],inf));
					})

				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0, 
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0, 
				],inf).coin.not,
				\speed, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					2,2,1,1, 1,2,1,1, 2,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					Pseq([
						1,1,1,2, 2,1,1,2, 2,1,1,1, 1,1,1,1,
					]/2,1),
				],inf),
				\pos, Pseq((0..15)/16*2/~t,inf)+0.04,
				\legato, 1,
				\amp, 0.1,
			).stutter(stut) <>
			Pbind(
				\dur, PdurStutter(stut,1/8),
				
			);

		})

		
	])
).play;
)


(
	// multitrack
Pdef(\resamp, 
	Ppar([
		Plazy({
			var stut = Pseq([
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,2,2,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,1,4,1, 1,1,1,1, 1,1,1,1,
			],inf);
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					Plazy({

						var bufs = [
							BufDef('loop/funky0_96bpm.flac'),
							BufDef('loop/funky1_96bpm.flac'),
							BufDef('loop/funky2_96bpm.flac'),
							BufDef('loop/funky3_96bpm.flac'),
							BufDef('loop/funky4_96bpm.flac'),
							BufDef('loop/funky5_96bpm.flac'),
							BufDef('loop/funky6_96bpm.flac'),
							BufDef('loop/funky7_96bpm.flac'),
							BufDef('loop/funky8_96bpm.flac'),
							BufDef('loop/funky9_96bpm.flac'),
							BufDef('loop/funky10_96bpm.flac'),
							BufDef('loop/funky11_96bpm.flac'),
						];

						Pindex(bufs, Pseq([
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*4,1),
						],inf));
					})

				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\speed, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq((0..15)/16*2/~t,inf)+0.04,
				\legato, 1,
				\amp, 0.1,
			).stutter(stut) <>
			Pbind(
				\dur, PdurStutter(stut,1/8),
			);
		}),
		Plazy({
			var stut = Pseq([
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,2,2,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,1,4,1, 1,1,1,1, 1,1,1,1,
			],inf);
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					Plazy({

						var bufs = [
							BufDef('loop/funky0_96bpm.flac'),
							BufDef('loop/funky1_96bpm.flac'),
							BufDef('loop/funky2_96bpm.flac'),
							BufDef('loop/funky3_96bpm.flac'),
							BufDef('loop/funky4_96bpm.flac'),
							BufDef('loop/funky5_96bpm.flac'),
							BufDef('loop/funky6_96bpm.flac'),
							BufDef('loop/funky7_96bpm.flac'),
							BufDef('loop/funky8_96bpm.flac'),
							BufDef('loop/funky9_96bpm.flac'),
							BufDef('loop/funky10_96bpm.flac'),
							BufDef('loop/funky11_96bpm.flac'),
						];

						Pindex(bufs, Pseq([
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*10,3),
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*4,1),
						],inf));
					})

				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,1,1,
				],inf).coin.not,
				\speed, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq((0..15)/16*2/~t,inf)+0.04,
				\legato, 1,
				\amp, 0.1,
			).stutter(stut) <>
			Pbind(
				\dur, PdurStutter(stut,1/8),
			);
		}),
		Plazy({
			var stut = Pseq([
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,2,2,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,1,4,1, 1,1,1,1, 1,1,1,1,
			],inf);
			Pbind(
				\instrument, \playersec,
				\bufnum, Pseq([
					Plazy({

						var bufs = [
							BufDef('loop/funky0_96bpm.flac'),
							BufDef('loop/funky1_96bpm.flac'),
							BufDef('loop/funky2_96bpm.flac'),
							BufDef('loop/funky3_96bpm.flac'),
							BufDef('loop/funky4_96bpm.flac'),
							BufDef('loop/funky5_96bpm.flac'),
							BufDef('loop/funky6_96bpm.flac'),
							BufDef('loop/funky7_96bpm.flac'),
							BufDef('loop/funky8_96bpm.flac'),
							BufDef('loop/funky9_96bpm.flac'),
							BufDef('loop/funky10_96bpm.flac'),
							BufDef('loop/funky11_96bpm.flac'),
						];

						Pindex(bufs, Pseq([
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*5,3),
							Pseq([
								1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
							]*4,1),
						],inf));
					})

				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,0, 1,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\speed, Pseq([
					1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				],inf),
				\pos, Pseq((0..15)/16*2/~t,inf)+0.04,
				\legato, 1,
				\amp, 0.1,
			).stutter(stut) <>
			Pbind(
				\dur, PdurStutter(stut,1/8),
			);
		})
	])
).play;
)


(
	// function

	~sampler = { arg stut, pat, prepat;
		var looptempo = 96/2/60;

		Plazy({
			var bufs = [
				BufDef('loop/funky0_96bpm.flac'),
				BufDef('loop/funky1_96bpm.flac'),
				BufDef('loop/funky2_96bpm.flac'),
				BufDef('loop/funky3_96bpm.flac'),
				BufDef('loop/funky4_96bpm.flac'),
				BufDef('loop/funky5_96bpm.flac'),
				BufDef('loop/funky6_96bpm.flac'),
				BufDef('loop/funky7_96bpm.flac'),
				BufDef('loop/funky8_96bpm.flac'),
				BufDef('loop/funky9_96bpm.flac'),
				BufDef('loop/funky10_96bpm.flac'),
				BufDef('loop/funky11_96bpm.flac'),
			];

			stut = stut ? Pseq([
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,2,2,1,
				1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,1,4,1, 1,1,1,1, 1,1,1,1,
			],inf);

			( prepat ? Pbind() ) <>
			Pstutter(stut,
				Pbind(
					\bufnum, Pindex(bufs, Pkey(\bufidx)),
				) <>
				(pat ? Pbind()) <>
				Pbind(
					\instrument, \playersec,
					\bufidx, Pseq([
						1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					]*0,inf),
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\speed, Pseq([
						1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\pos, Pseq((0..15)/16*2/looptempo,inf)+0.04,
					\legato, 1,
					\amp, 0.1,
				)
			) <>
			Pbind(
				\dur, PdurStutter(stut,1/8),
			);
		});

	};
)

(

	// functional
Pdef(\resamp, 
	Ppar([
		~sampler.(
			Pseq([
				1,1,1,1
			],inf),
			Pbind(
				\bufidx, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				4,4,4,4
			],inf),
			Pbind(
				\bufidx, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*2,1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*7,1),
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				],inf),
				\legato, 0.1,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				4,4,4,4
			],inf),
			Pbind(
				\bufidx, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*8,1),
				],inf),
				\speed, 0.7,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 0,1,1,1, 1,0,1,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,1,1, 1,1,1,1,
				2,1,2,1, 2,4,8,1,
			],inf),
			Pbind(
				\bufidx, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*10,1),
				],inf),
				\speed, 1.2,
				\gain, 0.8,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					 0,0,0,1, 1,0,1,0, 0,1,1,0, 1,1,1,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,1,1, 1,1,1,1,
				2,1,2,1, 2,4,8,1,
			],inf),
			Pbind(
				\bufidx, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*11,1),
				],inf),
				\speed, 1.2,
				\gain, 0.8,
				\isRest, Pseq([
					Pseq([
						0,1,0,1, 0,1,0,1,
					],6),
					Pseq([
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
					],1),
				],inf).coin.not,
			);
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				0,0,0,0,
				1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
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
		))

	])
).play;
)


(

	// functional 2
Pdef(\resamp, 
	Ppar([
		~sampler.(
			Pseq([
				1,1,1,1
			],inf),
			Pbind(
				\bufidx, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,1,1
			],inf),
			Pbind(
				\bufidx, Pseq([
					0,0,0,0, 0,0,0,0,
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*3,1),
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,1,0,1, 1,1,0,0, 
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,4,4,4, 1,3,1,2,
			],inf),
			Pbind(
				\bufidx, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*9,1),
				],inf),
				\speed, 0.5,
				\gain, 0.7,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,1,1,0, 1,0,0,0, 0,0,0,0, 
					0,0,0,1, 0,1,0,0, 1,0,0,0, 0,0,0,0, 
					1,1,0,1, 1,0,0,1, 1,0,1,0, 0,0,0,0, 
				],inf).coin.not,
			);
		),

	])
).play;
)

(

	// functional 3
Pdef(\resamp, 
	Ppar([
		~sampler.(
			Pseq([
				1,1,2,1
			],inf),
			Pbind(
				\pos, 0/~t+0.04,
				\bufidx, Pseq([
					2
				],inf),
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0, 0,0,0,1, 0,0,0,0,
					1,1,1,1, 1,1,0,1, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				4,1,1,1
			],inf),
			Pbind(
				\pos, 0.5/~t+0.04,
				\bufidx, Pseq([
					3
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					 0,0,0,0, 1,0,1,1,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,2,1
			],inf),
			Pbind(
				\pos, 1/~t+0.04,
				\bufidx, Pseq([
					8,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,2,1
			],inf),
			Pbind(
				\pos, 0.76/~t+0.04 + Pseq([0,0.04],inf).stutter(2),
				\bufidx, Pseq([
					8
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-2) ],
				],inf),
				\legato, 0.2,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,1,0,
				],inf).coin.not,
			);
		),

	])
).play;
)

(

	// functional 4
Pdef(\resamp, 
	Ppar([
		~sampler.(
			Pseq([
				1,1,2,1
			],inf),
			Pbind(
				\pos, 0/~t+0.04,
				\bufidx, Pseq([
					2
				],inf),
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0, 
					1,0,0,1, 0,0,1,0, 0,1,0,0, 1,0,0,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,2,1
			],inf),
			Pbind(
				\pos, 1/~t+0.04,
				\bufidx, Pseq([
					2
				],inf),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,2,1
			],inf),
			Pbind(
				\pos, 0/~t+0.04,
				\bufidx, Pseq([
					3
				],inf),
				\legato, Pseq([
					4,1,1,1, 1,1,1,1,
					2,1,1,2, 1,1,2,1,
					
				],inf),
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
				],inf).coin.not,
			);
		),
		~sampler.(
			Pseq([
				1,1,2,1
			],inf),
			Pbind(
				\pos, 1/~t+0.04,
				\bufidx, Pseq([
					9
				],inf),
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 4,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 8,1,1,1,
					
				],inf),
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
			);
		),

	])
).play;
)


(
Pdef(\trans1, 
	Pseq([
		Pfindur(3,Ppar([
			Pbind(
				\instrument, \playersec,
				\pos, 0/~t+0.04,
				\bufnum, BufDef('loop/funky1_96bpm.flac'),
				\freq, 200,
				\speed, Pseg(Pseq([0,1,1],inf),2),
				\isRest, Pser([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, Pseg(Pseq([0,1,1],inf),2),
				\amp, 0.1
			),
			Pbind(
				\instrument, \playersec,
				\pos, 1/~t+0.04,
				\bufnum, BufDef('loop/funky1_96bpm.flac'),
				\freq, 200,
				\speed, Pseg(Pseq([0,1,1],inf),2),
				\gain, Pseg(Pseq([0,1,1],inf),2),
				\isRest, Pser([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1
			),
		])),
			Pbind(
				\instrument, \sampleosc,
				\pos, 1/~t+0.04,
				\bufnum, BufDef('loop/funky1_96bpm.flac'),
				\freq, 200,
				\speed, 3,
				\isRest, Pser([
					1,
				],1).coin.not,
				\dur, 1/8,
				\amp, 0.1
			),
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, Pseq([1],1),
			\amp, 0.1
		),
		
	])
).play;
)


(
SynthDef(\bakick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1, freq=200, gate=1|
	var env0, env1, env1m;
	var sig;
	var fat;
	freq = freq.lag(1/4);
	fat = freq*1.1;
	fratio = fratio.lag(1/4);

	//freqpan = [-1,0,1] * freqpan;
	env0 = \adsr.kr(Env.adsr(0.01,0.1,0.8,0.1));
	env1 = Env.new([fat, fat, freq, freq*0.98], [0.001,0.05, 0.39], [-4, -5]);
	
	env0 =  EnvGen.ar(env0, gate, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, \trig.tr(1), timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = sig * \distamp.kr(1.2).lag(1/4);
	sig = BPF.ar(sig, env1*2, 0.1) + sig;
	sig = LeakDC.ar(sig - 1.4);
	sig = sig.tanh(1);
	sig = LPF.ar(sig, \lpf.kr(4000));
	sig = sig + FreqShift.ar(sig, freq*2, mul:1/2);
	//sig = sig * 3;
	sig = sig  / 3;
	sig = HPF.ar(sig, 70);
	

	sig = sig * env0 * 8;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\trans1, 
	// trans bass
Pfindur(8,	Ppar([
		Ppar([
			Pbind(
				\instrument, \playersec,
				\pos, 0/~t+0.04,
				\bufnum, BufDef('loop/funky2_96bpm.flac'),
				\freq, 200,
				\speed, Pseg(Pseq([0,1,1,1,1,1],inf),2),
				\isRest, Pser([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1
			),
			Pbind(
				\instrument, \playersec,
				\pos, 1/2/~t+0.04,
				\bufnum, BufDef('loop/funky2_96bpm.flac'),
				\freq, 200,
				\speed, Pseg(Pseq([0,1,1,1,1,1],inf),2),
				\isRest, Pser([
					1,0,1,0, 1,0,1,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/4,
				\amp, 0.1
			),
		]),
		PmonoArtic(\bakick,
			\degree, Pseq([
				Pseq([
					-1,-1,-1,-3,
				],6),
				Pseq([
					0,0,0,2,
				],2),
			],inf),
			\freq, 40 * Pseg(Pseq([1,2],inf),8),
			\fratio, Pseq([1,1/2,4],inf),
			\distamp, Pseq([
				20,20,20,20,
				10,1,4,1,
				10,10,10,20,
				14,10,4,10,
			],inf),
			\legato, Pseq([
				Pseq([
					1,
				],inf),
				1,1,1,0.71,
				1,1,1,1,
			],inf),
			\trig, 1,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1
		),
	]))
).play;
)

(
	// fast bass
Pdef(\trans1, 
	Ppar([
		PmonoArtic(\bakick,
			\degree, Pseq([
				Pseq([
					-1,-1,-1,-3,
				],6),
				Pseq([
					0,0,0,2,
				],2),
			],inf),
			\fratio, Pseq([1,1/2,4],inf),
			\distamp, Pseq([
				20,20,20,20,
				10,1,4,1,
				10,10,10,20,
				14,10,4,10,
			],inf),
			\legato, Pseq([
				Pseq([
					0.8,0.8,0.8,0.8,
					0.8,0.8,0.8,0.8,
					0.8,0.8,0.8,0.8,
					1,1,0.3,1,
					0.8,0.8,0.8,0.8,
					1,1,0.3,1,
					0.11,1,1,1,
					1,1,0.3,1,
				],inf),
				1,1,1,0.71,
				1,1,1,1,
			],inf),
			\trig, 1,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1
		),
	])
).play;
)


///////////////////// slow motion
~t = 96/2/60; TempoClock.default.tempo = ~t;
(
Pdef(\resamp, 
	// rand part in order
	Pseq([
		Ppar([
			~sampler.(
				Pseq([
					Pseq({[
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					2,2,1,1, 2,2,2,2,
					4,1,4,1, 2,2,4,4,
					].clump(2).choose}.dup(8*4).flat,inf)
				],inf),
				Pbind(
					//\pos, 1/~t+0.04,
					\bufidx, Pseq([
						5,9,
					],inf).stutter(4),
					\legato, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf),
					\dur, Pkey(\dur)*2,
					\legato, 0.7,
					\adsr, Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.1) ],
					],inf),
					\gain, 1.4,
					\speed, 0.8,
					\pos, Pseq((0..15)/16*2/( 96/2/60 ),inf)+0.04,
					\isRest, Pseq([
						1
					],inf).coin.not,
					\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 1,1,1,1,
						],1),
						Pseq({[
							0,0,0,0, 1,1,1,1,
							1,1,1,1, 0,0,0,0,
							1,1,1,1, 1,1,1,1,
							1,1,1,1, 0,1,1,1,
							1,0,1,0, 1,1,0,0,
							1,0,1,1, 0,0,1,0,
							1,1,0,1, 1,0,0,0,
						].clump(8).choose}.dup(8).flat,1)
					],inf).coin.not,
				),
				Pbind(
					\gain, Pkey(\gain) * Pstep(Pseq([
						0.5,0.7,1,0.7,
					],inf),1/8),
				)
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.4,
				\dur, 1/4,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.4,
				\dur, 1/4,
				\amp, 0.1,
			))
		]),
	])
).play;
)

(
Pdef(\resamp, 
	// rand part in order
	Pseq([
		Ppar([
			~sampler.(
				Pseq([
					Pseq({[
					1,1,1,1, 1,1,1,1,
					].clump(2).choose}.dup(8*4).flat,inf)
				],inf),
				Pbind(
					//\pos, 1/~t+0.04,
					\bufidx, Pseq([
						8,
					],inf).stutter(4),
					\legato, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf),
					\dur, Pkey(\dur)/2,
					\legato, 0.9,
					\adsr, Pseq([
						[ Env.adsr(0.001,0.1,0.8,0.2,1,-2) ],
					],inf),
					\gain, 0.8,
					\speed, 1.0,
					\posidx, Pseq([
						0,0,0,0,
						7,3,7,3,
					],inf).stutter(1),
					\pos, Pseq([Pkey(\posidx)]/16*2/( 96/2/60 ),inf)+0.04,
					\isRest, Pseq([
						1
					],inf).coin.not,
					\isRest, Pseq([
						Pseq([
							1,1,0,0,
							1,0,0,1,
							1,0,0,0,
							1,0,1,0,
							1,0,0,0,
							1,1,1,1,
						],1),
					],inf).coin.not,
				),
				Pbind(
				//	\gain, Pkey(\gain) * Pstep(Pseq([
				//		0.5,0.7,1,0.7,
				//	],inf),1/8),
				)
			),
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
			))
		]),
	])
).play;
)
