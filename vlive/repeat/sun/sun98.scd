
(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
)

(
SynthDef(\formantbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,4.8]), 1);
	env2 = EnvGen.kr(Env([1,3,1],[0.4,4.8]), 1);
	env3 = EnvGen.kr(Env([0,1.0,0],[0.4,1.8]), 1);
	//sig = LFSaw.ar(freq);
	//sig = Formant.ar(freq, freq/4*env1, freq * ( SinOsc.ar(freq/2) * env3 + 1 ) );
	sig = Formant.ar(freq , \formfreq.kr(10) * env2* ((0..7)/7 - 0.5 * \fspread.kr(1.1102) + 1), \bwfreq.kr(100) * env1 );
	//sig = sig * ( Pulse.ar(freq/4) * 0.5 + 1 );
	//sig = RLPF.ar(sig, [ \lpf.kr(800), \lpf2.kr(1400) ], \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\formsechoir, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[1.1,4.8]), 1);
	env2 = EnvGen.kr(Env([1,3,0],[0.01,4.8]), 1);
	env3 = EnvGen.kr(Env([0,1.0,0],[0.4,1.8]), 1);
	//sig = LFSaw.ar(freq);
	sig = Formant.ar(freq, freq/4*env1, freq * ( SinOsc.ar(freq/2) * env3 + 1 ) );
	sig = Formant.ar(freq, 180 * env2, \bwfreq.kr(20) * env1 ) + sig;
	//sig = sig * ( Pulse.ar(freq/4) * 0.5 + 1 );
	//sig = RLPF.ar(sig, [ \lpf.kr(800), \lpf2.kr(1400) ], \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				\Cm, \CM
			],inf).stutter(8*2),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \oscfmpad,
			\chord, Pseq([
				\Cm, \CM
			],inf).stutter(8*2),
			\fmadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.7) ],
			],inf),
			\oscmix, PmodEnv(Pseq([1,0],1), 8*2).loop,
			\fma, 2,
			\legato, 0.1,
			\lpf, PmodEnv(Pseq([100,1400],1), 8*2).loop,
			\fmadsramt, 0,
			\lpadsramt, 0,
			\fmf, 2,
			\idx, Pseq([
				//0,1,3,7, 11,5,4,2
				//4,3,2,1,
				4,
			],inf),
			\note, Pfunc({ arg ev;
				( ev[\chord] +.x [-12,0,12] ).wrapAt(ev[\idx])
			}),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/5,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq([
				\Cm, \CM
			],inf),
			\octave, 6,
			\dur, 2,
			\amp, 0.1/5,
			//\isRest, true,
		),
		Pbind(
			\instrument, \oscfmpad,
			\chord, Pseq([
				\Cm, \CM
			],inf).stutter(8*2),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,1.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.41,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\oscmix, PmodEnv(Pseq([1,0],1), 8*2).loop,
			\fmoscmix, 0.91,
			\fma, 0.1,
			\legato, 0.51,
			\lpf, PmodEnv(Pseq([800,4400],1), 8*2).loop,
			\fmadsramt, 5,
			\lpadsramt, 4,
			\fspread, 0.0001,
			\fmf, 4,
			\idx, Pseq([
				//0,1,3,7, 11,5,4,2
				4,3,2,1,
				//3,
			],inf)+3,
			\note, Pfunc({ arg ev;
				( ev[\chord] +.x [-12,0,12] ).wrapAt(ev[\idx])
			}),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/7,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\delay, 1/6/~t,
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
			\instrument, \oscfmpad,
			\chord, Pseq([
				\Cm, \CM
			],inf).stutter(8*2),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,1.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.41,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\oscmix, PmodEnv(Pseq([1,0],1), 8*2).loop,
			\fmoscmix, 0.91,
			\fma, 0.1,
			\legato, 0.51,
			\lpf, PmodEnv(Pseq([800,4400],1), 8*2).loop,
			\fmadsramt, 5,
			\lpadsramt, 4,
			\fspread, 0.0001,
			\fmf, 4,
			\idx, Pseq([
				//0,1,3,7, 11,5,4,2
				4,3,2,1,
				//3,
			],inf)+3,
			\note, Pfunc({ arg ev;
				( ev[\chord] +.x [-12,0,12] ).wrapAt(ev[\idx])
			}),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/7,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\delay, 1/6/~t,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

~chord.chordProg
(
~chord = [\Fm, [3,8,12], [3,7,10], [4,7,12]];
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
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1075].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq(~chord,inf).collect({ arg x; x ++ ( x[0]+12 ) }),
			\octave, 5,
			\dur, 2,
			\lpf, PmodEnv(Pseq([400,1000],1), 8).loop,
			\amp, 0.1/5,
			\fspread, 0.0001,
			\lpadsramt, 2,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,1.1,0.3,14.1) ],
			],inf),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,14.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
			],inf),
			//\isRest, true,
		),
		Pbind(
			\instrument, \oscfmpad,
			\chord, Pseq(~chord,inf).stutter(8*2),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,1.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.41,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\oscmix, PmodEnv(Pseq([1,0],1), 8*2).loop,
			\fmoscmix, 0.21,
			\fma, 0.1,
			\legato, 0.51,
			\lpf, PmodEnv(Pseq([800,4400],1), 8*2).loop,
			\fmadsramt, 8,
			\lpadsramt, 4,
			\fspread, 0.0011,
			\fmf, 1.01,
			\idx, Pseq([
				//0,1,3,7, 11,5,4,2
				//4,3,2,1,
				//0,1,2,3,
				3,2,1,0,
				//3,
			],inf) + Pseq([
				//0,0,4,0,0,2,0,0,6
				//Pseq((0..12))
				0,0,0,0,
				0,0,0,3,
				
			],inf).stutter(4),
			\note, Pfunc({ arg ev;
				( ev[\chord] +.x [0,12,24] ).wrapAt(ev[\idx])
			}),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1/7,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\delay, 1/6/~t,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
~chord = [\Fm, [3,8,12], [3,7,10], [4,7,12]];
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1.2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\isRest, Pseq([
				1,0,1,0, 0,1,1,0,
				//1,1,1,1, 1,1,1,1,
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1.2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				1,1,1,1, 1,1,1,1,
				Pser([0.5],8),
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1075].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq(~chord,inf).collect({ arg x; x ++ ( x[0]+12 ) }),
			\octave, 5,
			\dur, 2,
			\lpf, PmodEnv(Pseq([400,1000],1), 8).loop,
			\amp, 0.1/5,
			\fspread, 0.0001,
			\lpadsramt, 2,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,1.1,0.3,14.1) ],
			],inf),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,14.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \oscfmpad,
			\chord, Pseq(~chord,inf).stutter(8*2),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,1.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.41,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\oscmix, PmodEnv(Pseq([1,0],1), 8*2).loop,
			\fmoscmix, 0.21,
			\fma, 0.1,
			\legato, 0.51,
			\lpf, PmodEnv(Pseq([800,4400],1), 8*2).loop,
			\fmadsramt, 8,
			\lpadsramt, 4,
			\fspread, 0.0011,
			\fmf, 1.01,
			\idx, Pseq([
				//0,1,3,7, 11,5,4,2
				//4,3,2,1,
				//0,1,2,3,
				3,2,1,0,
				//3,
			],inf) + Pseq([
				//0,0,4,0,0,2,0,0,6
				//Pseq((0..12))
				0,0,0,0,
				0,0,0,3,
				
			],inf).stutter(4),
			\note, Pfunc({ arg ev;
				( ev[\chord] +.x [0,12,24] ).wrapAt(ev[\idx])
			}),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1/7,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\delay, 1/6/~t,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
