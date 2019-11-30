(
~t = 135/2/60; TempoClock.default.tempo = ~t;
)
(
SynthDef(\sereno, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * \ratio.kr([0,4,7].midiratio) * [1/2,1,2];
	sig1 = SinOsc.kr((1..9)/10).range(0,1);
	sig2 = SinOsc.kr((1..9)/20).range(0,1);
	sig = LFSaw.ar(freq) * SinOsc.ar(freq+sig2, SinOsc.ar(freq+2+sig1), 1, SinOsc.ar(freq+2+sig2) );
	pan = LFNoise1.kr((1..9)/75).range(-1,1);

	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/7/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo3 = TDuty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf));
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), lfo3);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = LFSaw.ar(freq * (lfo1 * 0.03 + 1) * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1 + LFSaw.ar(freq * (lfo2 * 0.03 + 1) * \ratio.kr) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig = SelectX.ar(\fiomix.kr(0.5), [sig, sig1]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\transi, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/transistor.flac'),
			\dur, 1,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		Pmono(\rdnfx_egg,
			\inbus, BusDef(\sendbus1, \audio),
			\dur, 1,
			'wet10', 1.0,
			'mix', 0.40207408153589,
			'gain', 0.45378151260504,
			'fb', 0.0001,
			'delay', ~pmodenv.(Pseq([1,14,1,300]*0.0001,inf), 8),
			'delay2', ~pmodenv.(Pseq([1,1,1,104]*0.0001,inf), 2),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 00.4834289824407,
			'pitchlag', 1.0,
			'pitchmix', 1.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 317,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
			\out, BusDef(\rev, \audio),
		),
		Pmono(\fx_reverb,
			\inbus, BusDef(\rev, \audio),
			\lpf, 19000,
			\lpmix, 0.5,
			\decay, 3,
			\delayfac, 1,
			\mix, Pseg(Pseq([0,0.1,0.2,1],inf),8),
			\gain, 1,
			\out, BusDef(\comp, \audio),
			\dur, 1,
		),
		Pmono(\simplecomp,
			\inbus, BusDef(\comp, \audio),
			\cpt, 0.01,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 2,
			\dur, 1,
		),
		
	])
));
);

(
Pdef(\part, Pdef(\deltransi, 
	Ppar([
		Psched([0,4],
			Ppar([
				Pmono(
					 \playersec,
					\bufnum, BufDef('voices/transistor.flac'),
					\dur, 1,
					\speed, ~pmodenv.(Pseq([1,0.2,1.4,1.50],inf), 1),
					\gain, 0.1,
					\out, BusDef(\bus1, \audio),
				),
				Pmono(\fx_reverb,
					\inbus, BusDef(\bus1),
					\lpf, 16000,
					\lpmix, 0.5,
					\decay, 0.3,
					\delayfac, ~pmodenv.(Pseq([1,0,0],inf), 5),
					\mix, 1,
					\gain, 1,
					\dur, 1,
				),
		
			])
		),
		Psched(4,Pdef(\transi))
	],1),
));
);

(
Pdef(\part, Pdef(\sereno, 
	Ppar([
		Pbind(\out, BusDef(\rev1, \audio)) <>
		Ppar([
			Pmono(
				 \sereno,
				\note, Pseq([
					0,4,
				],inf),
				\ratio, Pseq([
					[[0,4,7]],
					[[0,3,7]],
					[[12,4-12,7]],
				],inf).stutter(2).midiratio,
				\dur, 4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \sereno,
				\octave, 4,
				\note, Pseq([
					0,2,3,5, 4,4,3,2,
				],inf),
				\ratio, Pseq([
					[[0,12,-12]],
					[[-12,12,-12]],
					[[0,3,7]],
					[[-12,0,-12]],
					[[0,3-12,7-12]],
				],inf).midiratio,
				\dur, 1,
				\legato, Pseg(Pseq([0.1,1,1],inf),8),
				\lag, Pseg(Pseq([0,0.1],inf),7),
				\amp, 0.1,
			),
		]),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\rev1),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, 0.61,
			\gain, 2,
			\dur, 2,
		),
		
	])
));
);

~master.();
Pdef(\deltransi).play;
Pdef(\sereno).play;
Pdef(\sereno).stop; Pdef(\sereno2).play;
Pdef(\sereno2).play;
Pdef(\transi).stop;
Pdef(\sereno).stop;


Pdef(\sereno2).clear;
Pdef(\rdnfxperd).clear;

Pdef(\part).clear;
(
Pdef(\part, Pdef(\sereno2, 
	Ppar([
		Pbind(\out, BusDef(\rev1, \audio)) <>
		Ppar([
			Pmono(
				 \sereno,
				\note, Pstep(Pseq([
					0,7,
				],inf), 4),
				\ratio, Pseq([
					[[0,4,7]],
					[[0,3,7]],
					[[12,4-12,7]],
				],inf).stutter(2).midiratio,
				\dur, 1/4,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \sereno,
				\octave, 4,
				\note, Pseq([
					0,2,3,5, 4,4,3,2,
				],inf),
				\ratio, Pseq([
					[[0,12,-12]],
					[[-12,12,-12]],
					[[0,3,7]],
					[[-12,0,-12]],
					[[0,3-12,7-12]],
				],inf).midiratio,
				\dur, 1,
				\legato, Pseg(Pseq([0.1,1,1],inf),8),
				\lag, Pseg(Pseq([0,0.1],inf),7),
				\amp, 0.1,
			),
		]),
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\rev1),
			\verbmix, 0.4,
			\room, 0.5,
			\damp, 0.7,
			\mix, 0.61,
			\gain, 1,
			\dur, 2,
			\out, BusDef(\rev2, \audio),
		),
		Pmono(\rdnfxperd,
			\addAction, \addToTail,
			\lag, 0.0006,
			\inbus, BusDef(\rev2, \audio),
			\dur, 1,
		) <>
		Pbindef(\rdnfxperd, 

			'wet10', 1.0,
			'mix', ~pmodenv.(Pseq([0,1,1,1],inf), 8),
			'gain', 1.2386554621849,
			'fb',0.0001,
			'delay', 0.7,
			'delay', 0.0005,
			'delay2', ~pmodenv.(Pseq([0.5,0.5,0.2],inf), 4),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 25.560128050528,
			'pitchlag', 1.0,
			'pitchmix', 0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.16579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),

		
	])
));
);



(
Pbindef(\rdnfxperd,
	//\delay2, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
	\distamp, 100,
	\fb, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),

)
)
