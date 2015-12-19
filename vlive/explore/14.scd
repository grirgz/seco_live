
Ndef(\plop).quant = 
(
~t =1;
Ndef.defaultQuant = 8;
Pdef.defaultQuant = 8;
)
(
Ndef(\plop, { arg freq=170, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1;
	var pulsor = { arg freqs_pairs;
		freqs_pairs.collect({ arg pair;
			LFPulse.kr(pair[0]).range(0,1);

		})
	
	};
	//sig = LFPulse.ar(freq * [1,1.01] * ( 1 + ( SinOsc.ar(freq * LFPulse.kr([1/8,1/5]).range(0,1)) * LFPulse.kr([1/1,2], 0,0.1).range(0,1) )));
	sig = LFPulse.ar(freq * [1,1.01] * ( 1 + ( SinOsc.ar(freq) * LFPulse.kr([4/1,2], 0,0.9).range(0,1) )));
	sig = sig.fold2( SinOsc.ar(freq * [1,1/4,1/2 + 0.00001]).range(0,1) );
	//sig = (sig*100).tanh;
	sig = sig + (sig * LFSaw.kr(16).range(0,0.5));
	sig = sig * SinOsc.ar(freq).range(0,1);
	sig2 = sig * LFPulse.kr(8 * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,2,
	],inf))).range(0,1);
	env1 = EnvGen.kr(Env([2,1,1/8],[0.1,4.8]/~t), Impulse.kr(1/8*~t));
	sig = LPF.ar(sig, 4500 * env1);
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		1,1,1,0,
		0,1,1,1,
		1,1,1,0,
		1,0,1,0,
		1,1,1,1,
		1,1,0,1,
		1,1,1,1,
		1,1,1,0,
	],inf));
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\plop, { arg freq=170, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1;
	var pulsor = { arg freqs_pairs;
		freqs_pairs.collect({ arg pair;
			LFPulse.kr(pair[0]).range(0,1);

		})
	
	};
	//sig = LFPulse.ar(freq * [1,1.01] * ( 1 + ( SinOsc.ar(freq * LFPulse.kr([1/8,1/5]).range(0,1)) * LFPulse.kr([1/1,2], 0,0.1).range(0,1) )));
	sig = LFPulse.ar(
		freq * [1,1.01] * ( 1 + ( 
			SinOsc.ar(freq * LFPulse.kr([1/8,1/12], 0,0.9).range(0,1)) 
			* LFPulse.kr([4/1,2], 0,0.9).range(0,1) 
		))
	);
	sig = sig.fold2( SinOsc.ar(freq * [1,1/4,1/2 + 0.00001]).range(0,1) );
	sig3 = sig;
	//sig = (sig*100).tanh;
	sig = sig + (sig * LFSaw.kr(16).range(0,0.5));
	sig = sig * SinOsc.ar(freq).range(0,1);
	sig2 = sig * LFPulse.kr(8 * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,2,
	],inf))).range(0,1);
	env1 = EnvGen.kr(Env([2,1,1/8],[0.1,4.8]/~t), Impulse.kr(1/8*~t));
	//env1 = SinOsc.kr(4).range(2,1/2);
	env1 = env1 * LFPulse.kr(1/2).range(0.3,2);
	sig = LPF.ar(sig, 4500 * env1);
	sig = sig + (sig3 * LFPulse.kr(1/4,1/4,1/4).range(0,1) / 2);
	//sig = sig * Duty.kr(1/16/~t, 0, Dseq([
	//	1,1,1,0,
	//	0,1,1,1,
	//	1,1,1,0,
	//	1,0,1,0,
	//	1,1,1,1,
	//	1,1,0,1,
	//	1,1,1,1,
	//	1,1,1,0,
	//],inf));
	sig = sig * LFPulse.kr([1/4,8],0,0.93).range(0,1).inject(1,_*_);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);

(
Ndef(\plop, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1;
	var pulsor = { arg freqs_pairs;
		freqs_pairs.collect({ arg pair;
			LFPulse.kr(pair[0]).range(0,1);

		})
	
	};
	//sig = LFPulse.ar(freq * [1,1.01] * ( 1 + ( SinOsc.ar(freq * LFPulse.kr([1/8,1/5]).range(0,1)) * LFPulse.kr([1/1,2], 0,0.1).range(0,1) )));
	sig = LFPulse.ar(
		freq * [1,1.01] * ( 1 + ( 
			SinOsc.ar(freq * LFPulse.kr([1/8,1/12], 0,0.9).range(0,1)) 
			* LFPulse.kr([4/1,2], 0,0.9).range(0,1) 
		))
	);
	sig = sig.fold2( SinOsc.ar(freq * [1,1/4,1/2 + 0.00001]).range(0,1) );
	sig3 = sig;
	//sig = (sig*100).tanh;
	sig = sig + (sig * LFSaw.kr(16).range(0,0.5));
	sig = sig * SinOsc.ar(freq).range(0,1);
	sig2 = sig * LFPulse.kr(8 * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,2,
	],inf))).range(0,1);
	env1 = EnvGen.kr(Env([2,1,1/8],[0.1,4.8]/~t), Impulse.kr(1/8*~t));
	env1 = SinOsc.kr(4).range(2,1/2);
	env1 = env1 * LFPulse.kr(1/2).range(0.3,1);
	sig = LPF.ar(sig, 4500 * env1);
	sig = sig + (sig3 * LFPulse.kr(1/4,1/4,1/4).range(0,1) / 2);
	//sig = sig * Duty.kr(1/16/~t, 0, Dseq([
	//	1,1,1,0,
	//	0,1,1,1,
	//	1,1,1,0,
	//	1,0,1,0,
	//	1,1,1,1,
	//	1,1,0,1,
	//	1,1,1,1,
	//	1,1,1,0,
	//],inf));
	sig = sig * LFPulse.kr([1/4,8],0,0.93).range(0,1).inject(1,_*_);
	sig = Pan2.ar(sig, LFPulse.kr(1/2 * [1,1/3,4]).range(-1,1) * SinOsc.kr(1/8).range(0,1), amp).flop;
}).play;
);

