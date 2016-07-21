(
Ndef('fairydrone.rise', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = XLine.kr(21,100,20*1);
	env1 = EnvGen.kr(Env([0,21,102,1000,70],[4,4,7.9,0.1]).circle, 1);
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	sig = SinOsc.ar(freq / [1,2,4]);
	sig.debug("sig");
	sig = sig / 1.0;
	sig = Pan2.ar(sig.flop, SinOsc.kr(sig.flop.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,1) })).range(-1,1), amp).flop.mean.sum;
});

Ndef('fairydrone.night', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fac = 1/SelectX.kr( SinOsc.kr(1/113).range(0,6), [1/2,1,2,4,8,64,128] )/8;
	env1 = EnvGen.ar(Env([42,21,42,30,84],[4,4,7.5,0.5]/fac).circle, 1);
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);
	env3 = XLine.kr(1,0.1,20*1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	//freq.debug.shape.debug("freq");
	sig = SinOsc.ar( freq / [1,2,4]);
	//sig.shape.debug("sig1");
	sig = sig.collect({ arg isig, x;
		isig = SelectX.ar( SinOsc.kr(x+1/34).range(0,1), [isig, isig.fold2(env3)]);
		isig = SelectX.ar( SinOsc.kr(1/223, 3pi/2).range(0,1), [isig, ( isig * SinOsc.kr(1/48 * ( x + 1 )).range(1,100) ).tanh]);
	});
	//sig.shape.debug("sig2");
	sig1 = sig.flop[1];
	sig = sig.flop[0];
	//sig.debug("sig");
	sig1 = Pan2.ar(sig1, SinOsc.ar(sig1.size.collect({ arg x; SinOsc.kr(x/10+1.2).range(0,8) })) * SinOsc.kr(1/48).range(0,1), amp).mean;
	sig = Pan2.ar(sig, SinOsc.ar(sig.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,8) })) * SinOsc.kr(1/58).range(0,1), amp).mean;
	sig = sig + sig1;
	sig = sig * 2.0;
	sig = LPF.ar(sig, 1999);
	sig;
});

Ndef('fairydrone.digital', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = Ndef.ar(\crudebass);
	env1 = XLine.kr(71,100,20*1);
	env1 = EnvGen.kr(Env([0,0,70,1],[1,0.01,0.01]/18), Impulse.kr(4));
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);
	env3 = EnvGen.kr(Env([0,0,2,41,200],[4,6,6,16]).circle, 1);


	freq = 18.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	sig = SinOsc.ar(freq / [1,2,4] * ( 1+  ( in * env3 ) )) + Ndef.ar(\bigo);
	sig = BRF.ar(sig, Amplitude.ar(in) * 1000 + 100) + in;
	sig.debug("sig");
	sig = sig / 1.0;
	sig = Pan2.ar(sig.flop, SinOsc.kr(sig.flop.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,1) })).range(-1,1), amp).flop.mean;
	sig = sig.sum;
});

