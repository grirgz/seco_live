
// make big bass house
(
~t = 127/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

//// lib

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\partx, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		)
		
	])
));
//Pdef(\partx).play;
);

(
Pdef(\part, Pdef(\hats1, 
	Ppar([
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1750].value,
				\bufnum, ~buflib.hat[1835].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.15,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[21].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.2,0.5,0.7,1,
				],inf),
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\hats2, 
	Ppar([
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1750].value,
				\bufnum, ~buflib.hat[1835].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.15,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[21].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.2,0.5,0.7,1,
				],inf),
			),
			24, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
				\legato, 1,
				\st, 110/2/60,
				\speed, 1.0 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0, 4,
				]+0,1),4).loop / Pkey(\st),
				\pos, Pseq([
					0,1,0,0, 4,2,2,4,
					0,0,4,9, 0,4,2,12,
					0,1,0,0, 4,2,2,4,
					0,0,13,30, 21,19,20,22,
					0,1,0,0, 4,2,2,4,
					0,0,4,9, 0,4,2,12,
					0,1,0,0, 4,2,2,4,
					0,0,4,12, 4.1,4.02,4.05,27,
					//8,9,9,10,

				]/8,inf) / Pkey(\st),
				\dur, 1/8,
				\gain, 1/4,
			),
		]),
		
		
	])
)).play;
);

/////////

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * \freqfac.kr(1);
	sig = VarSaw.ar(freq * [1,1.001], width: SinOsc.ar(1/2,pi/2) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * \freqfac.kr(1);
	sig = LFSaw.ar(freq * [1,1.0001,1.0002,1.00001]);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * \freqfac.kr(1);
	sig = VarSaw.ar(freq * [1,1.001], width: SinOsc.ar(1/4,pi/2) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * \freqfac.kr(1);
	sig = VarSaw.ar(freq , width: SinOsc.ar(1/8*[1,1.01],pi*1.5) );
	sig = sig * 0.8;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=5;
	freq = freq * \freqfac.kr(1);
	sig = VarSaw.ar(freq * LFNoise1.ar(0.1!num,mul:0.01,add:1), width: SinOsc.ar(1/4,pi/2) );
	sig = sig * 0.8;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=5;
	freq = freq * \freqfac.kr(1);
	sig = LFPulse.ar(freq * LFNoise1.ar(0.1!num,mul:0.0001,add:1), width: SinOsc.ar(1/4,pi/2) ).bipolar;
	sig = sig * 0.4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

/// fm
(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod1 = SinOsc.ar(freq * [0.99,1,1.001]) * \fma.kr(88) * XLine.kr(1,48,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /1.52;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod1 = SinOsc.ar(freq * [0.9999,1,1.00101]) * \fma.kr(438) * XLine.kr(1,4,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod2 = SinOsc.ar(freq * 2) * 1000;
	mod1 = SinOsc.ar(freq * [0.9999,1,1.00101] + mod2) * \fma.kr(438) * XLine.kr(1,4,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod3 = SinOsc.ar(freq*[1,2,1]) * 0.1;
	mod2 = SinOsc.ar(freq * 2 + mod3) * 2000;
	mod1 = SinOsc.ar(freq * [0.9999,1,1.00101] + mod2) * \fma.kr(438) * XLine.kr(1,4,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod1 = LFSaw.ar(freq * [0.9999,1,1.00101]) * \fma.kr(438) * XLine.kr(1,4,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod1 = SinOsc.ar(freq * [0.9999,1,1.00101]) * \fma.kr(238) * XLine.kr(1,34,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod1 = SinOsc.ar(freq * [0.9999,1,1.00001]) * \fma.kr(198) * XLine.kr(1,34,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bigbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod2 = SinOsc.ar(freq * [0.99,1,1.001]) * 1; 
	mod1 = LFSaw.ar(freq + mod2) *  11 * freq; 
	freq = freq * \freqfac.kr(1);
	sig = SinOsc.ar(freq  + mod1);
	sig = ( ( sig*9 ).tanh * 0.4 ) + ( sig * 0.4 );
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
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
		
	])
)).play;
);

(
// offbeat bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				\r,-1,
			],inf),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
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
		
	])
)).play;
);


