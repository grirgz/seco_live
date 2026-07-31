
(
~t = 120/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
)

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[233].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
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
		
	])
)).play;
);

(
SynthDef(\m1_organ2_v, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lpenv, lpfreq;
	sig1 = LFTri.ar(freq/2);
	sig2 = LFPulse.ar(freq).bipolar;
	sig3 = LFPulse.ar(freq*7.midiratio).bipolar * 0.5;
	sig = [ sig1, sig2, sig3 ].mean;
	lpenv = EnvGen.kr(\lpenv.kr(Env([0, 1,0.45,0],[0.001,0.1,0.01])), 1, doneAction:0) * \lpenvamt.kr(8) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(180) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.4,0.2,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);

}, metadata:(specs:(
	lpenv: ParamEnvSpec(\amp!4),
))).add;
);

(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([5000,4000,85,50],[0.25/~t,0.01,2.018]), 1);
	env2 = EnvGen.kr(Env([15150,570,301],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(870, pi/2 * 0.4) * 388; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\bigcrash2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([50,40,485,450],[0.25/~t,0.01,7.018]), 1);
	env2 = EnvGen.kr(Env([510,4570,14301],[0.006,0.8]), 1);
	env3 = EnvGen.kr(Env([1,23,93],[4.006,2.8]), 1);
	mod1 = SinOsc.ar(59.midicps/2, pi/2 * 0.4) * 388; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100) * env3);
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,7.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\nonoz, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(304 * ( SinOsc.ar(10 * ( SinOsc.ar(1) * 1000 + 1 )) * 1000 + 1 )) * 10 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\piknonoz, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = LFNoise1.kr(\nfreq.kr(1/16*~t)).exprange(0.5,10.0);
	mod2 = LFNoise1.kr(\nfreq.kr).exprange(0.5,1000.0);
	sig1 = SinOsc.ar(freq * ( SinOsc.ar(704 * ( SinOsc.ar(10 * ( SinOsc.ar(1) * 1000 + 1 )) * 1000 + 1 )) * mod1 + 1 ));
	sig2 = SinOsc.ar(freq*3/2 * ( SinOsc.ar(freq) * mod2  ));
	sig = [sig1, sig2].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

///////////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
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
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1066].value,
			\bufnum, ~buflib.hat[818].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,11,5,7, 5,8,8,1,
			],inf),
			\dur, 1/8,
			\lpf, 100,
			\envamt, PmodEnv(Pseq([2,8,16],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\amp, 0.07,
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
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				7,7,7,7,
				5,5,5,5,
			],inf).stutter(4),
			\legato, 0.2,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
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
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1066].value,
			\bufnum, ~buflib.hat[818].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 0,0,9,0, ],8),
				Pser([ 7, ],8),
				Pser([ 0,0,-1,0, ],8),
				Pser([ -1,-1,-3,0, ],8),
			],inf),
			\dur, 1/8,
			\lpf, 200,
			\envamt, PmodEnv(Pseq([2,8,16],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 3,
			\amp, 0.07,
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
		Pbind(
			\instrument, \sh101,
			\note, Pstep(Pseq([
				[2,5,9,12], // Dm7
				[7,11,14,17], // G7
				[0,4,7,11], // CMaj7
				[0,4,7,11], // CMaj7
			],inf),1) + [0,0,-12,0],
			\dur, 1/8,
			\lpf, 700,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.1/3,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1066].value,
			\bufnum, ~buflib.hat[818].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
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
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 0,0,9,0, ],8),
				Pser([ 7, ],8),
				Pser([ 0,0,-1,0, ],8),
				Pser([ -1,-1,-3,0, ],8),
			],inf),
			\dur, 1/8,
			\lpf, 200,
			\envamt, PmodEnv(Pseq([2,8,16],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 3,
			\amp, 0.07,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pstep(Pseq([
				[2,5,9], // Dm7
				[7,11,14], // G7
				[0,4,7], // CMaj7
				[0,4,7], // CMaj7
			],inf),1),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.6,0.4) ],
			],inf),
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pstep(Pseq([
				12,12, 12, 11,
				//9, 14, 12, 12,
				//12, 17, 11, 11,
			],inf),1),
			\lpf, 700,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.6,0.4) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
				1,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \m1_organ2_v,
			\note, Pseq([
				4,4,4,4, 4,4,2,0,
				4,4,-5,4, -5,-5,2,0,
			],inf).stutter(2),
			\octave, 6,
			\dur, 1/8,
			\lpf, PmodEnv(Pseq([400,1000],1), 32, \exp).loop,
			\lpenvamt, PmodEnv(Pseq([2,8,14],1), 16).loop,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,1,0,0,
				1,1,1,1, 0,0,1,0,

				0,0,1,0, 0,1,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\amp, 0.071,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \m1_organ2_v,
			\note, Pseq([
				0,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);



////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1066].value,
			\bufnum, ~buflib.hat[818].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
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

		Pbind(
			\instrument, \sh101,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\note, Pseq([
				[2,5,9], // Dm7
				[-5,-1,2],
				//[2,5,9], // Dm7
			],inf).stutter(16),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\hi1, \audio),
		),
		Pbind(
			\instrument, \risy,
			\note, Pseq([
				0,
				//-5,
			],inf).stutter(4),
			\legato, Pseq([
				0,0,0,0,
				1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
				-3,
				0,
				4,
			],inf).stutter(8),
			\legato, 0.4,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				2,2,
				2,-5,
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0, 
				1,0,1,0, 1,1,1,0, 
				1,0,0,1, 0,0,1,0, 
				1,0,1,1, 0,1,1,0, 
			],inf).coin.not,
			\legato, 0.7,
			\lpf, 1400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
SynthDef(\risy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(4*~t) * XLine.kr(0.1,1,1/~t); 
	lfo2 = SinOsc.ar(freq) * XLine.kr(0.1,100,1/~t);
	lfo2 = SinOsc.ar(freq) * SinOsc.ar(8*~t).unipolar * Line.kr(0.1,2480,1/~t);
	lfo3 = SinOsc.ar(freq/2 + lfo2) * SinOsc.ar(2*~t).unipolar * Line.kr(0.1,2480,1/~t);
	//sig = LFTri.ar(freq * lfo2) * lfo1;
	//sig = LFSaw.ar(freq * lfo2);
	sig = SinOsc.ar(freq + lfo2 + lfo3);
	sig = BRF.ar(sig, 100);
	sig = ( sig*2 ).tanh;
	//sig = HPF.ar(sig, \hpf.kr(200));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassaze, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env2 = EnvGen.kr(Env([0.1,1,0],[0.9,3.8],1), 1);
	mod2 = SinOsc.ar(freq) * 700 * env2;
	sig = LFSaw.ar(freq + mod2);
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.04,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(200) * (env1 * \lpenvamt.kr(7.2) + 1), \rq.kr(0.8));
	sig = SinOsc.ar(freq)  + sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1066].value,
			\bufnum, ~buflib.hat[818].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
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
		Pbind(
			\instrument, \bassaze,
			\note, Pseq([
				-4,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\legato, 0.95,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
	])
)).play;
);