Ndef(\kicky, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = TDuty.kr(1/8/~t, 0, Dseq([
		1,0,0,0, 1,0,0,0,
	],inf));

	env4 = EnvGen.kr(Env([1,2000,100,7000],[0.1,0.8,0.2]), PulseDivider.kr(env1, 2));
	env3 = EnvGen.kr(Env([1, env4,101],[0.1,0.08]), env1);

	sig2 = WhiteNoise.ar;
	sig2 = BPF.ar(sig2, env3);
	sig2 = sig2 + BPF.ar(sig2, DelayL.kr(env3,1/4, SinOsc.kr(1/8).exprange(1/16,1/4)));
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[0.0001,0.04]), env1);
	sig2 = DelayL.ar(sig2, 2/5) * SinOsc.kr(1/23).exprange(0.001,1) + sig2;
	sig2 = DelayL.ar(sig2, 2/9) * SinOsc.kr(1/14).exprange(0.001,1) + sig2;

	env2 = EnvGen.kr(Env([0,302,50],[0.01,0.018]), env1);
	sig = SinOsc.ar(env2) ! 2;
	sig = sig + sig2;
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef(\crudebass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 50;
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/4,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef('alarm.0', { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 1450 + LFPulse.kr(1/4).range(100,200);
	freq = freq + LFPulse.kr(1/8).range(100,200);
	freq = freq + LFPulse.kr(1/8,3/2pi).range(1000,200);
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef('alarm.1', { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 1450 * LFPulse.kr(1/4).range(100,200);
	freq = freq + LFPulse.kr(1/8).range(10,31 * LFPulse.kr(1/3,0.1).range(1/2,1));
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef('alarm.2', { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 1450 * LFPulse.kr(1/4).range(100,200);
	//freq = freq + LFPulse.kr(1/8).range(10,31 * LFPulse.kr(1/3,0.1).range(1/2,1));
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef('alarm.3', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,410],[0.1,4.8,4]), Impulse.kr(1));
	freq = 1450 * LFPulse.kr(1/4 * LFPulse.kr(1/8).range(32,1)).range(1,4);
	//freq = freq + LFPulse.kr(1/8).range(10,31 * LFPulse.kr(1/3,0.1).range(1/2,1));
	sig = LFPulse.ar(freq * [1,1/2] );
	sig = SinOsc.ar(freq / [1,2,4,8]* ( 1 + ( SinOsc.ar(freq/2) * env1 ))) + sig;
	//sig = sig + SinOsc.ar(freq);
	//sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,0.04) ).fold2(1);
	sig = RLPF.ar(sig, 8500) + (sig/4);
	sig = RLPF.ar(sig, SinOsc.kr(1/13).exprange(100,12001),0.1) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 8;
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef('hatty.0', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	sig = BPF.ar(sig, 4000 * [1,1.2]);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.8,0.1]), Impulse.kr(1));
	sig = sig / 8;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.7, amp).mean;
});

Ndef('hatty.1', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	sig = LPF.ar(sig, 17000 * [1,1.2]);
	sig = HPF.ar(sig, 2000 * [1,1.2]);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.3]), Impulse.kr(1));
	sig = sig / 8;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.4, amp).mean;
});

Ndef('fasthatty.0', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([1,18000,4301],[0.1,0.08]), Impulse.kr(4)) * SinOsc.kr(1/23).range(1.30,0.11);
	env2 = EnvGen.kr(Env([1,12000,4301],[4.1,4.08]), Impulse.kr(1)) * SinOsc.kr(1/23).range(1.30,0.11);
	sig1 = BPF.ar(sig, env1 * [1,1.2]);
	sig2 = BPF.ar(sig, env2 * [1,1.2]);
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,0,1,0],[0,0.001,0.02]), Impulse.kr([8,4])) * SinOsc.kr([1.01,1/8.01]).range(0,1);
	sig = sig / 2;
	sig = DelayL.ar(sig, 1/4);
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.1, amp).mean;
});

Ndef('fasthatty.1', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([1,18000,4301],[0.1,0.08]), Impulse.kr(4)) * SinOsc.kr(1/23).range(1.30,0.11);
	env2 = EnvGen.kr(Env([1,12000,4301],[4.1,4.08]), Impulse.kr(1)) * SinOsc.kr(1/23).range(1.30,0.11);
	sig1 = BPF.ar(sig, env1 * [1,1.2]);
	sig2 = BPF.ar(sig, env2 * [1,1.2]);
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,0,1,0],[0,0.001,0.02]), Impulse.kr([8,4])) * SinOsc.kr([1.01,1/8.01]).range(0,1);
	sig = sig / 2;
	sig = DelayL.ar(sig, 1/4) + sig;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.1, amp).mean;
});

Ndef('bigbass.0', { arg freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,2,8,0],[4,8,8,8]).circle, 1);
	env2 = DelayL.kr(env1, 8,1/(1..8));
	env3 = EnvGen.kr(Env([0.1,0.2,0.01,0.7,0.1],[6,7,5,8]*2).circle, 1);
	env4 = DelayL.kr(env3, 8,1/(1..8));
	sig = LFSaw.ar(freq);
	sig = 8.collect({ arg x;
		RLPF.ar(sig, freq* env2[x], env4[x]);
	});
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef('bigbass.1', { arg freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,2,8,0],[4,8,8,8]).circle, 1);
	env2 = DelayL.kr(env1, 8,1/(1..8));
	env3 = EnvGen.kr(Env([0.1,0.2,0.01,0.7,0.1],[6,7,5,8]*2).circle, 1);
	env4 = DelayL.kr(env3, 8,1/(1..8));
	env6 = EnvGen.kr(Env([0,0,1,4],[8,8,16]).circle, 1);
	env5 = { arg x; SinOsc.kr(x+1).range(1/2,1) * env6 + 1 };

	sig = LFSaw.ar(freq);
	sig = 8.collect({ arg x;
		RLPF.ar(sig, freq* env2[x] * env5.(x), env4[x]);
	});
	sig = Pan2.ar(sig, pan, amp).mean;
});

