// two kinds of sounds:
// - crash: start big, 0 attack and long release
// - riser: start small, long exp attack and 0 release

// lib
(
Pdef(\part, Pdef(\kickdemo, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);
/////////////////

Pdef(\demo).stop
FileSystemProject.loadOnce("algokit/kits/PatKitDef_sample1.scd");
(
// reversed snare
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, -1 * 1.0,
			\pos, 1/2/~t,
			\sustain, 1.9,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
)).play;
)

(
// reversed snare
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1396].value,
			\bufnum, ~buflib.snare[132].value,
			\bufnum, ~buflib.snare[2518].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\speed, -0.5,
			\pos, 1/4/~t * Pkey(\speed).abs,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			//\lag, -0.07,
			\legato, 2,
			\gain, 0.21,
		),
		
	])
)).play;
)

/////// pitch based

(
SynthDef(\islurp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.9]*4,[ 1,-1 ]), 1).round(0.1);
	env2 = EnvGen.kr(Env([1,20,1,1/2],[0.1,0.9,1]*4), 1).round(0.1);
	env3 = EnvGen.kr(Env([1,1.20,0.1],[0.1,0.9]*4), 1).round(0.1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * env3) * env2 + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.01),gate,doneAction:2);
	sig = sig * EnvGen.kr(Env([0,1,0],[1.0,0.08], [4,-1]), 1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \islurp,
		\freq, 200,
		\legato, 4,
		\isRest, Pseq([
			1,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 1,0, 0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
SynthDef(\metalcut, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.9]*4,[ 1,-1 ]), 1).round(0.1);
	env2 = EnvGen.kr(Env([100,200,1,1/2],[0.1,0.9,1]*4), 1).round(0.1);
	env3 = EnvGen.kr(Env([1,120,0.1],[0.1,0.9]*4), 1).round(0.1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * env3) * env2 + 1 ));
	//sig = CombL.ar(sig, 4/~t,0.01,1.1) + sig;
	sig = AllpassL.ar(sig, 4/~t,0.1,1.1) + sig;
	sig = FreeVerb.ar(sig,1,2);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,3.01),gate,doneAction:2);
	//sig = sig * EnvGen.kr(Env([0,1,0],[1.0,0.08], [4,-1]), 1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \metalcut,
		\freq, 800,
		\legato, 4,
		\isRest, Pseq([
			1,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 0,0, 0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
SynthDef(\nidi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,10,40,1],[4,4.1,0.8]), 1);
	sig = SinOsc.ar([234,234.43] * ( SinOsc.ar(freq) * env1 + 1 )).mean;
	sig1 = ( sig*\distamp.kr(1)*env1 ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(2.01,0.1,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \nidi,
			\freq, 200,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
)


(
SynthDef(\echh, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,12000,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,1000,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,7100,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echh,
		\freq, 800,
		\legato, 1,
		\dur, Pn(4,1),
		\amp, 0.1,
	),
).play;
)



(
SynthDef(\echhlow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,420,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,100,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echhlow,
		\freq, 200,
		\legato, 1,
		\dur, Pn(4,1),
		\amp, 0.1,
	),
).play;
)

(
SynthDef(\echhhi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,10420,182],[0.04,5.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,10100,152],[0.04,4.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(7700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RHPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = LPF.ar(sig,  15000, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echhhi,
		\freq, 200,
		\legato, 1,
		\dur, Pn(1,1),
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\amp, 0.1/2,
	),
).play;
)

///////
(
// HPF hi to low
SynthDef(\wooshnoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var duration = 4/~t;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 4400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[duration,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;
	sig = HPF.ar(sig, XLine.kr(15000,100,duration));
	sig = sig * 20.dbamp;
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0,1,0.01,1,3)), gate, doneAction:2);
	sig = sig *   EnvGen.kr( Env.perc(duration, 0.01,1,3), doneAction:2 );
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\zed, 
	Pbind(
		\instrument, \wooshnoise,
		\degree, Pseq([0],inf),
		\dur, 4,
		\amp, 0.1,
	)
).play;
);

