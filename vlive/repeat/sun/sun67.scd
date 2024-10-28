
~t = 82/2/60; TempoClock.default.tempo = ~t;
// monk higgins railroad


(
Pdef(\melo, 
	Pbind(
		\instrument, \violin2,
	)
)
);

(
FileSystemProject.load("holis/synthdef.scd");
SynthDef(\violin, {
	| midinote=60, gate=1, amp=0.8 |
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.1), gate, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(0, sig!2);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
SynthDef(\violin2, {
	| midinote=60, gate=1, amp=0.8 |
	var env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(0, sig!2);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
)

ProtoDef(\piano).startControl(Pdef(\melo))


(
Pdef(\part2, Pdef(\zedpartx2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[727].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[727].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2437].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2437].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],6),
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 0,1,0,0,
			]*0.7,inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[324].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[324].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0.99,
				0,0.91,
				0,0.98,
				0,0.81,
				0,0.99,
				0,0.91,
				0,0.98,
				0,0.71,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, Pwrand([0.9,1],[0.9,0.1],inf),
			\gain, 0.11/2 * Pseg(Pwhite(0.1,1,inf),1),
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				2,\r,\r,\r, \r,\r,5,\r,
				8,\r,\r,\r, \r,\r,\r,\r,

				2,\r,\r,\r, \r,\r,5,2,
				-4,\r,\r,\r, \r,\r,\r,\r,
			],inf),
			\lpf, ~pmodenv.(Pseq([1,2,1,6]*70,1), 4).loop,
			\rq, ~pmodenv.(Pseq(1/[1,2,1,4,8],1), 5).loop,
			\legato, Pseq([
				6,0,0,0, 0,0,1,0,
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,1,1,
				6,0,0,0, 0,0,0,0,
			]*0.8,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\bass1, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				2,\r,\r,\r, \r,\r,5,\r,
				8,\r,\r,\r, \r,\r,\r,\r,

				2,\r,\r,\r, \r,\r,5,2,
				-4,\r,\r,\r, \r,\r,\r,\r,
			],inf),
			\lpf, ~pmodenv.(Pseq([1,2,1,6]*70,1), 4).loop,
			\rq, ~pmodenv.(Pseq(1/[1,2,1,4,8],1), 5).loop,
			\legato, Pseq([
				6,0,0,0, 0,0,1,0,
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,1,1,
				6,0,0,0, 0,0,0,0,
			]*0.8,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[727].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[727].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2437].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2437].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],6),
					0,0,0,1, 0,0,1,0,
					0,1,0,0, 0,1,0,0,
			]*0.7,inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[324].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[324].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0.99,
				0,0.91,
				0,0.98,
				0,0.81,
				0,0.99,
				0,0.91,
				0,0.98,
				0,0.71,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, Pwrand([0.9,1],[0.9,0.1],inf),
			\gain, 0.11/2 * Pseg(Pwhite(0.1,1,inf),1),
		),
	])
)).play;
);

////////////: seq



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\bass1),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				2,Prand([2,4,5,7,8],7),
				2,Prand([2,4,5,7,8],7),
				8,Prand([8],7),
				8,Prand([2,4,5,7,8],7),
			],inf),
			\octave, Pseq([6,5],inf),
			\octave, [6,5],
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0.2,0.2,0.2,0.2,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0.1,0.1,0.1,0.1,
				],1),
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0.2,0.2,0.2,0.2,
					1,0.51,0,0.51, 0.50,0,0.51,0.50,
					0,0,0,0, 0.1,0.1,0.1,0.1,

					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0.2,0.2,0.2,0.2,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0.1,0.1,0.1,0.1,

				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0.2,0.2,0.2,0.2,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0.1,0.1,0.1,0.1,
			],inf).coin.not,
			\dur, 1/16,
			\octbal, Pseg(Pwhite(0.0,1,inf),2),
			\amp, 0.1/2 * Ptuple([Pkey(\octbal) ,1-Pkey(\octbal) ]),
			//\out, BusDef(\ifx1, \audio),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chordgrowp,
			\note, 0,
			\chord, Pseq([
				[ [2,5,8] ],
			],inf),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 2,
			\timeScale, 0.7,
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.1,1,7) ],
			],inf),
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\room, 4,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\bass1),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				2,Prand([2],7),
				2,Prand([2,4,5,7,8],7),
				8,Prand([8],7),
				8,Prand([2,4,5,7,8],7),
			],inf),
			\octave, Pseq([6,5],inf),
			\octave, [6,5],
			\isRest, Pseq([
				Pseq([
					1,0.2,0.8,0.2,
				],1),
			],inf).coin.not,
			\dur, 1/16,
			\octbal, Pseg(Pwhite(0.0,1,inf),2),
			\amp, 0.1/2 * Ptuple([Pkey(\octbal) ,1-Pkey(\octbal) ]),
			//\out, BusDef(\ifx1, \audio),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \chordgrowp,
			\note, 0,
			\chord, Pseq([
				[ [2,5,8] ],
			],inf),
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 2,
			\timeScale, 0.7,
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.1,1,7) ],
			],inf),
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\room, 4,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);



