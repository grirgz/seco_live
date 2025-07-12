
// hard bass
(
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");


~t = 155/2/60; TempoClock.default.tempo = ~t;
)

(
// nice dist
SynthDef(\donk, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.2],-4), 1) * 0.9 + 1;
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.4],-8), 1) * 4;
	sig1 = ( LFSaw.ar(freq*2) * env2 );
	sig1 = sig1 + ( LFSaw.ar(freq*4) * env2 * \fma2.kr(0) );
	sig1 = LPF.ar(sig1, freq*4);
	sig = SinOsc.ar(freq * ( sig1 + 1 )) * 0.4;
	sig = sig + SinOsc.ar(freq/2 * ( sig1 * \fma.kr(5) + 1 ));
	//sig = sin(sig*2);
	sig = LeakDC.ar(sig);
	sig = sig + SinOsc.ar(freq/2,mul:0.5); // subbass; 
	//sig = RLPF.ar(sig, \lpf.kr(200) * env1, \rq.kr(0.3));
	//sig = LPF.ar(sig, \lpf.kr(300) * env1);
	//sig = sig * 8;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.009,0.2,0.1,0.4,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \donk,
		\degree, Pseq([0],inf),
		\octave, 3,
		\note, Pseq([
			//0,0,0,0, 6,3,0,4,
			0,6,3,4,
		],inf).stutter(8),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);


(
// recreate hard bass line
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \donk,
			\degree, Pseq([0],inf),
			\octave, 4,
			\lpf, PmodEnv(Pseq([100,1200],1), 16*2).loop,
			\note, Pseq([
				3,3,4,4,6,6,3,4,
				3,3,4,4,6,6,3,4,
				3,3,4,4,6,6,3,4,
				3,3,4,4,11,11,10,10,
			],inf).stutter(2),
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1339].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),	
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2061].value,
			\bufnum, ~buflib.snare[431].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1338].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

///// impro

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \donk,
			\degree, Pseq([0],inf),
			\octave, 4,
			\note, Pseq([
				//0,0,0,0, 6,3,0,4,
				0,0,0,6, 0,0,3,4,
			],inf).stutter(4),
			\fma, PmodEnv(Pseq([1,4],1), 8).loop,
			\fma2, PmodEnv(Pseq([1,8],1), 16).loop,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 1,0,1,1,
				//1,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1339].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),	
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2061].value,
			\bufnum, ~buflib.snare[431].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1338].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[73].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,1,
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,12,0,6-12,
				0,12,3,4-12,
			],inf).stutter(2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.2,0.3,0.1) ],
			],inf),
			\envamt, PmodEnv(Pseq([1,8],1), 16).loop,
			\lpf, 200,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,1,1,1, 0,0,1,1,
				1,1,0,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \sh101,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.8) ],
		],inf),
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

/////// sdesign evolve

(
SynthDef(\evo1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(freq * \fmr.kr(1) * ( SinOsc.ar(freq * \fmr2.kr(1) * [0,4,7].midiratio) * \fmamp2.kr(0.5) + 1 ));
	sig = SinOsc.ar(freq * ( sig1 * \fmamp.kr(0.5) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evo1,
			\note, Pseq([
				5,
			],inf),
			\fmr, PmodEnv(Pseq([1.95,2.051],1), 8*2).loop,
			\fmr2, PmodEnv(Pseq([1.95,2.051],1), 8*2).loop,
			\fmamp, PmodEnv(Pseq([1,1.5],1), 8*2).loop,
			\fmamp2, PmodEnv(Pseq([1,1.5],1), 8*2).loop,
			\dur, 4,
			\octave, 4,
			\amp, 0.1,
		),
	])
)).play;
);


