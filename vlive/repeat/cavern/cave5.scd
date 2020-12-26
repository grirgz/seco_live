(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("capsule/fxheavy.scd");
BufDef(\loop, s.sampleRate * 4 / ~t, 2);
BufDef(\mexico, "/home/ggz/Musique/helmut-zacharias-mexico-melody.flac");

SynthDef(\looper, { arg out=0, gate=1, bufnum;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	RecordBuf.ar(sig, bufnum: bufnum, offset: 0, recLevel: 1, preLevel: \preLevel.kr(1), run: 1, loop: 1, trigger: 1, doneAction: 0);
	sig = PlayBuf.ar(2, bufnum: bufnum, rate: 1, trigger: DelayL.kr(Impulse.kr(0), 0.0001,0.0001), startPos: 0, loop: 1, doneAction: 0);
	//sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part2, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\bus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\bus1, \audio, 2),
			//\out, BusDef(\bus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			//'delay', 0.000600001231 * Pseq([
				//~pmodenv.(Pseq([1,2,1,4,1000],inf), 7),
			//],inf).stutter(1),
			\delay, 0.000001,
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		
	])
)).play;
);

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,4/5,1,4/5+0.01,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\saw2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\apoca, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
BufDef(\loop).zero;
Pdef(\part, Pdef(\apoca1, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\freq, ~pmodenv.(Pseq([2000,1000,100,40],inf), Pseq([4,3,1/2],inf)),
			\lpfr, ~pmodenv.(Pseq([1.2,1.1,0.9,2.1],inf), Pseq([1,4,3,1/2],inf)),
			\dur, 1,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.9714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				~pmodenv.(Pseq([1,2,1,4,1000],inf), 7),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
)).play;
)

(
BufDef(\loop).zero;
Pdef(\part, Pdef(\apoca1, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\freq, ~pmodenv.(Pseq([2000,1000,100,40],inf), Pseq([4,3,1/2],inf)),
			\lpfr, ~pmodenv.(Pseq([1.2,1.1,0.9,2.1],inf), Pseq([1,4,3,1/2],inf)),
			\dur, 1/8 + Pseq([Pn(0,7),0.01],inf),
			\legato, 0.1,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.9714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				~pmodenv.(Pseq([1,2,1,4,100,1000],inf), 7),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
)).play;
)

(
BufDef(\loop).zero;
Pdef(\part, Pdef(\apoca1, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\freq, ~pmodenv.(Pexprand(40,2000.0,inf), Pseq([4,3,1/2],inf)),
			\lpfr, ~pmodenv.(Pexprand(0.7,2.1,inf), Pseq([1,4,3,1/2],inf)),
			\dur, Prand([1/8,1/16,1/4],inf),
			\legato, 0.1,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.9714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				~pmodenv.(Pseq([1,2,1,4,100,1000],inf), 7),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
)).play;
)

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\bufnum, ~buflib.kick[1334].value,
			//\bufnum, ~buflib.kick[1050].value,
			\bufnum, ~buflib.kick[257].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[736].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[259].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[892].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		
	])
)).play;
);
Pdef(\part2).clear;

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Psched(8,Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			//\bufnum, ~buflib.kick[1334].value,
			//\bufnum, ~buflib.kick[1050].value,
			\bufnum, ~buflib.kick[257].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		)),
		Psched(4,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[736].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[259].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[892].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		
	])
)).play;
);