Ndef('bigbass.high', { arg freq=270, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,2,8,0],[4,8,8,8]).circle, 1);
	env2 = DelayL.kr(env1, 8,1/(1..8));
	env3 = EnvGen.kr(Env([0.1,0.2,0.01,0.7,0.1],[6,7,5,8]*2).circle, 1);
	env4 = DelayL.kr(env3, 8,1/(1..8));
	env6 = EnvGen.kr(Env([0,0,1,4],[8,8,16]).circle, 1);
	env5 = { arg x; SinOsc.kr(x+1).range(1/2,1) * env6 + 1 };

	sig = LFSaw.ar(freq * [1,1/2]);
	sig = 8.collect({ arg x;
		var isig;
		isig = RLPF.ar(sig, freq* env2[x] * env5.(x), env4[x]);
		isig = SelectX.ar( SinOsc.kr(1+x/20).range(0,1), [isig, isig.fold2(0.1)]);
	}).flat;
	sig = HPF.ar(sig, 1000 * SinOsc.kr(1/[34,42]).mean.exprange(1/10,8));
	sig = sig / 4;
	sig = Pan2.ar(sig, SinOsc.kr(sig.size.collect({ arg x; x/10 })) * 0.5, amp).mean;
});

Pdef(\fakick, Pbind(
	\instrument, \zkick,
	\env0, Pseq([
		[ Env([0,1,0],[0.001,2.4]) ],
	],inf),
	\env1, Pseq([
		[ Env([66,36,34],[0.01,0.2]) ],
		[ Env([66,38,34],[0.001,0.2]) ],
	],inf).stutter(4),
	\degree, Pseq([0],inf),
	\distmix, Pseq([0,0.1,0.5],inf).stutter(8),
	\dist, 80,
	\distamp, 1/4,
	\dur, 1,
	\out, BusDef(\bus1, \audio, 2),
	\amp, 0.1
));

Pdef(\fasnare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\rel, 1,
	\snareampenv, [ Env([0,1,0],[0.001,8.48], -2) ],
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],1),
	],inf).coin.not,
	\out, BusDef(\bus1, \audio, 2),
	\amp, 0.1
));

3.do { arg x;
	Ndef('kickfx.' +++ x).fadeTime = 1/2;
};

Ndef('kickfx.0', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	var in2;
	in2 = 0;
	sig = in + in2;
	sig = sig + Fb { arg in;
		var isig2;
		var isig = in*\fb.kr(1.1) + sig;
		//isig = isig + DelayL.ar(isig, 1, 1/70 / SinOsc.kr(1/8).exprange(1/2,16));
		//isig = isig + DelayL.ar(isig, 1, \delay.kr(1/8));
		isig = AllpassL.ar(isig, 1, \delay.kr(1/8) * LFNoise1.kr(1/18).range(1.1,1));
		//isig2 = ( isig * 100 * SinOsc.kr(1/32).range(2,0.2) ).tanh / 78;
		//isig = SelectX.ar( SinOsc.kr(1/16).range(0.8,1), [isig/8, isig2] );
		//isig = isig + DelayL.ar(isig, 1, 1/16 * SinOsc.kr(1/37).exprange(1/2,16), mul:2);
		isig2 = isig * 2;
		isig2 = isig2.tanh;
		isig = SelectX.ar(\distmix.kr(0.45), [isig, isig2]);
		isig2 = Compander.ar(isig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
		isig = SelectX.ar(\cpmix.kr(0.5), [isig, isig2]);
		isig = BRF.ar(isig, SinOsc.kr(1/8).range(100,14991));
		//isig = Limiter.ar(isig,0.4,1) * SinOsc.kr(2/1).exprange(0.4,0.7) / 1;
		//isig = Limiter.ar(isig,0.4,1);
		isig;
	};
	sig = Limiter.ar(sig, \level.kr(0.2));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig;
});
Spec.add(\inbus, XBusSpec());