~chord = [\Fm, [3,8,12], [3,7,10], [4,7,12]];
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1.2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			//\hpf, Pseg(Pseq([10,10,10,10,10000],1),8).loop,
			\lpfmix, 1,
			\lpf, Pseg(Pseq([Pseq([20000],2),4400,1010],1),4).loop,
			\gain, 1/8,
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				//1,1,1,1, 1,1,1,1,
				0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1.2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				1,1,1,1, 1,1,1,1,
				Pser([0.5],8),
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				Pser([1],16*3),
				Pseq((0..15).reverse)/83+1,
			],inf),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			//\isRest, Pseq([
				//1,0,0,0, 1,1,1,0,
			//],inf).coin.not,
			\pos, Pseq([
				//(0..15),

				2, 1, 1, 1,
				(0..1)+8, (0..1),
				(0..3),
				(0..3)+10,

				2, 3, 1, 2,
				(0..1)+18, (0..1)+6,
				(0..3)+22,
				(0..3)+14,
				
			].flat,inf)/8 / Pkey(\st),
			\pos, Pseq([
				//(0..15),

				Pseq([
				   	14,15, 10, 5,  25, 10, 21,20, 
				   	15,12, 10, 25,  22, 10, 21,22, 
				   	15,12, 10, 25,  22, 10, 21,20, 
				   	15,12, 10, 25,  22, 10, 21,22, 
				],12),
				Pseq([
					Pseq([
						14,24,10, 24,
						18,19,20, 18,
					],3),
					14,15,14, 14,
					18,19,20, 18,
				],1),
				Pseq([
					14,17,10, 11,
					17,14,10, 17,
					14,14,10, 11,
					17,14,10, 17,
					14,17,10, 11+8,
					17,14,10, 17,
				],1),
				Pseq([
					14,17,10, 11+8,
					17,14,10, 17,
				],8),
				Pseq([
					12,10, 15,12,
				],8)+5,
				Pseq([
					12,10, 15,12,
				],2)+3,
				Pseq([
				   	15,12,
					10,10,
				],2),
				
			].flat,inf)/8 / Pkey(\st),
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				0.5,0.5,1,0.5, 0.5,1,1,0.5,
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1075].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,1,1,1, 
				0.5,0.3,0.5,0.3,
			],inf).coin.not,
			\dur, 1/16,
			\speed, Pseq([1,1.1],inf),
			\gain, 0.11 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq(~chord,inf).collect({ arg x; x ++ ( x[0]+12 ) }),
			\octave, 5,
			\dur, 2,
			\lpf, PmodEnv(Pseq([400,1000],1), 8).loop,
			\amp, 0.1/5,
			\fspread, 0.0001,
			\lpadsramt, 2,
			\lpadsr, Pseq([
				[ Env.adsr(3.01,1.1,0.3,14.1) ],
			],inf),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,14.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
			],inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \oscfmpad,
			\chord, Pseq(~chord,inf).stutter(8*2),
			\fmadsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,1.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.41,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.7) ],
			],inf),
			\oscmix, PmodEnv(Pseq([1,0],1), 8*2).loop,
			\fmoscmix, 0.21,
			\fma, 0.1,
			\legato, 0.51,
			\lpf, PmodEnv(Pseq([800,4400],1), 8*2).loop,
			\fmadsramt, 8,
			\lpadsramt, 4,
			\fspread, 0.0011,
			\fmf, 1.01,
			\idx, Pseq([
				//0,1,3,7, 11,5,4,2
				//4,3,2,1,
				//0,1,2,3,
				3,2,1,0,
				//3,
			],inf) + Pseq([
				//0,0,4,0,0,2,0,0,6
				//Pseq((0..12))
				0,0,0,0,
				0,0,0,3,
				
			],inf).stutter(4),
			\note, Pfunc({ arg ev;
				( ev[\chord] +.x [0,12,24] ).wrapAt(ev[\idx])
			}),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1/7,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\delay, 1/6/~t,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