(
// HPF lo to hi
SynthDef(\wooshnoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var duration = 4/~t;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 4400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[duration,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;
	sig = HPF.ar(sig, XLine.kr(10,15000,duration));
	sig = sig * 20.dbamp;
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0,1,0.01,1,3)), gate, doneAction:2);
	sig = sig *   EnvGen.kr( Env.perc(duration, 0.01,1,3), doneAction:2 );
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// LPF lo to hi
SynthDef(\wooshnoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var duration = 4/~t;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 4400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[duration,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;
	sig = LPF.ar(sig, XLine.kr(10,15000,duration));
	sig = sig * 20.dbamp;
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0,1,0.01,1,3)), gate, doneAction:2);
	sig = sig *   EnvGen.kr( Env.perc(duration, 0.01,1,3), doneAction:2 );
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// LPF hi to lo
SynthDef(\wooshnoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var duration = 4/~t;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 4400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[duration,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;
	sig = LPF.ar(sig, XLine.kr(19000,1000,duration));
	sig = sig * 20.dbamp;
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0,1,0.01,1,3)), gate, doneAction:2);
	sig = sig *   EnvGen.kr( Env.perc(duration, 0.01,1,3), doneAction:2 );
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

//////////////////:



(
Ndef(\woof, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 1/2;
	sig = WhiteNoise.ar;
	sig = Saw.ar(70 * EnvGen.kr(Env([1,2,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(100) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([200,5000,5000],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = BPF.ar(sig, EnvGen.kr(Env([201,5000 * [1,1.1,2],1],[1.1 * tscale,0.8]), 1), 1) + ( sig/4 );
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,3.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	pan = pan + SinOsc.ar((1..sig.size) * 100/1, mul: EnvGen.kr(Env([0,0.51,0],[1.1,0.8]), 1);); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig;
}).play;


Ndef(\woof2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 2/2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar;
	sig = PinkNoise.ar * Duty.kr(1/32/~t, 0, Dseq([
		1,0,0,1,
		1,0,1,0,
		1,0,0,1,
	],inf));
	sig2 = Pulse.ar(70 * EnvGen.kr(Env([8,1,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(400) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig2 = sig2  * Duty.kr(1/30/~t, 0, Dseq([
		0,1,0,1,
		1,1,0,1,
		1,0,1,0,
	],inf));
	sig = sig + sig2;
	sig = FreqShift.ar(sig, EnvGen.kr(Env([0,-0.2,-31],[1.1,0.8]), 1)) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([14200,500,500],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,1.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
	sig;
}).play;
);


///////////////:



(
SynthDef(\metaldetune, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 40;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = LFNoise1.ar(0.1);
	freq = Rand(100.0,4000!num);
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * lfo1) * lfo1 * 3 + 1 ));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \metaldetune,
			\freq, 900,
			\dur, 1,
			\amp, 0.1,
		),	
	])
)).play;
);

//////////////// short noise
// from sun23
(
SynthDef(\shorthinoise1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var bpftab;
	env1 = EnvGen.kr(Env([1,1,0.1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[0.1,0.8]), 1);
	sig = PinkNoise.ar;
	bpftab = \bpftab.kr(exprand(100,17000!num));
	sig = num.collect { arg idx;
		BPF.ar(sig, bpftab[idx] * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise1,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var bpftab;
	env1 = EnvGen.kr(Env([1,1,1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[1.1,0.8]), 1);
	env3 = EnvGen.kr(Env([100,10000,100],[1.1,0.1],1,1), gate, timeScale:timeScale);
	sig = PinkNoise.ar;
	bpftab = \bpftab.kr(exprand(100,17000!num));
	sig = num.collect { arg idx;
		BPF.ar(sig, bpftab[idx] * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = LPF.ar(sig, env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise2,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1/1,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var bpftab;
	env1 = EnvGen.kr(Env([1,1,1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[1.1,0.8]), 1);
	env3 = EnvGen.kr(\lpfenv.kr(Env([100,10000,100],[1.1,0.1],1,1)), gate, timeScale:timeScale);
	sig = WhiteNoise.ar;
	bpftab = \bpftab.kr(exprand(100,17000!num));
	sig = num.collect { arg idx;
		BPF.ar(sig, bpftab[idx] * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = LPF.ar(sig, env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise3,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1/1,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

/////////////////// up ramp

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,4,20);
	sig = SinOsc.ar(freq * lfo1 * ( SinOsc.ar(freq+lfo1 * [1,1/4,1/8]) * lfo1 + 1 ) );
	sig = sig * SinOsc.ar([1,4,8]).unipolar; 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan) * 2;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,7,3,
	],inf)).midiratio * freq * [0,3,7].midiratio;
	lfo1 = XLine.kr(1,4,20);
	lfo1 = lfo1 * ( SinOsc.kr(1/4) * 0.1 + 1 );
	sig = SinOsc.ar(freq  * ( SinOsc.ar(freq+( lfo1 * [1,1/4,1/8] )) * lfo1 + 1 ) );
	sig = sig + RHPF.ar(sig, \lpfr.kr(1.1) * ( SinOsc.kr(1* [1,1/4,1/8]) * lfo1/4 + 1.1 ) * freq * lfo1, \rq.kr(0.5));
	sig = sig + RLPF.ar(sig, \lpfr.kr(1.1) * ( SinOsc.kr(3* [1,1/4,1/8]) * lfo1/4 + 1.1 ) * freq * lfo1, \rq.kr(0.5));
	sig = sig * ( SinOsc.ar([1,4,8]).unipolar * lfo1 + 1 ) / lfo1; 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan) / 2;
}).play;
);

////////////////// detune chord and exp

(
// from sun67
SynthDef(\chordgrow, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([1,4000,1],[6.1,4.8],\exp), 1);
	lfo2 = EnvGen.kr(Env([1/3,20,1],[6.1,4.8],\exp), 1);
	sig = SinOsc.ar(freq * \chord.kr([0,4,7]).midiratio);
	sig = sig + LFSaw.ar(freq/2 * \chord.kr([0,4,7]).midiratio);
	sig = sig.mean;
	sig = sig + DelayC.ar(sig, 0.1,0.0001 * lfo1);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(5.1,0.1,0.8,0.1,1,4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \chordgrow,
			\note, 0,
			\chord, Pseq([
				[ [2,5,8] ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);


/////////////////::
// granulation


(
// from sun83
SynthDef(\grancruhp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum, gdur=0.1, gfreq=8, pos=0, pitch_stretch=1;
	var sig;
	var clk = Impulse.ar(gfreq);
	pos = pos + LFNoise1.ar(gfreq,mul:0.01);
	//pitch_stretch = pitch_stretch + LFNoise1.ar(10, mul:0.1);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = HPF.ar(sig, \hpf.kr(1000));
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \grancruhp,
			\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
			\pos, ~pmodenv.(Pseq([2.4,1]+3,1), 4).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.4) ],
			],inf),
			\gfreq, 840,
			\hpf, PmodEnv(Pseq([10000,100],1), 4).loop,
			\gdur, 0.08,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 2,
			\gain, 13.dbamp,
		)
		
	])
)).play;
)


/////////////// pschiou


(
// whitenoise in a closing filter is the essence
// phasering delay is the secret
SynthDef(\pschiou, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpfr.kr(1) * XLine.kr(10000,100,\time.kr(4/~t)), \rq.kr(0.5) * XLine.kr(1,0.3,4/~t));
	sig = sig + DelayL.ar(sig, 0.9, 0.01 * XLine.kr(0.01,0.81,\time.kr));
	//sig = sig + DelayL.ar(sig, 0.9, 0.01 * XLine.kr(0.001,0.81,4/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pschiou,
			\dur, 2,
			\time, 2,
			\amp, 0.1,
		),
	])
)).play;
);

