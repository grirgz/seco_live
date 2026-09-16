
(
~t = 245/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/synthbasic.scd");
FileSystemProject.load("sndlib/mysynthdefault.scd");
)

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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 1.0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
			],inf).coin.not,
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
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([

				Pseq([
					2,2,3,2,2,3,2,3,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6 + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-1,0, -2,-2,-1,-1,
				1,1,0,0, 0,1,0,1,
			],inf).stutter(4),
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
			//\isRest, true,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pstep(Pseq([

					0,12,
					0,12,
					0,12,
					0,11,
				//Pseq([
					//0
				//],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/8) + Pseq([0,0,3,7,5,8,3,0],inf).stutter(4),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],8),
				Pser([
					0,1,0,1,
					0,0,1,0,
					0,0,1,1,
					1,0,1,0,
				],8*4),
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		
	])
)).play;
);

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
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 1.0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
			],inf).coin.not,
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
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([

				Pseq([
					2,2,3,2,2,3,2,3,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6 + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//0,0,-1,-1, -1,-1,-2,-2,
				//1,1,1,1, 1,1,1,1,
				Pseq([-1],8),
				Pseq([1],8),
			],inf).stutter(4),
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
			//\isRest, true,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pstep(Pseq([

					0,12,
					0,12,
					0,12,
					0,11,
				//Pseq([
					//0
				//],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/8) + Pseq([0,0,3,7,5,8,3,0],inf).stutter(4),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],8),
				Pser([
					0,1,0,1,
					0,0,1,0,
					0,0,1,1,
					1,0,1,0,
				],8*4),
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		
	])
)).play;
);

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
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 1.0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
			],inf).coin.not,
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
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0.5,0, 1,0,0,0,
				0.31,0,0,0, 0.5,0,0,0,
				1,0,0,0, 0.81,0,1,0,
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([

				Pseq([
					2,2,3,2,2,3,2,3,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6 + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//0,0,-1,-1, -1,-1,-2,-2,
				//1,1,1,1, 1,1,1,1,
				Pseq([-1],8),
				Pseq([1],8),
			],inf).stutter(4),
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
			//\isRest, true,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pstep(Pseq([

					0,12,
					0,12,
					0,12,
					0,11,
				//Pseq([
					//0
				//],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/8) + Pseq([0,0,3,7,5,8,3,0],inf).stutter(4),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],8),
				Pser([
					0,1,0,1,
					0,0,1,0,
					0,0,1,1,
					1,0,1,0,
				],8*4),
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		
	])
)).play;
);

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
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 1.0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
			],inf).coin.not,
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
		
	])
)).play;
);

