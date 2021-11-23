
~t = 1/2; TempoClock.default.tempo = ~t;
(
Ndef(\zed, { arg freq=(65.4), pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, -1,-1,-1,-5,
	],inf)).midiratio.lag2ud(0.2,2) * freq;
	sig = LFSaw.ar(freq * [1,1.01] * ( Saw.ar(freq+[0.01,0.02]) * 0.81 + 1 ) );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.ar(freq - 0.01 * [1,1.01]) * LFNoise1.kr(0.1).range(0,0.71) + 1 ), \rq.kr(0.1)) * 0.3;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\sawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq.lag2ud(\lagu.kr(0.1), \lagd.kr(2));
	sig = LFSaw.ar(freq * [1,1.01] * ( Saw.ar(freq+[0.01,0.02]) * 0.81 + 1 ) );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,4001.0) * ( SinOsc.ar(freq - 0.01 * [1,1.01]) * LFNoise1.kr(0.1).range(0,0.71) + 1 ), \rq.kr(0.1)) * 0.3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\sawbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,4,1],[0.1,1.8]), \itrig.tr(1));
	freq = freq.lag2ud(\lagu.kr(0.1), \lagd.kr(2));
	sig = LFSaw.ar(freq * [1,1.01] * ( SinOsc.ar(freq+[0.01,0.02]) * 0.81 + 1 ) );
	sig = RLPF.ar(sig, LFNoise1.kr(1/2).exprange(200.0,401.0) * env1 * ( SinOsc.ar(freq - 0.01 * [1,1.01]) * LFNoise1.kr(0.1).range(0,0.71) + 1 ), \rq.kr(0.1)) * 0.3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			\sawbass,
			\note, Pseq([
				0
			],inf),
			\itrig, Pseq([1,0],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1454].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1454].value,
			\isRest, Pseq([
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,0,  0,0,1, 1,0,1,
				0,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,1,  0,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2189].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		
	])
)).play;
);