///////////////// bee swarm

(
SynthDef(\fmrander, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(
		( freq * ( ExpRand(0.100,0.7000!16) * 0.007 + 1 ) )
		* ( SinOsc.ar(ExpRand(0.0100,0.07000!16)/1).round(0.01) * SinOsc.ar(Rand(0.100,0.7!16)/10).range(0,0.9) + 1 )
		* ( SinOsc.ar(ExpRand(100,7000!16)) * SinOsc.ar(Rand(0.100,0.7!16)).range(0,0.03) + 1 ) 
	);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq, \rq.kr(0.5));
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmrander,
			\note, Pseq([
				0,4,12,
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// with hpf
SynthDef(\fmrander, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(
		( freq * ( ExpRand(0.100,0.7000!16) * 0.007 + 1 ) )
		* ( SinOsc.ar(ExpRand(0.0100,0.07000!16)/1).round(0.01) * SinOsc.ar(Rand(0.100,0.7!16)/10).range(0,0.9) + 1 )
		* ( SinOsc.ar(ExpRand(100,7000!16)) * SinOsc.ar(Rand(0.100,0.7!16)).range(0,0.03) + 1 ) 
	);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq, \rq.kr(0.5));
	//sig = Pan2.ar(sig, pan, amp);
	sig = HPF.ar(sig, XLine.kr(10,19000,4/~t));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);


/////////// gen_transi
// from sun73

(
SynthDef(\transi1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,0.1,2);
	lfo2 = Line.kr(0.01,0,1);
	lfo3 = XLine.kr(1,2.1,2);
	sig = LFCub.ar(freq * [1,1 + lfo2 ] * ( LFSaw.ar(freq) * lfo1 + 1 ) * XLine.kr(1,-1.midiratio,2));
	sig = sig.mean;
	sig = BPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo3 ).clip(20,20000), \rq.kr(0.5));
	//sig = sig * LFSaw.ar(freq * lfo1);
	sig = sig.fold2(lfo1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(3.1,0.1,0.8,0.1,1,4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
~gen_transi = { arg seed=1234, num=12;

	SynthDef(\transi_v+++seed+++\_n+++num, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1, freqfac=1;
		var sig;
		var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
		//var num = 17;
		var xfreq;
		thisThread.randSeed = seed;
		freq = exprand(100,18000!num) * freqfac;
		lfo1 = XLine.kr(0.1,0.01,2/~t * timeScale);
		lfo2 = XLine.kr(2,0.001,2/~t * timeScale);
		lfo3 = XLine.kr(0.2,0.9,1/~t * timeScale);
		//lfo1 = LFNoise1.ar(0.1);
		sig = SinOsc.ar(freq * ( LFSaw.ar(freq * lfo1) * lfo1 * 3 + 1 ));
		sig = sig.mean;
		//sig = BPF.ar(sig, freq * lfo2,0.05)*2 + sig;
		sig = RHPF.ar(sig, freq * lfo2,0.5);
		sig = FreeVerb.ar(sig, mix:1 * lfo3, room:1.5, damp:0.5);
		//sig = sig * LFSaw.ar(freq * lfo1);
		//sig = sig.fold2(lfo1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1,1,[4,4,-4])), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
}
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		Pbind(
			\instrument, Pseq([
				~gen_transi.(12340),
				~gen_transi.(12343),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\timeScale, 1,
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\legato, 2,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		Pbind(
			// start small
			\instrument, Pseq([
				~gen_transi.(42364,10),
				//~gen_transi.(42345),
			],inf).stutter(4),
			\freqfac, Pseg(Pseq([1,-7.midiratio],1),4).loop,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\timeScale, 1/4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 1/8,
			\legato, 1,
			\amp, 0.1/4,
		),
	])
)).play;
);

(
// with long release
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(32340),
				~gen_transi.(32343),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0, 
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 4,
			\legato, 1,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
// with short release
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		Pbind(
			// start big
			\instrument, Pseq([
				~gen_transi.(32340),
				~gen_transi.(32343),
			],inf).stutter(8),
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\timeScale, 4,
			\adsr, Pseq([
				[ Env.adsr(3.1,0,1,0.01,1,1) ],
			],inf),
			\dur, 4,
			\legato, 1,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\kickdemo),
		Pbind(
			\instrument, ~gen_transi.(12333),
			\isRest, Pseq([
				0,1,0,0,
			],inf).coin.not,
			\dur, 1,
			\legato, 1,
			\amp, 0.1*2,
		),
	])
)).play;
);