(
// nice
SynthDef(\evo2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 10;
	var rnd = { 
		LFNoise1.kr(0.01!num) * 0.001 + 1
	};
	freq = freq.lag(1);
	sig1 = SinOsc.ar(freq * \fmr2.kr(2) * rnd.() ) * \fmamp2.kr(0.5) + 1;
	sig2 = SinOsc.ar(freq * \fmr.kr(1/2) * rnd.() * sig1);
	sig = SinOsc.ar(freq * ( sig2 * \fmamp.kr(0.5) + 1 ) * [0,4,7].midiratio);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evo2,
			\note, Pseq([
				0,5,
			],inf).stutter(4),
			\fmamp, PmodEnv(Pseq([1,5],1), 8*2).loop,
			\fmamp2, PmodEnv(Pseq([1,5],1), 8*2).loop,
			\dur, 4,
			\octave, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
// nice drone
SynthDef(\evo3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 10;
	var rnd = { 
		LFNoise1.kr(0.01!num) * 0.0004 + 1
	};
	freq = freq.lag(\flag.kr(5));
	sig1 = SinOsc.ar(freq * \fmr2.kr(2) * rnd.() ) * \fmamp2.kr(0.5) + 1;
	sig2 = SinOsc.ar(freq * \fmr.kr(1/2) * rnd.() * sig1);
	sig2 = sig2 + SinOsc.ar(freq * \fmr.kr / 2 * rnd.() * sig1);
	sig2 = sig2 + SinOsc.ar(freq * \fmr.kr / 4 * rnd.() * sig1);
	sig = SinOsc.ar(freq * ( sig2 * \fmamp.kr(0.5) + 1 ) * [0,4,7].midiratio);
	//sig = RLPF.ar(sig, ( \lpfr.kr(4) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = BPF.ar(sig, freq);
	sig = BPF.ar(sig, freq);
	sig = BPF.ar(sig, freq);
	sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.5), amp, pan);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.1), \room.kr(2), \damp.kr(0.8));
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evo3,
			\note, Pseq([
				0,5,12,5-12,
			],inf).stutter(4),
			\fmamp, PmodEnv(Pseq([0,5],10), Pseq([3,3,1,10],inf)).loop,
			\fmamp2, PmodEnv(Pseq([0,5],10), 10).loop,
			\dur, 2,
			\octave, [5,6],
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evo3,
			\freq, PmodEnv(Pseq([50,7500],1), Pseq([16],inf)).loop,
			\fmamp, PmodEnv(Pseq([0,5],10), Pseq([3,3,1,10],inf)).loop,
			\fmamp2, PmodEnv(Pseq([0,5],10), 10).loop,
			\dur, 2,
			\octave, 5,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evo3,
			\freq, PmodEnv(Pseq([750,40],1), Pseq([6],inf)).loop,
			\fmamp, PmodEnv(Pseq([0,5],10), Pseq([3,3,1,10],inf)).loop,
			\fmamp2, PmodEnv(Pseq([0,5],10), 10).loop,
			\dur, 2,
			\octave, 5,
			\amp, 0.1,
		),
	])
)).play;
);



