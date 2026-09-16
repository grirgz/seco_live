
(
~t = 141/2/60; TempoClock.default.tempo = ~t;
)
Pdef.defaultQuant = 1;

(
SynthDef(\glass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,2,1.01]).mean;
	sig = sig + SinOsc.ar(freq/2, mul: XLine.kr(1,0.001,0.05));
	sig = sig * \distamp.kr(1);
	sig = sig.tanh;
	sig = Resonz.ar(sig, \cutoff.kr(300));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\brouilpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lpenv, hpenv;
	env1 = EnvGen.kr(Env([1,0,1,0],[0.1,3.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0,1,0],[0.1,1.1,2.8]), 1);
	env3 = EnvGen.kr(Env([0,1,0],[4.1,0.8]), 1);
	sig = LFPulse.ar(freq * LFSaw.ar(freq * 2.00723*[1,0.99] * ( env1+1 ), add:1, mul:1.4));

	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.03,2.4,0.1,1.2)), gate, doneAction:0) * \lpadsramt.kr(7) + 1;
	sig2 = BPF.ar(sig, ( \bpf.kr(480) * lpenv ).clip(20,20000), \rq.kr(0.3)) * 2;

	sig = LPF.ar(sig, \lpf.kr(7180));
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = sig + sig2;

	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = DelayL.ar(sig, 0.2, ( env2+1 ) * 0.1) + sig;
	sig = DelayL.ar(sig, 0.2, ( env3*0.4+1 ) * 0.01) + sig;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\monobass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1/4*~t, pi/2) * 0.2; 
	lfo2 = SinOsc.ar(2/1*~t, pi/2).range(1,2) * SinOsc.ar(1/16*~t, 3*pi/2).range(0.5,2); 
	mod2 = SinOsc.ar(freq * [0.9999,1,1.001]) * 4 * ( lfo1 + 1 );
	mod1 = SinOsc.ar(freq/2 * [0.9999,1,1.001], mod2) * 2 * lfo2;
	sig = SinOsc.ar(freq * mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.2), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

//////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[327].value,
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
			\bufnum, ~buflib.snare[953].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[287].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.09,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1041].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,2,-5,-8,6,5,4,5,
			],inf),
			\envamt, Pseq([
				2,2,2,4, 5,1,6,7,
				2,5,2,4, 2,4,6,7,
			],inf),
			\lpf, PmodEnv(Pseq([100,400],1), 32, \exp).loop,
			\octave, 3 + Pseq([
				0,0,0,0, -1,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, -1,0,0,0,
				0,0,1,0, 2,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseg(Pseq([0.2,1],1),32).loop,
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
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[327].value,
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
			\bufnum, ~buflib.snare[953].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
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
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[287].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.09,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1041].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				Pseq([
					[3, 6,8,13],
				],3),
				[3, 6,8,12],
			],inf),
			\dur, 4,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				11,10,9,8,
			],inf).stutter(16*2),
			\octave, 3,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.11,0.1,0.8,0.01) ],
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				13,8,6,3,
			],inf),
			\octave, 5,
			\envamt, 7,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.4,
			\lpf, 100,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				Pser([
					[8,13],
					[3,6,13],
				],3),
				[3, 8,12],
			],inf),
			\dur, 4,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				11,10,9,8,
			],inf).stutter(16*2),
			\octave, 3,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.11,0.1,0.8,0.01) ],
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				13,8,6,3,
			],inf),
			\octave, 5,
			\envamt, Pseg(Pseq([1,8],1),32).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.4,
			\lpf, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				[0,4,7],
				[1,4,7],
				[2,5,9],
				[-1,2,7],
			],inf),
			\dur, 2,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/4,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \glass,
			\note, Pseq([
				[0,3,7],
				[0,3,7,10],
				[-4,0,3],
				[-3,0,5],
				Pseq([
					[0,3,7],
					[-3,0,5],
				],2),
			],inf),
			\dur, 2,
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.1,0.8,2.1) ],
			],inf),
			\amp, 0.1/1,
		),
		Pmono(
			 \monobass2,
			\note, Pseq([
				Pseq([ 0,7, ],4),
				Pseq([ 0,10, ],4),
				Pseq([ 0,3, ],4),
				Pseq([ 0,5, ],4),

					Pseq([ 0,7, ],4),
					Pseq([ 0,5, ],4),
					Pseq([ 3,7, ],4),
					Pseq([  5,0,5,0, 5,9,0,5, ],1),
			],inf),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,5,3,5,
				7,5,3,5,
			],inf),
			\octave, 6,
			\dur, 1/4,
			\envamt, Pseq([
				1,2,2,5,4,7,5,3,
			],inf),
			\lpf, PmodEnv(Pseq([200,600],1), 32, \exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.5) ],
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1, 
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 1,1,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);

////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,2,-5,-8,6,5,4,5,
			],inf),
			\envamt, Pseq([
				2,2,2,4, 5,1,6,7,
				2,5,2,4, 2,4,6,7,
			],inf),
			\lpf, PmodEnv(Pseq([100,400],1), 32, \exp).loop,
			\octave, 3 + Pseq([
				0,0,0,0, -1,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, -1,0,0,0,
				0,0,1,0, 2,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseg(Pseq([0.2,1],1),32).loop,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,2,-5,-8,6,5,4,5,
			],inf),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseg(Pseq([0.2,1],1),32).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);
