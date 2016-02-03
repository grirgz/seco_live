(
TempoClock.default.tempo = 130/60;
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;
~t = TempoClock.default.tempo;
SynthDef(\hat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(11100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(3100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\hat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\snare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([4000,4400,1700],[0.04,0.7],-4), 1) * \env1scale.kr(1);
	sig1 = RLPF.ar(sig, env1 , \rq.kr(0.5) * [1,0.5]) * [1,0.7];
	env2 = EnvGen.kr(Env([1000,4400,1700],[0.01,0.7],-4), 1) * \env2scale.kr(1);
	sig2 = RLPF.ar(sig, env2 , \rq.kr(0.5) * [1,0.5]) * [1,0.7];
	sig = [sig1, sig2];
	//sig = [FreqShift.ar(sig, -220) , sig];
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ]) + sig;
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ] * 4.11) + sig;
	sig = 4.collect { arg x;
		var isig = DelayL.ar(sig, 0.1,0.01 * ( x/40 )) + sig;
		isig = DelayL.ar(isig, 0.1, [ 1/8000, 1/7000 ] * 0.98 * ( x/10 )) + sig;
	};
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\env.kr(Env.perc(0.01,0.2,1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\snare2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmf;
	sig1 = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([freq,freq*2,4541],[0.01,0.08]), 1);
	sig1 = BPF.ar(sig1, env1);
	sig2 = WhiteNoise.ar;
	env2 = EnvGen.kr(Env([freq,freq*2,8541],[0.04,0.08]), 1);
	sig2 = BPF.ar(sig2, env2);

	fmf = freq * [1,1/4];
	env3 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig3 = SinOsc.ar(fmf * ( 1 + ( SinOsc.ar(fmf * 8/10) * env3 )));
	sig = [sig1, sig2];
	sig = sig * EnvGen.kr(Env.perc(0.0001,0.02), gate);
	sig = sig + sig3;
	//sig = [sig1, sig2] * 2;
	sig = DelayL.ar(sig, 0.1, [ 1/8000, 1/7000 ] * 1744.11) + sig;
	sig = sig * EnvGen.kr(Env.perc(0.0001,0.2), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\kick2, Pbind(
	\instrument, \dr_kick,
	\env1, Pseq([
		[ Env.new([80, 32, 29], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.1,0], [0.055, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.4
)).play;
);

(
Pdef(\snare, 

	Pbind(
		\instrument, \snare,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,1,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,

			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,
		],inf).coin.not,
		\amp, 0.1/4
	)
	<>
	Pbind(
		\env, Pseq([
			[ Env.perc(0.01,0.2) ],
			[ Env.perc(0.01,0.2) ],
				//[ Env.perc(0.02,0.4) ]
		],inf),
		\env1scale, Pseq([1,1,2,0.2],inf),
		//\env2scale, Pseq([1,[0.4,0.8]],inf),
		//\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf),
	).stutter(8)

).play;
);


(
Ndef(\fx1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	in = in * SinOsc.ar(freq);
}).play;
);

(
Ndef(\fx1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var nfreq;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = sig;

	nfreq = 1/8;
	sig1 = DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*16*~t).range(0.1,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*4*~t).range(0.1,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 1.4, LFNoise0.kr(nfreq*4*~t).range(1.4,0.001));
	sig1 = LPF.ar(sig1, 1000 * LFNoise0.kr(1/2 * ~t).range(4,0.1));
	sig = sig + sig1;
	//sig = sig1;
	sig;
}).play;
);

(
Ndef(\fx1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var nfreq;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = sig;

	nfreq = 1/8;
	sig1 = DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*16*~t).range(0.1,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*4*~t).range(0.1,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001));
	sig1 = sig1 + DelayL.ar(sig1, 1.4, LFNoise0.kr(nfreq*4*~t).range(1.4,0.001));
	sig1 = LPF.ar(sig1, 1000 * LFNoise0.kr(1/4 * ~t).range(4,0.1));
	sig = sig + sig1;
	//sig = sig1;
	sig;
}).play;
);