(
SynthDef(\bassaze2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env2 = EnvGen.kr(Env([0,1,0],[0.91,3.8],1), 1);
	mod2 = SinOsc.ar(freq*4) * \fma.kr(470) * env2;
	sig = SinOsc.ar(freq + mod2);
	env5 = EnvGen.kr(Env([0,1,0]+0.1,[0.01,0.3],1), 1);
	sig1 = ( sig*\dist.kr(47)*env5 ).tanh;
	sig1 = HPF.ar(sig1, 120);
	sig = SelectX.ar(\distmix.kr(0.2), [sig, sig1]);
	//sig = sig1 * 0.6;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.04,0.8])), 1);
	sig = RLPF.ar(sig, \lpf.kr(800) * (env1 * \lpenvamt.kr(1.2) + 1), \rq.kr(0.8));
	//sig = SinOsc.ar(freq)  + sig /2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1066].value,
			\bufnum, ~buflib.hat[818].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
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
		Pbind(
			\instrument, \bassaze2,
			\note, Pseq([
				-4,0,
			],inf).stutter(Pseq([3,1],inf)),
			\octave, 3,
			\fma, PmodEnv(Pseq([510,200],1), 32, \exp).loop,
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 4,0,0,0,
				1,3,0,0, 4,0,0,0,
				2,0,1,1, 4,0,0,0,
				4,0,0,0, 3,0,0,1,
			],inf)*0.95,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, PmodEnv(Pseq([10000,200],1), 32).loop,
			//\legato, 0.95,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				0,-1
			],inf),
			\octave, 6,
			\dur, 2,
			\ffreq, 8000,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, 4500.0,
			\at, 0.2,
			\sustainlevel, 1.0,
			\rel, 0.7,
			\pan, 0.0,
			\note, Pseq([
				3
			],inf),
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\legato, 0.2,
			//\lag, 0.1/~t,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//[-4,0,4, 8],
				//[-5,0,4, 7],
				//[-4,0,4, 8],
				//[-3,0,4, 9],

				[-2,0,4, 10],
				[-3,0,5, 9],
				[-4,0,5, 8],
				[-5,0,4, 7],
			],1),
			\dur, 1,
			\amp, 0.1/3,
		),
		
	])
)).play;
);


(
SynthDef(\fmspread, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(1/16/~t) + 1)) * \fma.kr(1700);
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmspread,
			\note, Pseq([
				//[-4,0,4, 8],
				//[-5,0,4, 7],
				//[-4,0,4, 8],
				//[-3,0,4, 9],

				[-2,0,4, 10],
				[-3,0,5, 9],
				[-4,0,5, 8],
				[-5,0,4, 7],
			],inf),
			\fma, PmodEnv(Pseq([100,2000,10000],1), 8,\exp).loop,
			//\note, 0,
			\dur, 4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
SynthDef(\fmspread2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0.2],[0.1,2.8]), [1,-1]);
	mod1 = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(1/16/~t) + 1)) * \fma.kr(1700) * env1;
	sig1 = SinOsc.ar(freq + mod1) * Line.kr(0,1,0.2);

	env2 = EnvGen.kr(Env([0,1,0.2],[0.5,1.4]), [1,-1]);
	mod2 = SinOsc.ar(freq/2).tanh * \fma2.kr(70) * env2;
	sig2 = SinOsc.ar(freq + mod2) * EnvGen.kr(Env([0,1,0],[0.01,1.4]), 1);

	sig = [sig1, sig2].sum;
	//sig = sig2;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmspread2,
			\note, Pseq([
				//[-4,0,4, 8],
				//[-5,0,4, 7],
				//[-4,0,4, 8],
				//[-3,0,4, 9],

				[-2,0,4, 10],
				[-3,0,5, 9],
				[-4,0,5, 8],
				[-5,0,4, 7],
			],inf),
			\fspread, PmodEnv(Pseq([0.001,0.1],1), 32, \exp).loop,
			\legato, 0.95,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.3) ],
			],inf),
			//\fma, PmodEnv(Pseq([100,2000,10000],1), 8,\exp).loop,
			\fma, 1000,
			\fma2, 1000,
			\fma, ~pmodsynth.({ SinOsc.ar(4*~t) * Line.kr(0,1,32/~t) + 1 * 800 }),
			//\note, 0,
			\dur, 4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