(
Ndef(\plop, { arg freq=110, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1;
	var pulsor = { arg freqs_pairs;
		freqs_pairs.collect({ arg pair;
			LFPulse.kr(pair[0]).range(0,1);

		})
	
	};
	//sig = LFPulse.ar(freq * [1,1.01] * ( 1 + ( SinOsc.ar(freq * LFPulse.kr([1/8,1/5]).range(0,1)) * LFPulse.kr([1/1,2], 0,0.1).range(0,1) )));
	sig = LFSaw.ar(
		freq * [1,1.01] * ( 1 + ( 
			SinOsc.ar(freq/2 * LFPulse.kr([1/8,1/12]*2, 0,0.9).range(0,1)) 
			* LFPulse.kr([4/1,2]/8, 0,0.9).range(0,1) 
		))
	);
	sig = sig.wrap2( SinOsc.ar(freq * [1,1/4,1/2 + 0.00001]).range(0,1) );
	sig3 = sig;
	//sig = (sig*100).tanh;
	sig = sig + (sig * LFSaw.kr(16).range(0,0.5));
	sig = sig * SinOsc.ar(freq).range(0,1);
	sig2 = sig * LFPulse.kr(8 * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,2,
	],inf))).range(0,1);
	env1 = EnvGen.kr(Env([2,1,1/8],[0.1,4.8]/~t), Impulse.kr(1/8*~t));
	env1 = SinOsc.kr(4).range(2,1/2);
	env1 = env1 * LFPulse.kr(1/2).range(0.3,1);
	sig = LPF.ar(sig, 4500 * env1);
	sig = sig + (sig3 * LFPulse.kr(1/4,1/4,1/4).range(0,1) / 2);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1,
		1,1,0,1,
		1,1,1,1,
		1,1,1,0,
		1,0,1,0,
		1,1,0,1,
		1,1,1,1,
		1,1,1,0,
	],inf));
	//sig = sig * LFPulse.kr([1/4,8],0,0.93).range(0,1).inject(1,_*_);
	sig = Pan2.ar(sig, LFPulse.kr(1/2 * [1,1/3,4]).range(-1,1) * SinOsc.kr(1/8).range(0,1), amp).flop;
}).play;
);

(
Ndef(\plop, { arg freq=170, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1;
	var pulsor = { arg freqs_pairs;
		freqs_pairs.collect({ arg pair;
			LFPulse.kr(pair[0]).range(0,1);

		})
	
	};
	//sig = LFPulse.ar(freq * [1,1.01] * ( 1 + ( SinOsc.ar(freq * LFPulse.kr([1/8,1/5]).range(0,1)) * LFPulse.kr([1/1,2], 0,0.1).range(0,1) )));
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,-12,
		1,0,0,0,
		13,0,0,0,
	],inf)).midiratio.lag(1) * [1,2,1/2];
	//freq = freq * Duty.kr(1/8/~t, 0, Dseq([
	//	0,-8,0,2,
	//	0,0,0,12
	//],inf)).midiratio;
	sig = SinOsc.ar(
		freq * [1,1.01] * ( 1 + ( 
			SinOsc.ar(freq/2 * LFPulse.kr([1/8,1/12]*4, 0,0.9).range(0,1)) 
			* LFPulse.kr([4/1,2]*1, 0,0.9).range(0,1) 
		))
	);
	//sig = sig.wrap2( SinOsc.ar(freq * [1,1/4,1/2 + 0.00001]).range(0,1) );
	sig = (sig*100).tanh;
	//sig = sig.round(0.13);
	//sig = Decimator.ar(sig, 1100 * SinOsc.kr(1/2).range(0,8), 8);
	//sig = CombL.ar(sig, 1/20,1/60 * LFSaw.kr(4).range(0.1,1),0.1) + sig;
	sig = sig.flat / 4;
	sig3 = sig;
	sig = sig + (sig * LFSaw.kr(8).range(0,0.5));
	//sig = sig * SinOsc.ar(freq).range(0,1);
	sig = sig * LFPulse.kr(8 * Duty.kr(1/4/~t, 0, Dseq([
		1,1,1,2,
	],inf))).range(0,1);
	env1 = EnvGen.kr(Env([2,1,1/8],[0.1,4.8]/~t), Impulse.kr(1/8*~t));
	env1 = SinOsc.kr( Duty.kr(1/~t, 0, Dseq([
		1,0,4,0,
		8,8,8,2,
	],inf))).range(2,1/8);
	//env1 = env1 * LFPulse.kr(1/2).range(0.3,1);
	sig = sig + (sig3 * LFPulse.kr(1/4,1/4,1/4).range(0,1) / 2);
	sig = RLPF.ar(sig, 4500 * env1);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1,
		1,1,0,1,
		1,1,1,1,
		1,1,1,0,
		1,0,1,0,
		1,1,0,1,
		1,1,1,1,
		1,1,1,0,
	],inf));
	//sig = sig * LFPulse.kr([1/4,8],0,0.93).range(0,1).inject(1,_*_);
	sig.debug("sig1");
	sig = Pan2.ar(sig, LFPulse.kr(1/2 * [1,1/3,4]).range(-1,1) * SinOsc.kr(1/8).range(0,1), amp).sum;
	sig.debug("sig");
}).play;
);
Ndef(\plop).stop
Ndef(\plop).clear

{ LFPulse.ar(100 * [1,1/2],0.3,0.3) }.plot(2/100)

[1,2,3].inject(1,_*_)