////// other idea

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,4, 4,0,-3,0,
				0,4,7,4, 0,0,0,0,
				0,0,0,0, 7,0,0,-12,
				0,4,7,4, 0,0,0,0,
			],inf) + Pseq([0,2,4,5],inf).stutter(8),
			\dur, 1/8,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,1,
				1,0, 1,1, 0,1, 1,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				Pseq((0..15),2),
				0,1,2,3, 0,1,0,3,
				0,10,8,9, 4,5,0,3,
				0,1,2,3, 0,1,8,3,
				9,10,13,12, 4,5,0,3,
			],inf)/8 /Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[930].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09 * Pseq([
				0.2,0.2,1,0.2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[228].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,7,5,4,
				7-12,0,5,4,
				0-12,7-12,5,4,
			],inf) + Pseq([0,2,4,5],inf).stutter(8),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
			\isRest, true,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 7,0,0,-12,
				0,0,0,3, 3,0,-3,0,
				0,4,7,4, 0,0,0,0,
				0,4,7,4, 0,0,0,0,
			],inf) + Pseq([0,2,5,7],inf).stutter(8),
			\dur, 1/8,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([

				Pseq([
					1,0, 1,0, 1,0, 1,1,
					1,0, 1,1, 0,1, 1,1,
					1,0, 1,0, 1,0, 1,1,
					1,0, 1,1, 0,1, 1,1,
				],3),
				Pseq([
					1,0, 1,1, 0,1, 1,0,
					1,0, 0,0, 1,0, 1,1,
					0,1, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,1, 0,1,
				],1),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\pos, Pseq([
				Pseq((0..15),2),
				0,1,2,3, 0,1,0,3,
				0,10,8,9, 4,5,0,3,
				0,1,2,3, 0,1,8,3,
				9,10,13,12, 4,5,0,3,
			],inf)/8 /Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[930].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09 * Pseq([
				0.2,0.2,1,0.2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[228].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([

				0
			],inf) + Pseq([0,2,5,7],inf).stutter(8),
			\note, Pseq([
				4,0,2,-3, 0,0,2,-3,
				0,-3,-3,-5, -5,-1,-3,-5,
				4,0,2,-3, 0,0,2,-3,
				0,4,5,7, 0,4,5,7,

				7,0,4,-3, 0,0,2,-3,
				0,-3,-5,-10, -5,-1,-3,-5,
				4,0,7,-3, 0,0,2,-3,
				4,5,7,9, 0,4,5,4,
			],inf).stutter(2),
			\octave, 6 + Pseq([
				Pser([0],4*8),
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				0,0, 1,1, 0,1, 1,0,
				1,0, 1,0, 1,0, 1,0,
				0,0, 0,0, 1,1, 0,1,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


//////////////////////////

(
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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\octave, 3,
			\legato, 0.8,
			\amp, 0.1 * Pseq([
				0.4,0.4,1,0.4,
			],inf)* 2,
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
		Pbind( // down melo
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,1,1,
				],inf),
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		Pbind( // answer
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.3,0.75],1), 5*2).loop,
			\lpf, PmodEnv(Pseq([7100,4000],1), 7*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, Pseg(Pseq([3,3].reciprocal * -1,1), 4).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.4,0.4,0.8,0.1) ],
			],inf),
			\legato, 0.51,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		
	])
)).play;
);
Pdef(\part).clear;
(
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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\octave, 3,
			\legato, 0.8,
			\amp, 0.1 * Pseq([
				0.4,0.4,1,0.4,
			],inf)* 2,
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
		Pbind( // down melo
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,1,1,
				],inf),
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
		Pbind( // answer
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.3,0.75],1), 5*2).loop,
			\lpf, PmodEnv(Pseq([7100,4000],1), 7*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, Pseg(Pseq([3,3].reciprocal * -1,1), 4).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.4,0.4,0.8,0.1) ],
			],inf),
			\legato, 0.51,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				0,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([

				Pseq([
					2,2,3,2,2,3,2,3,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6 + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-1,0, -2,-2,-1,-1,
				1,1,0,0, 0,1,0,1,
			],inf).stutter(4),
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
			\isRest, true,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pstep(Pseq([

					0,12,
					0,12,
					0,12,
					0,11,
				//Pseq([
					//0
				//],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/8) + Pseq([0,0,3,7,5,8,3,0],inf).stutter(4),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],8),
				Pser([
					0,1,0,1,
					0,0,1,0,
					0,0,1,1,
					1,0,1,0,
				],8*4),
			],inf).coin.not,
			\amp, 0.1/2,
			\isRest, true,
		),
		
	])
)).play;
);

///////////////

(
// add fx
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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 1.0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.8,0.1)
			],inf),
			\isRest, Pseq([
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
			],inf).coin.not,
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
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([

				Pseq([
					2,2,3,2,2,3,2,3,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6 + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-1,0, -2,-2,-1,-1,
				1,1,0,0, 0,1,0,1,
			],inf).stutter(4),
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
			//\isRest, true,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pstep(Pseq([

				5,5,0,0,
				5,5,7,0,
			],inf),1/8),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],8),
				Pser([
					0,1,0,1,
					0,0,1,0,
					0,0,1,1,
					1,0,1,0,
				],8*4),
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
			\out, BusDef(\track1, \audio),
		),


		// fx
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, PmodEnv(Pseq([1,0],1), 8).loop,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,1],1), 8).loop,
			\sendbus0, BusDef(\track1fx1, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\track1fx1, \audio),
			\out, BusDef(\track1fx2, \audio),
			\room, 0.2,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\track1fx2, \audio),
			\out, BusDef(\track1fx3, \audio),
			\delay, 1/8/~t,
			\decay, PmodEnv(Pseq([0,2,1,4]/~t,1), 8).loop,
			//\hpf, PmodEnv(Pseq([10000,2],1), 8).loop,
			//\pfmix, 1,
			\mix, 0.3,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\track1fx3, \audio),
			\hpf, PmodEnv(Pseq([100,702,5000],1), 5).loop,
			\lpf, 7000,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