(
SynthDef(\evo4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 10;
	var rnd = { 
		LFNoise1.kr(0.01!num) * 0.0004 + 1
	};
	freq = freq.lag(\flag.kr(5));
	sig1 = SinOsc.ar(freq * \fmr2.kr(2) * rnd.() ) * \fmamp2.kr(0.5) + 1;
	sig2 = SinOsc.ar(freq * \fmr.kr(1/2) * rnd.() * sig1);
	sig2 = sig2 + SinOsc.ar(freq * \fmr.kr / 2 * rnd.() * sig1);
	sig2 = sig2 + SinOsc.ar(freq * \fmr.kr / 4 * rnd.() * sig1);
	sig = SinOsc.ar(freq * ( sig2 * \fmamp.kr(0.5) + 1 ));
	sig = sig + LFCub.ar(freq*1/4,mul:0.5);
	//sig = RLPF.ar(sig, ( \lpfr.kr(4) * freq ).clip(20,20000), \rq.kr(0.5));
	//sig = BPF.ar(sig, freq);
	//sig = BPF.ar(sig, freq);
	//sig = BPF.ar(sig, freq);
	sig = sig * 1/4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.5), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\evo4,
			\note, Pseq([
				//0,5,7,2, 3,1,7,2,
				0,7,5,7,
			],inf).stutter(1),
			\fmamp, PmodEnv(Pseq([0,5,1,3],10), Pseq([3,3,7,10],inf)).loop,
			\fmamp2, PmodEnv(Pseq([0,5],10), 10).loop,
			\flag, 0,
			\dur, 2,
			\octave, 5,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \evo4,
			\note, Pseq([
				0,4,3,2,
			],inf).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, Pseq([6,5],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\evo4simple, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 2;
	var rnd = { 
		LFNoise1.kr(0.01!num) * 0.004 + 1
	};
	freq = freq.lag(\flag.kr(5));
	sig1 = SinOsc.ar(freq * \fmr2.kr(2) * rnd.() ) * \fmamp2.kr(0.5) + 1;
	sig2 = SinOsc.ar(freq * \fmr.kr(1/2) * rnd.() * sig1);
	sig2 = sig2 + SinOsc.ar(freq * \fmr.kr / 2 * rnd.() * sig1);
	sig2 = sig2 + SinOsc.ar(freq * \fmr.kr / 4 * rnd.() * sig1);
	sig = SinOsc.ar(freq * ( sig2 * \fmamp.kr(0.5) + 1 ));
	sig = sig + LFCub.ar(freq*1/4,mul:0.5);
	//sig = RLPF.ar(sig, ( \lpfr.kr(4) * freq ).clip(20,20000), \rq.kr(0.5));
	//sig = BPF.ar(sig, freq);
	//sig = BPF.ar(sig, freq);
	//sig = BPF.ar(sig, freq);
	sig = sig * 1/1.8;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.5), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

// draft
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \evo4simple,
			\note, Pseq([
				0,4,3,2,
			],inf).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, Pseq([6,5],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \evo4simple,
			\note, Pseq([
				0,4,3,2,
			],inf).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\fmamp2, PmodEnv(Pseq([0.1,2],1), 16).loop,
			\flag, 0,
			\octave, Pseq([
				6,5, 6,5,
				7,5, 7,5,
			],inf),
			\dur, 1/4,
			\legato, Pseq([
				1,0,1,0, 4,0,0,0,
				1,1,1,1, 1,1,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \evo4simple,
			\note, Pseq([
				0,4,7,8,
				0,4,7,2,
			],inf).stutter(4),
			\octave, 8,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
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
			\instrument, \evo4simple,
			\note, Pseq([
				Pser([ 2,-1,-5, ],8),
				Pser([ 2,-1,-5, ],8),
				Pser([ 2,-3,-7, ],8),
				Pser([ 2,-3,-7, ],8),
			],inf),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				-5,0,2,4,
				-1,-1,-1,-1,
				-5,0,2,4,
				-1,-1,-1,-1,
				-3,0,2,4,
				2,2,2,2,
				-3,0,2,4,
				2,2,2,2,
			],inf).stutter(2),
			\octave, 7,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,1, 1,0,0,0,
				1,1,1,1, 1,1,0,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,0,1,1,
				1,1,0,1, 1,0,0,0,
				1,1,0,1, 1,0,0,1,
			],inf).coin.not,
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
			\instrument, \evo4simple,
			\note, Pseq([
				Pser([ 2,-1,-5, ],8),
				Pser([ 2,-1,-5, ],8),
				Pser([ 2,-3,-7, ],8),
				Pser([ 2,-3,-7, ],8),
			],inf),
			\octave, 6,
			\dur, 1/4,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				12,9,7,
			],inf).stutter(2),
			\octave, 6,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,0,1, 1,0,0,0,
				1,1,1,1, 1,1,0,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,0,1,1,
				1,1,0,1, 1,0,0,0,
				1,1,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
(
SynthDef(\evonoise1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\bpfenv.kr(Env([100,12000,100],[0.1,0.8])), 1);
	sig = WhiteNoise.ar;
	sig = BPF.ar(sig, \bpfr.kr(1) * env1, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\evonoise1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\bpfenv.kr(Env([100,12000,100],[0.1,0.8])), 1);
	sig = WhiteNoise.ar;
	sig = BPF.ar(sig, \bpfr.kr(1) * env1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

////// lib

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1280].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1731].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,1, 1,0,1,0,

				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,1, 1,1,1,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,1, 1,0,1,0,
				0,0,0,0, 1,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				Pseq([
					[ Env.adsr(0.1,0.01,0.8,0.1,0.7) ],
				],3),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[789].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 0,0,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07 * Pseq([
				0.7,0.4,
				1,0.5,
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1280].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,1,
				0,1,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1731].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				1,0,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				Pseq([
					[ Env.adsr(0.1,0.01,0.8,0.1,0.7) ],
				],3),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[789].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07 * Pseq([
				0.7,0.4,
				1,0.5,
			],inf),
		),
		
	])
)).play;
);