(
SynthDef(\kick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([800,52,57],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([1000,62,57],[0.01,0.8]), 1);
	env3 = EnvGen.kr(Env([1000,62,57],[0.4,0.8]), 1);
	env4 = EnvGen.kr(Env([10,6200,57],[0.01,0.01]), 1);
	env5 = EnvGen.kr(Env([1/4,1/6,0.7]/1,[0.01,0.01]), 1);
	sig = LFSaw.ar(env2);
	sig = RLPF.ar(sig, env1);

	sig1 = LFNoise0.ar(env3);
	sig1 = RLPF.ar(sig1, env4, \rq.kr(0.5));
	sig1 = ( sig1 * 1000 ).tanh/2;

	sig = sig + sig1;
	sig = sig + ( ( sig * 1000 ).tanh/8 );
	sig = RLPF.ar(sig, 4500 * [1,1/2,1/3,1/8] * env5, \rq2.kr(0.5) * ( 1/env5 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig/2;
	sig = Pan2.ar(sig, LFNoise1.kr((1..sig.size)).range(-1,1) * 0.1, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\kick2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([700,62,57],[0.11,1.8],-4), 1);
	env2 = EnvGen.kr(Env([300,55,81],[0.01,0.8]), 1);
	env3 = EnvGen.kr(Env([70,52,57],[0.04,0.8]), 1);
	env4 = EnvGen.kr(Env([10,6200,57],[0.01,0.01]), 1);
	env5 = EnvGen.kr(Env([1/4,1/6,0.7]/1,[0.01,0.01]), 1);
	sig = SinOsc.ar(env2 / Rand(1,1.2));
	sig1 = LFSaw.ar(env3 / [1,1.01 * Rand(1,2)]);
	sig1 = LPF.ar(sig1, env1);
	sig = sig1 + sig;
	sig = sig.tanh;

	//sig = sig * EnvGen.ar(Env.adsr(0.001,0.01,0.8,0.1),gate,doneAction:2);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,0.2],-3), gate, doneAction:2);
	sig = sig*2;
	//sig = Pan2.ar(sig, LFNoise1.kr((1..sig.size)).range(-1,1) * 0.1, amp).flop;
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\realkick, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.0, freqpan=0.001, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env2;
	var xenv0;
	var xenv1;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = [1,0,-1] * freqpan;
	xenv0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.030, 0.06, 00.1], [-4, -2, -4]));
	xenv1 = \env1.kr(Env.new([65, 36, 29], [0.07, 0.49], [-4, -5]));
	
	env0 =  EnvGen.ar(xenv0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(xenv1, timeScale:timeScale);
	env2 = EnvGen.ar(xenv1, levelScale: -1, levelBias: 70, timeScale:2).midicps;
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, pi);
	son = son + WhiteNoise.ar(1);
	son = RLPF.ar(son, env2 * 0.1);
	//son = LPF.ar(son, env2*fratio, env0);
	son = son + SinOsc.ar(env1m, Rand(1.1,1) * 2pi);
	
	son = son * 1.4;
	sig1 = son;
	son = son.clip2(1);
	son = son + sig1;
	son = son * 6;
	son = LPF.ar(son, 7900);
	//son = HPF.ar(son, 50);

	son = son * env0;
	//son = Splay.ar(son, spread, amp, pan);
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}).add;

SynthDef(\mkick, { arg out=0, amp=0.1, pan=0, timeScale=1, gate=1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig;

	//gate = TDuty.kr(1/8/~t, 0, Dseq([
	//	1,1,1,1,
	//],1));
	//gate = Impulse.kr(8) * EnvGen.kr(Env([1,1,0],[0.1,0.8]), 1, doneAction:2);
	//gate = Impulse.kr(4);
	env1 = EnvGen.kr(Env([800,52,41],[0.01,0.01]), gate);
	env2 = EnvGen.kr(Env([80,6172,4871],[0.07,0.11]), gate);
	env3 = EnvGen.kr(Env([7,1/4,0],[0.07,0.11]), gate);
	//env1 = LFSaw.kr(4).log.range(200,60).lag(0.1);

	sig = SinOsc.ar(env1);
	sig = sig + WhiteNoise.ar;
	sig = LPF.ar(sig, env2);
	sig = LPF.ar(sig, \lpf.kr(1200));
	//sig = sig + SinOsc.ar(env1);
	sig2 = SinOsc.ar(\basefreq.kr(50) * ( 1 + ( SinOsc.ar(env1) * env3 )));
	//sig = sig + sig2;
	sig = sig2;
	sig = sig * 2;

	sig = sig * EnvGen.kr(Env([0,1,0],[0.03,0.01]), gate, doneAction:0);
	//sig = sig * LFSaw.ar(18).log.range(1,0).lag(0.1/8) / 55750;
	sig = Compander.ar(sig, sig, \compt.kr(1.4), \complo.kr(1.1701), \comphi.kr(0.1001),0.01,0.2);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,\tsustain.kr(1/4)]), 1, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}).add;

//{ LFSaw.ar(2).log.range(1,0).lag(0.1/8)/800 }.plot(1);

