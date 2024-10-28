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
SynthDef(\bassfmenkor, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/10) * 100; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	sig = SinOsc.ar(freq  * ( SinOsc.ar(freq * 1/4 * ( LFNoise1.ar(0.1) * (1..10)*100*1 + 1 ))  * 10*lfo1 + 1 ));
	sig = SinOsc.ar(freq * ( sig * 24 + 1 ));
	sig = SinOsc.ar(freq * ( sig * 0.2 + 1 ));
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
			\gain, 0.2,
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


NoteTimeline(\sun45melo1).edit


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
				1,0,0,0, 0,0,0,0,
				3,0,0,1, 1,0,1,0,
				8,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,1,0,
				6,0,0,0, 0,0,0,1,
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 1,0,1,1,
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 0,1,0,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,1,0,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3 * Pseq([ Pwhite(0.8,1,1), Pwhite(0.6,1,1) ],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		
	])
)).play;
);

Pdef(\part).clear;

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
				Pstep(Pseq([0,-1,-2,-4],inf),1),
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				3,0,0,1, 1,0,1,0,
				8,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,1,1,0,
				6,0,0,0, 0,0,0,1,
				8,0,0,0, 0,0,0,0,
				4,0,0,0, 1,0,1,1,
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			//\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1568].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1131].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,1,1,
				0,0,0,0, 1,0,1,0,
				1,0,1,0, 0,1,0,0, 
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 0,1,0,0,
				0,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3 * Pseq([ Pwhite(0.8,1,1), Pwhite(0.6,1,1) ],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1124].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		
	])
)).play;
);



////////////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1492].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx1, \audio),
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1492].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[632].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[978].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.09,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 4,
		),
		
	])
)).play;
);

