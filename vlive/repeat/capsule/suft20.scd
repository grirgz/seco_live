
// new power!!!

(
SynthDef(\granozor, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var clk = Impulse.ar(240);
	var pos = SinOsc.ar(0.1 * (1..18)/10).range(0,0.03) + \pos.kr(0);
	var dur = SinOsc.kr((1..18)/72).range(0,0.1);
	sig = TGrains.ar(2, clk, \bufnum.kr(0), \pitch_stretch.kr(1), pos % BufDur.kr(\bufnum.kr), dur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 2;
	//sig = GVerb.ar(sig, 2);
	//sig = LPF.ar(sig, 400);
	sig = Pan2.ar(sig, pan, amp).mean * 1;
	Out.ar(out, sig);
}).add;
);
BufDef(\amen).play
BufDef.mono(\amen).play
(
Pdef(\part, Pdef(\power, 
	Ppar([
		Pbind(
			\instrument, \granozor,
			\bufnum, BufDef.mono(\amen),
			\pos, 0.7,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \granozor,
			\bufnum, BufDef.mono(\amen),
			\pos, 2,
			\dur, 1/8,
			\amp, Pseq([
				0.1
			],inf).mutezero,
		),
		Pbind(
			\instrument, \granozor,
			\bufnum, BufDef.mono(\amen),
			\pos, 4,
			\dur, 1/2,
			\amp, Pmute(Pseq([
				0.1,
			],inf)),
		),
		
	])
)).play;
)


////////////////////////////

(
SynthDef(\milsin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(( \freqfac.kr(1) * exprand(50!200,15000) ).clip(20,20000)).mean * 5 * 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\verby, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0],sig[1], 1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);


////////////////////////////////


(
SynthDef(\audioin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SoundIn.ar([0,1], 2); 
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Synth(\audioin, [\out, BusDef(\sendbus1)])

Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
);

ProtoDef(\rdn).edit

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\audioin,
			\inbus, BusDef(\sendbus1),
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'wet10', 1.0,
			'mix', 0.15714285714286,
			'gain', 0.9344889782792,
			\mix, 0,
			'gain', 1.9344889782792,
			'fb', 0.000099467303085,
			'delay', 0.00000600001231 * Pseq([
				1,199,1000,
			],inf).stutter(1),
			'delay2', 0.30000210000543560101,
			'distamp', 8.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 34.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/2,
			\isRest, true,
		),
		
	])
)).play;
)
