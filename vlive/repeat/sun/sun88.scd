
// olala

~t = 154/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\pschiou, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpfr.kr(1) * XLine.kr(10000,100,4/~t), \rq.kr(0.5) * XLine.kr(1,0.3,4/~t));
	sig = sig + DelayL.ar(sig, 0.9, 0.01 * XLine.kr(0.01,0.81,4/~t));
	//sig = sig + DelayL.ar(sig, 0.9, 0.01 * XLine.kr(0.001,0.81,4/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \sh101,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,3,6,-3,
			],inf).stutter(8),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

////////////

(
// intro
// 10 * 4 beats
Pdef(\part, Pdef(\secintro, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,3,6,-3,2,0,2,2,
			],inf).stutter(8),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\octave, Pseq([3,4],inf).stutter(2),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
(
// intro2
// 6*4 beats
Pdef(\part, Pdef(\secintro2, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,3,6,-3,2,0,2,2,
			],inf).stutter(8),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\octave, Pseq([3,4],inf).stutter(2),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,2, -3,-3,
				2,2, -5,-3,
			],inf).stutter(2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,1,1,0, 0,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\envamt, Pseq([1,1.3],inf)+5,
			\lpf, 800,
			\lpadsr, Pseq([
				[ Env.adsr(0.05,0.1,0.1,1.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1.0,0.1) ],
			],inf),
			\rq, 0.3,
			\octave, Pseq([6,6,5,6],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071 * Pseq([
				//1,0.1,1,0.1,0.1,1, 0.1,0.1,
				1,
			],inf).linlin(0,1,0.4,1),
		),
		Ptpar([
			8+4, Pfindur(4,Pbind( // down ramp
				\instrument, \sh101,
				\note, Pseq([
					2,3,6,-3,
				],inf).stutter(8),
				\freq, PmodEnv(Pseq([20,2000],1), 4).loop,
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\octave, Pseq([3,4],inf).stutter(2)+1,
				\lpf, PmodEnv(Pseq([9000,500],1), 8).loop,
				\rq, 0.61,
				\envamt, Pseq([0,0,1,0,1,0,0,0],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 1,
				\dur, Pseq([1/8],inf),
				\amp, 0.1/2,
			)).repeat(1),
			16+4, Pfindur(4,Pbind( // down ramp
				\instrument, \sh101,
				\note, Pseq([
					2,3,6,-3,
				],inf).stutter(8),
				\freq, PmodEnv(Pseq([20,2000],1), 4).loop,
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\octave, Pseq([3,4],inf).stutter(2)+1,
				\lpf, PmodEnv(Pseq([9000,500],1), 8).loop,
				\rq, 0.61,
				\envamt, Pseq([0,0,1,0,1,0,0,0],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 1,
				\dur, Pseq([1/8],inf),
				\amp, 0.1/2,
			)).repeat(1),
			12, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[674].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					],inf),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.09,
			),
		]),
	])
)).play;
);

(
// intro3
// 2*4 beats
Pdef(\part, Pdef(\secintro3, 
	Pfindur(8,Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,
			],inf).stutter(8),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\octave, Pseq([3,4],inf).stutter(2),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,2, -3,-3,
				2,2, -5,-3,
			],inf).stutter(2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
				],8*4),
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\envamt, Pseq([1,1.3],inf)+5,
			\lpf, 800,
			\lpadsr, Pseq([
				[ Env.adsr(0.05,0.1,0.1,1.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1.0,0.1) ],
			],inf),
			\rq, 0.3,
			\octave, Pseq([6,6,5,6],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071 * Pseq([
				//1,0.1,1,0.1,0.1,1, 0.1,0.1,
				1,
			],inf).linlin(0,1,0.4,1),
		),
		Pfindur(8,Pbind( // up ramp
			\instrument, \sh101,
			\freq, PmodEnv(Pseq([20,4000],1), 8).loop,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\octave, Pseq([3,4],inf).stutter(2)+1,
			\lpf, PmodEnv(Pseq([9000,500],1), 8).loop,
			\rq, 0.61,
			\envamt, Pseq([0,0,1,0,1,0,0,0],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\dur, Pseq([1/8],inf),
			\amp, 0.1/2,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pser([
					0,
				],8*5),
				0,0,1,0, 0,0,1,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	]))
)).play;
);
(
// sec 1
Pdef(\part, Pdef(\sec1, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				\r,\r,2,\r,
				\r,\r,2,\r,
				\r,\r,3,\r,
				\r,\r,3,\r,
				\r,\r,6,\r,
				\r,\r,6,\r,
				\r,\r,-3,\r,
				\r,\r,-3,\r,
			],inf).stutter(1),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,3,6,-3,
			],inf).stutter(8),
			\isRest, Pseq([
				Pser([0],4*4*8),
				Pser([
					1,0,1,0,
				],4*4*8),
			],inf).coin.not,
			\octave, Pseq([4,5],inf).stutter(2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1733].value,
			\bufnum, ~buflib.snare[20].value,
			\bufnum, ~buflib.snare[1872].value,
			//\bufnum, ~buflib.snare[723].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);