///////


(
Pdef(\part, Pdef(\intro, 
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
				0,0,1,0,
				//Pser([
					//1,1,1,1,
				//],8*2),
				//Pser([
					//1,0.4,1,0.41,
				//],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.9,1,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1588].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				1,0,1,1, 1,1,1,0,
			],inf).coin.not,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[401].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.3,0.3,
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
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			//\lpf, PmodEnv(Pseq([100,5004],1), 8).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\octave, 3,
			\legato, 0.8,
			\amp, 0.1 * Pseq([
				0.4,0.4,1,0.4,
			],inf)* 2,
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
		Pbind( // down melo
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,1,1,
				],inf),
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind( // answer
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.3,0.75],1), 5*2).loop,
			\lpf, PmodEnv(Pseq([7100,4000],1), 7*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, Pseg(Pseq([3,3].reciprocal * -1,1), 4).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.4,0.4,0.8,0.1) ],
			],inf),
			\legato, 0.51,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
			\isRest, true,
		),
		
	])
)).play;
);


(
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
			\out, BusDef(\kicktrack, \audio),
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
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([100,5004],1), 32,\exp).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\octave, 3,
			\legato, 0.8,
			\amp, 0.1 * Pseq([
				0.4,0.4,1,0.4,
			],inf)* 2,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[47].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09 * Pseq([
				1,0.3,0.3,0.3,
			],inf),
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1634].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.09,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[851].value,
				//\bufnum, ~buflib.hat[1163].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,1,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			8, Pbind(
				\instrument, \sh101,
				\note, Pstep(Pseq([

					Pseq([
						3,3,2,2,1,1,-1,-4,
					],inf)+4,
					//0,0,7,7,
					//0,0,3,3,
				],inf),1/2),
				\ctranspose, -4,
				\octave, 5,
				\dur, 1/8,
				\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
				\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
				\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,1,0,1, 1,0,0,0,
					1,0,1,1, 1,0,1,1,
					1,1,0,1, 0,1,1,1,
				],inf).coin.not,
				\amp, 0.1/2,
			),
			16, Pbind(
				\instrument, \organ_tonewheel0,
				\note, Pstep(Pseq([

					Pseq([
						2,2,3,2,2,3,2,3,
					],inf)+4,
					//0,0,7,7,
					//0,0,3,3,
				],inf),1/4),
				\ctranspose, -4,
				\octave, 6 + Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,-1,0, -2,-2,-1,-1,
					1,1,0,0, 0,1,0,1,
				],inf).stutter(4),
				\dur, 1/8,
				\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
				\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
				\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
				\isRest, Pseq([
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,1,
					1,1,0,1,
					0,1,0,1,
				],inf).coin.not,
				\amp, 0.1/1.5,
				//\isRest, true,
			),
		]),
		
	])
)).play;
);

(
// bass with sidechain
Pdef(\part, Pdef(\bass1, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([100,5004],1), 32,\exp).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\octave, 3,
			\legato, 0.8,
			\amp, 0.1 * Pseq([
				0.4,0.4,1,0.4,
			],inf)* 2,
			\out, BusDef(\basstrack, \audio),
		),
		
	])
)).play;
);
(
// drums with sidechain
Pdef(\part, Pdef(\drums1, 
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
			\out, BusDef(\kicktrack, \audio),
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
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[47].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,1,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.09 * Pseq([
				1,0.3,0.3,0.3,
			],inf),
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1634].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.09,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[851].value,
				//\bufnum, ~buflib.hat[1163].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,1,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);

(
// clean hook
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pdef(\bass1),
		Pbind( // down melo
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\octave, [4,5],
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,1,1,
				],inf),
				1,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,0,0,
				1,0,1,1, 1,0,1,1,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2 * [0.5,1],
			//\isRest, true,
		),
		Pbind( // answer
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.3,0.75],1), 5*2).loop,
			\lpf, PmodEnv(Pseq([7100,4000],1), 7*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, Pseg(Pseq([3,3].reciprocal * -1,1), 4).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.4,0.4,0.8,0.1) ],
			],inf),
			\legato, 0.51,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
					Pn(0,4), Pn(0,4),
					Pn(7,4), Pn(6,4),
					Pn(0,8),
					Pn(-1,6),0,0,
					Pn(0,4), Pn(12,4),
					Pn(7,4), Pn(6,4),
					Pn(0,8),
					Pn(-1,6),0,0,
			],inf),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0.21,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0.21,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1/2,
			//\isRest, true,
		),
	])
)).play;
);

