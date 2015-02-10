
(7/( 7+1 ))*7+7
1

7+(7*7) * (()1/7)
(1+7)

( (7*7)+1 ) * ( ( 7+7 )/7 )

100/(7+7)-(1/(7+7)) = 7
100/(7+7)
1/(7+7)

1+(1/7) * (7+7)
( 7+7 )/7
( 7*7 )+1

(7+7)*(7+1)
s.sampleRate/ ( s.options.blockSize*2 )

(7*(7+1))-(7)+1o
7*(7-1)/(7+1)

(10/6*4)
10/24
6*4


~melodyList = [0,2,3,1,1,1,1,1,1,1,1,1,7,8,9];
~melodyList = [0,2,3,2,2,2,2,2,2,2,2,2,7,8,9];
~melodyList = [0,2,3,2,2,7,7];
(
Pdef(\plop, Pbind(
	\degree, Prout({
		var c = 0;
		while({c < ~melodyList.size}) {
			y = ~melodyList[c];
			y.yield;
			c = c + 1;
		}
	}).loop % 3,
	\dur, 1/4,
)).trace.play;
);

( Pseq((1..8)) % 3 ).asStream.nextN(10)

PSSeq
PS

(
Pdef(\plop, Pbind(
	\degree, PLseq(\melodyList),
	\dur, 1/4,
)).play;
);


y = { Mix( SinOsc.ar(1000, 0, 1.0).dup  )  }.play; // OK
y = { Mix( SinOsc.ar(1000, 0, 0.9999).dup  )  }.play; // silent ??
y = { Mix( SinOsc.ar(1000, 0, 1.000001).dup  )  }.play; // silent ??

0.999*0.999


(
play {
var v0, v1, v2, v3, v4, v5, v7, v8, v9, v10, v12;
var v14, v15, v16, v17, v18, v19, v20, roots, sig;
v0 = 6371.5044;
v1 = -0.115686424;
v2 = LFDNoise3.ar([v1, v1]);
v3 = 2586.9963;
v4 = 1203.7903;
v5 = 42.465885;
v7 = v2 % v5;
v8 = Impulse.ar(v5, v7);
v9 = T2K.kr(v8);
v10 = LPZ1.ar(K2A.ar(v9));
v12 = 0.0012178319;
v14 = InRect.ar(v8, v10, Rect(v0, v7, v8, v12));
v15 = LFCub.ar(v7, v9);
v16 = LinCongL.ar(v4, v15, v4, v3, v0);
v17 = 0.013108879;
v18 = Ringz.ar(K2A.ar(v17), v10, v10);
v19 = Delay2.ar(v10);
v20 = LFTri.ar(v5, v17);
roots = [v20, v19, v18, v16, v14];
sig = Mix(roots);
Limiter.ar(LeakDC.ar(sig))
}
)


(
x = play {
var v0 = \v0.kr(0.013685876);
var v1 = \v1.kr(0.013685876);
var v2 = \v2.kr(9418.244);
var v3 = FSinOsc.ar(v2, v1);
var v4 = \v4.kr(42.465885);
var v5 = Ringz.ar(K2A.ar(v0), v4, v3);
var v6 = \v6.kr(1549.478);
var v7 = \v7.kr(0.02286103);
var v8 = \v8.kr(9.56704);
var v9 = Ringz.ar(K2A.ar(v8), v0, v5);
var v10 = LFCub.ar(K2A.ar(v1), v9);
var v11 = LFDNoise3.ar([v10, v10]);
var v12 = LinXFade2.ar(K2A.ar(v6), K2A.ar(v7), v5, v11);
var v13 = \v13.kr(2210.7979);
var v14 = Dust2.ar([v10, v10]);
var v15 = TwoPole.ar(v14, v13, v3);
var v16 = scaleneg(v15, v10);
var v17 = HPF.ar(v9, v13);
var v18 = RunningMax.ar(K2A.ar(v6), v15);
var v19 = SinOsc.ar(v11, v6);
var roots = [v19, v18, v17, v16, v12];
var sig = Mix(roots);
sig = sig / 2;
Limiter.ar(LeakDC.ar(sig));
}
)

x.set("v2", 9418.244); // slow down (don't ask why this value)
x.set("v2", 9418.100);
x.set("v2", 9418.000);
x.set("v2", 417.900);
x.set("v2", 9417.800);

x.set("v2", 9418.300); // speed up

x.set("v4", 43.0 * 2/4); // fundamental
x.set("v4", 43.0);

x.set("v13", 422); // resonance


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	lfreq = 400;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,3,0,
	],inf)).midiratio * 70;
	sig = LinCongL.ar(freq * (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),0.1 * SinOsc.kr(1/4).range(1,5));
	sig = sig.tanh;
	sig = sig * 2;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);

(
	// hurlement de mort vivants
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(2/~t, 0, Dseq([
		1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,0.7), gate, doneAction:0);
	env2 = EnvGen.kr(Env.adsr(0.2,0.7,1.8,0.04), gate, doneAction:0) * 0.3 + 1;
	env3 = EnvGen.kr(Env([0.2,0.2,2,2,2.3],[0,1,0.5,0.1]), gate, doneAction:0) * 0.3 + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		0
		//1,0,3,0,
	],inf)).midiratio * 70 * env3;
	sig = LinCongL.ar(freq * (1..8) * env2, 1.1 * env2, 1.02 * env2, 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 ));

	sig = sig.tanh;
	sig = sig * 2;
	sig = sig * env1;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	lfreq = 400;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,3,0,
	],inf)).midiratio * 70;
	sig = LinCongL.ar(freq * (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1));
	sig = sig.tanh;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);