(
// sec 2
// 8*4 beats
Pdef(\part, Pdef(\sec2, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,-2,-5,-3,
			],inf).stutter(8),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\envamt, 8,
			\envamt, Pseq([8,15],inf).stutter(8*4),
			\lpf, Pseq([100,150],inf).stutter(8*4),
			\lpf, 100,
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.1,0.4,0.1) ],
			],inf),
			\rq, 0.5,
			\octave, Pseq([3],inf).stutter(2),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					2,2,2,2,3,1,1,1,
				],3),
				2,2,2,-3,-1,1,1,1,
			],inf).stutter(4),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					0
				],16*8),
				Pser([
					1,0,0,0, 1,0,1,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,1, 0,0,1,0,
					0,0,1,0, 1,1,0,0,
				],16*8),
			],inf).coin.not,
			\envamt, Pseq([8,25],inf).stutter(2),
			//\envamt, Pseq([
				//Pseq([ 8 ],8),
				//Pseq([ 8 ],8),
				
			//],inf),
			\lpf, Pseq([100,150],inf).stutter(8*4),
			\lpf, 1000,
			\lpadsr, Pseq([
				[ Env.adsr(0.02,0.1,0.4,0.2) ],
			],inf),
			\rq, 0.5,
			\octave, Pseq([
				Pseq([
					5,5,6,6, 5,5,6,6,
					5,5,6,6, 5,5,6,6,
					5,5,6,6, 5,5,4,5,
					5,5,4,6, 6,6,6,6,
				],3),
				5,5,6,6, 5,5,6,6,
				5,5,6,6, 5,5,6,6,
				5,5,6,6, 5,5,4,5,
				5,5,4,6, 6,6,5,5,
			],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.051,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);

(
// sec 3
// 8*4 beats
Pdef(\part, Pdef(\sec3, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,-2,-5,-3,
			],inf).stutter(8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\envamt, 1,
			//\envamt, Pseq([8,15],inf).stutter(8*4),
			\lpf, Pseq([100,150],inf).stutter(8*4),
			\lpf, PmodEnv(Pseq([100,200,2000],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1.0,0.1) ],
			],inf),
			\rq, 0.3,
			\octave, Pseq([3,4],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.1 * Pseq([
				//1,0.1,1,0.1,0.1,1, 0.1,0.1,
				1,0,1,0, 1,0,0,1,
			],inf).linlin(0,1,0.4,1),
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*4),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10,100,2900],1), 8).loop,
			\lag, 0.0009,
			\gain, 2,
			\dur, 1,
		),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//2,2,2,2,3,1,1,1,
				//],3),
				//2,2,2,-3,-1,1,1,1,
			//],inf).stutter(4),
			//\octave, 3,
			//\adsr, Pseq([
				//[ Env.adsr(0.01,0.1,0.8,0.1) ],
			//],inf),
			//\isRest, Pseq([
				//1,0,0,0, 1,0,1,1,
				//1,0,0,0, 1,0,0,0,
				//1,0,1,1, 0,0,1,0,
				//0,0,1,0, 1,1,0,0,
			//],inf).coin.not,
			//\envamt, Pseq([8,25],inf).stutter(2),
			////\envamt, Pseq([
				////Pseq([ 8 ],8),
				////Pseq([ 8 ],8),
				
			////],inf),
			//\lpf, Pseq([100,150],inf).stutter(8*4),
			//\lpf, 1000,
			//\lpadsr, Pseq([
				//[ Env.adsr(0.02,0.1,0.4,0.2) ],
			//],inf),
			//\rq, 0.5,
			//\octave, Pseq([
				//Pseq([
					//5,5,6,6, 5,5,6,6,
					//5,5,6,6, 5,5,6,6,
					//5,5,6,6, 5,5,4,5,
					//5,5,4,6, 6,6,6,6,
				//],3),
				//5,5,6,6, 5,5,6,6,
				//5,5,6,6, 5,5,6,6,
				//5,5,6,6, 5,5,4,5,
				//5,5,4,6, 6,6,5,5,
			//],inf).stutter(1),
			//\dur, 1/8,
			//\amp, 0.1,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*4),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);

