// coil i don't get it
~t = 142/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("holis/synthdef.scd")

(
SynthDef(\clav, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(LFSaw.ar(freq), freq * 1.321)*0.5 + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\clav2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [SinOsc.ar(freq), LFPulse.ar(freq), LFSaw.ar(freq)]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\melo, 
	Pbind(
		\instrument, \clav,
		\amp, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
	)
)
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				9,9-12,\r,8, 8-12,\r,1,1-12,
				9,9-12,\r,8, 8-12,\r,1,1-12,
				8,8-12,\r,6, 6-12,\r,1,1-12,
				8,8-12,\r,6, 6-12,\r,1,1-12,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			//\isRest, true,
		),
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				\r,1,3,6, 8,6,8,\r,
				\r,1,3,6, 8,6,8,\r,
				\r,1,3,5, 6,5,6,\r,
				\r,1,3,5, 6,5,6,\r,

				\r,1,3,6, 8,6,3,\r,
				\r,1,3,6, 8,6,3,\r,
				\r,1,2,5, 6,5,2,\r,
				\r,1,2,5, 6,5,2,\r,
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				-4,-3,0,1, 3,6,11,8,
				-4,-3,0,1, 3,6,11,8,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,5,
			],inf),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1,
		),

		
	])
)).play;
);



/////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				Pser([
					8,3+12,
				],16),
				Pser([
					9,13,
				],16),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				0,3,10,3,0,10,\r,3,
				0,3,10,3,0,10,\r,3,
				1,6,13,6,1,13,\r,6,
				1,6,13,6,1,13,\r,6,
			],inf),
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
			\instrument, \clav,
			\note, Pseq([
				Pser([
					8,3+12,
				],8*3),
				Pser([
					0,3+12,
				],8),
				Pser([
					9,13,
				],8*3),
				Pser([
					6,13,
				],8*1),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				Pseq([
					0,3,10,3,0,10,\r,3,
					0,3,10,3,0,10,\r,3,
				],2),
				Pseq([
					1,6,13,6,1,13,\r,6,
					1,6,13,6,1,13,\r,6,
				],2),
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clav2,
			\note, Pseq([
				Pser([
					
				\r,\r,1,\r,\r,10,0, 10,3,10,\r,
				\r, 0-12,\r,10-12, \r,   \r,3+12,8+12,\r,
				\r,\r,\r,
				\r,1,\r,\r,\r,\r,10,0, 10,3,10,\r,\r,\r,\r
				],32),
			],inf),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\octave, 6,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				Pser([
					8,\r,
					0,\r,
				],8*3),
				Pser([
					\r,\r
				],8),
				Pser([
					6,\r,
					0,\r,
				],8*3),
				Pser([
					\r,\r
				],8*1),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clav,
			\note, Pseq([
				Pseq([
					0,3,10,3,0,10,\r,3,
					0,3,10,3,0,10,\r,3,
				],2),
				Pseq([
					1,6,13,6,1,13,\r,6,
					1,6,13,6,1,13,\r,6,
				],2),
			],inf),
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clav2,
			\note, Pseq([
				Pser([
					
				\r,\r,1,\r,\r,10,0, 10,3,10,\r,
				\r, 0-12,\r,10-12, \r,   \r,3+12,8+12,\r,
				\r,\r,\r,
				\r,1,\r,\r,\r,\r,10,0, 10,3,10,\r,\r,\r,\r
				],32),
			],inf),
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 6,
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \chordo2,
			\lpfr, 3.0999999046326,
			\rq, 0.5,
			\legato, 0.1,
			\hpf, 1000.0,
			\note, Pseq([
				[0,10,3] +.x [0,12],
				[1,6,13] +.x [0,12],
			],inf).stutter(2),
			\strum, 0.01+Pwhite(0,0.1,inf),
			\dur, 2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \organ,
			\lpfr, 1.1000000238419 * Pseg(Pseq([1,4],inf),8),
			\rq, 0.5,
			\note, Pseq([
				Pseq([
					0,3,10,3,0,10,\r,3,
					0,3,10,3,0,10,\r,3,
				],2),
				Pseq([
					1,6,13,6,1,13,\r,6,
					1,6,13,6,1,13,\r,6,
				],2),
			],inf),
			\legato, 0.3,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clav2,
			\oscmix, ~pmodenv.(Pseq([1,2,1,4],1), 1/8).loop,
			\note, Pseq([
				0,5,8,10,
				1,13,6,5,
			],inf) + [0,-12*1],
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]+1,1), 1/4).loop,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \organ,
		\amp, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
	)
)
);
