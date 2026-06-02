
(
FileSystemProject.loadOnce("sun/main.scd");
~t = 120/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/buflib.scd");
)

(
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([310, 42, 59], [0.048, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;

SynthDef(\sdsnare, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(Env([3500,90,91],[0.005,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.20], -4), 1);
	osc = HPF.ar(osc, 180) * 2;

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,4852,451],[0.01,0.2]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([90,452,7451],[0.01,0.2]), 1));
	snare = snare * EnvGen.kr(Env([0,1,0],[0.001,0.18], -2), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\choipad2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,6,0],[0.4,1.8]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\choipad4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 10;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.2,0.1,0.8,3.1)), gate);
	sig = LFPulse.ar(freq * LFNoise1.kr(0.1!num, mul:0.01,add:1) * ( SinOsc.ar(freq/2) * 4 + 1 )).mean;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * ((0..7)/7 - 0.5 * \lpspread.kr(1.01) * env1 + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 12,0,4,7, ],4),
				Pseq([ 12,0,3,6, ],4),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					0,
				],16),
				Pser([
					-3,
				],16),
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[0,-3],-5
			],inf),
			\octave, 8,
			\lag, Pseq([
				Pwhite(0,0.051!2,1),
				0,
			],inf),
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
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					[0,-3],-5
				],16*4),
				Pseq([
					Pser([
						[-1,-3],-5
					],16),
					Pser([
						[0,-3],-5
					],16),
				],2),
			],inf),
			\octave, 8,
			\lag, Pseq([
				0,
				Pwhite(0,0.051!2,1),
			],inf),
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1413].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[135].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[125].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					[0,-3],-5
				],16*4),
				Pseq([
					Pser([
						[-1,-3],-5
					],16),
					Pser([
						[0,-3],-5
					],16),
				],2),
			],inf),
			\octave, 8,
			\lag, Pseq([
				0,
				Pwhite(0,0.051!2,1),
			],inf),
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1413].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[135].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[125].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, Pseq([
				Pseq([
					3
				],7),4
				
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				//0,1,0,0, 1,0,1,1,
				//1,0,1,1, 0,1,0,1,
				//0,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\legato, 1.2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					[0,-3],-5
				],16*4),
				Pseq([
					Pser([
						[-1,-3],-5
					],16),
					Pser([
						[0,-3],-5
					],16),
				],2),
			],inf),
			\octave, 8,
			\lag, Pseq([
				0,
				Pwhite(0,0.051!2,1),
			],inf),
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1413].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[135].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/2,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[125].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1,
				0,0,1,1,
				0,0,1,1,
				0,1,1,1,
				0,0,1,1,
				0,0,1,1,
				0,0,1,1,
				1,1,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[829].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\hpmix, 1,
			\hpf, Pseg(Pseq([13040,100],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind( // arp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, Pseq([
				Pseq([
					3
				],7),4
				
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				//0,1,0,0, 1,0,1,1,
				//1,0,1,1, 0,1,0,1,
				//0,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\legato, 1.2,
			\amp, 0.1,
		),
		Pbind( // cliqueti
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					[0,-3],-5
				],16*4),
				Pseq([
					Pser([
						[-1,-3],-5
					],16),
					Pser([
						[0,-3],-5
					],16),
				],2),
			],inf),
			\octave, 8,
			\lag, Pseq([
				0,
				Pwhite(0,0.051!2,1),
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // pad
			\instrument, \snappad,
			\note, Pseq([
				Pstep(
					Pseq([
						Pseq([
							Pseq([ [ 12,0,4,7 ], ],2),
							Pseq([ [ 12,0,3,6 ], ],2),
						],2),
						Pseq([
							Pseq([ [ 11,-1,2,7 ], ],2),
							Pseq([ [ 12,0,3,7 ], ],2),
						],2),
					],1),
				1),
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\pwidth, 0.5,
			\pulse, 0.5,
			\saw, 0.5,
			\lpadsr, [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.0099999997764826, 0.40000000596046, 0.080000001192093 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\envamt, Pseg(Pseq([0,7],inf),8),
			\kbamt, 0.0,
			\vcfmod, 0.0,
			\lpf, 930.0,
			\adsr, [ Env([ 0.0, 1.0, 0.20000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.0080000001192093 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				\r,\r,\r,\r,
				\r,\r,-3,-5,
				\r,\r,\r,\r,
				\r,-3,-3,-5,
			],inf),
			\rq, Pseq([
				0.5,
			],inf),
			\legato, Pseq([
				0.1,0.1,1,1,
			],inf),
			\legato, Pseg(Pseq([0.1,1],inf),8) * Pseq([
				0.1,0.5,0.1,1,
				0.1,0.5,0.1,1,
				0.1,0.5,0.4,1,
			],inf),

			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\envamt, 1,
			\lpf, Pseg(Pseq([10,2700],inf),8),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.3,
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
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\envamt, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.15,0.1,3.01) ],
			],inf),
			\envamt, Pseg(Pseq([1,7],inf),8),
			//\envamt, 4,
			\lpf, 500,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\octave, 6,
			\legato, 0.3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.15,0.1,3.01) ],
			],inf),
			\envamt, Pseg(Pseq([1,7],inf),8),
			//\envamt, 4,
			\lpf, 500,
			\rq, 0.7,
			\octave, Pseq([
				Pseq([
					3
				],7),4
				
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				//0,1,0,0, 1,0,1,1,
				//1,0,1,1, 0,1,0,1,
				//0,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\legato, 1.2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \superpw,
			\lpadsr, [ Env([ 0.0, 1.0, 4.0 ], [ 1.6000000238419, 1.40000000596046 ], [ 4.0, 4.0 ]) ],
			\lpenvamt, Pseg(Pseq([1,27],inf),8),
			\lpf, 400.0,
			\rq, 0.7,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\spread, 0.80000001192093,
			\octave, 4,
			\note, Pseq([
				[7,12,0],
				[7,4,0],
				[7,12,0],
				[7,3,0],
			],inf),

			\dur, 1,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				0,7,
			],inf),
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
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\envamt, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.15,0.1,3.01) ],
			],inf),
			\envamt, Pseg(Pseq([1,7],inf),8),
			//\envamt, 4,
			\lpf, 500,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\octave, 6,
			\legato, 0.3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.15,0.1,3.01) ],
			],inf),
			\envamt, Pseg(Pseq([1,7],inf),8),
			//\envamt, 4,
			\lpf, 500,
			\rq, 0.7,
			\octave, Pseq([
				Pseq([
					3
				],7),4
				
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				//0,1,0,0, 1,0,1,1,
				//1,0,1,1, 0,1,0,1,
				//0,1,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\legato, 1.2,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \formant,
			\fenv, [ 0.0, 2.0, -99.0, -99.0, 1.0, 0.10000000149012, 1.0, 0.0, 0.0, 0.80000001192093, 1.0, 0.0 ],
			\fenvamt, Pseg(Pseq([0,0.021],inf),8),
			\bwenv, [ Env([ 0.0, 1.0, 0.0 ], [ 0.10000000149012, 0.80000001192093 ], [ 0.0, 0.0 ]) ],
			\bwenvamt, Pseg(Pseq([0,0.31],inf),9),
			\formfreq, Pseg(Pseq([0,201],inf),10),
			\bwfreq, Pseg(Pseq([10,100],inf),11),
			\adsr, Pseq([
				PpatEnv.adsr(0.01,0.1,0.8,Pseg(Pseq([0.01,0.2],inf),1)),
			],inf),
			\legato, Pseg(Pseq([0.1,1],inf),7),
			\note, Pseq([
				Pser([
					0,0,0,0,
				],8*4),
				Pser([
					3
				],8*4),
			],inf),

			\dur, 1/8/2,
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
			\bufnum, ~buflib.kick[508].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[582].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sdsnare,
			\freq, 200,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind( // arp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.4) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pseq([
					[0,7+12],
					[0,4+12],
					[0,6+12],
					[0,3+12],
				],2),
				Pseq([
					[-1,7+12],
					[-1,4+12],
					[0,7+12],
					[0,3+12],
				],2),
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
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
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \sdsnare,
			\freq, 200,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind( // arp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 0,0,4,7,12,12 ],4*4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pser([ 11,-1,-1,2,7, ],4*4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),9),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.4) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.2,1],inf),8),
		),
		Pbind( // arp
			\instrument, \reese,
			\lpadsramt, 1.0,
			\distamp, 10.0,
			\distpostamp, 0.5,
			\lpf, 1330.0,
			\rq, 0.80000001192093,
			\note, Pseq([
				Pseq([
					Pser([ 12,0,4,7,],4*4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf).stutter(2),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 6,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],inf),8) ,0.1,0.2,0.4),
			],inf),
			\isRest, Pseq([
				0,0,1,0,
				1,1,1,1,
				0,1,0,1,
				0,0,0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseg(Pseq([0.7,0.2,1],inf),7),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pseq([
					[0,7+12],
					[0,4+12],
					[3,6+12],
					[6,3+12],

					[0,7+12],
					[0,4+12],
					[-12,6+12],
					[-12,3+12],
				],1),
				Pseq([
					[-1,7+12],
					[-1,4+12],
					[0,7+12],
					[0,3+12],
				],2),
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// calm
Pdef(\part, Pfindur(16,Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \sdkick,
			\fratio, 2.5,
			\freqpan, 0.0099999997764826,
			\spread, 0.079999998211861,
			\timeScale, 1.0,
			\env0, [ [ 0.0, 3.0, -99.0, -99.0, 1.0, 0.0049999998882413, 5.0, -4.0, 0.5, 0.15999999642372, 5.0, -2.0, 0.0, 0.20000000298023, 5.0, -4.0 ] ],
			\env1, [ [ 110.0, 2.0, -99.0, -99.0, 42.0, 0.048000000417233, 5.0, -4.0, 59.0, 0.28999999165535, 5.0, -5.0 ] ],
			\lpf, 2000.0,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\lag, 1/8/2/~t,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \sdsnare,
			\freq, 200,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,1,0, 
					0,0,1,0, 0,0,0,0, 
				],64),
				Pseq([
					0,0,1,0, 0,0,1,0, 
					0,0,1,0, 0,0,1,0, 
					0,0,1,0, 0,0,1,0, 
					0,0,1,1, 0,1,1,0, 
				],inf),
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[996].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,0,1,

			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8/2,
			\legato, 4,
			\gain, 0.11/2,
		),
		Pbind( // arp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 0,0,4,7,12,12 ],4*4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pser([ 11,-1,-1,2,7, ],4*4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),9),
			\dur, 1/8,
			\isRest, Pseq([
				Pser([
					1,0,
				],32*2),
				Pseq([
					1,1
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.4) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.2,1],inf),8),
		),
		Pbind( // arp
			\instrument, \reese,
			\lpadsramt, 1.0,
			\distamp, 10.0,
			\distpostamp, 0.5,
			\lpf, 1330.0,
			\rq, 0.80000001192093,
			\note, Pseq([
				Pseq([
					Pser([ 12,0,4,7,],4*4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf).stutter(2),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 6,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],inf),8) ,0.1,0.2,0.4),
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				0,0,1,0,
				1,1,1,1,
				0,1,0,1,
				0,0,0,1,
				Pseq([
				0,0,1,0, 1,1,1,1,
				0,1,0,1, 0,0,0,1,
				1,0,1,0, 1,1,1,0,
				1,1,0,1, 0,0,0,1,
				1,0,1,0, 1,1,1,1,
				1,1,0,1, 1,0,1,1,
				],1),
				Pseq([
					1
				],inf),
			],inf).coin.not,
			\amp, 0.1 * Pseg(Pseq([0.7,0.2,1],inf),7),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pseq([
					[0,7+12],
					[0,4+12],
					[3,6+12],
					[6,3+12],

					[0,7+12],
					[0,4+12],
					[-12,6+12],
					[-12,3+12],
				],1),
				Pseq([
					[-1,7+12],
					[-1,4+12],
					[0,7+12],
					[0,3+12],
				],2),
			],inf),
			\octave, 5,
			\legato, Pseg(Pseq([0.1,0.3,1],inf),8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, PmodEnv(Pseq([100,15002],1), 8*2, \exp).loop,
			\at, 3.0,
			\note, Pseq([
				[12+4,7],
				[12+3,6],
				[12+4,7],
				[24,6],
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				0,0,0,12,6,5,4,3
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseg(Pseq([0,1],1),2).loop,
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				Pser([
					7,4,
				],8),
				6,7,
			],inf),
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				1,0,1,1, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,0,1,1,
			],inf).coin.not,
			\pan, Pseq([
				-1,0,1,
			],inf)*0.6,
			\amp, 0.1 * Pseg(Pseq([0,0.5,1],inf),2),
		),
		
	])
))).play;
);

