///// moved from sun109
// chord seq Csus4 G C Csus4

(
FileSystemProject.loadOnce("sun/main.scd");
~t = 128/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/buflib.scd");
)

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
SynthDef(\snappad_adsr, {
	var snd, freq;
	freq = \freq.kr(440) * \freqfac.kr(1);
	// Four pulse waves (two one octave down) with randomly modulated pitches and pulse widths
	snd = Pulse.ar(
		freq * ({ LFNoise2.kr(3).range(-0.05, 0.05).midiratio }.dup(4)) * [1, 1/2, 1/2, 1],
		{ LFNoise2.kr(3).range(0.3, 0.7) }.dup(4)
	);
	// Spread across stereo field
	snd = Splay.ar(snd);
	// Sharp hi cut made by cascading three lowpass filters
	3.do { snd = LPF.ar(snd, \ffreq.kr(1500)); };
	snd = snd * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), \gate.kr(1), doneAction:2);
	Out.ar(\out.kr(0), Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(0.1)));
}).add;
SynthDef(\lasercrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,36.midicps,24.midicps],[0.115,0.018]), 1);
	env2 = EnvGen.kr(Env([15150,870,301],[0.006,0.8]), 1);
	mod2 = LFSaw.ar(( 12*4 ).midicps) * 3123;
	mod1 = SinOsc.ar(( 12*5 ).midicps + mod2, pi/2 * 0.4) * 1388; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.3],1), 1);
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\hicrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([1500,36.midicps,24.midicps],[0.015,0.018]), 1);
	env2 = EnvGen.kr(Env([175,5870,12301],[0.016,0.8]), 1);
	mod2 = LFSaw.ar(( 12*4 ).midicps) * EnvGen.kr(Env([1,2000],[0.02],\exp), 1);
	mod1 = SinOsc.ar(( 12*3 ).midicps + mod2, pi/2 * 0.4) * 1388; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.3],1), 1);
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(500));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fmspot, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([400,41,40],[0.4,0.8]), 1);
	env2 = EnvGen.kr(Env([90,41,40],[0.1,0.8]), 1);
	mod2 = SinOsc.ar(freq)* 10 * env2 ;
	mod1 = SinOsc.ar(freq + mod2)* 10 * env1 ;
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fmspot2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([400,41,140],[0.4,0.8]), 1);
	env2 = EnvGen.kr(Env([90,41,40],[0.1,0.8]), 1);
	mod2 = SinOsc.ar(freq)* 10 * env2 ;
	mod1 = SinOsc.ar(freq + mod2)* 10 * env1 ;
	sig = SinOsc.ar(freq + mod1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
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

/////////////////////////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 400,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,

				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,
			],inf),
			\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
			\envamt, 10,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.20000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				0,0,-5,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.70000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				-3,-5,
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pstep(Pseq([
				[5,7,12],
				[7,11,14],
				[0,4,7],
				[5,7,12],
			],inf),2),
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,1, 
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,1,1, 
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,1, 1,0,1,0,
				0,0,0,0, 0,0,1,0,
				//Pseq([
					//0,0,1,0, 1,0,1,0,
				//],7),
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,0,1,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 1,1,0,1,
				1,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 400,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,

				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,
			],inf),
			\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
			\envamt, 10,
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.20000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				0,0,-5,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
		),
		
		Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.70000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				-3,-5,
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pstep(Pseq([
				[5,7,12],
				[7,11,14],
				[0,4,7],
				[5,7,12],
			],inf),2),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
// grow from chord nap
Pdef(\part, Pdef(\grownap, 
	Ppar([

		Ptpar([
			32+8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1414].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.1,
			),
			24, Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1845].value,
				\bufnum, ~buflib.snare[1822].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11* Pseq([
					1,Pn(0.8,7)
				],inf),
			),
			20,    Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[636].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,1, 1,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,
					//Pseq([
					//0,0,1,0, 1,0,1,0,
					//],7),
					//0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.07,
			),
			16,  Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1616].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 1,1,0,1,
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 1,1,0,1,
					1,0,1,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07 * Pseq([
					1,1,1,1,
					//1,0.7,0.9,0.5,
					//0.1,0.5,0.8,1,
				],inf),
			),


			8, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			16, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\envamt, 10,
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/3,
			),
			4,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
			),

			12,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.70000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					-3,-5,
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/2,
			),
			0, Pbind(
				\instrument, \snappad,
				\note, Pstep(Pseq([
					[5,7,12],
					[7,11,14],
					[0,4,7],
					[5,7,12],
				],inf),2),
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
			),
		]),
	])
)).play;
);

(
// work on rytm
Pdef(\part, Pdef(\grownap2, 
	Ppar([

		Ptpar([
			32, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1422].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					Pser([
						1,0,1,0,
					],4*12),
					1,0,1,0,
					1,0,1,0,
					0,0,0,0,
					1,1,0,1,
				],inf).coin.not,
				\dur, 1/4,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.1,
			),
			24, Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1845].value,
				\bufnum, ~buflib.snare[1821].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0,
					],4*12),
					0,0,1,0,
					0,0,1,0,
					1,0,0,0,
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11* Pseq([
					1,Pn(0.8,7)
				],inf),
			),
			20,    Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[636].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05 * Pseq([
						0.4,0.8,1,1,
					],inf),
					\out, BusDef(\hata1, \audio),
				),
				Pmono(\fx_resonz,
					\inbus, BusDef(\hata1, \audio),
					\addAction, \addToTail,
					\mix, PmodEnv(Pseq([0.8,1,0.2,1,1],1), 8).loop,
					\freq, PmodEnv(Pseq([100,2400,5000,800,3000],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			16,  Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1616].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07 * Pseq([
					1,1,1,1,
					//1,0.7,0.9,0.5,
					//0.1,0.5,0.8,1,
				],inf),
			),


			8, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			16, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\envamt, 10,
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/3,
			),
			4,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
			),

			12,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.70000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					-3,-5,
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/2,
			),
			0, Pbind(
				\instrument, \snappad,
				\note, Pstep(Pseq([
					[5,7,12],
					[7,11,14],
					[0,4,7],
					[5,7,12],
				],inf),2),
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
			),
		]),
	])
)).play;
);