Ndef('kickfx.1', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	var in2;
	in2 = 0;
	sig = in + in2.debug("in2");
	sig = sig + Fb { arg in;
		var isig = in/1.1 + sig;
		isig = isig + DelayL.ar(isig, 1/70 * SinOsc.kr(1/21).exprange(1/2,16));
		isig = ( isig * 40 * SinOsc.kr(1/4).range(0.1,1) ).tanh / 8;
		isig = BRF.ar(isig, SinOsc.kr(1/23).range(100,14991));
		isig = Limiter.ar(isig,0.4) * SinOsc.kr(8).range(0,0.5);
		isig;
	};
	sig = Limiter.ar(sig, 0.1) ;
	sig;
});

Ndef('kickfx.2', { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	var in2;
	//in2 = Ndef.ar(\frite);
	in2 = 0;
	sig = in + in2.debug("in2");
	sig = sig + Fb { arg in;
		var isig = in/1.1 + sig;
		isig = isig + DelayL.ar(isig, 1/70 * SinOsc.kr(1/21).exprange(1/2,16));
		isig = ( isig * 40 * LFPulse.kr(1/2).range(0.1,1) ).tanh / 8;
		isig = BRF.ar(isig, SinOsc.kr(1/23).range(100,14991));
		isig = Limiter.ar(isig,0.4) * SinOsc.kr(1/45).range(0,1.2);
		isig;
	};
	sig = Limiter.ar(sig, 0.01) * 1;
	sig;
});

);

// END


Ndef(\bla, { SinOsc.ar(200) ! 2 * 0.1  }).get(\out)
Ndef(\bla, { SinOsc.ar(200) ! 2 * 0.1  }).monitor.out = 0
Ndef(\bla, { SinOsc.ar(200) ! 2 * 0.1  }).play
Ndef(\blax, { SinOsc.ar(200) ! 2 * 0.1  }).monitor.out = 0
Ndef(\blax, { SinOsc.ar(200) ! 2 * 0.1  }).monitor.out
Ndef(\blax, { SinOsc.ar(200) ! 2 * 0.1  }).vol_(1)
Ndef(\blax, { SinOsc.ar(200) ! 2 * 0.1  }).play
Ndef(\blax).clear
Ndef(\blaxxx, { SinOsc.ar(200) ! 2 * 0.1  }).initMonitor.out=  1
Ndef(\blaxxx, { SinOsc.ar(200) ! 2 * 0.1  }).initMonitor.out
Ndef(\blaxxx, { SinOsc.ar(200) ! 2 * 0.1  }).initMonitor
Ndef(\blaxxx, { SinOsc.ar(200) ! 2 * 0.1  }).play
Ndef(\rrr, { SinOsc.ar(200) ! 2 * 0.1  })
Ndef(\rrr, { SinOsc.ar(200) ! 2 * 0.1  })
Ndef(\rrr, { SinOsc.ar(200 * SinOsc.kr(2).range(0,1)) ! 2 * 0.1  }).initMonitor
Ndef(\rrr).play
Ndef(\rrr).initMonitor

Ndef(\rrrr, )

(
Ndef(\ota, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = XLine.kr(21,100,20*1);
	env1 = EnvGen.kr(Env([0,21,102,1000,70],[4,4,7.9,0.1]).circle, 1);
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	sig = SinOsc.ar(freq / [1,2,4]);
	sig.debug("sig");
	sig = sig / 1.0;
	sig = Pan2.ar(sig.flop, SinOsc.kr(sig.flop.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,1) })).range(-1,1), amp).flop.mean;
}).play;
);

