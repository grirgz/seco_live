(
TempoClock.default.tempo = t = 1;
)

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=1000, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\kick, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5|
	var env0, env1, env1m, son;

	env0 = \env0.kr(Env.new([9.5, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 29, 59], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2);
	env1 = EnvGen.ar(env1);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Pan2.ar(son, pan);
	
	OffsetOut.ar(out, son);
}).store;

SynthDef(\dwgplucked, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0, cuspfreq=1000, pos=0.1, c1=0.6, spread=0.8|
    var env = Env.new([0,1, 1, 0],[0.001,0.406, 0.4005],[5,-5, -8]);
    var inp = amp * CuspN.ar(cuspfreq) * EnvGen.ar(env,gate);
    var son;
	freq = freq * [1,1.01,0.99];
	son = DWGPlucked.ar(freq, amp, gate,pos,c1,c3,inp);
    DetectSilence.ar(son, 0.001, doneAction:2);
	son = Splay.ar(son, spread, amp, pan);
    Out.ar(out, son);
}).add;

SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, fac1=500, fac2=200, decay=4;
	var sig, sig1, sig2, sig3;
	var impulse = Decay.ar(Impulse.ar(0.5),0.1);
	impulse = BPF.ar(impulse*fac1, 50).sin;
	sig = Pluck.ar(impulse, LFSaw.ar(1000), 0.1, 1/fac2, decay)  ! 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)
