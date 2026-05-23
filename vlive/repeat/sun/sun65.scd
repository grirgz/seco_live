
(
~t = 150/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("holis/synthdef.scd");
)


(
SynthDef(\strings, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
					var env, in, delay, f1, f2;
					f1 = freq.lag(freqLag);
					f2 = freq.lag(freqLag * 0.5);
					delay = 0.25 / f2;
					env = Env.asr(0, 1, 0.3);
					in = WhiteNoise.ar(180);
					in = CombL.ar(in, delay, delay, 1);
					in = Resonz.ar(in, f1, 0.001).abs;
					in = in * EnvGen.kr(env, gate, doneAction:2);
					Out.ar(out, Pan2.ar(in, pan, amp));

//From SC Examples Folder
// some small pieces
// Julian Rohrhuber, 2007
}).add;
SynthDef(\basicbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig.debug("basicbas");
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\swirl, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr( Env([1,2,1,1/2],[0.1,0.1,1.8]) ), 1);
	env2 = EnvGen.kr(\env2.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env3 = EnvGen.kr(\env3.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env4 = EnvGen.kr(\env4.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env5 = EnvGen.kr(\env5.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	env6 = EnvGen.kr(\env6.kr( Env([1,2,1,7],[0.1,0.1,1.8]) ), 1);
	freq = freq * env5;
	//sig = Pulse.ar(freq * ( 1 + ( SinOsc.ar((1..8) * env1) * (1..8) * env1 ))).mean;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar((1..8) * env4) * (1..8)*\fmamp.kr(1/2) * env1 ))).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(2.1) * freq * env3 ).clip(20,20000), \rq.kr(0.5));
	sig = sig + FreqShift.ar(sig, 0.1 * env2);
	sig = ( sig * env6 * 2).tanh /2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

/////////////////////////

(
Pdef(\demo, 
	Ppar([
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([1,3,1,100]/1,[0.4,0.1,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
			\env5, [ Env([1,1,1,1]/2,[0.2,0.1,0.1]) ],
			\env6, [ Env([1/2,1,4,1],[0.2,0.1,0.4]) ],
			\lpfr, 1,
			\dur, 1/4,
			\fmamp, 0.03,
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.2
		),
	]),
).play;
)

(
Pdef(\melo, 
		Pbind(
			\instrument, \swirl,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, 1,
			\dur, 1/4,
			\fmamp, 0.03,
			\amp, 0.2
		),
)
);
ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\melo, 
	Pbind(
		\instrument, \simpleacid,
		
		\lpfr, 1/2,
		\amp, 0.03,
	)
)
);

/////////////////////////
(
// drums + bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[754].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,1,0,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,1,
				1,1,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,5-12,-3,4,
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([500,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				2,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.2
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([5,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				1,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
);

(
// drums + different bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[754].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,1,0,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,1,
				1,1,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,1,5-12,6-12,-3,-3,4,4
			],inf).stutter(4),
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([500,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				2,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.2
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([5,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				1,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
);

(
// intro
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1403].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				//0.2,0.2,1,
				//0.2,0.2,1,
				1,
				0.2,
			],inf) * Pseg(Pseq([0,0,1,Pn(1,inf)],inf),Pseq([8,16])),
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,1,5-12,6-12,-3,-3,4,4
			],inf).stutter(4),
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.1,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
			\env5, [ Env([1,1,1,1]/2,[0.2,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.2,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				2,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.2
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([50,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([1.06,1,1,1]/2,[0.08,0.1,0.1]) ],
			\env6, [ Env([1,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1/2,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				1,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1 * Pseg(Pseq([0,0,1],inf),Pseq([8,16])),
			//\isRest, true,
		),
	])
)).play;
);

(
// arp
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			0,
			5-12,
			-3,
			4,
		],inf) + [0,4,7],2),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			it.debug("it");
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\arper) <> Pbind(\dur, 1/4, \octave, 3, \plen, 2, \prepeat,8*16,
			\instrument, \basicbass,
			\lpf, 400,
			\amp, 0.1/2,
			\arp, Pseq([0,0,4,4,4,4,0,0],inf),
			\isRest, Pseq([
				1,1,0,1, 1,0,1,1,
			],inf).coin.not,
			//\isRest, true,
		),
		Pdef(\arper) <> Pbind(\dur, 1/1, \octave, 7, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([3],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/2, \octave, 5, \plen, 4, \prepeat,4,
			\instrument, \strings,
			\dur, Prand([1,1/2,2],inf) * 1/2,
			\legato, 1,
			\amp, 0.1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pdef(\arper) <> Pbind(\dur, 1/2, \octave, 4, \plen, 4, \prepeat,4,
			\instrument, \strings,
			\dur, Prand([1,1/2,2],inf) * 1/2,
			\amp, 0.1,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0.3, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
			].scramble,inf).coin.not,
			//\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
	])
)).play;
);

