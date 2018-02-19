~t = 60/60; TempoClock.default.tempo = ~t;
(
SynthDef(\simplesin, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\sincrash, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, LFPulse.ar((1..8) * ( SinOsc.ar((1..8)*8075) * 8100 + 100 )) * SinOsc.ar((1..8)*8840).range(10.1,10000)  );
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\madshifter, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = in;
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		2,1,0,-1,
	].midiratio,inf));
	sig = FreqShift.ar(sig, SinOsc.ar(8100 * lfo1)*8400 * lfo1) + sig;
	sig = sig + ( DelayL.ar(( BPF.ar(sig, lfo1.poll * 400, 0.1) * 100 ).tanh/4, 1,0.1 ));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

	(
	Pdef(\part, Pdef(\plop, 
		Ppar([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \default,
					\note, Pseq([
						2,1,0,-1,
					],inf),
					\octave, 5,
					\dur, 1,
					\amp, 0.1,
					\isRest, true,
				),
				Pmono(\playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\dur, Pn(1,8),
					\amp, 0.1,
				).loop,
				//Pbind(
					//\instrument, \snapkickx,
					//\dur, 1/8,
					//\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,1,0, 0,0,0,0,
					//],inf).coin.not,
					//\amp, 0.1,
				//),
				//PatKitDef(\ksh2b).asPattern(Pbind(
					//\kitIndex, 5,
					//\isRest, Pseq([
						//0,0,0,0, 1,0,0,0,
					//],inf).coin.not,
					//\sustain, 0.1,
					//\gain, 0.2,
					//\dur, 1/8,
				//)),
				//Pbind(
					//\instrument, \phyhat3,
					//\isRest, Pseq([
						//1,1,
					//],inf).coin.not,
					//\sustain, 0.05,
					//\fac1,0.1,
					//\dur, 1/8,
					//\amp, 0.01 * Pseq([1,0.7],inf),
				//),
			]),
			Pmono(\madshifter,
				\inbus, BusDef(\sendbus1),
				\mix, 1,
				\dur, 1,
			),
		])
	)).play;
	)
	(
	Pdef(\part, Pdef(\plop, 
		Ppar([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \default,
					\note, Pseq([
						2,1,0,-1,
					],inf),
					\octave, 5,
					\dur, 1,
					\amp, 0.1,
					\isRest, true,
				),
				Pmono(\playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\dur, 1,
					\amp, 0.1,
				),
				//Pbind(
					//\instrument, \snapkickx,
					//\dur, 1/8,
					//\isRest, Pseq([
						//1,0,0,0, 0,0,0,0,
						//1,0,1,0, 0,0,0,0,
					//],inf).coin.not,
					//\amp, 0.1,
				//),
				//PatKitDef(\ksh2b).asPattern(Pbind(
					//\kitIndex, 5,
					//\isRest, Pseq([
						//0,0,0,0, 1,0,0,0,
					//],inf).coin.not,
					//\sustain, 0.1,
					//\gain, 0.2,
					//\dur, 1/8,
				//)),
				//Pbind(
					//\instrument, \phyhat3,
					//\isRest, Pseq([
						//1,1,
					//],inf).coin.not,
					//\sustain, 0.05,
					//\fac1,0.1,
					//\dur, 1/8,
					//\amp, 0.01 * Pseq([1,0.7],inf),
				//),
			]),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\sendbus1, \audio, 2),
				\addAction, \addToTail,
				'wet10', 1.0,
				'mix', 0.15714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0002099467303085,
				'delay', 0.000600001231 * Pseq([
					1,
				],inf).stutter(1),
				'delay2', 0.210000543560101,
				'distamp', 1.361836201538,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1,
				\dur, 1,
				\out, BusDef(\fx1, \audio),
			),
			Pmono(\sincrash,
				\inbus, BusDef(\fx1),
				\mix, 0.2,
				\dur, 1,
			),
		])
	)).play;
	)


//////////////////////////////


// make a cool echo/wind fx

SynthDef(\lfoshifter, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = in;
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		2,1,0,-1,
	].midiratio,inf));
	sig = FreqShift.ar(sig, Pulse.ar(1000 * lfo1)*400 * lfo1) + sig;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pmono(\playersec,
				\bufnum, BufDef('voices/feynman.flac'),
				\dur, Pn(1,8),
				\amp, 0.1,
			).loop,
		]),
		Pmono(\madshifter,
			\inbus, BusDef(\sendbus1),
			\mix, 1,
			\dur, 1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
		]),
		Pmono(\madshifter,
			\inbus, BusDef(\sendbus1),
			\mix, 1,
			\dur, 1,
		),
	])
)).play;
)



///////////////////////////////////////////
//delay freq bands

(
SynthDef(\delayband, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = in;
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		2,1,0,-1,
	].midiratio,inf));
	//sig = FreqShift.ar(sig, SinOsc.ar(8100 * lfo1)*8400 * lfo1) + sig;
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/5).range(1,2)  * 400, 0.3), 1,0.1 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/2).range(1,2)  * 400, 0.3), 1,0.2 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/9).range(1,2)  * 7800, 0.3), 1,0.142 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/19).range(1,2)  * 5800, 0.3), 1,0.342 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/5).range(1,2)  * 400, 0.3), 1,0.1 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/2).range(1,2)  * 400, 0.3), 1,0.2 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/9).range(1,2)  * 7800, 0.3), 1,0.142 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/19).range(1,2)  * 5800, 0.3), 1,0.342 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/5).range(1,2)  * 400, 0.3), 1,0.1 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/2).range(1,2)  * 400, 0.3), 1,0.2 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/9).range(1,2)  * 7800, 0.3), 1,0.142 ));
	//sig = sig + ( DelayL.ar( BPF.ar(sig, SinOsc.ar(1/19).range(1,2)  * 5800, 0.3), 1,0.342 ));
	10.do {
		sig = sig + ( DelayL.ar( BPF.ar(sig, ( SinOsc.ar(1/rrand(1,49.0)).range(1,2)  * exprand(10.0,15800) ).clip(20,19000), 0.8 * SinOsc.kr(rrand(1.0,1/100)).range(0.1,1)), 1,exprand(0.0001,1) ));
	};
	//sig = sig * 0.5;
	//sig = sig.tanh;
	//sig = sig *2;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

	(
	Pdef(\part, Pdef(\plop, 
		Ppar([
			Pbind(\out, BusDef(\sendbus1, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \iron,
					\note, Pseq([
						2,1,0,-1,
					],inf),
					\diff, 0.01,
					\fmr, 1/8,
					\lpfr, 0.4,
					\octave, 9,
					\dur, 1,
					\amp, 0.1,
				),
				Pmono(\playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\dur, Pn(1,8),
					\pos, 9,
					\gain, 1/5,
				).loop,
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
				PatKitDef(\ksh2b).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\gain, 0.2,
					\dur, 1/8,
				)),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\sustain, 0.05,
					\fac1,0.1,
					\dur, 1/8,
					\amp, 0.01 * Pseq([1,0.7],inf),
				),
			]),
			Pmono(\delayband,
				\inbus, BusDef(\sendbus1),
				\mix, 1,
				\dur, 1,
			),
		])
	)).play;
	)