(
Ndef(\fx1).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var nfreq;
	var sigt;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = sig;

	nfreq = 1/8;
	sigt = sig1;
	sig1 = DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*16*~t).range(0.1,0.001));
	sig1 = SelectX.ar(\mix1.kr(0.5), [sigt, sig1]);
	sigt = sig1;
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001));
	sig1 = SelectX.ar(\mix2.kr(0.5), [sigt, sig1]);
	sigt = sig1;
	sig1 = sig1 + DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*4*~t).range(0.1,0.001));
	sig1 = SelectX.ar(\mix3.kr(0.5), [sigt, sig1]);
	sigt = sig1;
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001));
	sig1 = SelectX.ar(\mix4.kr(0.5), [sigt, sig1]);
	//sig1 = sig1 + DelayL.ar(sig1, 1.4, LFNoise0.kr(nfreq*4*~t).range(1.4,0.001));
	sig1 = LPF.ar(sig1, \lpf.kr(5000).lag(0.1));
	sig = sig + sig1;
	//sig = sig1;
	sig;
}).play;
);

(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([250,500,1000,2000],1),
		Pseq([5000,100,8000,2000],1),
	],inf),
	\dur, 1,
	\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)

(
Ndef(\fx2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var nfreq, del;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = sig;

	nfreq = 1;
	del = 1/8;
	sig1 = DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*16*~t).range(0.1,0.001) * del);
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001) * del);
	sig1 = sig1 + DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*4*~t).range(0.1,0.001) * del);
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001) * del);
	sig1 = sig1 + DelayL.ar(sig1, 1.4, LFNoise0.kr(nfreq*4*~t).range(1.4,0.001) * del);
	//sig1 = LPF.ar(sig1, 1000 * LFNoise0.kr(1/4 * ~t).range(4,0.1));
	sig1 = HPF.ar(sig1, 100 * LFNoise0.kr(1/4 * ~t).range(4,0.1));
	sig1 = sig1 * 0.2;
	sig = sig + sig1;
	//sig = sig1;
	sig;
}).play;
);

(
Ndef(\fx2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var nfreq, del;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = sig;

	nfreq = 1/8;
	del = 1/8;
	sig1 = DelayL.ar(sig1, 0.1, LFNoise0.kr(nfreq*16*~t).range(0.1,0.001) * del);
	sig1 = sig1 + DelayL.ar(sig1, 0.4, LFNoise0.kr(nfreq*4*~t).range(0.4,0.001) * del);
	sig1 = LPF.ar(sig1, 1000 * LFNoise0.kr(1/4 * ~t).range(4,0.1));
	sig1 = sig1 * 0.2;
	sig = sig + sig1;
	//sig = sig1;
	sig;
}).play;
);

///////////////// control delays
(
Ndef(\fx1).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var nfreq;
	var sigt;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = sig;

	nfreq = 1/8;
	sigt = sig1;
	sig1 = DelayL.ar(sig1, 0.5, \del1.kr(0.01));
	sig1 = SelectX.ar(\mix1.kr(0.5), [sigt, sig1]);
	sigt = sig1;
	sig1 = sig1 + DelayL.ar(sig1, 0.5, \del2.kr(0.01));
	sig1 = SelectX.ar(\mix2.kr(0.5), [sigt, sig1]);
	sigt = sig1;
	sig1 = sig1 + DelayL.ar(sig1, 0.4, \del3.kr(0.01));
	sig1 = SelectX.ar(\mix3.kr(0.5), [sigt, sig1]);
	sigt = sig1;
	sig1 = sig1 + DelayL.ar(sig1, 0.4, \del4.kr(0.01));
	sig1 = SelectX.ar(\mix4.kr(0.5), [sigt, sig1]);
	//\del1.kr.poll;
	//sig1 = sig1 + DelayL.ar(sig1, 1.4, LFNoise0.kr(nfreq*4*~t).range(1.4,0.001));
	sig1 = LPF.ar(sig1, \lpf.kr(5000).lag(0.1));
	sigt = sig;
	sig = sig + sig1;
	sig = SelectX.ar(\mixm.kr(1).lag(0.05), [sigt, sig]);
	//sig = sig1;
	sig;
}).play;
);

(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([250,500,1000,2000],1),
		Pseq([5000,100,8000,2000],1),
	],inf),
	\dur, 1,
	[\del1, \del2, \del3, \del4], Pseq([
		1/16 !4,
		1/16 !4,
		1/16 !4,
		1/16 !4,

		1/16 !4,
		(1..4)/4 / 4,
		1/16 !4,
		1/8 !4,
	],inf),
	//\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)