(
Ndef(\ota, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fac = 1/SelectX.kr( SinOsc.kr(1/113).range(0,6), [1/2,1,2,4,8,64,128] )/8;
	env1 = EnvGen.ar(Env([42,21,42,30,84],[4,4,7.5,0.5]/fac).circle, 1);
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);
	env3 = XLine.kr(1,0.1,20*1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	//freq.debug.shape.debug("freq");
	sig = SinOsc.ar( freq / [1,2,4]);
	//sig.shape.debug("sig1");
	sig = sig.collect({ arg isig, x;
		isig = SelectX.ar( SinOsc.kr(x+1/34).range(0,1), [isig, isig.fold2(env3)]);
		isig = SelectX.ar( SinOsc.kr(1/223, 3pi/2).range(0,1), [isig, ( isig * SinOsc.kr(1/48 * ( x + 1 )).range(1,100) ).tanh]);
	});
	//sig.shape.debug("sig2");
	sig1 = sig.flop[1];
	sig = sig.flop[0];
	//sig.debug("sig");
	sig1 = Pan2.ar(sig1, SinOsc.ar(sig1.size.collect({ arg x; SinOsc.kr(x/10+1.2).range(0,8) })) * SinOsc.kr(1/48).range(0,1), amp).mean;
	sig = Pan2.ar(sig, SinOsc.ar(sig.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,8) })) * SinOsc.kr(1/58).range(0,1), amp).mean;
	sig = sig + sig1;
	sig = sig * 2.0;
	sig = LPF.ar(sig, 1999);
	sig;
}).play;
);
Ndef(\ota).edit

(
Ndef(\ota, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fac = 1/SelectX.kr( SinOsc.kr(1/113).range(0,6), [1/2,1,2,4,8,64,128] )/8;
	env1 = EnvGen.ar(Env([42,21,42,30,84],[4,4,7.5,0.5]/fac).circle, 1);
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);
	env3 = XLine.kr(1,0.1,20*1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(( x+1 ) * \fmtime.kr(1), mul:env2).range(0,10*x)];
	});
	//freq.debug.shape.debug("freq");
	sig = SinOsc.ar( freq / [1,2,4]);
	//sig.shape.debug("sig1");
	sig = sig.collect({ arg isig, x;
		isig = SelectX.ar( SinOsc.kr(x+1/34).range(0,1), [isig, isig.fold2(env3)]);
		isig = SelectX.ar( SinOsc.kr(1/223 * \tanhtime.kr(1), 3pi/2).range(0,1), [isig, ( isig * SinOsc.kr(1/48 * ( x + 1 )).range(1,100) ).tanh]);
	});
	//sig.shape.debug("sig2");
	sig1 = sig.flop[1];
	sig = sig.flop[0];
	//sig.debug("sig");
	sig1 = Pan2.ar(sig1, SinOsc.ar(sig1.size.collect({ arg x; SinOsc.kr(x/10+1.2).range(0,8) })) * SinOsc.kr(1/48).range(0,1), amp).mean;
	sig = Pan2.ar(sig, SinOsc.ar(sig.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,8) })) * SinOsc.kr(1/58).range(0,1), amp).mean;
	sig = sig + sig1;
	sig = sig / 1.0;
	sig = LPF.ar(sig, 1999);
	sig;
}).play;
);

{ SinOsc.ar(200, 3pi/2) ! 2 * 0.1}.plot

(
Ndef(\ota, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = XLine.kr(71,100,20*1);
	env1 = EnvGen.kr(Env([0,0,70,1],[1,0.01,0.01]/18), Impulse.kr(4));
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);
	env3 = EnvGen.kr(Env([0,0,2,41,200],[4,6,6,16]).circle, 1);


	freq = 18.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	sig = SinOsc.ar(freq / [1,2,4] * ( 1+  ( Ndef.ar(\bigo) * env3 ) )) + Ndef.ar(\bigo);
	sig = BRF.ar(sig, Amplitude.ar(Ndef.ar(\bigo)) * 1000 + 100) + Ndef.ar(\bigo);
	sig.debug("sig");
	sig = sig / 1.0;
	sig = Pan2.ar(sig.flop, SinOsc.kr(sig.flop.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,1) })).range(-1,1), amp).flop.mean;
}).play;
);


(
~t = 1;
Ndef(\bigo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFPulse.ar(70 * [1,1.01,2,1/2]) * LFPulse.kr([1,2,3,4]).range(0,1);
	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,1,
		Dseq([
			1,0,1,0,
			1,0,1,0,
		],3),
		Dseq([
			1,1,1,1,
			1,1,1,1,
		],6),
		Dseq([
			1,0,0,0,
			0,0,0,0,
		],2),
	],inf));
	sig = Pan2.ar(sig, pan, amp).mean;
});
);