(
// grow hi
Pdef(\part, Pdef(\growhi, 
	Ppar([

		Ptpar([
			32, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1422].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					Pser([
						1,0,1,0,
					],4*12),
					1,0,1,0,
					1,0,1,0,
					0,0,0,0,
					1,1,0,1,
				],inf).coin.not,
				\dur, 1/4,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.1,
			),
			24, Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1845].value,
				\bufnum, ~buflib.snare[1821].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0,
					],4*12),
					0,0,1,0,
					0,0,1,0,
					1,0,0,0,
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11* Pseq([
					1,Pn(0.8,7)
				],inf),
			),
			20,    Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[636].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05 * Pseq([
						0.4,0.8,1,1,
					],inf),
					\out, BusDef(\hata1, \audio),
				),
				Pmono(\fx_resonz,
					\inbus, BusDef(\hata1, \audio),
					\addAction, \addToTail,
					\mix, PmodEnv(Pseq([0.8,1,0.2,1,1],1), 8).loop,
					\freq, PmodEnv(Pseq([100,2400,5000,800,3000],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			16,  Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1616].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07 * Pseq([
					1,1,1,1,
					//1,0.7,0.9,0.5,
					//0.1,0.5,0.8,1,
				],inf),
			),


			0, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\hifx, \audio),
			),
			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\envamt, 10,
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),
			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),

			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.70000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					-3,-5,
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/2,
				\out, BusDef(\hifx, \audio),
			),
			32, Pbind(
				\instrument, \snappad,
				\note, Pstep(Pseq([
					[5,7,12],
					[7,11,14],
					[0,4,7],
					[5,7,12],
				],inf),2),
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\hifx, \audio),
			),
			0, Ppar([
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hifx, \audio),
					\addAction, \addToTail,
					\damp, 0.9,
					\mix, PmodEnv(Pseq([0,0.6,0.6],1), Pseq([8,24])).loop,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hifx1, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\hifx1, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([1,400,400],1), Pseq([8,24])).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			0, Pbind(
				\instrument, \hicrash,
				\dur, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
		]),
	])
)).play;
);

(
// full
Pdef(\part, Pdef(\full1, 
	Ppar([

		Ptpar([
			0, Pbind(
				\instrument, \hicrash,
				\dur, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1422].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					Pser([
						1,0,1,0,
					],4*12),
					1,0,1,0,
					1,0,1,0,
					0,0,0,0,
					1,1,0,1,
				],inf).coin.not,
				\dur, 1/4,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1845].value,
				\bufnum, ~buflib.snare[1821].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0,
					],4*12),
					0,0,1,0,
					0,0,1,0,
					1,0,0,0,
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11* Pseq([
					1,Pn(0.8,7)
				],inf),
			),
			0,    Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[636].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05 * Pseq([
						0.4,0.8,1,1,
					],inf),
					\out, BusDef(\hata1, \audio),
				),
				Pmono(\fx_resonz,
					\inbus, BusDef(\hata1, \audio),
					\addAction, \addToTail,
					\mix, PmodEnv(Pseq([0.8,1,0.2,1,1],1), 8).loop,
					\freq, PmodEnv(Pseq([2400,5000,100,800,3000],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			0,  Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1616].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07 * Pseq([
					1,1,1,1,
					//1,0.7,0.9,0.5,
					//0.1,0.5,0.8,1,
				],inf),
			),


			0, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\out, BusDef(\hifx, \audio),
			),
			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\envamt, 10,
				\legato, Pseq([
					1
				],inf)*0.8,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/3 * Pseq([
					1,1,1,1, 1,1/2,1,1,
					1,1,1,1, 1,1/2,1,1,
					1,1,1,1/2, 1,1,1,1,
					1,1,1,1/2, 1,1,1,1,
				],inf),
				\out, BusDef(\hifx, \audio),
			),
			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),

			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.70000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					-3,-5,-5,-5,
				],inf),
				\octave, 5,
				\isRest, Pseq([
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,

					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,

					1,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 1.6,
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\hifx, \audio),
			),
			0, Pbind(
				\instrument, \snappad,
				\note, Pstep(Pseq([
					[5,7,12],
					[7,11,14],
					[0,4,7],
					[5,7,12],
				],inf),2),
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\hifx, \audio),
			),
			0, Ppar([
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hifx, \audio),
					\addAction, \addToTail,
					\damp, 0.9,
					\mix, PmodEnv(Pseq([0,0,0.6],1), Pseq([24,8])).loop,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hifx1, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\hifx1, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([1,1,800],1), Pseq([24,8])).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
	])
)).play;
);

(
// full
Pdef(\part, Pdef(\full2, 
	Ppar([

		Ptpar([
			0, Pbind(
				\instrument, \hicrash,
				\dur, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1422].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					Pser([
						1,0,1,0,
					],4*12),
					1,0,1,0,
					1,0,1,0,
					0,0,0,0,
					1,1,0,1,
				],inf).coin.not,
				\dur, 1/4,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1845].value,
				\bufnum, ~buflib.snare[1821].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0,
					],4*12),
					0,0,1,0,
					0,0,1,0,
					1,0,0,0,
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11* Pseq([
					1,Pn(0.8,7)
				],inf),
			),
			0, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[636].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05 * Pseq([
						0.4,0.8,1,1,
					],inf),
					\out, BusDef(\hata1, \audio),
				),
				Pmono(\fx_resonz,
					\inbus, BusDef(\hata1, \audio),
					\addAction, \addToTail,
					\mix, PmodEnv(Pseq([0.8,1,0.2,1,1],1), 8).loop,
					\freq, PmodEnv(Pseq([2400,5000,100,800,3000],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			0,  Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1616].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07 * Pseq([
					1,1,1,1,
					//1,0.7,0.9,0.5,
					//0.1,0.5,0.8,1,
				],inf),
			),


			0, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
				0, Ppar([
					Pbind( // bass unison
					\instrument, \sh101,
					\note, Pseq([
						5,7,0,5,
					],inf).stutter(16),
					\octave, Pseq([
						5,5,5,5, 5,5,6,5,
					],inf),
					\lpf, PmodEnv(Pseq([100,2000,10000],1), 16,\exp).loop,
					\envamt, Pseg(Pseq([1,11],1),8*4).loop,
					\rq, Pseg(Pseq([0.3,0.5],inf), 8).loop,
					\legato, 0.3,
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.2) ],
						[ Env.adsr(0.01,0.1,0.4,0.2) ],
					],inf),
					\isRest, Pseq([
						1,0,1,0, 1,1,0,1,
						1,1,0,1, 1,0,0,1,
						1,0,1,0, 1,1,0,1,
						1,1,1,0, 1,0,1,1,
						1,0,1,0, 1,1,0,1,
						1,1,0,1, 1,0,0,1,
						1,0,1,0, 1,1,0,1,
						1,0,0,0, 0,1,1,1,
					],inf).coin.not,
					\amp, 0.1,
					//\out, BusDef(\bauni, \audio),
				),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\bauni),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, 1,
					\sendbus0, BusDef(\bauni1, \audio, 2),
					\dur, 1,
				),
				Pmono(\fx_delay,
					\inbus, BusDef(\bauni1, \audio),
					\addAction, \addToTail,
					\delay, 1/8/2/~t,
					\mix, 1,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\bauni2, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\bauni2, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([2000,2],1), 32,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),

			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\envamt, 10,
				\legato, Pseq([
					1,1,1,1, 1/2,1,1,1,
				],inf)*0.8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),
			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),

			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.70000000298023,
				\modIndex, Pseg(Pseq([0,2],inf),8*4),
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					-3,-5,-5,-5,
				],inf),
				\octave, [5,6],
				\isRest, Pseq([
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,

					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,

					1,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 1.6,
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\solofx, \audio),
			),
			0, Pbind(
				\instrument, \snappad,
				\note, Pstep(Pseq([
					[5,7,12],
					[7,11,14],
					[0,4,7],
					[5,7,12],
				],inf),2),
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\hifx, \audio),
			),
			0, Ppar([
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hifx, \audio),
					\addAction, \addToTail,
					\damp, 0.9,
					\mix, PmodEnv(Pseq([1,1,0.6],1), Pseq([24,8])).loop,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hifx1, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hifx1, \audio),
					\addAction, \addToTail,
					\lpf, 5400,
					\hpf, PmodEnv(Pseq([5000,3000,800],1), Pseq([24,8]),\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
				Pmono(\fx_echodiff,
					\inbus, BusDef(\solofx, \audio),
					\addAction, \addToTail,
					\diffadd, 0.01,
					\delay, 2/13/~t,
					\mix, 0.3,
					\decay, 2/~t,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\solofx2, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\solofx2, \audio),
					\lpf, 7000,
					\hpf, PmodEnv(Pseq([10000,2000,100,4,4],1), 8,\exp).loop,
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
	])
)).play;
);