(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([250,500,1000,2000],1),
		Pseq([5000,100,8000,2000],1),
	],inf),
	\dur, 1,
	[\del1, \del2, \del3, \del4], Pseq([
		1/2 !4,
		1/2 !4,
		1/2 !4,
		1/2 !4,

		1/16 !4,
		(1..4)/4 / 4,
		1/16 !4,
		1/8 !4,
	],inf) / ~t,
	//\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)


(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([5000,100,100,100],1)
	],inf),
	\dur, 1,
	[\del1, \del2, \del3, \del4], Pseq([
		1/2 !4,
		1/2 !4,
		1/2 !4,
		1/2 !4,

		1/16 !4,
		(1..4)/4 / 4,
		1/16 !4,
		1/8 !4,
	],inf) / ~t,
	//\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)

(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([5000,100,100,100],1),
		Pseq([5000,100,100,100],1),
		Pseq([5000,100,100,100],1),
		Pseq([500,100,1000,2100],1),
	],inf),
	\dur, 1,
	[\del1, \del2, \del3, \del4], Pseq([
		1/2 !4,
		1/2 !4,
		1/2 !4,
		1/2 !4,

		1/4 !4,
		1/2 !4,
		1/8 !4,
		1/2 !4,

		1/2 !4,
		1/2 !4,
		1/2 !4,
		1/16 !4,

		1/2!4,
		1/2 !4,
		1/2 !4,
		1/6 !4,
	],inf) / ~t,
	//\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)

(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([1500,1000,1000,1000],1),
	],inf),
	\dur, 1/2,
	[\del1, \del2, \del3, \del4], Pseq([
		(1..4)/1,
		1/2 * { 1+0.01.rand } ! 4,
		1/4 * { 1+0.01.rand } ! 4,
		1/2 * { 1+0.01.rand } ! 4,

		Pfuncn({ [1.0.rand,1.0.rand,1.0.rand,0.2.rand]/5 },1),
		(1..4)/4,
		(1..4)/4,
		Pfuncn({ [1/4,1,1.0.rand,0.2.rand]/4 },1),
	],inf) / ~t,
	//\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)

(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([1500,1000,1000,1000],1),
	],inf),
	\dur, 1/2,
	[\del1, \del2, \del3, \del4], Pseq([
		1/8 * { 1+0.01.rand } ! 4,
		1/8 * { 1+0.01.rand } ! 4,
		1/2 * { 1+0.01.rand } ! 4,
		1/2 * { 1+0.01.rand } ! 4,

		(1..4)/1,
		1/2 * { 1+0.01.rand } ! 4,
		1/4 * { 1+0.01.rand } ! 4,
		1/2 * { 1+0.01.rand } ! 4,

	],inf) / ~t,
	//\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)

(
Ndef(\fx1)[10] = \set -> Pbind(
	\lpf, 
	Pseq([
		Pseq([1500,1000],1),
	],inf),
	\dur, 1/4,
	[\del1, \del2, \del3, \del4], Pseq([
		1/1 * { 1+0.0001.rand } ! 4,
		1/4 * { 1+0.0001.rand } ! 4,
		1/1 * { 1+0.0001.rand } ! 4,
		1/2 * { 1+0.0001.rand } ! 4,

		1/4 * { 1+0.0001.rand } ! 4,
		1/1 * { 1+0.0001.rand } ! 4,
		1/4 * { 1+0.0001.rand } ! 4,
		1/1 * { 1+0.0001.rand } ! 4,
	],inf).stutter(4*4) / ~t,
	\mixm, Pseq([
		1,1,0,1,
		1,0,1,0,
		1,1,1,0,
		1,0,1,0,

		0,0,0,1,
		0,0,0,1,
		0,0,0,1,
		1,1,1,1,

		1,1,0,1,
		0,0,1,0,
		0,0,0,0,
		1,1,1,1,
	],inf),
	\mix1, 1,
	\mix2, 1,
	\mix3, 1,
	\mix4, 1,
	//\mix1, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix2, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
	//\mix3, Pseq([0,0,0,0, 0,0,0,1],inf).stutter(2),
);
)

////////////////////// players

