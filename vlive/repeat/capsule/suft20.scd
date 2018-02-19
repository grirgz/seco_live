
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
			\amp, 0.1,
		),
		Pbind(
			\instrument, \granozor,
			\bufnum, BufDef.mono(\amen),
			\pos, 4,
			\dur, 1/2,
			\amp, 0.1,
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


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Ppar([
			Pbind(
				\instrument, \default,
				\note, Pseq([
					0,2,3,4,
				],inf),
				\dur, 1/4,
				\amp, 0.1,
			),
			// no unlimit, no lowlatency kernel
			// 10: no xrun
			// 14: first xrun
			// 15: 1 xrun/s
			// with ulimit, lowlatency
			// same :(
			14.collect({ arg idx;
				Pbind(
					\instrument, \milsin,
					\freqfac, 1+(idx/4),
					\dur, 1,
					\amp, 0.1/8,
					\out, BusDef(\sendbus3),
				);
				
			})
		].flat),
	])
)).play;
)