SynthDef(\kick3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([800,52,57],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([1000,62,57],[0.01,0.8]), 1);
	env3 = EnvGen.kr(Env([1000,62,57],[0.4,0.8]), 1);
	env4 = EnvGen.kr(Env([10,6200,57],[0.01,0.01]), 1);
	env5 = EnvGen.kr(Env([1/4,1/6,0.7]/1,[0.01,0.01]), 1);
	sig = LFSaw.ar(env2);
	sig = RLPF.ar(sig, env1);

	sig1 = LFNoise0.ar(env3);
	sig1 = RLPF.ar(sig1, env4, \rq.kr(0.5));
	sig1 = ( sig1 * 10 ).tanh/2;

	sig = sig + sig1;
	sig = sig + ( ( sig * 10 ).tanh/8 );
	sig = RLPF.ar(sig, 4500 * [1,1/2,1/3,1/8] * env5, \rq2.kr(0.5) * ( 1/env5 ));
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig/2;
	sig = Pan2.ar(sig, LFNoise1.kr((1..sig.size)).range(-1,1) * 0.1, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\hat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([800,52,57],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([1000,62,57],[0.01,0.8]), 1);
	env3 = EnvGen.kr(Env([1000,62,57],[0.4,0.8]), 1);
	env4 = EnvGen.kr(Env([10,6200,57],[0.01,0.01]), 1);
	env5 = EnvGen.kr(Env([1/4,1/6,0.7]/1,[0.1,0.1]), 1);
	sig = LFSaw.ar(env2);
	sig = RLPF.ar(sig, env1);

	sig = LFNoise0.ar(1000) * 0;
	sig1 = WhiteNoise.ar;
	//sig1 = RLPF.ar(sig1, env4, \rq.kr(0.5));
	//sig1 = ( sig1 * 1000 ).tanh/2;

	sig = sig + sig1;
	//sig = sig + ( ( sig * 1000 ).tanh/8 );
	sig = RLPF.ar(sig, \lpf.kr(14500) * [1,1/2,1/3,1/8] * env5, \lrq.kr(0.5) * ( 1/env5 ));
	sig = RHPF.ar(sig, \hpf.kr(1500) * [1,1/2,1/3,1/8] * env5, \hrq.kr(0.5) * ( 1/env5 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0.01,0.8,0.02)),gate,doneAction:2);
	sig = sig/2;
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)).range(-1,1), amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\hat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([800,52,57],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([1000,62,57],[0.01,0.8]), 1);
	env3 = EnvGen.kr(Env([1000,62,57],[0.4,0.8]), 1);
	env4 = EnvGen.kr(Env([10,6200,57],[0.01,0.01]), 1);
	env5 = EnvGen.kr(Env([1/4,1/6,0.7]/1,[0.1,0.1]), 1);
	sig = LFSaw.ar(env2);
	sig = RLPF.ar(sig, env1);

	sig = LFNoise0.ar(1000) * 0;
	sig1 = WhiteNoise.ar;
	//sig1 = RLPF.ar(sig1, env4, \rq.kr(0.5));
	//sig1 = ( sig1 * 1000 ).tanh/2;

	sig = sig + sig1;
	//sig = sig + ( ( sig * 1000 ).tanh/8 );
	sig = RLPF.ar(sig, \lpf.kr(14500) * [1,1/2,1/3,1/8]/1 * env5, \lrq.kr(0.05) * ( 1/env5 ));
	sig = RHPF.ar(sig, \hpf.kr(1500) * [1,1/2,1/3,1/8] * env5, \hrq.kr(0.5) * ( 1/env5 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0.01,0.8,0.02)),gate,doneAction:2);
	sig = sig/2;
	sig = Pan2.ar(sig, SinOsc.kr((1..sig.size)).range(-1,1), amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\kick, Pbind(
	\instrument, \realkick,
	\degree, Pseq([0],inf),
	\dur, 1,
	\sustain, 0.1,
	\amp, 0.1
)).play;
);

(
	Pdef(\funkick, { arg xfreq = 46, lpf, dir=\raw;
		Pbind(
			\instrument, \mkick,
			\degree, Pseq([0],inf),
			\dur, 1/xfreq,
			\basefreq, (
				lohi: Pseq((1..5).mirror/5,inf)+1 * lpf,
				hi: Pseq((1..5)/5,inf)+1 * lpf,
				lo: Pseq((1..5).reverse/5,inf) * lpf,
				raw: lpf,
			)[dir],
			\legato, 1,
			\tsustain, Pkey(\legato) * Pkey(\dur),
			\amp, 0.5
		)
	});
	Pdef(\akick, Pbind(
		\type, \phrase,
		\instrument, \funkick,
		\lpf, Pseq([50,52,50,55],inf),
		\xfreq, Pseq([1,1,1,8],inf),
		\dur, 1,
	)).play;
);

	(
	Pdef(\akick, Pbind(
		\type, \phrase,
		\instrument, \funkick,
		\dir, Pseq([\lo,\hi,\lohi, \raw],inf),
		\lpf, Pseq([50,52,50,55],inf),
		\legato, 1,
		\xfreq, Pseq([1,1,1,2],inf) * Pseg(Pseq([1,8,16,64],inf),4),
		\dur, 1,
	)).play;
	)

	(
	Pdef(\akick, Pbind(
		\type, \phrase,
		\instrument, \funkick,
		\dir, Pseq([\lo,\lo,\lohi, \raw],inf),
		\lpf, Pseq([52,50,55,50],inf),
		\legato, 1,
		\amp, 1,
		\xfreq, Pseq([
			Pseq([
				1,1,1,8,
				1,1,1,16,
			],1),
			Pseq([
				4,4,1,4,
				4,4,1,8,
			],1) * 4,
		],inf), 
		\dur, 1,
	)).play;
	)

Ndef(\plop).play

(
Pdef(\hat, Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\hpf, Ndef(\lfo1, { SinOsc.kr(1/8).range(50,1000)  }),
	\lpf, Pseq([10000,8000,11400,14000]*1,inf).stutter(Pseq([2,2,2,1],inf)),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.2) ],
		[ Env.adsr(0.01,0.1,0.8,0.2) ],
		[ Env.adsr(0.01,0.1,0.8,0.2) ],
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf).stutter(Pseq([2,2,3,1],inf)),
	\sustain, 0.0051 + Pseq([
		1,1,1,3,
		1,1,1,1,
		2,1,1,3,
		1,1,1,1,
	]/62,inf),
	\amp, 0.1/2
)).play;
);

Ndef(\lfo1, { SinOsc.kr(1/8).range(5000,1000)  })