(
// nice synthese
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pdef(\bass1),
		Pbind( // down melo
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
			],inf),1/2),
			\ctranspose, -4,
			\octave, [4,5],
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,1,1,1,
				],inf),
			],inf).coin.not,
			\amp, 0.1/2 * [0.5,1],
			//\isRest, true,
		),
		Pbind( // answer
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 5,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.3,0.75],1), 5*2).loop,
			\lpf, PmodEnv(Pseq([7100,4000],1), 7*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, Pseg(Pseq([3,3].reciprocal * -1,1), 4).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.4,0.4,0.8,0.1) ],
			],inf),
			\legato, 0.51,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				0,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Ptpar([
			8,Pbind(
				\instrument, \flutepad,
				\note, Pseq([
					Pn(0,4), Pn(0,4),
					Pn(7,4), Pn(6,4),
					Pn(0,8),
					Pn(-1,6),0,0,
					Pn(0,4), Pn(12,4),
					Pn(7,4), Pn(6,4),
					Pn(0,8),
					Pn(-1,6),0,0,
				],inf),
				\ctranspose, -4,
				\octave, 6,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.01) ],
				],inf),
				\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0.21,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0.21,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1/2,
				//\isRest, true,
			),
			32, Pbind( // down melo tail
				\instrument, \sh101,
				\note, Pstep(Pseq([

					Pseq([
						3,3,2,2,1,1,-1,-4,
					],inf)+4,
					//0,0,7,7,
					//0,0,3,3,
				],inf),1/2),
				\ctranspose, -4,
				\octave, 5,
				\dur, 1/8,
				\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
				\lpf, PmodEnv(Pseq([8100,400],1), 8*2,\exp).loop,
				\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,0,0,0,
					0,0,1,1, 0,0,1,1,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1/2,
			),
			16, Pbind(
				\instrument, \organ_tonewheel0,
				\note, Pstep(Pseq([

					Pseq([
						2,2,3,2,2,3,2,3,
					],inf)+4,
					//0,0,7,7,
					//0,0,3,3,
				],inf),1/4),
				\ctranspose, -4,
				\octave, 6 + Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,-1,0, -2,-2,-1,-1,
					1,1,0,0, 0,1,0,1,
				],inf).stutter(4),
				\dur, 1/8,
				\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
				\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
				\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
				\isRest, Pseq([
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,1,
					1,1,0,1,
					0,1,0,1,
				],inf).coin.not,
				\amp, 0.1/1.5,
				//\isRest, true,
			),
		]),
	])
)).play;
);