/////////////////////////////

(
// base
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0,
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
// with vbreak snare
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0,
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				Pser([1],16*3),
				Pseq((0..15).reverse)/83+1,
			],inf),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			//\isRest, Pseq([
				//1,0,0,0, 1,1,1,0,
			//],inf).coin.not,
			\pos, Pseq([
				//(0..15),

				2, 1, 1, 1,
				(0..1)+8, (0..1),
				(0..3),
				(0..3)+10,

				2, 3, 1, 2,
				(0..1)+18, (0..1)+6,
				(0..3)+22,
				(0..3)+14,
				
			].flat,inf)/8 / Pkey(\st),
			\pos, Pseq([
				//(0..15),

				Pseq([
				   	14,15, 10, 5,  25, 10, 21,20, 
				   	15,12, 10, 25,  22, 10, 21,22, 
				   	15,12, 10, 25,  22, 10, 21,20, 
				   	15,12, 10, 25,  22, 10, 21,22, 
				],12),
				Pseq([
					Pseq([
						14,24,10, 24,
						18,19,20, 18,
					],3),
					14,15,14, 14,
					18,19,20, 18,
				],1),
				Pseq([
					14,17,10, 11,
					17,14,10, 17,
					14,14,10, 11,
					17,14,10, 17,
					14,17,10, 11+8,
					17,14,10, 17,
				],1),
				Pseq([
					14,17,10, 11+8,
					17,14,10, 17,
				],8),
				Pseq([
					12,10, 15,12,
				],8)+5,
				Pseq([
					12,10, 15,12,
				],2)+3,
				Pseq([
				   	15,12,
					10,10,
				],2),
				
			].flat,inf)/8 / Pkey(\st),
			\pos, Pseq([
				Pser([
					14,17,10, 11+8,
					17,14,10, 17,
				],8*4),
				Pser([
					12,10, 15,12,
				],8*4)+5,
				Pser([
					12,10, 15,12,
				],8*4)+3,
				Pser([
				   	15,12,
					10,10,
				],8*4),
				
			].flat,inf)/8 / Pkey(\st),
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				0.5,0.5,1,0.5, 0.5,1,1,0.5,
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			\gain, 1/8,
		),
	])
)).play;
);

