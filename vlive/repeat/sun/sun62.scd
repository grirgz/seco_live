
(
~t = 166/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("capsule/draftsynth.scd");
)

(
SynthDef(\betri, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(100) * ( SinOsc.ar(\fmf2.kr(0.2)) * 1 + 1 )) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\basicpad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, ( \lpf.kr(8000) * env1 ).clip(1,20000));
	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\basedrums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\trackkick, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\trackkick, \audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\sidekick, \audio, 2),
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,1,0,0, 1,0,1,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,1,0,0,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8+7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0.5,0.5, 1,0,1,0,
				],8+7),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\basedrums1nosc, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,1,0,0, 1,0,1,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,1,0,0,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8+7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0.5,0.5, 1,0,1,0,
				],8+7),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

//////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,0, 1,0,1,0,
				1,0,0.5,0.5, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				0,1,
			],inf),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmf, ~pmodenv.(Pseq([50,200],1), 32).loop,
			\fmf2, ~pmodenv.(Pseq([5,0.1],1), 32).loop,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,14,
			],inf).stutter(32),
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
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
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,0, 1,0,1,0,
				1,0,0.5,0.5, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				0,1,
			],inf),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.11,0.1,0.8,0.01) ],
			],inf),
			\octave, 7,
			\fmf, Pkey(\freq)*4/3,
			\fmf2, ~pmodenv.(Pseq([0.1,4,100],1), 8*8).loop,
			\legato, 0.4,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
				0,0,1,0, 1,1,1,0,
				1,0,1,0, 0,0,0,1,

				0,0,0,0, 1,0,0,0,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,0,1,
			],inf).coin.not,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,
			],inf).stutter(32),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				//0,1,0,0, 1,0,0,1,
				//0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\fmf2, Pseq([
				Pseq([
					100,1000, 300,1000, 700,1000, 300,1000,
					400,1000, 300,1000, 700,1000, 300,1000,
					910,1000, 300,1000, 700,1000, 300,1000,
					100,1000, 300,1000, 700,1000, 300,1000,
				],1),
				Pseq([
					100,1000, 300,1000, 700,1000, 300,1000,
					400,1000, 300,1000, 700,1000, 300,1000,
					300,1000, 300,1000, 700,1000, 300,1000,
					100,1000, 300,1000, 700,1000, 300,1000,
				],1),
			],inf),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.41,0.1,0.8,0.4) ],
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.1,0.8,0.04) ],
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],4),

				Pseq([
					[ Env.adsr(0.10,0.1,0.8,1.8,1,4) ],
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.1,0.8,0.04) ],
					[ Env.adsr(0.01,0.1,0.8,0.4) ],
				],4),
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
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8+7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0.5,0.5, 1,0,1,0,
				],8+7),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				[0,7,0-12,3-12],
				[-1,7,-1-12,3-12],
			],inf),
			\octave, 6,
			\lpf, 1000,
			\at, Pseg(Pseq([0,1,0.2,5],inf),20),
			\rel, Pseg(Pseq([0.5,0,4],inf),30),
			\adsr, Pfunc({ arg ev;
				[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ]
			}),
			\lpenv, Pseq([
				[ Env([1,8,1/3],[2.1,0.8]) ]
			],inf),
			\legato, Pseg(Pseq([0.1,1],inf),32),
			\lpf, ~pmodenv.(Pseq([1,80,10,4]*100,1), 8).loop,
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \simpleacid,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1) * Pseq((1..32)/32,1)+1, 1/2).loop,
			\rq, 0.1,
			//\freq, ~pmodenv.(Pseq([1,2,1,4]*40,1), 1).loop,
			\env1, [Env([1,7,1],[0.05,0.8])],
			\note, Pseq([
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0+12,3,0,3,0-12,3,4,5,
			],inf),
			\octave, 2,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.2,0.4) ],
			],inf),
			\legato, Pseq([
				1,0,0.71,0.1, 1,0,0.71,0,
				1,0,1,0, 1,1,0,1,
				1,0,0,0, 1,0,0,0,
				3,0,0,2, 0,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,0,1/2],inf),2),
			\pos, Pseq([
				0.4,0.41,
				0.4,0.31,
			],inf).stutter(8) + Pseg(Pseq([0,0.1],inf),10),
			\speed, Pstep(Pseq([
				0,
			],inf).midiratio,4),
			\speed, ~pmodenv.(Pseq([1,2,1,4]/100,1)+1, 8).loop,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,0.01) ],
				[ Env.adsr(1.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],
				//[ Env.adsr(1.01,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,0.31) ],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0.2,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.1,1,1)
			],inf).stutter(8),
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,14,
			],inf).stutter(32),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0.41,0,0.41,
				0,0.4,0.4,0, 0,0,0,0,
			],inf).coin.not,
			\octave,7,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,7,
			],inf).stutter(32),
			\isRest, Pseq([
				Pser([
					1,0,
				],8*8*2+6),
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\octave,6,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2 * Pseg(Pseq([1,0.1,1],inf),32),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,1,0,0, 1,0,1,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,1,0,0,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8+7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0.5,0.5, 1,0,1,0,
				],8+7),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				[0,7,0-12,3-12],
				[-1,7,-1-12,3-12],
			],inf),
			\octave, 6,
			\lpf, 1000,
			\at, Pseg(Pseq([0,1,0.2,5],inf),20),
			\rel, Pseg(Pseq([0.5,0,4],inf),30),
			\adsr, Pfunc({ arg ev;
				[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ]
			}),
			\lpenv, Pseq([
				[ Env([1,8,1/3],[2.1,0.8]) ]
			],inf),
			\legato, Pseg(Pseq([0.1,1],inf),32),
			\lpf, ~pmodenv.(Pseq([1,80,10,4]*100,1), 8).loop,
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				Prand([0,7,0-12,3-12]),
				Prand([-1,7,-1-12,3-12]),
			],inf),
			\octave, 7,
			\lpf, 1000,
			\at, Pseg(Pseq([1,0,1,0.2,5],inf),20),
			\rel, Pseg(Pseq([0.5,0,4],inf),30),
			\adsr, Pfunc({ arg ev;
				[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ]
			}),
			\lpenv, Pseq([
				[ Env([1,8,1/3],[2.1,0.8]) ]
			],inf),
			\legato, Pseg(Pseq([0.5,0.1,1],inf),32),
			\lpf, ~pmodenv.(Pseq([1,80,10,4]*100,1), 8).loop,
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \simpleacid,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1) * Pseq((1..32)/32,1)+1, 1/2).loop,
			\rq, 0.1,
			//\freq, ~pmodenv.(Pseq([1,2,1,4]*40,1), 1).loop,
			\env1, [Env([1,7,1],[0.05,0.8])],
			\note, Pseq([
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0+12,3,0,3,0-12,3,4,5,
			],inf),
			\octave, 2,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.2,0.4) ],
			],inf),
			\legato, Pseq([
				1,0,0.71,0.1, 1,0,0.71,0,
				1,0,1,0, 1,1,0,1,
				1,0,0,0, 1,0,0,0,
				3,0,0,2, 0,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,0,1/2],inf),2),
			\pos, Pseq([
				0.4,0.41,
				0.4,0.31,
			],inf).stutter(8) + Pseg(Pseq([0,0.1],inf),10),
			\speed, Pstep(Pseq([
				0,
			],inf).midiratio,4),
			\speed, ~pmodenv.(Pseq([1,2,1,4]/100,1)+1, 8).loop,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,0.01) ],
				[ Env.adsr(1.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],
				//[ Env.adsr(1.01,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,0.31) ],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0.2,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.1,1,1)
			],inf).stutter(8),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('voices/feynman.flac'),
			\pos, Pseq([
				0.4,1.1
			],inf).stutter(1) + Pseg(Pseq([0,0.1],inf),32),
			\speed, Pstep(Pseq([
				0,
			],inf).midiratio,4),
			\speed, ~pmodenv.(Pseq([0.01,2,1,4]/10,1)+1, 32).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],
				//[ Env.adsr(1.01,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,0.31) ],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0.81,1,0.81,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.01,0.41,1),
				Pwhite(0.4,1,1),Pwhite(0.01,0.41,1),
			],inf).stutter(1),
			//\gain, 1/8,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,14,
			],inf).stutter(32),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0.41,0,0.41,
				0,0.4,0.4,0, 0,0,0,0,
			],inf).coin.not,
			\octave,7,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,7,
			],inf).stutter(32),
			\isRest, Pseq([
				Pser([
					1,0,
				],8*8*2+6),
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\octave,6,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2 * Pseg(Pseq([1,0.1,1],inf),32),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('voices/kaspi.flac'),
			\pos, 3.4,
			\speed, 1.1,
			\legato, 4,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 1/8/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_stutter,
			\time, 1/Prand([2,4,8,16],inf).stutter(16)/~t,
			\rate, 1.0,
			\maxdelay, 10.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, Pseq([
				Prand([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 1,0,0,0,
					],1),
				],1),
			],inf),
			\lag, 0.0009,
			\dur, 1/8,
			\gain, 1.0,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,1,0,0, 1,0,1,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,1,0,0,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8+7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0.5,0.5, 1,0,1,0,
				],8+7),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				[0,7,0-12,3-12],
				[-1,7,-1-12,3-12],
			],inf),
			\octave, 6,
			\lpf, 1000,
			\at, Pseg(Pseq([0,1,0.2,5],inf),20),
			\rel, Pseg(Pseq([0.5,0,4],inf),30),
			\adsr, Pfunc({ arg ev;
				[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ]
			}),
			\lpenv, Pseq([
				[ Env([1,8,1/3],[2.1,0.8]) ]
			],inf),
			\legato, Pseg(Pseq([0.1,1],inf),32),
			\lpf, ~pmodenv.(Pseq([1,80,10,4]*100,1), 8).loop,
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				Prand([0,7,0-12,3-12]),
				Prand([-1,7,-1-12,3-12]),
			],inf),
			\octave, 7,
			\lpf, 1000,
			\at, Pseg(Pseq([1,0,1,0.2,5],inf),20),
			\rel, Pseg(Pseq([0.5,0,4],inf),30),
			\adsr, Pfunc({ arg ev;
				[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ]
			}),
			\lpenv, Pseq([
				[ Env([1,8,1/3],[2.1,0.8]) ]
			],inf),
			\legato, Pseg(Pseq([0.5,0.1,1],inf),32),
			\lpf, ~pmodenv.(Pseq([1,80,10,4]*100,1), 8).loop,
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \simpleacid,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1) * Pseq((1..32)/32,1)+1, 1/2).loop,
			\rq, 0.1,
			//\freq, ~pmodenv.(Pseq([1,2,1,4]*40,1), 1).loop,
			\env1, [Env([1,7,1],[0.05,0.8])],
			\note, Pseq([
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0+12,3,0,3,0-12,3,4,5,
			],inf),
			\octave, 2,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.2,0.4) ],
			],inf),
			\legato, Pseq([
				1,0,0.71,0.1, 1,0,0.71,0,
				1,0,1,0, 1,1,0,1,
				1,0,0,0, 1,0,0,0,
				3,0,0,2, 0,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,0,1/2],inf),2),
			\pos, Pseq([
				0.4,0.41,
				0.4,0.31,
			],inf).stutter(8) + Pseg(Pseq([0,0.1],inf),10),
			\speed, Pstep(Pseq([
				0,
			],inf).midiratio,4),
			\speed, ~pmodenv.(Pseq([1,2,1,4]/100,1)+1, 8).loop,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,0.01) ],
				[ Env.adsr(1.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],
				//[ Env.adsr(1.01,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,0.31) ],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0.2,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.1,1,1)
			],inf).stutter(8),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0.4,1.1
			],inf).stutter(1) + Pseg(Pseq([0,0.1],inf),32),
			\speed, Pstep(Pseq([
				0,
			],inf).midiratio,4),
			\speed, ~pmodenv.(Pseq([0.01,2,1,4]/10,1)+1, 32).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],
				//[ Env.adsr(1.01,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,0.31) ],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0.81,1,0.81,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.01,0.41,1),
				Pwhite(0.4,1,1),Pwhite(0.01,0.41,1),
			],inf).stutter(1),
			//\gain, 1/8,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,14,
			],inf).stutter(32),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0.41,0,0.41,
				0,0.4,0.4,0, 0,0,0,0,
			],inf).coin.not,
			\octave,7,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,7,
			],inf).stutter(32),
			\isRest, Pseq([
				Pser([
					1,0,
				],8*8*2+6),
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\octave,6,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2 * Pseg(Pseq([1,0.1,1],inf),32),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 3.4,
			\speed, 1.1,
			\legato, 4,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 1/8/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_stutter,
			\time, 1/Prand([2,4,8,16],inf).stutter(16)/~t,
			\rate, 1.0,
			\maxdelay, 10.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, Pseq([
				Prand([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 1,0,0,0,
					],1),
				],1),
			],inf),
			\lag, 0.0009,
			\dur, 1/8,
			\gain, 1.0,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,1,0,-1,
			],inf).stutter(16),
			\octave, 3,
			\lpf, ~pmodenv.(Pseg(Pseq([1,4,1/2,2]*100,1),10) + Pseg(Pseq([0,10,3,8]*100,inf),1/2), 1/8).loop,
			\legato, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				3,0,0,0, 3,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				2,0,0,1, 2,0,0,0,

				2,0,0,0, 4,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				2,0,0,1, 2,0,0,0,

				2,0,0,0, 4,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				2,0,1,1, 2,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1357].value,
			\bufnum, ~buflib.kick[65].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 0,0,1,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1839].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,0,0,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,1,0,0, 1,0,1,1,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 1,1,0,0,
				Pseq([ 0,0,0,0, 1,0,0,0, ],7),
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1728].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],8+7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,1,1,0, 1,0,1,0,
					1,0,0.5,0.5, 1,0,1,0,
				],8+7),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				[0,7,0-12,3-12],
				[-1,7,-1-12,3-12],
			],inf).stutter(4),
			\octave, 6,
			\lpf, 1000,
			\at, Pseg(Pseq([0,1,0.2,5],inf),20),
			\rel, Pseg(Pseq([0.5,0,4],inf),30),
			\adsr, Pfunc({ arg ev;
				[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ]
			}),
			\lpenv, Pseq([
				[ Env([1,8,1/3],[2.1,0.8]) ]
			],inf),
			\legato, Pseg(Pseq([0.1,1],inf),32),
			\lpf, ~pmodenv.(Pseq([1,80,10,4]*100,1), 8).loop,
			\dur, 2,
			\amp, 0.1/4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				Prand([0,7,0-12,3-12]),
				Prand([-1,7,-1-12,3-12]),
			],inf).stutter(4),
			\octave, 7,
			\lpf, 1000,
			\at, Pseg(Pseq([1,0,1,0.2,5],inf),20),
			\rel, Pseg(Pseq([0.5,0,4],inf),30),
			\adsr, Pfunc({ arg ev;
				[ Env.adsr(ev[\at],0.1,0.8,ev[\rel]) ]
			}),
			\lpenv, Pseq([
				[ Env([1,8,1/3],[2.1,0.8]) ]
			],inf),
			\legato, Pseg(Pseq([0.5,0.1,1],inf),32),
			\lpf, ~pmodenv.(Pseq([1,80,10,4]*100,1), 8).loop,
			\dur, 2,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \simpleacid,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1) * Pseq((1..32)/32,1)+1, 1/2).loop,
			\rq, 0.1,
			//\freq, ~pmodenv.(Pseq([1,2,1,4]*40,1), 1).loop,
			\env1, [Env([1,7,1],[0.05,0.8])],
			\note, Pseq([
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0,3,0,3,0,3,4,5,
				0+12,3,0,3,0-12,3,4,5,
			],inf),
			\octave, 2,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,0.2,0.4) ],
			],inf),
			\legato, Pseq([
				1,0,0.71,0.1, 1,0,0.71,0,
				1,0,1,0, 1,1,0,1,
				1,0,0,0, 1,0,0,0,
				3,0,0,2, 0,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseg(Pseq([0,0,1/2],inf),2),
			\pos, Pseq([
				0.4,0.41,
				0.4,0.31,
			],inf).stutter(8) + Pseg(Pseq([0,0.1],inf),10),
			\speed, Pstep(Pseq([
				0,
			],inf).midiratio,4),
			\speed, ~pmodenv.(Pseq([1,2,1,4]/100,1)+1, 8).loop,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.31,0.1,0.8,0.01) ],
				[ Env.adsr(1.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],
				//[ Env.adsr(1.01,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,0.31) ],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,1,0.2,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.1,1,1)
			],inf).stutter(8),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0.4,1.1
			],inf).stutter(1) + Pseg(Pseq([0,0.1],inf),32),
			\speed, Pstep(Pseq([
				0,
			],inf).midiratio,4),
			\speed, ~pmodenv.(Pseq([0.01,2,1,4]/10,1)+1, 32).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],
				//[ Env.adsr(1.01,0.1,0.8,0.01) ],
				//[ Env.adsr(1.01,0.1,0.8,0.31) ],
			],inf).stutter(8),
			\isRest, Pseq([
				1,0.81,1,0.81,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2 * Pseq([
				Pwhite(0.9,1,1),Pwhite(0.01,0.41,1),
				Pwhite(0.4,1,1),Pwhite(0.01,0.41,1),
			],inf).stutter(1),
			//\gain, 1/8,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,14,
			],inf).stutter(32),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0.41,0,0.41,
				0,0.4,0.4,0, 0,0,0,0,
			],inf).coin.not,
			\octave,7,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				7,7,
			],inf).stutter(32),
			\isRest, Pseq([
				Pser([
					1,0,
				],8*8*2+6),
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\octave,6,
			\fmf2, ~pmodenv.(Pseq([1,2,1,4]/10,1), 8).loop,
			\fmf, Pkey(\freq)*2 * Pseg(Pseq([1,0.1,1],inf),32),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
				[ Env.adsr(0.4,0.1,0.8,0.04) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 1.2 * Pseg(Pseq([0.8,1],inf),32),
			\speed, 0.9,
			\legato, 8,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 1/8/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 3.4,
			\speed, 1.1,
			\legato, 4,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 1/8/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_stutter,
			\time, 1/Prand([2,4,8,16],inf).stutter(16)/~t,
			\rate, 1.0,
			\maxdelay, 10.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, Pseq([
				Prand([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 1,1,1,1,
					],1),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,1,1, 1,0,0,0,
					],1),
				],1),
			],inf),
			\lag, 0.0009,
			\dur, 1/8,
			\gain, 1.0,
		),
	])
)).play;
);

