
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var n = 16;
	freq = exprand(50.0,11000!n);
	lfo1 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0))*0.1+1;}.dup(n);
	lfo2 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo3 = {XLine.kr(exprand(1.0,15000),exprand(1.0,15000), rrand(10,100.0));}.dup(n);
	lfo4 = exprand(50.0,11000!n);
	lfo5 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	sig = LFSaw.ar(freq * ( SinOsc.ar(lfo1 * lfo4) * 1 + lfo2 ));
	sig = DelayL.ar(sig, 0.1, lfo2 *0.01)+sig;
	sig = DelayL.ar(sig, 0.1, lfo5 *0.01)+sig;
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect(_.ar(sig, lfo3, 1));
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig[i], lfo3[i], 1)});
	sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, 1)});
	sig = Splay.ar(sig, 1, amp, pan);
	sig;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var n = 16;
	freq = exprand(50.0,11000!n);
	lfo1 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0))*0.1+1;}.dup(n);
	lfo2 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo3 = {XLine.kr(exprand(1.0,15000),exprand(1.0,15000), rrand(10,100.0));}.dup(n);
	lfo4 = exprand(50.0,11000!n);
	lfo5 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	sig = LFSaw.ar(freq * ( SinOsc.ar(lfo1 * lfo4) * 1 + lfo2 ));
	sig = DelayL.ar(sig, 0.2, lfo2 *0.2)+sig;
	sig = DelayL.ar(sig, 0.2, lfo5 *0.2)+sig;
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect(_.ar(sig, lfo3, 1));
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig[i], lfo3[i], 1)});
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, 1)});
	sig = [{[RLPF,RHPF,BPF].choose}.dup(16), sig, lfo3].flop.collect({ arg u, i; u[0].ar(u[1], u[2], 1)});
	sig = Splay.ar(sig, 1, amp, pan);
	sig;
}).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var n = 16;
	freq = exprand(50.0,11000!n);
	lfo1 = {EnvGen.kr(Env([0.01,1,0.01],[0.01,10.8]), 1)}.dup(n);
	//lfo1 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0))*0.1+1;}.dup(n);
	lfo2 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo3 = {XLine.kr(exprand(1.0,15000),exprand(1.0,15000), rrand(10,100.0));}.dup(n);
	lfo4 = exprand(50.0,11000!n);
	lfo5 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	sig = LFSaw.ar(freq * ( SinOsc.ar(lfo1 * lfo4) * 1 + lfo2 ));
	sig = DelayL.ar(sig, 0.2, lfo2 *0.2)+sig;
	sig = DelayL.ar(sig, 0.2, lfo5 *0.2)+sig;
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect(_.ar(sig, lfo3, 1));
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig[i], lfo3[i], 1)});
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, 1)});
	sig = [{[RLPF,RHPF,BPF].choose}.dup(16), sig, lfo3].flop.collect({ arg u, i; u[0].ar(u[1], u[2], 1)});
	sig = Splay.ar(sig, 1, amp, pan);
	sig;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var n = 16;
	freq = exprand(50.0,11000!n);
	lfo1 = {EnvGen.kr(Env([0.01,2,0.3,0.01],[0.01,0.1,10.8]+rrand(0.01,0.1)), 1)}.dup(n);
	//lfo1 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0))*0.1+1;}.dup(n);
	lfo2 = {EnvGen.kr(Env([1.01,0.2,0.3,1.01],[0.01,0.1,10.8]+rrand(0.01,0.1)), 1)}.dup(n);
	//lfo2 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo3 = {XLine.kr(exprand(1.0,15000),exprand(1.0,15000), rrand(10,100.0));}.dup(n);
	lfo4 = exprand(50.0,11000!n);
	lfo5 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	sig = LFSaw.ar(freq * ( SinOsc.ar(lfo1 * lfo4) * 1 + lfo2 ));
	sig = DelayL.ar(sig, 0.2, lfo2 *0.2)+sig;
	sig = DelayL.ar(sig, 0.2, lfo5 *0.2)+sig;
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect(_.ar(sig, lfo3, 1));
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig[i], lfo3[i], 1)});
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, 1)});
	sig = [{[RLPF,RHPF,BPF].choose}.dup(16), sig, lfo3].flop.collect({ arg u, i; u[0].ar(u[1], u[2], 1)});
	sig = Splay.ar(sig, 1, amp, pan);
	sig;
}).play;
);



/////////////////

(
SynthDef(\wosh, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([4000,320,19100],[1.4,0.98]), 1);
	env2 = EnvGen.kr(Env([0.1,1.2,0.2],[0.1,0.1]), 1);
	sig = WhiteNoise.ar(1);
	sig = BPF.ar(sig, env1, env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\rooo, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var n = 16;
	freq = exprand(50.0,11000!n);
	lfo1 = {EnvGen.kr(Env([0.01,1,0.01],[0.11,4.8]), 1)}.dup(n);
	//lfo1 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0))*0.1+1;}.dup(n);
	lfo2 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo3 = {XLine.kr(exprand(1.0,15000),exprand(1.0,15000), rrand(10,100.0));}.dup(n);
	lfo4 = exprand(50.0,11000!n);
	lfo5 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	sig = LFSaw.ar(freq * ( SinOsc.ar(lfo1 * lfo4) * 1 + lfo2 ));
	sig = DelayL.ar(sig, 0.2, lfo2 *0.2)+sig;
	sig = DelayL.ar(sig, 0.2, lfo5 *0.2)+sig;
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect(_.ar(sig, lfo3, 1));
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig[i], lfo3[i], 1)});
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, 1)});
	sig = [{[RLPF,RHPF,BPF].choose}.dup(16), sig, lfo3].flop.collect({ arg u, i; u[0].ar(u[1], u[2], 1)});
	sig = Splay.ar(sig, 1, amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 0.5;
	Out.ar(out, sig);
}).add;
);

~t = 135/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \wosh,
			\freq, 200,
			\legato, 1,
			\dur, Pn(1,1),
			\amp, 0.1,
		),
		Psched(0.91,Pbind(
			\instrument, \rooo,
			\freq, 200,
			\dur, Pn(6,1),
			\amp, 0.1,
		)),
		
		
	])
)).play;
);

(
SynthDef(\zebre, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = (LFSaw.ar(freq * [1,3/4,4/5])*[1,0.01,0.01]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		{
			
		Pbind(
			\instrument, \zebre,
			//\freq, Pseq(exprand(100,15000!16)),
			\degree, Pseq(rrand(0,4!16)*3,inf),
			\root, Pseg(Pseq([
				0,6,2,4,
			],inf),2),
			\dur, Pseq(rrand(0.1,1!6),inf),
			\lag, rrand(0.1,1),
			\amp, 0.1,
		)
		}.dup(15)
		
	].flat)
)).play;
);