(
// lot of fx
Pdef(\part, Pfindur(16,Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \sdkick,
			\fratio, 2.5,
			\freqpan, 0.0099999997764826,
			\spread, 0.079999998211861,
			\timeScale, 1.0,
			\env0, [ [ 0.0, 3.0, -99.0, -99.0, 1.0, 0.0049999998882413, 5.0, -4.0, 0.5, 0.15999999642372, 5.0, -2.0, 0.0, 0.20000000298023, 5.0, -4.0 ] ],
			\env1, [ [ 110.0, 2.0, -99.0, -99.0, 42.0, 0.048000000417233, 5.0, -4.0, 59.0, 0.28999999165535, 5.0, -5.0 ] ],
			\lpf, 2000.0,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\lag, 1/8/2/~t,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \sdsnare,
			\freq, 200,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,1,0, 
					0,0,1,0, 0,0,0,0, 
				],64),
				Pseq([
					0,0,1,0, 0,0,1,0, 
					0,0,1,0, 0,0,1,0, 
					0,0,1,0, 0,0,1,0, 
					0,0,1,1, 0,1,1,0, 
				],inf),
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[996].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,0,1,

			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8/2,
			\legato, 4,
			\gain, 0.11/2,
		),
		Pbind( // arp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 0,0,4,7,12,12 ],4*4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pser([ 11,-1,-1,2,7, ],4*4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),9),
			\dur, 1/8,
			\isRest, Pseq([
				Pser([
					1,0,
				],32*2),
				Pseq([
					1,1
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.4) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.2,1],inf),8),
		),
		Pbind( // arp
			\instrument, \reese,
			\lpadsramt, 1.0,
			\distamp, 10.0,
			\distpostamp, 0.5,
			\lpf, 1330.0,
			\rq, 0.80000001192093,
			\note, Pseq([
				Pseq([
					Pser([ 12,0,4,7,],4*4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf).stutter(2),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 6,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.01,0.1],inf),8) ,0.1,0.2,0.4),
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],3),
				0,0,1,0,
				1,1,1,1,
				0,1,0,1,
				0,0,0,1,
				Pseq([
				0,0,1,0, 1,1,1,1,
				0,1,0,1, 0,0,0,1,
				1,0,1,0, 1,1,1,0,
				1,1,0,1, 0,0,0,1,
				1,0,1,0, 1,1,1,1,
				1,1,0,1, 1,0,1,1,
				],1),
				Pseq([
					1
				],inf),
			],inf).coin.not,
			\amp, 0.1 * Pseg(Pseq([0.7,0.2,1],inf),7),
			\out, BusDef(\ifxecho, \audio),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pseq([
					[0,7+12],
					[0,4+12],
					[3,6+12],
					[6,3+12],

					[0,7+12],
					[0,4+12],
					[-12,6+12],
					[-12,3+12],
				],1),
				Pseq([
					[-1,7+12],
					[-1,4+12],
					[0,7+12],
					[0,3+12],
				],2),
			],inf),
			\octave, 5,
			\legato, Pseg(Pseq([0.1,0.3,1],inf),8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifxreverb, \audio),
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, PmodEnv(Pseq([100,15002],1), 8*2, \exp).loop,
			\at, 3.0,
			\note, Pseq([
				[12+4,7],
				[12+3,6],
				[12+4,7],
				[24,6],
			],inf),
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\ifxflanger, \audio),
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\ifxflanger, \audio),
			\flangefreq, 0.40000000149012,
			\fb, 0.40000000149012,
			\maxdelay, 0.019999999552965,
			\lfomul, 0.1099999997764826,
			\delay, 0.0019999998882413,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				0,0,0,12,6,5,4,3
			],inf),
			\isRest, Pseq([
				0,0,1,1, 1,1,1,1,
				0,0,1,1, 1,1,1,1,
				0,0,1,1, 1,1,1,1,
				0,0,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 0.3,
			\amp, 0.1 * Pseg(Pseq([0,1],1),2).loop,
		),
		Pmono(\fx_echo,
			\maxdelay, 1.0,
			\delay, 1.0/6/~t,
			\decay, 2.0/~t,
			\lpf, 19000.0,
			\hpf, 50.0,
			\pfmix, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\ifxecho, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \kalimba,
			\note, Pseq([
				Pser([
					7,4,
				],8),
				6,7,
			],inf),
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				1,0,1,1, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,0,1,1,
			],inf).coin.not,
			\octave, 6,
			\pan, Pseq([
				-1,0,1,
			],inf)*0.6,
			\amp, 0.1 * Pseg(Pseq([0,0.5,1],inf),2),
			\out, BusDef(\ifxreverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\verbmix, 1.0,
			\room, 1.5,
			\damp, 0.5,
			\mix, 0.5,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\gain, 1.0,
			\inbus, BusDef(\ifxreverb, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
))).play;
);