////// compo

(
// base
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1280].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1731].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
				0,0,1,0, 1,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				Pseq([
					[ Env.adsr(0.1,0.01,0.8,0.1,0.7) ],
				],3),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[789].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07 * Pseq([
				0.7,0.4,
				1,0.5,
			],inf),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 2,2,-5,2 ],8),
				Pser([ -1,-5, ],8),
				Pser([ -3,-7+12, ],8),
				Pser([ -3,-7,-7+12,-7 ],8),
			],inf),
			\lpenvamt, 4,
			\rq, PmodEnv(Pseq([0.7,0.3],1), 8*4).loop,
			\lpf, PmodEnv(Pseq([400,4000],1), 8*4).loop,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 2,-1,-5, ],8),
				Pser([ 2,-1,-5, ],8),
				Pser([ 2,-3,-7, ],8),
				Pser([ 2,-3,-7, ],8),
			],inf),
			\octave, 6,
			\lpf, 1800,
			\dur, 1/4,
			\amp, 0.1/3,
		),

		Pbind(
			\instrument, \reese,
			\note, Pseq([
				0,0,0,2,
			],inf).stutter(8),
			\lpadsramt, 4,
			\octave, Pseq([5,6],inf),
			\isRest, Pseq([
				Pseq([ 1,1,1,0, 1,0,1,0, ],7),
				1,1,1,1, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \reese2,
			\note, Pseq([
				5,7,0,2,
			],inf).stutter(2),
			\lpadsramt, 4,
			\octave, Pseq([7],inf),
			\isRest, Pseq([
				Pseq([ 1,0,0,1, 1,0,1,1, ],3),
				1,0,1,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[-1+12,-5,2-12],
				[-3+12,-7,2],
				[-1,-5+12,2-12],
				[-3+12,-7,2+12],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\passage1, 
	Ppar([

		Pmono(\evo4,
			\note, Pseq([
				Pser([ 2,2,-5 ],8),
				Pser([ 2,2,-1, ],8),
				Pser([ -3,2,-7+12, ],16),
			],inf),
			\fmamp, PmodEnv(Pseq([0,5],1), Pseq([16],inf)).loop,
			\fmamp2, PmodEnv(Pseq([0,5],1), 16).loop,
			\flag, 0,
			\dur, 1/8,
			\octave, 6,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[789].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.7,0.4,
				1,0.5,
			],inf) * Pseg(Pseq([0,1],inf),16),
		),
		Pbind(
			\instrument, \evonoise1,
			\bpf, 5200,
			\bpfenv, Pseq([
				[ Env([100,4000,100],[3.9,0.1]/~t, 2) ]
			],inf),
			\rq, 0.1,
			\dur, 4,
			\legato, 1,
			\isRest, Pseq([
				0,0,
				0,1,
			],inf).coin.not,
			\amp, 0.4,
		),
		Pbind(
			\instrument, \snappad,
			\ffreq, PmodEnv(Pseq([100,12000],1), 16).loop,
			\note, Pseq([
				[-1+12,-1],
				[-1+12,-1],
				[-5,-5+12],
				[-5,-5+12,2],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1731].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],12),
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//Pseq([
					//[ Env.adsr(0.1,0.01,0.8,0.1,0.7) ],
				//],1),
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\passage2, 
	Pfindur(32,Ppar([
		
		//Pdef(\drums1),
		Pseq([
			Pfindur(6,Pdef(\drums1)),
			Pfindur(2,Pdef(\drums2)),
		],1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 2,2, ],8),
				Pser([ -5,-5, ],8),
				Pser([ -3,-3,-3, ],8),
				Pser([ 4-12,4-12, ],6),
				Pser([ -7,-7, ],2),
			],inf),
			\lpenvamt, Pseq([2,6],inf),
			\rq, PmodEnv(Pseq([0.7,0.3],1), 8*4).loop,
			\lpf, PmodEnv(Pseq([800,4000],1), 8*4).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.21) ],
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				[-1+12,-5,2-12],
				[-3+12,-7,2],
				[-1,-5+12,2-12],
				[-3+12,-7,2+12],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\time, Pseq([
				1/3,1/8,1/16,1/4,1/2
			],inf).stutter(2)/~t,
			\mix, Pseq([
				0,0,0,0, 
				0,0,0,0,
				0,0,1,0, 
				0,1,0,0,
				0,1,0,1,
				1,1,0,1,
			],inf),
			\lag, 0.0009,
			\dur, 1/2,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\room, 2,
			\gain, 0.7,
			\mix, Pstep(Pseq([0,0,0,0, 0,0,1,1],1), 4),
			\lag, 0.00091,
			\dur, 1/4,
			\out, BusDef(\ifx3, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\ifx3, \audio),
			\addAction, \addToTail,
			\room, 2,
			\hpf, 2000,
			\mix, Pstep(Pseq([0,0,0,0, 0,0,1,1],1), 4),
			\lag, 0.00092,
			\dur, 1/4,
		),
		Ptpar([
			8, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.clap[225].value,
					//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
					\isRest, Pseq([
						Pseq([
							0,0,0,0, 1,0,0,0,
						],16),
					],1).coin.not,
					\dur, 1/8,
					\gain, 0.11 * Pseg(Pseq([0,1],1),16).loop,
				),
				Pmono(\jojo,
					\note, Pseq([
						-1,-7
					],inf).stutter(4),
					\dur, Pn(1,16),
					\amp, 0.1,
				),
			]),
			24, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1590].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\speed, Pseg(Pseq([0.5,2],1),8),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\legato, 2,
					\dur, 1/8,
					\gain, 0.11 * Pseg(Pseq([0,1],inf),8),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, [
						~buflib.hat[1181].value,
						~buflib.hat[1571].value,
					],
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],1).coin.not,
					\legato, 8,
					\dur, 1/8,
					\gain, [0.04,0.11]*2,
					\out, BusDef(\ifx10, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\ifx10, \audio),
					\addAction, \addToTail,
					\room, 3,
					\mix, 0.5,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		Pbind(
			\instrument, \evonoise1,
			\bpf, 5200,
			\bpfenv, Pseq([
				[ Env([100,6000,100],[8-0.1,0.1]/~t, 4) ]
			],inf),
			\rq, 0.1,
			\dur, 8,
			\legato, 1,
			\isRest, Pseq([
				0,0,
				0,1,
			],inf).coin.not,
			\amp, 0.4,
		),
		Pbind(
			\legato,1,
			\instrument, \zip1,
			\freq, 200,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1/2,
		),
	]))
)).play;
);


