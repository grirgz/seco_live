
~t = 85/2/60; TempoClock.default.tempo = ~t;


(
SynthDef(\bassdist, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * ( XLine.kr(4,0.1,4)-4 ).midiratio.poll;
	sig = SinOsc.ar(freq * ( SinOsc.ar( freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1) ) * 1 + 1 ));
	sig = ( sig * 5 ).distort + sig / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = LFNoise1.kr(1/2  ! sig.size) * 0.1;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bassdist,
			\note, Pseq([
				8,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,2,0, 4,0,0,0,
				3,0,0,3, 0,0,2,0,
				2,0,2,0, 4,0,0,0,
				2,0,2,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[329].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,1,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[557].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);
