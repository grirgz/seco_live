play{a=LFPar;VarSaw.ar(a.ar(1,0,5,a.ar([0.05,0.04],0,50,160).round(50)),0,a.ar(0.2,0,0.5,a.ar(3,0,0.2,0.5)))/8}//#SuperCollider


(

 Ndef(~name+++\fx, {
       var freq = { (84*(0+[1/4,2/4,3/4,1,5/4,6/4])).choose.postln.midicps.clip(50,2000) * LFNoise2.kr(1,0.01,1) }!24;
       var gen = LFSaw.ar(freq) * 0.1;
       var fmod = LFCub.kr(1/12 * [1,1.02,3]).range(1, MouseX.kr(2,16)); // modulate filter with mouse
       var rqmod = LFNoise2.kr(1/8).range(0.1,1.0);
       var snd = RLPF.ar(gen, freq * fmod, rqmod);
	   //snd = snd * 0.00000000000000000000000001;
       Splay.ar(snd)
 }).play;

)
(

 Ndef(~name+++\fx, {
       var freq = { (62*[5/4,1/2,3/4,5/7,6/9]).choose.midicps * LFNoise2.kr(1,0.01,1) }!24;
       var gen = LFSaw.ar(freq) * 0.1;
       var fmod = LFCub.kr(1/12 * [1,1.02,3]).range(1, MouseX.kr(2,16)); // modulate filter with mouse
       var rqmod = LFNoise2.kr(1/8).range(0.1,1.0);
       var snd = RLPF.ar(gen, freq * fmod, rqmod);
       Splay.ar(snd)
 }).play;

)
 Ndef(~name+++\fx).quant= Pdef.defaultQuant;
 Ndef(~name+++\fx).fadeTime= 4.5;



play{g=GrayNoise.ar;t=Dust.ar(0.3);e={|a,b,c|EnvGen.ar(Env.perc(a,b),c)};e.(0,1e-3,Dust.ar(e.(0.5,1,t)*50))*g/5+LPF.ar(g*7,99,e.(0,0.5,t))!2}


{f=Integrator.kr(DC.kr(2e-3),1-(Dust.kr(0.3)>0)); FreeVerb.ar((f<1.003)*((f>1)*9+1)*SinOsc.ar(f.linexp(0,10,6e3,3e3))).dup/5}.play


p={|x,a,f|9.do{x=BAllPass.ar(x*a,f).tanh};x};play{p.(Dust.ar(XLine.kr(1e4,0.01,5)*XLine.kr(0.001,1,0.8)),1.2,50)/2+p.(Impulse.ar(0),2,40)!2}

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(XLine.ar(
		150*Array.series(8,1,-0.4),
		100*Array.geom(8,1,0.94),
		1*Array.geom(8,1,0.04),
	));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(

Pdef(~name, Pbind(
	\instrument, ~name,
	\amp, 1/2,
	\freq, 1,
	
)).play
)

(
Ndef(~name, { arg amp=0.1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig1 = LFTri.ar([1,30,400]).abs;
	sig = LFSaw.ar(SinOsc.ar(
		1*Array.geom(8,1,5.1) * sig1,
	).range(
		150*Array.series(8,1,-0.4) / (sig1 + 1),
		sig1*1000*Array.geom(8,1,0.94),
	));
	//sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = sig + DelayC.ar(sig, 0.01,0.01 * [0,0.1]);
	sig = RLPF.ar(sig, 800 * Array.series(8,1,1.2) * sig1, 0.2);
	pan = pan * LFNoise1.kr(3);
	spread = spread * LFNoise1.kr(3);
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
);
Ndef(~name).clear
Ndef(~name).fadeTime=4.3;

