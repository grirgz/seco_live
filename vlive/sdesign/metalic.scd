
(
SynthDef(\metalic, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1,1],[0.01,0.8]), 1);
	sig = SinOsc.ar(freq * env1* ( SinOsc.ar( \fmf.kr(1723) * [1,2,3,4] * env1 ) * 1 + 1 ));
	sig = HPF.ar(sig, 100);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.5)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \metalic,
			\note, Pseq([
				0,7,-6,15,
			],inf),
			\freq, Pseq([
				1230,1445,2344,355
			],inf),
			\fmf, Pseq([
				1123,809, 449,
			],inf).stutter(3),
			\sustain, 0.071,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
)

///////////////

(
SynthDef(\metperc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4,1,1],[0.01,0.1]), 1);
	env2 = EnvGen.kr(Env([1,2,2],[0.01,1.8]), 1);
	env3 = EnvGen.kr(Env([0.1,2,1],[0.1,0.8]), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.02,0.58], [1,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,0],[0.001,0.2]), 1);
	sig = LFPulse.ar(freq * [1,1.123,1.543] * env1);
	sig = ( sig*env5 ) + BPF.ar(WhiteNoise.ar, freq * 8 * env2, 0.1, mul:env4);
	sig = HPF.ar(sig, 2000 * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,1.4)), gate, doneAction:2);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\demo, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \metperc,
			\freq, 1000,
			\dur, 1/16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
)


//////////////// fx to sustain the sound

(
SynthDef(\metpercsus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4,1,1],[0.01,4.1]), 1);
	env2 = EnvGen.kr(Env([1,2,4],[0.01,1.8],-2), 1);
	env3 = EnvGen.kr(Env([0.1,2,1],[0.1,4.8]), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.02,2.58], [1,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,0],[0.001,2.2]), 1);
	sig = LFPulse.ar(freq * [1,1.123,1.543] * env1);
	sig = ( sig*env5 ) + BPF.ar(WhiteNoise.ar, freq * 8 * env2, 0.1, mul:env4);
	sig = HPF.ar(sig, 2000 * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,4.4)), gate, doneAction:2);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\demo, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \metpercsus,
			\freq, 1000,
			\dur, 1/16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
SynthDef(\metpercfx, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0.4,1,2],[0.21,4.1]), 1);
	env2 = EnvGen.kr(Env([1,1/2,1/7],[0.01,2.8],-1), 1);
	env3 = EnvGen.kr(Env([0.1,2,1],[0.1,0.8]), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.02,0.58], [1,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,0],[0.001,0.2]), 1);
	sig = LFPulse.ar(freq * [1,1.123,1.543] * env1);
	sig = ( sig*env5 );
	sig = sig + BPF.ar(WhiteNoise.ar, freq * 8 * env2, 0.1, mul:env4);
	sig = HPF.ar(sig, 2000 * env1);


	in = sig;
	sig = LocalIn.ar(2) * \fb.kr(0.8);
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3));
	};
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4)), gate, doneAction:2);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \metpercfx,
			\freq, 800 * Pseq([
				1,150/154
			],inf).stutter(2),
			\dur, 1/16,
			\fb, 0.1,
			\mix, Pseq([
				0.6,1,
			],inf),
			\legato, Pseq([
				1,0,1,0, 4,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,3,0,0,
				1,0,2,0, 1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
		),
		
	])
)).play;
)



SynthDef(\fx_reverbenv, { arg out=0, amp=0.1, gate=1, decaylag=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env.kr(Env([0,0,1.5,1,0],[0.01,0.1,1.8,0.1])), \envtrig.tr(1));
	sig = LocalIn.ar(2) * \fb.kr(0.1) * env1;
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3).lag(decaylag) * env1);
	};
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \metperc,
			\freq, 200,
			\dur, 1/16,
			\isRest, Pseq([
				1,0,1,0, 4,0,0,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 4,0,0,0,
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 4,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 4,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_reverbenv,
			\inbus, BusDef(\sendbus1),
			\env, Pseq([
				[ Env([0,0,0.5,1,0],[0.01,0.01,4/16/~t,0.01]) ]
			],inf),
			\gain, 4,
			\envtrig, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\mix, 0.51,
			\dur, 1/16,
		),
	])
)).play;
)

(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \metperc,
			\freq, 200,
			\dur, 1/16,
			\isRest, Pseq([
				1,0,1,0, 4,0,0,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 4,0,0,0,
				0,0,0,0, 1,0,1,0,
				1,0,0,0, 4,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 4,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1/6,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,0,
				1,0,0,
				1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/8,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono(\fx_reverbenv,
			\inbus, BusDef(\sendbus1),
			\addAction, \addToTail,
			\lag, 0.0005,
			\env, Pseq([
				[ Env([0,0,0.5,1,0],[0.01,0.01,4/16/~t,0.01]) ]
			],inf),
			\gain, 4,
			\delayfac, Pseq([
				1/4,1/4,2,2,1,1,0.1,0.1,0,
			],inf).stutter(4),
			\envtrig, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf),
			\mix, 0.51,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\simplecomp,
			\addAction, \addToTail,
			\lag, 0.0006,
			\inbus, BusDef(\sendbus2, \audio),
			\cpt, 0.31,
			\cpabove, 0.02,
			\cpbelow, 1.2,
			\freq, 200,
			\dur, 1,
			\gain, 1/2,
		),
	])
)).play;
)