(
SynthDef(\chaosecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(10);
	sig = in;
	sig = 18.collect { arg idx;
		//DelayL.ar(sig, 1/~t, ( ( idx+1 ) * 0.4 ).postln / ~t);
		DelayL.ar(sig, 4/~t, ( ( idx+1 ) * 0.2.rand ).postln / ~t);
	} + sig;
	sig = sig.sum;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\chaosecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(SampleRate.ir * 1/8/~t,2).clear;
	var loop=1, pos=0, trigger=1, speed=1;
	sig = in;
	RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:0.5, run:1, loop:1, trigger:1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	// cool sound
SynthDef(\chaosecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(SampleRate.ir * 1/8/~t,2).clear;
	var loop=1, pos=0, trigger=1, speed=1;
	sig = in;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, 0.1 * ( SinOsc.ar(0.1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) );
		isig = Limiter.ar(isig);
		isig;
	});

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	// cool sound
SynthDef(\chaosecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(SampleRate.ir * 1/8/~t,2).clear;
	var loop=1, pos=0, trigger=1, speed=1;
	sig = in;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.99) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, 0.2 * ( SinOsc.ar(1.1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) );
		isig = Limiter.ar(isig);
		isig;
	});

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	// cool sound
SynthDef(\chaosecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(SampleRate.ir * 1/8/~t,2).clear;
	var loop=1, pos=0, trigger=1, speed=1;
	sig = in;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.99) ) + sig;
	
		isig = DelayL.ar(isig, 0.1, ( 0.2 * ( SinOsc.ar(48.1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) ).poll );
		isig = Limiter.ar(isig);
		isig;
	});

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	// LFNoise
SynthDef(\chaosecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(SampleRate.ir * 1/8/~t,2).clear;
	var loop=1, pos=0, trigger=1, speed=1;
	sig = in;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.99) ) + sig;
	
		isig = DelayL.ar(isig, 0.2, ( 1/4 * ( LFNoise1.ar(1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) * ( LFSaw.ar(1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) ).poll );
		isig = FreqShift.ar(isig,1);
		isig = Limiter.ar(isig);
		isig;
	});

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	// cyber
SynthDef(\chaosecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(SampleRate.ir * 1/8/~t,2).clear;
	var loop=1, pos=0, trigger=1, speed=1;
	sig = in;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.99) ) + sig;
	
		isig = DelayL.ar(isig, 0.2, ( \delay.kr(1/4) * ( LFNoise1.ar(1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) * ( LFSaw.ar(1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) ) );
		isig = FreqShift.ar(isig,1);
		isig = Limiter.ar(isig);
		isig;
	});

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pstep(Pseq([
				0,3,1,7,
			],inf),1/2),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1492].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[632].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[978].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.09,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bassfmenkor,
			\note, Pstep(Pseq([
				0,3,1,7,
			],inf),1/2),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				Pseg(Pseq([1,4],inf),8),
			],1),
			\amp, 0.1/4,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1492].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[632].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[978].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.09,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 4,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\chords, 
	Ppar([
		Pbind(
			\instrument, \bassfmenkor,
			\note, Pseq([
				[ 1,6,-12+1 ],
				[ 0,6, -12 ],
			],inf),
			\strum, Pwhite(0.01,0.2),
			\octave, 5,
			\dur, 1,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \bassfmenkor,
			\note, Pseq([
				\r,\r,\r,\r,10,
				\r,\r,\r,\r,12,
				\r,10,12+3,
				
				Prand([
					Pseq([
						12+4,
					],1),
					Pseq([
						\r,\r,\r,\r,
					],1),
					Pseq([
						\r,
					],1),
				],1),
				12+1,
				Prand([
					Pseq([
						\r,\r,\r,\r,12+6,
					],1),
					Pseq([
						\r,\r,\r,\r,
					],1),
					Pseq([
						\r,
					],1),
				],1),
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1492].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[632].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[978].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.09,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 4,
		),
		Pmono(\chaosecho_noise,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\mix, 0.49,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 2,
			\out, BusDef(\ifxcomp, \audio),
		),
		Pmono(\fx_simplecompander,
			\inbus, BusDef(\ifxcomp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(\out, BusDef(\ifx2, \audio)) <>
		Pdef(\chords),
		Pbind(
			\instrument, \wouchgen,
			\dur, 2,
			\sustain, 2,
			\hplevels, [[1,2000]],
			\hpsustain, 2/~t,
			\lpsustain, 6/~t,
			\adsr, Pseq([
				[ Env.adsr(2/~t,0.1,0.8,0.4,1,[5,0,-8]) ],
			],inf),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);


Pmono(
	{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
		var sig;
		sig = $1SinOsc.ar(freq);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}.asDefName,
	\note, Pseq([
		0,
	],inf),
	\octave, 5,
	\dur, 1/8,
	\amp, 0.1,
);


(
Ndef(\zed, { arg freq=39, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var time=32/~t;
	env1 = XLine.kr(1,12000,time);
	env2 = XLine.kr(1000,0.02,time);
	freq = XLine.kr(10,1000,time);
	sig = SinOsc.ar(freq * ( SinOsc.ar(4*~t * ( SinOsc.ar(env2 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * env1 + 1 ));
	sig = sig + SinOsc.ar(freq/2 * ( SinOsc.ar(4.01*~t * ( SinOsc.ar(env2 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * env1 + 1 ));
	sig = sig + SinOsc.ar(env2 * ( SinOsc.ar(4.01*~t * ( SinOsc.ar(env2 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * env1 + 1 ));
	sig = sig + SinOsc.ar(freq*2 * ( LFPulse.ar(env1 * ( SinOsc.ar(env2 * ( SinOsc.ar(1/8) * 100 + 1 )) * 10 + 1 )) * env1 + 1 ));
	sig = CombL.ar(sig, 4/~t, 1/3/~t * ( SinOsc.kr(0.01) * 0.31 + 1 ),1/~t) + sig;
	sig = CombL.ar(sig, 4/~t, 1/3/~t * ( SinOsc.kr(0.02) * 0.31 + 1 ),1/~t) + sig;
	sig = sig / 4;
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = Pan2.ar(sig, pan, amp);
}).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1492].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[632].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[978].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\chaosecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.09,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 4,
		),
		Pmono(\chaosecho_noise,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\mix, 0.49,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 2,
			\out, BusDef(\ifxcomp, \audio),
		),
		Pmono(\fx_simplecompander,
			\inbus, BusDef(\ifxcomp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			//\isRest, true,
		),
		Pbind(\out, BusDef(\ifx2, \audio)) <>
		Pdef(\chords),
		Pbind(
			\instrument, \wouchgen,
			\dur, 2,
			\sustain, 2,
			\hplevels, [[1,2000]],
			\hpsustain, 2/~t,
			\lpsustain, 6/~t,
			\adsr, Pseq([
				[ Env.adsr(2/~t,0.1,0.8,0.4,1,[5,0,-8]) ],
			],inf),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\delcolecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var bufnum = LocalBuf(10);
	sig = in;
	sig = 18.collect { arg idx;
		//DelayL.ar(sig, 1/~t, ( ( idx+1 ) * 0.4 ).postln / ~t);
		DelayL.ar(sig, 4/~t, ( ( idx+1 ) * 0.2.rand ).postln / ~t);
	} + sig;
	sig = sig.sum;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
	// LFNoise
SynthDef(\chaosecho_noise, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.99) ) + sig;
	
		isig = DelayL.ar(isig, \maxdelay.kr(0.2), ( \delay.kr(1/4/~t) * ( LFNoise1.ar(1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) * ( LFSaw.ar(1 * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ) ).poll );
		isig = FreqShift.ar(isig,1);
		isig = Limiter.ar(isig);
		isig;
	});

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\chords, 
	Ppar([
		Pbind(
			\instrument, \bassfmenkor,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						[ 1,[5,6].choose,[8,10].choose,[12,12+3].choose ],
						[ 0,5,[8,10,9].choose,[12,12+3].choose ],
					],1)
				}),
			],inf),
			\lag, Pseq([
				Prout({ arg ev;
					var tmp = 0;
					var res = List[];
					4.do { arg item, idx;
						tmp = tmp + exprand(0.1,0.4);
						res.add(tmp);
					};
					res.as(Array).yield
					//[0,0.1,0.2,0.3]
				}).trace,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.3) ],
			],inf),
			\legato, 0.4,
			\octave, 5,
			\dur, 2,
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
SynthDef(\wouchgen, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env(\hplevels.kr([1,4000]), [ \hpsustain.kr(3) ],-3), 1);
	env2 = EnvGen.kr(Env(\lplevels.kr([20000,8000]), [ \lpsustain.kr(1) ],-3), 1);
	sig = BrownNoise.ar*4;
	//sig = LFNoise1.ar(env1);
	sig = HPF.ar( sig, env1 );
	sig = LPF.ar( sig, env2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \wouchgen,
			\dur, 2,
			\sustain, 1.1,
			\hpsustain, 2,
			\lpsustain, 6,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,0.8,1,[5,0,-8]) ],
			],inf),
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
			\bufnum, ~buflib.kick[1492].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[632].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[978].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\delcolecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.09,
			\delay, 1/3/~t,
			\fb, 0.99,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\lag, 0.0009,
			\dur, 4,
		),
		Pmono(\chaosecho_noise,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\mix, 0.49,
			\fmr, Pseq([1,2,1/4],inf)*~t,
			\delay, 1/~t,
			\maxdelay, 1/~t,
			\fb, 1,
			\lag, 0.0009,
			\dur, 2,
			\out, BusDef(\ifxcomp, \audio),
		),
		Pmono(\fx_simplecompander,
			\inbus, BusDef(\ifxcomp, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(\out, BusDef(\ifx2, \audio)) <>
		Pdef(\chords),
		Pbind(
			\instrument, \wouchgen,
			\dur, 2,
			\sustain, 2,
			\hplevels, [[1,2000]],
			\hpsustain, 2/~t,
			\lpsustain, 6/~t,
			\adsr, Pseq([
				[ Env.adsr(2/~t,0.1,0.8,0.4,1,[5,0,-8]) ],
			],inf),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pmono(
				{ arg out=0, freq=200, pan=0, amp=0.1, gate=1;
					var sig;
					sig = LFPulse.ar(freq * ( LFPulse.ar(1) * 0.5 +1 ));
					sig = LPF.ar(sig,freq * ( LFPulse.ar(1.003) * 0.5 +1 ) );
					sig = sig * LFPulse.ar(1.01,add:0.1).lag(0.001);
					sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\freq, 200,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			8, Pmono(
				{ arg out=0, freq=200, pan=0, amp=0.1, gate=1;
					var sig;
					sig = LFPulse.ar(freq * ( LFPulse.ar(1.05) * 0.5 +1 ));
					sig = LPF.ar(sig,freq * ( LFPulse.ar(1.003) * 0.5 +1 ) );
					sig = sig * LFPulse.ar(1.01,add:0.1).lag(0.01);
					sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\freq, Pstep(Pseq([250,300,150,350,175],inf),16),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			24, Pmono(
				{ arg out=0, freq=200, pan=0, amp=0.1, gate=1;
					var sig;
					var env1, env2, env3, env4, env5, env6, env7, env8;
					var time = 16*3/~t;
					//env1 = XLine.kr(0.5,0.001,time);
					env1 = EnvGen.kr(Env([0.5,0.001,0.001,0.5],[time,2.8,time]), 1);
					env3 = EnvGen.kr(Env([1,1,0],[time,0.8]), 1);
					env2 = EnvGen.kr(Env([0,1,1,0],[time,12.8,time/2]), 1);
					sig = LFPulse.ar(freq * ( LFPulse.ar(1/2*~t) * env3 +1 ));
					sig = sig + LFPulse.ar(freq + 0.001 * ( LFPulse.ar(1.05) * env1 +1 ));
					sig = LPF.ar(sig,freq*3 * ( LFPulse.ar(1.003) * 0.5 +1 ) );
					sig = sig * SelectX.ar(env2, [LFPulse.ar(4.01*~t,add:0.1).lag(0.01),DC.ar(1)]);
					sig = sig * EnvGen.ar(Env.adsr(18.1,0.1,1,0.1),gate,doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\freq, 200 * 1/4 * Pseq([
					Pstep(Pseq([7].midiratio,1),16*3),
					Pstep(Pseq([0,5,7].midiratio,inf),1),
				],inf),
				\dur, 1,
				\amp, 0.071,
				//\out, BusDef(\sendbus1, \audio),
			),
		])
		
	])
)).play;
);

(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pmono(
				{ arg out=0, freq=200, pan=0, amp=0.1, gate=1;
					var sig;
					sig = LFPulse.ar(freq * ( LFPulse.ar(1) * 0.5 +1 ));
					sig = LPF.ar(sig,freq * ( LFPulse.ar(1.003) * 0.5 +1 ) );
					sig = sig * LFPulse.ar(1.01,add:0.1).lag(0.001);
					sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\freq, 200,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			8, Pmono(
				{ arg out=0, freq=200, pan=0, amp=0.1, gate=1;
					var sig;
					sig = LFPulse.ar(freq * ( LFPulse.ar(1.05) * 0.5 +1 ));
					sig = LPF.ar(sig,freq * ( LFPulse.ar(1.004) * 0.5 +1 ) );
					sig = sig * LFPulse.ar(1.014,add:0.1).lag(0.01);
					sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\freq, Pstep(Pseq([250,300,150,350,175],inf),16),
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
			16, Pmono(
				{ arg out=0, freq=200, pan=0, amp=0.1, gate=1;
					var sig;
					sig = LFPulse.ar(freq * ( LFPulse.ar(1.04) * 0.5 +1 ));
					sig = LPF.ar(sig,freq*3 * ( LFPulse.ar(1.004) * 0.5 +1 ) );
					sig = sig * LFPulse.ar(1.013,add:0.1).lag(0.01);
					sig = sig * EnvGen.ar(Env.adsr(8.1/~t,0.1,1,0.1),gate,doneAction:2);
					sig = Pan2.ar(sig, pan, amp);
					Out.ar(out, sig);
				}.asDefName,
				\freq, Pstep(Pseq([200],inf),16)/4 * 7.midiratio,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
			),
		])
		
	])
)).play;
);

//ProtoDef(\rdn).presetCompileString.editorInsert
(
	// powerful
ProtoDef('rdn').make('deldefault', 'rdn', "6-M9HD-8SV6", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.60084033613445,
	'gain', 0.78571428571429,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.76269858590234,
	'shift', 0.042016806722689,
	'shift2', -0.084033613445379,
	'distamp', 0.23203111045792,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.15588673396576,
	'fbdistmix', 0.10084033613445,
	'postlpf', 17000,
	'posthpf', 386.13954577665,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'deltran1', 2.4065216155096,
	'deltran2', 0.019597246864546,
	'deltran3', 0.15776103979864,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'fb1', 0.1,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'fb2', 0.1,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);

(
	// solid
ProtoDef('rdn').make('deldefault', 'rdn', "6-DJ70-PJGP", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.78571428571429,
	'gain', 0.78571428571429,
	'fb', 0.0001,
	'delay', 0.67909850299557,
	'delay2', 0.0001,
	'shift', 0.042016806722689,
	'shift2', -0.084033613445379,
	'distamp', 0.23203111045792,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.15588673396576,
	'fbdistmix', 0.70588235294118,
	'postlpf', 17000,
	'posthpf', 386.13954577665,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'deltran1', 2.4065216155096,
	'deltran2', 0.019597246864546,
	'deltran3', 0.15776103979864,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'fb1', 0.1,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'fb2', 0.1,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);

(
// fairy
ProtoDef('rdn').make('deldefault', 'rdn', "5-CVA3-SVF3", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.78571428571429,
	'gain', 0.78571428571429,
	'fb', 0.0035086914797844,
	'delay', 0.79279273894506,
	'delay2', 0.0001,
	'shift', 0.042016806722689,
	'shift2', -0.084033613445379,
	'distamp', 0.18936988889504,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 386.13954577665,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'deltran1', 2.4065216155096,
	'deltran2', 0.019597246864546,
	'deltran3', 0.15776103979864,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'fb1', 0.1,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'fb2', 0.1,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);



/////////////////////////
// dub snare

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[632].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\inbus, BusDef(\ifx1, \audio),
			\instrument, \expdelay,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 5,
			\mix, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\expdelay, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = DelayL.ar(sig, 1, 0.004 * XLine.kr(0.1,1000,1/8));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\expdelay, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = DelayL.ar(sig, 1, 0.01 * XLine.kr(1,0.0001,4/1));
	sig = GVerb.ar(sig, 50, revtime:0.2, damping:0);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);


////////////////

	
(
Pdef(\part, Pdef(\glissbass, 
	Ppar([
		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				sig = 3.collect { arg idx;
					var ifreq = freq + ( idx/1000 );
					var oscmix = SinOsc.kr(1/2*~t + ( idx/1000 )).unipolar;
					//oscmix = 0;
					sig1 = LFSaw.ar(ifreq);
					sig2 = LFPulse.ar(ifreq+1);
					sig3 = SinOsc.ar(ifreq+2);
					SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
				};
				sig = HPF.ar(sig, 20) * 4;
				sig = sig.mean;
				sig = LPF.ar(sig, freq*5);
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				sig = LeakDC.ar(sig);
				sig = Pan2.ar(sig, pan, amp);
			}.asDefName,
			\note, Pstep(Pseq([
				0,4,7,
			],inf),4),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

////////////////////////////////

(
Pdef(\melo1, 
	Pbind(
		\instrument, \bassfmenkor,
		\amp, 0.1/2,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,1.1) ],
		],inf),
	)
);
NoteTimeline('sun45monomelo1').param = Param(Pdef('melo1'), 'midinote');
NoteTimeline('sun45monomelo1').eventList = TimelineEventList.newFrom([
	(\absTime: -0.074489491332315, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5077.1255105087, \dur: 0.074489491332315, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 0.074489491332315, \relDur: 0.074489491332315, \sustain: 3.7451938883332, ),
	(\absTime: 0.0, \dur: 3.6442630320007, \label: 'start', \playDur: 3.6442630320007, \relDur: 3.6442630320007, \sustain: 0, \type: 'start', ),
	(\absTime: 3.6442630320007, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5080.844263032, \dur: 0.29260784166672, \instrument: 'bassfmenkor', \kitIndex: 85, \midinote: 85, \playDur: 0.29260784166672, \relDur: 0.29260784166672, \sustain: 0.2983769416669, ),
	(\absTime: 3.9368708736674, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5081.1368708737, \dur: 3.2760110441659, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 3.2760110441659, \relDur: 3.2760110441659, \sustain: 3.3134349516667, ),
	(\absTime: 7.2128819178333, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5084.4128819178, \dur: 0.34543167000083, \instrument: 'bassfmenkor', \kitIndex: 82, \midinote: 82, \playDur: 0.34543167000083, \relDur: 0.34543167000083, \sustain: 0.35066570916752, ),
	(\absTime: 7.5583135878342, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5084.7583135878, \dur: 0.33519245499974, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 0.33519245499974, \relDur: 0.33519245499974, \sustain: 0.32151002749924, ),
	(\absTime: 7.8935060428339, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5085.0935060428, \dur: 0.29572462333363, \instrument: 'bassfmenkor', \kitIndex: 85, \midinote: 85, \playDur: 0.29572462333363, \relDur: 0.29572462333363, \sustain: 0.31569099666649, ),
	(\absTime: 8.1892306661675, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5085.3892306662, \dur: 1.7720873041662, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 1.7720873041662, \relDur: 1.7720873041662, \sustain: 1.7930911308331, ),
	(\absTime: 9.9613179703338, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5087.1613179703, \dur: 1.7565765683339, \instrument: 'bassfmenkor', \kitIndex: 88, \midinote: 88, \playDur: 1.7565765683339, \relDur: 1.7565765683339, \sustain: 1.8120911124997, ),
	(\absTime: 11.717894538668, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5088.9178945387, \dur: 0.27120976916649, \instrument: 'bassfmenkor', \kitIndex: 87, \midinote: 87, \playDur: 0.27120976916649, \relDur: 0.27120976916649, \sustain: 0.1980490674996, ),
	(\absTime: 11.989104307834, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5089.1891043078, \dur: 3.2004909308334, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 3.2004909308334, \relDur: 3.2004909308334, \sustain: 3.1971753208336, ),
	(\absTime: 15.189595238668, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5092.3895952387, \dur: 0.2429442574994, \instrument: 'bassfmenkor', \kitIndex: 82, \midinote: 82, \playDur: 0.2429442574994, \relDur: 0.2429442574994, \sustain: 0.26175858499937, ),
	(\absTime: 15.432539496167, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5092.6325394962, \dur: 0.45029407916718, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 0.45029407916718, \relDur: 0.45029407916718, \sustain: 0.48130371750085, ),
	(\absTime: 15.882833575334, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5093.0828335753, \dur: 0.29521379249945, \instrument: 'bassfmenkor', \kitIndex: 85, \midinote: 85, \playDur: 0.29521379249945, \relDur: 0.29521379249945, \sustain: 0.30053677999967, ),
	(\absTime: 16.178047367834, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5093.3780473678, \dur: 3.0765271025002, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 3.0765271025002, \relDur: 3.0765271025002, \sustain: 3.0635711833329, ),
	(\absTime: 19.254574470334, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5096.4545744703, \dur: 0.37562874333344, \instrument: 'bassfmenkor', \kitIndex: 80, \midinote: 80, \playDur: 0.37562874333344, \relDur: 0.37562874333344, \sustain: 0.40968432666614, ),
	(\absTime: 19.630203213667, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5096.8302032137, \dur: 0.3383532083335, \instrument: 'bassfmenkor', \kitIndex: 82, \midinote: 82, \playDur: 0.3383532083335, \relDur: 0.3383532083335, \sustain: 0.27509395333345, ),
	(\absTime: 19.968556422001, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5097.168556422, \dur: 2.9624443883331, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 2.9624443883331, \relDur: 2.9624443883331, \sustain: 2.998356939167, ),
	(\absTime: 22.931000810334, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5100.1310008103, \dur: 0.27969692083389, \instrument: 'bassfmenkor', \kitIndex: 85, \midinote: 85, \playDur: 0.27969692083389, \relDur: 0.27969692083389, \sustain: 0.31067292749958, ),
	(\absTime: 23.210697731168, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5100.4106977312, \dur: 0.66854924833297, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 0.66854924833297, \relDur: 0.66854924833297, \sustain: 0.71634720749898, ),
	(\absTime: 23.879246979501, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5101.0792469795, \dur: 0.30691518416643, \instrument: 'bassfmenkor', \kitIndex: 87, \midinote: 87, \playDur: 0.30691518416643, \relDur: 0.30691518416643, \sustain: 0.28486965416687, ),
	(\absTime: 24.186162163667, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5101.3861621637, \dur: 3.7614029999995, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 3.7614029999995, \relDur: 3.7614029999995, \sustain: 3.7349426691662, ),
	(\absTime: 27.947565163667, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5105.1475651637, \dur: 2.9754055800004, \instrument: 'bassfmenkor', \kitIndex: 88, \midinote: 88, \playDur: 2.9754055800004, \relDur: 2.9754055800004, \sustain: 2.9598949125002, ),
	(\absTime: 30.922970743667, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5108.1229707437, \dur: 0.34336386916675, \instrument: 'bassfmenkor', \kitIndex: 87, \midinote: 87, \playDur: 0.34336386916675, \relDur: 0.34336386916675, \sustain: 0.38316922000013, ),
	(\absTime: 31.266334612834, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5108.4663346128, \dur: 0.39627413583366, \instrument: 'bassfmenkor', \kitIndex: 88, \midinote: 88, \playDur: 0.39627413583366, \relDur: 0.39627413583366, \sustain: 0.44590979333316, ),
	(\absTime: 31.662608748667, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5108.8626087487, \dur: 0.33074950333321, \instrument: 'bassfmenkor', \kitIndex: 92, \midinote: 92, \playDur: 0.33074950333321, \relDur: 0.33074950333321, \sustain: 0.2694546974999, ),
	(\absTime: 31.993358252001, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5109.193358252, \dur: 0.0066417479993106, \instrument: 'bassfmenkor', \kitIndex: 90, \midinote: 90, \playDur: 0.0066417479993106, \relDur: 0.0066417479993106, \sustain: 1.9856227441669, ),
	(\absTime: 32.0, \dur: 1.9442837103334, \label: 'end', \playDur: 1.9442837103334, \relDur: 1.9442837103334, \type: 'end', ),
	(\absTime: 33.944283710333, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5111.1442837103, \dur: 1.6008426941671, \instrument: 'bassfmenkor', \kitIndex: 92, \midinote: 92, \playDur: 1.6008426941671, \relDur: 1.6008426941671, \sustain: 1.6511610891666, ),
	(\absTime: 35.5451264045, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5112.7451264045, \dur: 0.50589393000064, \instrument: 'bassfmenkor', \kitIndex: 88, \midinote: 88, \playDur: 0.50589393000064, \relDur: 0.50589393000064, \sustain: 0.42846781916705, ),
	(\absTime: 36.051020334501, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5113.2510203345, \dur: 3.4767412166666, \instrument: 'bassfmenkor', \kitIndex: 88, \midinote: 88, \playDur: 3.4767412166666, \relDur: 3.4767412166666, \sustain: 3.5283846325001, ),
	(\absTime: 39.527761551168, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5116.7277615512, \dur: 0.34553586583297, \instrument: 'bassfmenkor', \kitIndex: 85, \midinote: 85, \playDur: 0.34553586583297, \relDur: 0.34553586583297, \sustain: 0.33123708750009, ),
	(\absTime: 39.873297417001, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5117.073297417, \dur: 3.3847067316665, \instrument: 'bassfmenkor', \kitIndex: 87, \midinote: 87, \playDur: 3.3847067316665, \relDur: 3.3847067316665, \sustain: 3.4665567716665, ),
	(\absTime: 43.258004148667, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5120.4580041487, \dur: 0.41941611083348, \instrument: 'bassfmenkor', \kitIndex: 85, \midinote: 85, \playDur: 0.41941611083348, \relDur: 0.41941611083348, \sustain: 0.50645113416613, ),
	(\absTime: 43.677420259501, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5120.8774202595, \dur: 0.31532090083329, \instrument: 'bassfmenkor', \kitIndex: 82, \midinote: 82, \playDur: 0.31532090083329, \relDur: 0.31532090083329, \sustain: 0.24818358999983, ),
	(\absTime: 43.992741160334, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5121.1927411603, \dur: 3.6530818408337, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 3.6530818408337, \relDur: 3.6530818408337, \sustain: 3.7076374550006, ),
	(\absTime: 47.645823001168, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5124.8458230012, \dur: 0.28950470499967, \instrument: 'bassfmenkor', \kitIndex: 85, \midinote: 85, \playDur: 0.28950470499967, \relDur: 0.28950470499967, \sustain: 0.26553365166637, ),
	(\absTime: 47.935327706167, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.1, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 5125.1353277062, \dur: 0, \instrument: 'bassfmenkor', \kitIndex: 83, \midinote: 83, \playDur: 0, \relDur: 0, \sustain: 3.9255640733327, ),
]);
);

//ProtoDef(\rdn).presetCompileString.editorInsert
(
	// ghost reverb
ProtoDef('rdn').make('deldefault', 'rdn', "5-9CRE-CPGT", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.78571428571429,
	'gain', 0.20672268907563,
	'fb', 0.0001,
	'delay', 0.79279273894506,
	'delay2', 0.0001,
	'shift', 0.042016806722689,
	'shift2', -0.084033613445379,
	'distamp', 0.18936988889504,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.12465796720366,
	'fbdistmix', 0.20168067226891,
	'postlpf', 17000,
	'posthpf', 386.13954577665,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

//ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-2LUP-F80B", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.29831932773109,
	'gain', 0.19411764705882,
	'fb', 0.0001,
	'delay', 0.85659021536855,
	'delay2', 0.73374679706514,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.15910384392722,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.72268907563025,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
// nice
ProtoDef('rdn2').make('deldefault', 'rdn2', "6-3J2A-MUKG", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.22915966386555,
	'fb', 0.028770056856156,
	'delay', 0.00052806705745826,
	'delay2', 0.47937156455582,
	'shift', 0.16806722689076,
	'shift2', 0.0,
	'distamp', 0.99037192233053,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.14705882352941,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
(
	ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				sig = 3.collect { arg idx;
					var ifreq = freq + ( idx/1000 );
					var oscmix = SinOsc.kr(1/2*~t + ( idx/1000 )).unipolar;
					//oscmix = 0;
					sig1 = LFSaw.ar(ifreq);
					sig2 = LFPulse.ar(ifreq+1);
					sig3 = SinOsc.ar(ifreq+2);
					SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
				};
				sig = HPF.ar(sig, 20) * 2;
				sig = sig.mean;
				sig = LPF.ar(sig, freq*2);
				sig = LeakDC.ar(sig);
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.3)), gate, doneAction:2);
				sig = Pan2.ar(sig, pan, amp);
			}.asDefName,
			\note, Pstep(Pseq([
				0,-1,
			],inf),4)+4,
			\octave, 3,
			\dur, Pn(1,inf),
			\amp, 0.1,
		),

		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				sig = 13.collect { arg idx;
					var ifreq = freq + ( idx/1000 );
					var oscmix = SinOsc.kr(1/2*~t + ( idx/1000 )).unipolar;
					//oscmix = 0;
					sig1 = LFSaw.ar(ifreq);
					sig2 = LFPulse.ar(ifreq+1);
					sig3 = SinOsc.ar(ifreq+2);
					SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
				};
				//sig = sig.mean;
				sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
				sig = LPF.ar(sig, freq*5);
				sig = HPF.ar(sig, 20) * 1/3;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				sig = LeakDC.ar(sig);
				//sig = Pan2.ar(sig, pan, amp);
			}.asDefName,
			\note, Pstep(Pseq([
				[0,4,7,12+7],
				[-1,4,7,12+7],
			],inf),4)+16,
			\octave, 3,
			\dur, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
			\isRest, true,
		),
		Ptpar([
			16, Pbind( 
				\out, BusDef(\sendbus1, \audio), 
				//\amp, Pkey(\amp)/2.5,
				\lag, -0.04,
			) <> NoteTimeline('sun45monomelo1').asPattern,
			32,Pbind(
				\instrument, \default,
				\note, Pstep(Pseq([
					[-1,4] +.x [-12,0,12],
					[-1,3] +.x [-12,0,12],
				],inf),4),
				\octave, 6,
				\legato, 0.1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1/2,
				\lag, -0.04,
				\out, BusDef(\sendbus2, \audio),
			),
		]),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(
			{ arg gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				sig = 3.collect { arg idx;
					var ifreq = freq + ( idx/1000 );
					var oscmix = SinOsc.kr(1*~t + ( idx/1000 )).unipolar;
					//oscmix = 0;
					sig1 = LFSaw.ar(ifreq);
					sig2 = LFPulse.ar(ifreq+1);
					sig3 = SinOsc.ar(ifreq+2);
					SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
				};
				sig = HPF.ar(sig, 20) * 2;
				sig = sig.mean;
				sig = LPF.ar(sig, freq*2);
				sig = LeakDC.ar(sig);
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.3)), gate, doneAction:2);
				sig = Pan2.ar(sig, pan, amp);
			}.asDefName,
			\note, Pstep(Pseq([
				0,-1,
				0,11,
			],inf),4)+4,
			\octave, 3,
			\dur, Pn(1,inf),
			\amp, 0.1,
		),
		Ptpar([
			0, Pbind(
				\instrument, ~fmgen_short.(13215),
				\note, Pseq([
					Pseq([
						0,7,
					],8),
					Pseq([
						-1,7,
					],8),
				],inf)+4,
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1,
			),
			//16, NoteTimeline(\sun45monomelo2).asPattern,
		]),
	])
)).play;
);