(
// more fx
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,7,6,5,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifxecho, \audio),
		),
		Pmono(\fx_echo,
			\maxdelay, 1.0,
			\delay, 1.0/8/~t,
			\decay, 2.0/~t,
			\lpf, 19000.0,
			\hpf, 50.0,
			\pfmix, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\ifxecho, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
(
// more fx
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,7,6,5,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\out, BusDef(\ifxecho, \audio),
			//\out, BusDef(\ifxreverb, \audio),
		),
		Pmono(\fx_freqshiftfb,
			\maxdelay, 1.0,
			\delay, 1.0/8/4/~t,
			\delay, 0.001,
			\delay, PmodEnv(Pseq([0.1,0.002],1), 8,\exp).loop,
			\fb, 0.2,
			//\shift, Pwhite(1,100,inf).trace,
			\note, Pseq([
				0,7,6,5,
			],inf),
			\octave, 3,
			\shift, Pkey(\freq),
			\shift, 66,
			\hpf, PmodEnv(Pseq([10,12000],1), 8).loop,
			\lpf, 19000,
			\pfmix, 0.5,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\ifxecho, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\ifxreverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifxreverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1/8,
			\gain, 1/2,
			\out, BusDef(\ifxphaser, \audio),
		),
		Pbind( // arp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 12,0,4,7, ],4*4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pser([ 11,-1,2,7, ],4*4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),9),
			\dur, 1/8,
			\isRest, Pseq([
				Pser([
					1,1,
				],32*2),
				Pseq([
					1,1
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.4) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.2,1],inf),8),
			\out, BusDef(\ifxphaser, \audio),
		),
		Pmono(\fx_phaser,
			\freq, 0.10000000298023,
			\maxdelay, 0.19999999552965,
			\lfomul, 0.01,
			\delay, 0.05,
			\decay, 0.2,
			\mix, 0.5,
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\inbus, BusDef(\ifxphaser, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
// trance
Pdef(\part, Pfindur(16,Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\env1, Pseq([
				[ Env([300,42,41],[0.02,0.8]) ]
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.15 * Pseg(Pseq([0,1,Pn(1,inf)],inf),8),
			\out, BusDef(\track1, \audio),
		),
		Pbind( // arp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 0,4,7,12, ],32),
					Pser([ 12,0,3,6, ],32),
				],2),
				Pseq([
					Pser([ 11,-1,-1,2,7, ],32),
					Pser([ 12,0,3,7, ],32),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 3,
			\envamt, Pseg(Pseq([0,4],inf),9),
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,1,1,1
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.2,0.4) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.2,1],inf),8),
			\out, BusDef(\comp, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1,\audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sideinbus, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\sideinbus, \audio),
			\cpt, 0.021,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1,4),
			\gain, 1,
			\out, BusDef(\ifxvocoder, \audio),
		).loop,
		Pbind(
			\instrument, \fx_vocoder,
			\inbus, BusDef(\ifxvocoder),
			\dur, 2,
			\octave, 5,
			\legato, 1,
			\rq, PmodEnv(Pseq([0.001,0.2],1), 8, 2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pseq([
					[0,7+12],
					[0,4+12],
					[3,6+12],
					[6,3+12],

					[0,7+12],
					[0,4+12],
					[-12,6+12],
					[-12,3+12],
				],1),
				Pseq([
					[-1,7+12],
					[-1,4+12],
					[0,7+12],
					[0,3+12],
				],2),
			],inf),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, PmodEnv(Pseq([100,15002],1), 8*2, \exp).loop,
			\at, 3.0,
			\note, Pseq([
				[12+4,7],
				[12+3,6],
				[12+4,7],
				[24,6],
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
))).play;
);
BPF
(
// trance
Pdef(\part, Pfindur(16,Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\env1, Pseq([
				Pseq([
					[ Env([300,42,41],[0.02,0.8]) ]
				],2*8),
				Pseq([
					[ Env([300,42,41],[0.04,0.8]) ]
				],2*8),
				Pser([
					[ Env([500,42,41],[0.04,0.8]) ],
					[ Env([500,42,41],[0.04,0.8]) ],
					[ Env([500,42,41],[0.04,0.8]) ],
					[ Env([500,42,41],[0.04,0.8]) ],
					[ Env([500,42,41],[0.02,0.8]) ],
					[ Env([500,42,41],[0.02,0.8]) ],
					[ Env([500,42,41],[0.01,0.8]) ],
					[ Env([500,42,41],[0.01,0.8]) ],
				],4*8),
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			//\amp, 0.15 * Pseg(Pseq([0,1,Pn(1,inf)],inf),8),
			\amp, 0.15,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[136].value,
			//\bufnum, ~buflib.clap[180].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[136].value,
			\bufnum, ~buflib.clap[180].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[311].value,
			\bufnum, ~buflib.clap[266].value,
			\bufnum, ~buflib.clap[40].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,0, 0,1,0,0,
				0,0,1,1, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\legato, 0.4,
			\gain, 0.1/1.6,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 0,7,12 ],
				[ 0,3,12 ],
				[ 0,5,9 ],
				[ 0,5,8 ],
			],inf),
			\octave, 6,
			\dur, 1,
			\isRest, Pseq([
				1,0,1,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.4,3.1,1,-4) ],
			],inf),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				7,6, 7,6,
				7,6, 10,6,
				7,6, 7,6,
				7,6, 9,6,
			],inf),
			\octave, 5,
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,0,
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					0,12,3,7,
				],4),
				Pseq([
					0,12,3,6,
				],4),
			],inf),
			\envamt, 5,
			\lpf, PmodEnv(Pseq([100,8000],1), 8, \exp).loop,
			\octave, Pseq([
				Pseq([
					4,4,4,4,
					3,4,5,4,
				],8*2),
				//Pseq([
					//4,3,4,5,
				//],8*2),
			],inf),
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.2,0.7) ],
				[ Env.adsr(0.1,0.1,0.2,0.7) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
				[ Env.adsr(0.01,0.1,0.2,0.1) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1 * Pseq([
				Pwhite(0.1,0.5,1),
				Pwhite(0.3,0.9,1),
				Pwhite(0.5,0.9,1),
				Pwhite(0.3,0.9,1),
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					0
				],13),
				Pseq([
					3
				],3),
			],inf),
			\dur, 1/8,
			\octave, 3,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.4,0.1,0.1) ],
				],13),
				Pseq([
					[ Env.adsr(0.01,0.4,0.5,0.1) ],
				],3),
			],inf),
			\legato, 1.0,
			\amp, 0.1 * Pseq([
				0.2, 1,
			],inf),
		),
		
	])
))).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1,8),
			\gain, 0.1,
			\out, BusDef(\ifxvocoder, \audio),
		).loop,
		Pbind(
			\instrument, \fx_vocoder,
			\inbus, BusDef(\ifxvocoder),
			\dur, 2,
			\octave, 4,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pseq([
					[0,7+12],
					[0,4+12],
					[3,6+12],
					[6,3+12],

					[0,7+12],
					[0,4+12],
					[-12,6+12],
					[-12,3+12],
				],1),
				Pseq([
					[-1,7+12],
					[-1,4+12],
					[0,7+12],
					[0,3+12],
				],2),
			],inf),
			\amp, 4.1,
		),
		
	])
)).play;
);

////////

(
Pdef(\part, Pdef(\drums3, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pseq([
					[0,7+12],
					[0,4+12],
					[3,6+12],
					[6,3+12],

					[0,7+12],
					[0,4+12],
					[-12,6+12],
					[-12,3+12],
				],1),
				Pseq([
					[-1,7+12],
					[-1,4+12],
					[0,7+12],
					[0,3+12],
				],2),
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					Pser([
						7,4,
					],8*2),
					Pser([
						6,6,3,3
					],8*2),
				],8*4),
			],inf),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],4),


				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


////////

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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				[ 0,7, ],
				[ 0,6, ]
			],inf),
			\bpf, Pseg(Pseq([70,3001],inf),8*2),
			\legato, 1,
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				Pseq([
					[ 0,7, ],
					[ 0,6, ]
				],2),
				Pseq([
					[ -1,7, ],
					[ 3,7, ]
				],2),
			],inf),
			\legato, 1,
			\lpf, PmodEnv(Pseq([100,7000],1), 8*2).loop,
			\hpf, PmodEnv(Pseq([10000,70],1), 8*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.2) ],
			],inf),
			\dur, 2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([1,4,-1,0],inf),16/3),
			\dur, 1/8,
			\lpf, Pseg(Pseq([1000,100],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8*2),
			//\out, BusDef(\ifx1, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				Pseq([
					[ 0,7, ],
					[ 0,6, ]
				],2),
				Pseq([
					[ -1,7, ],
					[ 3,7, ]
				],2),
			],inf),
			\legato, 1,
			\lpf, PmodEnv(Pseq([100,7000],1), 8*2).loop,
			\hpf, PmodEnv(Pseq([10000,70],1), 8*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.2) ],
			],inf),
			\dur, 2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						Pseq([
							Pseq([ 12,0,4,7, ].scramble,4),
							Pseq([ 12,0,3,6, ],4),
						],2),
						Pseq([
							Pseq([ 11,-1,2,7, ].scramble,4),
							Pseq([ 12,0,3,7, ],4),
						],2),
					],1).stutter(2) + Pseq(([-12,0,0,0,12]!4).flat.scramble.keep(16),inf)
				}).loop,
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, Pseq([4],inf),
			\envamt, Pseg(Pseq([1,4,-1,0],inf),16/3),
			\dur, 1/8/2,
			\lpf, Pseg(Pseq([9000,100],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8*2),
			//\out, BusDef(\ifx1, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				Pseq([
					[ 0,7, ],
					[ 0,6, ]
				],2),
				Pseq([
					[ -1,7, ],
					[ 3,7, ]
				],2),
			],inf),
			\legato, 1,
			\lpf, PmodEnv(Pseq([100,7000],1), 8*2).loop,
			\hpf, PmodEnv(Pseq([10000,70],1), 8*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.2) ],
			],inf),
			\dur, 2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						Pseq([
							Pser([ 0-12,12 ],8*2),
							Pser([ 6-12,6+12, ],8*2),
						],2),
						Pseq([
							Pser([ 11-12,11+12, ],8*2),
							Pser([ 3-12,3+12, ],8*2),
						],2),
					],1)
				}).loop,
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, Pseq([4],inf),
			\envamt, Pseg(Pseq([1,4,-1,0],inf),16/3),
			\dur, 1/8/2,
			\lpf, Pseg(Pseq([9000,100],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8*2)  /1.3,
			//\out, BusDef(\ifx1, \audio),
		),
	])
)).play;
);

/// mono brouilpad and custom arp

(
SynthDef(\monobrouilpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lpenv, hpenv;
	sig = LFPulse.ar(freq * LFSaw.ar(freq * 2.00723*[1,0.99] * \fmr.kr(1), add:1, mul:\fma.kr(1.4)));

	sig2 = BPF.ar(sig, ( \bpf.kr(480) * \bpfr.kr(1) ).clip(20,20000), \rq.kr(0.3)) * 2;

	sig = LPF.ar(sig, \lpf.kr(7180));
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = sig + sig2;

	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = DelayL.ar(sig, 0.2, ( env2+1 ) * 0.1) + sig;
	sig = DelayL.ar(sig, 0.2, \delayr.kr(1) * \delay.kr(0.01)) + sig;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pfindur(16,Pmono(
			 \monobrouilpad,
			\note, Pseq([
				Pseq([
					[ 0,7, ],
					[ 0,6, ]
				],2),
				Pseq([
					[ -1,7, ],
					[ 3,7, ]
				],2),
			],inf),
			\legato, 1,
			\bpfr, PmodEnv(Pseq([1,2,1,4,8],1), Pseq([1,1,10,10],inf)).loop,
			\lpf, PmodEnv(Pseq([100,7000],1), 8*2).loop,
			\hpf, PmodEnv(Pseq([10000,70],1), 8*2).loop,
			\fma, PmodEnv(Pseq([8,1/2,4],1), Pseq([6,10],1)).loop,
			//\fmr, PmodEnv(Pseq([1/2,4],1), 2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.2) ],
			],inf),
			\dur, 2,
			\amp, 0.1/2,
		)).loop,
		Pbind( // custom arp
			\instrument, \sh101,
			\note, Pseq([
				Prout({ arg ev;
					Pseq([
						Pseq([
							Pser([ [ 0,4,7, ] ],1),
							Pser([ [ 0,3,6, ] ],1),
						],2),
						Pseq([
							Pser([ [ -1,2,7, ] ],1),
							Pser([ [ 0,3,7, ] ],1),
						],2),
					],1).do { arg chord;
						// should have 32 note per chord in 1/16, 2 beats per chord, 16 beats total
						chord = chord ++ ( chord+12 );
						//Pser([0,4,1,5,0,4,1,5],32).do { arg idx;
							//chord.wrapAt(idx).yield
						//};
						Pser([1,2],32).do { arg idx;
							chord.wrapAt(idx).yield
						};
					};
				}),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, Pseq([4],inf),
			\envamt, Pseg(Pseq([1,4,-1,0],inf),16/3),
			\dur, 1/8/2,
			\lpf, Pseg(Pseq([9000,100],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8*2) / 1.3,
			//\out, BusDef(\ifx1, \audio),
		),
		Ptpar([
			16, Pdef(\drums3),
			14, Pbind(
				\instrument, \brouilpad,
				\note, Pseq([
					7,
				],1),
				\dur, 4,
				\adsr, Pseq([
					[ Env.adsr(4.3,0.1,0.8,4.1) ],
				],inf),
				\amp, 0.1,
			),
		]),
	])
)).play;
);

