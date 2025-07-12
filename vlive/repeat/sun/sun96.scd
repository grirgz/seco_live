
// try to make zero-k music

~t = 171/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1362].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1576].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1620].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.10/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					2,0,
				],12),
				//Pser([ 5,\r, ],4),
				Pser([ \r,\r, ],4),
				//Pser([
					//2,0,
				//],12),
				//Pser([ 7,\r, ],4),
			],inf),
			\ctranspose, -3,
			\octave, 3,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1362].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1576].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1620].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				//1,1,1,1, 1,1,1,1,
				//1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.10/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					-1,11,
				],16),
				Pser([
					-7,-7+12,
				],8),
				Pser([
					-6,-6+12,
				],8),
				//Pser([ 5,\r, ],4),
				//Pser([ \r,\r, ],4),
				//Pser([
					//2,0,
				//],12),
				//Pser([ 7,\r, ],4),
			],inf),
			\octave, 3,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1362].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1576].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1620].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				//1,1,1,1, 1,1,1,1,
				//1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.10/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					-1,11,
				],16),
				Pser([
					-7,-7+12,
				],8),
				Pser([
					-6,-6+12,
				],8),
				//Pser([ 5,\r, ],4),
				//Pser([ \r,\r, ],4),
				//Pser([
					//2,0,
				//],12),
				//Pser([ 7,\r, ],4),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					5,6,\r,
				],8),
				Pser([
					5,6,\r,
				],8),
				Pser([
					5,6,\r,
				],16),
				Pser([
					\r,5,6,
				],16),
			],inf),
			\octave, 6,
			\lpf, PmodEnv(Pseq([400,7500],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Prand([
				Pser([
					5,6,\r,
				],8),
				Pser([
					5,6,\r,
				],8),
				Pser([
					5,6,\r,
				],16),
				Pser([
					\r,5,6,
				],16),
			],inf),
			\lpf, PmodEnv(Pseq([100,1500],1), 8).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ -1 ],8),
				Pser([ -1-12 ],1),
				Pser([ -1 ],8),
				Pser([ 6,5, ],2),
			],inf),
			\lpf, PmodEnv(Pseq([100,5000],1), 8).loop,
			\octave, 7,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(note:3,octave:6,parent:Event.default).use { ~freq.value }
(note:3,octave:6).use { ~freq.value }
(note:3,octave:6).use { ~freq.value }
Event.default.use { kk<  }
[(note:3,octave:6),(note:7,octave:5)].do { arg x; x.parent = Event.default; x.use { ~freq.value.postln } }
[(degree:3,octave:6),(degree:7,octave:5)].do { arg x; x.parent = Event.default; x.use { ~freq.value.postln } }
[(degree:3,octave:6),(degree:7,octave:5)].do { arg x; x.parent = Event.default; x[\freq].valueWithEnvir(x).postln }
[(degree:3,octave:6),(degree:7,octave:5)].do { arg x; x.parent = Event.default; x[\freq].postln }
3.degreeToFreq()
Scale.major.degreeToFreq(3,0.midicps,6)
Scale.major.degreeToFreq(0,60.midicps,1)
valueEnvir
