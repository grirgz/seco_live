
// lucas y monica

~t = 132/4/60; TempoClock.default.tempo = ~t;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[825].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1812].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[222].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.2,0.3,0.4,
				0.5,0.2,0.7,0.4,
				0.1,0.1,0.9,0.1,
				
			],inf),
		),	
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,
			],inf).stutter(4),
			\ctranspose, 2,
			\fmffac, 100,
			\freqfac, Pseq([[1,2],[1/2,4]],inf),
			\octave, 3,
			\fdelta, 1,
			\pos, 0.2,
			\pos, ~pmodenv.(Pseq([0.1,0.14,0.6],1), 1).loop,
			\pan, Pseq([[-1,1],[1,-1]],inf),
			//\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			//\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,4.1,0.4,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/8,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				16,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\gain, 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				(0..4).mirror1
			].flat,inf),
			\note, Pseq([
				//Pfin(8,Pseq([-3, 2, 5, 9, 14, 17].mirror1)),
				Pfin(8,Pseq([2, 5, 9, 14].mirror)),
				//Pseq([-3, 2, 5, 9, 14].mirror),
			].flat,inf),
			//\ctranspose, 2,
			//\scale, Scale.choose.postln,
			\octave, 6,
			\dur, 1/8/4,
			\amp, 0.1 * Pseq([
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.5,0.1, 0.9,0.1,
				0.9,0.1, 0.5,0.1,
			].rotate(1),inf).collect({ arg x; rrand(0.01, x) }),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\room, 1,
			\mix, 1,
			\verbmix, 0.5,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	Pbind(
		\instrument, \metalcut,
		\freq, 800,
		\legato, 8,
		\isRest, Pseq([
			1,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 0,0, 0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
	),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpmix, 1,
			\hpf, 2000,
			\bufnum, ~buflib.snare[757].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\dur, 1/8,
			\gain, 2.71,
			\out, BusDef(\eifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\eifx1, \audio),
			\out, BusDef(\eifx2, \audio),
			\room, 4,
			\damp, 0.4,
			\mix, 1,
			\verbmix, 0.7,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_chorus,
			\fb, 0.90000000596046,
			\maxdelay, 0.20000000298023,
			\delay, 0.020099999606609,
			\diff, 0.40009999275208,
			\modfreq, 0.21000003814697,
			\modamp, 0.47999998927116,
			\lpf, 19000.0,
			\hpf, 50.0,
			\mix, 0.5,
			\inbus, BusDef(\eifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0018,
			\gain, 0.51,
			\dur, 1,
		),
		
	])
)).play;
);

ProtoDef(\piano).startControl()


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq([
				(0..8).mirror1
			].flat,1),
			\dur, 1/8/2,
			\amp, 0.1,
		),
		
	])
)).play;
);



(
SynthDef(\metalcut, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	env1 = EnvGen.kr(Env([1/8,1/2,1/10],[0.1,0.9]*4,[ 1,-1 ]), 1).round(0.1);
	env2 = EnvGen.kr(Env([100,200,100,302],[0.1,0.9,1]*4), 1).round(0.1);
	env3 = EnvGen.kr(Env([100,1,100.1],[0.1,0.9]*4), 1).round(0.1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * env3) * env2 + 1 ));

	//sig = CombL.ar(sig, 4/~t,0.01,1.1) + sig;
	sig = AllpassL.ar(sig, 4/~t,0.1,1.1) + sig;
	sig = FreeVerb.ar(sig,1,2);

	env4 = EnvGen.kr(Env([80,1000,15000],[0.1,0.5,1.9]*4), 1).round(0.1);
	sig = HPF.ar(sig, env4);

	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,3.01),gate,doneAction:2);
	//sig = sig * EnvGen.kr(Env([0,1,0],[1.0,0.08], [4,-1]), 1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
(
Pdef(\demo, 
	Pbind(
		\instrument, \metalcut,
		\freq, 800,
		\legato, 4,
		\isRest, Pseq([
			1,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 0,0, 0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)


(
	Pdef(\part, Pdef(\longsnare, 

	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\hpmix, 1,
			\hpf, 2000,
			\bufnum, ~buflib.snare[757].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\dur, 1/8,
			\gain, 2.71,
			\out, BusDef(\eifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\eifx1, \audio),
			\out, BusDef(\eifx2, \audio),
			\room, 4,
			\damp, 0.2,
			\mix, 1,
			\verbmix, 0.7,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_chorus,
			\fb, 0.90000000596046,
			\maxdelay, 0.20000000298023,
			\delay, 0.020099999606609,
			\diff, 0.40009999275208,
			\modfreq, 0.21000003814697,
			\modamp, 0.47999998927116,
			\lpf, 19000.0,
			\hpf, 50.0,
			\mix, 0.5,
			\inbus, BusDef(\eifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0018,
			\gain, 1,
			\dur, 1,
		),
		
	])
	)).play;
);