(
Pdef(\part, Pdef(\gruyere, 
	Ppar([
		Ptpar([
			16, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				//\out, BusDef(\hifx, \audio),
			),
			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),
			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\envamt, Pseg(Pseq([0,10],inf),32),
				\octave, 5,
				\dur, 1/4,
				\legato, Pseq([
					1,1,2,1, 0.7,1,1,1,
				],inf)*0.8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\amp, 0.1/3 * Pseq([
					1,1,1,1, 1/3,1,1,1,
				],inf),
				\out, BusDef(\hifx, \audio),
			),
			0, Ppar([
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hifx, \audio),
					\addAction, \addToTail,
					\damp, 0.9,
					\mix, PmodEnv(Pseq([0,0.6,0.6],1), Pseq([8,24])).loop,
					\size, 3,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hifx1, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\hifx1, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([1,400,400],1), Pseq([8,24])).loop,
					\mix, 0,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\gruyere3, 
	Ppar([
		Ptpar([
			30, Pbind(
				\instrument, \snappad_adsr,
				\note, Pseq([
					[4,7,11,12],
					[4,7,11,12],
					[4,7,11,12],
					[4+12,7+12,11,12],
				],inf).stutter(4),
				\legato, Pseg(Pseq([0.1,1],inf),2),
				\octave, 6,
				\ffreq, PmodEnv(Pseq([1500,15000],1), 2,\exp),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\amp, 0.05 * Pseg(Pseq([0,1],1),2),
			),
			27, Pbind(
				\instrument, \snappad_adsr,
				\freq, PmodEnv(Pseq([1000,2000],1), 4,\exp).loop,
				\dur, 4,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(4/~t,0.1,0.8,0.1,1,1) ],
				],1),
				\amp, 0.071,
			),
			23,Pbind(
				\instrument, \noisefil,
				\color, 0.2,
				\lpf, PmodEnv(Pseq([200,13000],1), 8,\exp).loop,
				\hpf, PmodEnv(Pseq([100,7000],1), 8,\exp).loop,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(4/~t,0.1,0.8,0.1,1,1) ],
				],1),
				\dur, 8,
				\amp, 0.1,
			),
			32,  Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1616].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07 * Pseq([
					1,1,1,1,
					//1,0.7,0.9,0.5,
					//0.1,0.5,0.8,1,
				],inf),
			),
			16, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1422].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\isRest, Pseq([
						Pser([
							1,0,1,0,
						],4*12),
						1,0,1,0,
						1,0,1,0,
						0,0,0,0,
						1,1,0,1,
					],inf).coin.not,
					\dur, 1/4,
					\legato, 1/2,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\gain, 0.1,
					\out, BusDef(\kick, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\kick, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([17000,2000,1,1,1,1,1],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			16, Ppar([
				Pbind(
					\instrument, \Piano_rhodeySC,
					\vel, 0.80000001192093,
					\modIndex, 0.70000000298023,
					\mix, 0.70000000298023,
					\mix, PmodEnv(Pseq([0.51,0,1],1), 8*2).loop,
					\lfoSpeed, 0.40000000596046,
					\lfoDepth, 0.10000000149012,
					\note, Pseq([
						-3,-5,
					],inf),
					\octave, 5,
					\dur, 1/4,
					\amp, 0.1/2,
					\out, BusDef(\rhode, \audio),
				),
				Pmono(\fx_freeverb2fil,
					\inbus, BusDef(\rhode, \audio),
					\addAction, \addToTail,
					\lpf, PmodEnv(Pseq([5000,10000],1), 32,\exp).loop,
					\hpf, PmodEnv(Pseq([10000,12,17301,4,4],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			12,Pbind(
				\instrument, \noisefil,
				\color, 0,
				\lpf, PmodEnv(Pseq([200,10000],1), 4,\exp).loop,
				\hpf, PmodEnv(Pseq([100,6000],1), 4,\exp).loop,
				\adsr, Pseq([
					[ Env.adsr(4/~t,0.1,0.8,0.1,1,1) ],
				],1),
				\dur, 4,
				\amp, 0.1,
			),
			15, Pbind( // bass ramp
				\instrument, \sh101,
				\freq, PmodEnv(Pseq(( [5+(3* 12 ),5]+(3*12) ).midicps,1), 1,\exp).loop,
				\octave, 3,
				\lpf, 400,
				\dur, 1,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(2.01,0.1,0.8,0.2,1,1) ],
				],inf),
				\isRest, Pseq([
					1,
				],1).coin.not,
				\amp, 0.1,
				//\out, BusDef(\hifx, \audio),
			),
			16, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],4),
					Pseq([
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,0,1,
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,1,1,
						1,0,1,1, 0,1,0,1,
						1,0,0,0, 1,0,0,1,
					],inf),
				],inf).coin.not,
				\amp, 0.1,
				//\out, BusDef(\hifx, \audio),
			),
			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,1,0,
						1,1,1,1, 1,1,1,1,
					],4),
					Pseq([
						1
					],inf),
				],inf).coin.not,
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),
			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
						1,0,0,0, 0,0,0,0,
					],2*4),
					Pseq([
						1
					],inf),
				],inf).coin.not,
				\envamt, Pseg(Pseq([0,10],inf),32),
				\octave, 5,
				\dur, 1/4,
				\legato, Pseq([
					1,1,2,1, 0.7,1,1,1,
				],inf)*0.8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\amp, 0.1/3 * Pseq([
					1,1,1,1, 0.8,1,1,1,
				],inf),
				\out, BusDef(\hifx, \audio),
			),
			0, Pfindur(31,Ppar([
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hifx, \audio),
					\addAction, \addToTail,
					\damp, 0.9,
					\mix, PmodEnv(Pseq([0,0.6,0.6],1), Pseq([8,24])).loop,
					\delay, 0.3/~t,
					\size, 3,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hifx1, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\hifx1, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([100,3400,400],1), Pseq([8,24]), \exp).loop,
					\mix, 0,
					\lag, 0.0009,
					\dur, 1,
				),
			])),
		]),
		Pbind(
			\instrument, \lasercrash,
			\freq, 200,
			\dur, 4,
			\isRest, Pseq([
				1,0,
				Pseq([
					0,0,
				],3),
			],inf).coin.not,
			\hpf, 1100,
			//\adsr, Pseq([
				//[ Env.adsr(2.1/~t,0.1,0.8,0.1,1,1) ],
			//],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\precore1, 
	Ppar([
		Pdef(\bass1,Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 100,
			\dur, 1/8,
			\envamt, PmodEnv(Pseq([4,12],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,2,0, 1,2,0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				0.4,0.6,1,1,
			],inf),
			\out, BusDef(\hip, \audio),
		)),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hip, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,102,1,4],1), 8).loop,
			\lag, 0.0009,
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
			\bufnum, ~buflib.kick[1422].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0,
				],4*12),
				1,0,1,0,
				1,0,1,0,
				0,0,0,0,
				1,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1821].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],4*12),
				0,0,1,0,
				0,0,1,0,
				1,0,0,0,
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[636].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05 * Pseq([
					0.4,0.8,1,1,
				],inf),
				\out, BusDef(\hata1, \audio),
			),
			Pmono(\fx_resonz,
				\inbus, BusDef(\hata1, \audio),
				\addAction, \addToTail,
				\mix, PmodEnv(Pseq([0.8,1,0.2,1,1],1), 8).loop,
				\freq, PmodEnv(Pseq([2400,5000,100,800,3000],1), 8,\exp).loop,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),

	])
)).play;
);