SynthDef(\fmspread3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0.2],[0.1,2.8]), [1,-1]);
	mod1 = SinOsc.ar(freq/2 * ((0..7)/7 - 0.5 * \fspread.kr(1/16/~t) + 1)) * \fma.kr(1700) * env1;
	sig1 = SinOsc.ar(freq * LFNoise1.kr(1/8!8,mul:0.001,add:1) + mod1) * Line.kr(0,1,0.2);

	env2 = EnvGen.kr(Env([0,1,0.2],[0.5,1.4]), [1,-1]);
	mod2 = SinOsc.ar(freq).tanh * \fma2.kr(70) * env2;
	sig2 = SinOsc.ar(freq  * LFNoise1.kr(1/8!8,mul:0.005,add:1) + mod2) * EnvGen.kr(Env([0,1,0],[0.01,1.4]), 1);

	sig = [sig1, sig2].sum;
	//sig = sig2;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1066].value,
			\bufnum, ~buflib.hat[818].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
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
		Pbind(
			\instrument, \bassaze2,
			\note, Pseq([
				-4,0,
			],inf).stutter(Pseq([3,1],inf)),
			\octave, 3,
			\fma, PmodEnv(Pseq([510,200],1), 32, \exp).loop,
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 4,0,0,0,
				1,3,0,0, 4,0,0,0,
				2,0,1,1, 4,0,0,0,
				4,0,0,0, 3,0,0,1,
			],inf)*0.95,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, PmodEnv(Pseq([10000,200],1), 32).loop,
			//\legato, 0.95,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \fmspread3,
			\note, Pseq([
				0,-1
			],inf),
			\octave, 6,
			\fma, PmodEnv(Pseq([700,4000],1), 32,\exp).loop,
			\fspread, PmodEnv(Pseq([0.1,0.040],1), 16).loop,
			\fma2, 1000,
			\dur, 2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, 4500.0,
			\at, 0.2,
			\sustainlevel, 1.0,
			\rel, 0.7,
			\pan, 0.0,
			\note, Pseq([
				3
			],inf),
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\legato, 0.2,
			//\lag, 0.1/~t,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\synthlfo, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = XLine.kr(0.1,1,1/2/~t);
	mod1 = SinOsc.ar(freq * [1.01/2,2.01,1,2,1/2]) * ( SinOsc.ar(8*~t) * env1 + 1 ) * 280;
	sig = SinOsc.ar(freq + mod1);
	//sig = sig * 0.4;
	//sig = BPF.ar(sig, 400) *2;
	sig = HPF.ar(sig, \hpf.kr(90));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1/2/~t,0.1,0.8,0.1,1,1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.3), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[233].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
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
		Pbind(
			\instrument, \fmspread3,
			\note, Pseq([
				0,-1
			],inf),
			\octave, 6,
			\fma, PmodEnv(Pseq([1700,140,400,1000,800],1), 8,\exp).loop,
			\fspread, PmodEnv(Pseq([0.0001,0.040],1), 16,\exp).loop,
			\fma2, 2100,
			\dur, 2,
			\amp, 0.1/2,
			\out, BusDef(\fms, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fms, \audio),
			\delay, 0.1,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, 4500.0,
			\at, 0.2,
			\sustainlevel, 1.0,
			\rel, 0.7,
			\pan, 0.0,
			\note, Pseq([
				3
			],inf),
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\legato, 0.2,
			//\lag, 0.1/~t,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \synthlfo,
			\note, Pseq([
				0,
				7,
			],inf).stutter(16),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[214].value,
			\bufnum, ~buflib.foley1[107].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\folv, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\folv, \audio),
			\addAction, \addToTail,
			\room, 1,
			\mix, 0.3,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.408,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				4,0,0,0, 1,0,0,1,
				0,0,2,0, 1,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.618,
			\pos, 0.74,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\levelScale, 2.2,
			\timeScale, 2,
			\finepos, 1/400,
			\legato, Pseq([
				0,0,2,0, 0,0,2,0,
				0,0,3,0, 0,0,1,0,
				0,0,3,0, 0,0,1,0,
				0,0,2,0, 0,0,2,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3,1,[1,-7]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, PmodEnv(Pseq([10,-200],1), 16,\exp).loop,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,1450,700,
			],inf) * Pseq([1,3,2,5],inf).stutter(4),
			//\ffreq, PmodEnv(Pseq([100,10000],1), 32,\exp).loop,
			\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		) 
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.408,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([
			4,0,0,0, 1,0,0,1,
		   	0,0,2,0, 1,0,1,1,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,2,1/2],inf).stutter(4),
		\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

	) 
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	Pbind(
		\instrument, \oscsampler3,
		\pos, 0.618,
		\freq, 187,
		\range, 0.0000001,
		\posenv, Pseq([
			[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		],inf),
		\finepos, 1/400,
		\legato, Pseq([
			//0,0,2,0, 0,0,2,0,
			2,0,2,0, 2,0,2,0,
		],inf)/2,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.3,1,[1,-7]) ],
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\fshift, 40,
		\lpmix, 1,
		\rq, 0.4,
		\hpmix, 0,
		\hpfreq, 100,
		\ffreq, Pseq([
			1020,5240,450,700,
		],inf) * Pseq([1,3,2,1/2],inf).stutter(4),
		\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

	) 
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1395].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[233].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
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
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				0,-1
			],inf),
			\octave, 6,
			\ffreq, 7000,
			\legato, 0.6,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\fms, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fms, \audio),
			\delay, 0.1,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, 4500.0,
			\at, 0.2,
			\sustainlevel, 1.0,
			\rel, 0.7,
			\pan, 0.0,
			\note, Pseq([
				3
			],inf),
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\legato, 0.2,
			//\lag, 0.1/~t,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \synthlfo,
			\note, Pseq([
				0,
				7,
			],inf).stutter(16),
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\octave, 3,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[214].value,
			\bufnum, ~buflib.foley1[107].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\folv, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\folv, \audio),
			\addAction, \addToTail,
			\room, 1,
			\mix, 0.3,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.408,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				4,0,0,0, 1,0,0,1,
				0,0,2,0, 1,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.618,
			\pos, 0.74,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\levelScale, 2.2,
			\timeScale, 2,
			\finepos, 1/400,
			\legato, Pseq([
				0,0,2,0, 0,0,2,0,
				0,0,3,0, 0,0,1,0,
				0,0,3,0, 0,0,1,0,
				0,0,2,0, 0,0,2,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3,1,[1,-7]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, PmodEnv(Pseq([10,-200],1), 16,\exp).loop,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,1450,700,
			],inf) * Pseq([1,3,2,5],inf).stutter(4),
			//\ffreq, PmodEnv(Pseq([100,10000],1), 32,\exp).loop,
			\amp, 0.1/3,
			\bufnum, BufDef.stereo('voices/feynman.flac'),

		) 
	])
)).play;
);


(
SynthDef(\oscsmp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var osc;
	var phase;
	var posenv;
	osc = SinOsc.ar(freq) *  \oscrange.kr(1);
	posenv = EnvGen.kr(\posenv.kr(Env([0,1,1.1,0],[0.1,1,2.8])), 1, levelScale:\levelScale.kr(1));
	phase = \pos.kr(0) + posenv * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase + osc % BufFrames.kr(bufnum), 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[453].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
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
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.618,
			\pos, 0.777,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\levelScale, 2.2,
			\timeScale, 2,
			\finepos, 1/400,
			\legato, Pseq([
				0,0,2,0, 1,0,1,1,
				0,0,2,0, 1,0,1,1,
				0,0,2,0, 1,0,1,1,
				0,1,0,0, 1,0,1,0,
				0,0,2,0, 1,0,1,1,
				0,0,2,0, 1,0,1,1,
				0,0,2,0, 1,0,1,1,
				0,1,0,1, 0,0,1,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3,1,[1,-7]) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, PmodEnv(Pseq([10,-200],1), 16,\exp).loop,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,1450,700,
			],inf) * Pseq([1,3,2,5],inf).stutter(4),
			//\ffreq, PmodEnv(Pseq([100,10000],1), 32,\exp).loop,
			\ffreq, 3000,
			\amp, 0.07,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\out, BusDef(\ppp, \audio),
		), 
		Pmono(\fx_hpf,
			\inbus, BusDef(\ppp, \audio),
			\hpf, PmodEnv(Pseq([300,10,1000],1), 16, \exp).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\pos, 1.455,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 340,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),
		), 
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.655,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,4,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 340,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),
		), 
		Pbind( // bass
			\instrument, \oscsmp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\pos, 9.130,
			\note, Pseq([
				0,4,
				-1,3,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\levelScale, ~pmodenv.(Pseq([0.01,0.1,0.02],1), 8).loop,
			\levelScale, 0.051,
			\levelScale, Pseg(Pseq([0,0.01]+0.051,inf),32),
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,1.1,5.8]) ],
				//[ Env([0,0.51,0.1,0.1].integrate,[0.002,0.1,1.8]) ],
				//[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\oscrange, 80,
			\legato, 0.81,
			\dur, 1/4,
			\amp, 0.5,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1860].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1902].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,0,
				1,1,0,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \randgranpitch,
			\mbufnum, BufDef.mono('notes/trumpet.flac'), // la#
			\note, Pseq([
				[0, 3, 7],
				[0, 3, 8],
				[0, 3, 6],
				[0, 3, 7],
			],inf),
			\pitch_stretch, ( Pkey(\note)+2 ).midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.7,0.6,1.3) ],
			],inf),
			\pos, PmodEnv(Pseq([0.1,0.21],3), 8).loop,
			\dur, 2,
			\gain, 0.071,
			\out, BusDef(\tru, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\tru, \audio),
			\addAction, \addToTail,
			\lpf,2000,
			\hpf, 800,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\randgranpitch, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.2, pan;
	var sig;
	var clk;
	var phase;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	clk = Impulse.ar(\gfreq.kr(90));
	mod1 = Demand.ar(clk, 0, Dseq([
		1,1,1,2,
	],inf));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos + LFNoise0.kr(\gfreq.kr,mul:\range.kr(0.01));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch * mod1, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.655,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 340,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		) 
	])
)).play;
);

BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");

(
Pdef(\part, Pdef(\rytno1, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.655,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 340,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.455,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 4.3,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.475,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 4.3,
			\legato, Pseq([
				0,0,0,0, 2,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 0,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.485,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 4.3,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,2,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 0,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),
		),
	])
)).play;
);