//////////////////////// foley
// from sun73

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		Pbind(
			\instrument, \playersec_hlpf,
			\lpf, 4000,
			\lpmix, 1,
			\bufnum, ~buflib.foley1[22].value,
			\speed, 1,
			\pos,0.1,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				//[ Env.adsr(0.1,0.1,0.8,1.1) ],
				[ Env.adsr(2.1,0.1,0.8,0.1) ],
			],inf).stutter(8*8),
			\legato, 2,
			\dur, 1/8,
			\gain, 1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		Pbind(
			// bottle end
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[255].value,
			\speed, 0.5,
			\pos,0,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				//0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(1.1,0,1,0.1,1,1) ],
			],inf),
			\legato, 4,
			\dur, 1/8,
			\gain, 2/1,
		),
	])
)).play;
);

// foley with reverb
// from sun83


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[449].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
			//\isRest, true,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[49].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\kickdemo),
		
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\bufnum, ~buflib.foley1[315].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\legato, 4,
			\gain, 0.1,
			\out, BusDef(\pfx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 3,
			\damp,0.4,
			\gain, 2,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);
///////////////////////// fxreverse
// from catalog/explore/reverse_reverb.scd

(
SynthDef(\fxreverse, { arg out=0, gate=1, bufnum, speed=(-1);
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var rec;
	var trig = Impulse.kr(0);
	var playtrig;
	sig = in;
	playtrig = DelayN.ar(trig, \duration.kr(1/~t), \duration.kr);
	rec = RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:0, run:1, loop:0, trigger:trig);
	Trig.kr(playtrig);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, playtrig, startPos: \duration.kr * BufSampleRate.kr(bufnum), doneAction:0, loop: 0);
	sig = sig * EnvGen.kr(Env([0,1,1,0],[\at.kr(0.01),\duration.kr-0.01-\at.kr,0.01], \curve.kr(0)), playtrig, doneAction:2);
	sig = sig + (in * \drygain.kr(0));
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
BufDef(\rev3, 3/~t * s.sampleRate, 2);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, 0.5,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\amp, 0.1,
		),
		Ptpar([
			2, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[385].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\dur, Pn(2,1),
					\gain, 0.11,
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \fx_freeverb2,
					\inbus, BusDef(\verb, \audio),
					\addAction, \addToTail,
					\room, 3,
					\lag, 0.0009,
					\dur, Pn(3,1),
					\out, BusDef(\reverse, \audio),
				),
				Pbind(
					\instrument, \fxreverse,
					\inbus, BusDef(\reverse, \audio),
					\duration, 3/~t,
					\addAction, \addToTail,
					\lag, 0.0009,
					\drygain, 0,
					\legato, 1,
					\bufnum, BufDef(\rev3),
					\dur, Pn(6,1),
					\amp, 0.1,
				),
			]),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1097].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[577].value,
				\sustain, 0.1/2,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		
	])
)).play;
);