(
Pdef(\part, Pdef(\passage2base, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 2,2, ],8),
				Pser([ -5,-5, ],8),
				Pser([ -3,-3,-3, ],8),
				Pser([ 4-12,4-12, ],6),
				Pser([ -7,-7, ],2),
			],inf),
			\lpenvamt, Pseq([2,6],inf),
			\rq, PmodEnv(Pseq([0.7,0.3],1), 8*4).loop,
			\lpf, PmodEnv(Pseq([800,4000],1), 8*4).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.21) ],
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				[-1+12,-5,2-12],
				[-3+12,-7,2],
				[-1,-5+12,2-12],
				[-3+12,-7,2+12],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\time, Pseq([
				1/3,1/8,1/16,1/4,1/2
			],inf).stutter(2)/~t,
			\mix, Pseq([
				0,0,0,0, 
				0,0,0,0,
				0,0,1,0, 
				0,1,0,0,
				0,1,0,1,
				1,1,0,1,
			],inf),
			\lag, 0.0009,
			\dur, 1/2,
		),
	])
)).play;
);


//////// main

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pdef(\passage2),
		Pfindur(16,Pdef(\passage1)),
		Pfindur(32,Pdef(\part1)),
		
	])
)).play;
)

//////// draft

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(6,Pdef(\drums1)),
			Pfindur(2,Pdef(\drums2)),
		],1),
	])
)).play;
);


