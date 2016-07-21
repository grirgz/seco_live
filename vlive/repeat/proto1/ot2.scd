
(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var size = 100;
	var trig = Impulse.kr({ rrand(1/100,100.0) } ! size * \density.kr(1));
	sig = SinGrain.ar(trig,0.1, { exprand(100.0,16000) } ! size * \tone.kr(1)) * ( { rrand(0.01,1) } ! size );
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 100;
	var trig = Impulse.kr({ rrand(1/100,100.0) } ! size * \density.kr(1));
	sig = SinGrain.ar(trig,0.1, { exprand(100.0,16000) } ! size * \tone.kr(1)) * ( { rrand(0.01,1) } ! size );
	sig = sig.collect({ arg sig, x;
		sig = sig.fold2( SinOsc.kr(1/23 * ( x+1 ) * speed).range(0.01,8) ) * 4;
		sig = sig * SinOsc.kr(1/26 * ( x+1 ) * speed).range(0.01,1);
	});
	sig = Pan2.ar(sig, ( { rrand(-1.0,1) } ! size ), amp).mean;
}).play;
);

(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 20;
	var trig = Impulse.ar({ rrand(1/1,15.0) } ! size * \density.kr(1));
	//sig = SinGrain.ar(trig,0.1, { exprand(50.0,16000) } ! size * \tone.kr(1)) * ( { rrand(0.01,1) } ! size );
	sig = { WhiteNoise.ar } ! size;
	sig = sig.collect({ arg sig, x;
		var bpfreq = exprand(50.0,16000) * \tone.kr(1);
		var bpfrq = 0.1 * SinOsc.ar(( x+1 ) * 1/153 * speed).exprange(0.1,4) * \blur.kr(1);
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 34;
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 4;
		sig = sig * EnvGen.ar(Env([0,1,0],[0.1,0.8]), trig[x]);
		//sig = sig.fold2( LFNoise0.kr(1/23 * ( x+1 ) * speed).range(0.01,8) ) * 4;
		sig = sig * SinOsc.ar(1/700 * ( x+1 ) * speed).range(0.01,1);
	});
	sig = Pan2.ar(sig, ( { rrand(-1.0,1) } ! size * SinOsc.ar(1/132 * (1..size) * speed).range(0,1) ), amp).mean;
}).play;
);
Ndef(\snow).edit
Ndef(\snow).fadeTime = 16

(1..10).size
( { rrand(-1.0,1) } ! size * SinOsc.kr(1/132 * (1..size) * speed).range(0,1) )
1

[1,2] * [1,2]

(
Ndef(\snow, { arg freq=200, pan=0, amp=0.1, speed=1;
	var sig;
	var size = 20;
	var trig = Impulse.ar({ rrand(1/1,15.0) } ! size * \density.kr(1));
	//sig = SinGrain.ar(trig,0.1, { exprand(50.0,16000) } ! size * \tone.kr(1)) * ( { rrand(0.01,1) } ! size );
	sig = { WhiteNoise.ar } ! size;
	sig = sig.collect({ arg sig, x;
		var bpfreq = exprand(50.0,16000) * \tone.kr(1);
		var bpfrq = 0.1 * SinOsc.ar(( x+1 ) * 1/153 * speed).exprange(0.1,4) * \blur.kr(1);
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 34;
		sig = BPF.ar(sig,  bpfreq, bpfrq) * 4;
		sig = sig * EnvGen.ar(Env([0,1,0],[0.1,0.8]), trig[x]);
		//sig = sig.fold2( LFNoise0.kr(1/23 * ( x+1 ) * speed).range(0.01,8) ) * 4;
		sig = sig * SinOsc.ar(1/700 * ( x+1 ) * speed).range(0.01,1);
	});
	sig = Pan2.ar(sig, ( { rrand(-1.0,1) } ! size * SinOsc.ar(1/132 * (1..size) * speed).range(0,1) ), amp).mean;
}).play;
);


(
SynthDef(\soufle, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var size = 10;
	var col = (1..size);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = size.collect { arg x;
		var xx = x+1;
		//sig = SinOsc.ar(exprand(100.0,13000));
		sig = WhiteNoise.ar;
		env1 = EnvGen.kr(Env([size-x/size+0.01,x/size+0.01,1],[0.1,0.8]), 1);
		sig = BPF.ar(sig, exprand(100.0,13000) * (rrand(-1,1) * \tone.kr(0) + 1), rrand(0.01,0.1) * env1) * 7;
		sig = sig * EnvGen.kr(Env([1,0,1,0],[0.1/(x),0.01,0.1 +(x/10)]), 1);
		sig;
	};
	sig = sig * 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.4,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\soufle, Pbind(
	\instrument, \soufle,
	\degree, Pseq([0],inf),
	\legato, Prand([0.1,1.8],inf),
	\legato, 5,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\out, BusDef(\bus1),
	\amp, 0.3
)).play;
);

(
Pdef(\soufle, Pbind(
	\instrument, \soufle,
	\degree, Pseq([0],inf),
	\legato, Prand([0.1,1.8],inf),
	\legato, 0.5,
	\tone, Pwhite(0.9,1),
	\tone, Pseq([
		0.91,0.5,
	],inf).stutter(8),
	\tone, Pseg(Pseq([0.1,1],inf),8),
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	//\out, BusDef(\bus1),
	\amp, 0.3
)).play;
);