/////////////

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_staticdist, { arg out=0, gate=1;
	// code: 5-2GG2-I8HO
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
	thisThread.randSeed = 598584.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
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
	'mix', 0.7436974789916,
	'gain', 0.45378151260504,
	'fb', 0.0001,
	'delay', 0.0006408002744416,
	'delay2', 0.000418647728829,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.46565816979706,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 1197.6803383227,
	'hpf', 117.47286445047,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 752.76643779303,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)

		
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1546].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[22].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1426].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseg(Pseq([0.2,0.8],1),32).loop,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.7,0.3,1,
			],inf),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, BusDef(\kickfx, \audio),
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kickfx, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,1,1,1,2000],1), 8, \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([100,5004],1), 32,\exp).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\octave, 3,
			\legato, 0.8,
			\amp, 0.1 * Pseq([
				0.4,0.4,1,0.4,
			],inf)* 2,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([

				Pseq([
					2,2,3,2,2,3,2,3,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6 + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-1,0, -2,-2,-1,-1,
				1,1,0,0, 0,1,0,1,
			],inf).stutter(4) + [0,-2],
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
			\out, BusDef(\tone, \audio),
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pmono(\rdn_staticdist,
			\inbus, BusDef(\tone, \audio),
			\addAction, \addToTail,
			\delay2, PmodEnv(Pseq([0.001,0.02],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 0.45378151260504,
			'fb', 0.0001,
			'delay', 0.0006408002744416,
			'delay2', 0.000418647728829,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.46565816979706,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1197.6803383227,
			'hpf', 117.47286445047,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 752.76643779303,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1041].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
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
			\bufnum, ~buflib.clap[197].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.4,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[22].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1426].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseg(Pseq([0.2,0.8],1),32).loop,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.5,0.7,0.3,1,
			],inf),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, BusDef(\kickfx, \audio),
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kickfx, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,1,1,1,2000],1), 8, \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					-12,0,0,0,
				],3),
					-12+5,0,5,0,
				Pseq([
					-12,0,0,0,
				],3),
					-12+4,0,0,4,

			],inf) + Pstep(Pseq([
				0,0,0,0,5,5,3,3,
			],inf),1/2),
			\ctranspose, -4,
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\lpf, PmodEnv(Pseq([100,5004],1), 32,\exp).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.03,0.1],1),16), 0.1,0.2,0.05)
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\octave, 3,
			\legato, 0.8,
			\amp, 0.1 * Pseq([
				0.4,0.4,1,0.4,
			],inf)* 2,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pstep(Pseq([

				Pseq([
					2,2,3,2,2,3,2,3,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6 + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-1,0, -2,-2,-1,-1,
				1,1,0,0, 0,1,0,1,
			],inf).stutter(4) + [0,-2],
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,1,
				1,1,0,1,
				0,1,0,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\amp, 0.1/1.5,
			\out, BusDef(\tone, \audio),
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pmono(\rdn_staticdist,
			\inbus, BusDef(\tone, \audio),
			\addAction, \addToTail,
			\delay2, PmodEnv(Pseq([0.0001,0.02],1), 32,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 0.45378151260504,
			'fb', 0.0001,
			'delay', 0.0006408002744416,
			'delay2', 0.000418647728829,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.46565816979706,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 1197.6803383227,
			'hpf', 117.47286445047,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 752.76643779303,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind( // down melo
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					3,3,2,2,1,1,-1,-4,
				],inf)+4,
			],inf),1/2),
			\ctranspose, -4,
			\octave, [4,5],
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.6,0.35],1), 8*2).loop,
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 4).loop,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\amp, 0.1/2 * [0.5,1],
			//\isRest, true,
		),
		Pbind( // answer
			\instrument, \sh101,
			\note, Pstep(Pseq([

				Pseq([
					-1,-4,
				],inf)+4,
				//0,0,7,7,
				//0,0,3,3,
			],inf),1/4),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\rq, PmodEnv(Pseq([0.3,0.75],1), 5*2).loop,
			\lpf, PmodEnv(Pseq([7100,4000],1), 7*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, Pseg(Pseq([3,3].reciprocal * -1,1), 4).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.4,0.4,0.8,0.1) ],
			],inf),
			\legato, 0.51,
			\isRest, Pseq([
				Pseq([
					0,0,1,1, 0,0,1,0,
					0,0,1,0, 1,0,1,0,
					0,0,1,1, 0,0,1,0,
					0,0,1,1, 0,0,1,0,
					0,0,1,1, 0,0,1,0,
				],inf),
				0,0,0,0, 0,0,1,1,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,1,0, 1,0,1,0,
				0,1,1,1, 1,0,1,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
					Pn(0,4), Pn(0,4),
					Pn(7,4), Pn(6,4),
					Pn(0,8),
					Pn(-1,6),0,0,
					Pn(0,4), Pn(12,4),
					Pn(7,4), Pn(6,4),
					Pn(0,8),
					Pn(-1,6),0,0,
			],inf),
			\ctranspose, -4,
			\octave, 6,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 8*2).loop,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 0,0,1,0,
					1,0,0,1, 0,0,1,0,
				],8),
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1/3,
			//\isRest, true,
		),
	])
)).play;
);
