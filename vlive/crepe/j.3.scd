(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	//freq = freq + SinOsc.kr({ Rand(100.1,2) }!16,0,0.5*freq);
	//sig = Gendy4.ar(1000);
	sig = DC.ar(0);
	//sig = DynKlank.ar(Ref([[100,200,300] * LFNoise1.ar([1,8,20]).range(1,2),[0.1,0.1,0.1], [1,0.12,0.3]]), sig);
	//sig = DynKlank.ar(Ref([{ Rand(100,5100) } ! 16,0.1!16, 0.1!16]), sig);
	sig = sig * 0.1+ Fb ({ arg fb;
		var fsig = fb * 0.99 + sig;
		var fsig1;
		fsig = Pulse.ar(1000, fb.range(0,1));
		fsig = Klank.ar(Ref([[7100,5020,6900]]), fsig);
		//fsig = fsig.clip(-0.1,0.1);
		
	
	});
	sig = RHPF.ar(sig, 100);
	sig = sig * 1/38;
	//sig = CombL.ar(sig, 0.1,0.002,1) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Pdef(~name +++ \pre, Pbind(
	\freq, 1000,
	\dur, 4,
	\legato, 1.0,
	\isRest, Pseq([1,0],inf).coin.not.stutter(1),
));