(
// with spot and blob
Pdef(\part, Pdef(\core1, 
	Ppar([
		
		Pdef(\drums1),
		Pdef(\bass1,Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 100,
			\dur, 1/8,
			\envamt, PmodEnv(Pseq([4,12],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,2,0, 1,2,0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				0.4,0.6,1,1,
			],inf),
		)),
		Ptpar([
			8, Ppar([
				Pdef(\melb1, Pbind(
					\instrument, \Piano_rhodeySC,
					\vel, 0.80000001192093,
					\modIndex, PmodEnv(Pseq([0,2],1), 8*4).loop,
					\mix, 0.70000000298023,
					\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
					\lfoSpeed, 0.40000000596046,
					\lfoDepth, 0.10000000149012,
					\note, Pseq([
						0,0,-5,
					],inf),
					\octave, 6,
					\dur, 1/8,
					\amp, 0.1/3 * Pseg(Pseq([1,0.5,1],inf),10),
					\out, BusDef(\melb1fx, \audio),
				)),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\melb1fx),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, Pstep(Pseq([0,0,1,0],inf),8),
					\sendbus0, BusDef(\melb1fx2, \audio, 2),
					\dur, 1,
				),
				Pmono(\fx_echo,
					\inbus, BusDef(\melb1fx2, \audio),
					\addAction, \addToTail,
					\delay, 0.2/~t,
					\pfmix, 1,
					\lpf, 5000,
					\hpf, PmodEnv(Pseq([5000,5000,4,4],1), Pseq([16,8,8]),\exp),
					\mix, 1,
					\lag, 0.0009,
					\dur, 1,
				).loop,
			]),
			8, Ppar([
				Pbind( // alien shot
					\instrument, Pseq([
						\fmspot,
						\fmspot2,
					],inf).stutter(8*8),
					\note, Pseq([
						0,5,
					],inf),
					\octave, 5,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,1,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						//Pseq([ 0,0,0,0, 0,0,0,0, ],8),
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
						[ Env.adsr(0.04,0.1,0.8,5.1) ],
					],inf),
					\dur, 1/8,
					\amp, 0.1/4,
					\out, BusDef(\spot, \audio),
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\spot, \audio),
					\addAction, \addToTail,
					\size, 1,
					\delay, 1/8/~t,
					\mix, 0.2,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			32, Ppar([
				Pbind(
					\instrument, \sh101,
					\note, Pseq([
						0,0,0,0, 0,0,0,-1,
						Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
						0,0,0,0, 0,0,0,-1,
						0,0,0,0, 0,0,0,-1,
				
						0,0,0,0, 0,0,0,-1,
						Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
						0,0,0,0, 0,0,0,-1,
						0,0,0,0, 0,0,0,-1,
					],inf).stutter(2),
					\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
					\envamt, 10,
					\legato, Pseq([
						1
					],inf)*0.8,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.1) ],
					],inf),
					\octave, 5,
					\dur, 1/8,
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\amp, 0.1/3 * Pseq([
						1,1,1,1, 1,1/2,1,1,
						1,1,1,1, 1,1/2,1,1,
						1,1,1,1/2, 1,1,1,1,
						1,1,1,1/2, 1,1,1,1,
					],inf) * Pseq([
						0.7,0.8,0.9,1,
					],inf),
					\out, BusDef(\mela1fx, \audio),
				),
				Pmono(\fx_freeverb2fil,
					\inbus, BusDef(\mela1fx, \audio),
					\addAction, \addToTail,
					\wetfmix, 1,
					\fmix, 1,
					\room, 2,
					\gain, 1,
					\wetlpf, 17000,
					\mix, PmodEnv(Pseq([0,0,1,0.5,1],1), 8).loop,
					\fmix, PmodEnv(Pseq([0,0,1,0.5,1],1), 8).loop,
					\wethpf, PmodEnv(Pseq([10000,100,10000,1000,6000],1), 8).loop,
					\hpf, PmodEnv(Pseq([2000,200,1,4,3],1), 8).loop,
					\lpf, PmodEnv(Pseq([16000,2000,16000],1), 16).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		Pbind( // strange voice
			\instrument, \notegranrfe,
			\mbufnum, BufDef.mono('voices/world.flac'), // re
			\note, Pseq([
				5,4
			],inf),
			\samplenote, 2,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,0.3) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(5.1/~t,0.1,0.8,1.1) ],
			],inf),
			\gdur, 0.2,
			\legato, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],3),
				8,0,0,0, 0,0,0,0,
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpadsramt, 4,
			\gfreq, 90,
			\gain, 0.2,
			\normpos, PmodEnv(Pseq([0.1,0.1154]+0.15,1), 1).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // trumpet
			\instrument, \oscsmp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\note, Pseq([
				5,7,0,
			],inf),
			\legato, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\levelScale, ~pmodenv.(Pseq([0.01,0.1,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,0.1,0.8]) ],
				//[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 4,
			\adsr, Pseq([
				[ Env.adsr(1/~t,0.1,0.8,0.1,1,1) ],
			],inf),
			\oscrange, ~pmodenv.(Pseq([100,200],1), 8).loop,
			//\oscrange, 160,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\blob, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\blob, \audio),
			\addAction, \addToTail,
			\delay, PmodEnv(Pseq([0.01,0.2],1), 2,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
///////// main
Pdef(\part, Pdef(\seq1, 
	Ppar([
		Pseq([
			//Pfindur(32+16, Pdef(\grownap2)),
			//Pfindur(32+16, Pdef(\growhi)),
			Pfindur(8, Pdef(\precore1)),
			Pfindur(64, Pdef(\core1)),
			Pfindur(32, Pdef(\gruyere3)),
			Pfindur(32, Pdef(\full1)),
			Pfindur(32, Pdef(\full2)),
			//Pfindur(32, Pdef(\gruyere)),
			//Pfindur(32, Pdef(\full1)),

		],1),
		//Pbind(
			//\instrument, \recorder,
			//\addAction, \addToTail,
			//\lag, 0.0019,
			//\inbus, 0,
			//\group, GroupDef.pattern(\end, 1, \addAfter),
			//\bufnum, BufDef(\mybuf, s.sampleRate * 64/~t, 2),
			//\gain, 0,
			//\dur, Pn(1,1),
		//),

		// todo: concat full1 and full2 to have transition in non obvious timing
		
	])
)).play;
);