(
BufDef(\loop).zero;
Pdef(\part, Pdef(\apoca1, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\freq, ~pmodenv.(Pexprand(80,2000.0,inf), Pseq([4,3,1/2],inf)),
			\lpfr, ~pmodenv.(Pexprand(0.7,2.1,inf), Pseq([1,4,3,1/2],inf)),
			\dur, Prand([1/8,1/16,1/4],inf),
			\legato, 0.1,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.9714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				~pmodenv.(Pseq([1,2,1,4,100,1000],inf), 7),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 170,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\gain , 1/3,
		),
	]),
)).play;
)

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1027].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.12,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2203].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1021].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.hat[203].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,0,0,0,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,1,1, 1,1,0,0,
			
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,1,1, 1,1,1,1,
					0,0,0,1, 0,0,1,0,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
					0,0,0,0, 0,1,1,1,
					0,0,0,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\st, 92.10/4/60,
				\speed, 1/2 * 1.1 * ~t / Pkey(\st),
				\pos, 1+Pseg(Pseq([
					0, 2, 1, 0.5,
				],1),1).loop / Pkey(\st),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.4,1),
					Pseq([
						1,1,1,1, 1,1,1,1,
					]*0.9,1),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('mexico'),
			\legato, ( 1 - Pexprand(0.1,0.91,inf) ),
			\speed, 1 * Pseq([
				Pser([
					1,
				],8),
				Pseq([
					Pn(1,3),Pwhite(0.7,1.3,1),
				],1),
			],inf),
			\speed, Pseg(Pseq([1,1.2,2,1/2,1],inf),1/2),
			\pos, 53 + Pwhite(0.0,1,inf),
			\pos, Pkey(\pos) + Pseg(Pseq([0,1],inf),8),
			\coin, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),

				0,0,0,0, 0,0,0,0,
				Pseq([ 1,1,1,1, 1,1,1,1, ],1),
				0,0,0,0, 0,0,0,0,
				Plazy({ arg ev; Pseq([ 2,1,1,1, 1,1,1,1, ].scramble/2,1) }),
			],inf).coin.not,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,2.1,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
				0,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				( 1 - Pexprand(0.1,0.91,8) ),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\coin] } }),
			\dur, 1/8,
			\dur, Pkey(\dur)* (1 + (0.19 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
	])
)).play;
);


(
BufDef(\loop).zero;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\mexico),
			\dur, 1,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\gain, 1,
		),
		Pbind(
			\instrument, \grainenoise,
			\mbufnum, BufDef.mono('mexico'),
			\gfreq, 20,
			\gdur, 0.091,
			\speed, Pwhite(0.6,1.7),
			\pos, ~pmodenv.(Pwhite(10,60.1,inf), Pwhite(10,30.0)),
			\gdur, Pwhite(0.1,2),
			\dur, Pwhite(0.1,0.05),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.3,
		),
		Pbind(
			\instrument, \saw,
			\freq, ~pmodenv.(Pexprand(180,2000.0,inf), Pseq([4,3,1/2],inf)),
			\lpfr, ~pmodenv.(Pexprand(0.7,2.1,inf), Pseq([1,4,3,1/2],inf)),
			\dur, Prand([1/8,1/16,1/4],inf),
			\legato, 0.1,
			\amp, 0.1/28,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			\lag, 0.0005,
			'mix', 0.9714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				~pmodenv.(Pseq([1,2,1,4,100,1000],inf), 7),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			\lag, 0.0006,
			\loopdur, 4/~t,
			\preLevel, 0.8,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\gain , 1,
		),
		
	])
)).play;
);

(
Pdef(\sample, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \oscsampler3,
			\pos, 54.15,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			]/4,inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 1,
			\hpfreq, 400,
			\ffreq, Pseq([
				1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\amp, 0.1/2,
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('mexico'),
		), 
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
		//		[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
				[ Env([0.20,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf).stutter(8),
			\finepos, 4/400,
			\legato, Pseq([
				0,0,0,0,
				2,0,
				2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fshift, 40,
			\lpmix, 1,
			\rq, 0.4,
			\hpmix, 0,
			\hpfreq, 100,
			\ffreq, Pseq([
				3000,1020,5240,450,700,
			],inf) * Pseq([1,2,1/2],inf).stutter(4),
			\amp, 0.071,
			\bufnum, BufDef('voices/feynman.flac'),
		), 
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.208,
			\freq, 187,
			\range, 0.0000001,
			\posenv, Pseq([
				[ Env([0.00,0.01001,0].integrate.postln,[0.41,8.1]) ],
		//		[ Env([0.20,0.01001,0].integrate.postln,[0.41,8.1]) ],
			],inf).stutter(8),
			\finepos, 4/400,
			\legato, Pseq([
				Pseq([
					2,0,
				],8*4),
				Pseq([
					Pseq((0..7),4)/8+0.1,
					Pseq((0..7),4)/4+0.1,
					Pseq((0..7),4)/2+0.1,
				],1),
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
			\bufnum, BufDef('voices/feynman.flac'),

		),
	])
)).play;
)
Pdef(\sample).clear;
