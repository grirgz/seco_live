

(
~t = 170/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
)
NoteTimeline(\bla, Pdef(\rah)).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					//-1,-1,\r,\r,
					-1,
					//-1,\r,\r,\r,
				],2*8),
				Pser([
					4,\r,\r,4, 4,4,\r,
				],8),
				Pseq([
					-1,-1,\r,\r,
				],2),
			],inf),
			\lpf, PmodEnv(Pseq([250,500,1000],1), 8).loop,
			\octave, Pseq([3,2,4,2],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1468].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0.4,0,0.4,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1468].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0.4,0,0.4,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					-1,3,6,3,
				],2*8),
				Pser([
					-1,4,8,4,
				],8),
				Pser([
					-1,3,6,3,
				],8),
			],inf),
			\octave, Pseq([4,5,7,5],inf),
			\octave, Pseq([
				Pseq([ 4,6,4,5, ],8),
				Pseq([4,5,7,5],8)
			],inf),
			\pulse, 0.8,
			\saw, 0.2,
			\lpf, 200,
			\lpadsr, Pseq([
				PpatEnv.adsr(Pseg(Pseq([0.01,0.1]),8),0.03,Pseg(Pseq([0.8,0.1]),8),0.1),
			],inf),
			\envamt, PmodEnv(Pseq([1,8],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[954].value,
			\bufnum, ~buflib.snare[1401].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				Pser([
					//-1,-1,\r,\r,
					-1,
					//-1,\r,\r,\r,
				],2*8),
				Pser([
					4,\r,\r,4, 4,4,\r,
				],8),
				Pseq([
					-1,-1,\r,\r,
				],2),
			],inf),
			\lpf, PmodEnv(Pseq([250,500,1000],1), 8).loop,
			\octave, Pseq([3,2,4,2],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1468].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[59].value,
			\bufnum, ~buflib.kick[856].value,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0,0,
				1,0,0,0,
				1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1468].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,0.4,0,0.4,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					-1,3,6,3,
				],2*8),
				Pser([
					4,8,11,8,
				],8),
				Pser([
					-1,3,6,3,
				],8),
			],inf),
			\octave, Pseq([4,5,7,5],inf),
			\octave, Pseq([
				Pseq([ 3,7,3,3, ],8),
				Pseq([ 6,6,6,5, ],8),
				Pseq([ 7,7,7,3, ],8),
			],inf),
			\pulse, 0.8,
			\saw, 0.2,
			\lpf, Pseq([
				200,300,200,200,
			],inf),
			\lpadsr, Pseq([
				PpatEnv.adsr(Pseg(Pseq([0.01,0.1]),8),0.03,Pseg(Pseq([0.8,0.1]),8),0.1),
			],inf),
			\envamt, PmodEnv(Pseq([1,8],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.1 * Pseq([
				0.5,1,0.5,0.5,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[954].value,
			\bufnum, ~buflib.snare[1401].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);
