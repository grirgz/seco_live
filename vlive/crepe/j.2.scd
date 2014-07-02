(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	//freq = freq + SinOsc.kr({ Rand(100.1,2) }!16,0,0.5*freq);
	sig = LFSaw.ar(freq * ({ Rand(0.1,2) }!16));
	sig = Gendy4.ar;
	sig = LFSaw.ar(sig.range(0,1) * 1000 * Array.series(8,1,0.01));
	sig = Impulse.ar(4);
	sig = sig * Crackle.ar(1.2);
	//sig = XLine.ar(1,10000,8);
	sig = Sweep.ar(1, 40000);
	sig = sig & (sig >> 1) | (sig >> 1);
	sig = sig * 0.03;
	sig = sig + ClipNoise.ar(1);
	sig = LFSaw.ar(1000* Array.series(8,1,0.1));
	//sig = DynKlank.ar(Ref([[100,200,300] * LFNoise1.ar([1,8,20]).range(1,2),[0.1,0.1,0.1], [1,0.12,0.3]]), sig);
	//sig = DynKlank.ar(Ref([{ Rand(100,5100) } ! 16,0.1!16, 0.1!16]), sig);
	sig = sig * 0.1+ Fb ({ arg fb;
		var fsig = fb * 0.99 + sig;
		var fsig1;
		//fsig = RHPF.ar(fsig, 100);
		fsig1 = fsig;
		fsig = DynKlank.ar(Ref([{ Rand(100,15100) } ! 16,0.1!16, 1.1!16]), fsig);
		//fsig = fsig1 & fsig;
		//fsig = Limiter.ar(fsig, 0.8,0.01);
		fsig = fsig.clip(-0.1,0.1);
		fsig;
	
	});
	sig = RHPF.ar(sig, 100);
	sig = sig * 3;
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