(
// drums + bass + arp
// rising
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7] + 0,
			[0,4,7] + 5-12,
			[0,3,7] + -3,
			[0,3-12,7-12] + 4,
			//[\r,\r,\r] + -3,
			//[0,3,7] + 4,
		],inf),2),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			it.debug("it");
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[754].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,1,0,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,1,
				1,1,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,1,5-12,6-12,-3,-3,4,4
			],inf).stutter(4),
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([500,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				2,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.3
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([5,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				1,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1,
			//\isRest, true,
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 2, \prepeat,8*16,
			\instrument, \simpleacid,
			\arp, Pseq([0,3,0,1,0,2],inf),
			\amp, 0.1/3,
			\lpfr, Pseg(Pseq([1,2,1,8],inf),8),
			\isRest, Pseq([
				1,0,1,0,
				1,0,1,0,
				0.5,Pwhite(0.0,1,3)
			],inf).coin.not,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 6, \plen, 2, \prepeat,8*16,
			\instrument, \kalimba,
			\arp, Pseq([0,0,1,2,3, Pwhite(0,7,3)],inf),
			\amp, 0.1/2,
			\isRest, Pseq([
				1,0,0,0,
				0,0,1,0.6,
				1,0,0.65,0,
				0,0,1,0,

				1,0,0,0,
				1,0,0,0,
				1,0,1,0,
				0.5,Pwhite(0.0,1,3)
			],inf).coin.not,
			//\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

////////////


(
// break
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1403].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				//0.2,0.2,1,
				//0.2,0.2,1,
				1,
				0.2,
			],inf) * Pseg(Pseq([0,0,1,Pn(1,inf)],inf),Pseq([8,16])),
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.1,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
			\env5, [ Env([1,1,1,1]/2,[0.2,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.2,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				2,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.2
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([50,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([1.06,1,1,1]/2,[0.08,0.1,0.1]) ],
			\env6, [ Env([1,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1/2,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				1,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1 * Pseg(Pseq([0,0,1],inf),Pseq([8,16])),
			//\isRest, true,
		),
			Pseq([
				//Event.silent(8),
				Plazy({ arg ev;
					var post = Pbind(
						\instrument, \pluck,
						//\lag, 0.04,
						\note, Pseq([
							Prand([
								Pseq([
									0,-3,-5,
								],1),
								Pseq([
									0,-3,-5,
								],1),
								Prand([2,5],1),
							],1),
						],inf).stutter(1),
						\isRest, Pseq([
							1,0,1,0, 1,0,1,0, 
						],inf).coin.not,
						\dur, 1/8,
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
							\note, Pseq([0,-7,5],inf),
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
						) <> post,
					]);
				}).loop,

			],1),
	])
)).play;
);


(
Pdef(\arper, 
	Pbind(
		\cnote, Pstep(Pseq([
			[0,4,7] + 0,
			[0,4,7] + 5-12,
			[0,3,7] + -3,
			[0,3-12,7-12] + 4,
			//[\r,\r,\r] + -3,
			//[0,3,7] + 4,
		],inf),2),
		\arp, Plazy({ arg ev;
			ev[\arp] ?? {
				Pseq(rrand(0,8!ev[\plen]).postln,ev[\prepeat])
			}
		}).loop.trace,
		\note, Pfunc({ arg ev;
			var it;
			it = ev[\cnote] % 12;
			it = [-12,0,12] +.x it;
			it.debug("it");
			it.wrapAt(ev[\arp]);
		}).trace,
	)
);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[754].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 0,1,0,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,1,0, 0,0,1,1,
				1,1,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,1,5-12,6-12,-3,-3,4,4
			],inf).stutter(4),
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([500,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				0.5,2,0,0.5, 0.5,0.5,0.5,0.5,
				2,0,2,0, 1,1,2,0,
				0.5,0.5,0.5,0.5, 0.5,0.5,0.5,0.5,
				2,0,2,0, 2,0,1,0.4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.3,
			\out, BusDef(\bass, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\hpf, 50,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([5,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([6,1,1,1]/2,[0.02,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				1,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1,
			\isRest, true,
		),
		//Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 5, \plen, 2, \prepeat,8*16,
			//\instrument, \simpleacid,
			//\arp, Pseq([0,3,0,1,0,2],inf),
			//\amp, 0.1/3,
			//\lpfr, Pseg(Pseq([1,2,1,8],inf),8),
			//\isRest, Pseq([
				//1,0,1,0,
				//1,0,1,0,
				//0.5,Pwhite(0.0,1,3)
			//],inf).coin.not,
			////\out, BusDef(\sendbus2, \audio),
		//),
		Pdef(\arper) <> Pbind(\dur, 1/8, \octave, 6, \plen, 1, \prepeat,8,
			\instrument, \kalimba,
			\arp, Pseq([0,0,0,0, 0,1,2,3],inf),
			\amp, 0.1/2 * Pseq([
				1/2,1/2,1/2,1,
				1/2,1/2,1,1/2,
			],inf),
			\isRest, Pseq([
				0,1,0,0,
				1,0,1,1,
			],inf).coin.not,
			//\out, BusDef(\sendbus2, \audio),
		),
	])
)).play;
);

// double trilogy break
// niveau d'energie: description
// 10: partie precedente
// 3: fall, macro turnaround
// 2
// 3
// 2: micro turnaround


///////////


(
// intro
Pdef(\part, Pdef(\intro, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1403].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				//0.2,0.2,1,
				//0.2,0.2,1,
				1,
				0.2,
			],inf) * Pseg(Pseq([0,0,1,Pn(1,inf)],inf),Pseq([8,16])),
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,1,5-12,6-12,-3,-3,4,4
			],inf).stutter(4),
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.1,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
			\env5, [ Env([1,1,1,1]/2,[0.2,0.1,0.1]) ],
			\env6, [ Env([1/2,1/2,4,1],[0.2,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/4,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				2,0,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.2
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([50,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([1.06,1,1,1]/2,[0.08,0.1,0.1]) ],
			\env6, [ Env([1,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1/2,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				1,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1 * Pseg(Pseq([0,0,1],inf),Pseq([8,16])),
			//\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],6),
					0,0,1,0, 0,0,1,1,
					0,0,1,0, 0,0,1,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],6),
					0,0,0,0, 0,0,0,1,
					1,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.03,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1403].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				//0.2,0.2,1,
				//0.2,0.2,1,
				1,
				0.2,
			],inf) * Pseg(Pseq([0,0,1,Pn(1,inf)],inf),Pseq([8,16])),
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,1,5-12,6-12,-3,-3,4,4
			],inf).stutter(4),
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8*2),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.1,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
			\env5, [ Env([1,1,1,1]/2,[0.2,0.1,0.1]) ],
			\escale, Pseq([
				//Pn(1,8*7),
				Pser([
					1,0.2,0.6,0.2,
				],8),
			],inf),
			\env6, Pfunc({ arg ev;
				[ Env([1/2,1/2,4,1],[0.2,0.4,0.4]*ev[\escale]) ];
			}),
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				//4,0,0,0, 0,2,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 2,0,2,0,

				4,0,0,0, 4,0,0,0,
				2,0,2,0, 4,0,0,0,
				2,0,1,1, 1,1,1,1,
				4,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([50,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([1.06,1,1,1]/2,[0.08,0.1,0.1]) ],
			\env6, [ Env([1,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1/2,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				Pser([
					1,0,
				],60),
				4,0, 0,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1 * Pseg(Pseq([0,0,1],inf),Pseq([8,16])),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,7,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,0,0,1,
				1,0,0,1, 1,0,0,1,
				1,0,0,1, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,0,1,
				1,1,0,1, 1,1,0,1,
				1,0,0,1, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				Pseg(
					Pseq([
					 	[ Env.adsr(0.01,0.1,0.8,0.1).asArray ],
					 	[ Env.adsr(0.01,0.1,0.5,1.1).asArray ],
					 ],1)
				 ,16),
			],inf),
			\octave, 5,
			\lpf, 100 * Pseg(Pseq([1,2],1),32,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				1,0.4,0.7,0.3,
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],6),
					0,0,1,0, 0,0,1,1,
					0,0,1,0, 0,0,1,0,
				Pseq([
					0,0,1,0, 0,0,1,0,
				],6),
					0,0,0,0, 0,0,0,1,
					1,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.03,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1403].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				//0.2,0.2,1,
				//0.2,0.2,1,
				1,
				0.2,
			],inf) * Pseg(Pseq([0,0,1,Pn(1,inf)],inf),Pseq([8,16])),
		),
		Pbind( // bass
			\instrument, \swirl,
			\note, Pseq([
				0,5-12,-3,4
			],inf).stutter(8*2),
			\octave, 4,
			\env1, [ Env([1,1,3,1]/1,[0.1,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
			\env5, [ Env([1,1,1,1]/2,[0.2,0.1,0.1]) ],
			\escale, Pseq([
				//Pn(1,8*7),
				Pser([
					1,0.5,0.6,0.2,
				],8),
			],inf),
			\env6, Pfunc({ arg ev;
				[ Env([1/2,1/2,4,1],[0.2,0.4,0.4]*ev[\escale]) ];
			}),
			\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				0,1,2,0, 
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \swirl,
			\note, Pseq([
				0,-5,-8,
			],inf).stutter(2),
			\octave, 6,
			\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
			\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
			\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
			\env4, [ Env([50,1,1,1]/1143,[0.02,0.1,0.1]) ],
			\env5, [ Env([1.06,1,1,1]/2,[0.08,0.1,0.1]) ],
			\env6, [ Env([1,1/2,4,1],[0.02,0.4,0.4]) ],
			\lpfr, ~pmodenv.(Pseq([1/2,2,4,8],1), 8).loop,
			\dur, 1/8,
			\legato, Pseq([
				Pser([
					1,0,
				],60),
				4,0, 0,0,
				//4,0,0,0, 0,2,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fmamp, 0.03,
			\amp, 0.1 * Pseg(Pseq([0,0,1],inf),Pseq([8,16])),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				4,7,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,0,0,1,
				1,0,0,1, 1,0,0,1,
				1,0,0,1, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,0,1,
				1,1,0,1, 1,1,0,1,
				1,0,0,1, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				Pseg(
					Pseq([
					 	[ Env.adsr(0.01,0.1,0.8,0.1).asArray ],
					 	[ Env.adsr(0.01,0.1,0.5,1.1).asArray ],
					 ],1)
				 ,16),
			],inf),
			\octave, 5,
			\lpf, 300 * Pseg(Pseq([1,2],1),32,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				1,0.4,0.7,0.3,
			],inf),
			\out, BusDef(\mela, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\mela, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mela2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mela2, \audio),
			\addAction, \addToTail,
			\lpf, 15000,
			\hpf, PmodEnv(Pseq([800,400,2000],1), Pseq([14,2]),\exp).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mela3, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\mela3, \audio),
			\mix, 0.3,
			\hpf, 300,
			\delay, PmodEnv(Pseq(2/3/~t*[1,1/2,1/8],1), Pseq([14,2]),\exp).loop,
			\decay, 3/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);


/////////// separate instr

(
Pdef(\kick, 
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1570].value,
		\isRest, Pseq([
			Pseq([
				1,0,0,0, 1,0,0,0,
			],7),
			1,0,0,0, 1,0,1,0,
			Pseq([
				1,0,0,0, 1,0,0,0,
			],7),
			0,0,0,0, 0,0,1,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
);
Pdef(\hat, 
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[26].value,
		//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\isRest, Pseq([
			Pseq([
				0,0,1,0, 0,0,1,0,
			],6),
			0,0,1,0, 0,0,1,1,
			0,0,1,0, 0,0,1,0,
			Pseq([
				0,0,1,0, 0,0,1,0,
			],6),
			0,0,0,0, 0,0,0,1,
			1,0,1,1, 0,0,0,0,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/8,
		\gain, 0.03,
	),
);
Pdef(\bass, 
	Pbind( // bass
		\instrument, \swirl,
		\note, Pseq([
			0,5-12,-3,4
		],inf).stutter(8*2),
		\octave, 4,
		\env1, [ Env([1,1,3,1]/1,[0.1,0.44,0.1]) ],
		\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
		\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
		\env4, [ Env([1,1,1,1]/1143,[0.2,0.1,0.1]) ],
		\env5, [ Env([1,1,1,1]/2,[0.2,0.1,0.1]) ],
		\escale, Pseq([
			//Pn(1,8*7),
			Pser([
				1,0.5,0.6,0.2,
			],8),
		],inf),
		\env6, Pfunc({ arg ev;
			[ Env([1/2,1/2,4,1],[0.2,0.4,0.4]*ev[\escale]) ];
		}),
		\lpfr, ~pmodenv.(Pseq([1,2,4,8],1), 8).loop,
		\dur, 1/8,
		\legato, Pseq([
			0,1,2,0, 
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\fmamp, 0.03,
		\amp, 0.2,
	),
);
Pdef(\swirlmel, 
	Pbind(
		\instrument, \swirl,
		\note, Pseq([
			0,-5,-8,
		],inf).stutter(2),
		\octave, 6,
		\env1, [ Env([1,1,3,1]/1,[0.01,0.44,0.1]) ],
		\env2, [ Env([3,1,5,-10]/1,[0.04,0.4,0.1]) ],
		\env3, [ Env([1,1,1,1],[0.2,0.3,0.3]) ],
		\env4, [ Env([50,1,1,1]/1143,[0.02,0.1,0.1]) ],
		\env5, [ Env([1.06,1,1,1]/2,[0.08,0.1,0.1]) ],
		\env6, [ Env([1,1/2,4,1],[0.02,0.4,0.4]) ],
		\lpfr, ~pmodenv.(Pseq([1/2,2,4,8],1), 8).loop,
		\dur, 1/8,
		\legato, Pseq([
			Pser([
				1,0,
			],60),
			4,0, 0,0,
			//4,0,0,0, 0,2,0,0,
		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\fmamp, 0.03,
		\amp, 0.1 * Pseg(Pseq([0,0,1],inf),Pseq([8,16])),
	),
);
Pdef(\mela, 
	Pbind(
		\instrument, \sh101,
		\note, Pseq([
			4,7,0,0,
		],inf),
		\isRest, Pseq([
			1,1,1,1, 1,0,0,1,
			1,0,0,1, 1,0,0,1,
			1,0,0,1, 1,0,0,1,
			1,0,1,0, 1,0,1,0,
			1,0,0,1, 1,0,0,1,
			1,1,0,1, 1,1,0,1,
			1,0,0,1, 1,0,0,1,
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\adsr, Pseq([
			Pseg(
				Pseq([
				 	[ Env.adsr(0.01,0.1,0.8,0.1).asArray ],
				 	[ Env.adsr(0.01,0.1,0.5,1.1).asArray ],
				 ],1)
			 ,16),
		],inf),
		\octave, 5,
		\lpf, 300 * Pseg(Pseq([1,2],1),32,\exp).loop,
		\envamt, 4,
		\dur, 1/8,
		\amp, 0.1 * Pseq([
			1,0.4,0.7,0.3,
		],inf),
	),
);
);


(
// todo: make the whole composition by using fx on the instruments
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kick),
		Pdef(\hat),
		Pdef(\bass),
		Pdef(\mela),
		Pdef(\swirlmel),
	])
)).play;
);

(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(\out, BusDef(\kick, \audio)) <> Pdef(\kick),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kick, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10000,1000,30],1), 8).loop,
			\lag, 0.0009,
			\gain, Pseq([
				PmodEnv(Pseq([0,1,1,1],1), 8),
				Pn(1,16),
			],inf),
			\dur, 1,
		),
		//Pdef(\hat),
		//Pdef(\bass),
		Pbind(\out, BusDef(\mela, \audio)) <> Pdef(\mela),
		Pbind(\out, BusDef(\swirlmel, \audio)) <> Pdef(\swirlmel),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\mela, \audio),
			\addAction, \addToTail,
			\room, 2,
			\mix, Pseq([
				PmodEnv(Pseq([1,0.5,0],1), 8),
				Pn(0,16),
			],inf),
			\fmix, Pseq([
				Pn(1,16),
				Pn(0,16),
			],inf),
			\hpf, Pseq([
				PmodEnv(Pseq([5000,1000,100],1), 8,\exp),
				Pn(100,16),
			],1),
			//\lag, 0.0009,
			\dur, 1,
		).loop,
	])
)).play;
);