(
// eparse
Pdef(\part, Pdef(\rytno2, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.655,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 340,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.455,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 4.3,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,0,0,
				],2),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.475,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 4.3,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,0,0, 2,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 0,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.485,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 4.3,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,0,
				],4),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 0,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\rytno1),
		
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,4,7],
				[1,4,7],
				[2,5,9],
				[-1,2,7],
			],inf),
			\dur, 2,
			\at, 0.2,
			\rel, 1/2,
			\legato, 0.5,
			\amp, 0.1,
		),
	])
)).play;
);


/////////////





(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		
		Pdef(\rytno1),
	])
)).play;
);

(
SynthDef(\bassdeep, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	mod1 = SinOsc.ar(freq/2) * \fac1.kr(10) * 1; 
	sig1 = SinOsc.ar(freq * 1.01 + mod1);
	lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0, 1,0,0,0,
		1,0,0,1, 0,0,1,0,
	],inf)).lag(1/8/~t);
	lfo2 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0, 1,0,0,0,
		1,1,0,1, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,1,0,
		1,0,0,0, 1,0,0,0,
	],inf)).lag(1/8/~t);
	//sig = BPF.ar(sig, lfo1 + 1 * 90) + sig;
	sig2 = SinOsc.ar(freq + (sig1 * ( lfo1 + 1 * \fac1.kr * 50 )));
	//sig2 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig3 = SinOsc.ar(freq + (sig1 * ( lfo2 + 1 * \fac1.kr * 50 )));
	sig = [sig1, sig2, sig3].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\bassdeep, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	mod1 = SinOsc.ar(freq/2) * \fac1.kr(10) * 1; 
	sig1 = SinOsc.ar(freq * 1.01 + mod1);
	lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0, 0,0,0,0,
	],inf)).lag(1/8/~t);
	lfo2 = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,1,0,0, 1,0,0,0,
	],inf)).lag(1/8/~t);
	//sig = BPF.ar(sig, lfo1 + 1 * 90) + sig;
	sig2 = SinOsc.ar(freq + (sig1 * ( lfo1 + 1 * \fac1.kr * 50 )));
	//sig2 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig3 = SinOsc.ar(freq + (sig2 * ( lfo2 + 1 * \fac1.kr * 90 )));
	sig = [sig1, sig2, sig3].mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		
		Pdef(\rytno1),
		Pmono( \bassdeep,
			\note, Pseq([
				-4,
			],inf),
			\octave, 3,
			\fac1, PmodEnv(Pseq([1,40],1), 32, \exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono( \bassdeep,
			\note, Pseq([
				-4,
			],inf),
			\octave, 3,
			\fac1, PmodEnv(Pseq([1,40],1), 32, \exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\fmgbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fratio=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = FMGrain.ar(
		Impulse.ar(freq*2), \gdur.kr(0.01), freq , freq*fratio * ( 1 + ( SinOsc.ar(freq*2) * \fma.kr(0.001) )),
		LFSaw.ar( freq!2 ).range(0.1, 1 * env1),
	).sum;
	sig = sig * 3;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\rytno1),

		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\gain, Pstep(Pseq([0,1,1,1],inf),2),
			\dur, 1,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		

		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				3,\r,2,\r,
			],inf)-2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\fratio, Pseq((1..4),inf).stutter(8*8),
			//\out, BusDef(\sendbus1, \audio),
			\fma, PmodEnv(Pseq([100,4000],1), 16,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/8
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bigcrash2,
			\freq, 200,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\rytno1),

		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\gain, Pstep(Pseq([0,1,1,1],inf),2),
			\dur, 1,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		

		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				3,\r,2,\r,
			],inf)-2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\fratio, Pseq((1..4),inf).stutter(8*8),
			//\out, BusDef(\sendbus1, \audio),
			\fma, PmodEnv(Pseq([100,4000],1), 16,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/8
		),
		Pbind(
			\instrument, \bigcrash,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\rytno1),

		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\gain, Pstep(Pseq([0,1,1,1],inf),2),
			\dur, 1,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		

		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-7,\r,-2,\r,
			],inf)-2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\fratio, Pseq((1..4),inf).stutter(8*8),
			//\out, BusDef(\sendbus1, \audio),
			\fma, PmodEnv(Pseq([100,4000],1), 16,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/5,
		),
		Pbind(
			\instrument, \bigcrash,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-1,\r,0,0,
				//\r,0,\r,\r,
			],inf)-2,
			\octave, 3,
			\lpf, 100,
			\envamt, 7,
			\dur, 1/8,
			\amp, 0.1,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pser([
					1,
				],8*8*3),
			],inf).coin.not,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\isRest, Pswitch1([
				true,
				Pkey(\isRest),
			],Pstep( 
				Pseq([
					Pn(0,6), Pn(1,2),
					Pn(0,2), Pn(1,4), Pn(0,2), 
					Pn(1,2), Pn(0,2), Pn(0,2), Pn(1,2),
				],inf),
		   	1)),
		)
		<>
		Pdef(\rytno1),

		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\gain, Pstep(Pseq([0,1,1,1],inf),2),
			\dur, 1,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		

		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-7,\r,-2,\r,
			],inf)-2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\fratio, Pseq((1..4),inf).stutter(8*8),
			//\out, BusDef(\sendbus1, \audio),
			\fma, PmodEnv(Pseq([100,4000],1), 16,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/5,
			\isRest, true,
		),
		Pbind(
			\instrument, \bigcrash,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1635].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseg(Pseq([1,0.2],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
			\out, BusDef(\mhat, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mhat, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4,4,4],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-1,\r,0,0,
				//\r,0,\r,\r,
			],inf)-2,
			\octave, 3,
			\lpf, 100,
			\envamt, 7,
			\dur, 1/8,
			\amp, 0.1,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		),
	])
)).play;
);

(
// rytno2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\rytno2),

		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\gain, Pstep(Pseq([0,1,1,1],inf),2),
			\dur, 1,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		

		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-7,\r,-2,\r,
			],inf)-2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\fratio, Pseq((1..4),inf).stutter(8*8),
			//\out, BusDef(\sendbus1, \audio),
			\fma, PmodEnv(Pseq([100,4000],1), 16,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/5,
			\isRest, true,
		),
		Pbind(
			\instrument, \bigcrash,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1635].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseg(Pseq([1,0.2],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
			\out, BusDef(\mhat, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mhat, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4,4,4],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-1,\r,0,0,
				//\r,0,\r,\r,
			],inf)-2,
			\octave, 3,
			\lpf, 100,
			\envamt, 7,
			\dur, 1/8,
			\amp, 0.1,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		),
	])
)).play;
);