////////////// draft

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1414].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1281].value,
			\bufnum, ~buflib.kick[1015].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1822].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\legato, 2,
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[636].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1,
				1,0.7,0.9,0.5,
				0.1,0.5,0.8,1,
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\gruyere2, 
	Ppar([
		Ptpar([
			16, Ppar([
				Pbind(
					\instrument, \Piano_rhodeySC,
					\vel, 0.80000001192093,
					\modIndex, 0.70000000298023,
					\mix, 0.70000000298023,
					\mix, PmodEnv(Pseq([0.51,0,1],1), 8*2).loop,
					\lfoSpeed, 0.40000000596046,
					\lfoDepth, 0.10000000149012,
					\note, Pseq([
						-3,-5,
					],inf),
					\octave, 5,
					\dur, 1/4,
					\amp, 0.1/2,
					\out, BusDef(\rhode, \audio),
				),
				Pmono(\fx_freeverb2fil,
					\inbus, BusDef(\rhode, \audio),
					\addAction, \addToTail,
					\lpf, PmodEnv(Pseq([5000,10000],1), 32,\exp).loop,
					\hpf, PmodEnv(Pseq([10000,1200,301,4,4],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			12,Pbind(
				\instrument, \noisefil,
				\color, 0,
				\lpf, PmodEnv(Pseq([200,10000],1), 4,\exp).loop,
				\hpf, PmodEnv(Pseq([100,6000],1), 4,\exp).loop,
				\adsr, Pseq([
					[ Env.adsr(4/~t,0.1,0.8,0.1,1,1) ],
				],1),
				\dur, 4,
				\amp, 0.1,
			),
			15, Pbind( // bass
				\instrument, \sh101,
				\freq, PmodEnv(Pseq(( [5+(3* 12 ),5]+(3*12) ).midicps,1), 1,\exp).loop,
				\octave, 3,
				\lpf, 400,
				\dur, 1,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(2.01,0.1,0.8,0.2,1,1) ],
				],inf),
				\isRest, Pseq([
					1,
				],1).coin.not,
				\amp, 0.1,
				//\out, BusDef(\hifx, \audio),
			),
			16, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				//\out, BusDef(\hifx, \audio),
			),
			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),
			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\envamt, Pseg(Pseq([0,10],inf),32),
				\octave, 5,
				\dur, 1/4,
				\legato, Pseq([
					1,1,2,1, 0.7,1,1,1,
				],inf)*0.8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\amp, 0.1/3 * Pseq([
					1,1,1,1, 1/3,1,1,1,
				],inf),
				\out, BusDef(\hifx, \audio),
			),
			0, Ppar([
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hifx, \audio),
					\addAction, \addToTail,
					\damp, 0.9,
					\mix, PmodEnv(Pseq([0,0.6,0.6],1), Pseq([8,24])).loop,
					\delay, 0.3/~t,
					\size, 3,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hifx1, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\hifx1, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([100,3400,400],1), Pseq([8,24]), \exp).loop,
					\mix, 0,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		Pbind(
			\instrument, \lasercrash,
			\freq, 200,
			\dur, 4,
			\isRest, Pseq([
				1,0,
				Pseq([
					0,0,
				],3),
			],inf).coin.not,
			\hpf, 1100,
			//\adsr, Pseq([
				//[ Env.adsr(2.1/~t,0.1,0.8,0.1,1,1) ],
			//],inf),
			\amp, 0.1,
		),
		
	])
)).play;
);


48.midicps
36.midicps

(
SynthDef(\tolecrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([1500,36.midicps,24.midicps],[0.015,0.018]), 1);
	env2 = EnvGen.kr(Env([1715,870,12301],[0.016,0.8]), 1);
	mod2 = LFSaw.ar(( 12*4 ).midicps) * 123;
	mod1 = SinOsc.ar(( 12*3 ).midicps + mod2, pi/2 * 0.4) * 1388; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.3],1), 1);
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
			Pbind( // bass
				\instrument, \sh101,
				\freq, PmodEnv(Pseq(( [5+(3* 12 ),5]+(3*12) ).midicps,1), 1,\exp).loop,
				\octave, 3,
				\lpf, 400,
				\dur, 1,
				\adsr, Pseq([
					[ Env.adsr(2.01,0.1,0.8,0.2,1,1) ],
				],inf),
				\legato, 1,
				\isRest, Pseq([
					Pseq([
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				//\out, BusDef(\hifx, \audio),
			),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \noisefil,
			\color, 0,
			\lpf, PmodEnv(Pseq([200,10000],1), 4,\exp).loop,
			\hpf, PmodEnv(Pseq([100,6000],1), 4,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(4/~t,0.1,0.8,0.1,1,1) ],
			],1),
			\dur, 4,
			\amp, 0.1,
		).loop,

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			//0, Pbind(
				//\instrument, \sh101,
				//\note, Pseq([
					//0,0,0,0, 0,0,0,-1,
					//Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					//0,0,0,0, 0,0,0,-1,
					//0,0,0,0, 0,0,0,-1,

					//0,0,0,0, 0,0,0,-1,
					//Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					//0,0,0,0, 0,0,0,-1,
					//0,0,0,0, 0,0,0,-1,
				//],inf),
				//\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				//\envamt, 10,
				//\octave, 5,
				//\dur, 1/4,
				//\amp, 0.1/3,
			//),
			//0,  Pbind(
				//\instrument, \Piano_rhodeySC,
				//\vel, 0.80000001192093,
				//\modIndex, 0.20000000298023,
				//\mix, 0.70000000298023,
				//\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				//\lfoSpeed, 0.40000000596046,
				//\lfoDepth, 0.10000000149012,
				//\note, Pseq([
					//0,0,-5,
				//],inf),
				//\octave, 6,
				//\dur, 1/8,
				//\amp, 0.1/3,
			//),

			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.70000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					-3,-5,
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/2,
			),
			0, Pbind(
				\instrument, \snappad,
				\note, Pstep(Pseq([
					[5,7,12],
					[7,11,14],
					[0,4,7],
					[5,7,12],
				],inf),2),
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
			),
		
		]),
	])
)).play;
);