(

SynthDef(\rdn_noiser, { arg out=0, gate=1;
	// code: 4-HB1D-GJP6
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 544550.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = [
			{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			}.value(si, env);
			,
			{ arg si, env;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			}.value(si, env);

		].mean;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;


Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.68243243243243,
	'fb', 0.001632510171073,
	'delay', 0.059307448950106,
	'delay2', 0.00018574090746386,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 20.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.51260504201681,
	'postlpf', 16803.499738589,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)


);

(
// add fx
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pfindur(16,Pmono(
			 \monobrouilpad,
			\note, Pseq([
				Pseq([
					[ 0,7, ],
					[ 0,6, ]
				],2),
				Pseq([
					[ -1,7, ],
					[ 3,7, ]
				],2),
			],inf),
			\legato, 1,
			\bpfr, PmodEnv(Pseq([1,2,1,4,8],1), Pseq([1,1,10,10],inf)).loop,
			\lpf, PmodEnv(Pseq([100,7000],1), 8*2).loop,
			\hpf, PmodEnv(Pseq([10000,70],1), 8*2).loop,
			\fma, PmodEnv(Pseq([8,1/2,4],1), Pseq([6,10],1)).loop,
			//\fmr, PmodEnv(Pseq([1/2,4],1), 2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.2) ],
			],inf),
			\dur, 2,
			\amp, 0.1/2,
		)).loop,
		Pbind( // custom arp
			\instrument, \sh101,
			\note, Pseq([
				Prout({ arg ev;
					Pseq([
						Pseq([
							Pser([ [ 0,4,7, ] ],1),
							Pser([ [ 0,3,6, ] ],1),
						],2),
						Pseq([
							Pser([ [ -1,2,7, ] ],1),
							Pser([ [ 0,3,7, ] ],1),
						],2),
					],1).do { arg chord;
						// should have 32 note per chord in 1/16, 2 beats per chord, 16 beats total
						chord = chord ++ ( chord+12 );
						//Pser([0,4,1,5,0,4,1,5],32).do { arg idx;
							//chord.wrapAt(idx).yield
						//};
						Pser([1,2],32).do { arg idx;
							chord.wrapAt(idx).yield
						};
					};
				}),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, Pseq([4],inf),
			\envamt, Pseg(Pseq([1,4,-1,0],inf),16/3),
			\dur, 1/8/2,
			\lpf, Pseg(Pseq([9000,100],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8*2),
			\out, BusDef(\track1, \audio),
		),
		Ptpar([
			16, Pdef(\drums3),
			14, Pbind(
				\instrument, \brouilpad,
				\note, Pseq([
					7,
				],1),
				\dur, 4,
				\adsr, Pseq([
					[ Env.adsr(4.3,0.1,0.8,4.1) ],
				],inf),
				\amp, 0.1,
			),
		]),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\noiser, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdn_noiser,
			\inbus, BusDef(\noiser, \audio),
			\addAction, \addToTail,
			\gain, PmodEnv(Pseq([0.001,1,1],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 1.0,
			'fb', 0.001632510171073,
			'delay', PmodEnv(Pseq([0.00101,0.0001,1],1), 8,\exp).loop,
			'delay2', PmodEnv(Pseq([0.00001,0.01,1],1), 8,\exp).loop,
			'shift', 0.1,
			'shift2', 0.0,
			'distamp', 1.2492192141522,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 20000.0,
			'hpf', PmodEnv(Pseq([2e4,2],1), 16,\exp).loop,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.51260504201681,
			'postlpf', 16803.499738589,
			'posthpf', 80.0,
			'wetamp', 0.03579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);



//////

(
// breakbeat
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.15]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.2,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.05]) ],
			],inf),
			\env1, Pseq([
				[ Env([300,61,50],[0.02,0.05]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[63].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				0,1,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[63].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,1, 0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1636].value,
			//\bufnum, ~buflib.hat[1139].value,
			//\bufnum, ~buflib.hat[1783].value,
			\bufnum, Pseq([
				~buflib.hat[1107].value,
				//~buflib.hat[1108].value,
			],inf),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,1,0,
				1,1,1,1, 1,1,0,1,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.8,0.2,
			],inf),
			\speed, Pseq([
				1,1.01,
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				1,
				0.41,
			],inf),
		),
		
	])
)).play;
);


(
// add chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.15]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, 0.2,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.05]) ],
			],inf),
			\env1, Pseq([
				[ Env([300,61,50],[0.02,0.05]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1/1.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[63].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				0,1,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[63].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,1, 0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\legato, 0.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1636].value,
			//\bufnum, ~buflib.hat[1139].value,
			//\bufnum, ~buflib.hat[1783].value,
			\bufnum, Pseq([
				~buflib.hat[1108].value,
				//~buflib.hat[1108].value,
			],inf),
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 1,0,1,0,
				0,1,1,0, 1,0,0,1,
				1,0,1,0, 0,1,1,0,
				1,1,1,1, 1,1,0,1,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.8,0.2,
			],inf),
			\speed, Pseq([
				1,1.01,
			],inf),
			\dur, 1/8/2,
			\gain, 0.11 * Pseq([
				1,
				0.41,
			],inf),
		),
		Pbind(
			\instrument, \choipad4,
			\note, Pseq([
				Pseq([
					[ 0,7, ],
					[ 0,6, ]
				],2),
				Pseq([
					[ -1,7, ],
					[ 3,7, ]
				],2),
			],inf),
			\legato, 1,
			\octave,6,
			\lpf, PmodEnv(Pseq([100,7000],1), 8*2).loop,
			\hpf, PmodEnv(Pseq([10000,70],1), 8*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.2) ],
			],inf),
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \choipad2,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf).stutter(2),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\lpf, PmodEnv(Pseq([200,1000],1), 8, \exp).loop,
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8)/3,
		),
		
	])
)).play;
);

(
// add noiser
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(\out, BusDef(\noiser, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \sdkick,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 0.2,
				\env0, Pseq([
					[ Env([0,1,0],[0.01,0.15]) ],
				],inf),
				\dur, 1/8/2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \sdkick,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,0,0,1,
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\legato, 0.2,
				\env0, Pseq([
					[ Env([0,1,0],[0.01,0.05]) ],
				],inf),
				\env1, Pseq([
					[ Env([300,61,50],[0.02,0.05]) ],
				],inf),
				\dur, 1/8/2,
				\amp, 0.1/1.5,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[63].value,
				//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
				\isRest, Pseq([
					0,1,1,0, 0,1,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[63].value,
				//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
					0,1,0,0, 0,1,0,1, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8/2,
				\legato, 0.2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1636].value,
				//\bufnum, ~buflib.hat[1139].value,
				//\bufnum, ~buflib.hat[1783].value,
				\bufnum, Pseq([
					~buflib.hat[1108].value,
					//~buflib.hat[1108].value,
				],inf),
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,0,1, 1,0,1,0,
					0,1,0,0, 1,0,0,1,
					1,0,0,1, 1,0,1,0,
					0,1,1,0, 1,0,0,1,
					1,0,1,0, 0,1,1,0,
					1,1,1,1, 1,1,0,1,
					1,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					0.8,0.2,
				],inf),
				\speed, Pseq([
					1,1.01,
				],inf),
				\dur, 1/8/2,
				\gain, 0.11 * Pseq([
					1,
					0.41,
				],inf),
			),
		]),
		Pmono(\rdn_noiser,
			\inbus, BusDef(\noiser, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,

			'wet10', 1.0,
			'mix', 0.051,
			'gain', 0.68243243243243,
			'fb', 0.00001632510171073,
			'delay', 0.00002307448950106,
			'delay2', 0.00008574090746386,
			\delay, PmodEnv(Pseq([0.00001,0.0003],1), 8).loop,
			\delay2, PmodEnv(Pseq([0.001,0.0003],1), 8).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.7492192141522,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 20000.0,
			'hpf', 420.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.51260504201681,
			'postlpf', 10803.499738589,
			'posthpf', PmodEnv(Pseq([1,10000],1), 8,\exp).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\noiser2, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\noiser2, \audio),
			\delay, 1/8/~t,
			\decay, 1/2/~t,
			\mix, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, Pseq([ 1,1,1,1, ]*0.2,1),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					1,1,1,1, 1,1,1,1,
				],2)*0.2,
			],inf),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/8,
		),
		
	])
)).play;
);

(
// dnb
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.8,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.15]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.05]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,1,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,1,1,0, 1,1,1,1,
				0,1,1,0, 0,0,1,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1.1,
			],inf),
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				0.9,0.7,
				1,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\bufnum, ~buflib.snare[1565].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\bufnum, ~buflib.snare[1565].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);


/////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums3),
		Plazy({ arg ev;
			var post = Pbind(
				\instrument, \pluck,
				//\lag, 0.04,
				\note, Pseq([
					Prand([
						Prand([0,12,-5,7],3),
						Prand([
							7,4,5,6,3,2,
						],1),
					],1),
				],inf).stutter(2),
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0, 
				],inf).coin.not,
				\dur, 1/8/2,
				\octave, 7,
				//\lag, -0.04,
				//\out, BusDef(\sendbus3, \audio),
				\amp, 0.1/10,
			);

			Ptpar([
				0, Pbind(
					\instrument, \pluck,
				) <> post,
				12, Pbind(
					\instrument, \basicbass,
					\note, Pkey(\note) + Pseq([0,-7,5],inf),
					\note, Pseq([0,-5,7],inf),
					\lpf, 7000,
					\amp, 0.1/15,
					\notRest, Pseq([
						0,0,0,0,
						0,0,0,0,
						Pseq([
							1,0,0,0,
							1,0,0,0,
							Prand([
								Pseq([
									1,0,0,0,
								],1),
								Pseq([
									1,0,0,1,
								],1),
							],1),
						],inf),
					],inf).coin,
					\isRest, Pfunc({ arg ev;
						ev[\isRest].not or: ev[\notRest]
					}).not,
					\octave, Prand([6,7,8],inf),
					\octave, 5,
				) <> post,
			]);
		}).loop,
		Pbind(
			\instrument, \strings,
			\legato, 1,
			\amp, 0.1/2,
			\note, Pseq([
				Pseq([
					Pseq([ [ 12,0,4,7, ] ],2),
					Pseq([ [ 12,0,3,6, ] ],2),
				],2),
				Pseq([
					Pseq([ [ 11,-1,2,7, ] ],2),
					Pseq([ [ 12,0,3,7, ] ],2),
				],2),
			],inf),
			\dur, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			].scramble,inf).coin.not,
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
	])
)).play;
);