(
// more instr
Pdef(\part, Pdef(\loop1, 
	Ppar([
		Pdef(\drums1),
		Ptpar([
			8, Pdef(\rytno2),
		]),

		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\gain, Pstep(Pseq([0,0,0,0,1,1,1,0],inf),1/2),
			\dur, 1/4,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		

		Pbind(
			\instrument, \fmgbass,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-7,\r,-2,\r,
			],inf)-2,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\fratio, Pseq((1..4),inf).stutter(8*8),
			//\out, BusDef(\sendbus1, \audio),
			\fma, PmodEnv(Pseq([100,4000],1), 16,\exp).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/5,
			\isRest, true,
		),
		Pbind(
			\instrument, \bigcrash,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \bigcrash2,
			\dur, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.08,
		),
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([
				-1,0,0,0,
				-1,0,0,0,
				-1,0,0,0,
				-1,\r,0,0,
				//\r,0,\r,\r,
			],inf)-2,
			\octave, 3,
			\lpf, Pseg(Pseq([100,300],inf),32,\exp),
			\envamt, Pseg(Pseq([5,11],1), 32).loop,
			\dur, 1/8,
			\amp, 0.1,
			\legato, Pseq([
				Pser([
					0.5,
				],3*4),
				Pser([
					1.8,
				],1*4),
		
			],inf),
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		),
		Ptpar([
			32, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[1635].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, 1/8,
					\legato, Pseg(Pseq([1,0.2],inf),8),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\gain, 0.11,
					\out, BusDef(\mhat, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\mhat, \audio),
					\addAction, \addToTail,
					\hpf, 1000,
					\lpf, 4000,
					\ffac, PmodEnv(Pseq([1,2,4,4,4],1), 8).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			24, Pbind(
				\instrument, \oscsampler3,
				\pos, 0.510,
				\freq, 187,
				\range, 0.0000001,
				\posenv, Pseq([
					[ Env([0.00,0.01301,0.01].integrate.postln,[4.01,4.1]) ],
				],inf),
				\finepos, 1/400 * Pseq([1,4,2,2],inf),
				\levelScale, 4.3,
				\legato, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,2,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,0,0,
					],3),
					0,0,0,0, 0,0,0,0,
					0,0,2,0, 0,2,0,0,
				],inf) * 1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.1,0.2) ],
					//[ Env.adsr(0.1,0.1,0.6,0.2) ],
				],inf).stutter(16),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8/2,
				\fshift, 0,
				\lpmix, 1,
				\rq, 0.4,
				\hpmix, 1,
				\hpfreq, 50,
				\ffreq, Pseq([
					1020,5240,8450,700,
				],inf) * Pseq([1,2,1/2],inf).stutter(4),
				\ffreq, 8000,
				\amp, 0.2,
				\bufnum, BufDef.stereo('voices/feynman.flac'),
				\bufnum, BufDef.stereo('vipere/metal.flac'),
			),
			16, Pbind(
				\instrument, \oscsampler3,
				\pos, 0.390,
				\freq, 187,
				\range, 0.0000001,
				\posenv, Pseq([
					[ Env([0.00,0.02301,0.001].integrate.postln,[0.01,4.1]) ],
				],inf),
				\finepos, 1/400 * Pseq([1,4,2,2],inf),
				\levelScale, 1.3,
				\legato, Pseq([
					Pseq([
						0,0,0,0, 4,0,0,0,
						0,0,0,0, 0,4,0,0,
					],4),
					Pseq([
						0,4,0,4, 0,0,0,0,
						0,0,0,0, 0,4,0,0,
						0,0,0,4, 0,0,4,0,
						0,0,0,0, 0,4,0,0,
					],2),
					Pseq([
						0,0,0,0, 4,0,0,4,
						0,0,4,0, 0,4,0,0,
						0,0,0,0, 4,0,0,4,
						0,4,0,0, 0,4,0,0,
					],2),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\fshift, 0,
				\lpmix, 1,
				\rq, 0.4,
				\hpmix, 1,
				\hpfreq, 50,
				\ffreq, Pseq([
					1020,5240,450,700,
				],inf) * Pseq([1,2,1/2],inf).stutter(4),
				\ffreq, 8000,
				\amp, 0.1,
				\bufnum, BufDef.stereo('voices/feynman.flac'),
				\bufnum, BufDef.stereo('vipere/metal.flac'),
			),
		]),
	])
)).play;
);

(
// no drum no bass
Pdef(\part, Pdef(\loop1simple, 
	Ppar([

		Pmono(\nonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.05,
			\out, BusDef(\nono, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\nono, \audio),
			\addAction, \addToTail,
			\hpf, 2000,
			\lpf, 4000,
			\ffac, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\lag, 0.0009,
			\gain, Pstep(Pseq([0,0,0,0,1,1,1,0],inf),1/2),
			\dur, 1/4,
		),
		Pmono(\piknonoz,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pikno, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\pikno, \audio),
			\note, 12,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.8,
		),
		

		Pbind(
			\instrument, \bigcrash,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \bigcrash2,
			\dur, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.08,
		),
		Ptpar([
			32, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[1635].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, 1/8,
					\legato, Pseg(Pseq([1,0.2],inf),8),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\gain, 0.11,
					\out, BusDef(\mhat, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\mhat, \audio),
					\addAction, \addToTail,
					\hpf, 1000,
					\lpf, 4000,
					\ffac, PmodEnv(Pseq([1,2,4,4,4],1), 8).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			24, Pbind(
				\instrument, \oscsampler3,
				\pos, 0.510,
				\freq, 187,
				\range, 0.0000001,
				\posenv, Pseq([
					[ Env([0.00,0.01301,0.01].integrate.postln,[4.01,4.1]) ],
				],inf),
				\finepos, 1/400 * Pseq([1,4,2,2],inf),
				\levelScale, 4.3,
				\legato, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,2,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,2,0, 0,0,0,0,
					],3),
					0,0,0,0, 0,0,0,0,
					0,0,2,0, 0,2,0,0,
				],inf) * 1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.1,0.2) ],
					//[ Env.adsr(0.1,0.1,0.6,0.2) ],
				],inf).stutter(16),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8/2,
				\fshift, 0,
				\lpmix, 1,
				\rq, 0.4,
				\hpmix, 1,
				\hpfreq, 50,
				\ffreq, Pseq([
					1020,5240,8450,700,
				],inf) * Pseq([1,2,1/2],inf).stutter(4),
				\ffreq, 8000,
				\amp, 0.2,
				\bufnum, BufDef.stereo('voices/feynman.flac'),
				\bufnum, BufDef.stereo('vipere/metal.flac'),
			),
			16, Pbind(
				\instrument, \oscsampler3,
				\pos, 0.390,
				\freq, 187,
				\range, 0.0000001,
				\posenv, Pseq([
					[ Env([0.00,0.02301,0.001].integrate.postln,[0.01,4.1]) ],
				],inf),
				\finepos, 1/400 * Pseq([1,4,2,2],inf),
				\levelScale, 1.3,
				\legato, Pseq([
					Pseq([
						0,0,0,0, 4,0,0,0,
						0,0,0,0, 0,4,0,0,
					],4),
					Pseq([
						0,4,0,4, 0,0,0,0,
						0,0,0,0, 0,4,0,0,
						0,0,0,4, 0,0,4,0,
						0,0,0,0, 0,4,0,0,
					],2),
					Pseq([
						0,0,0,0, 4,0,0,4,
						0,0,4,0, 0,4,0,0,
						0,0,0,0, 4,0,0,4,
						0,4,0,0, 0,4,0,0,
					],2),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\fshift, 0,
				\lpmix, 1,
				\rq, 0.4,
				\hpmix, 1,
				\hpfreq, 50,
				\ffreq, Pseq([
					1020,5240,450,700,
				],inf) * Pseq([1,2,1/2],inf).stutter(4),
				\ffreq, 8000,
				\amp, 0.1,
				\bufnum, BufDef.stereo('voices/feynman.flac'),
				\bufnum, BufDef.stereo('vipere/metal.flac'),
			),
		]),
	])
)).play;
);