////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basedrums1),

		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,-2,0,
				0,-12,-2,12,
			],inf),
			\octave, 3,
			//\lpf, ~pmodenv.(Pseg(Pseq([1,4,1/2,2]*100,1),10) + Pseg(Pseq([0,10,3,8]*100,inf),1/2), 1/8).loop,
			\lpf, ~pmodenv.(Pseq([1,4,1,14]*100,1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				1.4,0.2,1,0.2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\sidekick, \audio),
			\lag, 0.0004,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.001,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				\r,\r,\r,\r, \r,\r,\r,\r,
				0,\r,0,\r,0,\r,0,\r,
			],inf),
			\fmf, Pseg(Pseq([100,110]/2,1),1,-3).loop,
			\fmf2, Pseg(Pseq([10,0.1],inf),8*2),
			\legato, Pseg(Pseq([0.1,1],inf),8*4),
			\rel, Pseg(Pseq([0.3,0.01],inf),8*6),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Plazy({ arg ev;
					Pseg(Pseq([1,0],1),1,[0,1,-1,-2,-3].choose) * Pwhite(0.5,1.0,inf)
				}).loop,
			],inf),
		),
		Pbind(
			\instrument, \betri,
			\freq, ~pmodenv.(Pseq([1000,802],1), 8).loop,
			\fmf, Pkey(\freq)*1.01,
			\fmf2, Pkey(\freq)* Pseg(Pseq([1,1.1],inf),8),
			\octave, 4,
			\dur, 1/2,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.01,0.1,0.4,1,[-4,0,-4]) ],
			],inf),
			\lag, 1/16/~t,
			\amp, 0.1/4,
			\out, BusDef(\ifx2, \audio),
			\out, BusDef(\sendbus5, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\ifx2, \audio),
			\sideinbus, BusDef(\sidekick, \audio),
			\lag, 0.0004,
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.001,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.02,
			\gain, 1,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Pdef(\basedrums1nosc),

		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,-2,0,
				0,-12,-2,12,
			],inf),
			\octave, 3,
			//\lpf, ~pmodenv.(Pseg(Pseq([1,4,1/2,2]*100,1),10) + Pseg(Pseq([0,10,3,8]*100,inf),1/2), 1/8).loop,
			\lpf, ~pmodenv.(Pseq([1,4,1,14]*100,1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				1.4,0.2,1,0.2,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\ifx1, \audio),
			\sideinbus, BusDef(\sidekick, \audio),
			\lag, 0.0004,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.001,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \betri,
			\note, Pseq([
				\r,\r,\r,\r, \r,\r,\r,\r,
				0,\r,0,\r,0,\r,0,\r,
			],inf),
			\fmf, Pseg(Pseq([100,110]/2,1),1,-3).loop,
			\fmf2, Pseg(Pseq([10,0.1],inf),8*2),
			\legato, Pseg(Pseq([0.1,1],inf),8*4),
			\rel, Pseg(Pseq([0.3,0.01],inf),8*6),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\rel]) ]
				}),
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Plazy({ arg ev;
					Pseg(Pseq([1,0],1),1,[0,1,-1,-2,-3].choose) * Pwhite(0.5,1.0,inf)
				}).loop,
			],inf),
		),
		Pbind(
			\instrument, \betri,
			\freq, ~pmodenv.(Pseq([1000,802],1), 8).loop,
			\fmf, Pkey(\freq)*1.01,
			\fmf2, Pkey(\freq)* Pseg(Pseq([1,1.1],inf),8),
			\octave, 4,
			\dur, 1/2,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.4,0.01,0.1,0.4,1,[-4,0,-4]) ],
			],inf),
			\lag, 1/16/~t,
			\amp, 0.1/4,
			\out, BusDef(\ifx2, \audio),
			\out, BusDef(\sendbus5, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\ifx2, \audio),
			\sideinbus, BusDef(\sidekick, \audio),
			\lag, 0.0004,
			\cpt, 0.011,
			\pregain, 1,
			\cpabove, 0.001,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.02,
			\gain, 1,
			\dur, 1,
		),
	])
)).play;
);