(
// sec 4 (pschiou)
// 8*4
Pdef(\part, Pdef(\break1, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,3,6,-3,
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\octave, Pseq([3,4],inf).stutter(2),
			\lpf, 920,
			\rq, 0.61,
			\envamt, 2,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.3) ],
			],inf),
			\legato, 1,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,3,6,-3,
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\octave, Pseq([3,4],inf).stutter(2)+1,
			\lpf, 120,
			\rq, 0.61,
			\envamt, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Ptpar([
			16, Pfindur(8,Pbind( // down ramp
				\instrument, \sh101,
				\note, Pseq([
					2,3,6,-3,
				],inf).stutter(8),
				\freq, PmodEnv(Pseq([2000,20],1), 8).loop,
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\octave, Pseq([3,4],inf).stutter(2)+1,
				\lpf, PmodEnv(Pseq([9000,500],1), 8).loop,
				\rq, 0.61,
				\envamt, Pseq([0,0,1,0,1,0,0,0],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 1,
				\dur, Pseq([1/8],inf),
				\amp, 0.1/2,
			)).repeat(2),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
				],4*8),
				Pser([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4*8),

				Pser([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*8),

				Pser([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],8*8),

				Pser([
					1,0,0,0, 1,0,0,0,
				],4*8),
				Pser([
					1,0,1,0, 1,0,1,0,
				],2*8),
				Pser([
					1,1,1,1, 1,1,1,1,
				],2*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \pschiou,
			\dur, Pn(4,1),
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
// break 2
// 2*4 beats
Pdef(\part, Pdef(\break2, 
	Ppar([
		Pfindur(8,Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,3,6,-3,
			],inf).stutter(8),
			\freq, PmodEnv(Pseq([2000,20],1), 8).loop,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\octave, Pseq([3,4],inf).stutter(2)+1,
			\lpf, PmodEnv(Pseq([9000,500],1), 8).loop,
			\rq, 0.61,
			\envamt, Pseq([0,0,1,0,1,0,0,0],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1,
			\dur, Pseq([1/8],inf),
			\amp, 0.1/2,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,1,1,1, 1,1,1,1,
				],2*8),
				Pser([
					1,0,1,0, 1,0,1,0,
				],2*8),
				Pser([
					1,0,0,0, 1,0,0,0,
				],2*8),
				Pser([
					1,0,0,0, 0,0,0,0,
				],2*8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);

(
// sec 5
Pdef(\part, Pdef(\sec4, 
	Ppar([
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,-2,-5,-3,
			],inf).stutter(8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\envamt, 1,
			//\envamt, Pseq([8,15],inf).stutter(8*4),
			\lpf, Pseq([100,150],inf).stutter(8*4),
			\lpf, PmodEnv(Pseq([100,200,2000],1), 8).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1.0,0.1) ],
			],inf),
			\rq, 0.3,
			\octave, Pseq([3,4],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.1 * Pseq([
				//1,0.1,1,0.1,0.1,1, 0.1,0.1,
				1,0,1,0, 1,0,0,1,
			],inf).linlin(0,1,0.4,1),
			//\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,2, -3,-3,
				2,2, -5,-3,
			],inf).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,0, 1,1,1,1,
				1,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\envamt, Pseq([1,1.3],inf)+5,
			\lpf, 800,
			\lpadsr, Pseq([
				[ Env.adsr(0.05,0.1,0.1,1.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1.0,0.1) ],
			],inf),
			\rq, 0.3,
			\octave, Pseq([7,7,5,7],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071 * Pseq([
				//1,0.1,1,0.1,0.1,1, 0.1,0.1,
				1,
			],inf).linlin(0,1,0.4,1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
		),
	])
)).play;
);

(
// sec 6
Pdef(\part, Pdef(\sec5, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1224].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[674].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09,
		),
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,-2,-5,-3,
			],inf).stutter(8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\envamt, 1,
			//\envamt, Pseq([8,15],inf).stutter(8*4),
			\lpf, Pseq([100,150],inf).stutter(8*4),
			\lpf, PmodEnv(Pseq([100,200,2000],1), 8).loop,
			\lpf, 1000,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1.0,0.1) ],
			],inf),
			\rq, 0.5,
			\octave, Pseq([3,4],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,-2,-5,-3,
			],inf).stutter(8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				Pseq([
					0,0,0,0, 0,1,1,0,
				],3),
			],inf).coin.not,
			\envamt, 4,
			//\envamt, Pseq([8,15],inf).stutter(8*4),
			\lpf, 12000,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1.0,0.1) ],
			],inf),
			\legato, 0.3,
			\rq, 0.4,
			\octave, Pseq([4],inf).stutter(1),
			\dur, 1/8,
			\amp, 0.1,
			//\isRest, true,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\hpf, 1900,
			\lag, 0.0009,
			\gain, 4,
			\dur, 1,
		),
	])
)).play;
);

////// main

(
Pdef(\part, Pdef(\main, 
	Pseq([
		//Pfindur(10*4,Pdef(\secintro)),
		Pfindur(6*4,Pdef(\secintro2)),
		Pfindur(2*4,Pdef(\secintro3)),

		Pfindur(8*4,Pdef(\sec1)),
		Pfindur(8*4,Pdef(\sec2)),
		Pfindur(8*4,Pdef(\sec3)),
		Pfindur(8*4,Pdef(\break1)),
		Pfindur(2*4,Pdef(\break2)),
		Pfindur(8*4,Pdef(\sec4)),
		Pfindur(8*4,Pdef(\sec5)),
		
	])
)).play;
);


////////////////////////////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pschiou,
			\dur, 4,
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);
