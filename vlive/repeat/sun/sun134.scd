(
~t = 195/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

(
SynthDef(\fmline, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	env1 = EnvGen.kr(Env([1,41,2],[1.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([1,2,1400],[0.1,1.8],1), 1);
	mod2 = SinOsc.ar(freq) * 10 * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 10 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2] + mod2, mul:0.2) * 0.4; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\scratchercq, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = LFTri.ar(\sfreq.kr(1)).lag(0.1) * \samp.kr(1)/\sfreq.kr.sqrt + \pos.kr(1) * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fmline5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	freq = freq * SinOsc.ar(1,mul:0.001,add:1);
	env1 = EnvGen.kr(Env([\fac1.kr(100),141,2],[5.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([1,12,1000],[4.1,9.8],[1,2]), 1);
	mod2 = SinOsc.ar(freq) * \fma2.kr(1) * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 1 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2] + mod2, mul:0.3).mean * 0.4; 
	sig = BRF.ar(sig, freq * ( SinOsc.kr(0.9) * 0.2 + 1 ));
	sig = HPF.ar(sig, EnvGen.kr(Env([5000,500,100],[1.1,7.8],\exp), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1,1,1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \fmline,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \fmline,
			\note, Pseq([
				[5,8,12],
				[7,10,12],
			],inf).stutter(16),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\note, Pdemand.not(Pseq([
				17,15,13,12,
			],inf), 13, \isRest),
			\octave, 5,
			\legato, 0.8,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmline,
			\note, Pseq([
				[5,8,12],
				[7,10,12],
			],inf).stutter(16),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\note, Pdemand.not(Pseq([
				17,15,13,12,
			],inf), 13, \isRest),
			\octave, 5,
			\legato, 0.8,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],4),
				1,1,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,1,0,0, 1,1,0,0,
				1,1,0,0, 1,1,0,0,
			],inf).coin.not,
			\note, Pdemand.not(Pseq([
				17,15,13,12,
			],inf).stutter(2), 1, \isRest),
			\octave, 5,
			\lpf, 100,
			\envamt, PmodEnv(Pseq([7,17],1), 32).loop,
			\legato, 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\amp, 0.05,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7
			],inf).stutter(16),
			\lpf, PmodEnv(Pseq([1000,2000,5000],1), 16,\exp).loop,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.8) ],
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1/2,
				8,0,0,0, 0,0,0,0,
				0,0,1/2,0, 0,1/2,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bass, \audio),
		),
		Pmono(\fx_resonz,
			\freq, 80.0,
			\bwr, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);