///////// up and down
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[125].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseg(Pseq([0.1,1],inf),8),
		),

		Pbind(
			\instrument, \strings,
			\legato, 1,
			\amp, 0.1/2,
			\note, Pseq([
				Pseq([
					Pseq([ [ 12,0,4,7, ] ],2),
					Pseq([ [ 12,0,3,6, ] ],2),
				],2),
				Pseq([
					Pseq([ [ 11,-1,2,7, ] ],2),
					Pseq([ [ 12,0,3,7, ] ],2),
				],2),
			],inf),
			\dur, 1,
			//\legato, Pseg(Pseq([0.1,1],inf),8),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			].scramble,inf).coin.not,
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
			\out, BusDef(\ifxlpf, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\ifxlpf, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([100,2000],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 12,0,4,7, ],4),
				Pseq([ 12,0,3,6, ],4),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\dur, 1/8,
			\lpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1/2 * Pseg(Pseq([0.8,1],inf),8),
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,1,
				0,0,1,0, 1,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sdkick,
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1, 
				0,0,0,0, 0,0,1,0,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.15,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[125].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseg(Pseq([0.1,1],inf),8),
		),

		Pfindur(4,Ptpar([
			3, Pbind(
				\instrument, \strings,
				\legato, 1,
				\amp, 0.1/2,
				\freq, PmodEnv(Pseq([100,200]*2,2), 1).loop,
				\dur, 1,
				//\legato, Pseg(Pseq([0.1,1],inf),8),
				\isRest, Pseq([
					1,
				].scramble,1).coin.not,
				//\out, BusDef(\sendbus1, \audio),
				//\isRest, true,
				//\out, BusDef(\ifxlpf, \audio),
				\isRest, true,
			),
		])).loop,
		Pbind(
			\instrument, \strings,
			\legato, 1,
			\amp, 0.1,
			\note, Pseq([
				Pseq([
					Pseq([ [ 12,0,4,7, ] ],1),
					Pseq([ [ 12,0,3,6, ] ],1),
				],2),
				Pseq([
					Pseq([ [ 11,-1,2,7, ] ],1),
					Pseq([ [ 12,0,3,7, ] ],1),
				],2),
			],inf),
			\dur, 2,
			//\legato, Pseg(Pseq([0.1,1],inf),8),
			\isRest, Pseq([
				1,
			].scramble,inf).coin.not,
			\out, BusDef(\ifxlpf, \audio),
			//\isRest, true,
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\ifxlpf, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([100,400,18000],1), Pseq([2,2],inf), \exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 12,0,4,7, ],4),
				Pseq([ 12,0,3,6, ],4),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\dur, 1/8,
			\lpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1/2 * Pseg(Pseq([0.8,1],inf),8),
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 1,0,0,1,
				0,0,1,0, 1,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sdkick,
			\dur, 1/8/2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1, 
				0,0,0,0, 0,0,1,0,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\amp, 0.15,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \choipad2,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf).stutter(2),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\lpf, PmodEnv(Pseq([400,14000],1), 8, \exp).loop,
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8)/3,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 0,
			\mix, PmodEnv(Pseq([0,1],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\mix, PmodEnv(Pseq([0,1],1), 8).loop,
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
			\instrument, \choipad2,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf).stutter(2),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\lpf, PmodEnv(Pseq([400,14000],1), 8, \exp).loop,
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,0.2) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8)/3,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 0,
			\mix, PmodEnv(Pseq([0,1],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\mix, PmodEnv(Pseq([0,1],1), 8).loop,
			\lag, 0.00091,
			\dur, 1,
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\ifx3, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([Pn(1,8),10000],1), 1,\exp).loop,
			\lag, 0.00092,
			\dur, 1,
			\isRest, true,
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\ifx3, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([Pn(20000,8),200],1), 1,\exp),
			\lag, 0.00092,
			\dur, Pn(1,8),
		).loop,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(\out, BusDef(\masterfx, \audio)) <>
		Ppar([

			Pdef(\drums3),
			Plazy({ arg ev;
				var post = Pbind(
					\instrument, \pluck,
					//\lag, 0.04,
					\note, Pseq([
						Prand([
							Prand([0,12,-5,7],3),
							Prand([
								7,4,5,6,3,2,
							],1),
						],1),
					],inf).stutter(2),
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0, 
					],inf).coin.not,
					\dur, 1/8/2,
					\octave, 7,
					//\lag, -0.04,
					//\out, BusDef(\sendbus3, \audio),
					\amp, 0.1/10,
				);

				Ptpar([
					0, Pbind(
						\instrument, \pluck,
					) <> post,
					12, Pbind(
						\instrument, \basicbass,
						\note, Pkey(\note) + Pseq([0,-7,5],inf),
						\note, Pseq([0,-5,7],inf),
						\lpf, 7000,
						\amp, 0.1/15,
						\notRest, Pseq([
							0,0,0,0,
							0,0,0,0,
							Pseq([
								1,0,0,0,
								1,0,0,0,
								Prand([
									Pseq([
										1,0,0,0,
									],1),
									Pseq([
										1,0,0,1,
									],1),
								],1),
							],inf),
						],inf).coin,
						\isRest, Pfunc({ arg ev;
							ev[\isRest].not or: ev[\notRest]
						}).not,
						\octave, Prand([6,7,8],inf),
						\octave, 5,
					) <> post,
				]);
			}).loop,
			Pbind(
				\instrument, \strings,
				\legato, 1,
				\amp, 0.1/2,
				\note, Pseq([
					Pseq([
						Pseq([ [ 12,0,4,7, ] ],2),
						Pseq([ [ 12,0,3,6, ] ],2),
					],2),
					Pseq([
						Pseq([ [ 11,-1,2,7, ] ],2),
						Pseq([ [ 12,0,3,7, ] ],2),
					],2),
				],inf),
				\dur, 1,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				].scramble,inf).coin.not,
				//\out, BusDef(\sendbus1, \audio),
				//\isRest, true,
			),
		]),
		//Pmono(\fx_lpf,
			//\inbus, BusDef(\masterfx, \audio),
			//\addAction, \addToTail,
			//\lpf, PmodEnv(Pseq([20000,100],1), 8, \exp),
			//\lag, 0.0009,
			//\dur, 1,
		//).loop,
		Pmono(\fx_hpf,
			\inbus, BusDef(\masterfx, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,20000],1), 8, \exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\masterfx2, \audio)) <>
		Ppar([
			Plazy({ arg ev;
				var post = Pbind(
					\instrument, \pluck,
					//\lag, 0.04,
					\note, Pseq([
						Prand([
							Prand([0,12,-5,7],3),
							Prand([
								7,4,5,6,3,2,
							],1),
						],1),
					],inf).stutter(2),
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0, 
					],inf).coin.not,
					\dur, 1/8/2,
					\octave, 7,
					//\lag, -0.04,
					//\out, BusDef(\sendbus3, \audio),
					\amp, 0.1/10,
				);
			
				Ptpar([
					0, Pbind(
						\instrument, \pluck,
					) <> post,
					12, Pbind(
						\instrument, \basicbass,
						\note, Pkey(\note) + Pseq([0,-7,5],inf),
						\note, Pseq([0,-5,7],inf),
						\lpf, 7000,
						\amp, 0.1/15,
						\notRest, Pseq([
							0,0,0,0,
							0,0,0,0,
							Pseq([
								1,0,0,0,
								1,0,0,0,
								Prand([
									Pseq([
										1,0,0,0,
									],1),
									Pseq([
										1,0,0,1,
									],1),
								],1),
							],inf),
						],inf).coin,
						\isRest, Pfunc({ arg ev;
							ev[\isRest].not or: ev[\notRest]
						}).not,
						\octave, Prand([6,7,8],inf),
						\octave, 5,
					) <> post,
				]);
			}).loop,
			Pbind(
				\instrument, \strings,
				\legato, 1,
				\amp, 0.1/2,
				\note, Pseq([
					Pseq([
						Pseq([ [ 12,0,4,7, ] ],2),
						Pseq([ [ 12,0,3,6, ] ],2),
					],2),
					Pseq([
						Pseq([ [ 11,-1,2,7, ] ],2),
						Pseq([ [ 12,0,3,7, ] ],2),
					],2),
				],inf),
				\dur, 1,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				].scramble,inf).coin.not,
				//\out, BusDef(\sendbus1, \audio),
				//\isRest, true,
			),
		]),
		Pmono(\fx_lpf,
			\inbus, BusDef(\masterfx2, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([20000,1000],1), 8, \exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind(\out, BusDef(\masterfx, \audio)) <>
		Ppar([
			Pdef(\drums3),
		]),
		Pmono(\fx_hpf,
			\inbus, BusDef(\masterfx, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,10000],1), 8, \exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\masterfx2, \audio)) <>
		Ppar([
			Plazy({ arg ev;
				var post = Pbind(
					\instrument, \pluck,
					//\lag, 0.04,
					\note, Pseq([
						Prand([
							Prand([0,12,-5,7],3),
							Prand([
								7,4,5,6,3,2,
							],1),
						],1),
					],inf).stutter(2),
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0, 
					],inf).coin.not,
					\dur, 1/8/2,
					\octave, 7,
					//\lag, -0.04,
					//\out, BusDef(\sendbus3, \audio),
					\amp, 0.1/10,
				);
			
				Ptpar([
					0, Pbind(
						\instrument, \pluck,
					) <> post,
					12, Pbind(
						\instrument, \basicbass,
						\note, Pkey(\note) + Pseq([0,-7,5],inf),
						\note, Pseq([0,-5,7],inf),
						\lpf, 7000,
						\amp, 0.1/15,
						\notRest, Pseq([
							0,0,0,0,
							0,0,0,0,
							Pseq([
								1,0,0,0,
								1,0,0,0,
								Prand([
									Pseq([
										1,0,0,0,
									],1),
									Pseq([
										1,0,0,1,
									],1),
								],1),
							],inf),
						],inf).coin,
						\isRest, Pfunc({ arg ev;
							ev[\isRest].not or: ev[\notRest]
						}).not,
						\octave, Prand([6,7,8],inf),
						\octave, 5,
					) <> post,
				]);
			}).loop,
			Pbind(
				\instrument, \strings,
				\legato, 1,
				\amp, 0.1/2,
				\note, Pseq([
					Pseq([
						Pseq([ [ 12,0,4,7, ] ],2),
						Pseq([ [ 12,0,3,6, ] ],2),
					],2),
					Pseq([
						Pseq([ [ 11,-1,2,7, ] ],2),
						Pseq([ [ 12,0,3,7, ] ],2),
					],2),
				],inf),
				\dur, 1,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				].scramble,inf).coin.not,
				//\out, BusDef(\sendbus1, \audio),
				//\isRest, true,
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\masterfx2, \audio),
			\addAction, \addToTail,
			//\lpf, PmodEnv(Pseq([20000,1000],1), 8, \exp),
			\mix, PmodEnv(Pseq([0,1],1), 4),
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind(\out, BusDef(\masterfx, \audio)) <>
		Ppar([
			Pdef(\drums3),
		]),
		Pmono(\fx_hpf,
			\inbus, BusDef(\masterfx, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,1000],1), 8, \exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\out, BusDef(\masterfx2, \audio)) <>
		Ppar([
			Plazy({ arg ev;
				var post = Pbind(
					\instrument, \pluck,
					//\lag, 0.04,
					\note, Pseq([
						Prand([
							Prand([0,12,-5,7],3),
							Prand([
								7,4,5,6,3,2,
							],1),
						],1),
					],inf).stutter(2),
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0, 
					],inf).coin.not,
					\dur, 1/8/2,
					\octave, 7,
					//\lag, -0.04,
					//\out, BusDef(\sendbus3, \audio),
					\amp, 0.1/10,
				);
			
				Ptpar([
					0, Pbind(
						\instrument, \pluck,
					) <> post,
					12, Pbind(
						\instrument, \basicbass,
						\note, Pkey(\note) + Pseq([0,-7,5],inf),
						\note, Pseq([0,-5,7],inf),
						\lpf, 7000,
						\amp, 0.1/15,
						\notRest, Pseq([
							0,0,0,0,
							0,0,0,0,
							Pseq([
								1,0,0,0,
								1,0,0,0,
								Prand([
									Pseq([
										1,0,0,0,
									],1),
									Pseq([
										1,0,0,1,
									],1),
								],1),
							],inf),
						],inf).coin,
						\isRest, Pfunc({ arg ev;
							ev[\isRest].not or: ev[\notRest]
						}).not,
						\octave, Prand([6,7,8],inf),
						\octave, 5,
					) <> post,
				]);
			}).loop,
			Pbind(
				\instrument, \strings,
				\legato, 1,
				\amp, 0.1/2,
				\note, Pseq([
					Pseq([
						Pseq([ [ 12,0,4,7, ] ],2),
						Pseq([ [ 12,0,3,6, ] ],2),
					],2),
					Pseq([
						Pseq([ [ 11,-1,2,7, ] ],2),
						Pseq([ [ 12,0,3,7, ] ],2),
					],2),
				],inf),
				\dur, 1,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				].scramble,inf).coin.not,
				//\out, BusDef(\sendbus1, \audio),
				//\isRest, true,
			),
		]),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\masterfx2, \audio),
			\addAction, \addToTail,
			//\lpf, PmodEnv(Pseq([20000,1000],1), 8, \exp),
			\mix, PmodEnv(Pseq([0,1],1), 4),
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
		).loop,

		Pbind(\out, BusDef(\masterfx, \audio)) <>
		Ppar([
			Pdef(\drums3),
		]),
		Pmono(\fx_hpf,
			\inbus, BusDef(\masterfx, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,1000],1), 8, \exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
