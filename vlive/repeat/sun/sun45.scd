~t = 200/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("holis/synthdef.scd");
(
	~chanOpener = { arg door, array;
		array * ( door - ((0..array.size-1)/(array.size) ).postln * array.size ).clip(0,1);
	};
SynthDef(\fullerchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var chord = \chord.kr( ( [0,3,7,10,14,17] +.x ( 12 * (0..6) ) ) ).midiratio;
	sig = chord.collect { arg tone;
		var isig;
		isig = LFSaw.ar(freq * tone * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1));
		isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * tone ).clip(20,20000), \rq.kr(0.5));
		isig;
	};
	sig = ~chanOpener.( Line.ar(0,1,40), sig );
	sig = sig.mean * 4.4;
	//sig = sig.flat * 1.10;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\bassfmenkor_env, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig = SinOsc.ar(freq * \freqfac1.kr(1) * ( SinOsc.ar(freq * \freqfac2.kr(1) * ( LFNoise1.ar(0.1) * (1..10)* \fma2.kr(1) + 1 ))  * \fma1.kr(1)*lfo1 + 1 ));
	sig = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig * \fma3.kr(4) + 1 ));
	sig = SinOsc.ar(freq * ( sig * \fma4.kr(0.8) * lfo2 + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bass_fmek, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
	// fela
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\velo, Pseq([
				0,1,4,1, 4,1,0,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\legato, 1/4 * Pseq([
				1,1,4,1, 4,1,1,1,
				1,1,1,1, 4,1,1,1,
			],inf),
			\bufnum, Pfunc({ arg ev;
				~buflib.hat[1360 + ev[\velo]].value
			}),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	// mosdef
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\velo, Pseq([
				0,1,3,3, 1,3,0,1,
				1,1,3,3, 1,1,1,1,
			],inf),
			\legato, 1/2 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\bufnum, Pfunc({ arg ev;
				~buflib.hat[1360 + ev[\velo]].value
			}),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,1,0,0,
				0,0,1,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);



///////// draft

(
	~swing = 0.1; // bof bof
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\velo, Pseq([
				0,1,3,3, 1,3,0,1,
				1,1,3,3, 1,1,1,1,
			],inf),
			\legato, 1/2 * Pseq([
				1,1,1,2, 1,1,2,1,
				1,1,1,1, 4,1,1,1,
				1,1,1,3, 1,1,2,1,
				1,1,1,1, 4,1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\bufnum, Pfunc({ arg ev;
				~buflib.hat[1360 + ev[\velo]].value
			}),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,1,0,0,
				0,0,1,1, 0,0,0,1,
				0,0,1,1, 0,1,1,0,
				0,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bassfmenkor_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma1, 1,
			\fma2, 1,
			\fma4env, Pseq([
				[ Env([4,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
				//[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(30),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma3, 1,
			\fma4, 1,
			\freqfac1, 1,
			\freqfac2, 1,
			\freqfac3, 1,
			\legato, 0.4,
			\octave, 3,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 7,0,4,0,
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1/2,
			\isRest, true,
		),
		
	])
)).play;
);


/////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\velo, Pseq([
				0,1,3,3, 1,3,0,1,
				1,1,3,3, 1,1,1,1,
			],inf),
			\legato, 1/2 * Pseq([
				1,1,1,2, 1,1,2,1,
				1,1,1,1, 4,1,1,1,
				1,1,1,3, 1,1,2,1,
				1,1,1,1, 4,1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\bufnum, Pfunc({ arg ev;
				~buflib.hat[1360 + ev[\velo]].value
			}),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,1,0,0,
				0,0,1,1, 0,0,0,1,
				0,0,1,1, 0,1,1,0,
				0,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pseq([
			Pbind(
				\legato, 0.1,
				\note, Pseq([
					1,0,0,3, 0,0,0,0,
					0,0,0,0, 7,0,4,0,
				],inf),
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,0,
				],1).coin.not,
			),
			Pbind(
				\note, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 7,0,4,0,
				],inf),
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 1,0,1,0,
				],1).coin.not,
			),
			//Pbind(

				//\legato, Pseq([
					//1,0,0,1, 0,0,1,0,
					//1,0,0,0, 0,0,0,1,
					//1,0,0,1, 0,0,1,0,
					//1,0,0,0, 1,0,1,0,
				//],1).collect({ arg x; x.linlin(0,1,0.1,1) }).coin.not,
				//\note, Pseq([
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 7,0,4,0,
				//],inf),
				//\isRest, Pseq([
					//1,0,0,1, 0,0,1,0,
					//1,0,0,0, 0,0,0,1,
					//1,0,0,1, 0,0,1,0,
					//1,0,0,0, 1,0,1,0,
				//],1).coin.not,
			//),
		],inf)<>
		Pbind(
			\instrument, \bassfmenkor_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.2) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma1, 1,
			\fma2, 1,
			\fma4env, Pseq([
				[ Env([4,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
				//[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(30),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma3, 20,
			\fma4, 12,
			\freqfac1, 2,
			\freqfac2, 1,
			\freqfac3, 1/2,
			\legato, 0.9,
			\octave, 3,
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 7,0,4,0,
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\melo, 

		Pbind(
			\instrument, \bassfmenkor_env,
			\note, Pseq([
				Ppatlace([0,0,0,Pseq((1..6),inf).stutter(8)],inf),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma1, 1,
			\fma2, 1,
			\fma4env, Pseq([
				[ Env([4,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
				//[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(30),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma3, 1,
			\fma4, 1,
			\freqfac1, 1,
			\freqfac2, 1,
			\freqfac3, 1,
			\legato, 0.4,
			\isRest, Pseq([
				1,0,0,1, 1,0,0,0,
				1,1/2,1/2,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
			\isRest, true,
		),
);
)
ProtoDef(\piano).startControl(Pdef(\melo))



///////////////////////////////::



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2311].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,1,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\velo, Pseq([
				0.8, 1, 0.6, 1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5 * Pkey(\velo),
			\gain, 0.11 * Pkey(\velo),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[52].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[53].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1834].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,0,0,1, 1,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,1,1,
				1,1,0,0, 0,0,1,0,
				0,0,1,0, 1,0,1,1,
			],inf)/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[409].value,
			\bufnum, ~buflib.kick[1474].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1.1,
		),
		
	])
)).play;
);


///////////////////



(
Pdef(\melo, 

		Pbind(
			\instrument, \basicbass,
			\lpf, 5000,
			\amp, 0.02,
		),
);
)

ProtoDef(\piano).startControl(Pdef(\melo))


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/weststreet.flac'),
			\pos, 12.84,
			\pos, 14.5,
			\dur, 1/4,
			\legato, 1,
			\legato, Pseq([
				6,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/weststreet.flac'),
			\pos, 12.84,
			\pos, 10.5,
			\dur, 1/4,
			\legato, 1,
			\legato, Pseq([
				6,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/weststreet.flac'),
			\pos, 12.84,
			\pos, 11.5,
			\dur, 1/4,
			\legato, 1,
			\legato, Pseq([
				7,0,0,0, 0,0,0,1,
				4,0,0,0, 1,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1394].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1422].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1422].value,
			\bufnum, ~buflib.hat[948].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				1,1,1,1, 0,0,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1536].value,
			\bufnum, ~buflib.snare[559].value,
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/weststreet.flac'),
			\pos, 12.84,
			\pos, 11.5,
			\dur, 1/4,
			\legato, 1,
			\legato, Pseq([
				6,0,0,0, 0,0,0,1,
				3,0,0,0, 1,0,2,0,
				7,0,0,0, 0,0,0,1,
				4,0,0,0, 1,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\inbus, BusDef(\ifx1, \audio),
			\instrument, \fx_env,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 1,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,1,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1394].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1422].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1422].value,
			\bufnum, ~buflib.hat[948].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				1,1,1,1, 0,0,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[559].value,
			\bufnum, ~buflib.snare[1536].value,
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/weststreet.flac'),
			\pos, 12.84,
			\pos, 11.5,
			\pos, Pseq([
				Pseg(Pseq([0,1]+11.5,1),8),
				Pseg(Pseq([0,1]+13.5,1),8),
			],inf),
			\dur,1,
			\legato, Pseq([
				1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\inbus, BusDef(\ifx1, \audio),
			\instrument, \fx_env,
			\legato, Pseq([
				Pseq([
					1,1,1,1, 4,0,0,0,
				],1)*0.5,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				2,0,2,0, 1,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,1,0, 2,0,2,0,

				1,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1394].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1422].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1422].value,
			\bufnum, ~buflib.hat[948].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				1,1,1,1, 0,0,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[559].value,
			\bufnum, ~buflib.snare[1536].value,
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
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/weststreet.flac'),
			\pos, 12.84,
			\pos, 11.5,
			\pos, Pseq([
				Pseg(Pseq([0,1]+11.5,1),8),
				Pseg(Pseq([0,1]+13.5,1),8),
			],inf),
			\dur,1,
			\legato, Pseq([
				1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\inbus, BusDef(\ifx1, \audio),
			\instrument, \fx_env,
			\legato, Pseq([
				Pseq([
					1,1,1,1, 4,0,0,0,
				],1)*0.5,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				2,0,2,0, 1,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,1,0, 2,0,2,0,

				1,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1417].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.25,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2435].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				//Pseq([
					//0.2,
				//],8*12),
				Pseq([
					0.2, 0.2, 0.2, 0.2,
					1,1,1,1, 1,0.1,0.1,0.1,
					0.9,
				],8*4),
			],inf) * Pseq([
				0.8,0.8,0.8,0.8, 1,0.8,0.8,0.8,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,1,1,0, 1,0,0,1,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				0.7,0.7,0.7,0.7, 1,0.7,0.7,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1433].value,
			\bufnum, ~buflib.hat[751].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					1,0,1,0, 1,0,1,0, 
				],8),
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0,1, 1,0,1,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,0,0, 

				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.51,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			],1),8).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0.5,0.5,0.5, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0,0,0,0, 0,1,1,1, 
				1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, 1,
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+4,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,1,0,1, 0.5,0.5,0.5,0.5,
					1,1,0,1, 0.5,0.5,0.5,0.5,
					0,0,1,0, 0.5,0.5,0.5,0.5,
					1,1,0,1, 0.5,0.5,0.5,0.5,
				],8),
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				//0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),

			\dur, 1/8,
			\gain, 1/4,
		),
		Pfindur(32, Pmono(\fullerchord,
			\chord, Pseq([
				[ [ 3,2,0 ] +.x ( 12 * (0..6) ) ]
				
			],inf),
			\fspread, ~pmodenv.(Pseq([0.00001,0.001,0.002,0.1],11), 8).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4,1,12],11), 8).loop,
			\note, Pseq([
				Pstep(Pseq([0,-3],inf),8),
			],inf),
			\octave, 2,
			\dur, 1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		)).loop,
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-TO1F-2T6R", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.25210084033613,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.60466190090704,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.96204032710648,
	'pitchlag', 1.0,
	'pitchmix', 0.82773109243697,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
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
).keep(1));

);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bassfmenkor_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				Pstep(Pseq([
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([1,0.7,4],[0.1,2.8]) ],
				],inf),2),
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
			],inf),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma1, 0,
			\fma2, 0,
			\fma3, 0.1,
			\fma4, ~pmodenv.(Pseq([2,2,8,2,1,4,1],1), 1/4).loop,
			//\fma4, 1.4,
			\freqfac3, ~pmodenv.(Pseq([1,2,8,1,2,8,1,2],inf), 1/4, 1, \step).loop,
			\freqfac2, 1,
			\freqfac1, 1,
			\legato, 0.4,
			\octave, 3,
			\note, Pseq([
				Pstep(Pseq([0,-2,-4,1],inf),1),
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bass_fmek,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				Pstep(Pseq([
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([1,0.7,4],[0.1,2.8]) ],
				],inf),2),
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
			],inf),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma1, 0.1,
			\fma2, 0.1,
			\fma3, 0.2,
			\fma4, ~pmodenv.(Pseq([2,2,8,2,1,4,1],1), 1/4).loop,
			//\fma4, 1.4,
			\freqfac3, ~pmodenv.(Pseq([1,2,8,1,2,8,1,2],inf), 1/4, 1, \step).loop,
			\freqfac2, 1,
			\freqfac2, ~pmodenv.(Pseq([1,1/2,4],inf), 1, 1, \step).loop,
			\freqfac1, 1,
			\freqfac1, ~pmodenv.(Pseq([1,1/2,4],inf), 1, 1, \step).loop,
			\legato, 0.4,
			\octave, 3,
			\note, Pseq([
				Pstep(Pseq([0,-2,-4,1],inf),1),
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\fx1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bass_fmek2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				Pstep(Pseq([
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([1,0.7,4],[0.1,2.8]) ],
				],inf),2),
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
			],inf),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma1, 0.1,
			\fma2, 0.1,
			\fma3, 0.2,
			\fma4, ~pmodenv.(Pseq([2,2,8,2,1,4,1],1), 1/4).loop,
			//\fma4, 1.4,
			\freqfac3, ~pmodenv.(Pseq([1,2,8,1,2,8,1,2],inf), 1/4, 1, \step).loop,
			\freqfac2, 1,
			\freqfac2, ~pmodenv.(Pseq([1,1/2,4],inf), 1, 1, \step).loop,
			\freqfac1, 1,
			\freqfac1, ~pmodenv.(Pseq([1,1/2,4],inf), 1, 1, \step).loop,
			\legato, 0.4,
			\octave, 3,
			\note, Pseq([
				Pstep(Pseq([0,-2,-4,1],inf),1),
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\fx1, \audio),
		),
		
	])
)).play;
);