(
// variation
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,12,
					0,0,0,-12,
					0,0,0,0,
					0,0,0,0,
				],8*4),
				0,0,0,0,
				0,0,0,0,
				12,3,2,0,
				0,0,0,0,
				Pseq([
					0,0,0,0,
				],4),
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.39999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,3,0,-2,
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\envamt, Pseq([4,2,6,1],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(1),
			\isRest, Pseq([
				1,0,0.91,0.81, 1,0,0,1,
				Pser([0.5],8),
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([100,12000,400,300,4000],1), 4).loop,
			\rq, Pseg(Pseq([0.5,0.3,0.6],inf),2),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
// variation 2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//-12,0,12,0,
					//-12,0,5,0,
				//],inf),
				//0,\r,0,\r,
				//0,\r,0,12,
			//],inf) + Pstep(Pseq([
				//0,0,-1,2, -4,-4,-4,3,
				//0,0,-1,2, -4,-4,-4,\r,
			//],inf),1),
			//\degree, Pseq([
				//0,0,7,0,
				//0,3,0,3,
			//],inf) + Pstep(Pseq([
				//0,0,-1,1, -2b, -2b, -2b, 1s,
				//0,0,-1,1, -2b,-2b,-2b,\r,
			//],inf),1),
			\note, Pseq([
				0,0,3,3, 0,0,5,0,
				0,0,0,0, 0,0,0,0,
				Pseq([ 0,0,2,2, 0,0,0,0, ])-1,
				Pseq([ 0,0,0,0, 3,0,0,0, ])+2,
			   	Pseq([ 0,0,0,0, 1,0,1,0, ])-4,
				Pseq([ 0,0,0,0, 0,0,0,0, ])-4,
				Pseq([ 0,0,7,0, 8,8,11,11, ])-4,
				Pseq([ 0,0,0,0, 0,0,0,0, ])+3,
			],inf),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//3,7,7,6,
			//],inf).stutter(8),
			//\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			//\octave, 5,
			//\dur, 1/8,
			//\amp, 0.1/3,
		//),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//12,12,12,12+3,
					//11,11,12+3,3,
				//],2),
				//Pseq([
					//12,12,12,12+3,
					//11,11,11,0,
				//],4),

				//Pseq([
					//12,12,12,12+3,
					//10,11,10,11,
				//],2),
			//],inf).stutter(1),
			//\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			//\octave, 6,
			//\dur, 1/8,
			//\amp, 0.1/3,
		//),
		
	])
)).play;
);

(
// bass with formantbass, different hi
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \formantbass,
			\degree, Pseq([0],inf),
			\note, Pseq([
				0,5,5,5, 4,3,1,0
			],inf).stutter(4),
			\bwfreq, PmodEnv(Pseq([10,100,800,5000],1), 8).loop,
			\formfreq, PmodEnv(Pseq([10,100,800],1), 8).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\degree, Pseq([0],inf),
			\note, Pseq([
				0,5,5,5, 4,3,1,0
			],inf).stutter(4),
			\octave, 3,
			\lpf, PmodEnv(Pseq([100,400],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \formantbass,
			\note, Pseq([
				0,4,7,12,
				//-1,4,7,11,
			],inf),
			\octave, Pseq([
				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				5,4,5,5,

				5,5,5,5,
				5,5,5,5,
				5,5,5,5,
				5,4,6,5,
			],inf),
			\ctranspose, Pseq([
				0,5,5,5, 4,3,1,0
			],inf).stutter(4),
			\bwfreq, 100,
			\formfreq, Pseg(Pseq([10,1001],inf),16),
			\dur, 1/8,
			//\lpf, PmodEnv(Pseq([100,4000],1), 8*3).loop,
			//\lpf, 400,
			\lpspread, PmodEnv(Pseq([0.03,0.8],1), 8*2).loop,
			\lpadsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,1.1,1,2) ],
			],inf),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.01,0.4,0.8,0.1) ],
					[ Env.adsr(0.4,0.1,0.8,0.1) ],
				],3),

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.5) ],
			],inf),
			\amp, 0.1/3,
		),
	])
)).play;
);