(
~p1 = Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/16,
	\hpf, Ndef(\lfo1, { SinOsc.kr(1/8).range(50,1000)  }),
	\lpf, Pseq([10000,8000,11400,14000]*2,inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.01) ],
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\sustain, 0.0011 + Pseq([
		1,1,1,1,
		3,1,1,1,
		1,1,1,1,
		3,1,3,1,
	]/62,inf),
	\amp, 0.1
);
~p2 = Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\hpf, Ndef(\lfo1, { SinOsc.kr(1/8).range(50,1000)  }),
	\lpf, Pseq([10000,8000,11400,14000]*2,inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
		[ Env.adsr(0.1,0.1,0.8,0.01) ],
		[ Env.adsr(0.1,0.1,0.8,0.3) ],
		[ Env.adsr(0.1,0.1,0.8,0.01) ],
	],inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\sustain, 0.0011 + Pseq([
		//1,3,
		1,1,1,1,
		3,1,1,1,
		1,1,1,1,
		3,5,1,1,
		//1,1,1,1,
		//3,1,1,1,
		//1,2,1,1,
		//3,1,1,1,
	]/62,inf),
	\amp, 0.1

);
Pdef(\hat, 
	Pbind(\instrument, \hat2, \amp, Pseq([1,0.5,0.8,0.3],inf) * 0.1) <>
	Pseq([
		Pfindur(7/8,Pbind(\dur, 1/4) <> ~p2),
		Pfindur(1/8,~p1),

		Pfindur(4/8, Pbind(\dur, 1/4) <> Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(2)) <> ~p2),
		Pfindur(4/8, Pbind(\sustain, Pseq([0.2,0.1]), \dur,1/4) <> ~p2),

		Pfindur(14/8, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([4,2,1,1],inf))) <> ~p2),

		Pbind(\isRest, true, \dur, Pn(2/8,1)),

		///

		Pfindur(7/8,~p2),
		Pfindur(1/8,~p1),

		Pfindur(4/8, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(2)) <> ~p2),
		Pfindur(4/8, Pbind(\sustain, Pseq([0.2,0.1]), \dur,1/4) <> ~p2),

		Pfindur(14/8, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([4,2,1,1],inf))) <> ~p2),

		Pbind(\isRest, true, \dur, Pn(2/8,1)),

		///

		Pfindur(6/4,~p2),

		Pfindur(2/4,~p1),

		//Pfindur(1, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(2)) <> ~p2),
		//Pfindur(1, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([3,1],inf))) <> ~p2),
		Pfindur(7/4, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([4,2,1,1],inf))) <> ~p2),
		Pbind(\isRest, true, \dur, Pn(1/4,1))


		///


	],inf)
).play;
);

(
~p1 = Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/16,
	\hpf, Ndef(\lfo1, { SinOsc.kr(1/8).range(50,1000)  }),
	\lpf, Pseq([10000,8000,11400,14000]*2,inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.01) ],
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
	],inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\sustain, 0.0011 + Pseq([
		1,1,1,1,
		3,1,1,1,
		1,1,1,1,
		3,1,3,1,
	]/62,inf),
	\amp, 0.1
);
~p2 = Pbind(
	\instrument, \hat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\hpf, Ndef(\lfo1, { SinOsc.kr(1/8).range(50,1000)  }),
	\lpf, Pseq([10000,8000,11400,14000]*2,inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.01) ],
		[ Env.adsr(0.1,0.1,0.8,0.01) ],
		[ Env.adsr(0.1,0.1,0.8,0.3) ],
		[ Env.adsr(0.1,0.1,0.8,0.01) ],
	],inf).stutter(Pseq([2,2,3,1]*4,inf)),
	\sustain, 0.0011 + Pseq([
		//1,3,
		1,1,1,1,
		3,1,1,1,
		1,1,1,1,
		3,5,1,1,
		//1,1,1,1,
		//3,1,1,1,
		//1,2,1,1,
		//3,1,1,1,
	]/62,inf),
	\amp, 0.1

);
Pdef(\hat, 
	Pbind(\instrument, \hat2, \amp, Pseq([1,0.5,0.8,0.3],inf) * 0.1/2) <>
	Pseq([
		Pfindur(7/8,Pbind(\dur, 1/4) <> ~p2),
		Pfindur(1/8,~p1),

		Pfindur(4/8, Pbind(\dur, 1/4) <> Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(2)) <> ~p2),
		Pfindur(4/8, Pbind(\sustain, Pseq([0.2,0.1]), \dur,1/4) <> ~p2),

		Pfindur(14/8, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([4,2,1,1],inf))) <> ~p2),

		Pbind(\isRest, true, \dur, Pn(2/8,1)),

		///

		Pfindur(7/8,~p2),
		Pfindur(1/8,~p1),

		Pfindur(4/8, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(2)) <> ~p2),
		Pfindur(4/8, Pbind(\sustain, Pseq([0.2,0.1]), \dur,1/4) <> ~p2),

		Pfindur(14/8, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([4,2,1,1],inf))) <> ~p2),

		Pbind(\isRest, true, \dur, Pn(2/8,1)),

		///

		Pfindur(6/4,~p2),

		Pfindur(2/4,~p1),

		//Pfindur(1, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(2)) <> ~p2),
		//Pfindur(1, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([3,1],inf))) <> ~p2),
		Pfindur(7/4, Pbind(\lrq, Pseq([0.5,0.1],inf).stutter(Pseq([4,2,1,1],inf))) <> ~p2),
		Pbind(\isRest, true, \dur, Pn(1/4,1))


		///


	],inf).stutter(4)
).play;
);