////////////////// draft
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[2,5,8],
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono( \chordgrow,
			\note, 0,
			\chord, Pseq([
				[ [2,5,8] ],
			],inf),
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
		Pbind(
			\instrument, \chordgrow,
			\note, 0,
			\chord, Pseq([
				[ [2,5,8] ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\chordgrow2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([1,4000,1],[6.1,4.8],\exp), 1);
	lfo2 = EnvGen.kr(Env([1/3,20,1],[6.1,4.8],\exp), 1);
	sig = SinOsc.ar(freq * \chord.kr([0,4,7]).midiratio);
	sig = sig + LFSaw.ar(freq/2 * \chord.kr([0,4,7]).midiratio);
	sig = sig.mean;
	sig = sig + DelayC.ar(sig, 0.1,0.0001 * lfo1);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\chordgrow, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([1,4000,1],[6.1,4.8],\exp), 1);
	lfo2 = EnvGen.kr(Env([1/3,20,1],[6.1,4.8],\exp), 1);
	sig = SinOsc.ar(freq * \chord.kr([0,4,7]).midiratio);
	sig = sig + LFSaw.ar(freq/2 * \chord.kr([0,4,7]).midiratio);
	sig = sig.mean;
	sig = sig + DelayC.ar(sig, 0.1,0.0001 * lfo1);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(5.1,0.1,0.8,0.1,1,4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \chordgrow,
			\note, 0,
			\chord, Pseq([
				[ [2,5,8] ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\chordgrowp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([1,4000,1],[6.1,4.8],\exp), 1, timeScale:\timeScale.kr(1));
	lfo2 = EnvGen.kr(Env([1/3,20,1],[6.1,4.8],\exp), 1, timeScale:\timeScale.kr);
	sig = SinOsc.ar(freq * \chord.kr([0,4,7]).midiratio);
	sig = sig + LFSaw.ar(freq/2 * \chord.kr([0,4,7]).midiratio);
	sig = sig.mean;
	sig = sig + DelayC.ar(sig, 0.1,0.0001 * lfo1);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(5.1,0.1,0.8,0.1,1,4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);



(
SynthDef(\fx_midsatur, { arg out=0, gate=1, lpf=15000, hpf=300;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = LPF.ar(sig, lpf);
	sig = HPF.ar(sig, hpf);
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = LPF.ar(sig, lpf);
	sig = HPF.ar(sig, hpf);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
TagSpecDef(\SynthDef_fx).addUnique(\fx_midsatur);
);


(
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus5, \audio)) <>
	Ppar([
		Pdef(\drums1),
		Pdef(\bass1),
	])
)).play;
);

(
SynthDef(\fx_saturarray, { arg out=0, gate=1, lpf=15000, hpf=300;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num = 10;
	sig = in;

	sig = num.collect { arg idx;
		var isig;
		isig = DelayL.ar(sig, 0.1, idx.linexp(0,num-1,\lodel.kr(20),\hidel.kr(18000)).reciprocal) + sig;
		isig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2)
	};
	sig = sig.mean;


	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
TagSpecDef(\SynthDef_fx).addUnique(\fx_saturarray);
);