///////////////////////////
//// try to make a track
// structure:
// - intro 16
// - sec1 32
// - cut drums 16
// - sec2 32
// - cut hi 16
// - sec3 16
// - outro 16
// doit faire 138 beats pour faire 3 minutes
138/6
16+32+16+32+16+16+16 == 144
// bass = 8 beats, doubled with silence at the end = 16 beats
// 144/8 = 18 times the bass pattern
// 144/16 = 9 times the doubled bass pattern
// section of 32 beat = 2 doubled bass pattern

(
///// main
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16, Pdef(\intro)),
		Pfindur(24, Pdef(\sec1)),
		Pfindur(8, Pdef(\sec1b)),
		Pfindur(16, Pdef(\sec_nodrum)),
		Pfindur(32, Pdef(\sec2)),
		Pfindur(16, Pdef(\sec_nohi)),
		Pfindur(16, Pdef(\sec3)),
		Pfindur(16, Pdef(\outro)),
	])
)).play;
);

(
Pdef(\part, Pfindur(16,Pdef(\intro, 
	Ppar([

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0,
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
		),
		Ptpar([
			6, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					7,6,
				],1).stutter(8),
				\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
				\octave, 4,
				\dur, 1/8,
				\amp, 0.1/3,
			),
			8, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					3,7,7,6,
				],inf).stutter(8),
				\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1/3,
			),
			12, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[235].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.1) ],

					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					1,0,0,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					Pser([
						1,1,1,1,
					],8*2),
					Pser([
						1,0.4,1,0.41,
					],8*2),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.5,0.9,1,0.8,
				],inf),
			),
		]),
	])
))).play;
);


(
// base
Pdef(\part, Pdef(\sec1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,0,
				],8*16),
				Pser([
					0,0,0,0,
					0,0,0,0,
					0,0,0,0,
					0,0,0,0,
					0,0,12,0,
					0,0,-12,0,
					0,12,-12,12,
				],8*16),
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
// base part 2
Pdef(\part, Pfindur(16, Pdef(\sec1b, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,0,
					0,0,0,0,
					0,0,12,0,
					0,0,-12,0,
					0,12,-12,12,
				],8*16),
				Pser([
					0,0,0,0,
				],8*16),
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, Pseq([6,5],inf),
			\dur, 1/16,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0, 
				],4),
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		
	])
))).play;
);

(
Pdef(\part, Pfindur(16, Pdef(\sec_nodrum, 
	Ppar([
		Ptpar([
			4, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0,
				],inf) + Pstep(Pseq([
					0,0,-1,2, -4,-4,-4,3,
					0,0,-1,2, -4,-4,-4,\r,
				].rotate(-4),inf),1),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
				\adsr, Pseq([
					PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
				],inf),
				\dur, 1/8,
				\octave, 3,
				\amp, 0.1,
				//\out, BusDef(\ifx1, \audio),
			),
			12, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
				\legato, 1,
				\st, 119/2/60,
				\speed, 1 * ~t / Pkey(\st) * Pseq([
					Pser([1],16*3),
					Pseq((0..15).reverse)/83+1,
				],inf),
				\dur, 1/8,
				\pos, Pseq([
					//Pser([
						//14,17,10, 11+8,
						//17,14,10, 17,
					//],8*4),
					//Pser([
						//12,10, 15,12,
					//],8*4)+5,
					//Pser([
						//12,10, 15,12,
					//],8*4)+3,
					Pser([
						15,12,
						10,10,
					],8*4),

				].flat,inf)/8 / Pkey(\st),
				\isRest, Pseq([
					//1,0,1,0, 0,1,1,0,
					0.4
					//0.5,0.5,1,0.5, 0.5,1,1,0.5,
					//0.5,0.5,1,0.5, 0.5,1,1,0.5,
				],inf).coin.not,
				\gain, 1/8,
			),
		]),
		Pmono(\fx_compander,
			\sidemode, 0.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
				3,0,-1,-3,
				12,11,7,7,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([12000,400],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
	])
))).play;
);