FileSystemProject.load("sun/fmgen.scd");
(
Pdef(\melo2, 
	Pbind(
		\instrument, ~fmgen_short.(198921),
		\amp, 0.1/2,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,1.1) ],
		],inf),
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo2))
NoteTimeline(\sun45monomelo2, Pdef(\melo2)).edit
//NoteTimeline(\sun45monomelo2).presetCompileString.editorInsert
(
NoteTimeline('sun45monomelo2').param = Param(Pdef('melo2'), 'midinote');
NoteTimeline('sun45monomelo2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3508.2157940277, \dur: 0.0, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 96, \midinote: 96.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.12883708416666, ),
	(\absTime: 0.0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	(\absTime: 0.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3508.4329615185, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 94, \midinote: 94.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.10701049250065, ),
	(\absTime: 0.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3508.6348036593, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 92, \midinote: 92.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1179998733337, ),
	(\absTime: 0.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3508.8765852693, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 91, \midinote: 91.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14948861250014, ),
	(\absTime: 1.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3509.1157502135, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 92, \midinote: 92.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14833589499995, ),
	(\absTime: 1.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3509.3407622968, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 91, \midinote: 91.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15921743666695, ),
	(\absTime: 1.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3509.6089641718, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 92, \midinote: 92.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15790227083335, ),
	(\absTime: 1.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3509.8261693452, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 94, \midinote: 94.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16376773916636, ),
	(\absTime: 2.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3510.0898730643, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 92, \midinote: 92.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15592366583314, ),
	(\absTime: 2.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3510.3277373677, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 91, \midinote: 91.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15147924666644, ),
	(\absTime: 2.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3510.5972211077, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 89, \midinote: 89.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13796770249974, ),
	(\absTime: 2.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3510.831897871, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 91, \midinote: 91.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2396718058335, ),
	(\absTime: 3.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3511.0806884052, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 89, \midinote: 89.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11475685166624, ),
	(\absTime: 3.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3511.3191956327, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 87, \midinote: 87.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16042719916732, ),
	(\absTime: 3.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3511.5686805477, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 84, \midinote: 84.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21584007583397, ),
	(\absTime: 3.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3511.805945321, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 87, \midinote: 87.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14178015083326, ),
	(\absTime: 4.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3512.0741425093, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 89, \midinote: 89.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13535840833356, ),
	(\absTime: 4.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3512.3345027485, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 87, \midinote: 87.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1875, ),
	(\absTime: 4.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3512.553040641, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 86, \midinote: 86.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15287872416593, ),
	(\absTime: 4.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3512.8084344735, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 87, \midinote: 87.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12189841833333, ),
	(\absTime: 5.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3513.0430916268, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 86, \midinote: 91.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3513.3003992702, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 84, \midinote: 84.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11540285916681, ),
	(\absTime: 5.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3513.5396186302, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 83, \midinote: 83.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13280166583399, ),
	(\absTime: 5.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3513.7794658152, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 84, \midinote: 84.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12249136999981, ),
	(\absTime: 6.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3514.059820956, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 87, \midinote: 87.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.094119036666598, ),
	(\absTime: 6.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3514.2854529735, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 86, \midinote: 86.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1875, ),
	(\absTime: 6.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3514.5157376335, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 84, \midinote: 84.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13077285750023, ),
	(\absTime: 6.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3514.7420187552, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 83, \midinote: 83.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.10823021666693, ),
	(\absTime: 7.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3514.9804996943, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 84, \midinote: 84.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1359362674998, ),
	(\absTime: 7.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3515.2280271677, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 83, \midinote: 83.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13470902250083, ),
	(\absTime: 7.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3515.4768347427, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 84, \midinote: 80.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.1, \clockTime: 3515.7102544418, \dur: 0.25, \instrument: SynthDef('fmgen_ambientchords_v123215n20', { | out = 0, gate = 1, amp = 0.1, pan = 0, freq = 200 | "open Function" }), \kitIndex: 86, \midinote: 83.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13867559666642, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

//////////////////////////////////////
(
Pdef(\melo, 
	Pbind(
		\instrument, ~fmgen_ambientchords.(123215),
		\amp, 0.1,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,1.1) ],
		],inf),
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

NoteTimeline(\sun45monomelo1, Pdef(\melo)).edit
NoteTimeline(\sun45monomelo1, Pdef(\melo)).presetCompileString.editorInsert

///////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[]
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);