SynthDef(\fxcrossdist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = CrossoverDistortion.ar(sig, \thres.kr(1), \smooth.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums3),

		Pbind(\out, BusDef(\group1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,
				],inf),
				\envamt, 1,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.15,0.1,3.01) ],
				],inf),
				\envamt, Pseg(Pseq([1,7],inf),8),
				//\envamt, 4,
				\lpf, 500,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\octave, 6,
				\legato, 0.3,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					Pstep(Pseq([0,3,4,6,7,11],inf),2),
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.15,0.1,3.01) ],
				],inf),
				\envamt, Pseg(Pseq([1,7],inf),8),
				//\envamt, 4,
				\lpf, 500,
				\rq, 0.7,
				\octave, Pseq([
					Pseq([
						3
					],7),4
			
				],inf),
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,1,
					1,0,0,1, 0,0,1,0,
					0,1,0,0, 1,0,0,1,
					//0,1,0,0, 1,0,1,1,
					//1,0,1,1, 0,1,0,1,
					//0,1,0,1, 1,0,1,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\legato, 1.2,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \superpw,
				\lpadsr, [ Env([ 0.0, 1.0, 4.0 ], [ 1.6000000238419, 1.40000000596046 ], [ 4.0, 4.0 ]) ],
				\lpenvamt, Pseg(Pseq([1,27],inf),8),
				\lpf, 400.0,
				\rq, 0.7,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],inf),
				\spread, 0.80000001192093,
				\octave, 4,
				\note, Pseq([
					[7,12,0],
					[7,4,0],
					[7,12,0],
					[7,3,0],
				],inf),
			
				\dur, 1,
				\amp, 0.1/6,
			),
			Pbind(
				\instrument, \superpw,
				\note, Pseq([
					0,7,
				],inf),
				\dur, 1/8,
				\amp, 0.1/2,
			),
		]),
		Pmono(\fxdist,
			\inbus, BusDef(\group1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\smooth, 0.9,
			\distamp, 20,
			\thres, 0.3,
			\mix, Pseq([
				0,0,0,1,
			],1),
			\dur, 1/2,
		).loop,
		//Pmono(\fxcrossdist,
			//\inbus, BusDef(\group1, \audio),
			//\addAction, \addToTail,
			//\lag, 0.0009,
			//\smooth, 0.9,
			//\thres, 0.3,
			//\mix, Pseq([
				//0,1,
			//],inf),
			//\dur, 1,
		//),
		
	])
)).play;
);

(
SynthDef(\fxdist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = ( sig*\distamp.kr(40) * XLine.kr(0.1,1,1/~t) ).tanh * \distpostamp.kr(1/4);
	sig = HPF.ar(sig, XLine.kr(100,1000,1/~t).poll);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
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
			\note, Pseq([
				0,Pwhite(0,12,1),
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, Pwhite(0.1,1,inf),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_softclip,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\level, 0.5,
			\distamp, 2,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

///////////// transi fx


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\flute, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					Pser([
						7,4,
					],8*2),
					Pser([
						6,6,3,3
					],8*2),
				],8*4),
			],inf),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],4),


				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\flute, \audio),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			//\out, BusDef(\flute, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\flute, \audio),
			\addAction, \addToTail,
			\room, 3,
			\mix, PmodEnv(Pseq([1,1,0,0,0,],1), Pseq([8,0.1,8,8],1)).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\flute2, \audio),
		),
		Pmono(\fx_lpf,
			\inbus, BusDef(\flute2, \audio),
			\addAction, \addToTail,
			\gain, 1/2,
			\lpf, PmodEnv(Pseq([1,Pn(2e4,4)],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\lfo_sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=2;
	var sig;
	sig = SinOsc.ar(freq) * \range.kr(1) + \base.kr(1);
	EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig.poll);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lpf, BusDef(\lpfa, \audio,1).asMap,
			//\rq, 0.1,
			\mix, 1,
			\lag, 0.00091,
			\dur, 1,
		),

		Pmono(\lfo_sin,
			\freq, 4,
			\dur, 1,
			\amp, 0.1,
			\base, 7000,
			\range, 6500,
			\out, BusDef(\lpfa, \audio,1),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),

		
	])
)).play;
);
(
SynthDef(\fx_echodiff, { arg out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = LocalIn.ar(2) * \fb.kr(0.4);
	//sig = sig + in;
	sig = in;
	sig = CombC.ar(sig, \maxdelay.kr(1), \delay.kr(1) * [1,\diffmul.kr(1)] + [0,\diffadd.kr(0)],\decay.kr(1));
	sig1 = sig;
	sig1 = LPF.ar(sig1, \lpf.kr(19000));
	sig1 = HPF.ar(sig1, \hpf.kr(50));
	sig = SelectX.ar(\pfmix.kr(0.5), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\ifx2, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/4/~t,
			\diffadd, 1/8 + 0.01 /~t,
			\decay, 4/~t,
			\hpf, 3000,
			\mix, 1,
			\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1,
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\fx_freqshiftfb,
			\inbus, BusDef(\ifx3, \audio),
			\shift, 10,
			\delay, 1/4/~t,
			\fb, 0.8,
			\mix, 1,
			\addAction, \addToTail,
			\lag, 0.00091,
			\gain, PmodEnv(Pseq([0,0.8],1), 8).loop,
			\dur, 1,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
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
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\ifx2, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/4/~t,
			\diffadd, 1/8 + 0.01 /~t,
			\decay, 4/~t,
			\hpf, PmodEnv(Pseq([1,1e4],1), 8,\exp).loop,
			\pfmix, 1,
			\mix, 1,
			\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1,
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\fx_freqshiftfb,
			\inbus, BusDef(\ifx3, \audio),
			\shift, 10,
			\delay, 1/4/~t,
			\fb, 0.8,
			\mix, 1,
			\addAction, \addToTail,
			\lag, 0.00091,
			\gain, PmodEnv(Pseq([0.01,1.8],1), 8,\exp).loop,
			\dur, 1,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),

		
	])
)).play;
);