(
SynthDef(\jojo, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,2,10],[8,8]/~t), 1);
	env2 = EnvGen.kr(Env([0.3,1],[16]/~t), 1);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) * env1 + 1));
	sig = sig * SinOsc.ar(freq * [1/2,1,2,4]  );
	//sig = BPF.ar(sig, freq* [1/2,1,2,4], env2);
	sig = CombL.ar(sig, 4/~t, 1/3/~t * ( SinOsc.kr(0.1) * 0.03 + 1 ),1/~t) + sig;
	sig = sig * SinOsc.ar(4*~t,add:0.4).clip(0,1);
	//sig = sig * ( SinOsc.ar( XLine.kr(1,8,16/~t)*~t) * 0.6 + 1 );
	sig = LPF.ar(sig, XLine.kr(100,17000,16/~t));
	//env1 = EnvGen.kr(Env([20,20,10000],[16,16]/~t), 1);
	//sig = HPF.ar(sig, env1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.2) * Line.kr(0,1,16/~t), \room.kr(1), \damp.kr(0.4));
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\jojo,
			\note, Pseq([
				-1,-7
			],inf).stutter(4),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pfindur(16,Pmono(\jojo,
			\note, Pseq([
				-1,-7
			],inf).stutter(4),
			\dur, 1,
			\amp, 0.1,
		)),
	])
)).play;
);