(
// full1 + full2
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ptpar([
			0, Pbind(
				\instrument, \hicrash,
				\dur, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1422].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					Pser([
						1,0,1,0,
					],4*12),
					1,0,1,0,
					1,0,1,0,
					0,0,0,0,
					1,1,0,1,
				],inf).coin.not,
				\dur, 1/4,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1845].value,
				\bufnum, ~buflib.snare[1821].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0,
					],4*12),
					0,0,1,0,
					0,0,1,0,
					1,0,0,0,
					0,0,1,0,
				],inf).coin.not,
				\dur, 1/4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\gain, 0.11* Pseq([
					1,Pn(0.8,7)
				],inf),
			),
			0, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[636].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05 * Pseq([
						0.4,0.8,1,1,
					],inf),
					\out, BusDef(\hata1, \audio),
				),
				Pmono(\fx_resonz,
					\inbus, BusDef(\hata1, \audio),
					\addAction, \addToTail,
					\mix, PmodEnv(Pseq([0.8,1,0.2,1,1],1), 8).loop,
					\freq, PmodEnv(Pseq([2400,5000,100,800,3000],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			0,  Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1616].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\legato, 1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.07 * Pseq([
					1,1,1,1,
					//1,0.7,0.9,0.5,
					//0.1,0.5,0.8,1,
				],inf),
			),


			0, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					5,7,0,5,
				],inf).stutter(16),
				\octave, 3,
				\lpf, 400,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\isRest, Pseq([
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,0,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
					1,0,1,0, 0,1,0,1,
					1,0,0,0, 1,0,1,1,
					1,0,1,1, 0,1,0,1,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
				0, Ppar([
					Pbind( // bass unison
					\instrument, \sh101,
					\note, Pseq([
						5,7,0,5,
					],inf).stutter(16),
					\octave, Pseq([
						5,5,5,5, 5,5,6,5,
					],inf),
					\lpf, PmodEnv(Pseq([100,2000,10000],1), 16,\exp).loop,
					\envamt, Pseg(Pseq([1,11],1),8*4).loop,
					\rq, Pseg(Pseq([0.3,0.5],inf), 8).loop,
					\legato, 0.3,
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.2) ],
						[ Env.adsr(0.01,0.1,0.4,0.2) ],
					],inf),
					\isRest, Pseq([
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,0,0,1,
						1,0,1,0, 0,1,0,1,
						1,0,0,0, 1,1,0,1,
						1,0,1,0, 1,1,0,1,
						1,0,1,0, 0,1,0,1,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 1,1,1,1,
					]+0.3,inf).coin.not,
					\amp, 0.1,
					//\out, BusDef(\bauni, \audio),
				),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\bauni),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, 1,
					\sendbus0, BusDef(\bauni1, \audio, 2),
					\dur, 1,
				),
				Pmono(\fx_delay,
					\inbus, BusDef(\bauni1, \audio),
					\addAction, \addToTail,
					\delay, 1/8/2/~t,
					\mix, 1,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\bauni2, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\bauni2, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([2000,2],1), 32,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),

			0, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,

					0,0,0,0, 0,0,0,-1,
					Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
					0,0,0,0, 0,0,0,-1,
					0,0,0,0, 0,0,0,-1,
				],inf),
				\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
				\envamt, 10,
				\legato, Pseq([
					1,1,1,1, 1/2,1,1,1,
				],inf)*0.8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\octave, 5,
				\dur, 1/4,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),
			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.20000000298023,
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					0,0,-5,
				],inf),
				\octave, 6,
				\dur, 1/8,
				\amp, 0.1/3,
				\out, BusDef(\hifx, \audio),
			),

			0,  Pbind(
				\instrument, \Piano_rhodeySC,
				\vel, 0.80000001192093,
				\modIndex, 0.70000000298023,
				\modIndex, Pseg(Pseq([0,2],inf),8*4),
				\mix, 0.70000000298023,
				\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
				\lfoSpeed, 0.40000000596046,
				\lfoDepth, 0.10000000149012,
				\note, Pseq([
					-3,-5,-5,-5,
				],inf),
				\octave, [5,6],
				\isRest, Pseq([
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,

					1,0,1,0,
					1,0,1,0,
					1,0,1,0,
					1,0,1,0,

					1,1,0,1,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 1.6,
				\dur, 1/8,
				\amp, 0.1/2,
				\out, BusDef(\solofx, \audio),
			),
			0, Pbind(
				\instrument, \snappad,
				\note, Pstep(Pseq([
					[5,7,12],
					[7,11,14],
					[0,4,7],
					[5,7,12],
				],inf),2),
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
				\out, BusDef(\hifx, \audio),
			),
			0, Ppar([
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hifx, \audio),
					\addAction, \addToTail,
					\damp, 0.9,
					\mix, PmodEnv(Pseq([1,1,0.6],1), Pseq([24,8])).loop,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hifx1, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hifx1, \audio),
					\addAction, \addToTail,
					\lpf, 5400,
					\hpf, PmodEnv(Pseq([5000,3000,800],1), Pseq([24,8]),\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
				Pmono(\fx_echodiff,
					\inbus, BusDef(\solofx, \audio),
					\addAction, \addToTail,
					\diffadd, 0.01,
					\delay, 2/13/~t,
					\mix, 0.3,
					\decay, 2/~t,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\solofx2, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\solofx2, \audio),
					\lpf, 7000,
					\hpf, PmodEnv(Pseq([10000,2000,100,4,4],1), 8,\exp).loop,
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
	])
)).play;
);


///// test other bass pattern
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pdef(\bass1,Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 100,
			\dur, 1/8,
			\envamt, PmodEnv(Pseq([4,12],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,2,0, 1,2,0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				0.4,0.6,1,1,
			],inf),
		)),
		Pdef(\melb1, Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, PmodEnv(Pseq([0,2],1), 8*4).loop,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				0,0,-5,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
			\out, BusDef(\melb1fx, \audio),
		)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\melb1fx),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, Pstep(Pseq([0,1],inf),8),
			\sendbus0, BusDef(\melb1fx2, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\melb1fx2, \audio),
			\addAction, \addToTail,
			\delay, 0.2/~t,
			\pfmix, 1,
			\lpf, 5000,
			\hpf, PmodEnv(Pseq([5000,5000,4],1), 8,\exp),
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		).loop,

	])
)).play;
);