(
SynthDef(\bass_fmek2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var sigo;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig1 = SinOsc.ar(freq * \freqfac1.kr(1) * ( LFNoise1.ar((1..10)*\noisefreqfac.kr(0.1)) * \fma1.kr(1) + 1 ));
	sig2 = SinOsc.ar(freq * \freqfac2.kr(1) * ( sig1 * \fma2.kr(1)*lfo1 + 1 ));
	sig3 = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig2 * \fma3.kr(4) + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * \fma4.kr(0.8) * lfo2 + 1 ));
	sig = sig4;
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig1 = Ringz.ar(sig, freq * 2) * 0.002;
	sig2 = Ringz.ar(sig, freq ) * 0.002;
	sig3 = MidEQ.ar(sig, 100 + freq / 2, rq:0.5, db:14);
	sig = sig1 + sig2 + sig;
	sig = sig3;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bass_fmek2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				Pstep(Pseq([
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([4,1,1],[0.01,0.8]) ],
					[ Env([1,0.7,4],[0.1,2.8]) ],
				],inf),2),
				//[ Env([2,1,1],[0.01,0.8]) ],
				//[ Env([2,1,1],[0.1,0.8]) ],
			],inf),
			//\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma1, 0.1,
			\fma2, 0.1,
			\fma3, 0.2,
			\fma4, ~pmodenv.(Pseq([2,2,8,2,1,4,1],1), 1/4).loop,
			//\fma4, 1.4,
			\freqfac3, ~pmodenv.(Pseq([1,2,8,1,2,8,1,2],inf), 1/4, 1, \step).loop,
			\freqfac2, 1,
			\freqfac2, ~pmodenv.(Pseq([1,1/2,4],inf), 1, 1, \step).loop,
			\freqfac1, 1,
			\freqfac1, ~pmodenv.(Pseq([1,1/2,4],inf), 1, 1, \step).loop,
			\legato, 0.4,
			\octave, 3,
			\note, Pseq([
				Pstep(Pseq([0,-2,-4,1],inf),1),
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vbreaks/Funk Brothers - Home Cookin.wav'),
			\legato, 1/2,
			\st, 110/2/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				3, 7,
			],1),4).loop / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0,
				0,0,1,1,
				0,0,1,0,
				0,0,1,0,
				0,1,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 1/4,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Igor Bril - Street Without End.wav'),
			\legato, Pseq([
				0.5,0.2,0.2, 0.5,0.2,0.2, 0.5,0.2,
			],inf),
			\st, 272/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+4,1),2).loop / Pkey(\st),
			\pos, Pseq([
				2.4,1.4, 2.4,1.4,
				2.4,1.4, 2.6,1.4,
				2.4,1.4, 2.4,1.4,
			],inf) / Pkey(\st),
			\isRest, Pseq([
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				Pseq([
					1,1,
				],8),
				//1,0.7,0.9,0.6, 1,0.7,0.9,0.6,
				//0.3,0.3,0.3,0.3, 0.3,0.9,0.9,0.9, 
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),

			\dur, 1/8,
			\gain, 1/4 * Pseq([
				1,1,1,1, 0.51,0.51,1,1,
				1,0.5,1,0.51, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0.1,0.1, 0.1,1,1,1,

				1,1,1,1, 0.51,0.51,1,1,
				1,0.1,1,0.51, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,0.1,1.0, 0.5,1,0.51,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		
	])
)).play;
);

(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
}).play
);
{ SoundIn.ar([0,1]) }.play
Ndef(\soundin).play(0,2)
Ndef(\soundin).edit;