(
BufDef(\rev4, 4/~t * s.sampleRate, 2);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[577].value,
				\sustain, 0.1/2,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			0, Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
					\bufnum, ~buflib.foley1[49].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],1).coin.not,
					\dur, 1/4,
					\legato, 4,
					\gain, 0.7,
					\pos, 0.1, // the sound start a bit late, compensate
					\lag, -0.051, // same
					\out, BusDef(\verb, \audio),
				),
				Pbind(
					\instrument, \fx_freeverb2,
					\inbus, BusDef(\verb, \audio),
					\addAction, \addToTail,
					\room, 3,
					\lag, 0.0009,
					\dur, Pn(4,1),
					\out, BusDef(\reverse, \audio),
				),
				Pbind(
					\instrument, \fxreverse,
					\inbus, BusDef(\reverse, \audio),
					\duration, 4/~t,
					\addAction, \addToTail,
					\lag, 0.0009,
					\legato, 1,
					\drygain, 0,
					\at, 2.0, // attenuate start of sound
					\curve, 3, // same
					\bufnum, BufDef(\rev4),
					\dur, Pn(8,1),
					\amp, 0.1,
				),
			]),
			8, Pbind(
				\instrument, \sh101,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\dur, 1/8,
				\legato, 0.5,
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\amp, 0.1,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1097].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
		]),
		
	])
)).play;
);

/////////////////// big crash
// from catalog/explore/bigcrash.scd