(
/// rdn
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 1/2,1,2,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\distpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	freq = freq * \freqfac.kr(1);
	mod1 = SinOsc.ar(freq * [0.9999,1,1.00101]) * \fma.kr(238) * XLine.kr(1,34,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
/// rdn with distpiano
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 1,1,2,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \distpiano,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 1,1,2,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1750].value,
				\bufnum, ~buflib.hat[1835].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.15,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[21].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.2,0.5,0.7,1,
				],inf),
			),
		]),
		
	])
)).play;
);


(
/// rdn
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 1,1,2,0,

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \distpiano,
			\note, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,-12,0,12,
				0,0,0,0,
			],inf).stutter(2),
			\legato, Pseq([
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0, 
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0, 
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1750].value,
				\bufnum, ~buflib.hat[1835].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.15,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[21].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.2,0.5,0.7,1,
				],inf),
			),
		]),
		
	])
)).play;
);


ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "6-4JNV-OIRI", BusDef('sendbus1'));
ProtoDef('rdn').outBus = BusDef(\basstrack, \audio, 2);
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.47058823529412,
	'gain', 0.38655462184874,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', -0.084033613445379,
	'shift2', 0.0,
	'distamp', 0.27616998133438,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
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
).keep(1));

);

///


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, PmodEnv(Pseq([1,1,1,1,-1.midiratio],1), 2).loop,
			\octave, 3,
			\legato, Pseq([
				2,0,1,1, 1,0,2,0,
				1,1,2,0, 1,1,1,1,
				1,0,0,1, 1,0,1,0, 
				4,0,0,0, 3,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
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
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1013].value,
				\bufnum, ~buflib.hat[834].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.10,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
				\legato, 1,
				\st, 110/2/60,
				\speed, 1.0 * ~t / Pkey(\st),
				\pos, Pseg(Pseq([
					0, 4,
				]+0,1),4).loop / Pkey(\st),
				\pos, Pseq([
					0,1,0,0, 4,2,2,4,
					0,0,4,9, 0,4,2,12,
					0,1,0,0, 4,2,2,4,
					0,0,13,30, 21,19,20,22,
					0,1,0,0, 4,2,2,4,
					0,0,4,9, 0,4,2,12,
					0,1,0,0, 4,2,2,4,
					0,0,4,12, 4.1,4.02,4.05,27,
					//8,9,9,10,

				]/8,inf) / Pkey(\st),
				\dur, 1/8,
				\gain, 1/4,
			),
		]),
		
	])
)).play;
);