Ndef.defaultQuant = 1

(
~t = 1;
Ndef(\kicky, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = TDuty.kr(1/8/~t, 0, Dseq([
		1,0,0,0, 1,0,0,0,
	],inf));

	env4 = EnvGen.kr(Env([1,2000,100,7000],[0.1,0.8,0.2]), PulseDivider.kr(env1, 2));
	env3 = EnvGen.kr(Env([1, env4,101],[0.1,0.08]), env1);

	sig2 = WhiteNoise.ar;
	sig2 = BPF.ar(sig2, env3);
	sig2 = sig2 + BPF.ar(sig2, DelayL.kr(env3,1/4, SinOsc.kr(1/8).exprange(1/16,1/4)));
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[0.0001,0.04]), env1);
	sig2 = DelayL.ar(sig2, 2/5) * SinOsc.kr(1/23).exprange(0.001,1) + sig2;
	sig2 = DelayL.ar(sig2, 2/9) * SinOsc.kr(1/14).exprange(0.001,1) + sig2;

	env2 = EnvGen.kr(Env([0,302,50],[0.01,0.018]), env1);
	sig = SinOsc.ar(env2) ! 2;
	sig = sig + sig2;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
Ndef(\kicky).clear


(
Ndef(\kicky, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = EnvGen.kr(Env([1000,54,1],[0.01,0.8]), 1);
	sig = LFPulse.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\bigo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 50;
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/4,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
}).stop;
);

(
Ndef(\bigo, { arg freq=800, pan=0, amp=0.1;
	var sig;
	//freq = 50;
	sig = SinOsc.ar(freq, mul: SinOsc.kr(1/4).range(1,1000)).tanh/ 4; 
	//sig = sig.tanh;
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
}).stop;
);

(
Ndef(\trico, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 1450 + LFPulse.kr(1/4).range(100,200);
	freq = freq + LFPulse.kr(1/8).range(100,200);
	freq = freq + LFPulse.kr(1/8,3/2pi).range(1000,200);
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\trico, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 1450 * LFPulse.kr(1/4).range(100,200);
	freq = freq + LFPulse.kr(1/8).range(10,31 * LFPulse.kr(1/3,0.1).range(1/2,1));
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\trico, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = 1450 * LFPulse.kr(1/4).range(100,200);
	//freq = freq + LFPulse.kr(1/8).range(10,31 * LFPulse.kr(1/3,0.1).range(1/2,1));
	sig = LFPulse.ar(freq * [1,2,1/2]);
	sig = sig + SinOsc.ar(freq);
	sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,4) ).fold2(1);
	sig = LPF.ar(sig, 1500) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\trico, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,410],[0.1,4.8,4]), Impulse.kr(1));
	freq = 1450 * LFPulse.kr(1/4 * LFPulse.kr(1/8).range(32,1)).range(1,4);
	//freq = freq + LFPulse.kr(1/8).range(10,31 * LFPulse.kr(1/3,0.1).range(1/2,1));
	sig = LFPulse.ar(freq * [1,1/2] );
	sig = SinOsc.ar(freq / [1,2,4,8]* ( 1 + ( SinOsc.ar(freq/2) * env1 ))) + sig;
	//sig = sig + SinOsc.ar(freq);
	//sig = ( sig * LFPulse.kr(1/1,mul:5).range(1,0.04) ).fold2(1);
	sig = RLPF.ar(sig, 8500) + (sig/4);
	sig = RLPF.ar(sig, SinOsc.kr(1/13).exprange(100,12001),0.1) + (sig/4);
	//sig = sig.tanh;
	sig = sig / 8;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);