(
// with spot and blob
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pdef(\bass1,Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 100,
			\dur, 1/8,
			\envamt, PmodEnv(Pseq([4,12],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,2,0, 1,2,0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				0.4,0.6,1,1,
			],inf),
		)),
		Ptpar([
			8, Ppar([
				Pdef(\melb1, Pbind(
					\instrument, \Piano_rhodeySC,
					\vel, 0.80000001192093,
					\modIndex, PmodEnv(Pseq([0,2],1), 8*4).loop,
					\mix, 0.70000000298023,
					\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
					\lfoSpeed, 0.40000000596046,
					\lfoDepth, 0.10000000149012,
					\note, Pseq([
						0,0,-5,
					],inf),
					\octave, 6,
					\dur, 1/8,
					\amp, 0.1/3 * Pseg(Pseq([1,0.5,1],inf),10),
					\out, BusDef(\melb1fx, \audio),
				)),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\melb1fx),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, Pstep(Pseq([0,0,0,1],inf),8),
					\sendbus0, BusDef(\melb1fx2, \audio, 2),
					\dur, 1,
				),
				Pmono(\fx_echo,
					\inbus, BusDef(\melb1fx2, \audio),
					\addAction, \addToTail,
					\delay, 0.2/~t,
					\pfmix, 1,
					\lpf, 5000,
					\hpf, PmodEnv(Pseq([5000,5000,4],1), 8,\exp),
					\mix, 1,
					\lag, 0.0009,
					\dur, 1,
				).loop,
			]),
		]),
		Pbind( // alien shot
			\instrument, Pseq([
				\fmspot,
				\fmspot2,
			],inf).stutter(8*8),
			\note, Pseq([
				0,5,
			],inf),
			\octave, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//Pseq([ 0,0,0,0, 0,0,0,0, ],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.04,0.1,0.8,5.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\spot, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\spot, \audio),
			\addAction, \addToTail,
			\size, 1,
			\delay, 1/8/~t,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // strange voice
			\instrument, \notegranrfe,
			\mbufnum, BufDef.mono('voices/world.flac'), // re
			\note, Pseq([
				5,4
			],inf),
			\samplenote, 2,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,0.3) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(5.1/~t,0.1,0.8,1.1) ],
			],inf),
			\gdur, 0.2,
			\legato, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],3),
				8,0,0,0, 0,0,0,0,
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpadsramt, 4,
			\gfreq, 90,
			\gain, 0.2,
			\normpos, PmodEnv(Pseq([0.1,0.1154]+0.15,1), 1).loop,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // trumpet
			\instrument, \oscsmp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\note, Pseq([
				5,7,0,
			],inf),
			\legato, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),

			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\levelScale, ~pmodenv.(Pseq([0.01,0.1,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,0.1,0.8]) ],
				//[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 4,
			\adsr, Pseq([
				[ Env.adsr(1/~t,0.1,0.8,0.1,1,1) ],
			],inf),
			\oscrange, ~pmodenv.(Pseq([100,200],1), 8).loop,
			//\oscrange, 160,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\blob, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\blob, \audio),
			\addAction, \addToTail,
			\delay, PmodEnv(Pseq([0.01,0.2],1), 2,\exp).loop,
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
			\instrument, \notegranrfe,
			\mbufnum, BufDef.mono('voices/world.flac'), // re
			\note, Pseq([
				5,4
			],inf),
			\samplenote, 2,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,0.3) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(5.1/~t,0.1,0.8,1.1) ],
			],inf),
			\gdur, 0.2,
			\legato, Pseq([
				6,0,0,0, 0,0,0,0,
				Pseq([ 0,0,0,0, 0,0,0,0, ],4),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpadsramt, 4,
			\gfreq, 70,
			\gain, 0.2,
			\normpos, PmodEnv(Pseq([0.1,0.11]+3,1), 1).loop,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\blob, 
	Ppar([
		
		Pbind(
			\instrument, \oscsmp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, 1/2,
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\note, Pseq([
				5,7,0,
			],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Pseq([
					0,0,0,0, 0,0,0,0,
				],6),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\levelScale, ~pmodenv.(Pseq([0.01,0.1,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,0.1,0.8]) ],
				//[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 4,
			\adsr, Pseq([
				[ Env.adsr(1/~t,0.1,0.8,0.1,1,1) ],
			],inf),
			\oscrange, ~pmodenv.(Pseq([100,200],1), 8).loop,
			//\oscrange, 160,
			\dur, 1/8,
			\amp, 0.4,
			\out, BusDef(\blob, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\blob, \audio),
			\addAction, \addToTail,
			\delay, PmodEnv(Pseq([0.01,0.2],1), 2,\exp).loop,
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
		Pdef(\bass1,Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 100,
			\dur, 1/8,
			\envamt, PmodEnv(Pseq([4,12],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,2,0, 1,2,0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				0.4,0.6,1,1,
			],inf),
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pdef(\bass1,Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 100,
			\dur, 1/8,
			\envamt, PmodEnv(Pseq([4,12],1), 16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, Pseq([
				1,0,1,0,
				0,1,1,1,
				1,1,2,0,
				1,2,0,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1 * Pseq([
				0.4,0.6,1,1,
			],inf),
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \bigbass,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\freqfac, 1,
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
		),
	])
)).play;
);
////////////////// timeline
(
//// drums1
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1422].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,0,1,0,
				],4*12),
				1,0,1,0,
				1,0,1,0,
				0,0,0,0,
				1,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[1845].value,
			\bufnum, ~buflib.snare[1821].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0,
				],4*12),
				0,0,1,0,
				0,0,1,0,
				1,0,0,0,
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\gain, 0.11* Pseq([
				1,Pn(0.8,7)
			],inf),
		),
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[636].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05 * Pseq([
					0.4,0.8,1,1,
				],inf),
				\out, BusDef(\hata1, \audio),
			),
			Pmono(\fx_resonz,
				\inbus, BusDef(\hata1, \audio),
				\addAction, \addToTail,
				\mix, PmodEnv(Pseq([0.8,1,0.2,1,1],1), 8).loop,
				\freq, PmodEnv(Pseq([2400,5000,100,800,3000],1), 8,\exp).loop,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1616].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07 * Pseq([
				1,1,1,1,
				//1,0.7,0.9,0.5,
				//0.1,0.5,0.8,1,
			],inf),
		),

	])
)).play;
);

(
Pdef(\vide, Pbind(
	\type, \rest,
	\dur, 1,
));
Pdef(\part, Pdef(\synths, 
	Ppar([
		Pdef(\bass1,Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				5,7,0,5,
			],inf).stutter(16),
			\octave, 3,
			\lpf, 400,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 0,1,0,1,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\bass1fx, \audio),
		)),
		Pdef(\mela1, Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,-2, ]+7,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,

				0,0,0,0, 0,0,0,-1,
				Pseq([ 0,0,0,0, 0,0,0,5, ]-1,1),
				0,0,0,0, 0,0,0,-1,
				0,0,0,0, 0,0,0,-1,
			],inf),
			\lpf, PmodEnv(Pseq([500,2500],1), 8*4).loop,
			\envamt, 10,
			\legato, Pseq([
				1,1,1,1, 1/2,1,1,1,
			],inf)*0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/3,
			\out, BusDef(\mela1fx, \audio),
		)),
		Pdef(\melb1, Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.20000000298023,
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*4).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				0,0,-5,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3,
			\out, BusDef(\melb1fx, \audio),
		)),

		Pdef(\melc1,  Pbind(
			\instrument, \Piano_rhodeySC,
			\vel, 0.80000001192093,
			\modIndex, 0.70000000298023,
			\modIndex, Pseg(Pseq([0,2],inf),8*4),
			\mix, 0.70000000298023,
			\mix, PmodEnv(Pseq([0,1],1), 8*8).loop,
			\lfoSpeed, 0.40000000596046,
			\lfoDepth, 0.10000000149012,
			\note, Pseq([
				-3,-5,-5,-5,
			],inf),
			\octave, [5,6],
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,

				1,0,1,0,
				1,0,1,0,
				1,0,1,0,
				1,0,1,0,

				1,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1.6,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\melc1fx, \audio),
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\trackfx, 
	Ppar([
		
		Pdef(\bass1fx, 
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\bass1fx),
				\addAction, \addToTail,
				\lag, 0.0005,
				\pregain, 1,
				\postgain, 1,
				\delay, 0,
				\send0, 0,
				\sendbus0, BusDef(\sendbus0, \audio, 2),
				\dur, 1,
			),
		),
		Pdef(\mela1fx, 
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\mela1fx),
				\addAction, \addToTail,
				\lag, 0.0005,
				\pregain, 1,
				\postgain, 1,
				\delay, 0,
				\send0, 0,
				\sendbus0, BusDef(\sendbus0, \audio, 2),
				\dur, 1,
			),
		),
		Pdef(\melb1fx, 
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\melb1fx),
				\addAction, \addToTail,
				\lag, 0.0005,
				\pregain, 1,
				\postgain, 1,
				\delay, 0,
				\send0, 0,
				\sendbus0, BusDef(\sendbus0, \audio, 2),
				\dur, 1,
			),
		),
		Pdef(\melc1fx, 
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\melc1fx),
				\addAction, \addToTail,
				\lag, 0.0005,
				\pregain, 1,
				\postgain, 1,
				\delay, 0,
				\send0, 0,
				\sendbus0, BusDef(\sendbus0, \audio, 2),
				\dur, 1,
			),
		),
	])
)).play;
);



