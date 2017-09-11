
(
SynthDef(\noise1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = LFNoise1.kr((1..8)/8).exprange(20,19000);
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\phyhat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,2100,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = HPF.ar(sig, 20000-env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\stickfight, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([4410,100,451],[0.1,0.2]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	//env2 = EnvGen.kr(Env([18210,2100,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([110,12100,451],[0.1,0.2],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\snarebpf1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\snarebpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\noise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(10) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,1810,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.3) );
	env2 = EnvGen.kr(Env([171,170,845],[0.04,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/1 ) + ( sig );
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-8),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\phycymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
    var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

    popFreq = EnvGen.ar(Env([8261, 11410, 1460], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.7;
    pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(10) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1180,6810,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.3) );
	env2 = EnvGen.kr(Env([3171,7470,13845],[0.04,\rel.kr(0.1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = pop/2 + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.71,0.9) * XLine.kr(1.3,1,1)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = HPF.ar(sig, env2);
	sig = LPF.ar(sig, 17000);
	sig = LPF.ar(sig, 11000) + ( sig/2 );
	//sig = BRF.ar(sig, MouseX.kr(20,20000).poll, MouseY.kr(0.1,1));
	sig = BRF.ar(sig, 12000);
	sig = sig * 0.6;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.1,0.1,0.8,0.4,1,-8) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\funkydrummer, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snarebpf,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	])
).play;
)
