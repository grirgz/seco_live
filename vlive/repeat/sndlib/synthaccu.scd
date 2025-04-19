// put here synth that i often use
// that i wrote in some file then use it elsewhere then wonder where is the definition

(
SynthDef(\basicpad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, ( \lpf.kr(8000) * env1 ).clip(20,20000));
	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\sinchord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq * [1/2,1,2];
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\largechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0.1,0.32,2.1],[0.7,1.8])), 1);
	freq = freq * [1/4,1/2,1,2,3,4,5,6,7];
	sig = LFSaw.ar(freq *.x [1,1+\diff.kr(0.00001)]);
	sig = sig + SinOsc.ar(freq,mul:\sinamp.kr(0.2));
	sig = RLPF.ar(sig, ( \lpfr.kr(8.1) * env1 * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);