(
SynthDef(\zip1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq= 800;
	env1 = Env([14,9,0.1],[0.9,0.1]/~t,3).kr;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.7) + 1) * env1 * ( LFSaw.ar(freq * 1.423 * 1/2 * env1) * 1 + 1 ));
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.04,0.02)*0.81) + sig;
	sig = HPF.ar(sig, XLine.kr(16000,8090,1/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1/~t,0.1,1,0.01,1,2)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\legato,1,
			\instrument, \zip1,
			\freq, 200,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\zip2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq= XLine.kr(1300,6000,1/~t);
	env1 = Env([14,9,0.1],[0.9,0.1]/~t,3).kr;
	sig = SinOsc.ar(freq * [1,2,4] * ( LFSaw.ar(freq/2) * XLine.kr(100,40,1/~t) + 1 ));
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.02,0.05)*0.31) + sig;
	sig = HPF.ar(sig, XLine.kr(1600,10080,1/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1/~t,0.1,1,0.01,1,2)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
SynthDef(\zip2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq= XLine.kr(1300,6000,1/~t);
	env1 = Env([14,9,0.1],[0.9,0.1]/~t,3).kr;
	sig = SinOsc.ar(freq * [1,2,4] * ( LFSaw.ar(freq/2) * XLine.kr(100,40,1/~t) + 1 ));
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.02,0.05)*0.31) + sig;
	sig = LPF.ar(sig, XLine.kr(160,10080,1/~t));
	sig = HPF.ar(sig, XLine.kr(60,2080,1/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1/~t,0.1,1,0.01,1,2)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
SynthDef(\zip2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq= XLine.kr(13000,600,1/~t);
	env1 = Env([14,9,0.1],[0.9,0.1]/~t,3).kr;
	sig = SinOsc.ar(freq * [1,2,4] * ( LFSaw.ar(freq/2) * XLine.kr(0.1,44,1/~t) + 1 ));
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.02,0.05,1/~t)*0.31) + sig;
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.2,0.01,1/~t)*0.41) + sig;
	sig = LPF.ar(sig, XLine.kr(160,14080,1/~t));
	sig = HPF.ar(sig, XLine.kr(60,12080,1/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1/~t,0.1,1,0.01,1,4)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\legato,1,
			\instrument, \zip2,
			\freq, 200,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\zip3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 8;
	freq= XLine.kr(1130,5600,len/~t);
	env1 = Env([14,9,0.1],[0.9,0.1]*len/~t,3).kr;
	sig = SinOsc.ar(freq * [1,2,4] * ( LFSaw.ar(freq/2) * XLine.kr(10.1,44,len/~t) + 1 ));
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.02,0.05,len/~t)*0.31) + sig;
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.2,0.01,len/~t)*0.41) + sig;
	sig = LPF.ar(sig, XLine.kr(360,9080,len/~t));
	sig = HPF.ar(sig, XLine.kr(360,12080,len/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(len/~t,0.1,1,0.01,1,4)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
SynthDef(\zip3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var len = 8;
	//freq= XLine.kr(9130,5600,len/~t);
	freq = EnvGen.kr(Env([7000,4000,180],[0.6,0.4]*len/~t, -2), 1);
	env1 = Env([14,9,0.1],[0.9,0.1]*len/~t,3).kr;
	sig = SinOsc.ar(freq * [1,2,4] * ( LFSaw.ar(freq * XLine.kr(8,0.5,len/~t)) * XLine.kr(70.1,44,len/~t) + 1 ));
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.02,0.05,len/~t)*0.31) + sig;
	sig = DelayL.ar(sig, 0.2, XLine.kr(0.002,[ 0.01,0.02 ],len/~t)*0.41) + sig;
	sig = LPF.ar(sig, XLine.kr(17600,5980,len/~t));
	sig = HPF.ar(sig, XLine.kr(7360,880,len/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(len/~t,0.1,1,0.01,1,4)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\legato,1,
			\instrument, \zip3,
			\freq, 200,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 8,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\clokverb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num = 8;
	var in;
	var freqs = [ 988.4455897338, 69.993030548994, 503.09104435907, 237.82167708897, 81.754651308933, 477.02782752208, 189.80505561986, 129.09602373581  ];
	//sig = SinOsc.ar(freq);
	sig = Impulse.ar(0);
	sig = sig + LFSaw.ar( XLine.kr(301,50,0.02) );
	sig = sig + ( Klang.ar(Ref([freqs * ( Rand(-1.0,1!num) * 0.1 + 1 ).postln])) * 0.3 );

	sig = sig * EnvGen.ar( Env([1,0,0],[0.01,0.8]),gate,doneAction:0);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	in = sig;
	sig = GVerb.ar(sig);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
//Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pmono( \clokverb,
			//\freq, 200,
			//\dur, 1,
			//\amp, 0.1,
		//),
		Pbind(
			\instrument, \clokverb,
			\freq, 200,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);



(
SynthDef(\snareverb, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num = 8;
	var in;
	var freqs = [ 988.4455897338, 69.993030548994, 503.09104435907, 237.82167708897, 81.754651308933, 477.02782752208, 189.80505561986, 129.09602373581  ];
	//sig = SinOsc.ar(freq);
	//sig = Impulse.ar(0);
	sig = 0;
	sig = sig + LFSaw.ar( XLine.kr(301,50,0.02) );
	//sig = sig + ( Klang.ar(Ref([freqs * ( Rand(-1.0,1!num) * 0.1 + 1 ).postln])) * 0.3 );

	sig = sig * EnvGen.ar( Env([1,0,0],[0.01,0.8]),gate,doneAction:0);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	in = sig;
	sig = GVerb.ar(sig, roomsize:18,revtime:1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,3.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);


(
SynthDef(\snareverb2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var input, output, delrd, deltimes;
	sig = LFSaw.ar( XLine.kr(301,50,0.02) );
	sig = sig * EnvGen.ar( Env([1,0,0],[0.01,0.8]),gate,doneAction:0);
	//sig = AllpassL.ar(sig, 4/~t, 1/8/8/8/~t,1/~t) + sig;


	// Choose which sort of input you want by (un)commenting these lines:
	input = sig;
	delrd = LocalIn.ar(4);
	output = input + delrd[[0,1]];
	sig = output ++ delrd[[2,3]];
	sig = ([ [1,  1,  1,  1],
	         [1, -1,  1, -1],
	         [1,  1, -1, -1],
	         [1, -1, -1,  1]] * sig).sum;
	sig = sig * [0.4, 0.37, 0.333, 0.3];
	deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
	LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
	sig = output;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snareverb3,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\snareverb3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var in;
	sig = LFSaw.ar( XLine.kr(301,50,0.02) );
	sig = sig * EnvGen.ar( Env([1,0,0],[0.01,0.8]),gate,doneAction:0);
	//sig = AllpassL.ar(sig, 4/~t, 1/8/8/8/~t,1/~t) + sig;

	//sig = GVerb.ar(sig);
	in = sig;
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06), 3);
	};
	LocalOut.ar(sig);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset.play;
);