(
SynthDef(\cym, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = 0;
	5.do {
		sig1 = SinOsc.ar(ExpRand(100,9000) * ( 1 + ( SinOsc.ar(ExpRand(100,9000) * ( 1 + ( SinOsc.ar(100) * 1 ))) * Rand(0,3) )));
		sig1 = HPF.ar(sig1, ExpRand(100,1000));
		sig1 = LPF.ar(sig1, ExpRand(100,1000));
		sig = sig + sig1;
	};
	sig = ( sig/2 ).distort * 3;
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.8,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	// good!!!
	// keep this cymbal!
SynthDef(\cym, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = WhiteNoise.ar;
	sig = sig + LFTri.ar(4000 * ( { Rand(1,2.3) } ! 4 ), mul:1/2);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,1.9], [0,-5]), 1, doneAction:2);
	sig = HPF.ar(sig, EnvGen.kr(Env([1200,5000,3500],[0.01,0.9]), 1));


	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\cym, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = WhiteNoise.ar;
	sig = sig + LFTri.ar(7000 * ( { ExpRand(1,2.3) } ! 4 ), mul:1/2);
	sig1 = sig;
	sig = HPF.ar(sig, EnvGen.kr(Env([1200,5000,3500],[0.01,0.9]), 1));
	sig = sig + BPF.ar(sig1, EnvGen.kr(Env([120,5000,3500],[0.01,0.9]), 1), mul:0.5);

	sig = sig * EnvGen.kr(Env([0,1,0],[0.002 + Rand(0.001,0.005),0.4], [0,-5]), 1, doneAction:2);

	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\cym, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = WhiteNoise.ar([1,1]);
	//sig = sig + LFTri.ar(4000 * ( { Rand(1,1.3) } ! 4 * ( 1 + ( SinOsc.ar(1000 * ( 1 + ( SinOsc.ar(2000) * 1 ))) * 1/2 )) ), mul:1);
	sig = RHPF.ar(sig, EnvGen.kr(Env([100,200,150]*4.9,[0.01,0.9]), 1), 0.5);
	sig = RLPF.ar(sig, EnvGen.kr(Env([100,500,350]*20,[0.01,0.9]), 1), 0.5);
	sig = sig + BPF.ar(sig, 400 * EnvGen.kr(Env([1,2,7],[0.01,0.2]), 1));

	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,1.9], [0,-5]), 1, doneAction:2);

	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\cym, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = WhiteNoise.ar([1,1]);
	sig3 = SinOsc.ar(400 * ( { Rand(1,1.3) } ! 4 * ( 1 + ( SinOsc.ar(7000 * ( 1 + ( SinOsc.ar(7000) * 1 ))) * 1/2 )) ), mul:1);
	sig3 = HPF.ar(sig3, 1000, mul:0.3);
	sig = sig + sig3;
	//sig = CombL.ar(sig, 1/20,1/40 * [1,1.1 * SinOsc.ar(49).range(1.1,1)], XLine.kr(0.00001,0.01,1/2))+ sig;
	sig = RHPF.ar(sig, EnvGen.kr(Env([100,200,150]*4.9,[0.01,0.9]), 1), 0.5);
	sig = RLPF.ar(sig, EnvGen.kr(Env([100,4400,4350],[0.01,0.02]), 1), 0.5);
	sig = sig + BPF.ar(sig, 400 * EnvGen.kr(Env([1,2,7],[0.01,0.2]), 1));
	sig1 = ((LFNoise1.ar(500) * 4 ).tanh * EnvGen.kr(Env([0,1,0],[0.001,1.4], [0,-5]), 1));
	sig1 = BPF.ar(sig, 800, 0.5);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.051,1.9], [0,-5]), 1, doneAction:2);
	sig2 = ((LFPulse.ar(4500 * EnvGen.kr(Env([2,1/2,1],[0.01,0.08]), 1);) ).tanh * EnvGen.kr(Env([0,1,0],[0.001,0.1], [0,-5]), 1));
	sig4 = ( sig * 5 ).tanh;
	sig2 = HPF.ar(sig, 400, mul:1.5);
	sig = sig + sig1 + sig2;
	sig = SelectX.ar( XLine.kr(0.01,1,1/8), [sig, sig+sig4]);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,2.9], [0,-5]), 1, doneAction:2);


	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\cym, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig1 = 0; sig2 = 0; sig3 = 0;

	sig1 = LFPulse.ar(MouseX.kr(100,8000).poll(label:1) ! 2);
	sig1 = sig1 * LFPulse.ar(MouseY.kr(100,8000).poll(label:2) ! 2);
	sig1 = LFSaw.ar([822,2551,4121,7122]).inject(1,_*_);
	sig1 = sig1 ! 2;
	sig1 = LPF.ar(sig1, 7000);

	sig2 = WhiteNoise.ar([1,1]);
	//sig2 = sig2 + LFTri.ar(4000 * ( { Rand(1,1.3) } ! 4 * ( 1 + ( SinOsc.ar(1000 * ( 1 + ( SinOsc.ar(2000) * 1 ))) * 1/2 )) ), mul:1);
	sig2 = RHPF.ar(sig2, 600);
	sig2 = RLPF.ar(sig2, 18000);
	//sig2 = sig2 + BPF.ar(sig2, 400 * EnvGen.kr(Env([1,2,7],[0.01,0.2]), 1));

	sig = sig1 + sig2 + sig3;

	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,1.9], [0,-5]), 1, doneAction:2);


	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\cym, Pbind(
	\instrument, \cym,
	\degree, Pseq([0],inf),
	\legato, 0.1,
	\dur, 2,
	\amp, 0.1
)).play;
);

(
~t =1;
Ndef.defaultQuant = 2;
Pdef.defaultQuant = 2;
)



(

SynthDef(\realcym, { arg out=0, pan=0, amp=0.1;

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig;

	locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));

	freqs  = {ExpRand(300, 20000)}.dup(100);

	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack);
	
	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,1.9], [0,-5]), 1, doneAction:2);

	sig = Pan2.ar(sig, pan, amp);

	Out.ar(out, sig);

}).add;

SynthDef(\paracym, { arg out=0, pan=0, amp=0.1;

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig;

	locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * \locutfac.kr(10000) + \locutbase.kr(10);
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));

	//freqs  = {ExpRand(4300, 20000)}.dup(100);
	freqs = \freqtab.kr({ exprand(4300, 20000) } ! 100);

	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack);
	
	sig = sig * EnvGen.kr(\env.kr(Env([0,1,0],[0.001,1.9], [0,-5])), 1, doneAction:2);

	sig = Pan2.ar(sig, pan, amp);

	Out.ar(out, sig);

}).add;

SynthDef(\cym, { arg out=0, pan=0, amp=0.1, gate=1;

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig;

	locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * 2000 + 10000;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 1001 - (EnvGen.ar(Env.perc(0.1, 3)) * 100);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(0.1, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));

	freqs  = {exprand(30, 200)}.dup(10);

	res    = Klank.ar(Ref([freqs, [0.2]], ), lodriver + hidriver + thwack);
	sig = ((res * 1) + (lodriver * 2) + thwack);
	
	sig = sig * EnvGen.kr(Env([0,1,0],[0.001,0.2], [0,-5], 1), gate, doneAction:2);

	sig = Pan2.ar(sig, pan, amp);

	Out.ar(out, sig);

}).add;