ClipTimeline(\sun109).edit
ClipTimeline(\sun109).presetCompileString.editorInsert
(
ClipTimeline('sun109').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'muted': false, 'recordBus': 0, 'index': 4, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 5, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 6, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 7, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 8, 'recordArmed': false, 
  'solo': false ), ( 'muted': false, 'recordBus': 0, 'index': 9, 'recordArmed': false, 
  'solo': false ) ];
{
ClipTimeline('sun109').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 1.0, \pattern: Pdef('synths'), \playDur: 0.0, \relDur: 0.0, \sustain: 64.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \pattern: Pdef('drums1'), \playDur: 0.0, \relDur: 0.0, \sustain: 28.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 2.0, \pattern: Pdef('bass1fx'), \playDur: 0.0, \relDur: 0.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 3.0, \pattern: Pdef('mela1fx'), \playDur: 0.0, \relDur: 0.0, \sustain: 20.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 6.0, \pattern: Pdef('vide'), \playDur: 0.0, \relDur: 0.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 7.0, \pattern: Pdef('vide'), \playDur: 0.0, \relDur: 0.0, \sustain: 28.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 0.0, \legato: 1, \midinote: 8.0, \pattern: Pdef('vide'), \playDur: 0.0, \relDur: 0.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \legato: 1, \midinote: 9.0, \pattern: Pdef('vide'), \playDur: 8.0, \relDur: 8.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 8.0, \dur: 8.0, \legato: 1, \midinote: 9.0, \pattern: Pdef('vide'), \playDur: 8.0, \relDur: 8.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 16.0, \dur: 0.0, \legato: 1, \midinote: 4.0, \pattern: Pdef('melb1fx'), \playDur: 0.0, \relDur: 0.0, \sustain: 28.0, \type: 'pattern', )),
	PatternEvent((\absTime: 16.0, \dur: 2.0, \legato: 1, \midinote: 6.0, \pattern: Pdef('vide'), \playDur: 2.0, \relDur: 2.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 18.0, \dur: 4.0, \legato: 1, \midinote: 2.0, \pattern: Pdef('bass1fx'), \playDur: 4.0, \relDur: 4.0, \sustain: 22.0, \type: 'pattern', )),
	PatternEvent((\absTime: 22.0, \dur: 2.0, \legato: 1, \midinote: 3.0, \pattern: Pdef('mela1fx'), \playDur: 2.0, \relDur: 2.0, \sustain: 20.0, \type: 'pattern', )),
	PatternEvent((\absTime: 24.0, \dur: 8.0, \legato: 1, \midinote: 8.0, \pattern: Pdef('vide'), \playDur: 8.0, \relDur: 8.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 32.0, \dur: 0.0, \legato: 1, \midinote: 0.0, \pattern: Pdef('drums1'), \playDur: 0.0, \relDur: 0.0, \sustain: 24.0, \type: 'pattern', )),
	(\absTime: 32.0, \dur: 0.0, \label: "unnamed", \playDur: 0.0, \relDur: 0.0, \type: 'locator', ),
	PatternEvent((\absTime: 32.0, \dur: 0.0, \legato: 1, \midinote: 7.0, \pattern: Pdef('vide'), \playDur: 0.0, \relDur: 0.0, \sustain: 28.0, \type: 'pattern', )),
	PatternEvent((\absTime: 32.0, \dur: 8.0, \legato: 1, \midinote: 9.0, \pattern: Pdef('vide'), \playDur: 8.0, \relDur: 8.0, \sustain: 8.0, \type: 'pattern', )),
	PatternEvent((\absTime: 40.0, \dur: 0.0, \legato: 1, \midinote: 5.0, \pattern: Pdef('melc1fx'), \playDur: 0.0, \relDur: 0.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 40.0, \dur: 0.0, \legato: 1, \midinote: 6.0, \pattern: Pdef('vide'), \playDur: 0.0, \relDur: 0.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 40.0, \dur: 2.0, \legato: 1, \midinote: 9.0, \pattern: Pdef('vide'), \playDur: 2.0, \relDur: 2.0, \sustain: 24.0, \type: 'pattern', )),
	PatternEvent((\absTime: 42.0, \dur: 2.0, \legato: 1, \midinote: 2.0, \pattern: Pdef('bass1fx'), \playDur: 2.0, \relDur: 2.0, \sustain: 20.0, \type: 'pattern', )),
	PatternEvent((\absTime: 44.0, \dur: 4.0, \legato: 1, \midinote: 3.0, \pattern: Pdef('mela1fx'), \playDur: 4.0, \relDur: 4.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 48.0, \dur: 0.0, \legato: 1, \midinote: 4.0, \pattern: Pdef('melb1fx'), \playDur: 0.0, \relDur: 0.0, \sustain: 16.0, \type: 'pattern', )),
	PatternEvent((\absTime: 48.0, \dur: 16.0, \legato: 1, \midinote: 8.0, \pattern: Pdef('vide'), \playDur: 16.0, \relDur: 16.0, \sustain: 16.0, \type: 'pattern', )),
	(\absTime: 64.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;




);

///////////
// bug
// full1 has high volume for a second when after gruyere3
// solved: it was fx on hifx bus on both side, should use a different bus for fx, else there is contamination
// or just stop the fx before the end of 32 beats patterns: i've done that

///// transition work

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1422].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0,
				1,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		), 
		Pbind(
				\instrument, \snappad_adsr,
				\note, Pseq([
					[0,4,7,11],
					\r,
				],inf),
				\octave, 5,
				\adsr, Pseq([
					[ Env.adsr(2.1,0.1,0.8,1.1) ],
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
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1422].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0,
				1,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.1,
		), 
		Pbind(
			\instrument, \snappad_adsr,
			\note, Pseq([
				[13,4,7,11],
			],inf),
			\octave, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1 * Pseg(Pseq([0,1],1),2).loop,
		),
	])
)).play;
);

(
// work on transition with recording
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pmono( \playersec,
				\bufnum, BufDef(\mybuf),
				\pos, 24/~t,
				\legato, 1,
				\dur, 1,
				\gain, 1,
			),
			6, Pbind(
				\instrument, \snappad_adsr,
				\note, Pseq([
					[4,7,11,12],
					[4,7,11,12],
					[4,7,11,12],
					[4+12,7+12,11,12],
				],inf).stutter(4),
				\legato, Pseg(Pseq([0.1,1],inf),2),
				\octave, 6,
				\ffreq, PmodEnv(Pseq([1500,15000],1), 2,\exp),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\amp, 0.05 * Pseg(Pseq([0,1],1),2),
			),
		]),
	])
)).play;
);