Pdef(\snare).play
Pdef(\kick2).play
Pdef(\niark).play
Pdef(\hat2).play
Ndef(\fx1).play
Ndef(\fx2).play
Pdef(\snare).set(\out, BusDef(\fx1, \audio))
Pdef(\kick2).set(\out, BusDef(\fx2, \audio))
Pdef(\hat2).set(\out, BusDef(\fx1, \audio))
Ndef(\fx1).set(\inbus, BusDef(\fx1, \audio))
Ndef(\fx2).set(\inbus, BusDef(\fx2, \audio))

Pdef(\kick2).set(\out, 0)
(
Pdef(\hat2, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\sustain, 0.05,
	\isRest, Pseq([
		0,0,1,1, 1,1,1,0,
		0,0,1,0, 1,0,1,0, 
	],inf).coin.not,
	\rel, Pseq([ 
		0.1,
	],inf).stutter(2),
	\amp, 0.01
)).play;
);

(
Pdef(\hat2, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\sustain, 0.05,
	\isRest, Pseq([
		0,0,1,1, 1,1,1,0,
		0,0,1,0, 1,0,1,0, 
	],inf).coin.not,
	\rel, Pseq([ 
		0.1,
	],inf).stutter(2),
	\amp, 0.01
)).play;
);

(
Pdef(\snare, 

	Pbind(
		\instrument, \snare,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,1,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,

			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,
		],inf).coin.not,
		\amp, 0.1/4
	)
	<>
	Pbind(
		\env, Pseq([
			[ Env.perc(0.01,0.1) ],
			[ Env.perc(0.01,0.2) ],
			[ Env.perc(0.01,0.1) ],
			[ Env.perc(0.01,0.4) ],
				//[ Env.perc(0.02,0.4) ]
		],inf),
		\env1scale, Pseq([1,1,2,0.2],inf),
		\env2scale, Pseq([1,0.4,0.8],inf),
		//\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf),
	).stutter(8)

).play;
);