SynthDef(\tray, { arg out=0, amp=0.1, gate=1, pan=0, freq=200,
					freq2=1, amp2=1, freq3=1, amp3=1;
	var sig;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq2 * ( 1 + ( SinOsc.ar(freq3 * [1,1.1]) * amp3 ))) * amp2 )));
	sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
//Pdef(\cym).play;

)

(
Pdef(\realcym, Pbind(
	\instrument, \paracym,
	\degree, Pseq([0],inf),
	\legato, 0.1,
	\freqtab, [ {exprand(300,1000)}!100 ],
		\freqtab, Plazy({ 
			var x = { [ {rand(300.0,14500)}!100 ] } ! 8;
			Pseq([
				x[0],
				x[0],
				x[0],
				x[1],
			],16);
		}).loop,
	\legato, Pseq([1.5,0.2,0.2,0.2],inf)/4,
	\env, [Env([0,1,0],[0.001,0.08])],
	\isRest, Pseq([
		Prand([
			Pseq([
				0,0,1,0, 0,0,1,1,
				0,0.5,1,0.5, 0.51,0.5,1,1,
				0,1,0,0.5, 0.5,0.5,1,1,
			],1),
			Pseq([
				0,0.5,1,0.5, 0.51,0.5,1,1,
			],1),
			Pseq([
				0.5,0.5,1,0.5, 0.51,0.5,1,1,
			],1),
			Pseq([
				0,0,1,0, 0,0,1,1,
			],1),
			Pseq([1,0,0,1, 0,0,1,0]),
			Pseq([ 1,1,1,1, 1,1,1,1, ]),
			Pseq([ 1,1,1,1, 1,1,1,0, ]),
			Pseq([ 1,1,1,1, 1,1,0,0, ]),
			Pseq([ 1,1,1,0, 1,1,0,1, ]),
			Pseq([ 1,0,1,0, 1,0,1,0, ]),
			Pseq([ 0,1,0,1, 0,1,0,1,  ]),
		],inf),
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

Pdef(\realcym).stop
Pdef(\cym).stop

(
Pdef(\cym, Pbind(
	\instrument, \cym,
	\degree, Pseq([0],inf),
	\legato, 0.1,
	\legato, Pseq([1.5,0.2,0.2,0.2],inf)/4,
	\sustain, 0.01,
	\dur, 1/1,
	\amp, 0.1
)).play;
);


(
Pdef(\tray, Pbind(
	\instrument, \tray,
	\degree, Pseq([0],inf),
	\legato, 0.1,
	\freq2, 100,
	\freq2, 400,
	\legato, Pseq([1.5,0.2,0.2,0.2],inf)/4 * Pseg(Pseq([0.5,3],inf),8),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
Pdef(\tray2, Pbind(
	\instrument, \tray,
	\degree, Pseq([0,0,12,0, -12],inf),
	\legato, 0.1,
	\freq2, 2100,
	\amp2, Pseg(Pseq([14,1],inf),8),
	\amp3, Pseg(Pseq([4,1],inf),8),
	\freq2, 200 * Pseg(Pseq([4,1],inf),8),
	\legato, Pseq([1.5,0.2,0.2,0.2],inf)/4 * Pseg(Pseq([0.5,3],inf),8),
	\isRest, Pseq([
		1,0,0.3,0,
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
)).play;
);




(// 1st
SynthDef(\perc1, {
	arg freq=100, dec1 = 2, dec2 = 4, gain = 250, ground = 0;
	var src, rnd, env, free;
	free = EnvGen.ar(Env.sine(dec2),doneAction:2);
	rnd = {arg rt,low,high; LFNoise2.ar(rt).range(low,high)};
	env = {arg dec; Decay.ar(Impulse.ar(0),dec!2,1-ground)+ground};
	src = GrainSin.ar(
		2, Dust.ar(freq*env.(dec1)), // Channels & Trig
		rnd.(2,0.00005,0.0005), // Grain Duration
		rnd.(dec2,freq/4,freq*8), // Grain Freq
		0,-1,1024,0.1 // Pan, Env, MaxGrain, Mul
	);
	src = src*env.(dec2)*gain;
	src = LPF.ar(src.fold(-0.5,0.5),10000,0.25);
	src = HPF.ar(src,100);
	Out.ar(0,src);
}).store
)
(// 2nd
SynthDef(\perc2, {
	arg freq=100, dec1 = 2, dec2 = 4, gain = 250, ground=0, gDur = 0.0005, pitchE = 1;
	var src, rnd, env, free, mod;
	free = EnvGen.ar(Env.sine(dec2),doneAction:2);
	rnd = {arg rt,low,high; LFNoise2.ar(rt!2).range(low,high)};
	env = {arg dec; Decay.ar(Impulse.ar(0),dec!2,1-ground)+ground};
	//mod = Splay.arFill(8, {Pulse.ar(rrand(freq,freq*4)*(env.(dec1)*pitchE))})*env.(dec2);
	//mod = Splay.arFill(8, {Blip.ar(rrand(freq,freq*4)*(env.(dec1)*pitchE),100)})*env.(dec2);
	//mod = Splay.arFill(8, {HenonC.ar(rrand(freq*4,freq*16)*(env.(dec1)*pitchE))})*env.(dec2);
	src = GrainSin.ar(
		2, Dust.ar(freq*(env.(dec1)*pitchE)!2), // Channels & Trig
		rnd.(freq*IRand(-2,2),gDur/2,gDur*2), // Grain Duration
		rnd.(dec2,freq/4,freq), // Grain Freq
		0,-1,1024,0.1 // Pan, Env, MaxGrain, Mul
	);
	src = src*env.(dec2)*gain;
	src = LPF.ar(src.fold(-0.5,0.5),250,0.25);
	src = FreqShift.ar(src,freq*IRand(1,4)*(env.(dec1)*pitchE));
	src = src ring2: mod;
	src = HPF.ar(src,100).tanh;
	Out.ar(0,src*0.25);
}).store
)
(
Pdef(\seq1,
	Pbind(
		\instrument, \paracym,
		\sustain, Pseq((1..8),inf) * 0.2,
		\locutbase, 8000,
		\locutfac, 10000,
		\freqtab, Plazy({ 
			var x = { [ {exprand(1000,20000)}!100 ] } ! 8;
			Pseq([
				x[0],
				x[0],
				x[0],
				x[1],
			],8);
		}).loop,
		\isRest, Pseq([
			0.5,
		],inf).coin.not,
		\amp, 0.22,
		\env, Pseq([
			Plazy({
				var p;
				p = Pseq((1..8).pow(1.2),inf) * 0.02;
				p.collect({ arg x;
					[Env([0,1,0],[0.001,x])];
				});
			})
		],inf),
		\dec1, Pseq(Array.geom(3,0.125,1.25),inf), // Pitch Env
		\dec2, Pseq(Array.geom(5,0.25,1.25),inf), // Volume doneAction Env
		\gDur, Pseq(Array.geom(9,0.005,2),inf), // Average Grain Duration
		\freq, Pseq(Array.geom(7,250,1.5),inf), // Average Freq
		\gain, Pseq(Array.geom(6,25,2),inf), // Gain for distortion
		\pitchE, Pseq(Array.geom(11,1,0.75),inf), // Pitch Envelope Amount
		// \ground, Pseq([0.25,0.125,0.067,0],inf), // Lowest volume
		\dur, 1/4 // Duration
)).play
)
(
Pdef(\rndSeq,
	Pbind(
		\instrument, \paracym,
		\sustain, 0.1,
		\freqtab, Plazy({ 
			var x = { [ {exprand(1000,20000)}!100 ] } ! 8;
			Pseq([
				x[0],
				x[1],
			],8);
		}).loop,
		\isRest, Pseq([
			0.5,
		],inf).coin.not,
		\amp, 0.3,
		\env, [Env([0,1,0],[0.001,0.18])],
		\dur, 0.125,
		\dec2, 0.125,
		\dec1, Pwhite(0.025,1),
		\gDur, Pwhite(0.00005,0.5),
		\freq, Pwhite(5,750),
		\gain, Pwhite(25,500),
		\pitchE, Pwhite(0.5,1),
		\ground, Pwhite(0,0.125)
)).play
)

(
Pdef(\snare,
	Pbind(
		\instrument, \paracym,
		\sustain, 0.1,
		\freqtab, Plazy({ 
			var x = { [ {exprand(1000,20000)}!100 ] } ! 8;
			Pseq([
				x[0],
				x[1],
			],16) + Pfunc({ exprand(1,100) });
		}).loop,
		\isRest, Pseq([
			0,1,
		],inf).coin.not,
		\dur, 1,
		\amp, 0.3,
)).play
)

(
Pdef(\hat2,
	Pbind(
		\instrument, \paracym,
		\sustain, 0.1,
		\locutfac, Pseq([
			Pser([
				10000,7000
			],4),
			Pser([
				1000,7000
			],4),
			Pser([
				10000,17000
			],8),
		],inf),
		\freqtab, Plazy({ 
			var x = { [ {exprand(7000,2100)}!100 ] } ! 8;
			Pseq([
				x[0],
				x[1],
			],8).stutter(4);
		}).loop,
		\release, Pseq([
			0.1,0.01,0.051,0.1,
			0.1,0.01,0.051,0.1,
			0.1,0.01,0.051,0.1,
			0.1,0.01,0.01,0.3,
		],inf) * Pseq([1,2,2,2],inf),
		\curve, Pseq([0,-3,-3,-3],inf),
		\env, Pfunc({ arg ev;
			[Env([0,1,0],[0.051,ev[\release]], ev[\curve])]
		}),
		\isRest, Pseq([
			0,1,
		],inf).coin.not,
		\dur, 1/8,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,1,0,0,
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\isRest, Pseq([
			0,1,1,1,
			1,1,1,1
		],inf).coin.not,
		\isRest, Pseq([
			1,1,0,0,
			1,0,0,0,
			1,1,1,0,
			0,0,0,0.51,

			0.5,0.5,0.5,0.5,
			0.5,0.5,0.5,0.5,
			0.5,0.5,0.5,0.5,
			0.5,0.5,0.5,0.5,
		],inf).coin.not,
		\amp, 0.3,
)).play
)

Pdef(\kick).play

(
Pdef(\hat2,
	Pbind(
		\instrument, \paracym,
		\sustain, 0.1,
		\locutfac, Pseq([
			Pser([
				10000,7000
			],4),
			Pser([
				1000,7000
			],4),
			Pser([
				10000,17000
			],8),
		],inf),
		\freqtab, Plazy({ 
			var x = { [ {exprand(1700,17100)}!100 ] } ! 8;
			Pseq([
				x[0],
				x[1],
			],8).stutter(4);
		}).loop,
		\release, Pseq([
			0.1,0.01,0.051,0.1,
			0.1,0.01,0.051,0.1,
			0.1,0.01,0.051,0.1,
			0.1,0.01,0.01,0.3,
		],inf) * Pseq([1,2,2,2],inf),
		\curve, Pseq([0,-3,-3,-3],inf),
		\env, Pfunc({ arg ev;
			[Env([0,1,0],[0.051,ev[\release]], ev[\curve])]
		}),
		\isRest, Pseq([
			0,1,
		],inf).coin.not,
		\dur, 1/8,
		\isRest, Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,1,0,0,
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\isRest, Pseq([
			0,1,1,1,
			1,1,1,1
		],inf).coin.not,
		\isRest, Pseq([
			1,1,0,0,
			1,0,0,0,
			1,1,1,0,
			0,0,0,0.51,

			0.5,0.5,0.5,0.5,
			0.5,0.5,0.5,0.5,
			0.5,0.5,0.5,0.5,
			0.5,0.5,0.5,0.5,
		],inf).coin.not,
		\amp, 0.3,
)).play
)