(
// second
Pdef(\part, Pdef(\intro2, 
	Ppar([
		Pbind(\out, BusDef(\kick, \audio)) <> Pdef(\kick),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kick, \audio),
			\addAction, \addToTail,
			\hpf, Pseq([
				PmodEnv(Pseq([10000,1000,30],1), 8),
				Pn(10,16),
				Pn(10,16),
			],1),
			\lag, 0.0009,
			\gain, Pseq([
				PmodEnv(Pseq([0,0,0,1,1],1), 8),
				Pn(1,16),
			],inf),
			\dur, 1,
		),
		Ptpar([
			4, Pdef(\hat),
		]),
		//Pbind(\out, BusDef(\bass, \audio)) <> 
		Pseq([
			Pfindur(16,Pbind(
				\legato, Pseq([
					4,0,0,0, 4,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			)),
			Pfindur(32,Pbind(
				\legato, Pseq([
					Pser([
						4,0,0,0, 4,0,0,0,
						4,0,0,0, 4,0,0,0,
						4,0,0,0, 2,0,2,0,
						2,0,1,0, 1,1,1,0,
					],8),
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			)),
			Pbind()
		],1) <> Pdef(\bass),
		Pbind(\out, BusDef(\mela, \audio)) <> Pdef(\mela),
		//Pbind(\out, BusDef(\swirlmel, \audio)) <> 
		Pdef(\swirlmel),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\mela, \audio),
			\addAction, \addToTail,
			\room, 2,
			\mix, Pseq([
				Pn(1,16),
				PmodEnv(Pseq([1,0.5,0],1), 8),
				Pn(0,16),
				Pn(0,16),
			],inf),
			\fmix, Pseq([
				Pn(1,16),
				Pn(1,16),
				Pn(0,16),
				Pn(0,16),
			],inf),
			\hpf, Pseq([
				Pn(5000,16),
				PmodEnv(Pseq([5000,1000,100],1), 8,\exp),
				Pn(100,16),
				Pn(100,16),
			],1),
			//\lag, 0.0009,
			\gain, 
			Pseq([
				PmodEnv(Pseq([0,0,0,1,1],1), 8).loop,
				Pn(1,16),
				Pn(1,16),
			],1),
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\type, \phrase,
			\instrument, \kick,
			\legato, 1,
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\dur, 8,
		),
		Pbind(
			\type, \phrase,
			\instrument, \hat,
			\legato, 1,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 8,
		),
		Pbind(
			\type, \phrase,
			\instrument, \bass,
			\legato, 1,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 8,
		),
		Pbind(
			\type, \phrase,
			\instrument, \mela,
			\legato, 1,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 8,
		),
		Pbind(
			\type, \phrase,
			\instrument, \swirlmel,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 8,
		),
	])
)).play;
);