(
Pdef(\kick2, Pbind(
	\instrument, \dr_kick,
	\env1, Pseq([
		[ Env.new([80, 37, 22], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.7,0], [0.055, 0.10,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 2,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,
	\fratio, 2,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.4
)).play;
);


/////////////////////////

(
SynthDef(\niark, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var pamp = \pamp.kr(1);
	freq = freq * ( 1 + ( SinOsc.ar((1..4)*freq/2 * SinOsc.kr((1..4)).range(1.01,1)) * 1 ));
	sig = SinOsc.ar(freq);
	sig = (sig * 100).tanh;
	sig = RLPF.ar(sig, \lpf.kr(200));
	sig = HPF.ar(sig, \hpf.kr(70));
	sig = BRF.ar(sig, 1200);
	sig = BRF.ar(sig, 1000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = pamp * sig;
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\niark, Pbind(
	\instrument, \niark,
	\lpf, Ndef(\niarklfo1, { LFSaw.kr(2 * ~t).range(50,4100)  }),
	\degree, Pseq([0],inf),
	\octave, 3,
	\dur, 4,
	\amp, 0.1
)).play;
);
Pdef(\niark).stop;

(
Pdef(\niark, Pbind(
	\instrument, \niark,
	\lpf, Ndef(\niarklfo1, { LFSaw.kr(2 * ~t).range(50,4100)  }),
	\degree, Pseq([0],inf),
	\octave, 3,
	\pamp, Ndef(\niarklfo2, { LFPulse.kr(
		Duty.kr(1/~t, 0, Dseq([
			1,1,1,1,
			1,1,1,1,
			1,2,1,1,
			1,1,4,1,
		],inf)) * ~t).range(0,1)  }),
	\dur, 4,
	\amp, 0.1
)).play;
);

(
Pdef(\niark, Pbind(
	\instrument, \niark,
	\lpf, Ndef(\niarklfo1, { LFSaw.kr(2 * ~t).range(50,4100)  }),
	\degree, Pseq([0,0,7,7,4,2,7,7],inf),
	\octave, 3,
	\pamp, Ndef(\niarklfo2, { LFPulse.kr(
		Duty.kr(1/~t, 0, Dseq([
			1,1,1,1,
			1,1,1,1,
			1,2,1,1,
			1,1,4,1,
		],inf))*2 * ~t, 0, 0.9).range(0,1)  }),
	\dur, 1/4,
	\legato, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\niark, Pbind(
	\instrument, \niark,
	\lpf, Ndef(\niarklfo1, { LFSaw.kr(
		Duty.kr(4/~t, 0, Dseq([
			1,1/2,1/8,1/2,
			4,2,8,2,
		],inf)) * ~t,0.3).range(50,1400)
	}),
	\degree, Pseq([0,0,7,7,4,2,7,7],inf),
	\octave, 3,
	\pamp, Ndef(\niarklfo2, {
		Duty.kr(1/4/~t, 0, Dseq([
			1,0,0,0, 1,0,1,0,
			1,1,0,0, 1,0,1,0,
			1,1,0,1, 1,0,1,1,
			1,1,1,1, 1,1,1,1,
		],inf)).lag(0.05)
	}),
	\dur, 1/4,
	\legato, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\niark, Pbind(
	\instrument, \niark,
	\lpf, Ndef(\niarklfo1, { LFSaw.kr(
		Duty.kr(4/~t, 0, Dseq([
			1,1/2,1/8,1/2,
			4,2,8,2,
		],inf)) * ~t,0.3).range(50,1400)
	}),
	\degree, Pseq([0,0,2,2],inf),
	\scale, Scale.minor,
	\octave, 3,
	\pamp, Ndef(\niarklfo2, {
		Duty.kr(1/4/~t, 0, Dseq([
			1,1,0,0,
			1,1,0,0,
			1,1,0,0,
			1,1,0,0,
			0,0,0,0,
			1,0,1,1,
			0,0,1,0,
			1,0,1,1,
		],inf)).lag(0.05)
	}),
	\dur, 1/4,
	\legato, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\niark, Pbind(
	\instrument, \niark,
	\lpf, Ndef(\niarklfo1, { LFSaw.kr(
		Duty.kr(1/~t, 0, Dseq([
			1,1/8,1/8,1/8,
			2,1/4,1/4,1/4,
			1,1/8,1/8,1/8,
			1,1/4,1/4,1/4,
		],inf)) * ~t,0.3).exprange(10,7400).clip(100,4000)
	}),
	\degree, Pseq([0,0,2,2],inf),
	\scale, Scale.minor,
	\octave, 3,
	\hpf, Pseq([
		200,70,170,100,
		20,70,17,10,
	],inf),
	\dur, 1/4,
	\legato, 1,
	\amp, 0.1
)).play;
);


////////////////////////////


(
SynthDef(\glue, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * ( 1 + ( SinOsc.kr(freq*4) * 1 ));
	freq = freq * ( 1 + ( SinOsc.kr(freq*4) * 1 ));
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq*2);
	//freq.poll;
	sig = RLPF.ar(sig, 17000) + BPF.ar(sig, 1000, mul:1/2);
	sig = HPF.ar(sig, \hpf.kr(4500));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig /1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\glue, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = ((0..7)/7 - 0.5 * 0.01 + 1) * freq;
	sig = SinOsc.ar(freq);
	sig = sig + LFSaw.ar(freq*2);
	//freq.poll;
	//sig = RLPF.ar(sig, 17000) + BPF.ar(sig, 1000, mul:1/2);
	sig = HPF.ar(sig, \hpf.kr(4500));
	sig = sig /2;
	sig = CombL.ar(sig, 0.1,0.1,1) + sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\glue, Pbind(
	\instrument, \glue,
	\degree, Pseq([0,3,2,1],inf),
	\octave, 6,
	\isRest, Pseq([
		1,0,0,1, 1,0,1,0,
		1,0,0,1, 1,0,1,0,
		1,0,0,1, 1,0,1,0,
		0,1,1,1, 0,1,1,0,
	],inf).coin.not,
	\legato,2,
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
Pdef(\glue, Pbind(
	\instrument, \glue,
	\degree, Pseq([0,3,2,1],inf),
	\octave, 6,
	\isRest, Pseq([
		1,0,0,1, 1,0,1,0,
		1,0,0,1, 1,0,1,0,
		1,0,0,1, 1,0,1,0,
		0,1,1,1, 0,1,1,0,
	],inf).coin.not,
	\legato,2,
	\hpf, 1000,
	\dur, 1/4,
	\amp, 0.1
)).play;
);