// big crash with internal verb
(
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(8000) * 10000; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// big crash
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bigcrash,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// with bass
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(800) * 10000; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// mid
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([5000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([10000,10,1],[0.006,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
// with tone
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([5000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([15000,1000,1],[0.006,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// with bass tone 
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,8510,1],[0.115,0.018]), 1);
	env2 = EnvGen.kr(Env([150,14470,4001],[0.006,0.008]), 1);
	mod1 = LFSaw.ar(80, pi/2 * 0.4) * 888; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// with doom tone 
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,85,50],[0.115,2.018]), 1);
	env2 = EnvGen.kr(Env([15150,870,301],[0.006,0.8]), 1);
	mod1 = SinOsc.ar(70, pi/2 * 0.4) * 388; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// with chirp
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([5000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([15000,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// with chirp 2
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,510,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([15000,470,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(8800, pi/2 * 0.4) * 8811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// with clave
SynthDef(\bigcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([1500,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

//////////////////////// trans balienrise
// from sun58
(
Pdef(\part, Pdef(\balienrise1, 
	Ppar([
			Pbind(
				\instrument, \oscsampler3,
				\pos, 0.012,
				//\fshift, -148,
				\lpmix, 0.41,
				\hpmix, 0.0,
				\hpfreq, 10,
				\rq, 0.1,
				\posenv, Pseq([
					[ Env([0.004,0.0019,0.1071].integrate.postln,[0.42,8.4]) ],
				],inf),
				\posenv, Pseq([
					[ Env([0.000,0.0002,0.0021].integrate.postln,[0.12,8.4]) ],
				],inf),
				\pos, 0.1 * [1,2,3,4,5,10,20],
				\levelScale, 8*2,
				\timeScale, 2,
				\range, 0.0007,
				//\range, ~pmodenv.(Pseq([1,2,1,4]*0.00003,1), 2).loop,
				\ffreq, 1000,
				\note, Pseq([
					0,
				],inf).stutter(8),
				\octave, 3,
				\bufnum, BufDef.stereo('voices/kaspi.flac'),
				\ffreqtab, Pseq([[Array.geom(8,2.1,0.8).postln]],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.3,0.5,0.21) ],
				],inf),
				\legato, 8.0,
				\dur, 1,
				\isRest, Pseq([
					1,0,0,0,
					0,0,0,0,
				],1).coin.not,
				\amp, PmodEnv(Pseq([0.01,1]*0.081,1), 8,\exp).loop,
			),
		
	])
)).play;
);

//////////////////////// trans with fx
// todo

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,3,7,12,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, Pstep([ BusDef(\verb, \audio), 0], Pseq([8,24])),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 3,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([12000,80],1), 8,\exp),
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			8, Pdef(\kickdemo)
		]),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,3,7,12,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fxbus, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\fxbus, \audio),
		),
		Pbindf(Pdef(\kickdemo), \out, BusDef(\fxbus, \audio)),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\fxbus),
			\pregain, 1,
			\postgain, PmodEnv(Pseq([0,0,1,1],1), Pseq([8,0.1,7.9],inf)),
			\delay, 0,
			\send0, PmodEnv(Pseq([1,1,0,0],1), Pseq([8,0.1,7.9],inf)),
			\sendbus0, BusDef(\verb, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\verb, \audio),
			\addAction, \addToTail,
			\room, 3,
			\lag, 0.0009,
			\mix, 1,
			\dur, 1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([12000,80,200],1), 8,\exp),
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

//////////////////////// trans with fmbell
// todo


//////////////////////// trans with downing bass annoucing bass
// todo

(
SynthDef(\downbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(XLine.kr(80,40,1/~t));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			7, Pbind(
				\instrument, \downbass,
				\freq, 200,
				\dur, Pn(1,1),
				\amp, 0.1,
			),
			8, Pdef(\kickdemo),
			8.5, Pdef(\kickdemo),
		]),

		
	])
)).play;
);

////////// to rip
// - sun22
// - other sdesign

//////////////////////// echo

(
// from sun83
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\kickdemo),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0.53,
			\speed, 1.2,
			\legato, 1,
			\dur, Pseq([Rest(1.75),Pn(0.4,1)]),
			\gain, 1/4,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			\decay,5,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

//////////////// filler

(
// amp rise
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pdef(\kickdemo),
			0.5, Pdef(\kickdemo),
			6, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1877].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0.01,1],1),2,3),
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),

		
	])
)).play;
);

(
// amp rise and speed decrease with linear curve
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pdef(\kickdemo),
			0.5, Pdef(\kickdemo),
			6, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1877].value,
				\speed, PmodEnv(Pseq([2,1],1), 2, 0).loop,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0.01,1],1),2,3),
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),

		
	])
)).play;
);

(
// amp rise and speed decrease with exp curve
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pdef(\kickdemo),
			0.5, Pdef(\kickdemo),
			6, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1877].value,
				\speed, PmodEnv(Pseq([2,1],1), 2, 3).loop,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0.01,1],1),2,3),
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),

		
	])
)).play;
);
(
// amp rise and speed decrease with log curve
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pdef(\kickdemo),
			0.5, Pdef(\kickdemo),
			6, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1877].value,
				\speed, PmodEnv(Pseq([2,1],1), 2, -3).loop,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0.01,1],1),2,3),
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),

		
	])
)).play;
);

(
// amp rise and speed rise
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ptpar([
			0, Pdef(\kickdemo),
			0.5, Pdef(\kickdemo),
			6, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1877].value,
				\speed, PmodEnv(Pseq([1/2,1],1), 2, 0).loop,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseg(Pseq([0.01,1],1),2,3),
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),

		
	])
)).play;
);