(
SynthDef(\lfoa_usaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=2;
	var sig;
	sig = LFSaw.ar(freq).unipolar * \range.kr(1) + \base.kr(1);
	EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig.poll);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, PmodEnv(Pseq([0,0,1],1), 8).loop,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\ifx1, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, PmodEnv(Pseq([0,1,0.5],1), 8).loop,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/4/~t,
			\diffadd, 1/8 + 0.01 /~t,
			\decay, 4/~t,
			\hpf, BusDef(\lfoa_saw1, \audio,1).asMap,
			\pfmix, 1,
			\mix, 1,
			\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1,
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\lfoa_usaw,
			\freq, 2*~t,
			\base, 1000,
			\range, PmodEnv(Pseq([0,2000],1), 8).loop,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\lfoa_saw1, \audio,1),
		),
		Pmono(\lfoa_usaw,
			\freq, 2*~t,
			\base, PmodEnv(Pseq([0,1],1), 8).loop,
			\range, PmodEnv(Pseq([1,0],1), 8).loop,
			\out, BusDef(\lfoa_saw2, \audio,1),
		),
		Pmono(\fx_freqshiftfb,
			\inbus, BusDef(\ifx3, \audio),
			\shift, 10,
			\delay, 1/4/~t,
			\fb, PmodEnv(Pseq([0.8,0.4,0.2],1), 8).loop,
			\mix, PmodEnv(Pseq([1,0.41,0],1), 8).loop,
			\addAction, \addToTail,
			\lag, 0.00091,
			//\gain, PmodEnv(Pseq([0.01,1.8],1), 1,\exp).loop,
			\gain, BusDef(\lfoa_saw2, \audio, 1).asMap,
			\dur, 1,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
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
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf).stutter(2),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 6,
			\envamt, Pseg(Pseq([2,1,0,4],inf),8),
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,0,1,0,1,1,0,1,0,1,
			],inf).coin.not,
			\legato, 1,
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\track1b, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, PmodEnv(Pseq([0,0,1],1), 8).loop,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\ifx1, \audio, 2),
			\dur, 1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1b),
			\pregain, 1,
			\postgain, PmodEnv(Pseq([0,0.31,0,0.4,0.4],1), 4).loop,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,0.2],1), 8).loop,
			\sendbus0, BusDef(\ifx1, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, PmodEnv(Pseq([0,1,0.5],1), 8).loop,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/4/~t,
			\diffadd, 1/8 + 0.01 /~t,
			\decay, 4/~t,
			\hpf, BusDef(\lfoa_saw1, \audio,1).asMap,
			\pfmix, 1,
			\mix, 1,
			\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1,
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\lfoa_usaw,
			\freq, 2*~t,
			\base, 1000,
			\range, PmodEnv(Pseq([0,2000],1), 8).loop,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\lfoa_saw1, \audio,1),
		),
		Pmono(\lfoa_usaw,
			\freq, 2*~t,
			\base, PmodEnv(Pseq([0,1],1), 8).loop,
			\range, PmodEnv(Pseq([1,0],1), 8).loop,
			\out, BusDef(\lfoa_saw2, \audio,1),
		),
		Pmono(\fx_freqshiftfb,
			\inbus, BusDef(\ifx3, \audio),
			\shift, 10,
			\delay, 1/4/~t,
			\fb, PmodEnv(Pseq([0.8,0.4,0.2],1), 8).loop,
			\mix, PmodEnv(Pseq([1,0.41,0],1), 8).loop,
			\addAction, \addToTail,
			\lag, 0.00091,
			//\gain, PmodEnv(Pseq([0.01,1.8],1), 1,\exp).loop,
			\gain, BusDef(\lfoa_saw2, \audio, 1).asMap,
			\dur, 1,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
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
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					Pser([
						7,4,
					],8*2),
					Pser([
						6,6,3,3
					],8*2),
				],8*4),
			],inf),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],4),


				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\flute, \audio),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\flute, \audio),
		),

		// fx
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\flute0, \audio, 2),
			\dur, 1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\flute),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 2,
			\sendbus0, BusDef(\flute0, \audio, 2),
			\dur, 1,
		),

		Pmono(\fx_echodiff,
			\inbus, BusDef(\flute0, \audio),
			\delay, 1/8/~t,
			\decay, 2/~t,
			\diffadd, 0.14,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\flute1b, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 0.10000000149012,
			\fb, 0.80000000149012,
			\maxdelay, 0.019999999552965,
			\lfomul, 0.0099999997764826,
			\delay, 0.0049999998882413,
			\mix, 0.1,
			\gain, 1.0,
			\inbus, BusDef(\flute1b, \audio),
			\out, BusDef(\flute1c, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\inbus, BusDef(\flute1c,\audio),
			\instrument, \fx_env,
			\dur, 1/1 * 
			Pseq([
				PdurStutter(Pseq([1,4,2,8],1), 1/2),
				PdurStutter(Pseq([1,4,1,2],1), 1/4),
				PdurStutter(Pseq([1,4,1,8],1), 1),
			],inf),
			\amp, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\gain, 1,
			\out, BusDef(\flute2, \audio),
		),
		//Pmono(\fx_freeverb2,
			//\inbus, BusDef(\flute, \audio),
			//\addAction, \addToTail,
			//\room, 3,
			//\mix, PmodEnv(Pseq([1,1,0,0,0,],1), Pseq([8,0.1,8,8],1)).loop,
			//\lag, 0.0009,
			//\dur, 1,
			//\out, BusDef(\flute2, \audio),
		//),
		Pmono(\fx_lpf,
			\inbus, BusDef(\flute2, \audio),
			\addAction, \addToTail,
			//\lpf, PmodEnv(Pseq([1,Pn(2e4,4)],1), 8).loop,
			\lpf, 14000,
			\gain, 1/2,

			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
// add pmodsynth lfo
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					Pser([
						7,4,
					],8*2),
					Pser([
						6,6,3,3
					],8*2),
				],8*4),
			],inf),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],4),


				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\flute, \audio),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\flute, \audio),
		),

		// fx
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\flute0, \audio, 2),
			\dur, 1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\flute),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 2,
			\sendbus0, BusDef(\flute0, \audio, 2),
			\dur, 1,
		),

		Pmono(\fx_echodiff,
			\inbus, BusDef(\flute0, \audio),
			\delay, 1/8/~t,
			\decay, 2/~t,
			\diffadd, 0.14,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\flute1b, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 0.10000000149012,
			\fb, 0.80000000149012,
			\maxdelay, 0.019999999552965,
			\lfomul, 0.0099999997764826,
			\delay, 0.0049999998882413,
			\mix, 0.1,
			\gain, 1.0,
			\inbus, BusDef(\flute1b, \audio),
			\out, BusDef(\flute1c, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\inbus, BusDef(\flute1c,\audio),
			\instrument, \fx_env,
			\dur, 1/1 * 
			Pseq([
				PdurStutter(Pseq([1,4,2,8],1), 1/2),
				PdurStutter(Pseq([1,4,1,2],1), 1/4),
				PdurStutter(Pseq([1,4,1,8],1), 1),
			],inf),
			\amp, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\gain, 1,
			\out, BusDef(\flute2, \audio),
		),
		//Pmono(\fx_freeverb2,
			//\inbus, BusDef(\flute, \audio),
			//\addAction, \addToTail,
			//\room, 3,
			//\mix, PmodEnv(Pseq([1,1,0,0,0,],1), Pseq([8,0.1,8,8],1)).loop,
			//\lag, 0.0009,
			//\dur, 1,
			//\out, BusDef(\flute2, \audio),
		//),
		Pmono(\fx_lpf,
			\inbus, BusDef(\flute2, \audio),
			\addAction, \addToTail,
			//\lpf, PmodEnv(Pseq([1,Pn(2e4,4)],1), 8).loop,
			\lpf, ~pmodsynth.({ SinOsc.kr(8*~t).exprange(100,500 * XLine.kr(1,30,8/~t)) }),
			\gain, 1/2,

			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);



(
SynthDef(\fx_extract, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(300);
	//sig = sig + DelayL.ar(sig, 0.2,0.0001 * ( SinOsc.kr(1/4) * 0.01 + 1 ));
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/4);
	sig = RLPF.ar(sig, ( \lpf.kr(9000.1) ).clip(20,20000), \lrq.kr(0.4));
	sig = RHPF.ar(sig, ( \hpf.kr(500.1) ).clip(20,20000), \hrq.kr(0.4));
	//sig = sig * 1.2;
	//sig = AllpassL.ar(sig, 4/~t, 0.01,4/~t) + sig;
	sig = sig * 1.4;
	sig = FreeVerb2.ar(sig.first, sig.last, mix:\verbmix.kr(0.5), room:\room.kr(1.5), damp:\damp.kr(0.5));
	sig = sig / 8;
	//sig = LPF.ar(sig, \postlpf.kr(8000));
	sig = HPF.ar(sig, \posthpf.kr(800));
	sig = SelectX.ar(\mix.kr(0.9), [in, sig]);
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
			\instrument, \sdkick,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
			\out, BusDef(\track1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					Pser([
						7,4,
					],8*2),
					Pser([
						6,6,3,3
					],8*2),
				],8*4),
			],inf),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,1,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				],4),


				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\flute, \audio),
		),
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				Pser([
					9,10,11,
				],8*4),
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\flute, \audio),
		),

		// fx
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\flute0, \audio, 2),
			\dur, 1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\flute),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 2,
			\sendbus0, BusDef(\flute0, \audio, 2),
			\dur, 1,
		),

		Pmono(\fx_echodiff,
			\inbus, BusDef(\flute0, \audio),
			\delay, 1/8/~t,
			\decay, 2/~t,
			\diffadd, 0.14,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\flute1b, \audio),
		),
		Pmono(\fx_flanger,
			\flangefreq, 0.10000000149012,
			\fb, 0.80000000149012,
			\maxdelay, 0.019999999552965,
			\lfomul, 0.0099999997764826,
			\delay, 0.0049999998882413,
			\mix, 0.1,
			\gain, 1.0,
			\inbus, BusDef(\flute1b, \audio),
			\out, BusDef(\flute1c, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\flute1c,\audio),
			\dur, 1/1 * 
			Pseq([
				PdurStutter(Pseq([1,4,2,8],1), 1/2),
				PdurStutter(Pseq([1,4,1,3],1), 1/4),
				PdurStutter(Pseq([1,4,1,8],1), 1),
			],inf),
			\amp, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\gain, 1,
			\out, BusDef(\flute2, \audio),
		),
		//Pmono(\fx_freeverb2,
			//\inbus, BusDef(\flute, \audio),
			//\addAction, \addToTail,
			//\room, 3,
			//\mix, PmodEnv(Pseq([1,1,0,0,0,],1), Pseq([8,0.1,8,8],1)).loop,
			//\lag, 0.0009,
			//\dur, 1,
			//\out, BusDef(\flute2, \audio),
		//),
		Pmono(\fx_lpf,
			\inbus, BusDef(\flute2, \audio),
			\addAction, \addToTail,
			//\lpf, PmodEnv(Pseq([1,Pn(2e4,4)],1), 8).loop,
			\lpf, 14000,

			\lag, 0.0009,
			\dur, 1,
			\gain, 1/2,
			\out, BusDef(\fxtrack1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\fxtrack1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\ext, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_extract,
			\distamp, 150.0,
			\distpostamp, 0.25,
			\lpf, 15000.099609375,
			\lrq, 0.40000000596046,
			\hpf, 95.10000610352,
			\hrq, 0.40000000596046,
			\verbmix, 1,
			\room, 1.5,
			\damp, 0.5,
			\posthpf, 80.0,
			\mix, 0.89999997615814,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\gain, 4.0,
			\inbus, BusDef(\ext, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\ext2, \audio),
		),
		Pmono(\fx_flanger,
			\inbus, BusDef(\ext2,\audio),
			\flangefreq, 1/2*~t,
			\fb, 0.80000000149012,
			\maxdelay, 0.119999999552965,
			\lfomul, 0.0099999997764826,
			\delay, 0.1049999998882413,
			\mix, 0.5,
			\gain, 1.0/2,
			\inbus, BusDef(\flute1b, \audio),
			\out, BusDef(\flute1c, \audio),
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
			\instrument, \sdkick,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,1,0, 1,0,1,1,
				Pseq([
					1,0,1,0, 1,0,1,0,
				],3),
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \sdsnare,
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0, 
				],3),
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1580].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
			\out, BusDef(\hattrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[239].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, 2,
			\gain, 0.11/2,
			\out, BusDef(\hattrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[58].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				1,0,1,0, 0,1,1,1,

			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1.7,
				1,1,1.7,1.7, 1.7,1,1,1.7,
			],inf),
			\gain, 0.11/1.2 * Pseq([
				1,1,3,1, 1,1,3,1,
			],inf)/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1898].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,1,0,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
			\out, BusDef(\hattrack, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\track1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\track1),
			\pregain, 1,
			\postgain, PmodEnv(Pseq([0,0,1],1), 8).loop,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\ifx1, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, PmodEnv(Pseq([0,1,0.5],1), 8).loop,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\ifx2, \audio),
			\delay, 1/4/~t,
			\diffadd, 1/8 + 0.01 /~t,
			\decay, 4/~t,
			\hpf, BusDef(\lfoa_saw1, \audio,1).asMap,
			\pfmix, 1,
			\mix, 1,
			\addAction, \addToTail,
			\lag, 0.00091,
			\dur, 1,
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\lfoa_usaw,
			\freq, 2*~t,
			\base, 1000,
			\range, PmodEnv(Pseq([0,2000],1), 8).loop,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\lfoa_saw1, \audio,1),
		),
		Pmono(\lfoa_usaw,
			\freq, 2*~t,
			\base, PmodEnv(Pseq([0,1],1), 8).loop,
			\range, PmodEnv(Pseq([1,0],1), 8).loop,
			\out, BusDef(\lfoa_saw2, \audio,1),
		),
		Pmono(\fx_freqshiftfb,
			\inbus, BusDef(\ifx3, \audio),
			\shift, 10,
			\delay, 1/4/~t,
			\fb, PmodEnv(Pseq([0.8,0.4,0.2],1), 8).loop,
			\mix, PmodEnv(Pseq([1,0.41,0],1), 8).loop,
			\addAction, \addToTail,
			\lag, 0.00091,
			//\gain, PmodEnv(Pseq([0.01,1.8],1), 1,\exp).loop,
			\gain, BusDef(\lfoa_saw2, \audio, 1).asMap,
			\dur, 1,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hattrack),
			\pregain, 1,
			\postgain, PmodEnv(Pseq([0.01,1,1],1), 8,\exp).loop,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\hattrack1, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\hattrack1, \audio),
			\addAction, \addToTail,
			\delay, 1/8/2/~t,
			\diffmul, 0,
			\diffadd, 1/6/2/~t,
			\decay, 2/~t,
			\mix, 1,
			\pfmix, 1,
			\hpf, PmodEnv(Pseq([100,14000],1), 8,\exp).loop,
			\lpf, PmodEnv(Pseq([1000,14000],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),


		
	])
)).play;
);