(
SynthDef(\distpianogli, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = TChoose.kr(Dust.kr(40), [1/2,1,2,3,4]).lag(0.1);
	freq = freq * \freqfac.kr(1);
	mod1 = SinOsc.ar(freq * lfo1 * [0.9999,1,1.00101]) * \fma.kr(8) * LFNoise1.kr(1/2,mul:100,add:1) * XLine.kr(1,34,2); 
	sig = LFSaw.ar(freq  + mod1);
	sig = LPF.ar(sig, \lpf.kr(1300)* lfo1);
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \distpianogli,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod2 = LFNoise1.ar(0.1) * 10; 
	mod1 = SinOsc.ar(freq + mod2) * 1400; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod2 = LFNoise1.ar(0.1!5) * 10; 
	mod1 = SinOsc.ar(freq + mod2) * 1400; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod2 = LFNoise1.ar(0.1!5) * 1; 
	mod1 = SinOsc.ar(freq + mod2) * 1400; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod3 = LFNoise1.ar(0.1!5) * 1; 
	mod2 = SinOsc.ar(freq + mod3) * 10; 
	mod1 = SinOsc.ar(freq + mod2) * 1400; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod3 = LFNoise1.ar(0.1!5) * 100; 
	mod2 = SinOsc.ar(freq*[3,2] + mod3) * 4380; 
	mod1 = SinOsc.ar(freq + mod2) * 484; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod3 = LFNoise1.ar(0.1!5) * 100; 
	mod2 = SinOsc.ar(freq*[3,2] + mod3) * freq * 8; 
	mod1 = SinOsc.ar(freq + mod2) * 484; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod3 = LFNoise1.ar(0.1!5) * 1; 
	mod2 = SinOsc.ar(freq + mod3) * 10; 
	mod1 = SinOsc.ar(freq + mod2) * 140; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod3 = LFNoise1.ar(0.1!5) * 0.1; 
	mod2 = LFSaw.ar(freq*4 + mod3.poll) * 1420; 
	mod1 = SinOsc.ar(freq + mod2) * 440; 
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod4 = LFNoise1.ar(0.1!5) * 0.01; 
	mod3 = SinOsc.ar(freq*1/2 + mod4) * freq * 344; 
	mod2 = SinOsc.ar(freq*1/2 + mod3) * 182; 
	mod1 = SinOsc.ar(freq*2 + mod2) * 840; 
	sig = SinOsc.ar(freq * [1,1.001] + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono( \monodistpiano,
			\note, Pseq([
				0,
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
		Pmono( \monodistpiano,
			\note, Pseq([
				Pseq((0..12*4))
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono( \monodistpiano,
			\note, Pseq([
				[0,4,7],
				[0,3,7]+4,
			],inf).stutter(8*4),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod4 = LFNoise1.ar(0.1!5) * 0.0001; 
	mod3 = SinOsc.ar(freq*[1,2,3,4] + [ mod4 ]) * freq * 1440; 
	mod3 = SelectX.ar( LFNoise1.kr(0.1).range(0,3), mod3 );
	mod2 = SinOsc.ar(freq*[1,2,3,4] + [ mod3 ]) * 122; 
	mod2 = SelectX.ar( LFNoise1.kr(0.1).range(0,3), mod2 );
	mod1 = SinOsc.ar(freq*[1,2,3,4] + [ mod2 ]) * 340; 
	mod1 = SelectX.ar( LFNoise1.kr(0.2).range(0,3), mod1 );
	sig = SinOsc.ar(freq  + mod1);
	//sig1 = Resonz.ar(sig, freq, 0.1);
	//sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod4 = LFNoise1.ar(0.1!5) * 3.1001; 
	mod3 = SinOsc.ar(freq*[1,2,3,4] + [ mod4 ]) * freq * 1440; 
	mod3 = SelectX.ar( LFNoise1.kr(0.1).range(0,3), mod3 );
	mod2 = SinOsc.ar(freq*[1,2,3,4] + [ mod3 ]) * 122; 
	mod2 = SelectX.ar( LFNoise1.kr(0.1).range(0,3), mod2 );
	mod1 = SinOsc.ar(freq*[1,2,3,4] + [ mod2 ]) * 340; 
	mod1 = SelectX.ar( LFNoise1.kr(0.2).range(0,3), mod1 );
	sig = SinOsc.ar(freq  + mod1);
	//sig1 = Resonz.ar(sig, freq, 0.1);
	//sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod4 = LFNoise1.ar(0.1!5) * 3.1001; 
	mod3 = SinOsc.ar(freq*[1,2,3,4] + [ mod4 ]) * freq * 1440; 
	mod3 = SelectX.ar( LFNoise1.kr(0.1).range(0,3), mod3 );
	mod2 = SinOsc.ar(freq*[1,2,3,4] + [ mod3 ]) * 122; 
	mod2 = SelectX.ar( LFNoise1.kr(0.1).range(0,3), mod2 );
	mod1 = SinOsc.ar(freq*[1,2,3,4] + [ mod2 ]) * 340; 
	mod1 = SelectX.ar( LFNoise1.kr(0.2).range(0,3), mod1 );
	sig = SinOsc.ar(freq  + mod1);
	//sig1 = Resonz.ar(sig, freq, 0.1);
	//sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

////// try fb
(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	//sig = SinOsc.ar(freq  + mod1);
	sig = SinOscFB.ar(freq, 1.4);
	//sig1 = Resonz.ar(sig, freq, 0.1);
	//sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\monodistpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var fbin;
	//sig = SinOsc.ar(freq  + mod1);
	fbin = LocalIn.ar(1) * \fb.kr(134.9);
	mod1 = SinOsc.ar(freq + fbin) * 170; 
	sig = SinOsc.ar(freq + mod1);
	LocalOut.ar(sig);
	//sig1 = Resonz.ar(sig, freq, 0.1);
	//sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \monodistpiano,
			\note, Pseq([
				0,4,4,3,2,1,0,-1,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);


///////
(
SynthDef(\vent, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod4 = LFNoise1.ar(0.1!5) * 0.0001; 
	mod3 = SinOsc.ar(freq*[1,2,3,4]/2 + [ mod4 ]) * freq * 144; 
	mod3 = SelectX.ar( SinOsc.kr(1.1).range(0,3), mod3 );
	mod2 = SinOsc.ar(freq*[1,2,3,4]/2 + [ mod3 ]) * 3102; 
	mod2 = SelectX.ar( SinOsc.kr(1).range(0,3), mod2 );
	mod1 = SinOsc.ar(freq*[1,2,3,4]/2 + [ mod2 ]) * 340; 
	mod1 = SelectX.ar( LFNoise1.kr(0.2).range(0,3), mod1 );
	sig = SinOsc.ar(freq  + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono( \vent,
			\note, Pseq([
				[ -12,1,14 ],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


//////////////

(
// tremble
SynthDef(\tremble, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -2), 1);
	mod3 = SinOsc.ar(freq) * 1000 * env1;
	mod2 = SinOsc.ar(freq*2 + mod3 ) * 140;
	mod1 = SinOsc.ar(freq + mod2 )  * 145;
	sig = SinOscFB.ar(freq* ((0..7)/7 - 0.5 * \fspread.kr(0.002)* env1 + 1) + mod1, \fb.kr(1.4));
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// tremble
SynthDef(\tremble, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -2), 1);
	mod3 = SinOsc.ar(freq) * 1000 * env1;
	mod2 = SinOsc.ar(freq*2 + mod3 ) * 140;
	mod1 = SinOsc.ar(freq + mod2 )  * 845;
	sig = SinOscFB.ar(freq* ((0..7)/7 - 0.5 * \fspread.kr(0.002)* env1 + 1) + mod1, \fb.kr(1.4));
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// tremble
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[859].value,
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
			\bufnum, ~buflib.snare[1666].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \tremble,
			\note, Pseq([
				0,4,5,3,2,1,0,-1,1,
			],inf),
			\fb, Pseg(Pseq([1.0,0.6],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, 4/1 * Pseq([1,1/2,1/2],inf),
			\amp, 0.15,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
// tremble
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \tremble,
			\note, Pseq([
				0,4,5,3,2,1,0,-1,1,
			],inf),
			\fb, Pseg(Pseq([1.0,0.6],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\legato, 1,
			\dur, 4/1 * Pseq([1,1/2,1/2],inf),
			\amp, 0.15,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
// tremble
SynthDef(\tremble2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -2), 1);
	mod3 = SinOsc.ar(freq) * 1000 * env1;
	mod2 = SinOsc.ar(freq*2 + mod3 ) * \fma2.kr(140);
	mod1 = SinOsc.ar(freq + mod2 )  * \fma1.kr(145).poll;
	sig = SinOscFB.ar(freq* ((0..7)/7 - 0.5 * \fspread.kr(0.002)* env1 + 1) + mod1, \fb.kr(1.4));
	sig = sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// tremble
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \tremble2,
			\note, Pseq([
				0,4,5,3,2,1,0,-1,1,
			],inf),
			\fb, Pseg(Pseq([1.0,0.6],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\legato, 1,
			//\fma1, PmodEnv(Pseq([111,1800],1),8*4,\exp).loop,
			\fma1, Pseg(Pseq([111,200,1400],1),8*4,\exp).loop,
			//\fma1, 400,
			//\fma2, PmodEnv(Pseq([11,400],1),8,\exp).loop,
			\dur, 4/1 * Pseq([1,1/2,1/2],inf),
			\amp, 0.15,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
// tremble
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \tremble2,
			\note, Pseq([
				0,4,5,3,2,1,0,-1,1,
			],inf),
			\fb, Pseg(Pseq([1.0,0.6],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\legato, 1,
			//\fma1, PmodEnv(Pseq([111,1800],1),8*4,\exp).loop,
			\fma1, Pseg(Pseq([111,200,800,1400],1),8*2,\exp).loop,
			//\fma1, 400,
			//\fma2, PmodEnv(Pseq([11,400],1),8,\exp).loop,
			\dur, 4/1 * Pseq([1,1/2,1/2],inf),
			\amp, 0.15,
			\out, BusDef(\basstrack0, \audio),
		),
		Pbind(
			\inbus, BusDef(\basstrack0, \audio),
			\out, BusDef(\basstrack, \audio),
			\instrument, \fx_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\legato, 1,
			\legato, Pseq([
				4,0,0,0,
				2,0,1,1,
				2,0,2,0,
				1,1,0,1,

				4,0,0,0,
				2,0,1,1,
				2,0,2,0,
				1,1,0,1,

				4,0,0,0,
				2,0,1,1,
				3,0,0,1,
				1,1,1,1,

				2,0,2,0,
				2,0,2,0,
				0,0,1,1,
				1,0,1,0,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
	])
)).play;
);

///////:


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, 
			Pseq([
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
			],inf),
			\octave, 3,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 1,1,1,2,
				//1,1,1,1, 1,1,1,1,
				1,1,2,0, 1,1,1,2,
				1,1,1,1, 1,1,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, 
			Pseq([
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
				PmodEnv(Pseq([0,4,4,4,5].midiratio,1), 1/2),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				//4,0,0,0, 1,1,1,2,
				//1,1,1,1, 1,1,1,1,
				1,2,0,1, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 1,1,2,0,
				2,0,1,1, 1,1,2,0,
				1,2,0,1, 2,0,2,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, 
			Pseq([
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
				PmodEnv(Pseq([0,4,4,4,5].midiratio,1), 1/2),
				PmodEnv(Pseq([5,5,5].midiratio,1), 1),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				1,2,0,1, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 1,1,2,0,
				2,0,1,1, 1,1,2,0,
				1,2,0,1, 2,0,2,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, 
			Pseq([
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([0,4,4,4,5].midiratio,1), 1/2),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([0,4,4,4,4].midiratio,1), 1/2),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				1,2,0,1, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 1,1,2,0,
				2,0,1,1, 1,1,2,0,
				1,2,0,1, 2,0,2,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Ptpar([
			32, Pbind(
			   	\instrument, \bigbass,
			   	\note, Pseq([
			   		4,4,4,4,
			   		4,4,4,4-12,
			   	],inf).stutter(4) + Pseq([
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,-1,0,
			   	]*12,inf),
			   	\octave, Pstep(Pseq([5,6],inf),8),
			   	\legato, Pseq([
			   		4,1,1,4, 1,1,4,1,
			   		2,1,4,2, 2,1,2,1,
			   	],inf)/8,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,0,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,0,0,0, 1,1,0,1,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   ),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		//Pdef(\hats2),
		Pbind(
			\instrument, \sawbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, 
			Pseq([
				Pseq([
					4,5,6,7,
				],inf).stutter(8*4).midiratio,
				//PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				//PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				//PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				//PmodEnv(Pseq([0,4,4,4,5].midiratio,1), 1/2),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				1,2,0,1, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 1,1,2,0,
				2,0,1,1, 1,1,2,0,
				1,2,0,1, 2,0,2,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4,7,11 ],
			],inf),
			\octave, 6,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		//Ptpar([
			//32, Pbind(
				   //\instrument, \bigbass,
				   //\note, Pseq([
					   //4,4,4,4,
					   //4,4,4,4-12,
				   //],inf).stutter(4) + Pseq([
					//0,0,0,0, 0,1,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,1,
					//0,0,0,0, 0,0,-1,0,
				   //]*12,inf),
				   //\octave, Pstep(Pseq([5,6],inf),8),
				   //\legato, Pseq([
					   //4,1,1,4, 1,1,4,1,
					   //2,1,4,2, 2,1,2,1,
				   //],inf)/8,
				   //\dur, 1/8,
				   //\isRest, Pseq([
					   //1,1,1,1, 1,1,1,1,
					   //1,1,1,1, 1,1,1,1,
					   //1,1,1,1, 1,1,1,1,
					   //1,1,1,1, 1,1,1,1,
					   //1,0,1,1, 1,1,1,1,
					   //1,1,1,1, 1,1,1,1,
					   //1,0,0,0, 1,1,0,1,
				   //],inf).coin.not,
				   //\amp, 0.1,
			   //),
		//]),
		
	])
)).play;
);

(
SynthDef(\sawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	freq = freq * \freqfac.kr(1);
	sig = LFSaw.ar(freq * LFNoise1.kr(1!num,mul:0.01,add:1));
	//sig = Resonz.ar(sig, \ffreq.kr(70), 0.9) + sig  /1.52;
	//sig = LFSaw.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	freq = freq * \freqfac.kr(1);
	sig = Pulse.ar(freq * LFNoise1.kr(1!num,mul:0.01,add:1)).bipolar;
	//sig = Resonz.ar(sig, \ffreq.kr(70), 0.9) + sig  /1.52;
	//sig = LFSaw.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq*4) * freq * 8;
	freq = freq * \freqfac.kr(1);
	sig = SinOsc.ar(freq * LFNoise1.kr(1!num,mul:0.001,add:1) + mod1).bipolar;
	sig = SinOsc.ar(freq + ( sig+1 * freq*8 ));
	//sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
	//sig = Resonz.ar(sig, \ffreq.kr(70), 0.9) + sig  /1.52;
	sig = Resonz.ar(sig, freq, 0.1) + sig  /1.52;
	//sig = LFSaw.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,8],[0.1,0.8]), 1);
	freq = freq * \freqfac.kr(1);
	sig = LFSaw.ar(freq * LFNoise1.kr(1!num,mul:0.01,add:1));
	sig = Pulse.ar(freq * 2,mul:0.5).bipolar + sig;
	//sig = Resonz.ar(sig, \ffreq.kr(70), 0.9) + sig  /1.52;
	//sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(1000) * env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 5;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([8,6,0.1],[0.1,0.4]), 1);
	freq = freq * \freqfac.kr(1);
	sig = LFSaw.ar(freq * LFNoise1.kr(1!num,mul:0.01,add:1));
	sig = Pulse.ar(freq * 2,mul:0.5).bipolar + sig;
	//sig = sig.clip2(0.2) *3;
	sig = AllpassL.ar(sig, 0.2,0.1,0.58) + sig;
	//sig = Resonz.ar(sig, \ffreq.kr(70), 0.9) + sig  /1.52;
	//sig = LFSaw.ar(freq);
	//sig = RLPF.ar(sig, \lpf.kr(1000) * env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\hidrone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * \freqfac.kr(1);
	env1 = EnvGen.kr(Env([0,100,200],[10,10]), 1);
	env2 = EnvGen.kr(Env([0,1000,200],[10,10]), 1);
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)) * env1;
	mod2 = LFSaw.ar(freq + mod1) * env2;
	sig = SinOsc.ar(freq + mod2);
	sig = sig.fold2(0.9);
	sig = sig * Duty.kr(Dseq([0.5,0.5],inf)/8/~t, 0, Dseq([
		1,0,
	],inf)).lag(0.01);
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.001)) + sig;
	env3 = EnvGen.kr(Env([1500,200,1000],[10.1,10.8],\exp), 1);
	sig = HPF.ar(sig, env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\hidrone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var duty = 1/8/~t;
	env1 = EnvGen.kr(Env([0.1,100,200,2000],[10,10,10],\exp), 1);
	env2 = EnvGen.kr(Env([0,1000,200],[10,10]), 1);
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)) * env1;
	mod2 = LFSaw.ar(freq + mod1) * env2;
	sig = SinOsc.ar(freq + mod2);
	sig = sig.fold2(0.9);
	env4 = TDuty.kr(duty, 0, Dseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,0,
		1,1,1,1, 1,1,0,1,
		1,1,1,0, 1,0,1,1,

		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,0,
		1,1,1,1, 1,1,0,1,
		1,0,0,0, 1,0,1,1,
	],inf)).lag(0.01);
	env4 = EnvGen.kr(Env([0,0,1,0],[0,0.1,0.8].normalizeSum * duty ), env4);
	sig = sig * env4;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.001)) + sig;
	env3 = EnvGen.kr(Env([1500,200,1000],[10.1,10.8],\exp), 1);
	sig = HPF.ar(sig, env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\hidrone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,100,200],[10,10]), 1);
	env2 = EnvGen.kr(Env([0,1000,200],[10,10]), 1);
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)) * env1;
	mod2 = LFSaw.ar(freq + mod1) * env2;
	sig = SinOsc.ar(freq + mod2);
	sig = sig.fold2(0.9);
	sig = sig * Duty.kr(Dseq([0.5,0.5],inf)/8/~t * freq/(256*2), 0, Dseq([
		1,0,
	],inf)).lag(0.01);
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.001)) + sig;
	env3 = EnvGen.kr(Env([1500,200,1000],[10.1,10.8],\exp), 1);
	sig = HPF.ar(sig, env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\hidrone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var num=5;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * \freqfac.kr(1);
	env1 = EnvGen.kr(Env([0,1,20],[10.1,20.8]), 1);
	mod1 = SinOsc.ar(freq) * LFNoise1.kr(1/2!num).range(0.0,3441.0) * env1;
	sig = SinOsc.ar(freq * [1,1/2,2] + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\hidrone, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var num=5;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * \freqfac.kr(1);
	env1 = EnvGen.kr(Env([0,1,20],[10.1,20.8]), 1);
	mod2 = LFSaw.ar(freq * 2) * 5;
	mod2 = LPF.ar(mod2, \lpf.kr(300) * LFNoise1.kr(1/2).range(0.5,7.0));
	mod1 = SinOsc.ar(freq + mod2) * LFNoise1.kr(1/2!num).range(0.0,3441.0) * env1;
	sig = SinOsc.ar(freq * [1,1/2,2] + mod1);
	sig1 = CombL.ar(sig, 4/~t, 0.1 * LFNoise1.kr(1/2).range(0.1,1.0), 1/~t);
	sig = SelectX.ar(\combmix.kr(0.2) * LFNoise1.kr(1/2).exprange(0.5,4.0), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\hidrone,
			\note, [ 0, 4 ],
			\dur, 1,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		//Pdef(\hats2),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, 
			Pseq([
				//Pseq([
					//4,4,4,7,
				//],inf).stutter(8).midiratio,
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				Pseq([
					7,7,0,4,
				],1).stutter(4).midiratio,
				//PmodEnv(Pseq([4,4,4].midiratio,1), 1),
				//PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				//PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				//PmodEnv(Pseq([0,4,4,4,5].midiratio,1), 1/2),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				1,2,0,1, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 1,1,2,0,
				2,0,1,1, 1,1,2,0,
				1,2,0,1, 2,0,2,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\hidrone,
			\note, [ 0, 4, 4-12 ],
			\octave, 6,
			\dur, 1,
			\amp, 0.1,
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		//Pdef(\hats2),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				4,
			],inf),
			\freqfac, 
			Pseq([
				//Pseq([
					//4,4,4,7,
				//],inf).stutter(8).midiratio,
				PmodEnv(Pseq([0,0,0,0,4].midiratio,1), 1/2),
				//PmodEnv(Pseq([4,4,4].midiratio,1), 1),
				//PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				//PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				//PmodEnv(Pseq([0,4,4,4,5].midiratio,1), 1/2),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				1,2,0,1, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 1,1,2,0,
				2,0,1,1, 1,1,2,0,
				1,2,0,1, 2,0,2,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\hidrone,
			\note, [ 0, 4, 4-12 ],
			\octave, 6,
			\freqfac, Pseq([
				//PmodEnv(Pseq([1,1,4.midiratio],1), 1),
				//PmodEnv(Pseq([1,1,1.midiratio],1), 1),
				//Pseq([1],1),
				PmodEnv(Pseq([1,1,1,1,-5.midiratio],1), 1).loop,
			],inf),
			\dur, Pn(1,32),
			\amp, 0.1/3,
			\out, BusDef(\drone, \audio),
		).loop,
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\drone, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,0.41,1, 0.4,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,0.41,1, 0.4,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 0,0,1,0,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\drone2, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\drone2, \audio),
			\addAction, \addToTail,
			\fb, 0.5,
			\delay, 1/3/~t,
			\lag, 0.0009,
			\damp, 0.5,
			\size, 1,
			\mix, PmodEnv(Pseq([0,0.2,0.3],1), Pseq([8,24])).loop,
			//\mix, 0.5,
			\dur, 1,
			\out, BusDef(\drone3, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\drone3, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([100,300,1300],1), 16,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);

/////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pdef(\hats2),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				0,
			],inf),
			\freqfac, 
			Pseq([
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([0,4,4,4,5].midiratio,1), 1/2),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([4,4,5].midiratio,1), 1),
				PmodEnv(Pseq([0,4,4,4,4].midiratio,1), 1/2),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 2,0,2,0,

				1,2,0,1, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 2,0,2,0,
				1,1,1,1, 1,1,2,0,
				1,1,2,0, 1,1,2,0,
				2,0,1,1, 1,1,2,0,
				1,2,0,1, 2,0,2,0,
				3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Ptpar([
			0, Pbind(
			   	\instrument, \sawbass,
			   	\note, Pseq([
			   		4,4,4,4,
			   		4,4,4,4-12,
			   	],inf).stutter(4) + Pseq([
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,-1,0,
			   	]*12,inf),
			   	\octave, Pstep(Pseq([5,6],inf),8),
			   	\legato, Pseq([
			   		4,1,1,4, 1,1,4,1,
			   		2,1,4,2, 2,1,2,1,
			   	],inf)/8,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,0,1,1, 1,1,1,1,
			   		1,1,1,1, 1,1,1,1,
			   		1,0,0,0, 1,1,0,1,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   ),
		]),
		
	])
)).play;
);
