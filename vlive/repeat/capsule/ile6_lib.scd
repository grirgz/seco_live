
(
SynthDef(\cymnoise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=1;
var sig;
var env1, env2, env3, env4, env5, env6, env7, env8;
var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
sig = SinOsc.ar(freq);
sig = WhiteNoise.ar;
env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
sig = HPF.ar(sig, 20000-env2);
sig1 = sig;
//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
sig = WhiteNoise.ar;
env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
sig = sig + Ringz.ar(sig, [9400,17030,16410,8000.14,15000] * env3, 0.001).mean/10;
env1 = EnvGen.kr(Env([14821,14810,14251,1100],[0.01,0.1*fac1,0.1], 4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
env2 = EnvGen.kr(Env([4820,4000,3151],[0.07,0.8*fac1],4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
sig = HPF.ar(sig, env1);
sig = LPF.ar(sig, env2);
sig2 = sig*1.3;

sig = sig1+sig2;

sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.08,1,-4),gate,doneAction:2);
sig = Pan2.ar(sig, pan, amp).sum;
Out.ar(out, sig);
}).add;
);

(
// load
11.do { arg idx;
	BufDef(\smp+++idx, "~/Musique/sc/reckit/loop/min%_135bpm.flac".format(idx).standardizePath)
};
)