(
// with vbreak snare
Pdef(\part, Pfindur(32, Pdef(\sec2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,1,

				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,1,0,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0,
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([
						3,7,7,6,
					],3),
					3,12,7,10,
				],3),
				Pseq([
					0,3,7-12,6,
				],3),
				3,12,7,10,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([

				Pseq([
					Pseq([
						12,12,12,12+3,
						11,11,12+3,3,
					],2),
					Pseq([
						12,12,12,12+3,
						11,11,11,0,
					],4),
					
					Pseq([
						12,12,12,12+3,
						10,11,10,11,
					],2),
				],2),
				Pseq([
					Pser([
						0,12,-12,-12+3,
						11,11,12+3,3,
						12,12,12,12+3,
						11,11,11,0,
					],8*6),
					Pseq([
						24,12,12,12+3,
						10,11,10,11,
					],2),
				],2),
			],inf).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				Pser([1],16*3),
				Pseq((0..15).reverse)/83+1,
			],inf),
			\dur, 1/8,
			\pos, Pseq([
				Pser([
					14,17,10, 11+8,
					17,14,10, 17,
				],8*4),
				Pser([
					12,10, 15,12,
				],8*4)+5,
				Pser([
					12,10, 15,12,
				],8*4)+3,
				Pser([
				   	15,12,
					10,10,
				],8*4),
				
			].flat,inf)/8 / Pkey(\st),
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				0.5,0.5,1,0.5, 0.5,1,1,0.5,
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			\gain, 1/8,
		),
	])
))).play;
);

(
Pdef(\part, Pfindur(16, Pdef(\sec_nohi, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],4),
				Pseq([
					1,0,1,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 1,0,1,0,
					0,1,0,0, 1,0,0,1,
					0,0,0,0, 1,0,1,0,
					0,1,1,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				2,0.7,0.7,0.7,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,1,
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,1,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,1,
				],inf),
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[213].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,

					0,0,1,0, 1,0,0,1,
					0,1,1,0, 1,1,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11/2,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
					0,1,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,0, 1,0,1,1,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Ptpar([
			4, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0,
				],inf) + Pstep(Pseq([
					0,0,-1,2, -4,-4,-4,3,
					0,0,-1,2, -4,-4,-4,\r,
				].rotate(-4),inf),1),
				\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
				//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
				\adsr, Pseq([
					PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
				],inf),
				\dur, 1/8,
				\octave, 3,
				\amp, 0.1,
				\out, BusDef(\ifx1, \audio),
			),
		]),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				Pser([1],16*3),
				Pseq((0..15).reverse)/83+1,
			],inf),
			\dur, 1/8,
			\pos, Pseq([
				Pser([
					14,17,10, 11+8,
					17,14,10, 17,
				],8*4),
				Pser([
					12,10, 15,12,
				],8*4)+5,
				Pser([
					12,10, 15,12,
				],8*4)+3,
				Pser([
				   	15,12,
					10,10,
				],8*4),
				
			].flat,inf)/8 / Pkey(\st),
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				0.5,0.5,1,0.5, 0.5,1,1,0.5,
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			\gain, 1/8,
			\isRest, true,
		),
		
	])
))).play;
);

(
Pdef(\part, Pfindur(16, Pdef(\outro_old, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],4).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],4).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pfindur(8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0,
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.09999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
		Pfindur(8,Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st) * Pseq([
				Pseg(Pseq([1,0.1],inf),8),
			],inf),
			\dur, 1/8,
			\pos, Pseq([
				Pser([
					14,17,10, 11+8,
					17,14,10, 17,
				],8*4),
				Pser([
					12,10, 15,12,
				],8*4)+5,
				Pser([
					12,10, 15,12,
				],8*4)+3,
				Pser([
				   	15,12,
					10,10,
				],8*4),
				
			].flat,inf)/8 / Pkey(\st),
			\isRest, Pseq([
				//1,0,1,0, 0,1,1,0,
				0.5,0.5,1,0.5, 0.5,1,1,0.5,
				//0.5,0.5,1,0.5, 0.5,1,1,0.5,
			],inf).coin.not,
			\gain, 1/8,
		)),
	])
))).play;
);

