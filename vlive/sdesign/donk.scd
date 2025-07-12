
// hard bass donk


~t = 155/2/60; TempoClock.default.tempo = ~t;
////////////////
(
// nice simple
SynthDef(\donk, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.2],-4), 1) * 0.9 + 1;
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.4],-8), 1) * 4;
	sig1 = ( LFSaw.ar(freq*2) * env2 );
	sig = SinOsc.ar(freq * ( sig1 + 1 ));
	//sig = sin(sig*2);
	sig = LeakDC.ar(sig);
	sig = sig + SinOsc.ar(freq/2,mul:0.5); // subbass; 
	//sig = RLPF.ar(sig, \lpf.kr(200) * env1, \rq.kr(0.3));
	//sig = LPF.ar(sig, \lpf.kr(300) * env1);
	//sig = sig * 8;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.009,0.2,0.01,0.01,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// nice dist
SynthDef(\donk, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.2],-4), 1) * 0.9 + 1;
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.4],-8), 1) * 4;
	sig1 = ( LFSaw.ar(freq*2) * env2 );
	sig = SinOsc.ar(freq * ( sig1 + 1 )) * 0.4;
	sig = sig + SinOsc.ar(freq/2 * ( sig1 * 5 + 1 ));
	//sig = sin(sig*2);
	sig = LeakDC.ar(sig);
	sig = sig + SinOsc.ar(freq/2,mul:0.5); // subbass; 
	//sig = RLPF.ar(sig, \lpf.kr(200) * env1, \rq.kr(0.3));
	//sig = LPF.ar(sig, \lpf.kr(300) * env1);
	//sig = sig * 8;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.009,0.2,0.01,0.01,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\donk, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.2],-4), 1) * 0.9 + 1;
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.4],-8), 1) * 4;
	env3 = EnvGen.kr(Env([0,1,0],[0.01,0.01],-3), 1) * 4;
	sig2 = LFCub.ar(freq*[2,3,7]) * env3 * 8.311;
	sig1 = ( SinOsc.ar(freq * ( sig2 + 1 )) * env2 );
	sig = SinOsc.ar(freq/2 * ( sig1 * 5 + 1 ));
	sig = sig + SinOsc.ar(freq * ( sig1 * 1 + 1 ));
	sig = sig.mean;
	//sig = sin(sig+0.2);
	sig = LeakDC.ar(sig);
	sig = sig + SinOsc.ar(freq/2,mul:0.5); // subbass; 
	//sig = RLPF.ar(sig, \lpf.kr(200) * env1, \rq.kr(0.3));
	//sig = LPF.ar(sig, \lpf.kr(300) * env1);
	//sig = sig * 8;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.009,0.2,0.01,0.01,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
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
