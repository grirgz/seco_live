
~t = 245/4/60; TempoClock.default.tempo = ~t;

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
			\isRest, true,
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
