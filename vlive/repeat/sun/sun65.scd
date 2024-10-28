
~t = 150/2/60; TempoClock.default.tempo = ~t;

FileSystemProject.load("holis/synthdef.scd");


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
)

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

(
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

// with arp
(
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
