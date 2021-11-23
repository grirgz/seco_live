
/// kick shhhh-snare
~t = 145/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\shipy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( LFCub.ar(freq/2 + \amt.kr) * \amt.kr(0) + 1 )) * LFCub.ar(\ffac.kr(1) * freq) ;
	sig = SinOsc.ar(freq * Rand(1,1.001!70) * ( SinOsc.ar(freq *\ffac.kr) * \amt.kr + 1 )).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[281].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\lpf, ~pmodenv.(Pseq([Pexprand(70,10000,2)],1), 1).loop,
			\legato, Pseq([
				0,3,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \shipy,
			\note, Pseq([
				0,
			],inf),
			\ffac, ~pmodenv.(Pseq([1,0.0],1), 1).loop,
			\amt, ~pmodenv.(Pseq([0,3],1), 1).loop,
			\octave, 3,
			\legato, Pseq([
				0,0,0,0,
				0,3,0,0, 0,0,0,0,
				0,0,2,0, 
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1858].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([1,0.4],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[281].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\lpf, ~pmodenv.(Pseq([Pexprand(70,300,2)],1), 1).loop,
			\legato, Pseq([
				0,6,0,0, 0,0,0,3,
				0,0,2,0, 0,0,0,0,
			]*0.9,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \shipy,
			\note, Pseq([
				0,
			],inf),
			\ffac, ~pmodenv.(Pseq([1,0.0],1), 1).loop,
			\amt, ~pmodenv.(Pseq([0,3],1), 1).loop,
			\octave, 5,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1858].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,0,0,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([1,0.4],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[281].value,
			\isRest, Pseq([
				1,1,1,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,-1,
			],inf).stutter(8),
			\octave, 3,
			\lpf, ~pmodenv.(Pseq([Pexprand(70,300,2)],1), 1).loop,
			\legato, Pseq([
				0,0,0,0, 0,0,0,3,
				0,0,2,0, 0,0,0,0,
			]*0.9,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \shipy,
			\note, Pseq([
				0,
			],inf),
			\ffac, ~pmodenv.(Pseq([0.2,0.2,1,1.0],1), 1/4).loop,
			\amt, ~pmodenv.(Pseq([0,3],1), 1).loop,
			\octave, 4,
			\legato, Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1858].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			\isRest, Pseq([
				1,0,1,0, 1,1,1,0, 
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([1,0.4],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\seq1, 
	Pseq([
		Pfindur(2, Pdef(\zedpart1)),
		Pfindur(2, Pdef(\zedpart2)),
		Pfindur(2, Pdef(\zedpart3)),
		
	])
)).play;
);