(
// variation
Pdef(\part, Pdef(\sec3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,12,
					0,0,0,-12,
					0,0,0,0,
					0,0,0,0,
				],8*4),
				0,0,0,0,
				0,0,0,0,
				12,3,2,0,
				0,0,0,0,
				Pseq([
					0,0,0,0,
				],4),
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,3,
				0,0,-1,2, -4,-4,-4,\r,
			],inf),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.39999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//3,3,0,-2,
			//],inf).stutter(2),
			//\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			//\envamt, Pseq([4,2,6,1],inf),
			//\octave, 5,
			//\dur, 1/8,
			//\amp, 0.1/3,
		//),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//12,12,12,12+3,
					//11,11,12+3,3,
				//],2),
				//Pseq([
					//12,12,12,12+3,
					//11,11,11,0,
				//],4),

				//Pseq([
					//12,12,12,12+3,
					//10,11,10,11,
				//],2),
			//],inf).stutter(1),
			//\isRest, Pseq([
				//1,0,0.91,0.81, 1,0,0,1,
				//Pser([0.5],8),
			//],inf).coin.not,
			//\lpf, PmodEnv(Pseq([100,12000,400,300,4000],1), 4).loop,
			//\rq, Pseg(Pseq([0.5,0.3,0.6],inf),2),
			//\octave, 5,
			//\dur, 1/8,
			//\amp, 0.1/3,
		//),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
				3,3,0,-2,
			],inf).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],inf).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\isRest, Pseq([
				1,0,0.91,0.81, 1,0,0,1,
				Pser([0.5],8),
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
// variation
Pdef(\part, Pdef(\outro, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				1,1,0,0, 1,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[235].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],

				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				Pser([
					1,1,1,1,
				],8*2),
				Pser([
					1,0.4,1,0.41,
				],8*2),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\kickbus),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			//\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,0,0,12,
					0,0,0,-12,
					0,0,0,0,
					0,0,0,0,
				],8*4),
				0,0,0,0,
				0,0,0,0,
				12,3,2,0,
				0,0,0,0,
				Pseq([
					0,0,0,0,
				],4),
			],inf) + Pstep(Pseq([
				0,0,-1,2, -4,-4,-4,-4,
			],1),1),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\dur, 1/8,
			\octave, 3,
			\amp, 0.1,
			//\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_compander,
			\sidemode, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\kickbus),
			\pregain, 1.0,
			\cpt, 0.010000000596046,
			\cpbelow, 1.00100004673,
			\cpabove, 0.39999997615814,
			\cpclamp, 0.0099999997764826,
			\cprelax, 0.10000000149012,
			\mix, 1.0,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//3,3,0,-2,
			//],inf).stutter(2),
			//\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			//\envamt, Pseq([4,2,6,1],inf),
			//\octave, 5,
			//\dur, 1/8,
			//\amp, 0.1/3,
		//),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//12,12,12,12+3,
					//11,11,12+3,3,
				//],2),
				//Pseq([
					//12,12,12,12+3,
					//11,11,11,0,
				//],4),

				//Pseq([
					//12,12,12,12+3,
					//10,11,10,11,
				//],2),
			//],inf).stutter(1),
			//\isRest, Pseq([
				//1,0,0.91,0.81, 1,0,0,1,
				//Pser([0.5],8),
			//],inf).coin.not,
			//\lpf, PmodEnv(Pseq([100,12000,400,300,4000],1), 4).loop,
			//\rq, Pseg(Pseq([0.5,0.3,0.6],inf),2),
			//\octave, 5,
			//\dur, 1/8,
			//\amp, 0.1/3,
		//),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,7,7,6,
				3,3,0,-2,
			],1).stutter(8),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,12,12,12+3,
					11,11,12+3,3,
				],2),
				Pseq([
					12,12,12,12+3,
					11,11,11,0,
				],4),

				Pseq([
					12,12,12,12+3,
					10,11,10,11,
				],2),
			],1).stutter(1),
			\lpf, PmodEnv(Pseq([100,12000,4000],1), 8).loop,
			\isRest, Pseq([
				1,0,0.91,0.81, 1,0,0,1,
				Pser([0.5],8),
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

////////////////////////////////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0,
			\speed, 1 * Pseq([0,4,2,1],inf).midiratio,
			\legato, 1,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 1,
			\speed, 1 * Pseq([0,4,2,1],inf).midiratio,
			\legato, 1,
			\dur, 1,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6+8,7,
				0,1,2,3,4,5,6,7,
				0,1,2,3+8,4,5,6,7,

				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6,7,
				0,1,2,6,4,5,4+8,7,
				Pseq([
					0,1,2,3,4,5,6,7,
				],1)+6,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 2.13 + Pseq([
				Pser([
					0.1,0,1.3,
					0.1,0,1.3,
				],8*4),
				Pser([
					0.1,0,0.3,
					0.1,0,0.3,
				],8*4),
			],inf),
			\speed, 1 * Pseq([0,0,0,-1, -4,-4,-5,1],inf).midiratio,
			\legato, 1,
			\dur, 1/4,
			\gain, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 1.43 + Pseq([0],inf),
			\speed, 1/2 * Pseq([7,3],inf).midiratio,
			\legato, 0.51* Pseq([1,0.5,2],inf).stutter(9),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 1,0,1,1,
				],7),
			],inf).coin.not,
			\dur, 1/2,
			\gain, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 0.9 * ~t / Pkey(\st),
			\pos, Pseq([
				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6+8,7,
				0,1,2,3,4,5,6,7,
				0,1,2,3+8,4,5,6,7,

				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6,7,
				0,1,2,6,4,5,4+8,7,
				Pseq([
					0,1,2,3,4,5,6,7,
				],1)+6,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),

	])
)).play;
);