(
Ndef(\tarte, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	sig = BPF.ar(sig, 4000 * [1,1.2]);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.8,0.1]), Impulse.kr(1));
	sig = sig / 8;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.7, amp).mean;
}).play;
);
(
Ndef(\tarte, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	sig = LPF.ar(sig, 17000 * [1,1.2]);
	sig = HPF.ar(sig, 2000 * [1,1.2]);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.3]), Impulse.kr(1));
	sig = sig / 8;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.4, amp).mean;
}).play;
);
Ndef(\tarte).clear
(
Ndef(\creme, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([1,18000,4301],[0.1,0.08]), Impulse.kr(4)) * SinOsc.kr(1/23).range(1.30,0.11);
	env2 = EnvGen.kr(Env([1,12000,4301],[4.1,4.08]), Impulse.kr(1)) * SinOsc.kr(1/23).range(1.30,0.11);
	sig1 = BPF.ar(sig, env1 * [1,1.2]);
	sig2 = BPF.ar(sig, env2 * [1,1.2]);
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,0,1,0],[0,0.001,0.02]), Impulse.kr([8,4])) * SinOsc.kr([1.01,1/8.01]).range(0,1);
	sig = sig / 2;
	sig = DelayL.ar(sig, 1/4);
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.1, amp).mean;
}).play;
);
(
Ndef(\creme, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([1,18000,4301],[0.1,0.08]), Impulse.kr(4)) * SinOsc.kr(1/23).range(1.30,0.11);
	env2 = EnvGen.kr(Env([1,12000,4301],[4.1,4.08]), Impulse.kr(1)) * SinOsc.kr(1/23).range(1.30,0.11);
	sig1 = BPF.ar(sig, env1 * [1,1.2]);
	sig2 = BPF.ar(sig, env2 * [1,1.2]);
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,0,1,0],[0,0.001,0.02]), Impulse.kr([8,4])) * SinOsc.kr([1.01,1/8.01]).range(0,1);
	sig = sig / 2;
	sig = DelayL.ar(sig, 1/4) + sig;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/4)* 0.1, amp).mean;
}).play;
);

Ndef.defaultQuant = 2

(
Ndef(\frite, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,2,8,0],[4,8,8,8]).circle, 1);
	env2 = DelayL.kr(env1, 8,1/(1..8));
	env3 = EnvGen.kr(Env([0.1,0.2,0.01,0.7,0.1],[6,7,5,8]*2).circle, 1);
	env4 = DelayL.kr(env3, 8,1/(1..8));
	sig = LFSaw.ar(freq);
	sig = 8.collect({ arg x;
		RLPF.ar(sig, freq* env2[x], env4[x]);
	});
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

Ndef(\trico).stop
Ndef(\bigo).stop
Ndef(\ota).stop

(
Ndef(\frite, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,2,8,0],[4,8,8,8]).circle, 1);
	env2 = DelayL.kr(env1, 8,1/(1..8));
	env3 = EnvGen.kr(Env([0.1,0.2,0.01,0.7,0.1],[6,7,5,8]*2).circle, 1);
	env4 = DelayL.kr(env3, 8,1/(1..8));
	env6 = EnvGen.kr(Env([0,0,1,4],[8,8,16]).circle, 1);
	env5 = { arg x; SinOsc.kr(x+1).range(1/2,1) * env6 + 1 };

	sig = LFSaw.ar(freq);
	sig = 8.collect({ arg x;
		RLPF.ar(sig, freq* env2[x] * env5.(x), env4[x]);
	});
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\frite, { arg freq=270, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,2,8,0],[4,8,8,8]).circle, 1);
	env2 = DelayL.kr(env1, 8,1/(1..8));
	env3 = EnvGen.kr(Env([0.1,0.2,0.01,0.7,0.1],[6,7,5,8]*2).circle, 1);
	env4 = DelayL.kr(env3, 8,1/(1..8));
	env6 = EnvGen.kr(Env([0,0,1,4],[8,8,16]).circle, 1);
	env5 = { arg x; SinOsc.kr(x+1).range(1/2,1) * env6 + 1 };

	sig = LFSaw.ar(freq * [1,1/2]);
	sig = 8.collect({ arg x;
		var isig;
		isig = RLPF.ar(sig, freq* env2[x] * env5.(x), env4[x]);
		isig = SelectX.ar( SinOsc.kr(1+x/20).range(0,1), [isig, isig.fold2(0.1)]);
	}).flat;
	sig = HPF.ar(sig, 1000 * SinOsc.kr(1/[34,42]).mean.exprange(1/10,8));
	sig = sig / 4;
	sig = Pan2.ar(sig, SinOsc.kr(sig.size.collect({ arg x; x/10 })) * 0.5, amp).mean;
}).play;
);