(

SynthDef(\rdn_softdist, { arg out=0, gate=1;
	// code: 5-MD4-14G0
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 37376.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.86554621848739,
	'gain', 0.28571428571429,
	'fb', 0.0035086914797844,
	'delay', 0.18936988889504,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.3463059962866,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 110.84790122088,
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
)

		
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmline,
			\note, Pseq([
				[5,8,12],
				[7,10,12],
			],inf).stutter(16),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\note, Pdemand.not(Pseq([
				17,15,13,12,
			],inf), 13, \isRest),
			\octave, 5,
			\legato, 0.8,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],4),
				1,1,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,1,0,0, 1,1,0,0,
				1,1,0,0, 1,1,0,0,
			],inf).coin.not,
			\note, Pdemand.not(Pseq([
				17,15,13,12,
			],inf).stutter(2), 1, \isRest),
			\octave, 5,
			\lpf, 100,
			\envamt, PmodEnv(Pseq([7,17],1), 32).loop,
			\legato, 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\dur, 1/8,
			\amp, 0.05,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\rdn_softdist,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.16554621848739,
			'gain', 0.88571428571429,
			'fb', 0.00035086914797844,
			'delay', 0.1018936988889504,
			\delay, PmodEnv(Pseq([0.0001,0.001,0.002],1), 16,\exp).loop,
			'delay2', 0.0001,
			'shift', 0.0,
			'shift2', 0.1,
			'distamp', 17.3463059962866,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 1100.84790122088,
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
			\out, BusDef(\stut3, \audio),
		),
		
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut3, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7
			],inf).stutter(16),
			\lpf, PmodEnv(Pseq([1000,2000,5000],1), 16,\exp).loop,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.8) ],
				[ Env.adsr(0.01,0.1,0.8,0.8) ],
			],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1/2,
				8,0,0,0, 0,0,0,0,
				0,0,1/2,0, 0,1/2,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1/2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bass, \audio),
		),
		Pmono(\fx_resonz,
			\freq, 80.0,
			\bwr, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\fmline3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	env1 = EnvGen.kr(Env([1,141,2],[1.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([1,2,1400],[0.1,1.8],1), 1);
	mod2 = SinOsc.ar(freq) * 10 * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 10 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2] + mod2, mul:0.2) * 0.4; 
	sig = HPF.ar(sig, EnvGen.kr(Env([5000,100,1],[1.1,2.8],\exp), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fmline3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	freq = freq * SinOsc.ar(1,mul:0.001,add:1);
	env1 = EnvGen.kr(Env([\fac1.kr(100),141,2],[5.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([1,12,1400],[4.1,3.8],1), 1);
	mod2 = SinOsc.ar(freq) * \fma2.kr(1) * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 1 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2] + mod2, mul:0.3).mean * 0.4; 
	sig = BRF.ar(sig, freq * ( SinOsc.kr(0.9) * 0.2 + 1 ));
	sig = HPF.ar(sig, EnvGen.kr(Env([5000,100,1],[1.1,2.8],\exp), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1,1,1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \fmline3,
			\note, Pseq([
				[7-12,3+12,0,10],
			],inf),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseg(Pseq([0,1000,400],inf),8*8),
			\fac1, Pseq([0,1000,400],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fmfx, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmfx, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\fmline4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	freq = freq * SinOsc.ar(1,mul:0.001,add:1);
	env1 = EnvGen.kr(Env([\fac1.kr(100),141,2],[5.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([1,12,1000],[4.1,9.8],[1,2]), 1);
	mod2 = SinOsc.ar(freq) * \fma2.kr(1) * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 1 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2] + mod2, mul:0.3).mean * 0.4; 
	sig = BRF.ar(sig, freq * ( SinOsc.kr(0.9) * 0.2 + 1 ));
	sig = HPF.ar(sig, EnvGen.kr(Env([5000,500,100],[1.1,7.8],\exp), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1,1,1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \fmline4,
			\note, Pseq([
				[7-12,3+12,0,10],
			],inf),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([0,1000,400],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, 100,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fmfx, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmfx, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \fmline5,
			\note, Pseq([
				[7-12,3+12,0,10],
				[7-12,3+12,0,11],
				[7-12,3+12,0,10],
				[7-12,2+12,-1,11],
			],inf).stutter(8*4),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([10],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, PmodEnv(Pseq([1,700],1), 8*8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fmfx, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmfx, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

/////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1811].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8/2,
			\gain, 0.07,
			\g2, Pseg(Pseq([0,0.7],inf),32),
			\gain, 0.05 * Pseq([1,Pkey(\g2).keep(1)],inf) * Pseg(Pseq([0,1,1],1),16).loop,
		),
		
		Pbind(
			\instrument, \fmline5,
			\note, Pseq([
				[7-12,3+12,0,10],
				[7-12,3+12,0,11],
				[7-12,3+12,0,10],
				[7-12,2+12,-1,11],
			],inf).stutter(8*4),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([10],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, PmodEnv(Pseq([1,700],1), 8*8).loop,
			\octave, Pseq([
				5,6
			],inf).stutter(8*4*4),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fmfx, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmfx, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1811].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8/2,
			\gain, 0.07,
			\g2, Pseg(Pseq([0,0.7],inf),32),
			\gain, 0.05 * Pseq([1,Pkey(\g2).keep(1)],inf) * Pseg(Pseq([0,1,1],1),16).loop,
		),
		
		Pbind(
			\instrument, \fmline5,
			\note, Pseq([
				[7-12,3+12,0,10],
				[7-12,3+12,0,11],
				[7-12,3+12,0,10],
				[7-12,2+12,-1,11],
			],inf).stutter(8*4),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([10],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, PmodEnv(Pseq([1,700],1), 8*8).loop,
			\octave, Pseq([
				5,6
			],inf).stutter(8*4*4),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fmfx, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fmfx, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef(\metal, "vipere/metal.flac"),
			\sfreq, 1*~t * Pseq([
				1,1,1,2,
				1,1,2,1,
				1,1,1,1,
				2,1,2,1,
			],inf).stutter(1),
			\legato, Pseq([
				1,1,1,1, 1/2,1/2,1,1,
				1,1,2,0, 3,0,0,1,
				2,0,1,2, 0,1,2,0,
				1,1,2,0, 2,0,1,1,
			],inf) * 0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.37 * Pseq([
				0,0,0,0, 8,0,0,0,
				0,0,10,0, 0,0,0,10,
			],inf).midiratio * Pseg(Pseq([1,2],1),32).loop,
			\pos, 2.57 + Pseq([
				Pseg(Pseq([0,0.4],1),2),
				Pseg(Pseq([0,0.04],1),2),
			],inf),
			\pos, 2.77 + Pseq([0,0.1,0.01,0.05],inf),
			\pos, 0.71 + Pseg(Pseq([0,0.4],1),1).loop,
			\pos, 0.11,

			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10000,420,1000,40,2000],1), 8, \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),

	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,-1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
			],inf) /8/ Pkey(\st),
			\dur, 1/8/2,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				(0..7)
			].flat,inf) + Pseq([
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				1,-1,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,2, 0,2,2,-2,
				0,0,0,0, 0,0,1,0,
			]/2,inf) /4/ Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseg(Pseq([-1,1,0.3,0,-0.3],inf),1),
			\pan, Pseq([-1,1,0.3,0,-0.3],inf),
			\out, BusDef(\druma, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\druma, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\druma2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\druma2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2400,9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([1310,12000,2000,],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseq([0,0,-1,1,0.3,0,-0.3],inf) * Pseg(Pseq([0.02,1],inf),8),
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,0, 0,0,0,-5,
				],8),
				Pser([
					-1,-1,-1,-1, -1,-1,-1,5,
				],8),
				Pser([
					3,3,3,3, 3,3,3,-5,
				],8),
				Pser([
					-1,-1,-1,-1, 2,2,2,3,
				],8),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, 100 * Pseg(Pseq([1,4],1),32),
			\envamt, 5,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.07,
		),
		Pbind(
			\instrument, \fmline5,
			\note, Pseq([
				[7-12,3+12,0,10],
				[7-12,3+12,0,11],
				[7-12,3+12,0,10],
				[7-12,2+12,-1,11],
			],inf).stutter(8*4),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([10],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, PmodEnv(Pseq([1,700],1), 8*8).loop,
			\octave, Pseq([
				5,6
			],inf).stutter(8*4*4),
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				(0..7)
			].flat,inf) + Pseq([
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				1,-1,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,2, 0,2,2,-2,
				0,0,0,0, 0,0,1,0,
			]/2,inf) /4/ Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseg(Pseq([-1,1,0.3,0,-0.3],inf),1),
			\pan, Pseq([-1,1,0.3,0,-0.3],inf),
			\out, BusDef(\druma, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\druma, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\druma2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\druma2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2400,9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([1310,12000,2000,],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseq([0,0,-1,1,0.3,0,-0.3],inf) * Pseg(Pseq([0.02,1],inf),8),
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,0, 0,0,0,-2,
				],8),
				Pser([
					-1,-1,-1,-1, -1,-1,-1,7,
				],8),
				Pser([
					-2,-2,-2,-2, -2,-2,-2,10,
				],8),
				Pser([
					-1,-1,-1,7, 2,2,2,3,
				],8),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, 100 * Pseg(Pseq([1,4],1),32),
			\envamt, 5,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.07,
		),
		Pbind(
			\instrument, \fmline5,
			\note, Pseq([
				[7-12,3+12,0,10],
				[7-12,3+12,0,11],
				[7-12,3+12,0,10],
				[7-12,2+12,-1,11],
			],inf).stutter(8*4),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([10],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, PmodEnv(Pseq([1,700],1), 8*8).loop,
			\octave, Pseq([
				5,6
			],inf).stutter(8*4*4),
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				(0..7)
			].flat,inf) + Pseq([
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				1,-1,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,2, 0,2,2,-2,
				0,0,0,0, 0,0,1,0,
			]/2,inf) /4/ Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseg(Pseq([-1,1,0.3,0,-0.3],inf),1),
			\pan, Pseq([-1,1,0.3,0,-0.3],inf),
			\out, BusDef(\druma, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\druma, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\druma2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\druma2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2400,9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([1310,12000,2000,],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseq([0,0,-1,1,0.3,0,-0.3],inf) * Pseg(Pseq([0.02,1],inf),8),
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,0, 0,0,0,-2,
				],8),
				Pser([
					-1,-1,-1,-1, -1,-1,-1,7,
				],8),
				Pser([
					-2,-2,-2,-2, -2,-2,-2,10,
				],8),
				Pser([
					-1,-1,-1,7, 2,2,2,3,
				],8),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				2,0,1,2, 0,0,2,0,
				2,0,2,0, 1,1,2,0,
				2,0,0,2, 0,0,2,0,
				1,1,2,0, 2,0,2,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, 300 * Pseg(Pseq([1,4],1),32),
			\envamt, 5,
			\lpadsr, Pseq([
				[ Env.adsr(0.03,0.1,0.2,0.1) ],
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
				[ Env.adsr(0.3,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.07,
		),
		Pbind(
			\instrument, \fmline5,
			\note, Pseq([
				[7-12,3+12,0,10],
				[7-12,3+12,0,11],
				[7-12,3+12,0,10],
				[7-12,2+12,-1,11],
			],inf).stutter(8*4),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([10],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, PmodEnv(Pseq([1,700],1), 8*8).loop,
			\octave, Pseq([
				5,6
			],inf).stutter(8*4*4),
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				(0..7)
			].flat,inf) + Pseq([
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				1,-1,0,0, 0,0,1,0,
				0,0,0,-1, 0,1,1,-1,
				0,0,0,0, 0,0,1,0,
				0,0,0,2, 0,2,2,-2,
				0,0,0,0, 0,0,1,0,
			]/2,inf) /4/ Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseg(Pseq([-1,1,0.3,0,-0.3],inf),1),
			\pan, Pseq([-1,1,0.3,0,-0.3],inf),
			\out, BusDef(\druma, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\druma, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\druma2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\druma2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([2400,9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([1310,12000,2000,],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind(
			\instrument, \playerbalancesec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\pan, Pseq([0,0,-1,1,0.3,0,-0.3],inf) * Pseg(Pseq([0.02,1],inf),8),
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([9000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Pbind(
			\instrument, \scratchercq,
			\bufnum, BufDef(\kaspi, "voices/kaspi.flac"),
			\sfreq, 1*~t * Pseq([
				1,1,1,1,
				1,1,1,2,
				1,1,1,1,
				1,1,1,4,
			],inf).stutter(4),
			\legato, Pseq([
				6,0,0,0, 0,0,4,0,
				0,0,0,0, 2,0,0,0,
				4,0,0,0, 2,0, 2,0,
				1,1, 2,0, 2,0, 0,1,

				6,0,0,0, 2,0,2,0,
				0,0,0,0, 4,0,0,0,
				2,0,0,1, 2,0, 2,0,
				1,1, 2,0, 2,0, 0,1,
			],inf) * 0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\samp, 0.26 * Pseq([
				0,
			],inf).midiratio,
			\pos, 0.25,

			\dur, 1/8/2,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[784].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07 * Pseq([1,0.7,0.9,0.65],inf),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10000,420,1000,40,2000],1), 8, \exp).loop,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
		),
	])
)).play;
);

///////// find bass


(
Pdef(\part, Pdef(\base1, 
	Ppar([
		Pbind(
			\instrument, \fmline,
			\note, Pseq([
				[5,8,12],
				[7,10,12],
			],inf).stutter(16),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_resonz,
			\freq, 80.0,
			\bwr, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\base2, 
	Ppar([
		Pbind(
			\instrument, \fmline5,
			\note, Pseq([
				[7-12,3+12,0,10],
				[7-12,3+12,0,11],
				[7-12,3+12,0,10],
				[7-12,2+12,-1,11],
			],inf).stutter(8*4),
			\legato, Pseq([
				24,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\fac1, Pseq([10],inf).stutter(8*4),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma2, PmodEnv(Pseq([1,700],1), 8*8).loop,
			\octave, Pseq([
				5,6
			],inf).stutter(8*4*4),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				2,2,2,-4, 0,0,0,0,
			].flat,inf).midiratio,
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf),
			\rate, 1,
			\time, Pstep(Pseq([1/4,1/8,1/4],inf),1/4)/~t,
			\time, 1/16/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
			\out, BusDef(\stut2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\stut2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,2],1), 16,\exp).loop,
			\lpf, PmodEnv(Pseq([2000,12000],1), 16,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_resonz,
			\freq, 80.0,
			\bwr, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\base1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7
			],inf).stutter(16) + Pseq([
				0,0,3,0, 3,7,0,0,
				0,0,-5,0, 0,3,0,0,
				0,0,3,0, 0,3,0,-1,
				0,0,-5,0, 0,3,0,0,
				//0,0,-2,-1, 0,3,0,0,
			],inf),
			\lpf, PmodEnv(Pseq([100,200,500],1), 16,\exp).loop,
			\envamt, PmodEnv(Pseq([5,8],1), 32).loop,
			\rq, PmodEnv(Pseq([0.5,0.3],1), 32).loop,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.8
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\bass, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\base2),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,0, 0,0,0,-2,
				],8),
				Pser([
					-1,-1,-1,-1, -1,-1,-1,7,
				],8),
				Pser([
					-2,-2,-2,-2, -2,-2,-2,10,
				],8),
				Pser([
					-1,-1,-1,7, 2,2,2,3,
				],8),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				2,0,1,2, 0,0,2,0,
				2,0,2,0, 1,1,2,0,
				2,0,0,2, 0,0,2,0,
				1,1,2,0, 2,0,2,0,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, 300 * Pseg(Pseq([1,4],1),32),
			\envamt, 5,
			\lpadsr, Pseq([
				[ Env.adsr(0.03,0.1,0.2,0.1) ],
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
				[ Env.adsr(0.3,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.07,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\base2),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,0, 0,0,0,-2,
				],8),
				Pser([
					-1,-1,-1,-1, -1,-1,-1,7,
				],8),
				Pser([
					-2,-2,-2,-2, -2,-2,-2,10,
				],8),
				Pser([
					-1,-1,-1,7, 2,2,2,3,
				],8),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				2,0,1,2, 0,0,2,0,
				2,0,2,0, 1,1,2,0,
				2,0,0,2, 0,0,2,0,
				1,1,2,0, 2,0,2,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],4),
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, 300 * Pseg(Pseq([1,4],1),32),
			\envamt, 5,
			\lpadsr, Pseq([
				[ Env.adsr(0.03,0.1,0.2,0.1) ],
				[ Env.adsr(0.03,0.1,0.8,0.1) ],
				[ Env.adsr(0.3,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.07,
		),
	])
)).play;
);

(
SynthDef(\distbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\base2),
		Pmono(\distbass,
			//\fmrange, Pseq([0.5,1,1.5],inf),
			//\fmfreq, Pseq([0.5,1,2,4],inf),
			\note, Pseq([
				Pser([
					0,0,0,0, 0,0,0,-2,
				],8),
				Pser([
					-1,-1,-1,-1, -1,-1,-1,7,
				],8),
				Pser([
					-2,-2,-2,-2, -2,-2,-2,10,
				],8),
				Pser([
					-1,-1,-1,7, 2,2,2,3,
				],8),
			],inf).stutter(4),
			\octave, 3,
			\dur, 1/8,
			\igate, Pseq([
				1,1,0,
				1,1,0,
				1,0,
			],inf),
			\iadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpf, Pkey(\freq) * Pseq([2,1,4,8],inf).stutter(8),
			\hpf, Pkey(\freq) / 2,

			\amp, Pkey(\amp) * 1.52,
			\isRest, false,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\base2),
		Pmono(\reese,
			\out, 0.0,
			\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.0099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\lpadsramt, 7.0,
			\distamp, 10.0,
			\distpostamp, 0.5,
			\lpf, 730.0,
			\rq, 0.80000001192093,
			\spread, 0.80000001192093,
			//\fmrange, Pseq([0.5,1,1.5],inf),
			//\fmfreq, Pseq([0.5,1,2,4],inf),
			\note, Pseq([
				Pser([
					0,0,0,0, 0,0,0,-2,
				],8),
				Pser([
					-1,-1,-1,-1, -1,-1,-1,7,
				],8),
				Pser([
					-2,-2,-2,-2, -2,-2,-2,10,
				],8),
				Pser([
					-1,-1,-1,7, 2,2,2,3,
				],8),
			],inf).stutter(4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\isRest, false,
		)
	])
)).play;
);
