(
Pdef(\t, Pbind(
	\t, Pfuncn({
		TempoClock.beatInBar.postln;
	},inf),
	\dur, Pseq([
		Pseq([1],3),
		Pseq([1/3],3),
	],inf),
)).play(quant: -1);
)


1/0.000000000001

Psync(4, )

(
Pdef(\t, 
	Psync(Pbind(
		\t, Pfuncn({
			TempoClock.default.beatInBar.postln;
			TempoClock.beats.postln;
		},inf),
		\dur, Pseq([
			Pseq([1],3),
			Pseq([1/3],3),
		],inf),
	), 4).loop
).play(quant: -1);
)


TempoClock.tempo = 120/60;
(
Routine({
	SynthDef(\kick, {
		arg freq=44, amp=1, dur=1, pan=0;
		var sig, env, fEnv, nEnv;
		env = Env.perc(0,dur*3);
		env = EnvGen.kr(env,
			doneAction:2);
		fEnv = Env.new([2,0],[dur/1]);
		fEnv = EnvGen.kr(fEnv);
		nEnv = Env.perc(0,dur/8);
		nEnv = EnvGen.kr(nEnv);
		sig = [
			SinOsc.ar(freq * fEnv, pi/2),
			BBandPass.ar(
				WhiteNoise.ar(nEnv),
				4200, 0.125, 2);
		];
		sig = Mix.ar(sig);
		sig = Pan2.ar(sig, pan);
		sig = sig * env * amp;
		Out.ar(0, sig);
	}).add;
	0.125.sleep;
	// Synth(\kick, [\freq, 44, \amp, 1]);
}).play;
)
(
SynthDef(\snare, {
	arg freq=440, amp=1, dur=1, pan=0;
	var sig, env, sEnv, resEnv;
	env = Env.perc(0.0,0.75);
	env = EnvGen.kr(env,
		doneAction:2);
	sEnv = Env.new([22000,100],[0.75],\exp);
	sEnv = EnvGen.kr(sEnv);
	resEnv = Env.new([2,0.125],[0.5]);
	resEnv = EnvGen.kr(resEnv);
	sig = {WhiteNoise.ar()}!2;
	sig = BBandPass.ar(sig, sEnv, resEnv);
	sig = sig * env * amp;
	sig = Splay.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(0, sig);
}).add;
)
Synth(\snare, [\freq, 54, \amp, 1]);

(
SynthDef(\hihat, {
	arg freq=440, amp=1, pan=0,
	fco=1200, res=0.5;
	var sig, env;
	env = Env.perc(0.01,0.125);
	env = EnvGen.kr(env,
		doneAction:2);
	sig = WhiteNoise.ar();
	sig = BBandPass.ar(sig, fco, res.linlin(0,1,2,0.125));
	sig = sig * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;
)
Synth(\hihat, [\freq, 54, \amp, 1]);

(
Pdef(\drums, Pbind(
	\melo, Pfuncn({
		arg e;
		var b;
		b = TempoClock.beatInBar;
		b.postln;
		case
		{b == 0} {\kick}
		{b == 1} {\snare}
		{b == 1.25} {\kick}
		{b == 2} {\kick}
		{b == 3} {\snare}
		{\hihat}
		;
	},inf),
	\instrument, Pwrand([
		Pkey(\melo,1), \kick, \snare, \hihat
	],[100,10,5,1].normalizeSum,inf),
	\freq, 35,
	\fco, Pexprand(14000,17000),
	\res, Pwhite(0.75,1),
	\pan, Pwhite(-0.75,0.75,inf),
	\amp, 0.75,
	\dur, Pwrand([
		Pseq([1/4],4),
		Pseq([1/4,1/2,1/4]),
		Pseq([1/2],2),
		Pseq([1/3],3), // < The problem
	],[10,10,10,0].normalizeSum,inf),
)).quant= -1;
)
Pdef(\drums).play();
Pdef(\drums).stop;

(2/3).equalWithPrecision((1/3) + (1/3))
(1/3) == ( (1/6) + (1/6) + (1/6) + (1/6))
