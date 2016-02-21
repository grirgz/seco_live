
190/02
(
TempoClock.default.tempo = 190/60;
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

SynthDef(\hat3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1!2);
	sig = RLPF.ar(sig, \lpf.kr(17100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(7100) * [[1,1/2]], \rq.kr(0.5), mul:[1,1/2]).mean;
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,\rel.kr(0.2),1,-3),gate,doneAction:2);
	sig = sig * 6;
	sig = Pan2.ar(sig, pan, amp).mean;
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

SynthDef(\zkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	//son = son * 1.2;
	//son = son.clip2(1);

	son = son * amp;
	son = son * env0 * 8;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	env0: XEnvSpec( ControlSpec(0,9,\lin)!4, ControlSpec(0,2,\lin)!4 ),
	env1: XEnvSpec( ControlSpec(0,127,\lin)!3, ControlSpec(0,2,\lin)!3 ),
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;

SynthDef(\zsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=20, fratio=1, timeScale=1;
	var sig;
	var env0, env1, env1m;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env2, env3, env4, env5, env6, env7, env8;
	var size;
	sig = SinOsc.ar(freq);
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.3], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([30, 92, 89], [0.005, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	//sig = SinOsc.ar(env1m, 0, 0.5, 1, -0.5);
	sig = WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1m*fratio);
	//sig = sig + SinOsc.ar(env1m, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	sig2 = WhiteNoise.ar;
	//env2 = EnvGen.kr(Env([4400,1000,100],[0.04,0.08]), 1);
	//sig2 = BPF.ar(sig2, env2);
	size = 12;
	sig2 = Klank.ar(Ref([ 
		size.collect({
			127+rrand(0,10)
		}) ++ size.collect({
			430+rrand(0,10)
		}),
		(size*2).collect({
			rrand(0.07,0.04)/100
		}),
	
	]), sig)/1*3;

	//sig1 = WhiteNoise.ar;
	//env1 = EnvGen.kr(Env([400,100,100],[0.01,0.08]), 1);
	//sig1 = BPF.ar(sig1, env1);
	////sig = sig * 1.2;
	////sig = sig.clip2(1);
	//sig = sig + ( ( sig2 + sig1 ) * 1/2 );
	//sig = sig/2;
	sig = sig + sig2;
	sig = sig2;

	sig = sig * amp;
	sig = sig * env0 * 8;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\snare808, { arg out=0,tu=1, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env = EnvGen.ar(Env.perc(0.01,1));
	var enf = EnvGen.ar(Env([200,430,127],[0.01,0.01],-4));
	sig = SinOsc.ar(tu*enf+127,0,0.5)*env;
	sig = WhiteNoise.ar+sig;
	sig = RHPF.ar(sig, \hpf.kr(170)*tu, \rq.kr(0.5));
	sig = sig + Mix.ar(BPF.ar(sig,[127,430],[0.5,0.5])*0.1);
	sig = RLPF.ar(sig, \lpf.kr(11100)*tu, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

(
SynthDef(\sossnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig1 = LFTri.ar(111);
	sig1 = FreqShift.ar(sig1, [175,224]).mean;
	sig2 = SinOsc.ar([180,330]).mean;
	sig = sig1 + sig2;
	sig = sig / 1;
	//sig = LPF.ar(sig, 1000);
	sig = sig * EnvGen.kr(Env.perc(0.001,0.03),gate,doneAction:0);
	//sig = Ringz.ar(sig + WhiteNoise.ar, { exprand(100,10000) }!20,0.01).mean / 8;

	sig3 = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([200,6420,200],[0.01,0.4],-2), 1);
	sig3 = LPF.ar(sig3, env1);
	sig3 = BPF.ar(sig3, env1 * [0.2,1,1.3]).mean;
	//sig3 = sig3 * EnvGen.kr(Env.perc(0.01,0.1,-4),gate,doneAction:0);

	sig = sig3 * 0.5 + sig;

	sig = sig * EnvGen.kr(Env.perc(0.01,0.3,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


)
Pdef(\snare).play

(
Pdef(\kick1, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.152
)).play;

Pdef(\snare, 

	Pbind(
		\instrument, \sossnare,
		//\env1, Pseq([
		//	[ Env.new([90, 38, 35], [0.005, 0.29], [-4, -5]) ],
		//],inf),
		//\freq, 1000,
		//\env0, Pseq([
		//	[ Env.new([0, 1, 0.8,0], [0.005, 0.09,0.1], [-4, -5]) ],
		//],inf),
		//\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\amp, 0.4,
	)
	<>
	Pbind(
		//\env, Pseq([
		//	[ Env.perc(0.01,0.2) ],
		//	[ Env.perc(0.01,0.2) ],
		//		//[ Env.perc(0.02,0.4) ]
		//],inf),
		//\env1scale, Pseq([1],inf),
		//\env2scale, Pseq([1,[0.4,0.8]],inf),
		//\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf),
	).stutter(8)

).play;

Pdef(\hat2, Pbind(
	\instrument, \hat3,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	//\sustain, 0.05,
	\isRest, Pseq([
		Pser([
			1,0,0,0,
		],12),
		//Pser([
		//	Prand([
		//		Pseq([
		//			0,1,
		//		],1),
		//		Pseq([
		//			1,1,
		//		],1),
		//		Pseq([
		//			1,0,
		//		],1),
		//	],1),
		//],4),
	],inf).coin.not,
	\legato, Pseq([ 
		Pser([
			0.11,
		],28),
		Pser([
			Prand([
				Pseq([
					0.1,
				],1),
				Pseq([
					0.2,0.1,
				],1),
			],1),
		],4*1)*4,
	],inf)*2,
	\amp, 0.01/2,
	\amp, Pkey(\amp) * Pseq([
		1,0.7,0.9,0.6,
	],inf),
)).play;
)


(
SynthDef(\fret, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.kr((1..5)/10).range(0,1)  *2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
	Pdef(\fret,
		Pbind(
			\instrument, \fret,
			\degree, Pseq([0,1,2,4],inf).stutter(16) + [0,2,4],
			\scale, Scale.minor,
			\dur, 1/2,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, (Pseg(Pseq([1/2,0.00],inf),4) + 1).log * 0.1,
		)
	).play;
)
([1,0.001]+1).log
