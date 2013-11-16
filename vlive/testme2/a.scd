~name = \a;

(
SynthDef(\boom, { arg out=0, gate=1, freq=200, pan=0, amp=0.1, doneAction=2;
	var sig, sig1, sig2, sig3, sig4;
	var env1, env2, env3, env4;
	var freqenv, freqenv2;
	freqenv = EnvGen.kr(Env([0,1,1,0.5],[0.001,0.41,0.4]), gate, timeScale:1);
	freqenv2 = EnvGen.kr(Env([0.5,1,1,0.5],[0.1,0.41,0.4]), gate, timeScale:1);
	sig1 = SinOsc.ar(LFNoise0.ar(freqenv2*800).range(10,freqenv*300));
	env1 = EnvGen.kr(Env([0,1,1,0],[0.001,0.41,0.4],-5), gate, timeScale:1);
	sig1 = sig1 * env1;

	//sig2 = BrownNoise.ar(1);
	sig2 = SinOsc.ar(LFNoise0.ar(880).range(10,0500));
	//sig2 = LPF.ar(sig2, 500);
	sig2 = sig2.tanh;
	env2 = EnvGen.kr(Env([0,0,1,1,0.5,0],[0.1,0.1,0.01,1.21,2.0], [0,0,0,5,-5]), gate, timeScale:1);
	sig2 = sig2 * env2 * 0.9;

	sig3 = SinOsc.ar(SinOsc.kr(1000).range(10,970));
	sig3 =  sig3 * EnvGen.ar(Env.perc(0.0001,0.01),gate,doneAction:0);

	sig4 = WhiteNoise.ar(1);
	//sig4 = SinOsc.ar(LFNoise0.ar(880).range(10,0500));
	sig4 = LPF.ar(sig4, 4500);
	//sig4 = sig2.tanh;
	//env4 = EnvGen.kr(Env([0,0,1,1,0.5,0],[0.6001,0.1,0.01,1.21,2.0], [0,0,0,5,-5]), gate, timeScale:1);
	env4 = EnvGen.kr(Env([0,0,1,1,0.5,0],[0.0001,0.1,0.01,1.21,2.0], [0,0,0,5,-5]), gate, timeScale:1);
	sig4 = sig4 * env4 * 0.1;

	sig =  sig1;
	sig = sig3;
	sig = sig1 + sig2 + sig3;
	sig = sig1 + sig2;
	sig = sig4;
	sig = sig1 + sig2 + sig3 + sig4;
	DetectSilence.ar(sig, doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);	
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \boom,
	\degree, Pseq([0],inf),
	\dur, Pn(8,1),
	\amp, 0.7
)).play;
);




(
SynthDef(\boom, { arg out=0, gate=1, freq=200, pan=0, amp=0.1, doneAction=2;
	var sig, sig1, sig2, sig3, sig4;
	var env1, env2, env3, env4;
	var freqenv, freqenv2;
	freqenv = EnvGen.kr(Env([0,1,1,0.5],[0.001,0.41,0.4]), gate, timeScale:1);
	freqenv2 = EnvGen.kr(Env([0.5,1,1,0.5],[0.1,0.41,0.4]), gate, timeScale:1);
	sig1 = SinOsc.ar(LFNoise0.ar(freqenv2*800).range(10,freqenv*300));
	env1 = EnvGen.kr(Env([0,1,1,0],[0.001,0.41,0.4],-5), gate, timeScale:1);
	sig1 = sig1 * env1;

	sig2 = SinOsc.ar(LFNoise0.ar(880).range(10,0500));
	sig2 = sig2.tanh;
	env2 = EnvGen.kr(Env([0,0,1,1,0.5,0],[0.1,0.1,0.01,1.21,2.0], [0,0,0,5,-5]), gate, timeScale:1);
	sig2 = sig2 * env2 * 0.9;

	sig3 = SinOsc.ar(SinOsc.kr(1000).range(10,970));
	sig3 =  sig3 * EnvGen.ar(Env.perc(0.0001,0.01),gate,doneAction:0);

	sig = sig1 + sig2 + sig3;
	DetectSilence.ar(sig, doneAction:doneAction);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);	
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \boom,
	\degree, Pseq([0],inf),
	\dur, Pn(8,1),
	\amp, 0.7
)).play;
);



explosion
//1.
play{p=Pulse;GVerb.ar(IFFT(PV_BrickWall(FFT(Buffer.alloc(s,128),WhiteNoise.ar*p.ar(8,5e-4)+SinOsc.ar(9*p.ar(1),0,n=p.kr(p.ar(5)))),n)))}//w8
//2.
play{a=SinOsc;p=Pulse;WhiteNoise.ar*p.kr(8,0.01)+a.ar(98*n=p.ar(4),0,p.kr(2,add:1))+GVerb.ar(a.ar(99*n)+p.ar(p.kr(3*n)),1,mul:0.1)}// #sc140
//3.
play{p=Pulse;WhiteNoise.ar*p.ar(8,h=3e-3)+GVerb.ar(GrainSin.ar(2,p.ar(8),n=h*t=LFNoise0.ar,1/n),2)+PMOsc.ar(9*p.ar(4*t),111,p.kr(6,t,1,1))}
//4.
play{GVerb.ar(IFFT(PV_BrickWall(FFT(Buffer.alloc(s,1024),WhiteNoise.ar*Pulse.ar(8,2e-2)),SinOsc.ar(Duty.kr(1,0,Dseq((10..19),inf))))))}
//5.
play{a=SinOsc;p=Pulse;GVerb.ar(WhiteNoise.ar*p.ar(TChoose.kr(a.kr(2),[5,8,20,30]))*p.ar(16,0.1))+a.ar(97*p.ar(4),0,p.kr(5,add:1))}// #sc140
//6.
ProxySpace.push;~a0.play;~a1.play;fork{loop{2.do{|i|currentEnvironment[(\a++i).asSymbol]={GVerb.ar(LFTri.ar(99+9.rand2),1,i)/2};0.2.wait}}}
Ndef(\a0).play;Ndef(\a1).play;fork{loop{2.do{|i|Ndef((\a++i).asSymbol,{GVerb.ar(LFTri.ar(99+9.rand2),1,i)/2});0.2.wait}}}


SCDoc.renderAll

(

{ var m = Line.kr(0.01, 0.8, Rand(0.01, 0.04)); SinOsc.ar(LFDNoise3.ar(m.range(18000, 2) ! 2) * (Rand(1, 2) * 600)) * m.exprange(1, 8) * XLine.kr(0.3, 0.0001, 5, doneAction:2)  }.play;
Pbind(
	\instrument, \boom,
	\degree, Pseq([0],inf),
	\dur, Pn(8,1),
	\amp, 0.7
).play
)


(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2;
	mod1 = XLine.kr(1,100,10);
	mod2 = XLine.kr(8000,1,10);
	mod2 = XLine.kr(40,5000,10);
	sig = SinOsc.ar(LFNoise1.kr([1,2,3,4,5,6] * mod1).range(50,mod2));
	sig = sig.sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

ProxySpace.pop