(
// hipass vbreak and add drums
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 2.13 + Pseq([
				Pser([
					0.1,0,1.3,
					0.1,0,1.3,
				],8*4),
				Pser([
					0.1,0,0.3,
					0.1,0,0.3,
				],8*4),
			],inf),
			\speed, 1 * Pseq([0,0,0,-1, -4,-4,-5,1],inf).midiratio,
			\legato, 1 * Pseq([ Pser([1],6),2,Pser([1],1) ],inf),
			\legato, 1,
			\dur, 1/4,
			\gain, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 1.43 + Pseq([0],inf),
			\speed, 1/2 * Pseq([7,3],inf).midiratio,
			\legato, 0.51* Pseq([1,0.5,2],inf).stutter(9),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 1,0,1,1,
				],7),
			],inf).coin.not,
			\dur, 1/2,
			\gain, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 6.43 + Pseq([0,0.8],inf).stutter(8*4),
			\speed, 1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,6,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1165].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
				1,0,1,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1894].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,1,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.6,0.6,0.6,
			],inf),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 0.9 * ~t / Pkey(\st) * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1.5,1.5,1.5, 1,1,1,1, 
				1,1,1,1, 1,1,0.82,0.81,
			],inf),
			\pos, Pseq([
				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6+8,7,
				0,1,2,3,4,5,6,7,
				0,1,2,3+8,4,5,6,7,

				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6,7,
				0,1,2,6,4,5,4+8,7,
				Pseq([
					0,1,2,3,4,5,6,7,
				],1)+6,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),

	])
)).play;
);

(
// change pitch of saxo
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 2.13 + Pseq([
				Pser([
					0.1,0,1.3,
					0.1,0,1.3,
				],8*4),
				Pser([
					0.1,0,0.3,
					0.1,0,0.3,
				],8*4),
			],inf),
			\speed, 1 * Pseq([0,0,0,0, 0,0,-5,-5, 0,0,0,0, -5,-5,-5,-5,],inf).midiratio,
			\legato, 1 * Pseq([ Pser([1],6),2,Pser([1],1) ],inf),
			\legato, 1,
			\dur, 1/4,
			\gain, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 1.43 + Pseq([0],inf),
			\speed, 1/2 * Pseq([10,12],inf).midiratio,
			\legato, 0.51* Pseq([1,0.5,2],inf).stutter(9),
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 1,0,1,1,
				],7),
			],inf).coin.not,
			\dur, 1/2,
			\gain, 2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/october.flac'),
			\pos, 0.4,
			\pos, 6.43 + Pseq([0,0.8],inf).stutter(8*4),
			\speed, 1,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,6,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1165].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
				1,0,1,1, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1894].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,1,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.6,0.6,0.6,
			],inf),
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 1000,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 0.9 * ~t / Pkey(\st) * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1.5,1.5,1.5, 1,1,1,1, 
				1,1,1,1, 1,1,0.82,0.81,
			],inf),
			\pos, Pseq([
				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6+8,7,
				0,1,2,3,4,5,6,7,
				0,1,2,3+8,4,5,6,7,

				0,1,2,3,4,5,6,7,
				0,1,2,3,4,5,6,7,
				0,1,2,6,4,5,4+8,7,
				Pseq([
					0,1,2,3,4,5,6,7,
				],1)+6,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),

	])
)).play;
);