(
// add synth
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\loop1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				12,1,-1,
			],inf),
			\octave, 6,
			\lpf, 100,
			\envamt, Pseg(Pseq([1,4,18],1), 8).loop,
			\rq, Pseg(Pseq([0.7,0.31],1),16).loop,
			\adsr, Pseq([
				PpatEnv.adsr(0.01,0.1,0.8, Pseg(Pseq([0.01,1],1),16).loop),
			],inf),
			\legato, 0.3,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\hiz, \audio),
		),
		Pmono(\fx_echodiff,
			\out, 0.0,
			\diffmul, 1.0,
			\diffadd, 0.01,
			\lpf, 9000.0,
			\hpf, 750.0,
			\pfmix, 0.5,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\hiz, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0.1,0.1,1,1,2],1),8).loop,
			\delay, Pseg(Pseq([0.001,0.1],1),8, \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
// add synth
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\loop1),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Pser([15],2),
				Pser([9],14),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 1,1,1,1,
				1,1,1,1, 0,0,1,1,
				1,1,1,1, 1,1,1,0,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,0,0,
				0,1,0,0, 1,1,0,0,
			],inf).coin.not,
			\octave, Pseq([
				Pser([
					4,4,4,4,5,
				],8*8*2),
				Pser([
					5,5,5,4,
					5,5,5,4,
					5,4,5,5,
					5,4,5,5,
				],8*8*2),
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
// add synth
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\loop1),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				9,
				10,
				9,
				10,
				9,
				12,
				9,
				12,
			],inf).stutter(1),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				4,
				4,
				3,
				1,
			],inf).stutter(1),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([3000,17000,5000],inf), 16, \exp).loop,
			\hpf, PmodEnv(Pseq([3000,100,1000],inf), 8, \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				12,1,-1,
			],inf),
			\octave, 6,
			\lpf, 100,
			\envamt, Pseg(Pseq([1,4,18],1), 8).loop,
			\rq, Pseg(Pseq([0.7,0.31],1),16).loop,
			\adsr, Pseq([
				PpatEnv.adsr(0.01,0.1,0.8, Pseg(Pseq([0.01,1],1),16).loop),
			],inf),
			\legato, 0.3,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\hiz, \audio),
		),
		Pmono(\fx_echodiff,
			\out, 0.0,
			\diffmul, 1.0,
			\diffadd, 0.01,
			\lpf, 9000.0,
			\hpf, 750.0,
			\pfmix, 0.5,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\hiz, \audio),
			\addAction, \addToTail,
			\decay, Pseg(Pseq([0.1,0.1,1,1,2],1),8).loop,
			\delay, Pseg(Pseq([0.001,0.1],1),8, \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
// add synth
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\loop1),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.20000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				//Pser([
				//],4*8),
				0,0,-5,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,1, 1,1,1, 
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
			\out, BusDef(\hifx, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\hifx, \audio),
			\delay, 1/4/~t,
			\decay, 0.01,
			\diffadd, 0.01,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//Pser([
				//],4*8),
				//7,7,6,
				0,0,1,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,1,1
			],inf).coin.not,
			\octave, Pseq([5,5,5,5,5,5,6,6],inf)-1,
			\octave, 5,
			\lpf, 3700,
			\envamt, 3,
			\dur, 1/8,
			\amp, 0.1/3,
			//\out, BusDef(\hifx, \audio),
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

//////////////