Ndef(\kicky).stop
Ndef(\frite).stop
Ndef(\frite).stop
Ndef(\frite).stop
Ndef(\ota).stop
Ndef(\bigo).stop
Ndef(\tarte).stop
Ndef(\creme).stop
(
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env0, Pseq([
		[ Env([0,1,0],[0.001,2.4]) ],
	],inf),
	\env1, Pseq([
		[ Env([66,36,34],[0.01,0.2]) ],
		[ Env([66,38,34],[0.001,0.2]) ],
	],inf).stutter(4),
	\degree, Pseq([0],inf),
	\distmix, Pseq([0,0.1,0.5],inf).stutter(8),
	\dist, 80,
	\distamp, 1/4,
	\dur, 1,
	\out, BusDef(\bus1, \audio, 2),
	\amp, 0.1
)).play;
);

(
Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\rel, 1,
	\snareampenv, [ Env([0,1,0],[0.001,8.48], -2) ],
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],1),
	],inf).coin.not,
	\out, BusDef(\bus1, \audio, 2),
	\amp, 0.1
)).play;
)

Ndef(\creme).stop
Ndef(\frite).stop
(
Ndef(\kickfx, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	var in2 = Ndef.ar(\creme);
	in2 = 0;
	sig = in + in2;
	sig = sig + Fb { arg in;
		var isig2;
		var isig = in*\fb.kr(1.1) + sig;
		//isig = isig + DelayL.ar(isig, 1, 1/70 / SinOsc.kr(1/8).exprange(1/2,16));
		//isig = isig + DelayL.ar(isig, 1, \delay.kr(1/8));
		isig = AllpassL.ar(isig, 1, \delay.kr(1/8) * LFNoise1.kr(1/18).range(1.1,1));
		//isig2 = ( isig * 100 * SinOsc.kr(1/32).range(2,0.2) ).tanh / 78;
		//isig = SelectX.ar( SinOsc.kr(1/16).range(0.8,1), [isig/8, isig2] );
		//isig = isig + DelayL.ar(isig, 1, 1/16 * SinOsc.kr(1/37).exprange(1/2,16), mul:2);
		isig2 = isig * 2;
		isig2 = isig2.tanh;
		isig = SelectX.ar(\distmix.kr(0.45), [isig, isig2]);
		isig2 = Compander.ar(isig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
		isig = SelectX.ar(\cpmix.kr(0.5), [isig, isig2]);
		isig = BRF.ar(isig, SinOsc.kr(1/8).range(100,14991));
		//isig = Limiter.ar(isig,0.4,1) * SinOsc.kr(2/1).exprange(0.4,0.7) / 1;
		//isig = Limiter.ar(isig,0.4,1);
		isig;
	};
	sig = Limiter.ar(sig, \level.kr(0.2));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig;
}).play;
);

Ndef(\kickfx).edit

Ndef(\kickfx).fadeTime = 1/2;

(
Ndef(\kickfx, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	var in2 = Ndef.ar(\frite);
	sig = in + in2.debug("in2");
	sig = sig + Fb { arg in;
		var isig = in/1.1 + sig;
		isig = isig + DelayL.ar(isig, 1/70 * SinOsc.kr(1/21).exprange(1/2,16));
		isig = ( isig * 40 * SinOsc.kr(1/4).range(0.1,1) ).tanh / 8;
		isig = BRF.ar(isig, SinOsc.kr(1/23).range(100,14991));
		isig = Limiter.ar(isig,0.4) * SinOsc.kr(8).range(0,0.5);
		isig;
	};
	sig = Limiter.ar(sig, 0.1) ;
	sig;
}).play;
);

(
Ndef(\kickfx, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\bus1, \audio)), 2); 
	var in2 = Ndef.ar(\frite);
	sig = in + in2.debug("in2");
	sig = sig + Fb { arg in;
		var isig = in/1.1 + sig;
		isig = isig + DelayL.ar(isig, 1/70 * SinOsc.kr(1/21).exprange(1/2,16));
		isig = ( isig * 40 * LFPulse.kr(1/2).range(0.1,1) ).tanh / 8;
		isig = BRF.ar(isig, SinOsc.kr(1/23).range(100,14991));
		isig = Limiter.ar(isig,0.4) * SinOsc.kr(1/45).range(0,1.2);
		isig;
	};
	sig = Limiter.ar(sig, 0.01) * 1;
	sig;
}).play;
);