(
// dnb
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.8,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.15]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.05]) ],
			],inf),
			\dur, 1/8/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,1,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,1,1,0, 1,1,1,1,
				0,1,1,0, 0,0,1,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\speed, Pseq([
				1,1.1,
			],inf),
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				0.9,0.7,
				1,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\bufnum, ~buflib.snare[1565].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\bufnum, ~buflib.snare[1565].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8/2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);
(
// dnb fast
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.8,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.15]) ],
			],inf),
			\dur, 1/8/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdkick,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, 0.2,
			\env0, Pseq([
				[ Env([0,1,0],[0.01,0.05]) ],
			],inf),
			\dur, 1/8/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[277].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,1,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,1,1,0, 1,1,1,1,
				0,1,1,0, 0,0,1,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8/4,
			\speed, Pseq([
				1,1.1,
			],inf),
			\legato, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				0.9,0.7,
				1,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\bufnum, ~buflib.snare[1565].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8/4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 1.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1566].value,
			\bufnum, ~buflib.snare[1565].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\dur, 1/8/4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\gain, 0.11/2,
		),
	])
)).play;
);
(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 100,
			\hpmix, 1,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8/2,
			\isRest, Pseq([
				1,1,1,0,1,0,0,1,
				1,0,0,1,0,0,1,0,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec_hlpf,
			\hpf, 100,
			\hpmix, 1,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8/2,
			\isRest, Pseq([
				1,0,1,0, 0,1,1,1,
				1,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\legato, 1,
			\gain, 1/8,
		),
		
	])
)).play;
);


/////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[135].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/2,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[125].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[100].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\out, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_ringz,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\freq, PmodEnv(Pseq([10,14000],5), 4,\exp).loop,
			\bwr, 1.01,
			\lag, 0.0009,
			\gain, 1/8,
			\dur, 1,
		),
		//Pmono(\fx_resonz,
			//\inbus, BusDef(\ifx2, \audio),
			//\addAction, \addToTail,
			//\freq, PmodEnv(Pseq([10,14000],5), 4,\exp).loop,
			//\bwr, 1.01,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([0,4],inf),8),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.2,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pstep(Pseq([0,3,4,6,7,11],inf),2),
			],inf),
			\envamt, Pseg(Pseq([0,4],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					[0,-3],-5
				],16*4),
				Pseq([
					Pser([
						[-1,-3],-5
					],16),
					Pser([
						[0,-3],-5
					],16),
				],2),
			],inf),
			\octave, 8,
			\lag, Pseq([
				0,
				Pwhite(0,0.051!2,1),
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	])
)).play;
);

(
SynthDef(\fx_resonz, { arg out=0, gate=1, freq=400;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Resonz.ar(sig, freq, \bwr.kr(1));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fx_ringz, { arg out=0, gate=1, freq=400;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Ringz.ar(sig, freq, \decay.kr(0.1));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);


///////////////

(
SynthDef(\fxshiftecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.71) ) + sig;
	
		isig = DelayL.ar(isig, \maxdelay.kr(0.5), \delay.kr(0.3));
		isig = FreqShift.ar(isig, \freqshift.kr(10));
		//isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums3),
		Pbind(
			\instrument, \brouilpad,
			\note, Pseq([
				Pseq([
					[ 0,7, ],
					[ 0,6, ]
				],2),
				Pseq([
					[ -1,7, ],
					[ 3,7, ]
				],2),
			],inf),
			\legato, 1,
			\lpf, PmodEnv(Pseq([100,7000],1), 8*2).loop,
			\hpf, PmodEnv(Pseq([10000,70],1), 8*2).loop,
			\adsr, Pseq([
				[ Env.adsr(0.2,0.1,0.8,0.2) ],
			],inf),
			\dur, 2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pseq([ 12,0,4,7, ],4),
					Pseq([ 12,0,3,6, ],4),
				],2),
				Pseq([
					Pseq([ 11,-1,2,7, ],4),
					Pseq([ 12,0,3,7, ],4),
				],2),
			],inf),
			//\ctranspose, Pstep(Pseq([0,4],inf),2),
			\octave, 5,
			\envamt, Pseg(Pseq([1,4,-1,0],inf),16/3),
			\dur, 1/8,
			\lpf, Pseg(Pseq([1000,100],inf),8*2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1 * Pseg(Pseq([0.8,1],inf),8*2),
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\fb, 1.09,
			\fb, 0.85,
			//\fb, 0.4,
			//\delay, Pwhite(0.1,1,inf)/~t,
			//\delay, PmodEnv(Pseq([1,0.02]/~t,1), 8*2).loop,
			\delay, 0.121,
			\delay, 1/6/~t,
			\maxdelay, 1/~t,
			//\freqshift, PmodEnv(Pseq([4001,440],1), 8*2).loop,
			\freqshift, -10,
			\freqshift, PmodEnv(Pseq([0.1,0.1,224],1), Pseq([7,1]),\exp).loop,
			//\freqshift, ~pmodsynth.({ LFPulse.kr(1*~t) * 50 }),
			\mix, 0.4,
			\mix, PmodEnv(Pseq([0,0.5],1), 8).loop,
			\dur, 1,
			\gain, 0.5,
		),
	])
)).play;
);