(
SynthDef(\wub, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(\lfo1freq.kr(2*~t)); 
	lfo2 = SinOsc.ar(1/4*~t); 
	env1 = EnvGen.kr(Env([1,2,24],[0.1,0.8]), 1);
	mod2 = LFSaw.ar(freq) * lfo2* \mod2a.kr(8) * ((0..7)/7 - 0.5 * \fspread.kr(0.02)  + 1) * env1;
	mod1 = SinOsc.ar(freq + mod2) *lfo1 * \mod1a.kr(100);
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = sig / 4;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\wubhi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fspread;
	lfo1 = SinOsc.ar(2*~t); 
	lfo2 = SinOsc.ar(1/4*~t); 
	lfo3 = SinOsc.ar(4*~t) * lfo2 * 0.9 + 1; 
	lfo4 = LFNoise1.kr(0.1) * 0.01 + 1;
	lfo5 = LFNoise1.kr(0.1) * 0.01 + 1;
	fspread = ((0..7)/7 - 0.5 * \fspread.kr(0.002)  + 1);
	env1 = EnvGen.kr(Env([1,2,24],[0.1,0.8]), 1);
	mod2 = LFSaw.ar(freq * lfo5) * lfo2* 144 * env1;
	mod1 = SinOsc.ar(freq/2 + mod2) *lfo1 * 200;
	sig = SinOsc.ar(freq * fspread * lfo4 + mod1).tanh;
	//sig = RLPF.ar(sig, \lpf.kr(3100) * lfo3, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = sig /2;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\wubbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(2*~t); 
	lfo2 = SinOsc.ar(1/4*~t); 
	env1 = EnvGen.kr(Env([1,2,24],[0.1,0.8]), 1);
	mod2 = LFSaw.ar(freq*2) * lfo2* 14* ((0..7)/7 - 0.5 * \fspread.kr(0.02)  + 1) * env1;
	mod1 = SinOsc.ar(freq/2 + mod2) *lfo1 * 200;
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\wubbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(\lfo1freq.kr(2*~t)); 
	lfo2 = SinOsc.ar(1/4*~t); 
	env1 = EnvGen.kr(Env([1,2,24],[0.1,0.8]), 1);
	mod2 = LFSaw.ar(freq*2) * lfo2* 14* ((0..7)/7 - 0.5 * \fspread.kr(0.02)  + 1) * env1;
	mod1 = SinOsc.ar(freq + mod2) *lfo1 * 200;
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = sig / 3;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(\wub,
			\note, Pseq([
				3,0
				//Pseq((-6..-12))
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(\wubbass2,
			\note, Pseq([
				3,0
				//Pseq((-6..-12))
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(\wubhi,
			\note, Pseq([
				3,0
				//Pseq((-6..-12))
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(\wubhi2,
			\note, Pseq([
				3,0
				//Pseq((-6..-12))
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Ptpar([
			0,Pmono(\wubbass2,
				\note, Pseq([
					3,0
				],inf),
				\octave, 3,
				\dur, 4,
				\amp, 0.1,
				\out, BusDef(\basstrack, \audio),
			),
			8, Pmono(\wub,
				\note, Pseq([
					//[0,-7,3-12],
					[0,-5],
					//[0,2],
				],inf),
				\octave, 5,
				\dur, 4,
				\amp, 0.1,
			),
			16,Pmono(\wubhi,
				\note, Pseq([
					3,0
				],inf),
				\octave, 6,
				\dur, 4,
				\amp, 0.1,
			),
		]),
		
	])
)).play;
);

(
SynthDef(\wubhi2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fspread;
	lfo1 = SinOsc.ar(2*~t); 
	lfo2 = SinOsc.ar(1/4*~t).squared; 
	lfo3 = SinOsc.ar(4*~t) * lfo2 * 0.9 + 1; 
	lfo4 = LFNoise1.kr(0.1) * 0.01 + 1;
	lfo5 = LFNoise1.kr(0.1) * 0.01 + 1;
	lfo6 = XLine.kr(1,100,32/~t);
	lfo7 = XLine.kr(1,1,32/~t);
	fspread = ((0..3)/3 - 0.5 * \fspread.kr(1/4/~t) * lfo7  + 1);
	env1 = EnvGen.kr(Env([1,2,24],[0.1,0.8]), 1);
	mod2 = LFSaw.ar(freq*2 * lfo5) * lfo2* 14  * env1;
	mod1 = SinOsc.ar(freq/2 + mod2) *lfo1 * 20 * lfo6;
	sig1 = SinOsc.ar(freq * fspread * lfo4 + mod1) * 0.5;
	sig = SinOsc.ar(freq * lfo4 + mod1).tanh + sig1;
	//sig = RLPF.ar(sig, \lpf.kr(3100) * lfo3, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = sig / 3;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Ptpar([
			0,Pmono(\wubbass2,
				\note, Pseq([
					3,0
				],inf),
				\octave, 3,
				\dur, 4,
				\amp, 0.1,
				\out, BusDef(\basstrack, \audio),
			),
			8, Pmono(\wub,
				\note, Pseq([
					//[0,-7,3-12],
					[0,-5],
					//[0,2],
				],inf),
				\octave, 5,
				\dur, 4,
				\amp, 0.1,
			),
			0,Pmono(\wubhi2,
				\note, Pseq([
					3,0
				],inf),
				\octave, 6,
				\dur, 4,
				\amp, 0.1,
			),
		]),
		
	])
)).play;
);

/////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \wubbass2,
			\note, Pseq([
				0,3,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \wub,
			\note, Pseq([
				7,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pmono(\wubbass2,
			\note, Pseq([
				0,0,3,3,
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\lfo1freq, ~t * Pseq([2],inf),
			\out, BusDef(\basstrack0, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\basstrack0, \audio),
			\out, BusDef(\basstrack, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				5.2,0,0,0, 0,0,10,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \wub,
			\note, Pseq([
				7,
			],inf),
			\mod2a, Pseg(Pseq([8,200],1),32,\exp).loop,
			\mod1a, Pseg(Pseq([100,20,400],1),16,\exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\wubhi2,
			\note, Pseq([
				3,5,
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\wubhi, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\wubhi, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0,0,2,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \wubhi,
			\note, Pseq([
				Pseq([
					Pser([ 7,8, ],16),
					Pser([ 5,0, ],16),
				],3),
				Pser([ 12,14],16),
				Pser([ 15,14],16),
			],inf),
			\mod2a, 1,
			\mod1a, 1,
			\octave, 6,
			\dur, 1/8,
			\legato, 0.6,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\amp, 0.05,
			\out, BusDef(\www, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\www, \audio),
			\out, BusDef(\www1, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 2000,
			\ffac, PmodEnv(Pseq([1,4,8],1), 16).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\www1, \audio),
			\addAction, \addToTail,
			\room,3,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \wub,
			\note, Pseq([
				Pseq([
					8,8,7,7,5,5,3,3,
				],1).stutter(2),
				Pseq([
					0,3,8,7,5,5,3,0,
				],1).stutter(2),
			],inf),
			\mod2a, Pseg(Pseq([1,1000],1),32).loop,
			\mod1a, Pseg(Pseq([1,200],1),32).loop,
			\octave, 6,
			\dur, 1/8,
			\legato, 0.6,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.1) ],
				[ Env.adsr(0.04,0.1,0.8,0.1) ],
				[ Env.adsr(0.04,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1, 
				1,0,1,0, 1,0,1,0, 
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.05,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pmono(\wubbass2,
			\note, Pseq([
				0,0,3,3,
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\lfo1freq, ~t * Pseq([2],inf),
			\out, BusDef(\basstrack0, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\basstrack0, \audio),
			\out, BusDef(\basstrack, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				5.2,0,0,0, 0,0,10,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \wub,
			\note, Pseq([
				7,7,7,7,
				7,7,7,7,
				Pseq([
					7,7,7,7,
					7,7,7,5,
				],inf),
			],inf),
			\mod2a, Pseg(Pseq([8,200],1),32,\exp).loop,
			\mod1a, Pseg(Pseq([100,20,400],1),16,\exp).loop,
			\legato, Pseg(Pseq([0.8,0.8,0.1],1),16,\exp).loop,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\wubhi2,
			\note, Pseq([
				3,5,
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\wubhi, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\wubhi, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0,0,2,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \wubhi,
			\note, Pseq([
				Pseq([
					Pser([ 7,8, ],16),
					Pser([ 5,0, ],16),
				],3),
				Pser([ 12,14],16),
				Pser([ 15,14],16),
			],inf),
			\mod2a, 1,
			\mod1a, 1,
			\octave, 6,
			\dur, 1/8,
			\legato, 0.6,
			\adsr, Pseq([
				[ Env.adsr(0.02,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\amp, 0.05,
			\out, BusDef(\www, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\www, \audio),
			\out, BusDef(\www1, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lpf, 2000,
			\ffac, PmodEnv(Pseq([1,4,8],1), 16).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\www1, \audio),
			\addAction, \addToTail,
			\room,3,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \wub,
			\note, Pseq([
				Pseq([
					8,8,7,7,5,5,3,3,
				],1).stutter(2),
				Pseq([
					0,3,8,7,5,5,3,0,
				],1).stutter(2),
			],inf),
			\mod2a, Pseg(Pseq([1,1000],1),32).loop,
			\mod1a, Pseg(Pseq([1,200],1),32).loop,
			\octave, 6,
			\dur, 1/8,
			\legato, 0.6,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.1) ],
				[ Env.adsr(0.04,0.1,0.8,0.1) ],
				[ Env.adsr(0.04,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1, 
				1,0,1,0, 1,0,1,0, 
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.05,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \wubbass2,
			\note, Pseq([
				0,3,
			],inf),
			\octave, 3,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \wub,
			\note, Pseq([
				7,
			],inf),
			\dur, 1,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \wubhi,
			\note, Pseq([
				4,
			],inf),
			\dur, 1,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[255].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pmono(\wubbass2,
			\note, Pseq([
				3,0
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\basstrack0, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\basstrack0, \audio),
			\out, BusDef(\basstrack, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
		),
		Pmono(\wub,
			\note, Pseq([
				//[0,-7,3-12],
				[0,-5],
				//[0,2],
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\wub, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\wub, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
		),
		Pmono(\wubhi2,
			\note, Pseq([
				3,0
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\wubhi, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\wubhi, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0,0,2,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\pp1, 
	Ppar([
		Pdef(\drums1),
		Ptpar([
			8, Pdef(\loop1simple),
		]),
		Pmono(\wubbass2,
			\note, Pseq([
				3,0
			],inf),
			\octave, 3,
			\dur, 4,
			\amp, 0.1,
			\lfo1freq, ~t * Pseq([4,4,4,4, 4,4,2,4],inf),
			\out, BusDef(\basstrack0, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\basstrack0, \audio),
			\out, BusDef(\basstrack, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				5.2,0,0,0, 0,0,10,0,
				0,0,0,0, 0,0,0,0,
				12,0,0,0, 0,0,0,0,
				0,0,0,0, 0,2,0,0,
				1.3,0,6,0, 0,0,0,0,
				7.2,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				0,0,2,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pmono(\wub,
			\note, Pseq([
				//[0,-7,3-12],
				[0,-5],
				//[0,2],
			],inf),
			\octave, 5,
			\lfo1freq, ~t * Pseq([
				4,
				1,
				4,
				2,
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\wub, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\wub, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
		),
		Pmono(\wubhi2,
			\note, Pseq([
				3,0
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\wubhi, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\wubhi, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.455,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 4.3,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,0,0,
				],2),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 1,
			\hpfreq, 3100,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\ffreq, 8000,
			\amp, 0.1,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \oscsampler3,
			\pos, 0.261,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01301,0.1].integrate.postln,[1.41,8.1]) ],
			],inf),
			\finepos, 1/400 * Pseq([1,4,2,2],inf),
			\levelScale, 6.3,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,2,0,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 1,
			\hpfreq, 6100,
			\ffreq, 10000,
			\amp, 0.05,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\bufnum, BufDef.stereo('vipere/metal.flac'),

		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[415].value,
			\bufnum, ~buflib.foley1[226].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[415].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1
				//0,0,1,0, 0,0,0,1,
				//1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\fol, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\fol, \audio),
			\addAction, \addToTail,
			\lpf, 3000,
			\hpf, 2000,
			\ffac, PmodEnv(Pseq([1,8],1), 32).loop,
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
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part2).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 0.125,
			]+0,1),1).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
				],2),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8/2,
			\gain, 1/8/2,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),4).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,0,1,
				],4),
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
					0,0,0,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Chuck Jackson - Through All Times.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				1/2, 1,
			]+0,1),2).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
				],2),
				Pseq([
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
					0,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,0,
				],2),
				Pseq([
					0,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,0,
					0,1,1,1, 1,1,1,1,
					0,0,0,0, 1,0,1,0,
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[255].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.95,1,1),
				Pwhite(0.9,1,1),
				Prand([
					Pwhite(0.5,1,1),
					Pwhite(0.8,1,1),
					Pwhite(0.8,1,2),
				],1),
				//Pwhite(0.8,1),
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\pp1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Chuck Jackson - Through All Times.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				1/2, 1,
			]+0,1),2).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*2*3),
				Pseq([
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
				],2),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*2*3),
				Pseq([
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
					0,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,0,
				],2),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*2*3),
				Pseq([
					0,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,0,
					0,1,1,1, 1,1,1,1,
					0,0,0,0, 1,0,1,0,
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),4).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*4),
				Pseq([
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,0,1,
				],4),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4*4),
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
					0,0,0,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\pp1),
		//Pdef(\drums1),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),4).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,0,1,
				],4),
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,0,
					0,0,0,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2 * Pdefn(\randgain, Pseg(Prand([0,Pwhite(0.1,1,1)],inf),Prand([4,8],inf))),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Chuck Jackson - Through All Times.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				1/2, 1,
			]+0,1),2).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
				],2),
				Pseq([
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
					0,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,0,
				],2),
				Pseq([
					0,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,0,
					0,1,1,1, 1,1,1,1,
					0,0,0,0, 1,0,1,0,
				],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4 * Pdefn(\randgain),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[255].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.95,1,1),
				Pwhite(0.9,1,1),
				Prand([
					Pwhite(0.5,1,1),
					Pwhite(0.8,1,1),
					Pwhite(0.8,1,2),
				],1),
				//Pwhite(0.8,1),
			],inf) * Pdefn(\randgain),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pdef(\pp1),
		Pseq([
			Pfindur(7, Pbind()),
			Pfindur(1, Pbind(\type, \rest)),
		],inf) <>
		Pdef(\drums1),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),4).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pser([
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,0,1,
				],8*8),
				//1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Chuck Jackson - Through All Times.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				1/2, 1,
			]+0,1),2).loop * Pkey(\bufdur),
			\isRest, Pseq([
				Pser([
					0,0,1,0, 1,1,0,0,
					0,1,0,1, 1,0,1,1,
					0,1,0,1, 1,0,1,1,
					0,0,0,0, 1,0,1,0,
				],8*8),
				//1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[255].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.95,1,1),
				Pwhite(0.9,1,1),
				Prand([
					Pwhite(0.5,1,1),
					Pwhite(0.8,1,1),
					Pwhite(0.8,1,2),
				],1),
				//Pwhite(0.8,1),
			],inf),
		),
		Pmono(\wubhi2,
			\note, Pseq([
				3,0
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\wubhi, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\wubhi, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf)*0.7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\gain, 1,
			\out, BusDef(\wubhi2, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\wubhi2, \audio),
			\delay, 1/8/~t,
			\diffmul, 1.5,
			\decay, 4/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\wubhi3, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\wubhi3, \audio),
			\addAction, \addToTail,
			\room, 2,
			\mix, 0.5,
			\gain, 1,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

//////////


(
SynthDef(\dmds, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var num=7;
	lfo1 = 1;
	lfo2 = XLine.kr(1,1/12,6/~t);
	sig = LFPulse.ar(freq * lfo1).bipolar;
	//sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		//1,0,0,0,
	//],inf));
	sig = CombL.ar(sig, \maxdelay.kr(1.4), \delay.kr(0.04)*Rand(0.3,2!num) * LFNoise1.ar(Rand(0.3,20!num),mul:\dellfoamt.kr(0.99),add:1),1.07/~t * lfo2) + ( sig/num/2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig / 2;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pmono(\dmds,
			//\octave, 3,
			//\note, Pseq([
				//0,-2,3,7
			//],inf),
			//\dur, 4,
			//\delay, 0.01,
			//\dellfoamt, 0.01,
			////\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			//\amp, 0.1,
			//\out, BusDef(\basstrack, \audio),
		//),
		//Pmono(\dmds,
			//\octave, 4,
			//\note, Pseq([
				//7,5,7,5
			//],inf),
			//\dur, 4,
			//\delay, 0.1,
			//\dellfoamt, 0.01,
			////\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			//\amp, 0.1,
		//),
		//Pmono(\dmds,
			//\octave, 6,
			//\note, Pseq([
				//3,2,0,3
			//],inf),
			//\dur, 4,
			//\delay, 0.1,
			//\dellfoamt, PmodEnv(Pseq([0.991,0.002].reverse,1), 32,\exp).loop,
			//\amp, 0.1,
		//),
		//Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Melvin Bliss - Synthetic Substitution.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/4 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),4).loop + (Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,3,3,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				-1,-2,3,0, 0,0,0,0,
				0,1,2,3, 0,1,2,3,
			   	0,0,0,0, 0,-1,0,-1,
			],inf)*1/32) * Pkey(\bufdur),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
				Pser([
					0,0,0,1, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,0,1,
				],8*8),
				//1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The Bar-Kays - Do You See What I See.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 0.6 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),8).loop + ( Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,-1,2, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				3,2,-1,0, 0,0,0,0,
				
			],inf)/16 ) / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);
